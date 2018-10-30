//===============================================================================
//
//	Salt Business Service Layer
//
//===============================================================================

using System;
using System.Data;
using System.Data.SqlTypes;
using System.Data.SqlClient;
using Bdw.Application.Salt.Data;
using System.Configuration;
using System.Web;
using Localization;
using Microsoft.ApplicationBlocks.Data;
namespace Bdw.Application.Salt.BusinessServices
{
	/// <summary>
	/// This class handles all of the application configuration settings
	/// retrieval and updating.
	/// </summary>
	public class AppConfig
	{
		/// <summary>
		/// Get a list of application configuration
		/// </summary>
		/// <returns></returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public DataTable GetList()
		{
			using(StoredProcedure sp = new StoredProcedure("prcAppConfig_GetList"))
			{
				return sp.ExecuteTable();
			}
		} // GetList

        /// <summary>
        /// Get the Version of the application
        /// </summary>
        /// <returns></returns>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen Kennedy-Clark, 10/02/2004
        /// Changes:
        /// </remarks>
        public string GetVersion()
        {
            using(StoredProcedure sp = new StoredProcedure("prcVersion_Get"))
            {
                return Convert.ToString(sp.ExecuteScalar());
            }
        } // GetVersion

		/// <summary>
		/// Updates configuration details.
		/// </summary>
		/// <param name="name">This is the unique key, and read-only</param>
		/// <param name="value">The value of the setting</param>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public void Update(string name, string value)
		{
			using(StoredProcedure sp = new StoredProcedure("prcAppConfig_Update",
					  StoredProcedure.CreateInputParam("@name", SqlDbType.NVarChar, 50, name),
					  StoredProcedure.CreateInputParam("@value", SqlDbType.NVarChar, 4000, value)
					  ))
			{
				SqlDataReader rdr = sp.ExecuteReader();
				int intErrorNumber; // Holds the error number return from the stored procedure.
				string strErrorMessage; // Holds the error message return from the stored procedure.

				//1. Get the response.
				rdr.Read();
				intErrorNumber = rdr.GetInt32(0);
				strErrorMessage =  rdr.GetString(1);
				
				//2. Close the reader.
				rdr.Close();
				
				//4. Throw the required exception if error number is not 0.
				switch(intErrorNumber)
				{
					case 0: // Succeeded.
					{
						break;
					}
					case 1:
					{
						throw new RecordNotFoundException(ResourceManager.GetString("prcAppConfig_Update.1"));
					}
					case 4: // Unique constraint.
					{
						throw new UniqueViolationException(strErrorMessage);
					}
					case 5: // Parameter Exception.
					{
						throw new ParameterException(strErrorMessage);
					}
					default: // Whatever is left.
					{
						throw new BusinessServiceException(strErrorMessage);
					}
				}
			}
		}// Update

        public DataTable getMailServices()
        {
            using (StoredProcedure sp = new StoredProcedure("prcAppConfig_GetMailServices"))
            {
                return sp.ExecuteTable();
            }
 
        }

        public string getConfigValue(string strName)
        {

            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
            SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@name", strName) };

            string strSQL = "select value from tblAppConfig where name=@name";
            return SqlHelper.ExecuteScalar(connectionString, CommandType.Text, strSQL, sqlParams).ToString();
        }
	}
}
