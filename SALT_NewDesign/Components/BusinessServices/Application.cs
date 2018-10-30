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

namespace Bdw.Application.Salt.BusinessServices
{
	/// <summary>
	/// This class handles application specific functions
	/// </summary>
	public class Application: Bdw.Application.Salt.Data.DatabaseService
	{
		#region Public Methods

		/// <summary>
		/// Gets SQL Server version
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public string GetDatabaseVersion()
		{
			using (StoredProcedure sp = new StoredProcedure("prcVersion_Get")
					)
			{
				return (string)sp.ExecuteScalar();
			}
		} // GetDatabaseVersion

        /// <summary>
        /// Gets time the Module Status Update job was last run
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Gavin Buddis, 24/03/2004
        /// Changes:
        /// #1 19/4/04 Returns DateTime.Minvalue if it has never been run before
        /// </remarks>
        public DateTime GetDateModuleStatusUpdateLastRun(int organisationID)
        {
            string strDateTime;
			// Update User Quiz Status table
			using (StoredProcedure sp = new StoredProcedure("prcModuleStatusUpdateHistory_GetLastRun",
                   StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, 8000, organisationID)))
			{
                strDateTime = sp.ExecuteScalar().ToString();
                if (strDateTime.Length==0)
                {
                    return(DateTime.MinValue);
                }
                else
                {
                    return (DateTime.Parse(strDateTime));
                }
				
			}

        }

        /// <summary>
        /// Gets time the Module Status Update job was last run
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Gavin Buddis, 24/03/2004
        /// Changes:
        /// #1 19/4/04 Returns DateTime.Minvalue if it has never been run before
        /// </remarks>
        public String GetSqlAgentRunningStatus()
        {

            using (StoredProcedure sp = new StoredProcedure("prcSqlAgentRunningStatus_Get"))
            {
                return (string) sp.ExecuteScalar();
            }

        }

        
        /// <summary>
        /// Simulates the running of the Module Status Update job by calling 2 stored procedures
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Gavin Buddis, 24/03/2004
        /// Changes:
        /// </remarks>
        public void RunModuleStatusUpdate(int orgID)
        {
            // Update User Quiz Status table
			using (StoredProcedure sp = new StoredProcedure("prcUserQuizStatus_Update_Quick",
					   StoredProcedure.CreateInputParam("@orgID", SqlDbType.Int, orgID)))
            {
                sp.ExecuteNonQuery();
            }

            // Update User Lesson Status table
			using (StoredProcedure sp = new StoredProcedure("prcUserLessonStatus_Update_Quick",
					   StoredProcedure.CreateInputParam("@orgID", SqlDbType.Int, orgID)))
            {
                sp.ExecuteNonQuery();
            }
        }
		#endregion
	}
}