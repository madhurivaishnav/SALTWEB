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
	public class LangInterfaceDB
	{
		//-- Sql Select List and object mapping
		private static string SqlSelectList()
		{
			return "tblLangInterface.LangInterfaceID, tblLangInterface.LangInterfaceName, tblLangInterface.InterfaceType, " + _BaseDB.SqlSelectList("tblLangInterface");
		}

		private static LangInterface LoadMapping(DataRow dr)
		{
			LangInterface langInterface = new LangInterface();
			langInterface.RecordID =		(int)dr["LangInterfaceID"];
			langInterface.RecordName =		(string)dr["LangInterfaceName"];
			langInterface.InterfaceType =	(string)dr["InterfaceType"];

			_BaseDB.LoadMapping(langInterface, dr);

			return langInterface;
		}

	
		
		//-- Save
		public static void Save(LangInterface langInterface)
		{
			SqlConnection sqlConn = new SqlConnection(_BaseDB.ConnectionString());
			sqlConn.Open();
			SqlTransaction sqlTrans = sqlConn.BeginTransaction();
			
			try
			{
				Save(sqlTrans, langInterface);
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

		private static void Save(SqlTransaction sqlTrans, LangInterface langInterface)
		{
			//-- Record locked?
			_BaseDB.RecordLocked(sqlTrans, langInterface);


			//-- For Date:Created,Modified,Deleted
			DateTime eventDate = DateTime.Now.ToUniversalTime();
			Guid newRecordLock = Guid.NewGuid();

			//-- Params and Sql statements
			SqlParameter[] sqlParams = {
										new SqlParameter("@LangInterfaceID", langInterface.RecordID)
										, new SqlParameter("@LangInterfaceName", langInterface.RecordName)
										, new SqlParameter("@InterfaceType", langInterface.InterfaceType)
										, new SqlParameter("@_EventUser", langInterface.UserID)
										, new SqlParameter("@_EventDate", eventDate)
										, new SqlParameter("@_NewRecordLock", newRecordLock)
									   };


			string sqlInsert = @"INSERT INTO tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, DateCreated, RecordLock)
									VALUES(@LangInterfaceName, @InterfaceType, @_EventUser, @_EventDate, @_NewRecordLock);
									SELECT @@IDENTITY AS [@@IDENTITY]
								";


			string sqlUpdate = @"UPDATE tblLangInterface set 
												LangInterfaceName = @LangInterfaceName
												, InterfaceType = @InterfaceType
												, UserModified = @_EventUser
												, DateModified = @_EventDate
												, RecordLock = @_NewRecordLock
								WHERE LangInterfaceID = @LangInterfaceID
								";


			//-- Execute SQL and set object properties
			if (langInterface.RecordID == 0)
			{
				langInterface.RecordID = Int32.Parse(SqlHelper.ExecuteDataset(sqlTrans, CommandType.Text, sqlInsert, sqlParams).Tables[0].Rows[0][0].ToString());
				langInterface.userCreated = langInterface.UserID;
				langInterface.dateCreated = eventDate;
			}
			else
			{
				SqlHelper.ExecuteNonQuery(sqlTrans, CommandType.Text, sqlUpdate, sqlParams);
				langInterface.userModified = langInterface.UserID;
				langInterface.dateModified = eventDate;
			}

			langInterface.RecordLock = newRecordLock;

		}


		
		//-- Load
		public static LangInterface Load(int langInterfaceID)
		{
			SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@LangInterfaceID", langInterfaceID) };
			string sqlSelect = "SELECT " + SqlSelectList() + " FROM tblLangInterface WHERE LangInterfaceID = @langInterfaceID";

			return Load(sqlSelect, sqlParams);
		}

		public static LangInterface Load(string langInterfaceName)
		{
			SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@LangInterfaceName", langInterfaceName) };
			string sqlSelect = "SELECT " + SqlSelectList() + " FROM tblLangInterface WHERE LangInterfaceName = @LangInterfaceName";

			return Load(sqlSelect, sqlParams);
		}

		private static LangInterface Load(string sqlSelect, SqlParameter[] sqlParams)
		{
			//-- Select, Params, Execute SQL
			string connectionString = _BaseDB.ConnectionString();

			DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlSelect, sqlParams).Tables[0];

			//-- Lang Object
			LangInterface langInterface = new LangInterface();
			if (dt.Rows.Count > 0)
				langInterface = LoadMapping(dt.Rows[0]);

			return langInterface;
		}

		public static ArrayList LoadList(int langID)
		{
			//-- Select, Params, Execute SQL
			string connectionString = _BaseDB.ConnectionString();
			
			SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@LangID", langID) };

			string sqlSelectList = @"SELECT " + SqlSelectList() + @",  
                                    (
										SELECT     COUNT(*) AS Expr1
										FROM tblLangValue
										WHERE      (LangInterfaceID = tblLangInterface.LangInterfaceID) AND (Active = 0) AND (LangID = @LangID)
									) AS CommittedCount, tblLangValue_1.LangEntryValue AS PageTitle
									FROM tblLangInterface 
									LEFT OUTER JOIN tblLangValue AS tblLangValue_1 ON tblLangInterface.LangInterfaceID = tblLangValue_1.LangInterfaceID 
										AND tblLangValue_1.LangResourceID IN
										(
											SELECT LangResourceID  FROM tblLangResource WHERE (LangResourceName = 'pagTitle' OR LangResourceName = 'rptReportTitle')
										) AND tblLangValue_1.LangID = @LangID AND tblLangValue_1.Active = 1 
									ORDER BY tblLangInterface.InterfaceType, PageTitle";

			DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlSelectList, sqlParams).Tables[0];


			//-- Load Array List
			ArrayList list = new ArrayList();
			foreach (DataRow dr in dt.Rows)
			{
				LangInterface langInterface = LoadMapping(dr);
				langInterface.CommittedCount = (int)dr["CommittedCount"];
				langInterface.PageTitle = dr["PageTitle"].ToString();
				list.Add(langInterface);
				
			}
			return list;
		}
	}
}
