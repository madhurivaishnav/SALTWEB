//===============================================================================
//
//	Salt Business Service Layer
//
//	Bdw.Application.Salt.Data.User
//
//  Retrieve and update user information
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
using System.Collections.ObjectModel;

namespace Bdw.Application.Salt.BusinessServices
{
	/// <summary>
	/// Retrieves and updates user information.
	/// </summary>
	/// <remarks>
	/// Assumptions: None
	/// Notes: 
	/// Author: All Developers
	/// Changes:
	/// </remarks>
	public class User : Bdw.Application.Salt.Data.DatabaseService
	{		
		#region Public  Methods
		/// <summary>
		/// Gets a single User's Details.
		/// </summary>
		/// <returns>Returns a DataTable with the details of one User in the SALT database.</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Gavin Buddis
		/// Date: 10/02/2004
		/// Changes:
		/// </remarks>
        public DataTable GetUser(int userID)
		{
			using (StoredProcedure sp = new StoredProcedure("prcUser_GetOne",
					   StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID)
                     
					   ))
			{
				return sp.ExecuteTable();
			}
		}// GetUser

        public DataTable GetUserOrganisation(int userID)
        {
            using (StoredProcedure sp = new StoredProcedure("prcUserOrganisation",
                       StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID)

                       ))
            {
                return sp.ExecuteTable();
            }
        }// GetUser

        public DataTable GetUserOrganisationPasswordLock(string OrgURL)
        {
            using (StoredProcedure sp = new StoredProcedure("prcUserOrganisationPasswordLock",
                       StoredProcedure.CreateInputParam("@organisationURL", SqlDbType.NVarChar, OrgURL)

                       ))
            {
                return sp.ExecuteTable();
            }
        }// GetUser

        public DataTable GetUserForCC(int userId)
        {
            using (StoredProcedure sp = new StoredProcedure("prcUser_GetUserForCC",
                StoredProcedure.CreateInputParam("UserID", SqlDbType.Int, userId)
                ))
            {
                return sp.ExecuteTable();
            }
        }

        public DataTable GetUserWithOwnTime(int userID)
        {
            using (StoredProcedure sp = new StoredProcedure("prcUser_GetOneWithOwnTime",
                       StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID)

                       ))
            {
                return sp.ExecuteTable();
            }
        }// GetUser

        public DataTable GetDetailsByEmailAndDomain(string emailAddress, string DomainName)
        {
            using (StoredProcedure sp = new StoredProcedure("prcUser_GetDetailsByEmailAndDomain",
                       StoredProcedure.CreateInputParam("@emailAddress", SqlDbType.NVarChar, emailAddress),
                       StoredProcedure.CreateInputParam("@DomainName", SqlDbType.NVarChar, DomainName)
                       ))
            {
                return sp.ExecuteTable();
            }
        }// GetUser
        public void UpdatePassword(int UserID, string password, string EncryptPassword)
        {
            using (StoredProcedure sp = new StoredProcedure("prcUser_UpdatePassword",
                StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, UserID),
                StoredProcedure.CreateInputParam("@password", SqlDbType.NVarChar, password),
                StoredProcedure.CreateInputParam("@EncryptPassword", SqlDbType.NVarChar, EncryptPassword)
                     ))
            {
                sp.ExecuteNonQuery();
            }
        } 

		/// <summary>
		/// Gets a list of SALT Administrators.
		/// </summary>
		/// <returns>Returns a DataTable with all the SALT Administrators.</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Gavin Buddis
		/// Date: 23/03/2004
		/// Changes:
		/// </remarks>
        public DataTable GetSALTAdministrators(int currentUserID, int organisationID)
		{
			using (StoredProcedure sp = new StoredProcedure("prcUser_GetSALTAdministrators",
					   StoredProcedure.CreateInputParam("@requestedByUserID", SqlDbType.Int, currentUserID),
                       StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, 8000, organisationID)
                       ))
			{
				return sp.ExecuteTable();
			}
		}// GetSALTAdministrators

		/// <summary>
		/// Gets the email addresses of all users in the supplied csv list.
		/// </summary>
		/// <returns>Returns a DataTable with the userids and emails of all of the users supplied</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Kneale
		/// Date: 27/02/2004
		/// Changes:
		/// </remarks>
		public DataTable GetEmails(string userIDs)
		{
			using (StoredProcedure sp = new StoredProcedure("prcUser_GetEmailAddress",
					   StoredProcedure.CreateInputParam("@userIDs", SqlDbType.VarChar,8000, userIDs)
					   ))
			{
				return sp.ExecuteTable();
			}
		}// GetEmails


		/// <summary>
		/// Gets all active users who have yet to be assigned to a unit
		/// </summary>
		/// <returns>Returns a DataSet with the details of all Users who are unassigned.</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Kneale
		/// Date: 23/02/2004
		/// Changes:
		/// </remarks>
		public DataSet GetUnassigned(int organisationID)
		{
			using (StoredProcedure sp = new StoredProcedure("prcUser_GetUnassigned",
					   StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID)
					   ))
			{
				return sp.ExecuteDataSet();
			}
		}//GetUnassigned



		/// <summary> Get list of users which have a status against the specified module </summary>
		public static DataTable GetUserList(int organisationID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			System.Data.SqlClient.SqlParameter[] sqlParams =	{
																	new SqlParameter("@OrganisationID", organisationID)
																};

			string sqlSelect = "select UserID, FirstName, LastName from tblUser where OrganisationID = @OrganisationID order by LastName";
			return Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteDataset(connectionString, System.Data.CommandType.Text, sqlSelect, sqlParams).Tables[0];
		}


		/// <summary> Get list of users which have a status against the specified module </summary>
		public static DataTable GetUserList(int organisationID, int moduleID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			System.Data.SqlClient.SqlParameter[] sqlParams =	{
																	new SqlParameter("@OrganisationID", organisationID), 
																	new SqlParameter("@ModuleID", moduleID)
																};

			string sqlSelect = @"SELECT UserID, FirstName, LastName FROM tblUserQuizStatus
									INNER JOIN tblUser ON tblUserQuizStatus.UserID = tblUser.UserID 
									ORDER BY LastName";

			return Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteDataset(connectionString, System.Data.CommandType.Text, sqlSelect, sqlParams).Tables[0];
		}




		/// <summary>
		/// Gets a list of users from a specific Unit which conform to the criteria and 
		/// who are not Salt or org administrator
		/// </summary>
		/// <param name="organisationID">Organisation to search</param>
		/// <param name="parentUnitIDs">Parent units to search</param>
		/// <param name="firstName">The text that user's  first name contains</param>
		/// <param name="lastName">The text that user's  last name contains</param>
		/// <param name="adminUserID">UserID of the current admin user</param>
		/// <returns>A list of user</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// Aaron		27/03/2007		@parentUnitIDs type modified from Varchar(500)
		/// VDL			26 Sep 2008		call the prc_UserSearch in one place only!
		/// </remarks>
		public DataTable Search(int organisationID, string parentUnitIDs, string firstName, string lastName, int adminUserID)
		{			
			//prcUser_Search
			return Search(organisationID, parentUnitIDs, firstName, lastName, adminUserID, false);
		}//Search

		/// <summary>
		/// Gets a list of users from a specific Unit which conform to the criteria and 
		/// who are not Salt or org administrator
		/// </summary>
		/// <param name="organisationID">ID of the Organisation to search</param>
		/// <param name="parentUnitIDs">ID of the units</param>
		/// <param name="firstName">The text that user's  first name contains</param>
		/// <param name="lastName">The text that user's  last name contains</param>
		/// <param name="adminUserID"></param>
		/// <param name="includeInactiveUsers"></param>
		/// <returns>A list of user</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// Aaron		27/03/2007		@parentUnitIDs type modified from Varchar(500)
		/// </remarks>
		public DataTable Search(int organisationID, string parentUnitIDs, string firstName, string lastName, int adminUserID, bool includeInactiveUsers)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUser_Search",
					  StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID),
					  StoredProcedure.CreateInputParam("@parentUnitIDs", SqlDbType.VarChar, 8000, parentUnitIDs),
					  StoredProcedure.CreateInputParam("@firstName", SqlDbType.NVarChar, 50, firstName),
					  StoredProcedure.CreateInputParam("@lastName", SqlDbType.NVarChar, 50, lastName),
					  StoredProcedure.CreateInputParam("@adminUserID", SqlDbType.Int, adminUserID),
					  StoredProcedure.CreateInputParam("@includeInactiveUsers", SqlDbType.Int, includeInactiveUsers)
					  ))
			{
				return sp.ExecuteTable();
			}
		}//Search

		/// <summary>
		/// Gets a list of users from a specific Unit which conform to the criteria 
		/// and who have a user type which is lower than or equal to the specified user type id
		/// </summary>
		/// <param name="unitID">ID of the unit</param>
		/// <param name="firstName">The text that user's  first name contains</param>
		/// <param name="lastName">The text that user's  last name contains</param>
		/// <param name="userTypeID">the highest user role that the users belong to</param>
		/// <param name="adminUserID">The admin user that makes the query</param>
		/// <returns>A list of users</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// VDL			26 Sep 2008			Call prcUnit_SearchUsers in one place
		/// </remarks>
		public DataTable Search(int unitID, string firstName, string lastName, int userTypeID, int adminUserID)
		{
			//prcUnit_SearchUsers
			return Search(unitID, firstName, lastName, userTypeID, adminUserID, false);
		} //Search

		/// <summary>
		/// Gets a list of users from a specific Unit which conform to the criteria 
		/// and who have a user type which is lower than or equal to the specified user type id.
		/// It can be specified whether inactive users should be returned or not.
		/// </summary>
		/// <param name="unitID">ID of the unit</param>
		/// <param name="firstName">The text that user's  first name contains</param>
		/// <param name="lastName">The text that user's  last name contains</param>
		/// <param name="userTypeID">the highest user role that the users belong to</param>
		/// <param name="adminUserID">The admin user that makes the query</param>
		/// <param name="includeInactiveUsers">Whether inactive users should be returned or not</param>
		/// <returns>A list of users</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public DataTable Search(int unitID, string firstName, string lastName, int userTypeID, int adminUserID, bool includeInactiveUsers)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUnit_SearchUsers",
					  StoredProcedure.CreateInputParam("@unitID", SqlDbType.Int, unitID),
					  StoredProcedure.CreateInputParam("@firstName", SqlDbType.NVarChar,50, firstName),
					  StoredProcedure.CreateInputParam("@lastName", SqlDbType.NVarChar,50, lastName),
					  StoredProcedure.CreateInputParam("@userTypeID", SqlDbType.Int, userTypeID),
					  StoredProcedure.CreateInputParam("@adminUserID", SqlDbType.Int, adminUserID),
					  StoredProcedure.CreateInputParam("@includeInactiveUsers", SqlDbType.Bit, includeInactiveUsers)
					  ))
			{
				return sp.ExecuteTable();
			}
		} //Search

		/// <summary>
		/// Gets a list of users from a specific Unit which conform to the criteria and 
		/// who are not Salt or org administrator
		/// </summary>
		/// <param name="organisationID">Organisation to search</param>
		/// <param name="parentUnitIDs">Parent units to search</param>
		/// <param name="firstName">The text that user's  first name contains</param>
		/// <param name="lastName">The text that user's  last name contains</param>
		/// <param name="userName">The text that user's  username contains</param>
		/// <param name="adminUserID">UserID of the current admin user</param>
		/// <returns>A list of user</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Li Zhang, 4/04/2006
		/// Changes:
		/// </remarks>
		public DataTable Search(int organisationID, string parentUnitIDs, string firstName, string lastName,string userName, int adminUserID)
		{
			//prcUser_UsernameSearch
			return Search(organisationID, parentUnitIDs, firstName, lastName, userName, adminUserID, false, "", 0);
		}//Search

		/// <summary>
		/// Gets a list of users from a specific Unit which conform to the criteria and 
		/// who are not Salt or org administrator
		/// </summary>
		/// <param name="organisationID">ID of the Organisation to search</param>
		/// <param name="parentUnitIDs">ID of the units</param>
		/// <param name="firstName">The text that user's  first name contains</param>
		/// <param name="lastName">The text that user's  last name contains</param>
		/// <param name="userName">The text that user's  username contains</param>
		/// <param name="adminUserID"></param>
		/// <param name="includeInactiveUsers"></param>
		/// <returns>A list of user</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Li Zhang, 4/04/2006
		/// Changes:
		/// </remarks>
		public DataTable Search(int organisationID, string parentUnitIDs, string firstName, string lastName, string userName, int adminUserID, bool includeInactiveUsers)
		{
			//prcUser_UsernameSearch
			return Search(organisationID, parentUnitIDs, firstName, lastName, userName, adminUserID, includeInactiveUsers, "", 0);
		}//Search


		public DataTable Search(int organisationID, string parentUnitIDs, string firstName, string lastName, string userName, int adminUserID, bool includeInactiveUsers, string emailAddress, int userID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUser_UsernameSearch",
					  StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID),
					  StoredProcedure.CreateInputParam("@parentUnitIDs", SqlDbType.VarChar, 500, parentUnitIDs),
					  StoredProcedure.CreateInputParam("@firstName", SqlDbType.NVarChar, 50, firstName),
					  StoredProcedure.CreateInputParam("@lastName", SqlDbType.NVarChar, 50, lastName),
					  StoredProcedure.CreateInputParam("@userName", SqlDbType.NVarChar, 100, userName),
					  StoredProcedure.CreateInputParam("@userEmail", SqlDbType.NVarChar, 300, emailAddress),
                      StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID),
					  StoredProcedure.CreateInputParam("@adminUserID", SqlDbType.Int, adminUserID),
					  StoredProcedure.CreateInputParam("@includeInactiveUsers", SqlDbType.Int, includeInactiveUsers)
					  ))
			{
				return sp.ExecuteTable();
			}
		}//Search

        public DataTable SearchUsers(int orgID, string firstName, string lastName, int scheduleId)
        {
            using (StoredProcedure sp = new StoredProcedure("prcSearchUsers",
                StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, orgID),
                StoredProcedure.CreateInputParam("@Firstname", SqlDbType.VarChar, firstName),
                StoredProcedure.CreateInputParam("@LastName", SqlDbType.VarChar, lastName),
                StoredProcedure.CreateInputParam("@ScheduleId", SqlDbType.Int, scheduleId)
                ))
            {
                return sp.ExecuteTable();
            }

        }

        public DataTable SearchAdminUsers(int orgID, string firstName, string lastName)
        {
            using (StoredProcedure sp = new StoredProcedure("prcSearchAdminUsers",
                StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, orgID),
                StoredProcedure.CreateInputParam("@Firstname", SqlDbType.VarChar, firstName),
                StoredProcedure.CreateInputParam("@LastName", SqlDbType.VarChar, lastName)
                ))
            {
                return sp.ExecuteTable();
            }

        }

		/// <summary>
		/// Gets the unit tree for a specific user
		/// The unit that the user belongs to will be preselected, and expanded.
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu
		/// Date: 17/02/2004
		/// Changes:
		/// </remarks>
		public DataSet GetUnitsTree(int userID, int adminUserID)
		{
			using (StoredProcedure sp = new StoredProcedure("prcUser_GetUnitsTree",
					   StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID),
					   StoredProcedure.CreateInputParam("@adminUserID", SqlDbType.Int, adminUserID)
					   ))
			{
				return sp.ExecuteDataSet();
			}
		}

		/// <summary>
		/// This is a hierarchical list of the Units that this user has Unit Administrator rights to.  
		///	It is for display-only.
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu
		/// Date: 17/02/2004
		/// Changes:
		/// </remarks>
		public DataSet GetAdminUnitsTree(int userID)
		{
			using (StoredProcedure sp = new StoredProcedure("prcUser_GetAdminUnitsTree",
					   StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID)
					   ))
			{
				return sp.ExecuteDataSet();
			}
		}
		/// <summary>
		/// This is a hierarchical list of the Units that this user has Unit Administrator rights to.  
		///	Any unit returned can be selected
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Kneale
		/// Date: 18/02/2004
		/// Changes:
		/// </remarks>
		public DataSet SelectAdminUnitsTree(int userID)
		{
			using (StoredProcedure sp = new StoredProcedure("prcUser_SelectAdminUnitsTree",
					   StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID)
					   ))
			{
				return sp.ExecuteDataSet();
			}
		} //SelectAdminUnitsTree

		

		/// <summary>
		/// Returns a single row for the classification assigned to a user
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: John Crawford
		/// Date: 17/02/2004
		/// Changes:
		/// </remarks>
		public DataTable GetClassification(int userID)
		{
			using (StoredProcedure sp = new StoredProcedure("prcUser_GetClassification",
					   StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID)
					   ))
			{
				return sp.ExecuteTable();
			}
		} //GetClassification
		
		/// <summary>
		/// Gets the user details for authentication and login.
		/// </summary>
		/// <param name="userName">username to </param>
		/// <returns>Returns a collection user details</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu
		/// Date: 17/02/2004
		/// Changes.
		/// Revision Number: 1
		/// Author:
		/// Date:
		/// Description:
		/// </remarks>
		public  DataTable Login(string userName,string domainName)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUser_Login",
					  StoredProcedure.CreateInputParam("@userName", SqlDbType.NVarChar, 50, userName),
					  StoredProcedure.CreateInputParam("@domainName", SqlDbType.NVarChar, 100, domainName)
					  ))
			{
				return sp.ExecuteTable();
			}
		}
        public DataTable Login228(string userName, string domainName, string connectionString)
        {
            SqlCommand cmd = new SqlCommand();
            SqlConnection con = new SqlConnection(connectionString);        
            SqlDataAdapter da = new SqlDataAdapter();
            DataTable dt = new DataTable();
            try
            {
                cmd = new SqlCommand("prcUser_Login", con);
                cmd.Parameters.Add(new SqlParameter("@userName", userName));
                cmd.Parameters.Add(new SqlParameter("@domainName", domainName));
                cmd.CommandType = CommandType.StoredProcedure;
                da.SelectCommand = cmd;
                da.Fill(dt);
            }
            catch (Exception x)
            {
               
            }
            finally
            {
                cmd.Dispose();
                con.Close();
            }
            return dt;

            //using (StoredProcedure sp = new StoredProcedure("prcUser_Login",
            //          StoredProcedure.CreateInputParam("@userName", SqlDbType.NVarChar, 50, userName),
            //          StoredProcedure.CreateInputParam("@domainName", SqlDbType.NVarChar, 100, domainName)
            //          ))
            //{
            //    return sp.ExecuteTable();
            //}
        }
		/// <summary>
		/// Log the fact that a user has successfully logged in.
		/// </summary>
		/// <param name="userName">username of the user that logged in.</param>
		public void LogLogin(int userID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUser_LogLogin",
					  StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID)

					  ))
			{
				sp.ExecuteScalar();
			}
		}
		
		/// <summary>
		/// Gets the users module access details for the homepage.
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Stephen K-Clark
		/// Date: 01/03/2004
		/// Changes.
		/// </remarks>
		/// <param name="userID">ID of the user</param>
		/// <param name="courseID">ID of the course</param>
		/// <returns>DataTable specifically for the home page module list</returns>
		public  DataTable HomePageDetails(int userID, int courseID, int ProfileID )
		{
            			string currentCulture = ResourceManager.CurrentCultureName;

			using(StoredProcedure sp = new StoredProcedure("prcModule_GetDetailsForHomePage",
					  StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID),
					  StoredProcedure.CreateInputParam("@courseID", SqlDbType.Int, courseID),
                      StoredProcedure.CreateInputParam("@ProfileID", SqlDbType.Int, ProfileID),
                      StoredProcedure.CreateInputParam("@CurrentCultureName", SqlDbType.NVarChar, 50, currentCulture)
))
			{
				return sp.ExecuteTable();
			}
		} //HomePageDetails

        public DataTable GEtToolBookLocation(int courseID)
        {
            string currentCulture = ResourceManager.CurrentCultureName;

            using (StoredProcedure sp = new StoredProcedure("prcGetToolbookLocation",
                      StoredProcedure.CreateInputParam("@courseID", SqlDbType.Int, courseID)))
            {
                return sp.ExecuteTable();
            }
        } //HomePageDetails

		/// <summary>
		/// Gets a user's course status.
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Stephen K-Clark
		/// Date: 01/03/2004
		/// Changes.
		/// </remarks>
		/// <param name="userID">ID of the user</param>
		/// <param name="courseID">ID of the course</param>
		/// <returns>DataTable specifically for the home page course status</returns>
        public DataTable GetUserCourseStatus(int userID, int courseID, int organisationID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUserCourseStatus_GetOne",
					  StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID),
					  StoredProcedure.CreateInputParam("@courseID", SqlDbType.Int, courseID),
                      StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, 8000, organisationID)
					  ))
			{
				return sp.ExecuteTable();
			}

		} //UserCourseStatus

		/// <summary>
		/// Insert or Updates user details as specified in the XML document.
		/// </summary>
		/// <param name="ID">The ID of either the Unit or Organisation.</param>
		/// <param name="userXml">The XML file with the user details.</param>
		/// <param name="hierachy">Name of the stored procedure to execute.</param>
		/// <param name="userID">The user id of the user to update</param>
		/// <returns>Returns a DataTable with the results of the upload.</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Vranich
		/// Date: 17/02/2004
		/// Changes.
		/// Revision Number: 1
		/// Author:
		/// Date:
		/// Description:
		/// </remarks>
		public DataSet LoadUserXML(int ID, SqlString userXml, SqlString hierachy, int userID, int uniqueField)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUser_ImportPreview",
					  StoredProcedure.CreateInputParam("@userXMLData", SqlDbType.Text, userXml),
					  StoredProcedure.CreateInputParam("@ID", SqlDbType.Int, ID),
					  StoredProcedure.CreateInputParam("@hierachy", SqlDbType.NVarChar, 12, hierachy),
					  StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID),
					  //StoredProcedure.CreateInputParam("@isPreview", SqlDbType.Int, isPreview),
					  StoredProcedure.CreateInputParam("@uniqueField",SqlDbType.Int,uniqueField)
					  ))
			{
				return sp.ExecuteDataSet();
			}
		}

		/// <summary>
		/// This returns a users quiz summary for a given quiz session
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Stephen K-Clark
		/// Date: 01/03/2004
		/// </remarks>
		/// <param name="quizSessionID">The SessionID of the session that needs to be returned</param>
		/// <returns>Returns a DataSet with the summary of a users quiz session</returns>
		public DataSet GetQuizSummary (string quizSessionID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUser_GetQuizSummary",
					  StoredProcedure.CreateInputParam("@QuizSessionID", SqlDbType.VarChar, 50, quizSessionID)
					  ))
			{
				return sp.ExecuteDataSet();
			}
		} //GetQuizSummary

		/// <summary>
		/// This returns a users quiz history for a given quiz module
		/// </summary>
		/// <param name="userID">The userid of the user for whom the quiz history is to be returned</param>
		/// <param name="moduleID">The module for which the quiz history is to be returned.</param>
		/// <returns>Returns a DataTable with the summary of a users quiz session</returns>
        public DataSet GetQuizHistory(int userID, int moduleID, int organisationID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUser_GetQuizHistory",
					  StoredProcedure.CreateInputParam("@UserID", SqlDbType.Int, userID),
					  StoredProcedure.CreateInputParam("@ModuleID", SqlDbType.Int, moduleID),
                      StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, 8000, organisationID)
					  ))
			{
				return sp.ExecuteDataSet();
			}
		} //GetQuizHistory

		/// <summary>
		/// Gets user module access settings
		/// </summary>
		/// <param name="userID">User ID to get access details for</param>
		/// <param name="courseID">Course ID to get access detail for</param>
		/// <returns></returns>
		public DataTable GetModuleAccess(int userID, int courseID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUser_GetModuleAccess",
					  StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID),
					  StoredProcedure.CreateInputParam("@courseID", SqlDbType.Int, courseID)
					  ))
			{
				return sp.ExecuteTable();
			}
		} //GetModuleAccess

		
		/// <summary>
		/// Saves User module access settings
		/// </summary>
		/// <param name="userID">User ID to save access for</param>
		/// <param name="courseID">Course ID to save access for</param>
		/// <param name="grantedModuleIDs">Comma seperated list of modules to apply access to</param>
		/// <returns></returns>
		public DataTable SaveModuleAccess(int userID, int courseID, string grantedModuleIDs)
		{
			DataTable dt = null;
			using(StoredProcedure sp = new StoredProcedure("prcUser_SaveModuleAccess",
					  StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID),
					  StoredProcedure.CreateInputParam("@courseID", SqlDbType.Int, courseID),
					  StoredProcedure.CreateInputParam("@grantedModuleIDs", SqlDbType.VarChar, 500, grantedModuleIDs)
					  ))
			{
				dt = sp.ExecuteTable();
			}

			if (grantedModuleIDs != null)
			{
				foreach(string grantedModuleID in grantedModuleIDs.Split(','))
				{
					if (grantedModuleID != string.Empty)
					{
						int moduleID = Int32.Parse(grantedModuleID);
						BusinessServices.CourseLicensing.LicenseAuditByUserModule(userID, moduleID);
					}
				}
			}

			return dt;
		}

		/// <summary>
		/// Creates a new user in the database
		/// </summary>
		/// <param name="organisationID">The organisation id of the new user.</param>
		/// <param name="unitID">The unit id of the new user.</param>
		/// <param name="firstName">First name of the user.</param>
		/// <param name="lastName">Last name of the user.</param>
		/// <param name="userName">Username of the user.</param>
		/// <param name="email">Email address of the user</param>
		/// <param name="active">Boolean value indicating that the user is active.</param>
		/// <param name="password">Password of the user</param>
		/// <param name="userTypeID">The type of the user</param>
		/// <param name="actionUserID">The user id of the user performing this user.</param>
		/// <param name="externalID">The external id of the user</param>
		/// <returns>Integer success or failure value.</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: If the unitID supplied is 0, a null value for the user's unit is made
		/// Author: Peter Vranich/Gavin Buddis
		/// Date: 20/02/2004
		/// Changes:
		/// </remarks>
		public int Create(int organisationID, int unitID, SqlString firstName, SqlString lastName, SqlString userName, 
			SqlString email, SqlBoolean active, int userTypeID, int actionUserID,
            SqlString password, SqlString externalID, String standardName, string ManEmail
            , bool NotifyUnitAdmin, bool NotifyOrgAdmin, bool NotifyMgr, bool EbookNotification)
		{
            SqlInt32 TimeZoneID = 0;

            if (standardName != null)
            {
                using (StoredProcedure sp = new StoredProcedure("prcTimeZone_GetTZIDfromFLBName", StoredProcedure.CreateInputParam("@FLBName", SqlDbType.NVarChar, standardName)))
                {
                    TimeZoneID = Convert.ToInt32(sp.ExecuteScalar());
                }
            }

			using(StoredProcedure sp = new StoredProcedure("prcUser_Create",
					  StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID),
					  StoredProcedure.CreateInputParam("@unitID", SqlDbType.Int, ((unitID == 0) ? SqlInt32.Null : unitID)),
					  StoredProcedure.CreateInputParam("@firstName", SqlDbType.NVarChar,50,firstName),
					  StoredProcedure.CreateInputParam("@lastName", SqlDbType.NVarChar,50,lastName),
					  StoredProcedure.CreateInputParam("@userName", SqlDbType.NVarChar,50,userName),
					  StoredProcedure.CreateInputParam("@email", SqlDbType.NVarChar,100,email),
					  StoredProcedure.CreateInputParam("@active", SqlDbType.Bit, active),
					  StoredProcedure.CreateInputParam("@userTypeID", SqlDbType.Int, userTypeID),
					  StoredProcedure.CreateInputParam("@actionUserID", SqlDbType.Int, actionUserID),
					  StoredProcedure.CreateInputParam("@password", SqlDbType.NVarChar, 50, password),
					  StoredProcedure.CreateInputParam("@externalID", SqlDbType.NVarChar, 50, externalID),
                      StoredProcedure.CreateInputParam("@TimeZoneID", SqlDbType.Int, ((standardName == null) ? SqlInt32.Null : TimeZoneID)),
                      StoredProcedure.CreateInputParam("@DelinquencyManagerEmail", SqlDbType.NVarChar, 100, ManEmail),
                      StoredProcedure.CreateInputParam("@NotifyUnitAdmin", SqlDbType.Bit, NotifyUnitAdmin),
                      StoredProcedure.CreateInputParam("@NotifyOrgAdmin", SqlDbType.Bit, NotifyOrgAdmin),
                      StoredProcedure.CreateInputParam("@NotifyMgr", SqlDbType.Bit, NotifyMgr),
                      StoredProcedure.CreateInputParam("@EbookNotification", SqlDbType.Bit, EbookNotification)

					  ))
			{
				SqlDataReader rdr = sp.ExecuteReader();
				int intError;
				string strMessage;
				rdr.Read();
				intError = rdr.GetInt32(0);
				strMessage = rdr.GetString(1);
				rdr.Close();
				
				// Throw the required exception if error number is not 0.
				switch(intError)
				{
					case 0: // Succeeded.
					{
						// Return the new PK value
						int newUserID = int.Parse(strMessage);

						//-- LICENSING
						BusinessServices.CourseLicensing.LicenseAudit(newUserID, unitID);

						return newUserID;
					}
					case 41: // Unique constraint.
					{
						throw new UniqueViolationException(string.Format(ResourceManager.GetString("prcUser_Create." + intError.ToString()), email));
					}
					case 4: 
					case 42: // Unique constraint.
					{
						throw new UniqueViolationException(string.Format(ResourceManager.GetString("prcUser_Create." + intError.ToString()), strMessage));
					}
					case 5: // Parameter Exception.
					{
						throw new ParameterException(strMessage);
					}
					default: // Whatever is left.
					{
						throw new BusinessServiceException(ResourceManager.GetString("prcUser_Create." + intError.ToString()));
					}
				}
			}
		} // Create

        
		/// <summary>
		/// Update a users details into the database - No Password change
		/// </summary>
		/// <param name="userID">User Id of the user being updated</param>
		/// <param name="unitID">Unit Id of the user being updated - may be 0 for
		/// salt administrators
		/// </param>
		/// <param name="firstName">First Name of the user being updated</param>
		/// <param name="lastName">Last Name of the user being update</param>
		/// <param name="userName">username of the user being update</param>
		/// <param name="email">Email Adress of the user being update</param>
		/// <param name="active">Active Status of the user being update</param>
		/// <param name="userTypeID">UserType IF of the user being update</param>
		/// <param name="updatedByUserID">User Id of the user doing the update</param>
		/// <param name="dateUpdated">date stamp for the previous dateUpdated,
		/// used as integrity check, if this value does not match the value currently
		/// in the database then an update has occured since this user loaded the 
		/// browser page and will cause an integrity constraint failure
		/// </param>
		/// <param name="externalID">Users external ID in the organisations other data stores</param>
		/// <remarks>
		/// Assumptions: All relevant user/password validation has already occurred
		/// in the validation on the web page
		/// Notes: 
		/// Author: John Crawford
		/// Date: 18/02/2004
		/// Changes.
		/// </remarks>
		public void UpdateUser(int userID, int unitID, string firstName, string lastName, 
			string userName, string email, bool active, int userTypeID,
            int updatedByUserID, string dateUpdated, string externalID, String standardName, string ManEmail
            , bool NotifyUnitAdmin, bool NotifyOrgAdmin, bool NotifyMgr, bool EbookNotification)
		{
                SqlInt32 TimeZoneID = 0;

                if (standardName != null)
                {
                    using (StoredProcedure sp = new StoredProcedure("prcTimeZone_GetTZIDfromFLBName", StoredProcedure.CreateInputParam("@FLBName", SqlDbType.NVarChar, standardName)))
                    {
                        TimeZoneID = Convert.ToInt32(sp.ExecuteScalar());
                    }
                }
                
                using(StoredProcedure sp = new StoredProcedure("prcUser_Update",
					  StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID),
					  StoredProcedure.CreateInputParam("@unitID", SqlDbType.Int, ((unitID == 0) ? SqlInt32.Null : unitID)),
					  StoredProcedure.CreateInputParam("@firstName", SqlDbType.NVarChar,50,firstName),
					  StoredProcedure.CreateInputParam("@lastName", SqlDbType.NVarChar,50,lastName),
					  StoredProcedure.CreateInputParam("@userName", SqlDbType.NVarChar,50,userName),
					  StoredProcedure.CreateInputParam("@email", SqlDbType.NVarChar,100,email),
					  StoredProcedure.CreateInputParam("@active", SqlDbType.Bit, active),
					  StoredProcedure.CreateInputParam("@userTypeID", SqlDbType.Int, userTypeID),
					  StoredProcedure.CreateInputParam("@updatedByUserID", SqlDbType.Int, updatedByUserID),
					  StoredProcedure.CreateInputParam("@dateUpdated", SqlDbType.DateTime, dateUpdated),
					  StoredProcedure.CreateInputParam("@externalID", SqlDbType.NVarChar,50,externalID),
                      StoredProcedure.CreateInputParam("@TimeZoneID", SqlDbType.Int, ((standardName == null) ? SqlInt32.Null : TimeZoneID)),
   					  StoredProcedure.CreateInputParam("@DelinquencyManagerEmail", SqlDbType.NVarChar,100,ManEmail),
                      StoredProcedure.CreateInputParam("@NotifyUnitAdmin", SqlDbType.Bit, NotifyUnitAdmin),
                      StoredProcedure.CreateInputParam("@NotifyOrgAdmin", SqlDbType.Bit,NotifyOrgAdmin),
                      StoredProcedure.CreateInputParam("@NotifyMgr", SqlDbType.Bit, NotifyMgr),
                      StoredProcedure.CreateInputParam("@EbookNotification", SqlDbType.Bit, EbookNotification)
                     ))
			{

				SqlDataReader rdr = sp.ExecuteReader();
				int intError;
				string strMessage;
				rdr.Read();
				intError = rdr.GetInt32(0);
				strMessage = rdr.GetString(1);
				rdr.Close();

				// Throw the required exception if error number is not 0.
				UserUpdateException(intError, strMessage);

				//-- LICENSING
				BusinessServices.CourseLicensing.LicenseAudit(userID, unitID);
			}
		} //Update

		

		/// <summary>
		///  Update a users details into the database - Administrator Password Change
		/// </summary>
		/// <param name="userID">User Id of the user being updated</param>
		/// <param name="unitID">Unit Id of the user being updated - may be 0 for
		/// salt administrators
		/// </param>
		/// <param name="firstName">First Name of the user being updated</param>
		/// <param name="lastName">Last Name of the user being update</param>
		/// <param name="userName">username of the user being update</param>
		/// <param name="email">Email Adress of the user being update</param>
		/// <param name="active">Active Status of the user being update</param>
		/// <param name="userTypeID">UserType IF of the user being update</param>
		/// <param name="updatedByUserID">User Id of the user doing the update</param>
		/// <param name="dateUpdated">date stamp for the previous dateUpdated,
		/// used as integrity check, if this value does not match the value currently
		/// in the database then an update has occured since this user loaded the 
		/// browser page and will cause an integrity constraint failure
		/// </param>
		/// <param name="Password">New Password for this user. 
		/// Administrator password change so only the new password is required
		/// </param>
		/// <param name="externalID">Users external ID in the organisations other data stores</param>
		/// <remarks>
		/// Assumptions: All relevant user/password validation has already occurred
		/// in the validation on the web page
		/// Notes: 
		/// Author: John Crawford
		/// Date: 18/02/2004
		/// Changes.
		/// </remarks>
		public void Update(int userID, int unitID, string firstName, string lastName, 
			string userName, string email, bool active, int userTypeID,
            int updatedByUserID, string dateUpdated, string Password, string externalID, String standardName, string ManEmail,
            bool NotifyUnitAdmin, bool NotifyOrgAdmin, bool NotifyMgr, bool EbookNotification)
		{

            SqlInt32 TimeZoneID = 0;

            if (standardName != null)
            {
                using (StoredProcedure sp = new StoredProcedure("prcTimeZone_GetTZIDfromFLBName", StoredProcedure.CreateInputParam("@FLBName", SqlDbType.NVarChar, standardName)))
                {
                    TimeZoneID = Convert.ToInt32(sp.ExecuteScalar());
                }
            }
            using (StoredProcedure sp = new StoredProcedure("prcUser_Update",
					  StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID),
					  StoredProcedure.CreateInputParam("@unitID", SqlDbType.Int, unitID),
					  StoredProcedure.CreateInputParam("@firstName", SqlDbType.NVarChar,50,firstName),
					  StoredProcedure.CreateInputParam("@lastName", SqlDbType.NVarChar,50,lastName),
					  StoredProcedure.CreateInputParam("@userName", SqlDbType.NVarChar,50,userName),
					  StoredProcedure.CreateInputParam("@email", SqlDbType.NVarChar,100,email),
					  StoredProcedure.CreateInputParam("@active", SqlDbType.Bit, active),
					  StoredProcedure.CreateInputParam("@userTypeID", SqlDbType.Int, userTypeID),
					  StoredProcedure.CreateInputParam("@updatedByUserID", SqlDbType.Int, updatedByUserID),
					  StoredProcedure.CreateInputParam("@dateUpdated", SqlDbType.DateTime, dateUpdated),
					  StoredProcedure.CreateInputParam("@Password", SqlDbType.NVarChar,50,Password),
					  StoredProcedure.CreateInputParam("@externalID", SqlDbType.NVarChar,50,externalID),
                      StoredProcedure.CreateInputParam("@TimeZoneID", SqlDbType.Int, ((standardName == null) ? SqlInt32.Null : TimeZoneID)),
                      StoredProcedure.CreateInputParam("@DelinquencyManagerEmail", SqlDbType.NVarChar, 100, ManEmail),
                      StoredProcedure.CreateInputParam("@NotifyUnitAdmin", SqlDbType.Bit, NotifyUnitAdmin),
                      StoredProcedure.CreateInputParam("@NotifyOrgAdmin", SqlDbType.Bit, NotifyOrgAdmin),
                      StoredProcedure.CreateInputParam("@NotifyMgr", SqlDbType.Bit, NotifyMgr),
                      StoredProcedure.CreateInputParam("@EbookNotification", SqlDbType.Bit, EbookNotification)
                      ))
			{
				SqlDataReader rdr = sp.ExecuteReader();
				int intError;
				string strMessage;
				rdr.Read();
				intError = rdr.GetInt32(0);
				strMessage = rdr.GetString(1);
				rdr.Close();
				
				// Throw the required exception if error number is not 0.
				UserUpdateException(intError, strMessage);

				//-- LICENSING
				BusinessServices.CourseLicensing.LicenseAudit(userID, unitID);
			}
		} //Update
		
		/// <summary>
		/// Update a users details into the database - Salt User Password Change
		/// </summary>
		/// <param name="userID">User Id of the user being updated</param>
		/// <param name="unitID">Unit Id of the user being updated - may be 0 for
		/// salt administrators
		/// </param>
		/// <param name="firstName">First Name of the user being updated</param>
		/// <param name="lastName">Last Name of the user being update</param>
		/// <param name="userName">username of the user being update</param>
		/// <param name="email">Email Adress of the user being update</param>
		/// <param name="active">Active Status of the user being update</param>
		/// <param name="userTypeID">UserType IF of the user being update</param>
		/// <param name="updatedByUserID">User Id of the user doing the update</param>
		/// <param name="dateUpdated">date stamp for the previous dateUpdated,
		/// used as integrity check, if this value does not match the value currently
		/// in the database then an update has occured since this user loaded the 
		/// browser page and will cause an integrity constraint failure
		/// </param>
		/// 
		/// <param name="Password">New Password for this user. 
		/// Administrator password change so only the new password is required
		/// </param>
		/// <param name="OldPassword">Old password that should be in the database. 
		/// Returns an error if the old password passed in does not match the password
		/// previously stored in the database.
		/// </param>
		/// <param name="externalID">Users external ID in the organisations other data stores</param>
		/// <remarks>
		/// Assumptions: All relevant user/password validation has already occurred
		/// in the validation on the web page
		/// Notes: 
		/// Author: John Crawford
		/// Date: 18/02/2004
		/// Changes.
		/// </remarks>
		public void Update(int userID, int unitID, string firstName, string lastName, 
			string userName, string email, bool active, int userTypeID, 
			int updatedByUserID, string dateUpdated, string Password, string OldPassword, string externalID, String standardName, string ManEmail,
            bool NotifyUnitAdmin, bool NotifyOrgAdmin, bool NotifyMgr, bool EbookNotification)
		{
            SqlInt32 TimeZoneID = 0;

            if (standardName != null)
            {
                using (StoredProcedure sp = new StoredProcedure("prcTimeZone_GetTZIDfromFLBName", StoredProcedure.CreateInputParam("@FLBName", SqlDbType.NVarChar, standardName)))
                {
                    TimeZoneID = Convert.ToInt32(sp.ExecuteScalar());
                }
            }

			using(StoredProcedure sp = new StoredProcedure("prcUser_Update",
					  StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID),
					  StoredProcedure.CreateInputParam("@unitID", SqlDbType.Int, unitID),
					  StoredProcedure.CreateInputParam("@firstName", SqlDbType.NVarChar,50,firstName),
					  StoredProcedure.CreateInputParam("@lastName", SqlDbType.NVarChar,50,lastName),
					  StoredProcedure.CreateInputParam("@userName", SqlDbType.NVarChar,50,userName),
					  StoredProcedure.CreateInputParam("@email", SqlDbType.NVarChar,100,email),
					  StoredProcedure.CreateInputParam("@active", SqlDbType.Bit, active),
					  StoredProcedure.CreateInputParam("@userTypeID", SqlDbType.Int, userTypeID),
					  StoredProcedure.CreateInputParam("@updatedByUserID", SqlDbType.Int, updatedByUserID),
					  StoredProcedure.CreateInputParam("@dateUpdated", SqlDbType.DateTime, dateUpdated),
					  StoredProcedure.CreateInputParam("@Password", SqlDbType.NVarChar,50,Password),
					  StoredProcedure.CreateInputParam("@OldPassword", SqlDbType.NVarChar,50,OldPassword),
					  StoredProcedure.CreateInputParam("@externalID", SqlDbType.NVarChar,50,externalID),
                      StoredProcedure.CreateInputParam("@TimeZoneID", SqlDbType.Int, ((standardName == null) ? SqlInt32.Null : TimeZoneID)),
                      StoredProcedure.CreateInputParam("@DelinquencyManagerEmail", SqlDbType.NVarChar, 100, ManEmail),
                      StoredProcedure.CreateInputParam("@NotifyUnitAdmin", SqlDbType.Bit, NotifyUnitAdmin),
                      StoredProcedure.CreateInputParam("@NotifyOrgAdmin", SqlDbType.Bit, NotifyOrgAdmin),
                      StoredProcedure.CreateInputParam("@NotifyMgr", SqlDbType.Bit, NotifyMgr),
                      StoredProcedure.CreateInputParam("@EbookNotification", SqlDbType.Bit, EbookNotification)
                      ))
			{
				SqlDataReader rdr = sp.ExecuteReader();
				int intError;
				string strMessage;
				rdr.Read();
				intError = rdr.GetInt32(0);
				strMessage = rdr.GetString(1);
				rdr.Close();
				

				// Throw the required exception if error number is not 0.
				UserUpdateException(intError, strMessage);

				//-- LICENSING
				BusinessServices.CourseLicensing.LicenseAudit(userID, unitID);
			}
		}  //Update






		// Update - overloaded
		//==========================================================================
		// 1. No password change
		// 2. Password change by Administrator
		// 3. Password Change by Salt User
		// 4. Unit changed 
		// 5. Unit changed (All unassigned users)
		/// <summary>
		/// Update a users unit into the database
		/// </summary>
		/// <param name="userID">The User to Update</param>
		/// <param name="unitID">The Users new Unit ID</param>
		/// <param name="updatedByUserID">The User ID of the user performing the action</param>
		/// <param name="organisationID">The Organisation ID of the new user</param>
		public void Update(int userID, int unitID, int updatedByUserID, int organisationID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUser_AssignUnit",
					  StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID),
					  StoredProcedure.CreateInputParam("@unitID", SqlDbType.Int, unitID),
					  StoredProcedure.CreateInputParam("@updatedByUserID", SqlDbType.Int, updatedByUserID),
					  StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID)
					  ))
			{
				SqlDataReader rdr = sp.ExecuteReader();
				int intError;
				string strMessage;
				rdr.Read();
				intError = rdr.GetInt32(0);
				strMessage = rdr.GetString(1);
				rdr.Close();

				// Throw the required exception if error number is not 0.
				UserUpdateException(intError, strMessage);

				//-- LICENSING
				BusinessServices.CourseLicensing.LicenseAudit(userID, unitID);
			}
		} //Update

		private void UserUpdateException(int intError, string strMessage)
		{
			// Throw the required exception if error number is not 0.
			switch(intError)
			{
				case 0: // Succeeded.
				{
					break;
				}
				case 1:
				case 11:
				{
					throw new RecordNotFoundException(ResourceManager.GetString("cmnRecordNotExist"));
				}
				case 4:
				case 43:
				case 41:// Unique constraint.
				{
					throw new UniqueViolationException(string.Format(ResourceManager.GetString("prcUser_Update." + intError.ToString()), strMessage));
				}
				case 42:
				{
					throw new UniqueViolationException(string.Format(ResourceManager.GetString("prcUser_Update." + intError.ToString()), strMessage));
				}
				case 5: // Parameter Exception.
				{
					throw new ParameterException(string.Format(ResourceManager.GetString("prcUser_Update." + intError.ToString()), strMessage));
				}
				case 7: // Integrity Violation.
				{
					throw new IntegrityViolationException(ResourceManager.GetString("prcUser_Update." + intError.ToString()));
				}
				default: // Whatever is left.
				{
					throw new BusinessServiceException(ResourceManager.GetString("prcUser_Update." + intError.ToString()));
				}
			}
		}




		/// <summary>
		/// Updates the classifications for a user id.
		/// </summary>
		/// <param name="userID"></param>
		/// <param name="values">Comma separated list of clasification IDs</param>
		/// <remarks>Note:
		/// Procedure will insert a row for each item in the comma seperated list
		/// Does not check for duplicates so could raise integrity constaint failure
		/// </remarks>
		public void ClassificationUpdate(int userID, string values)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUser_ClassificationUpdate",
					  StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID),
					  StoredProcedure.CreateInputParam("@values", SqlDbType.NVarChar,4000,values)
					  ))
			{
				SqlDataReader rdr = sp.ExecuteReader();
				int intError;
				string strMessage;
				rdr.Read();
				intError = rdr.GetInt32(0);
				strMessage = rdr.GetString(1);
				rdr.Close();
				

				// Throw the required exception if error number is not 0.
				switch(intError)
				{
					case 0: // Succeeded.
					{
						break;
					}
					case 1:
					{
						throw new RecordNotFoundException(ResourceManager.GetString("cmnRecordNotExist"));
					}
					case 4: // Unique constraint.
					{
						throw new UniqueViolationException(strMessage);
					}
					case 5: // Parameter Exception.
					{
						throw new ParameterException(strMessage);
					}
					case 7: // Integrity Violation.
					{
						throw new IntegrityViolationException(strMessage);
					}
					default: // Whatever is left.
					{
						throw new BusinessServiceException(strMessage);
					}
				}
			}
		} // ClassificationUpdate - update version 3

		/// <summary>
		/// Get user type
		/// </summary>
		/// <param name="userID"></param>
		/// <returns></returns>
		public  UserType GetUserType(int userID)
		{
			int intUserTypeID;

			SqlParameter prmUserType = StoredProcedure.CreateOutputParam("@userTypeID",SqlDbType.Int);

			using(StoredProcedure sp = new StoredProcedure("prcUser_GetUserType",
					  StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID),
					  prmUserType
					  ))
			{
				sp.ExecuteNonQuery();
                if (prmUserType.Value.ToString().Equals("")) throw new RecordNotFoundException(ResourceManager.GetString("Error determining administrative permissions for user " + userID.ToString() + ", prcUser_GetUserType returned null!"));


                intUserTypeID = (int)prmUserType.Value;
				return (UserType)intUserTypeID;
			}
		} //GetUserType

		/// <summary>
		/// Get the admin user permission to a specific user
		/// </summary>
		/// <param name="userID">ID of the user details that is accessed</param>
		/// <param name="adminUserID">The user who is granted permission</param>
		/// <returns>Permission:
		///		'F': Full permission
		///		'' : No permission
		/// </returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 09/03/2004
		/// Changes:
		/// </remarks>
		public string GetPermission(int userID, int adminUserID)
		{
			string  strPermission;

			SqlParameter prmPermission = StoredProcedure.CreateOutputParam("@Permission",SqlDbType.Char, 1);

			using(StoredProcedure sp = new StoredProcedure("prcUser_GetPermission",
					  StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID),
					  StoredProcedure.CreateInputParam("@adminUserID", SqlDbType.Int, adminUserID),
					  prmPermission
					  ))
			{
				sp.ExecuteNonQuery();
				strPermission = (string)prmPermission.Value ;
				return strPermission.Trim();
			}
		}

		public DataTable GetArchiveUsers(SqlDateTime fromDate, int inclNewUsers, int orgID, int UserID)
		{
			DataTable dt = null;
			using(StoredProcedure sp = new StoredProcedure("prcUser_GetArchiveUsers",
					  StoredProcedure.CreateInputParam("@fromDate",SqlDbType.DateTime,fromDate),
					  StoredProcedure.CreateInputParam("@inclNewUsers",SqlDbType.Int,inclNewUsers),
					  StoredProcedure.CreateInputParam("@orgID" , SqlDbType.Int, orgID),
					  StoredProcedure.CreateInputParam("@UserID" , SqlDbType.Int, UserID))
					  )
			{
				dt = sp.ExecuteTable();

			}
			
			return dt;

		}

		public void ArchiveUsers(string userIDs, int updatedBy)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUser_ArchiveUsers",
					  StoredProcedure.CreateInputParam("@userIDs",SqlDbType.VarChar,1000,userIDs),
					  StoredProcedure.CreateInputParam("@updatedBy",SqlDbType.Int,updatedBy))
					  )
			{
				sp.ExecuteNonQuery();
			}
		}
		public void ImportUser(SqlString userName, SqlString password, SqlString firstName, SqlString lastName, SqlString email, SqlInt32 unitID, SqlString classificationName,SqlString classificationOption, SqlString externalID, SqlInt32 archival, SqlBoolean isUpdate, SqlInt32 uniqueField, SqlInt32 userID, SqlInt32 orgID, SqlString NotifyUnitAdmin,SqlString NotifyOrgAdmin,SqlString ManagerNotification,SqlString ManagerToNotify)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUser_Import",
					  StoredProcedure.CreateInputParam("@userName", SqlDbType.NVarChar,200,userName),
					  StoredProcedure.CreateInputParam("@password", SqlDbType.NVarChar,100,password),
					  StoredProcedure.CreateInputParam("@firstName", SqlDbType.NVarChar,200,firstName),
					  StoredProcedure.CreateInputParam("@lastName", SqlDbType.NVarChar,200,lastName),
					  StoredProcedure.CreateInputParam("@email", SqlDbType.NVarChar,255,email),
					  StoredProcedure.CreateInputParam("@unitID", SqlDbType.Int,unitID),
					  StoredProcedure.CreateInputParam("@classificationName", SqlDbType.NVarChar,100,classificationName),
					  StoredProcedure.CreateInputParam("@classificationOption", SqlDbType.NVarChar,100,classificationOption),
					  StoredProcedure.CreateInputParam("@externalID", SqlDbType.NVarChar,100,externalID),
					  StoredProcedure.CreateInputParam("@archival", SqlDbType.Int,archival),
					  StoredProcedure.CreateInputParam("@isUpdate", SqlDbType.Bit,isUpdate),
					  StoredProcedure.CreateInputParam("@uniqueField", SqlDbType.Int, uniqueField),
					  StoredProcedure.CreateInputParam("@userID",SqlDbType.Int,userID),
					  StoredProcedure.CreateInputParam("@orgID", SqlDbType.Int,orgID),
                      StoredProcedure.CreateInputParam("@NotifyUnitAdmin", SqlDbType.NVarChar,3,NotifyUnitAdmin),
                      StoredProcedure.CreateInputParam("@NotifyOrgAdmin", SqlDbType.NVarChar,3,NotifyOrgAdmin),
                      StoredProcedure.CreateInputParam("@ManagerNotification", SqlDbType.NVarChar,3,ManagerNotification),
                      StoredProcedure.CreateInputParam("@ManagerToNotify", SqlDbType.NVarChar,255,ManagerToNotify)
					  ))
			{
				sp.ExecuteNonQuery();	
			}
		}

		public DataTable GetProfilePeriodList(int UserID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			string strSQL = @"select p.ProfileID, p.ProfileName ";
			strSQL = strSQL + @"from tblProfile p ";
			strSQL = strSQL + @"join tblProfilePeriod pp on p.ProfileID = pp.profileID ";
			strSQL = strSQL + @"join tblUserProfilePeriodAccess uppa on uppa.ProfilePeriodID = pp.ProfilePeriodID ";
			strSQL = strSQL + @"join tblOrganisationFeatureAccess ofa on p.organisationid = ofa.organisationid and ofa.featurename='cpd profile' ";
			strSQL = strSQL + @"where userID = " + UserID;
			strSQL = strSQL + @" and profileperiodactive = 1 ";
			strSQL = strSQL + @"and uppa.granted = 1 and getutcdate() between datestart and dateadd(d,1,dateend) order by ProfileName";
			DataTable dtInitialPeriod = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
			return dtInitialPeriod;

		}

        public DataTable GetUserQuizStatusID(int UserID,int ModuleID)
        {
            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
            string strSQL = @"select top 1 QuizStatusID,UserQuizStatusID,QuizSessionID from tblUserQuizStatus where UserID=" + UserID + " and ModuleID=" + ModuleID + " order by DateCreated desc";
            DataTable dtInitialPeriod = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
            return dtInitialPeriod;

        }

        public void UpdateQuizSessionOnExpiry(int UserQuizStatusID, Guid QuizSessionID)
        {
            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

            string strSQL = @"update tblUserQuizStatus ";
            strSQL = strSQL + @" set QuizSessionID = '" + QuizSessionID.ToString()+"'"  ;
            strSQL = strSQL + @" where UserQuizStatusID = " + UserQuizStatusID;

            SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, strSQL);
        }

		public DataTable GetProfilePeriodDetail(int ProfileID, int UserID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			string strSQL = @"select ";
            strSQL = strSQL + @"convert(varchar(11),dbo.udfUTCtoDaylightSavingTime(pp.DateStart,OrganisationID),103) + ' - ' + convert(varchar(11),pp.DateEnd, 103) as Period, ";
			strSQL = strSQL + @"pp.points ";
			strSQL = strSQL + @"from tblProfile p ";
			strSQL = strSQL + @"join tblProfilePeriod pp on p.ProfileID = pp.profileID ";
			strSQL = strSQL + @"join tblUserProfilePeriodAccess uppa on uppa.ProfilePeriodID = pp.ProfilePeriodID ";
			strSQL = strSQL + @"where userID = " + UserID;
			strSQL = strSQL + @" and p.ProfileID = " + ProfileID;
			strSQL = strSQL + @" and pp.profileperiodactive = 1 ";
            strSQL = strSQL + @"and uppa.granted = 1";
			DataTable dtPeriodDetail = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
			return dtPeriodDetail;
		}

        public String getPoliciesAssignedToUser(int UserID, int OrganisationID)
        {
            string strSQL =  @"	select pol.policyname as pol_name from ";
            strSQL = strSQL + @"		tblPolicy pol ";
            strSQL = strSQL + @"		join tblOrganisationFeatureAccess ofa on ofa.organisationid = pol.organisationid and ofa.featurename='policy' ";
            strSQL = strSQL + @"        join tblUserPolicyAccess upa on upa.policyid = pol.policyid";
            strSQL = strSQL + @"        and upa.userid = " + UserID + " ";
            strSQL = strSQL + @"		where pol.organisationid = " + OrganisationID + " ";
            strSQL = strSQL + @"        and upa.granted = 1";
            strSQL = strSQL + @"		and deleted = 0 and Active =1 ";


            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
            DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
            
            string strPolicies = "";

            foreach (DataRow dr in dt.Rows)
            {
                strPolicies += dr["pol_name"].ToString() + "<br />";
            }


            return strPolicies;
        }

		public DataTable GetUserPolicyStatus(int ProfileID, int UserID, int OrganisationID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			
			string strSQL = String.Empty;
			if(ProfileID == -1)
			{
				strSQL = @"create table #policy (policyid int, policyname nvarchar(255), points numeric(10,1)) ";
				
				strSQL = strSQL + @"insert into #policy ";
				strSQL = strSQL + @"	select pol.policyid, pol.policyname, 0 as points from ";
				strSQL = strSQL + @"		tblPolicy pol ";
				strSQL = strSQL + @"		join tblOrganisationFeatureAccess ofa on ofa.organisationid = pol.organisationid and ofa.featurename='policy' ";
				strSQL = strSQL + @"        join tblUserPolicyAccess upa on upa.policyid = pol.policyid";
				strSQL = strSQL + @"        and upa.userid = " + UserID + " ";
				strSQL = strSQL + @"		where pol.organisationid = " + OrganisationID + " ";
				strSQL = strSQL + @"        and upa.granted = 1";
				strSQL = strSQL + @"		and deleted = 0 and Active =1 ";
				
				strSQL = strSQL + @"create table #UserPolicyAccepted (policyID int, policystatus bit, userid int) ";
				
				strSQL = strSQL + @"insert into #UserPolicyAccepted select policyid, accepted as policystatus, ";
				strSQL = strSQL + @"userid from tblUserPolicyAccepted where userid = " + UserID + " ";
				
				strSQL = strSQL + @"select p.policyid, p.policyname, case when upa.policystatus is null then 0 ";
				strSQL = strSQL + @"else upa.policystatus end as policystatus, p.points from ";
				strSQL = strSQL + @"#policy p left outer join #UserPolicyAccepted upa ";
                strSQL = strSQL + @"on p.policyid = upa.policyid ";
                strSQL = strSQL + @"order by p.policyname ";

				strSQL = strSQL + @"drop table #Policy ";
				strSQL = strSQL + @"drop table #UserPolicyAccepted ";
			}
			else
			{
				strSQL = @"select ";
				strSQL = strSQL + @"pol.PolicyID, ";
				strSQL = strSQL + @"pol.PolicyName, ";
				strSQL = strSQL + @"case when upa.accepted is null then 0 else upa.accepted end as PolicyStatus, ";
				strSQL = strSQL + @"case when ucp.points <> 0 then 0 else coalesce(ppts.points, 0) end as points ";
				strSQL = strSQL + @"from tblProfile p ";
				strSQL = strSQL + @"join tblProfilePeriod pp ";
				strSQL = strSQL + @"on p.ProfileID = pp.ProfileID ";
				strSQL = strSQL + @"join tblUserProfilePeriodAccess uppa ";
				strSQL = strSQL + @"on pp.ProfilePeriodID = uppa.ProfilePeriodID and pp.profileperiodactive = 1 ";
				strSQL = strSQL + @"join tblProfilePoints ppts ";
				strSQL = strSQL + @"on pp.ProfilePeriodID = ppts.ProfilePeriodID ";
				strSQL = strSQL + @"join tblPolicy pol ";
				strSQL = strSQL + @"on ppts.TypeID = pol.PolicyID ";
				strSQL = strSQL + @"left outer join tblUserPolicyAccepted upa ";
				strSQL = strSQL + @"on pol.PolicyID = upa.PolicyID and upa.userid = " + UserID + " ";
				strSQL = strSQL + @"left outer join tblUserCPDPoints ucp ";
				strSQL = strSQL + @"on ppts.ProfilePointsID = ucp.ProfilePointsID and ucp.userid = " + UserID + " ";
				strSQL = strSQL + @"join tblOrganisationFeatureAccess ofa ";
				strSQL = strSQL + @"on ofa.organisationid = pol.organisationid and ofa.featurename = 'policy' ";
				strSQL = strSQL + @"join tblUserPolicyAccess upola ";
				strSQL = strSQL + @"on upola.policyid = pol.policyid ";
				strSQL = strSQL + @" and upola.userid = " + UserID;
				strSQL = strSQL + @" where p.ProfileID = "  + ProfileID;
				strSQL = strSQL + @" and uppa.UserID = " + UserID;
				strSQL = strSQL + @" and pol.OrganisationID = " + OrganisationID;
				strSQL = strSQL + @" and upola.granted = 1 ";
				
				strSQL = strSQL + @" and ProfilePointsType = 'P' and pol.deleted = 0 and pol.active = 1";
			}
			DataTable dtUserPolicyStatus = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
			return dtUserPolicyStatus;
		}

		public DataTable GetUserCourseList(int ProfileID, int UserID)
		{
            			string currentCulture = ResourceManager.CurrentCultureName;

			using(StoredProcedure sp = new StoredProcedure("prcUser_GetCourseList",
					  StoredProcedure.CreateInputParam("@UserID",SqlDbType.Int,UserID),
					  StoredProcedure.CreateInputParam("@ProfileID",SqlDbType.Int,ProfileID),
                      StoredProcedure.CreateInputParam("@CurrentCultureName", SqlDbType.NVarChar, 50, currentCulture)
					  ))
			{
				DataTable dtCourseStatus = sp.ExecuteTable();
				return dtCourseStatus;
			}			
		}

		public DataTable GetUserPointsEarned(int ProfileID, int UserID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			string strSQL = @"select ";
			strSQL = strSQL + @"case when sum(ucp.points) is null then 0.0 else sum(ucp.points) end as PointsEarned from ";
			strSQL = strSQL + @"tblUserCPDPoints ucp ";
			strSQL = strSQL + @"join tblProfilePoints ppts ";
			strSQL = strSQL + @"on ppts.ProfilePointsID = ucp.ProfilePointsID ";
			strSQL = strSQL + @"join tblProfilePeriod pp ";
			strSQL = strSQL + @"on ppts.ProfilePeriodID = pp.ProfilePeriodID and pp.profileperiodactive = 1";
			strSQL = strSQL + @"where ucp.UserID = " + UserID;
			strSQL = strSQL + @" and pp.ProfileID = " + ProfileID;
			strSQL = strSQL + @" and ucp.dateAssigned <= dateadd(d,1,pp.dateend) ";
			strSQL = strSQL + @"and ucp.dateAssigned >= pp.datestart ";

			DataTable dtUserPointsEarned = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
			return dtUserPointsEarned;

		}

		public void UpdateLoginAttempts(int UserID, int NewLoginAttempts)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			string strSQL = @"update tblUser ";
			strSQL = strSQL + @"set LoginFailCount = " + NewLoginAttempts + " ";
			strSQL = strSQL + @"where UserID = " + UserID;

			SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, strSQL);
		}

		public bool UserIsPasswordLocked(int UserID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			string strSQL = @"select LoginFailCount from tblUser where UserID = " + UserID;

			DataTable dtUserIsPasswordLocked = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
			int intLoginFailCount = int.Parse(dtUserIsPasswordLocked.Rows[0]["LoginFailCount"].ToString());
			if (intLoginFailCount >= 3)
			{
				return true;
			}
			else
			{
				return false;
			}
		}

		public bool UserUnitAdminCanPropagate(int UserID, int UnitID)
		{	
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			string strSQL = @"select propagate from tblUnitAdministrator where UserID = " + UserID + " ";
			strSQL = strSQL + @"and UnitID = " + UnitID;

			DataTable dtUserUnitAdminCanPropagate = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];

			return bool.Parse(dtUserUnitAdminCanPropagate.Rows[0]["propagate"].ToString());

		}

		public bool DisplayUnitIsSub(int UnitID, int DisplayUnitID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			string strSQL = @"select * from tblUnit where UnitID = " + DisplayUnitID + " ";
			strSQL = strSQL + @"and convert(nvarchar(4000), Hierarchy) like '%" + UnitID + "%'";

			DataTable dtDisplayUnitIsSub = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];

			if (dtDisplayUnitIsSub.Rows.Count > 0)
			{
				return true;
			}
			else
			{
				return false;
			}
		}

		public DataTable UnitsUserAdministrates(int UserID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			string strSQL = @"select UnitID, Propagate from tblUnitAdministrator where UserID = " + UserID;

			DataTable dtUnitsUserAdministrates = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
			return dtUnitsUserAdministrates;
		}

		public void UpdateUserProfilePeriodAccess(int UserID, int UnitID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			string strSQL = @"update tblUserProfilePeriodAccess ";
			strSQL = strSQL + @"set granted = unitppa.granted ";
			strSQL = strSQL + @"from tblUnitProfilePeriodAccess unitppa ";
			strSQL = strSQL + @"join tblUserProfilePeriodAccess userppa ";
			strSQL = strSQL + @"on unitppa.profileperiodid = userppa.profileperiodid ";
			strSQL = strSQL + @"where userid = " + UserID + " ";
			strSQL = strSQL + @"and UnitID = " + UnitID;

			SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, strSQL);
		}

		public void UpdateUserPolicyAccess(int UserID, int UnitID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			string strSQL = @"update tblUserPolicyAccess ";
			strSQL = strSQL + @"set granted = unitpa.granted ";
			strSQL = strSQL + @"from tblUnitPolicyAccess unitpa ";
			strSQL = strSQL + @"join tblUserPolicyAccess userpa ";
			strSQL = strSQL + @"on unitpa.policyid = userpa.policyid ";
			strSQL = strSQL + @"where userid = " + UserID + " ";
			strSQL = strSQL + @"and UnitID = " + UnitID;

			SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, strSQL);
		}

		public bool ImportCheck(int UniqueField, string Value, int OrganisationID, string UserName)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			string strSQL = String.Empty;

			switch (UniqueField)
			{
				// email is selected as the unique field // currently not used
				case 1:
					strSQL += @"select * from tblUser where username = '" + Value + "' ";
					strSQL += @"and organisationid = " + OrganisationID;
					break;
				// user name is selected as the unique field
				case 2:
					strSQL += @"select * from tblUser where email = '" + Value + "' ";
					strSQL += @"and organisationid = " + OrganisationID + " and username <>'" + UserName + "'" ;
					break;
			}

			DataTable dtImportCheck = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
			if(dtImportCheck.Rows.Count > 0)
			{
				return true;
			}
			else
			{
				return false;
			}
		}

        public int GetIdFromUsername(string userName)
        {
            using (StoredProcedure sp = new StoredProcedure("prcUser_GetIdFromUsername",
                StoredProcedure.CreateInputParam("@Username", SqlDbType.NVarChar, userName)
                ))
            {
                return ((int) sp.ExecuteScalar());
            }
        }

        public int GetIdFromEmail(string email)
        {
            using (StoredProcedure sp = new StoredProcedure("prcUser_GetIdFromEmail",
                StoredProcedure.CreateInputParam("@Email", SqlDbType.NVarChar, email)
                ))
            {
                return ((int)sp.ExecuteScalar());
            }
        }


        public void LogEbookDownload(int userID, int ebookID, string userAgent, string result)
        {
            using (StoredProcedure sp = new StoredProcedure("prcUserEbook_Add",
                     StoredProcedure.CreateInputParam("@userid", SqlDbType.Int, userID),
                     StoredProcedure.CreateInputParam("@ebookid", SqlDbType.Int, ebookID),
                     StoredProcedure.CreateInputParam("@userAgent", SqlDbType.NVarChar, 1000, userAgent),
                     StoredProcedure.CreateInputParam("@result", SqlDbType.NVarChar, 100, result)))
            {
                sp.ExecuteNonQuery();
            }
        }

        public void UpdateEbookNotify(int userEbookID)
        {
            using (StoredProcedure sp = new StoredProcedure("prcUserEbook_UpdateNotify",
                     StoredProcedure.CreateInputParam("@userebookid", SqlDbType.Int, userEbookID)
                     ))
            {
                sp.ExecuteNonQuery();
            }
        }

        public void UpdateEncryptedPassword(string username, string encryptedPassword)
        {
            using (StoredProcedure sp = new StoredProcedure("prcUser_UpdateEncryptedPassword",
                StoredProcedure.CreateInputParam("@UserName", SqlDbType.NVarChar, username),
                StoredProcedure.CreateInputParam("@EncryptedPassword", SqlDbType.NVarChar, encryptedPassword)))
            {
                sp.ExecuteNonQuery();
            }
        }
		#endregion
	}
}
