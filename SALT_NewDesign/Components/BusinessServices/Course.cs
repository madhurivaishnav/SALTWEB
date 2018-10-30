//===============================================================================
//
//	Salt Business Service Layer
//
//	Bdw.Application.Salt.Data.Course
//
//  Retrieves and updates course information
//
//===============================================================================
using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Configuration;
using System.Web;
using Bdw.Application.Salt.Data;
using Localization;
using Microsoft.ApplicationBlocks.Data;


namespace Bdw.Application.Salt.BusinessServices
{
    /// <summary>
    /// This class manages database activity for Course related data 
    /// </summary>
    /// <remarks>
    /// Assumptions: None.
    /// Notes: None.
    /// Author: Gavin Buddis
    /// Date: 03/03/2004
    /// Changes:
    /// </remarks>
    public class Course : Bdw.Application.Salt.Data.DatabaseService
	{	
		#region Public Methods
		/// <summary>
		/// Gets a list of Courses.
		/// </summary>
		/// <returns>Returns a DataTable with the details of all courses.</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Stephen K-Clark, 9/02/04
		/// Changes:
		/// </remarks>
        public DataTable GetCourseList(int organisationID)
		{
            using (StoredProcedure sp = new StoredProcedure("prcCourse_GetList",
                StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, 8000, organisationID)))
			{
				return sp.ExecuteTable();
			}

		} // GetSelectedCourses

