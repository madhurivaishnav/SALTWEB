using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using Microsoft.ApplicationBlocks.Data;

using Bdw.Application.Salt.App_Code.Entity;


namespace Bdw.Application.Salt.App_Code.Data
{
	/// <summary>
	/// Summary description for LangDB.
	/// </summary>
	public class LangValueDB
	{
		//-- Sql Select List and object mapping
		private static string SqlSelectList()
		{
			return "tblLangValue.LangValueID, tblLangValue.LangID, tblLangValue.LangInterfaceID, tblLangValue.LangResourceID, tblLangValue.LangEntryValue, tblLangValue.Active, " + _BaseDB.SqlSelectList("tblLangValue");
		}

		private static LangValue LoadMapping(DataRow dr)
		{
			LangValue langValue = new LangValue();
			langValue.RecordID =		(int)dr["LangValueID"];
			langValue.langID =			(int)dr["LangID"];
			langValue.langInterfaceID =	(int)dr["LangInterfaceID"];
			langValue.langResourceID =	(int)dr["LangResourceID"];
			langValue.LangEntryValue =	(string)dr["LangEntryValue"];
			langValue.Active =			(bool)dr["Active"];

			_BaseDB.LoadMapping(langValue, dr);

			return langValue;
		}

	
		
		//-- Save
		public static void Save(LangValue langValue)
		{
			SqlConnection sqlConn = new SqlConnection(_BaseDB.ConnectionString());
			sqlConn.Open();
			SqlTransaction sqlTrans = sqlConn.BeginTransaction();
			
			try
			{
				if (langValue.LangID == 0 || langValue.LangInterfaceID == 0 || langValue.LangResourceID == 0)
					throw new ApplicationException("Language, Interface and Resource are required fields");

				Save(sqlTrans, langValue);
				sqlTrans.Commit();
			}
			catch (Exception ex)
			{
				sqlTrans.Rollback();
				throw ex;
			}
			finally
			{
				sqlConn.Close();
			}
		}

		private static void Save(SqlTransaction sqlTrans, LangValue langValue)
		{
			//-- Record locked?
			_BaseDB.RecordLocked(sqlTrans, langValue);

			//-- For Date:Created,Modified,Deleted
			DateTime eventDate = DateTime.Now.ToUniversalTime();
			Guid newRecordLock = Guid.NewGuid();

			//-- Params and Sql statements
			//			SqlParameter sqlLangEntryValue = new SqlParameter("@LangEntryValue", SqlDbType.NText);
			//			sqlLangEntryValue.Value = langValue.LangEntryValue;

			SqlParameter[] sqlParams = {
										   new SqlParameter("@LangValueID", langValue.RecordID)
										   , new SqlParameter("@LangID", langValue.LangID)
										   , new SqlParameter("@LangInterfaceID", langValue.LangInterfaceID)
										   , new SqlParameter("@LangResourceID", langValue.LangResourceID)
										   , new SqlParameter("@LangEntryValue", langValue.LangEntryValue)
										   , new SqlParameter("@Active", langValue.Active)
										   , new SqlParameter("@_EventUser", langValue.UserID)
										   , new SqlParameter("@_EventDate", eventDate)
										   , new SqlParameter("@_NewRecordLock", newRecordLock)
									   };


			string sqlInsert = @"INSERT INTO tblLangValue (LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
									VALUES(@LangID, @LangInterfaceID, @LangResourceID, @LangEntryValue, @Active, @_EventUser, @_EventDate, @_NewRecordLock);
									SELECT @@IDENTITY AS [@@IDENTITY]
								";


			string sqlUpdate = @"UPDATE tblLangValue set 
												LangID = @LangID
												, LangInterfaceID = @LangInterfaceID
												, LangResourceID = @LangResourceID
												, LangEntryValue = @LangEntryValue
												, Active = @Active
												, UserModified = @_EventUser
												, DateModified = @_EventDate
												, RecordLock = @_NewRecordLock
								WHERE LangValueID = @LangValueID
								";


			//-- Execute SQL and set object properties
			if (langValue.RecordID == 0)
			{
				langValue.RecordID = Int32.Parse(SqlHelper.ExecuteDataset(sqlTrans, CommandType.Text, sqlInsert, sqlParams).Tables[0].Rows[0][0].ToString());
				langValue.userCreated = langValue.UserID;
				langValue.dateCreated = eventDate;
			}
			else
			{
				SqlHelper.ExecuteNonQuery(sqlTrans, CommandType.Text, sqlUpdate, sqlParams);
				langValue.userModified = langValue.UserID;
				langValue.dateModified = eventDate;
			}

			langValue.RecordLock = newRecordLock;

		}


		private static void Archive(SqlTransaction sqlTrans, LangValue langValue)
		{
			SqlParameter[] sqlParams = new SqlParameter[] { 
															  new SqlParameter("@LangID", langValue.LangID), 
															  new SqlParameter("@LangInterfaceID", langValue.LangInterfaceID), 
															  new SqlParameter("@LangResourceID", langValue.LangResourceID), 
															  new SqlParameter("@LangEntryValue", langValue.LangEntryValue), 
															  new SqlParameter("@UserCreated", langValue.UserID)
														  };
			string sqlInsert = @"INSERT INTO tblLangValueArchive(LangID, LangInterfaceID, LangResourceID, LangEntryValue, UserCreated) VALUES(@LangID, @LangInterfaceID, @LangResourceID, @LangEntryValue, @UserCreated)";

			SqlHelper.ExecuteNonQuery(sqlTrans, CommandType.Text, sqlInsert, sqlParams);
		}
		

