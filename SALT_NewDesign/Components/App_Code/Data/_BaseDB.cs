using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using Microsoft.ApplicationBlocks.Data;
using Bdw.Application.Salt.App_Code.Entity;

namespace Bdw.Application.Salt.App_Code.Data
{
	/// <summary>
	/// Summary description for _BaseDB.
	/// </summary>
	internal class _BaseDB
	{
		internal static string ConnectionString()
		{
			Bdw.Application.Salt.Data.SecurityHandler objSecurityHandler = new Bdw.Application.Salt.Data.SecurityHandler();
			string strEncPassword = ConfigurationSettings.AppSettings["ConnectionStringPassword"];
			string strDecPassword = objSecurityHandler.Decrypt(strEncPassword);
			return ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + strDecPassword + ";";
		}

		internal static string SqlSelectList(string tableName)
		{
			return tableName + ".UserCreated, " + tableName + ".UserModified, " + tableName + ".UserDeleted, " + tableName + ".DateCreated, " + tableName + ".DateModified, " + tableName + ".DateDeleted, " + tableName + ".RecordLock";
		}

		internal static void LoadMapping(_BaseEntity baseObject, DataRow dr)
		{
			if (dr["UserCreated"] != System.DBNull.Value) { baseObject.userCreated =	(int)dr["UserCreated"]; }
			if (dr["UserModified"] != System.DBNull.Value) { baseObject.userModified = (int)dr["UserModified"]; }
			if (dr["UserDeleted"] != System.DBNull.Value) { baseObject.userDeleted =	(int)dr["UserDeleted"]; }

			if (dr["DateCreated"] != System.DBNull.Value) { baseObject.dateCreated = (DateTime)dr["DateCreated"]; }
			if (dr["DateModified"] != System.DBNull.Value) { baseObject.dateModified = (DateTime)dr["DateModified"]; }
			if (dr["DateDeleted"] != System.DBNull.Value) { baseObject.dateDeleted = (DateTime)dr["DateDeleted"]; }
			baseObject.RecordLock = new Guid(dr["RecordLock"].ToString());

		}

		internal static bool RecordLocked(SqlTransaction sqlTrans, _BaseEntity entity)
		{
			//-- Get the object type class name
			string entityType = entity.GetType().ToString();
			entityType = entityType.Substring(entityType.LastIndexOf(".") + 1, entityType.Length - entityType.LastIndexOf(".") - 1);


			//-- Table and id field variables
			string tableName = "tbl" + entityType;
			string idFieldName = entityType + "ID";
			

			//-- Does the recordLock guid match?
			bool recordLocked = false;
			if (entity.RecordID > 0)
			{
				SqlParameter[] selectParams = { 
												new SqlParameter("@ID", entity.RecordID), 
												new SqlParameter("@RecordLock", entity.RecordLock.ToString()) 
												};

				string sqlSelect = @"SELECT 1 from " + tableName + " WHERE " + idFieldName + " = @ID AND RecordLock = @RecordLock";
				
				object result = SqlHelper.ExecuteScalar(sqlTrans, CommandType.Text, sqlSelect, selectParams);
				if (result == null)
					recordLocked = true;
			}


			//-- Exception
			if (recordLocked)
				throw new ApplicationException("The record you are trying to save is Locked. Please try again.");

			return recordLocked;
		}
	}
}