        public DataTable GetSelectedCourses(string courseIDs, int organisationID)
		{
			using (StoredProcedure sp = new StoredProcedure("prcCourse_GetSelected",
					   StoredProcedure.CreateInputParam("@CourseIDs", SqlDbType.VarChar, 8000, courseIDs),
                       StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, 8000, organisationID)
					   ))
			{
				return sp.ExecuteTable();
			}

		} // GetSelectedCourses

		public DataTable GetUserMashup(string userCourseCsv, string userIDs)
		{
			using (StoredProcedure sp = new StoredProcedure("prcCourse_UserMashup",
					   StoredProcedure.CreateInputParam("@input_csv", SqlDbType.VarChar, 8000, userCourseCsv),
					   StoredProcedure.CreateInputParam("@user_ids", SqlDbType.VarChar, 8000, userIDs)
						   ))
			{
				return sp.ExecuteTable();
			}

		} // GetUserMashup

		public DataTable GetAdminMashup(int organisationID, string unitIDs, string courseIDs, string userCourseCsv, string adminIDs, int classificationID, int courseModuleStatus, DateTime quizDateFrom, DateTime quizDateTo, int inclInactive)
		{
			using (StoredProcedure sp = new StoredProcedure("prcCourse_AdminMashup",
					   StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID),
					   StoredProcedure.CreateInputParam("@unitIDs", SqlDbType.VarChar,8000, unitIDs),
					   StoredProcedure.CreateInputParam("@courseIDs", SqlDbType.VarChar,8000, courseIDs),
					   StoredProcedure.CreateInputParam("@input_csv", SqlDbType.VarChar, 8000, userCourseCsv),
					   StoredProcedure.CreateInputParam("@adminids", SqlDbType.VarChar, 8000, adminIDs),
					   StoredProcedure.CreateInputParam("@classificationID", SqlDbType.Int, classificationID),
					   StoredProcedure.CreateInputParam("@courseModuleStatus", SqlDbType.Int, courseModuleStatus),
					   StoredProcedure.CreateInputParam("@quizDateFrom", SqlDbType.DateTime, quizDateFrom),
					   StoredProcedure.CreateInputParam("@quizDateTo", SqlDbType.DateTime, quizDateTo),
					   StoredProcedure.CreateInputParam("@includeInactive",SqlDbType.Int, inclInactive)
						   ))
			{
				return sp.ExecuteTable();
			}

		} // GetUserMashup


        public void AddEbook(int courseid, string ebookFileName, string serverFileName)
        {
            using (StoredProcedure sp = new StoredProcedure("prcCourse_EbookAdd",
                     StoredProcedure.CreateInputParam("@courseid", SqlDbType.Int, courseid),
                     StoredProcedure.CreateInputParam("@ebookFileName", SqlDbType.NVarChar, 500, ebookFileName),
                     StoredProcedure.CreateInputParam("@serverFileName", SqlDbType.VarChar, 500, serverFileName)))
            {
                sp.ExecuteNonQuery();
            }
        }

        public void DeleteEbook(int courseID)
        {
            using (StoredProcedure sp = new StoredProcedure("prcCourse_EbookDelete",
                     StoredProcedure.CreateInputParam("@courseid", SqlDbType.Int, courseID)
                     ))
            {
                sp.ExecuteNonQuery();
            }
        }


        public DataTable GetEbook(int courseID, int organisationID)
        {
            using (StoredProcedure sp = new StoredProcedure("prcCourse_EbookGet",
                      StoredProcedure.CreateInputParam("@courseID", SqlDbType.Int, courseID),
                      StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID)
                      ))
            {
                return sp.ExecuteTable();
            }
        }

        public DataTable GetEbookUsersToNotify(int ebookID, int courseID)
        {
            using (StoredProcedure sp = new StoredProcedure("prcCourse_Ebook_GetDownloadUsers",
                      StoredProcedure.CreateInputParam("@ebookID", SqlDbType.Int, ebookID),
                      StoredProcedure.CreateInputParam("@courseID", SqlDbType.Int, courseID)
                      ))
            {
                return sp.ExecuteTable();
            }
        }


		public static DataTable GetCourseListByUnit(int unitID)
		{
//			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
//
//			SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@UnitID", unitID) };
//
//			string sqlCurrent = @"SELECT * FROM tblCourseLicensing WHERE OrganisationID = @OrganisationID AND CourseID = @CourseID AND DateStart <= getutcdate() AND DateEnd >= getutcdate()";
//
//			DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlCurrent, sqlParams).Tables[0];
//			return dt;
return null;
		}
		
		/// <summary>
		/// Gets a single Course's details.
		/// </summary>
		/// <returns>Returns a DataTable with the details of the specified Course.</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Stephen K-Clark, 9/02/04
		/// Changes:
		/// </remarks>
		/// <param name="courseID">ID of the course to get the details for</param>
        public DataTable GetCourse(int courseID, int organisationID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcCourse_GetOne",
					  StoredProcedure.CreateInputParam("@CourseID", SqlDbType.Int, courseID),
                      StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, 8000, organisationID)
					  ))
			{
				return sp.ExecuteTable();
			}

		} // GetCourse

        /// <summary>
		/// Gets the course ID given the session ID
		/// </summary>
		/// <returns>Returns the ID of the Course as an int, -1 if no session was found matching this session id</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Stephen K-Clark, 9/02/04
		/// Changes:
		/// </remarks>
		/// <param name="sessionID">ID of the session to get the course id for</param>
		public int GetCourseBySessionID(SqlString sessionID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcCourse_GetOneBySessionID",
					  StoredProcedure.CreateInputParam("@sessionID", SqlDbType.VarChar, 50, sessionID)
					  ))
			{
				return Convert.ToInt32(sp.ExecuteScalar());
			}

		} // GetCourse
		/// <summary>
		/// Gets a list of Courses and their details available to an organisation
		/// </summary>
		/// <returns>Returns a DataTable with the details of Accessable Courses in the SALT database.</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Stephen Kennedy-Clark
		/// Date: 09/02/2004
		/// Changes: 
		/// </remarks>
		/// <param name="organisationID"> ID of the organisation for which to get the details</param>
        public DataTable GetCourseListAccessableToOrg(int organisationID)
        {
            return GetCourseListAccessableToOrg(organisationID, 0);
        }
        public DataTable GetCourseListAccessableToOrg(int organisationID, int excludeInactive)
		{
			using(StoredProcedure sp = new StoredProcedure("prcCourse_GetListByOrganisation",
					  StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID)
                      , StoredProcedure.CreateInputParam("@excludeInactive", SqlDbType.Int, excludeInactive)
					  ))
			{
				return sp.ExecuteTable();
			}
		}// GetCourseListAccessableToOrg


		public DataTable GetPastCourseListForOrg(int organisationID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			string strSQL = @"select distinct c.courseid, c.name from tblOrganisation o ";
			strSQL = strSQL + @"join tblUser u on u.organisationid = o.organisationid ";
			strSQL = strSQL + @"join tblUserCourseStatus ucs on ucs.userid = u.userid ";
			strSQL = strSQL + @"join tblCourse c on c.courseid = ucs.courseid ";
			strSQL = strSQL + @"where o.OrganisationID = " + organisationID + " ";
			strSQL = strSQL + @"and c.courseid not in (select c1.courseid from tblCourse c1 ";
			strSQL = strSQL + @"inner Join tblOrganisationCourseAccess oca ";
			strSQL = strSQL + @"on oca.GrantedCourseID = c1.CourseID ";
			strSQL = strSQL + @"and oca.organisationID = " + organisationID + ") order by c.name";

			DataTable dtPastCourseList = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0]; 
			return dtPastCourseList;
		}
    
        /// <summary>
        /// Gets a list of Courses and their details available to a user
        /// </summary>
        /// <returns>Returns a DataTable with the details of Accessable Courses in the SALT database.</returns>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen Kennedy-Clark
        /// Date: 09/02/2004
        /// Changes: 
        /// </remarks>
        /// <param name="userID"> ID of the user for which to get the details</param>
        public DataTable GetCourseListAccessableToUser(int userID)
        {
            using(StoredProcedure sp = new StoredProcedure("prcCourse_GetListByUser",
                      StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID)
                      ))
            {
                return sp.ExecuteTable();

            }

        }// GetCourseListAccessableToUser


        public string GetCourseListAccessableToUsr(int userID)
        {
            DataTable dt;

            dt = GetCourseListAccessableToUser(userID);

            string strCourselist = "";

            foreach (DataRow dr in dt.Rows)
            {
                strCourselist += dr["Name"].ToString() + "<br />";
            }

            return strCourselist;

        }// GetCourseListAccessableToUsr



        /// <summary>
        /// Increments by 1 the Module sequence value for the specified module
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Gavin Buddis
        /// Date: 03/03/2004
        /// Changes: 
        /// </remarks>
        /// <param name="moduleIDToIncrement">ID of the module to move</param>
        /// <param name="updatedByUserID">ID of the user preforming the update</param>
        public void IncrementModuleSequence(int moduleIDToIncrement, int updatedByUserID, int organisationID)
        {
            int intCurrentSequence;         // Current sequence value of the specified Module

            // Get the details for the specified module and details for all modules in the same course
            Module objModule = new Module();
            DataTable dtbModule = objModule.GetModule(moduleIDToIncrement, organisationID);
            DataTable dtbModules = objModule.GetModuleListByCourse(Convert.ToInt32(dtbModule.Rows[0]["CourseID"]), organisationID);

            // Get the current sequence value for the specified module
            intCurrentSequence = Convert.ToInt32(dtbModule.Rows[0]["Sequence"]);
            if (intCurrentSequence < dtbModules.Rows.Count)
            {
                // Increment the specifed module's sequence value and demrement the
                // following module sequence value
                objModule.UpdateSequence(moduleIDToIncrement, intCurrentSequence + 1, updatedByUserID);
                objModule.UpdateSequence(Convert.ToInt32(dtbModules.Rows[intCurrentSequence]["ModuleID"]), intCurrentSequence, updatedByUserID);
            }

        } // IncrementModuleSequence

        /// <summary>
        /// Decrements by 1 the Module sequence value for the specified module
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Gavin Buddis
        /// Date: 03/03/2004
        /// Changes: 
        /// </remarks>
        /// <param name="moduleIDToDecrement">ID of the module</param>
        /// <param name="updatedByUserID">ID of the user</param>
        public void DecrementModuleSequence(int moduleIDToDecrement, int updatedByUserID, int organisationID)
        {
            int intCurrentSequence;         // Current sequence value of the specified Module

            // Get the details for the specified module and details for all modules in the same course
            Module objModule = new Module();
            DataTable dtbModule = objModule.GetModule(moduleIDToDecrement, organisationID);
            DataTable dtbModules = objModule.GetModuleListByCourse(Convert.ToInt32(dtbModule.Rows[0]["CourseID"]), organisationID);

            // Get the current sequence value for the specified module
            intCurrentSequence = Convert.ToInt32(dtbModule.Rows[0]["Sequence"]);
            if (intCurrentSequence > 1)
            {
                // Decrement the specifed module's sequence value and increment the
                // preceeding module's sequence value
                objModule.UpdateSequence(moduleIDToDecrement, intCurrentSequence - 1, updatedByUserID);
                objModule.UpdateSequence(Convert.ToInt32(dtbModules.Rows[intCurrentSequence - 2]["ModuleID"]), intCurrentSequence, updatedByUserID);
            }

        } // DecrementModuleSequence

        /// <summary>
        /// Updates a course details. If the status is changed, there will be validation checking.
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Gavin Buddis
        /// Date: 03/03/2004
        /// Changes: 
        /// </remarks>
        /// <param name="courseID">ID of the course</param>
        /// <param name="name">Course Name</param>
        /// <param name="notes">Course Notes</param>
        /// <param name="active">Is Course Active</param>
        /// <param name="updatedByUserID">User ID of user preforming the update</param>
        public void Update(int courseID, string name, string notes, bool active, int updatedByUserID)
        {
            using(StoredProcedure sp = new StoredProcedure("prcCourse_Update",
                      StoredProcedure.CreateInputParam("@courseID", SqlDbType.Int, courseID),
                      StoredProcedure.CreateInputParam("@name", SqlDbType.NVarChar, 100, name),
                      StoredProcedure.CreateInputParam("@notes", SqlDbType.NVarChar, 1000, notes),
                      StoredProcedure.CreateInputParam("@active", SqlDbType.Bit, active),
                      StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, updatedByUserID)
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
                switch (intErrorNumber)
                {
                    case 0: // Succeeded.
                    {
                        break;
                    }
                    case 1: // PK not found.
                    {
                        throw new RecordNotFoundException(strErrorMessage);
                    }
                    case 4: // Unique constraint.
                    {
                        throw new UniqueViolationException(String.Format(ResourceManager.GetString("prcCourse_Create.4"), name));
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

        } // Update

        /// <summary>
        /// Creates a course.
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Gavin Buddis
        /// Date: 03/03/2004
        /// Changes: 
        /// </remarks>
        /// <param name="name">Name of the course</param>
        /// <param name="notes">Notes for this course</param>
        /// <param name="active">Is this course active</param>
        /// <param name="createdByUserID">Id of the user creatig this course</param>
        public int Create(string name, string notes, bool active, int createdByUserID)
        {
            int intCourseID = 0;
            SqlParameter paramKey = StoredProcedure.CreateOutputParam("@intCourseID", SqlDbType.Int, 4, intCourseID);
            using(StoredProcedure sp = new StoredProcedure("prcCourse_Create",
                      paramKey,
                      StoredProcedure.CreateInputParam("@name", SqlDbType.NVarChar, 100, name),
                      StoredProcedure.CreateInputParam("@notes", SqlDbType.NVarChar, 1000, notes),
                      StoredProcedure.CreateInputParam("@active", SqlDbType.Bit, active),
                      StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, createdByUserID)
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
                        intCourseID = (int)paramKey.Value;
                        return intCourseID;
                    }
                    case 4: // Unique constraint.
                    {
                        throw new UniqueViolationException(String.Format(ResourceManager.GetString("prcCourse_Create.4"), name));
                    }
                    case 5: // Parameter Exception.
                    {
                        throw new ParameterException(strErrorMessage);
                    }
                    case 6: // Permission Denied.
                    {
                        throw new PermissionDeniedException(strErrorMessage);
                    }
                    default: // Whatever is left.
                    {
                        throw new BusinessServiceException(strErrorMessage);
                    }
                }
            }

        } // Create

        #endregion	
	}
}
