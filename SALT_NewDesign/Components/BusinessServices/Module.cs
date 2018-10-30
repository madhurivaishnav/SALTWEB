//===============================================================================
//
//	Salt Business Service Layer
//
//	Bdw.Application.Salt.Data.Module
//
//  Retrieves and updates course information
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
namespace Bdw.Application.Salt.BusinessServices
{
	/// <summary>
	/// Retrieves and updates course information.
	/// </summary>
	public class Module : Bdw.Application.Salt.Data.DatabaseService
	{	
		#region Public Methods

        /// <summary>
        /// Gets a list of Modules and their details for a given Course
        /// </summary>
        /// <returns>Returns a DataTable with Module details</returns>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Gavin Buddis, 11/02/04
        /// Changes: 
        /// </remarks>
        /// <param name="courseID">Parent Course ID of the module to get.</param>
        public DataTable GetModuleListByCourse(int courseID, int organisationID)
        {
            using(StoredProcedure sp = new StoredProcedure("prcModule_GetListByCourse",
                      StoredProcedure.CreateInputParam("@courseID", SqlDbType.Int, courseID),
                      StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, 8000, organisationID)
                      ))
            {
                return sp.ExecuteTable();
            }

        } // GetModuleListByCourse

        /// <summary>
		/// Gets a single Module's details.
		/// </summary>
		/// <returns>Returns a DataTable with the details of the specified Module.</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Gavin Buddis, 11/02/04
		/// Changes:
		/// </remarks>
		/// <param name="moduleID">Module ID to get the details of.</param>
        public DataTable GetModule(int moduleID, int organisationID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcModule_GetOne",
					  StoredProcedure.CreateInputParam("@ModuleID", SqlDbType.Int, moduleID),
                      StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, 8000, organisationID)
					  ))
			{
				return sp.ExecuteTable();
			}

		} // GetModule

        /// <summary>
        /// Create a new module.
        /// </summary>
        /// <returns>Module ID for the created module.</returns>
        /// <param name="courseID">Parent Course ID</param>
        /// <param name="name">name of the module</param>
        /// <param name="description">Description of the module</param>
        /// <param name="active">Active flag for the new module</param>
        /// <param name="createdByUserID">Currently logged on user creating the module</param>
        public int Create(int courseID, string name, string description, bool active, int createdByUserID)
        {
            using(StoredProcedure sp = new StoredProcedure("prcModule_Create",
                      StoredProcedure.CreateInputParam("@courseID", SqlDbType.Int, courseID),
                      StoredProcedure.CreateInputParam("@name", SqlDbType.NVarChar, 100, name),
                      StoredProcedure.CreateInputParam("@description", SqlDbType.NVarChar, 1000, description),
                      StoredProcedure.CreateInputParam("@active", SqlDbType.Bit, active),
                      StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, createdByUserID)
                      ))
            {
                SqlDataReader rdr = sp.ExecuteReader();
                int intError;
                string strMessage;
                rdr.Read();
                intError = rdr.GetInt32(0);
                strMessage = rdr.GetString(1);
                rdr.Close();
                if (intError==4)
                {
                    throw new BusinessServiceException(ResourceManager.GetString("prcModule_Create.4"));
                }
                else
                {
                    return int.Parse(strMessage);
                }
            }
        } // Create

        /// <summary>
        /// Updates a module details. If the status is changed, there will be validation checking.
        /// </summary>
        /// <param name="moduleID">Module ID whose details are being updated</param>
        /// <param name="name">Name for the updated module</param>
        /// <param name="description">Description for the updated module</param>
        /// <param name="active">Active flag for the updated module</param>
        /// <param name="updatedByUserID">Currently logged on user updating the module</param>
        public void Update(int moduleID, string name, string description, bool active, int updatedByUserID, 
							string worksiteID, string lWorkSiteID, string qfWorkSiteID)
        {
            using(StoredProcedure sp = new StoredProcedure("prcModule_Update",
                      StoredProcedure.CreateInputParam("@moduleID", SqlDbType.Int, moduleID),
                      StoredProcedure.CreateInputParam("@name", SqlDbType.NVarChar, 100, name),
                      StoredProcedure.CreateInputParam("@description", SqlDbType.NVarChar, 500, description),
                      StoredProcedure.CreateInputParam("@active", SqlDbType.Bit, active),
                      StoredProcedure.CreateInputParam("@updatedByUserID", SqlDbType.Int, updatedByUserID)
                      ))
            {
                SqlDataReader rdr = sp.ExecuteReader();
                int intError;
                string strMessage;
                rdr.Read();
                intError = rdr.GetInt32(0);
                strMessage = rdr.GetString(1);
                rdr.Close();

				if (intError==1)
				{
					throw new BusinessServiceException(ResourceManager.GetString("cmnRecordNotExist"));
				}

				if (intError==4)
				{
					throw new BusinessServiceException(ResourceManager.GetString("prcModule_Update.4"));
				}

				//-- Update quiz and lesson worksite IDs
				string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
				System.Data.SqlClient.SqlParameter[] quizParams = {
																	  new SqlParameter("@ModuleID", moduleID), 
																	  new SqlParameter("@WorksiteID", worksiteID)
																  };

				System.Data.SqlClient.SqlParameter[] lessonParams = {
																		new SqlParameter("@ModuleID", moduleID), 
																		new SqlParameter("@LWorkSiteID", lWorkSiteID),
																		new SqlParameter("@QFWorkSiteID", qfWorkSiteID)
																	};

				string sqlUpdateQuiz = "UPDATE tblQuiz set WorksiteID = @WorksiteID where ModuleID = @ModuleID and Active = 1";
				string sqlUpdateLesson = "UPDATE tblLesson set LWorkSiteID = @LWorkSiteID,  QFWorkSiteID = @QFWorkSiteID where ModuleID = @ModuleID and Active = 1";

				Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteNonQuery(connectionString, System.Data.CommandType.Text, sqlUpdateQuiz, quizParams);
				Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteNonQuery(connectionString, System.Data.CommandType.Text, sqlUpdateLesson, lessonParams);
            }

        } // Update

        /// <summary>
        /// Updates a module's sequence value only.
        /// </summary>
        /// <param name="moduleID">Module ID whose sequence value is being updated</param>
        /// <param name="sequence">New sequence value for the module</param>
        /// <param name="updatedByUserID">Currently logged on user updating the module</param>
        public void UpdateSequence(int moduleID, int sequence, int updatedByUserID)
        {
            using(StoredProcedure sp = new StoredProcedure("prcModule_UpdateSequence",
                      StoredProcedure.CreateInputParam("@moduleID", SqlDbType.Int, moduleID),
                      StoredProcedure.CreateInputParam("@sequence", SqlDbType.Int, sequence),
                      StoredProcedure.CreateInputParam("@updatedByUserID", SqlDbType.Int, updatedByUserID)
                      ))
            {
                SqlDataReader rdr = sp.ExecuteReader();
                int intError;
                string strMessage;
                rdr.Read();
                intError = rdr.GetInt32(0);
                strMessage = rdr.GetString(1);
                rdr.Close();
                if (intError==1)
                {
                    throw new BusinessServiceException(ResourceManager.GetString("cmnRecordNotExist"));
                }
            }

        } // UpdateSequence

        /// <summary>
        /// Retrieves the active lessons for a specified module
        /// </summary>
        /// <param name="moduleID">Module ID of the desired lessons</param>
        /// <returns>The properties for the active lessons</returns>
        public DataTable GetLesson(int moduleID, int organisationID)
        {
            using(StoredProcedure sp = new StoredProcedure("prcLesson_GetListByModule",
                      StoredProcedure.CreateInputParam("@ModuleID", SqlDbType.Int, moduleID),
                      StoredProcedure.CreateInputParam("@ActiveOnly", SqlDbType.Bit, true),
                      StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, 8000, organisationID)
                      ))
            {
                return sp.ExecuteTable();
            }

        } // GetLesson

        /// <summary>
        /// Retrieves the active quizzes for a specified module
        /// </summary>
        /// <param name="moduleID">Module ID of the desired quizs</param>
        /// <returns>The properties for the active quizzes</returns>
        public DataTable GetQuiz(int moduleID, int organisationID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcQuiz_GetListByModule",
					  StoredProcedure.CreateInputParam("@ModuleID", SqlDbType.Int, moduleID),
					  StoredProcedure.CreateInputParam("@ActiveOnly", SqlDbType.Bit, true),
                      StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, 8000, organisationID)
					  ))
			{
				return sp.ExecuteTable();
			}

		}

        public DataTable GetQuiz(int moduleID, bool activeOnly, int organisationID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcQuiz_GetListByModule",
					  StoredProcedure.CreateInputParam("@ModuleID", SqlDbType.Int, moduleID),
					  StoredProcedure.CreateInputParam("@ActiveOnly", SqlDbType.Bit, activeOnly),
                      StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, 8000, organisationID)
					  ))
			{
				return sp.ExecuteTable();
			}

		} // GetQuiz



		
        #endregion	

		#region "Reset Course Status"

		/// <summary> Allows the manual reset of user quiz status independant of whether new quiz content has been uploaded or not </summary>
		public static int ResetQuizStatus(int userListType, int orgID, int moduleID, bool preview)
		{
			// Get the ID of the latest quiz
			int latestQuizID = GetLatestQuizLessonID(moduleID, "Quiz");

			// Get user list
			DataTable dtUsers = GetUserList(latestQuizID, moduleID, orgID, userListType, "Quiz");
			int usersAffectedCount = 0;
			
			BusinessServices.Module objModule = new Module();
            DataTable dtModule = objModule.GetModule(moduleID, orgID);

			bool moduleIsActive = (bool)dtModule.Rows[0]["Active"];

			foreach (DataRow dr in dtUsers.Rows)
			{
				int userID = (int)dr["UserID"];

				System.Data.SqlClient.SqlParameter[] sqlParams = { new SqlParameter("@UserID", userID), new SqlParameter("@ModuleID", moduleID) };
			
				bool userIsCurrentlyAssignedModule = UserAssignedModule(userID, moduleID);
                bool userHasQuizActivity = UserHasQuizActivity(userID, moduleID);

				if (moduleIsActive)
				{
					
					int userLessonStatusID = GetLessonStatus(moduleID, userID);
					if (userHasQuizActivity)
					{
                        if (userIsCurrentlyAssignedModule)
                        {
                            int userQuizStatusID = GetQuizStatus(moduleID, userID);
                            if (userQuizStatusID != (int)QuizStatus.Unassigned && userQuizStatusID != (int)QuizStatus.NotStarted)
                            {
                                if (!preview)
                                {
                                    InsertQuizStatus(userID, moduleID, QuizStatus.ExpiredNewContent);
                                    UpdateCourseStatus(userID, moduleID);
                                    InsertExpiry(userID, moduleID, orgID);
                                }
                                usersAffectedCount++;
                            }
                        }

                        if (!preview)
                        {  // do the following for all users with any quiz activity...
                            UpdateUserQuizStatusDateLastReset(userID, moduleID);
                        }
					}
				}
			}


            

			return usersAffectedCount;
		}

		/// <summary> Allows the manual reset of user lesson status independant of whether new lesson content has been uploaded or not </summary>
		public static int ResetLessonStatus(int userListType, int orgID, int moduleID, bool preview)
		{
			User objUser = new User();

			BusinessServices.Module objModule = new Module();
            DataTable dtModule = objModule.GetModule(moduleID, orgID);

			bool moduleIsActive = (bool)dtModule.Rows[0]["Active"];

			// Get the ID of the latest quiz
			int latestLessonID = GetLatestQuizLessonID(moduleID, "Lesson");

			// Get user list
			DataTable dtUsers = GetUserList(latestLessonID, moduleID, orgID, userListType, "Lesson");
			
			int affectedCount = 0;
			foreach (DataRow dr in dtUsers.Rows)
			{
				int userID = (int)dr["UserID"];

				bool userIsAssignedModule = UserAssignedModule(userID, moduleID); 

				if (userIsAssignedModule && moduleIsActive)
				{
					// do not add expired content status for users where their last status is not "not started" or Unassigned
					int userLessonStatusID = GetLessonStatus(moduleID, userID);
					if (userLessonStatusID != (int)LessonStatus.Unassigned && userLessonStatusID != (int)LessonStatus.NotStarted)
					{
						if (!preview)
						{
							InsertLessonStatus(userID, moduleID, LessonStatus.ExpiredNewContent);
						}
						affectedCount++;
					}
				}
			}

			return affectedCount;
		}

		public static int GetLessonStatus(int moduleID, int userID)
		{
			string sqlSelect = "SELECT TOP 1 LessonStatusID FROM tblUserLessonStatus WHERE UserID = @UserID and ModuleID = @ModuleID ORDER BY UserLessonStatusID DESC";
			System.Data.SqlClient.SqlParameter[] sqlParams = { new SqlParameter("@UserID", userID), new SqlParameter("@ModuleID", moduleID) };
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			
			int id = 0;
			object result = Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteScalar(connectionString, System.Data.CommandType.Text, sqlSelect, sqlParams);
			if (result != null)
				id = Int32.Parse(result.ToString());

			return id;

		}

		private static int GetQuizStatus(int moduleID, int userID)
		{
			string sqlSelect = "SELECT TOP 1 QuizStatusID FROM tblUserQuizStatus WHERE UserID = @UserID and ModuleID = @ModuleID ORDER BY UserQuizStatusID DESC";
			System.Data.SqlClient.SqlParameter[] sqlParams = { new SqlParameter("@UserID", userID), new SqlParameter("@ModuleID", moduleID) };
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			
			int id = 0;
			object result = Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteScalar(connectionString, System.Data.CommandType.Text, sqlSelect, sqlParams);
			if (result != null)
				id = Int32.Parse(result.ToString());

			return id;

		}
        private static void InsertExpiry(int userID, int moduleID, int organisationID)
        {
            using (StoredProcedure sp = new StoredProcedure("prcUserQuizStatus_InsertExpiry",
                        StoredProcedure.CreateInputParam("@ModuleID", SqlDbType.Int, moduleID),
                        StoredProcedure.CreateInputParam("@UserID", SqlDbType.Int, userID),
                        StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, organisationID)
                        ))
            {
                sp.ExecuteNonQuery();
            }
        }

		private static void UpdateCourseStatus(int userID, int moduleID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUserQuizStatus_UpdateCourseStatus",
						StoredProcedure.CreateInputParam("@ModuleID", SqlDbType.Int, moduleID),
						StoredProcedure.CreateInputParam("@UserID", SqlDbType.Int, userID)
						))
			{
				sp.ExecuteNonQuery();
			}
		}
		/// <summary> get the id for the latest quiz </summary>
		private static int GetLatestQuizLessonID(int moduleID, string quizLesson)
		{
			string sqlSelect = "SELECT TOP 1 " + quizLesson + @"ID FROM tbl" + quizLesson + @" where ModuleID = @ModuleID order by " + quizLesson + @"ID Desc";
			System.Data.SqlClient.SqlParameter[] sqlParams = { new SqlParameter("@ModuleID", moduleID) };

			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			int id = Int32.Parse(Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteScalar(connectionString, System.Data.CommandType.Text, sqlSelect, sqlParams).ToString());

			return id;
		}


        private static void UpdateUserQuizStatusDateLastReset(int userID, int moduleID)
        {
            string sqlUpdateQuiz = @" UPDATE tblUserQuizStatus set DateLastReset = dbo.getDateUTC()) where UserID = @userID and ModuleID = @ModuleID ";

            System.Data.SqlClient.SqlParameter[] sqlParams = { 
                                                                new SqlParameter("@userID", userID), 
															    new SqlParameter("@ModuleID", moduleID)
                                                             };

            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
            Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteNonQuery(connectionString, System.Data.CommandType.Text, sqlUpdateQuiz, sqlParams);
        }


		/// <summary> Insert a user status into the UserQuizStatus table </summary>
		private static void InsertQuizStatus(int userID, int moduleID, QuizStatus quizStatus)
		{

			string sqlInsertQuiz = @"
									if (SELECT TOP 1 QuizStatusID FROM tblUserQuizStatus WHERE UserID = @UserID AND ModuleID = @ModuleID ORDER BY UserQuizStatusID DESC) <> 5
									BEGIN
										INSERT into tblUserQuizStatus (UserID, ModuleID, QuizStatusID)
										VALUES(@UserID, @ModuleID, @QuizStatusID)
									END
									";

			System.Data.SqlClient.SqlParameter[] sqlParams =	{
																	new SqlParameter("@userID", userID), 
																	new SqlParameter("@ModuleID", moduleID), 
																	new SqlParameter("@quizStatusID", (int)Enum.Parse(typeof(QuizStatus), quizStatus.ToString()))
																};

			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteNonQuery(connectionString, System.Data.CommandType.Text, sqlInsertQuiz, sqlParams);
		}


		/// <summary> Insert a user status into the UserQuizStatus table </summary>
		public static void InsertLessonStatus(int userID, int moduleID, LessonStatus lessonStatus)
		{

			string sqlInsertLesson = @"
									INSERT into tblUserLessonStatus (UserID, ModuleID, LessonStatusID)
									VALUES(@UserID, @ModuleID, @LessonStatusID)
									";

			System.Data.SqlClient.SqlParameter[] sqlParams =	{
																	new SqlParameter("@userID", userID), 
																	new SqlParameter("@ModuleID", moduleID), 
																	new SqlParameter("@LessonStatusID", (int)Enum.Parse(typeof(LessonStatus), lessonStatus.ToString()))
																};

			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteNonQuery(connectionString, System.Data.CommandType.Text, sqlInsertLesson, sqlParams);
		}
		
		
		/// <summary> Get users across all user which have access to a module or all users where their organisation has access to the module</summary>
		private static DataTable GetUserList(int latestID, int moduleID, int orgID, int userListType, string quizLesson)
		{
			System.Data.SqlClient.SqlParameter[] sqlParams = { 
																 new SqlParameter("@" + quizLesson, latestID),  
																 new SqlParameter("@ModuleID", moduleID),  
																 new SqlParameter("@OrganisationID", orgID) 
															 };

			string sqlSelect = string.Empty;

			if (userListType == 1)	// All Users who have started the quiz
			{
				sqlSelect = @"SELECT DISTINCT tblUser" + quizLesson + @"Status.UserID
								FROM         tblUser" + quizLesson + @"Status INNER JOIN
													tblUser ON tblUser" + quizLesson + @"Status.UserID = tblUser.UserID
								WHERE     (tblUser" + quizLesson + @"Status.ModuleID = @ModuleID) AND (tblUser" + quizLesson + @"Status." + quizLesson + @"StatusID > 1)
								AND (tblUser.OrganisationID = @OrganisationID) ";
			}
			else
			{
				// NOTE: The query in 2 within is the same as 3.
				string sqlSelect3 = @"SELECT DISTINCT tbl" + quizLesson + @"Session_1.UserID
											FROM  tbl" + quizLesson + @"Session AS tbl" + quizLesson + @"Session_1 
												INNER JOIN tblUser AS tblUser_1 ON tbl" + quizLesson + @"Session_1.UserID = tblUser_1.UserID 
												INNER JOIN tblUser" + quizLesson + @"Status AS tblUser" + quizLesson + @"Status_1 ON tbl" + quizLesson + @"Session_1.UserID = tblUser" + quizLesson + @"Status_1.UserID
											WHERE (tbl" + quizLesson + @"Session_1." + quizLesson + @"ID = @" + quizLesson + @") AND (tblUser_1.OrganisationID = @OrganisationID) AND (tblUser" + quizLesson + @"Status_1.ModuleID = @ModuleID) AND (tblUser" + quizLesson + @"Status_1." + quizLesson + @"StatusID > 1)
									";

				if (userListType == 2) // All Users who have started a previous version of the quiz
				{
					//-- Select users which are not in the list of current 
					sqlSelect = @"SELECT DISTINCT tbl" + quizLesson + @"Session.UserID
								FROM  tbl" + quizLesson + @"Session 
									INNER JOIN tblUser ON tbl" + quizLesson + @"Session.UserID = tblUser.UserID 
									INNER JOIN tblUser" + quizLesson + @"Status ON tbl" + quizLesson + @"Session.UserID = tblUser" + quizLesson + @"Status.UserID
								WHERE (tbl" + quizLesson + @"Session." + quizLesson + @"ID <> @" + quizLesson + @") 
									AND (tblUser.OrganisationID = @OrganisationID)
									AND (tblUser" + quizLesson + @"Status.ModuleID = @ModuleID) 
									AND (tblUser" + quizLesson + @"Status." + quizLesson + @"StatusID > 1)
									AND (tbl" + quizLesson + @"Session.UserID NOT IN (" + sqlSelect3 + @")
										)
								";
				}
				else if (userListType == 3) // All Users who have started a current version of the quiz
				{
					sqlSelect = sqlSelect3;
				}
			}
			

			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			return Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteDataset(connectionString, System.Data.CommandType.Text, sqlSelect, sqlParams).Tables[0];
		}

		

		/// <summary> does the user have access to the module </summary>
		private static bool UserAssignedModule(int userID, int moduleID)
		{
			string sqlSelect = @"SELECT 1 FROM vwUserModuleAccess where UserID = @UserID and ModuleID = @ModuleID";

			
			System.Data.SqlClient.SqlParameter[] sqlParams =	{
																	new SqlParameter("@UserID", userID), 
																	new SqlParameter("@ModuleID", moduleID)
																};


			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			DataTable dt = Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteDataset(connectionString, System.Data.CommandType.Text, sqlSelect, sqlParams).Tables[0];

			if (dt.Rows.Count >= 1)
				return true;
			else
				return false;		

		}
		

		/// <summary> does the user have activity for the module quiz </summary>
		private static bool UserHasQuizActivity(int userID, int moduleID)
		{
			string sqlSelect = @"
								SELECT     UserID, ModuleID, QuizStatusID
								FROM         tblUserQuizStatus
								WHERE     (UserID = @UserID) AND (ModuleID = @ModuleID) AND (QuizStatusID = 2 OR QuizStatusID = 3)
								";

			
			System.Data.SqlClient.SqlParameter[] sqlParams =	{
																	new SqlParameter("@UserID", userID), 
																	new SqlParameter("@ModuleID", moduleID)
																};


			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			DataTable dt = Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteDataset(connectionString, System.Data.CommandType.Text, sqlSelect, sqlParams).Tables[0];

			if (dt.Rows.Count >= 1)
				return true;
			else
				return false;		
		}

		/// <summary> Besides the module specified, does the user have anyother modules they have passed or failed. </summary>
		/// <param name="userID"></param>
		/// <param name="moduleID"></param>
		/// <returns></returns>
		private static bool UserStartedOtherCourseModules(int userID, int moduleID)
		{
			string sqlSelect = @"
								SELECT     tblUserQuizStatus.QuizStatusID, tblUserQuizStatus.UserID, OtherCourseModules.ModuleID as OtherModuleID
								FROM         tblCourse INNER JOIN
													tblModule ON tblCourse.CourseID = tblModule.CourseID INNER JOIN
													tblModule AS OtherCourseModules ON tblCourse.CourseID = OtherCourseModules.CourseID INNER JOIN
													tblUserQuizStatus ON OtherCourseModules.ModuleID = tblUserQuizStatus.ModuleID
								WHERE     (tblModule.ModuleID = @ModuleID) AND (OtherCourseModules.ModuleID <> @ModuleID)
								AND (tblUserQuizStatus.UserID = @UserID)
								AND (tblUserQuizStatus.QuizStatusID = 2 OR tblUserQuizStatus.QuizStatusID = 3)
								";

			
			System.Data.SqlClient.SqlParameter[] sqlParams =	{
																	new SqlParameter("@UserID", userID), 
																	new SqlParameter("@ModuleID", moduleID)
																};


			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			DataTable dt = Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteDataset(connectionString, System.Data.CommandType.Text, sqlSelect, sqlParams).Tables[0];

			if (dt.Rows.Count >= 1)
				return true;
			else
				return false;	
		}


		#endregion
	}
}
