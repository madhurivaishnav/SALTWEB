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
	public class LangDB
	{
		//-- Sql Select List and object mapping
		private static string SqlSelectList()
		{
			return "LangID, LangName, LangCode, ShowAdmin, ShowUser, " + _BaseDB.SqlSelectList("tblLang");
		}

		private static Lang LoadMapping(DataRow dr)
		{
			Lang lang = new Lang();
			lang.RecordID =		(int)dr["LangID"];
			lang.RecordName =	(string)dr["LangName"];
			lang.LangCode =		(string)dr["LangCode"];
			lang.ShowAdmin =	(bool)dr["ShowAdmin"];
			lang.ShowUser =		(bool)dr["ShowUser"];

			_BaseDB.LoadMapping(lang, dr);

			return lang;
		}

	
		
		//-- Save
		public static void Save(Lang lang)
		{
			SqlConnection sqlConn = new SqlConnection(_BaseDB.ConnectionString());
			sqlConn.Open();
			SqlTransaction sqlTrans = sqlConn.BeginTransaction();
			
			try
			{
				Save(sqlTrans, lang);
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

		private static void Save(SqlTransaction sqlTrans, Lang lang)
		{
			//-- Record locked?
			_BaseDB.RecordLocked(sqlTrans, lang);


			//-- For Date:Created,Modified,Deleted
			DateTime eventDate = DateTime.Now.ToUniversalTime();
			Guid newRecordLock = Guid.NewGuid();

			//-- Params and Sql statements
			SqlParameter[] sqlParams = {
										new SqlParameter("@LangID", lang.RecordID)
										, new SqlParameter("@LangName", lang.RecordName)
										, new SqlParameter("@LangCode", lang.LangCode)
										, new SqlParameter("@ShowAdmin", lang.ShowAdmin)
										, new SqlParameter("@ShowUser", lang.ShowUser)
										, new SqlParameter("@_EventUser", lang.UserID)
										, new SqlParameter("@_EventDate", eventDate)
										, new SqlParameter("@_NewRecordLock", newRecordLock)
									   };


			string sqlInsert = @"INSERT INTO tblLang (LangName, LangCode, ShowAdmin, ShowUser, UserCreated, DateCreated, RecordLock)
									VALUES(@LangName, @LangCode, @ShowAdmin, @ShowUser, @_EventUser, @_EventDate, @_NewRecordLock);
									SELECT @@IDENTITY AS [@@IDENTITY]
								";


			string sqlUpdate = @"UPDATE tblLang set 
												LangName = @LangName
												, LangCode = @LangCode
												, ShowAdmin = @ShowAdmin
												, ShowUser = @ShowUser
												, UserModified = @_EventUser
												, DateModified = @_EventDate
												, RecordLock = @_NewRecordLock
								WHERE LangID = @LangID
								";


			//-- Execute SQL and set object properties
			if (lang.RecordID == 0)
			{
				lang.RecordID = Int32.Parse(SqlHelper.ExecuteDataset(sqlTrans, CommandType.Text, sqlInsert, sqlParams).Tables[0].Rows[0][0].ToString());
				lang.userCreated = lang.UserID;
				lang.dateCreated = eventDate;
			}
			else
			{
				SqlHelper.ExecuteNonQuery(sqlTrans, CommandType.Text, sqlUpdate, sqlParams);
				lang.userModified = lang.UserID;
				lang.dateModified = eventDate;
			}

			lang.RecordLock = newRecordLock;

		}


		
		//-- Load
		public static Lang Load(int langID)
		{
			//-- Select, Params, Execute SQL
			string connectionString = _BaseDB.ConnectionString();
			SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@LangID", langID) };
			string sqlSelect = "SELECT " + SqlSelectList() + " FROM tblLang WHERE LangID = @LangID";
			DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlSelect, sqlParams).Tables[0];

			//-- Lang Object
			Lang lang = new Lang();
			if (dt.Rows.Count > 0)
				lang = LoadMapping(dt.Rows[0]);

			return lang;
		}

		public static Lang Load(string langCode)
		{
			//-- Select, Params, Execute SQL
			string connectionString = _BaseDB.ConnectionString();
			SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@LangCode", langCode) };
			string sqlSelect = "SELECT " + SqlSelectList() + " FROM tblLang WHERE LangCode = @LangCode";
			DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlSelect, sqlParams).Tables[0];

			//-- Lang Object
			Lang lang = new Lang();
			if (dt.Rows.Count > 0)
				lang = LoadMapping(dt.Rows[0]);

			return lang;
		}


		public static ArrayList LoadAdminList(bool onlySelectAdminActive)
		{
			System.Diagnostics.Trace.WriteLine("LoadAdminList");
			//-- Select, Params, Execute SQL
			string connectionString = _BaseDB.ConnectionString();
			SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@ShowAdmin", onlySelectAdminActive) };
			string sqlSelectList = @"SELECT " + SqlSelectList() + @", 
									(SELECT count(*) from tblLangValue WHERE tblLangValue.LangID = tblLang.LangID and Active = 0) as CommittedCount
									FROM tblLang WHERE ShowAdmin = @ShowAdmin ORDER BY LangName";
			

			DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlSelectList, sqlParams).Tables[0];


			//-- Load Array List
			ArrayList list = new ArrayList();
			foreach (DataRow dr in dt.Rows)
			{
				Lang lang = LoadMapping(dr);
				lang.CommittedCount = (int)dr["CommittedCount"];
				list.Add(lang);
				
			}
			return list;
		}

		public static ArrayList LoadUserList()
		{
			//-- Select, Params, Execute SQL
			string connectionString = _BaseDB.ConnectionString();
			SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@ShowUser", true) };
			string sqlSelectList = "SELECT " + SqlSelectList() + " FROM tblLang WHERE ShowUser = @ShowUser ORDER BY LangName";

			DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlSelectList, sqlParams).Tables[0];

			//-- Load Array List
			ArrayList list = new ArrayList();
			foreach (DataRow dr in dt.Rows)
			{
				Lang lang = LoadMapping(dr);
				list.Add(lang);
			}
			return list;
		}
	}
}
