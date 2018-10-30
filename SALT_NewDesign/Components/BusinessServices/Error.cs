using System;
using System.Data;
using Bdw.Application.Salt.Data;

namespace Bdw.Application.Salt.BusinessServices
{
	/// <summary>
	/// This class logs an error to the database via the stored procedure.
	/// It is called by the ErrorHandler.ErrorLog class but is required to 
	/// to be in the business services layer due to COM+ restraints.
	/// </summary>
	/// <remarks>
	/// Assumptions: None
	/// Notes: 
	/// Author: Peter Kneale 03/03/04
	/// Changes:
	/// </remarks>
	public class Error : DatabaseService  
	{
		#region Public Methods
		/// <summary>
		/// This method is essentially just saves an error to the database.
		/// </summary>
		/// <remarks>
		/// Assumptions:None
		/// Notes:
		/// Author: Peter Kneale, 05/02/2004
		/// Changes:
		/// </remarks>
		/// <param name="Source">Source Of Error</param>
		/// <param name="Module">Module error occured in.</param>
		/// <param name="Function">Function error occured in.</param>
		/// <param name="Code">Code error occured in.</param>
		/// <param name="Message">Error Message</param>
		/// <param name="StackTrace">Stack Trace from when error occured.</param>
		/// <param name="enuErrorLevel">Severity of the Error.</param>
		public void SaveToDbService (string Source, string Module, string Function, string Code, string Message, string StackTrace, ErrorLevel enuErrorLevel)
		{
			using (StoredProcedure sp = new StoredProcedure(
					   "prcErrorLog_Create",
					   StoredProcedure.CreateInputParam("@strSource", SqlDbType.VarChar, 1000, Source),
					   StoredProcedure.CreateInputParam("@strModule", SqlDbType.VarChar, 100, Module),
					   StoredProcedure.CreateInputParam("@strFunction", SqlDbType.VarChar, 100, Function),
					   StoredProcedure.CreateInputParam("@strCode", SqlDbType.VarChar, 100, Code),
					   StoredProcedure.CreateInputParam("@strMessage", SqlDbType.VarChar, 500, Message),
					   StoredProcedure.CreateInputParam("@strStackTrace", SqlDbType.VarChar, 8000, StackTrace),
					   StoredProcedure.CreateInputParam("@intErrorLevel", SqlDbType.Int, enuErrorLevel)
					   ))
			{
				sp.ExecuteNonQuery();
			}
		} // SaveToDbService

        /// <summary>
        /// Update a log entry
        /// </summary>
        /// <param name="errorLogID">Log ID</param>
        /// <param name="errorLevel">Error Level</param>
        /// <param name="errorStatus">Error Status</param>
        /// <param name="resolution">Resolution comments</param>
        public void Update (int errorLogID, int errorLevel, int errorStatus, string resolution)
        {
            using (StoredProcedure sp = new StoredProcedure(
                       "prcErrorLog_Update",
                       StoredProcedure.CreateInputParam("@ErrorLogID", SqlDbType.Int, errorLogID),
                       StoredProcedure.CreateInputParam("@ErrorLevel", SqlDbType.Int, errorLevel),
                       StoredProcedure.CreateInputParam("@ErrorStatus", SqlDbType.Int, errorStatus),
                       StoredProcedure.CreateInputParam("@Resolution", SqlDbType.VarChar, 1000, resolution)
                       ))
            {
                sp.ExecuteNonQuery();
            }
        }
        /// <summary>
        /// List all error levels
        /// </summary>
        /// <returns>Datatable of Error Levels</returns>
        public static DataTable ErrorLevelList()
        {
            using (StoredProcedure sp = new StoredProcedure("prcErrorLog_ErrorLevelList"))
            {
                return(sp.ExecuteTable());
            }
        }
        /// <summary>
        /// List all error statuses
        /// </summary>
        /// <returns>Datatable of error status's</returns>
        public static DataTable ErrorStatusList()
        {
            using (StoredProcedure sp = new StoredProcedure("prcErrorLog_ErrorStatusList"))
            {
                return(sp.ExecuteTable());
            }
        }
		/// <summary>
		/// Gets the datatable containing the report of the latest errors. This report
		/// shows the most recently occuring errors.
		/// </summary>
		/// <remarks>
		/// Assumptions:None
		/// Notes:
		/// Author: Peter Kneale, 05/02/2004
		/// Changes:
		/// </remarks>
		/// <returns>DataTable: Contains an error listing of the most recent errors</returns>
        public DataTable GetReport(int organisationID)
		{
			using (StoredProcedure sp = new StoredProcedure("prcErrorLog_GetReport",
                   StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, 8000, organisationID)))
			{
				return(sp.ExecuteTable ());
			}
		} // GetReportService
        /// <summary>
        /// Gets the error
        /// </summary>
        /// <remarks>
        /// Assumptions:None
        /// Notes:
        /// Author: Peter Kneale, 05/02/2004
        /// Changes:
        /// </remarks>
        /// <returns>DataTable: Contains an error</returns>
        public DataTable GetError(int id, int organisationID)
        {
            using (StoredProcedure sp = new StoredProcedure("prcErrorLog_GetOne",
                       StoredProcedure.CreateInputParam("@ErrorLogID", SqlDbType.Int, id),
                       StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, 8000, organisationID)
					   ))
            {
                return(sp.ExecuteTable ());
            }
        } // GetErrorService
		#endregion

	}
}