		private static void Delete(SqlTransaction sqlTrans, LangValue langValue)
		{
			SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@LangValueID", langValue.RecordID) };
			
			string sqlDelete = @"DELETE FROM tblLangValue WHERE LangValueID = @LangValueID";
			
			SqlHelper.ExecuteNonQuery(sqlTrans, CommandType.Text, sqlDelete, sqlParams);
		}

		public static void Commit(LangValue langValueActive, LangValue langValueUnCommitted)
		{
			SqlConnection sqlConn = new SqlConnection(_BaseDB.ConnectionString());
			sqlConn.Open();
			SqlTransaction sqlTrans = sqlConn.BeginTransaction();
			try
			{
				// move the active version to the archive
				Archive(sqlTrans, langValueActive);
				Delete(sqlTrans, langValueActive);

				// mark and save the uncommited version as active.
				langValueUnCommitted.Active = true;
				Save(sqlTrans, langValueUnCommitted);
				sqlTrans.Commit();
			}
			catch (Exception ex)
			{
				langValueUnCommitted.Active = false;
				sqlTrans.Rollback();

				throw ex;
			}
			finally
			{
				sqlConn.Close();
			}
		}

		//-- Load
		
		public static LangValue Load(int langValueID)
		{
			//-- Select, Params, Execute SQL
			string connectionString = _BaseDB.ConnectionString();
			
			SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@LangValueID", langValueID) };
			
			string sqlSelect = "SELECT " + SqlSelectList() + " FROM tblLangValue WHERE LangValueID = @langValueID";
			
			DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlSelect, sqlParams).Tables[0];

			//-- Lang Object
			LangValue langValue = new LangValue();
			if (dt.Rows.Count > 0)
				langValue = LoadMapping(dt.Rows[0]);

			return langValue;
		}

		public static LangValue Load(int langID, int langInterfaceID, int langResourceID, bool active)
		{
			//-- Select, Params, Execute SQL
			string connectionString = _BaseDB.ConnectionString();
			
			SqlParameter[] sqlParams = new SqlParameter[] { 
															new SqlParameter("@LangID", langID), 
															new SqlParameter("@LangInterfaceID", langInterfaceID), 
															new SqlParameter("@LangResourceID", langResourceID), 
															new SqlParameter("@Active", active)
														  };
			
			string sqlSelect = @"SELECT " + SqlSelectList() + @" FROM tblLangValue 
									WHERE LangID = @LangID 
									AND LangInterfaceID = @LangInterfaceID
									AND LangResourceID = @LangResourceID
									AND Active = @Active
								";
			
			DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlSelect, sqlParams).Tables[0];

			//-- Lang Object
			LangValue langValue = new LangValue();
			if (dt.Rows.Count > 0)
				langValue = LoadMapping(dt.Rows[0]);

			return langValue;
		}
			
		//-- Load list of active or inactive langValues
		public static ArrayList LoadList(int langID, int langInterfaceID, bool active)
		{
			//-- Select, Params, Execute SQL
			string connectionString = _BaseDB.ConnectionString();

			SqlParameter[] sqlParams = new SqlParameter[] { 
															  new SqlParameter("@LangID", langID), 
															  new SqlParameter("@LangInterfaceID", langInterfaceID), 
															  new SqlParameter("@active", active)
														  };

			string sqlSelectList = @"SELECT " + SqlSelectList() + @" FROM tblLangValue 
										WHERE LangID = @LangID
									";

			if (langInterfaceID > 0) { sqlSelectList += @" AND LangInterfaceID = @LangInterfaceID"; }
			sqlSelectList+= " AND Active = @Active ";


			DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlSelectList, sqlParams).Tables[0];


			//-- Load Array List
			ArrayList list = new ArrayList();
			foreach (DataRow dr in dt.Rows)
			{
				LangValue langValue = LoadMapping(dr);
				list.Add(langValue);
				
			}
			return list;
		}
		public static ArrayList LoadFlagList(bool active)
		{
			//-- Select, Params, Execute SQL
			string connectionString = _BaseDB.ConnectionString();

			SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@active", active) };

			string sqlSelectList = @"SELECT tblLang.LangCode, " + SqlSelectList() + @" 
										FROM         tblLangInterface INNER JOIN
															tblLangValue ON tblLangInterface.LangInterfaceID = tblLangValue.LangInterfaceID INNER JOIN
															tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID INNER JOIN
															tblLang ON tblLangResource.LangResourceName = tblLang.LangCode AND tblLangValue.LangID = tblLang.LangID
										WHERE     (tblLangInterface.LangInterfaceName = 'LanguageNames')
									";

			if (active)
			{
				sqlSelectList += " AND (tblLangValue.Active = 1)";
				sqlSelectList += " AND (tblLang.ShowUser = 1)";
			}
			else
				sqlSelectList += " AND (tblLang.ShowAdmin = 1)";

			sqlSelectList += " ORDER BY tblLangValue.Active, tblLang.LangName";

			DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlSelectList, sqlParams).Tables[0];


			//-- Load Array List
			ArrayList list = new ArrayList();
			foreach (DataRow dr in dt.Rows)
			{
				LangValue langValue = LoadMapping(dr);
				langValue.LangCode = dr["LangCode"].ToString();
				list.Add(langValue);
				
			}
			return list;
		}
	}
}
