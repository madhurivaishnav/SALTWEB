//===============================================================================
//
//	Salt Business Service Layer
//
//	Bdw.Application.Salt.Data.Report
//
//  Retrieves and updates course information
//
//===============================================================================
using System;
using System.Data;
using System.Data.SqlTypes;
using Bdw.Application.Salt.Data;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;

namespace Bdw.Application.Salt.BusinessServices
{
    /// <summary>
    /// Retrieves Report information.
    /// </summary>
	public class Report
	{
        #region Public Methods
        /// <summary>
        /// Gets the details for the individual Report
        /// </summary>
        /// <returns>Returns a DataTable with the details of all Modules in all courses a user has access to</returns>
        /// <remarks>
        /// Assumptions: That the table tblUserQuizStatus contains the latest valid results
        /// Notes: 
        /// Author: Stephen K-Clark, 16/02/04
        /// Changes:
        /// </remarks>
        /// <returns>
        /// DataTable containg the report
        /// </returns>
        /// <param name="userID">User ID</param>
        public DataTable GetIndividualReport(int userID)
        {
			Profile objProfile = new Profile();
			DataTable dt = objProfile.GetIndividualReportData (userID);
			return dt;
			

        } //GetIndividualReport

		/// <summary>
		/// Gets the details for the Trend Report
		/// </summary>
		/// <returns>Returns a DataTable with the details of the average score and number of users for a selected course and unit/s</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Kneale 18/02/2004
		/// Changes:
		/// </remarks>
		/// <param name="organisationID">organisation to return units from if no unit was selected</param>
		/// <param name="unitIDs">Comma seperated list of unit ID's</param>
		/// <param name="courseID">A single course ID.</param>
		/// 
		/// <returns></returns>
		public DataTable GetTrendReport(int organisationID, string unitIDs, int courseID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcReport_Trend",                   
                      StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID),
                      StoredProcedure.CreateInputParam("@unitID", SqlDbType.VarChar,8000, unitIDs),
					  StoredProcedure.CreateInputParam("@courseID", SqlDbType.Int, courseID)
						  ))
			{
				return sp.ExecuteTable();
			}
		} //GetTrendReport

		/// <summary>
		/// Gets the details for the Summary Report
		/// </summary>
		/// <returns>Returns a DataTable/DataSet with summary data relating to the users and courses.</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Kneale 3/02/2004
		/// Changes:
		/// </remarks>
		/// <param name="organisationID"></param>
		/// <param name="unitIDs">Comma seperated list of unit id's</param>
		/// <param name="courseIDs">Comma seperated list of course id's</param>
		/// <param name="userFirstName">The entered users first name</param>
		/// <param name="userLastName">The entered users last name</param>
		/// <param name="effectiveDate">Nullable date at which the report is accurate</param>
		/// <param name="groupBy">Group by 'Course' or 'Unit/User'</param>
		/// <param name="sortBy">Sort by 'QuizScore' or 'QuizDate'</param>
		/// <param name="adminUserID">Administrator ID of the logged in user.</param>
		/// <param name="classificationID">Classification ID or zero for any</param>
		/// <param name="IncludeInactiveUsers">Include Inactive Users</param>
		/// <returns>DataTable containing admin summary results</returns>
		public DataTable GetAdminSummaryReport(int organisationID, string unitIDs, string courseIDs, string userFirstName, string userLastName, string userName, string userEmail, string effectiveDate, string groupBy, string sortBy, int adminUserID,int classificationID,int inclInactive)
		{
			if (effectiveDate != null)
			{
				DateTime dtEffectiveDate = DateTime.Parse (effectiveDate);
				using(StoredProcedure sp = new StoredProcedure("prcReport_AdminSummaryReport",
						  StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID),
						  StoredProcedure.CreateInputParam("@unitIDs", SqlDbType.VarChar,-1, unitIDs),
						  StoredProcedure.CreateInputParam("@courseIDs", SqlDbType.VarChar,8000, courseIDs),
						  StoredProcedure.CreateInputParam("@UserFirstName", SqlDbType.NVarChar,50, userFirstName),
						  StoredProcedure.CreateInputParam("@UserLastName", SqlDbType.NVarChar,50, userLastName),
						  StoredProcedure.CreateInputParam("@userName", SqlDbType.NVarChar,100, userName),
						  StoredProcedure.CreateInputParam("@userEmail", SqlDbType.NVarChar,100, userEmail),
						  StoredProcedure.CreateInputParam("@effectiveDate", SqlDbType.DateTime, dtEffectiveDate),
						  StoredProcedure.CreateInputParam("@groupBy", SqlDbType.NVarChar,50, groupBy),
						  StoredProcedure.CreateInputParam("@sortBy", SqlDbType.NVarChar,50, sortBy),
						  StoredProcedure.CreateInputParam("@adminUserID", SqlDbType.Int, adminUserID),
						  StoredProcedure.CreateInputParam("@classificationID", SqlDbType.Int, classificationID),
						  StoredProcedure.CreateInputParam("@inclInactive",SqlDbType.Int, inclInactive)

						  ))
				{
					return sp.ExecuteTable();
				}
			}
			else
			{
				DateTime dt = new DateTime();
				dt = DateTime.Now;

				using(StoredProcedure sp = new StoredProcedure("prcReport_AdminSummaryReport",
						  StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID),
						  StoredProcedure.CreateInputParam("@unitIDs", SqlDbType.VarChar,-1, unitIDs),
						  StoredProcedure.CreateInputParam("@courseIDs", SqlDbType.VarChar,8000, courseIDs),
						  StoredProcedure.CreateInputParam("@UserFirstName", SqlDbType.NVarChar,50, userFirstName),
						  StoredProcedure.CreateInputParam("@UserLastName", SqlDbType.NVarChar,50, userLastName),
						  StoredProcedure.CreateInputParam("@userName", SqlDbType.NVarChar,100, userName),
						  StoredProcedure.CreateInputParam("@userEmail", SqlDbType.NVarChar,100, userEmail),
						  StoredProcedure.CreateInputParam("@effectiveDate", SqlDbType.DateTime, dt),
						  StoredProcedure.CreateInputParam("@groupBy", SqlDbType.NVarChar,50, groupBy),
						  StoredProcedure.CreateInputParam("@sortBy", SqlDbType.NVarChar,50, sortBy),
						  StoredProcedure.CreateInputParam("@adminUserID", SqlDbType.Int, adminUserID),
						  StoredProcedure.CreateInputParam("@classificationID", SqlDbType.Int, classificationID),
						  StoredProcedure.CreateInputParam("@inclInactive",SqlDbType.Int, inclInactive)
					))
				{
					return sp.ExecuteTable();
				}
			}
		
		} //GetAdminSummaryReport

        //historic date to default to yesterday based on the org time zone.

        public DataTable getYesterdayforOrgTZ(int orgID)
        {
            
            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			System.Data.SqlClient.SqlParameter[] sqlParams =	{
																	new SqlParameter("@OrganisationID", orgID)
																};

            string sqlSelect = "select dbo.udfUTCtoDaylightSavingTime(dateadd (dd, -1,GETUTCDATE()),organisationid) as Yesterday, tz.WrittenName "+
                               " from tblOrganisation o "+
                                " join tblTimeZone tz on tz.TimeZoneID= o.TimeZoneID "+
                                " where o.OrganisationID = @OrganisationID"; 
			return Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteDataset(connectionString, System.Data.CommandType.Text, sqlSelect, sqlParams).Tables[0];
        }

        public string getToday(int orgID)
        {

            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

            System.Data.SqlClient.SqlParameter[] sqlParams =	{
																	new SqlParameter("@OrganisationID", orgID)
																};

            string sqlSelect = "select dbo.[udfGetSaltOrgDate]("+orgID.ToString()+") as today ";
            return Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteDataset(connectionString, System.Data.CommandType.Text, sqlSelect, sqlParams).Tables[0].Rows[0]["today"].ToString();
            
        }		

		/// <summary>
		/// This report returns a table of users that have completed testing requrements or alternatly, thoes who have not.
		/// </summary>
        /// <remarks>
        /// Assumptions: If a user has access to a module then thay have to complete that module
        /// Notes: 
        /// Author: Stephen Kennedy-Clark 19/02/2004
        /// Changes:
        /// </remarks>
        /// <returns>
        /// DataTable containg the completed users report data
        /// </returns>
        /// <param name="organisationID">Organisation to search if no units were specified</param>
        /// <param name="unitIDs">Comma seperated list of unit id's</param>
        /// <param name="courseID">Integer Course ID</param>
        /// <param name="completed">Boolean - Show Completed (true) or incomplete (false) users</param>
        /// <param name="effectiveDate">Nullable date at which the report is accurate</param>
		public DataTable GetCompletedUsersReport(int organisationID, string unitIDs, int courseID, DateTime effectiveDate, bool completed)
		{ 
            if (effectiveDate != DateTime.MinValue)
            {
                using(StoredProcedure sp = new StoredProcedure("prcReport_CompletedUsers",
                          StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID),
                          StoredProcedure.CreateInputParam("@unitIDs", SqlDbType.VarChar,-1, unitIDs),
                          StoredProcedure.CreateInputParam("@courseID", SqlDbType.Int, courseID),
                          StoredProcedure.CreateInputParam("@effectiveDate", SqlDbType.DateTime, effectiveDate),
                          StoredProcedure.CreateInputParam("@completed", SqlDbType.Bit, completed)
                          ))																																													
                {
                    return sp.ExecuteTable();
                }
            }
            else
            {
                using(StoredProcedure sp = new StoredProcedure("prcReport_CompletedUsers",
                          StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID),
                          StoredProcedure.CreateInputParam("@unitIDs", SqlDbType.VarChar,-1, unitIDs),
                          StoredProcedure.CreateInputParam("@courseID", SqlDbType.Int, courseID),
                          StoredProcedure.CreateInputParam("@completed", SqlDbType.Bit, completed)
                          ))																																													
                {
                    return sp.ExecuteTable();
                }
            }
        } //GetCompletedUsersReport


		/// <summary>
		/// This method performs the search necessary to find the users based on the criteria supplied for by the email report.
		/// </summary>
		/// <param name="organisationID">Organisation to search if no units specified</param>
		/// <param name="unitIDs">Comma seperated list of unit ids.</param>
		/// <param name="courseID">The Course ID.</param>
		/// <param name="classificationID">The Classification ID or 0 for any classification</param>
		/// <param name="courseModuleStatus">The Course/Module Status.</param>
		/// <param name="quizDateFrom">From Date</param>
		/// <param name="quizDateTo">To Date</param>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Kneale 1/03/2004
		/// Changes:
		/// </remarks>
		/// <returns>DataTable of user details that match the supplied criteria</returns>
		public DataTable GetEmailReportUserSearch (int organisationID, string unitIDs, string courseIDs, int classificationID, int courseModuleStatus, DateTime quizDateFrom, DateTime quizDateTo, int inclInactive)
		{
			using(StoredProcedure sp = new StoredProcedure("prcReport_EmailReportUserSearch",
                      StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID),
                      StoredProcedure.CreateInputParam("@unitIDs", SqlDbType.VarChar,-1, unitIDs),
					  StoredProcedure.CreateInputParam("@courseIDs", SqlDbType.VarChar,8000, courseIDs),
					  StoredProcedure.CreateInputParam("@classificationID", SqlDbType.Int, classificationID),
					  StoredProcedure.CreateInputParam("@courseModuleStatus", SqlDbType.Int, courseModuleStatus),
					  StoredProcedure.CreateInputParam("@quizDateFromOrg", SqlDbType.DateTime, quizDateFrom),
					  StoredProcedure.CreateInputParam("@quizDateToOrg", SqlDbType.DateTime, quizDateTo),
					  StoredProcedure.CreateInputParam("@includeInactive",SqlDbType.Int, inclInactive)
					  ))																																													
			{
				return sp.ExecuteTable();
			}
		} //GetEmailReportUserSearch

		public DataTable GetEmailReportDistinctUsers (int organisationID, string unitIDs, string courseIDs, int classificationID, int courseModuleStatus, DateTime quizDateFrom, DateTime quizDateTo, int inclInactive)
		{
			using(StoredProcedure sp = new StoredProcedure("prcReport_EmailReportDistinctUsers",
					  StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID),
					  StoredProcedure.CreateInputParam("@unitIDs", SqlDbType.VarChar,-1, unitIDs),
					  StoredProcedure.CreateInputParam("@courseIDs", SqlDbType.VarChar,8000, courseIDs),
					  StoredProcedure.CreateInputParam("@classificationID", SqlDbType.Int, classificationID),
					  StoredProcedure.CreateInputParam("@courseModuleStatus", SqlDbType.Int, courseModuleStatus),
					  StoredProcedure.CreateInputParam("@quizDateFromOrg", SqlDbType.DateTime, quizDateFrom),
					  StoredProcedure.CreateInputParam("@quizDateToOrg", SqlDbType.DateTime, quizDateTo),
					  StoredProcedure.CreateInputParam("@includeInactive",SqlDbType.Int, inclInactive)
					  ))																																													
			{
				return sp.ExecuteTable();
			}
		} //GetEmailReportDistinctUsers

		/// <summary>
		/// This method returns a datatable of users and their email addresses based on an organisation 
		/// ID and a comma seperated list of user id's
		/// </summary>
		/// <param name="organisationID">A single Organisation ID</param>
		/// <param name="userIDs">A comma seperated list of user ID's</param>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Kneale 1/03/2004
		/// Changes:
		/// </remarks>
		/// <returns>DataTable containing user details and email addresses</returns>
		public DataTable GetEmailReportToAdministrators (int organisationID, string unitIDs, string courseIDs, int classificationID, int courseModuleStatus, DateTime quizDateFrom, DateTime quizDateTo, int inclInactive)
		{
			using(StoredProcedure sp = new StoredProcedure("prcReport_EmailReportToAdministrators",
					  StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID),
					  StoredProcedure.CreateInputParam("@unitIDs", SqlDbType.VarChar,-1, unitIDs),
					  StoredProcedure.CreateInputParam("@courseIDs", SqlDbType.VarChar,8000, courseIDs),
					  StoredProcedure.CreateInputParam("@classificationID", SqlDbType.Int, classificationID),
					  StoredProcedure.CreateInputParam("@courseModuleStatus", SqlDbType.Int, courseModuleStatus),
					  StoredProcedure.CreateInputParam("@quizDateFrom", SqlDbType.DateTime, quizDateFrom),
					  StoredProcedure.CreateInputParam("@quizDateTo", SqlDbType.DateTime, quizDateTo),
					  StoredProcedure.CreateInputParam("@includeInactive",SqlDbType.Int, inclInactive)
					  ))																																													
				  {
				return sp.ExecuteTable();
			}
		} //GetEmailReportToAdministrators

        public DataTable GetPeriodicFields(int scheduleId)
        {
            using (StoredProcedure sp = new StoredProcedure("prcGetPeriodicFields",
                StoredProcedure.CreateInputParam("@scheduleId", SqlDbType.Int, scheduleId)
                ))
            {
                return sp.ExecuteTable();
            }
        }

        public void SetPeriodicFields(int scheduleId, string reportTitle, string isPeriodic, DateTime reportStartDate, int reportFrequency, string reportFrequencyPeriod, Boolean endOn, DateTime reportEndDate, int numberOfReports, int reportPeriodType, DateTime reportFromDate)
        {
            if (endOn)
            {
                using (StoredProcedure sp = new StoredProcedure("prcSetPeriodicFields",
                    StoredProcedure.CreateInputParam("@ScheduleId", SqlDbType.Int, scheduleId),
                    StoredProcedure.CreateInputParam("@ReportTitle", SqlDbType.NVarChar, reportTitle),
                    StoredProcedure.CreateInputParam("@IsPeriodic", SqlDbType.Char, isPeriodic),
                    StoredProcedure.CreateInputParam("@ReportStartDate", SqlDbType.DateTime, reportStartDate),
                    StoredProcedure.CreateInputParam("@ReportFrequency", SqlDbType.Int, reportFrequency),
                    StoredProcedure.CreateInputParam("@ReportFrequencyPeriod", SqlDbType.Char, reportFrequencyPeriod),
                    StoredProcedure.CreateInputParam("@ReportEndDate", SqlDbType.DateTime, reportEndDate),
                    StoredProcedure.CreateInputParam("@NumberOfReports", SqlDbType.Int, numberOfReports),
                    StoredProcedure.CreateInputParam("@ReportPeriodType", SqlDbType.Int, reportPeriodType),
                    StoredProcedure.CreateInputParam("@ReportFromDate", SqlDbType.DateTime, reportFromDate)
                    ))
                {
                    sp.ExecuteNonQuery();
                }
            }
            else
            {
                using (StoredProcedure sp = new StoredProcedure("prcSetPeriodicFields",
                    StoredProcedure.CreateInputParam("@ScheduleId", SqlDbType.Int, scheduleId),
                    StoredProcedure.CreateInputParam("@ReportTitle", SqlDbType.NVarChar, reportTitle),
                    StoredProcedure.CreateInputParam("@IsPeriodic", SqlDbType.Char, isPeriodic),
                    StoredProcedure.CreateInputParam("@ReportStartDate", SqlDbType.DateTime, reportStartDate),
                    StoredProcedure.CreateInputParam("@ReportFrequency", SqlDbType.Int, reportFrequency),
                    StoredProcedure.CreateInputParam("@ReportFrequencyPeriod", SqlDbType.Char, reportFrequencyPeriod),
                    StoredProcedure.CreateInputParam("@ReportEndDate", SqlDbType.DateTime, DBNull.Value),
                    StoredProcedure.CreateInputParam("@NumberOfReports", SqlDbType.Int, numberOfReports),
                    StoredProcedure.CreateInputParam("@ReportPeriodType", SqlDbType.Int, reportPeriodType),
                    StoredProcedure.CreateInputParam("@ReportFromDate", SqlDbType.DateTime, reportFromDate)
                    ))
                {
                    sp.ExecuteNonQuery();
                }
            }

        }
        public DataTable GetCCList(int scheduleId)
        {
            using (StoredProcedure sp = new StoredProcedure("prcGetCCList",
                StoredProcedure.CreateInputParam("@ScheduleId", SqlDbType.Int, scheduleId)
                ))
            {
                return sp.ExecuteTable();
            }
        }

        public void ReassignReport(int scheduleId, int userId)
        {
            using (StoredProcedure sp = new StoredProcedure("prcReassignReport",
                StoredProcedure.CreateInputParam("@ScheduleId", SqlDbType.Int, scheduleId),
                StoredProcedure.CreateInputParam("@UserId", SqlDbType.Int, userId)
                ))
            {
                sp.ExecuteNonQuery();
            }
        }

        public void ReassignReportInactive(int scheduleId, int fromUser, int toUser)
        {
            using (StoredProcedure sp = new StoredProcedure("prcReport_ReassignReportInactive",
                StoredProcedure.CreateInputParam("@ScheduleId", SqlDbType.Int, scheduleId),
                StoredProcedure.CreateInputParam("@FromUser", SqlDbType.Int, fromUser),
                StoredProcedure.CreateInputParam("@ToUser", SqlDbType.Int, toUser)
                ))
            {
                sp.ExecuteNonQuery();
            }
        }

        public void DeleteReport(int scheduleId)
        {
            using (StoredProcedure sp = new StoredProcedure("prcDeleteReport",
                StoredProcedure.CreateInputParam("@ScheduleId", SqlDbType.Int, scheduleId)
                ))
            {
                sp.ExecuteNonQuery();
            }
        }

        public void DeleteReportInactive(int scheduleId, int userId)
        {
            using (StoredProcedure sp = new StoredProcedure("prcReport_DeleteReportInactive",
                StoredProcedure.CreateInputParam("@ScheduleId", SqlDbType.Int, scheduleId),
                StoredProcedure.CreateInputParam("@UserId", SqlDbType.Int, userId)
                ))
            {
                sp.ExecuteNonQuery();
            }
        }

        public Boolean RequiresEffectiveDate(int reportId)
        {
            using (StoredProcedure sp = new StoredProcedure("prcRequiresEffectiveDate",
                StoredProcedure.CreateInputParam("@ReportId", SqlDbType.Int, reportId)
                ))
            {
                return Convert.ToBoolean(sp.ExecuteScalar());
            }
        }

        public Boolean RequiresDateFromDateTo(int reportId)
        {
            using (StoredProcedure sp = new StoredProcedure("prcRequiresDateFromDateTo",
                StoredProcedure.CreateInputParam("@ReportId", SqlDbType.Int, reportId)
                ))
            {
                return Convert.ToBoolean(sp.ExecuteScalar());
            }
        }

        public string GetTypeFromScheduleId(int scheduleId)
        {
            using (StoredProcedure sp = new StoredProcedure("prcReport_GetTypeFromScheduleId",
                StoredProcedure.CreateInputParam("@ScheduleId", SqlDbType.Int, scheduleId)
                ))
            {
                return (sp.ExecuteScalar().ToString());
            }
        }

        public string GetTypeFromID(int reportId)
        {
            using (StoredProcedure sp = new StoredProcedure("prcReport_GetTypeFromID",
                StoredProcedure.CreateInputParam("@ReportId", SqlDbType.Int, reportId)
                ))
            {
                return (sp.ExecuteScalar().ToString());
            }
        }

        public void SaveCCUser(int userId, int scheduleId)
        {
            using (StoredProcedure sp = new StoredProcedure("prcReport_SaveCCUser",
                StoredProcedure.CreateInputParam("@UserId", SqlDbType.Int, userId),
                StoredProcedure.CreateInputParam("@ScheduleId", SqlDbType.Int, scheduleId)
                ))
            {
                sp.ExecuteNonQuery();
            }
        }

        #endregion
	}
}
