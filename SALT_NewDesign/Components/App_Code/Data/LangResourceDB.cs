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
	public class LangResourceDB
	{
		//-- Sql Select List and object mapping
		private static string SqlSelectList()
		{
			return "LangResourceID, LangResourceName, ResourceType, Comment, " + _BaseDB.SqlSelectList("tblLangResource");
		}

		private static LangResource LoadMapping(DataRow dr)
		{
			LangResource langResource = new LangResource();
			langResource.RecordID =		(int)dr["LangResourceID"];
			langResource.RecordName =		(string)dr["LangResourceName"];
			langResource.ResourceType =	(string)dr["ResourceType"];
			langResource.Comment =	(string)dr["Comment"];

			_BaseDB.LoadMapping(langResource, dr);

			return langResource;
		}

	
		
		//-- Save
		public static void Save(LangResource langResource)
		{
			SqlConnection sqlConn = new SqlConnection(_BaseDB.ConnectionString());
			sqlConn.Open();
			SqlTransaction sqlTrans = sqlConn.BeginTransaction();
			
			try
			{
				Save(sqlTrans, langResource);
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

		private static void Save(SqlTransaction sqlTrans, LangResource langResource)
		{
			//-- Record locked?
			_BaseDB.RecordLocked(sqlTrans, langResource);


			//-- For Date:Created,Modified,Deleted
			DateTime eventDate = DateTime.Now.ToUniversalTime();
			Guid newRecordLock = Guid.NewGuid();

			//-- Params and Sql statements
			SqlParameter[] sqlParams = {
										new SqlParameter("@LangResourceID", langResource.RecordID)
										, new SqlParameter("@LangResourceName", langResource.RecordName)
										, new SqlParameter("@ResourceType", langResource.ResourceType)
										, new SqlParameter("@Comment", langResource.Comment)
										, new SqlParameter("@_EventUser", langResource.UserID)
										, new SqlParameter("@_EventDate", eventDate)
										, new SqlParameter("@_NewRecordLock", newRecordLock)
									   };


			string sqlInsert = @"INSERT INTO tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, DateCreated, RecordLock)
									VALUES(@LangResourceName, @ResourceType, @Comment, @_EventUser, @_EventDate, @_NewRecordLock);
									SELECT @@IDENTITY AS [@@IDENTITY]
								";


			string sqlUpdate = @"UPDATE tblLangResource set 
												LangResourceName = @LangResourceName
												, ResourceType = @ResourceType
												, Comment = @Comment
												, UserModified = @_EventUser
												, DateModified = @_EventDate
												, RecordLock = @_NewRecordLock
								WHERE LangResourceID = @LangResourceID
								";


			//-- Execute SQL and set object properties
			if (langResource.RecordID == 0)
			{
				langResource.RecordID = Int32.Parse(SqlHelper.ExecuteDataset(sqlTrans, CommandType.Text, sqlInsert, sqlParams).Tables[0].Rows[0][0].ToString());
				langResource.userCreated = langResource.UserID;
				langResource.dateCreated = eventDate;
			}
			else
			{
				SqlHelper.ExecuteNonQuery(sqlTrans, CommandType.Text, sqlUpdate, sqlParams);
				langResource.userModified = langResource.UserID;
				langResource.dateModified = eventDate;
			}

			langResource.RecordLock = newRecordLock;

		}


		
		//-- Load
		public static LangResource Load(int langResourceID)
		{
			SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@LangResourceID", langResourceID) };
			string sqlSelect = "SELECT " + SqlSelectList() + " FROM tblLangResource WHERE LangResourceID = @langResourceID";

			return Load(sqlSelect, sqlParams);
		}

		public static LangResource Load(string langResourceName)
		{
			SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@LangResourceName", langResourceName) };
			string sqlSelect = "SELECT " + SqlSelectList() + " FROM tblLangResource WHERE LangResourceName = @LangResourceName";

			return Load(sqlSelect, sqlParams);
		}

		private static LangResource Load(string sqlSelect, SqlParameter[] sqlParams)
		{
			//-- Select, Params, Execute SQL
			string connectionString = _BaseDB.ConnectionString();
			DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlSelect, sqlParams).Tables[0];

			//-- Lang Object
			LangResource langResource = new LangResource();
			if (dt.Rows.Count > 0)
				langResource = LoadMapping(dt.Rows[0]);

			return langResource;
		}

		public static ArrayList LoadList()
		{
			//-- Select, Params, Execute SQL
			string connectionString = _BaseDB.ConnectionString();
			string sqlSelectList = "SELECT " + SqlSelectList() + " FROM tblLangResource ORDER BY LangResourceName";

			DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlSelectList).Tables[0];


			//-- Load Array List
			ArrayList list = new ArrayList();
			foreach (DataRow dr in dt.Rows)
			{
				LangResource langResource = LoadMapping(dr);
				list.Add(langResource);
				
			}
			return list;
		}

		public static DataTable LoadList(int langID, int langInterfaceID)
		{
			//-- Select, Params, Execute SQL
			string connectionString = _BaseDB.ConnectionString();

			SqlParameter[] sqlParams = {
										   new SqlParameter("@langID", langID)
										   , new SqlParameter("@LangInterfaceID", langInterfaceID)
									   };

			string sqlSelectList = @"SELECT tblLangResource.LangResourceID, tblLangResource.LangResourceName, tblLangResource.ResourceType, tblLangResource.Comment, 
										tblLangValue.LangEntryValue AS EnglishValue
										FROM tblLangValue INNER JOIN
											tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID
										WHERE(tblLangValue.LangID = @langID) AND (tblLangValue.LangInterfaceID = @LangInterfaceID) AND (tblLangValue.Active = 1)
										ORDER BY tblLangResource.LangResourceName
									";

			DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlSelectList, sqlParams).Tables[0];

			return dt;
		}


	}
}
