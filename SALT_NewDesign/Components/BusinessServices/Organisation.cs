//===============================================================================
//
//	Salt Business Service Layer
//
//	Bdw.Application.Salt.Data.Organisation
//
//  Retrieves and updates organisation information
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
    /// Retrieves and updates organisation information.
    /// </summary>
    /// <remarks>
    /// Assumptions: None
    /// Notes: 
    /// Author: Peter Vranich, 28/01/0/2004
    /// Changes:
    /// </remarks>
    public class Organisation : Bdw.Application.Salt.Data.DatabaseService
    {
        /// <summary>
        /// Gets a list of Organisations.
        /// </summary>
        /// <returns>Returns a DataTable with the details of all Organisations in the SALT database.</returns>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Peter Vranich, 28/01/0/2004
        /// Changes:
        /// </remarks>
        public DataTable GetOrganisationList()
        {
            using (StoredProcedure sp = new StoredProcedure("prcOrganisation_GetList"))
            {
                return sp.ExecuteTable();
            }
        }
        public DataTable GetOrganisationList228(string connectionString)
        {
            SqlCommand cmd = new SqlCommand();
            SqlConnection con = new SqlConnection(connectionString);
            SqlDataAdapter da = new SqlDataAdapter();
            DataTable dt = new DataTable();
            try
            {
                cmd = new SqlCommand("prcOrganisation_GetList", con);
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
            //using (StoredProcedure sp = new StoredProcedure("prcOrganisation_GetList"))
            //{
            //    return sp.ExecuteTable();
            //}
        }

        public DataTable GetOrganisationPolicyList(int OrganisationID)
        {
            using (StoredProcedure sp = new StoredProcedure("prcOrganisation_GetPolicyList", StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, OrganisationID)))
            {
                return sp.ExecuteTable();
            }
        }

        public DataTable GetOrganisationPolicies(int OrganisationID)
        {
            using (StoredProcedure sp = new StoredProcedure("prcOrganisation_GetPolicies",
                       StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, OrganisationID)))
            {
                return sp.ExecuteTable();
            }
        }

        public DataTable GetOrganisationProfiles(int OrganisationID)
        {
            using (StoredProcedure sp = new StoredProcedure("prcOrganisation_GetProfiles",
                       StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, OrganisationID)))
            {
                return sp.ExecuteTable();
            }
        }

        public bool ShowLastPassed(int OrganisationID)
        {
            using (StoredProcedure sp = new StoredProcedure("prcOrganisation_EnabledLastPassed", StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, OrganisationID)))
            {
                bool ShowLastPassed = (bool)sp.ExecuteScalar();
                return ShowLastPassed;
            }
        }

        public static bool GetDisablePasswordField(int OrganisationID)
        {
            using (StoredProcedure sp = new StoredProcedure("prcOrganisation_CheckDisabledPasswordField", StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, OrganisationID)))
            {
                bool DisablePasswordField = (bool)sp.ExecuteScalar();
                return DisablePasswordField;
            }
        }

        public static bool GetDefaultEbookEmailNotification(int OrganisationID)
        {
            using (StoredProcedure sp = new StoredProcedure("prcOrganisation_DefaultEbookEmailNotification", StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, OrganisationID)))
            {
                bool DefaultEbookEmailNotification = (bool)sp.ExecuteScalar();
                return DefaultEbookEmailNotification;
            }
        }

        /// <summary>
        /// Return all the organisations with their respective feature access
        /// </summary>
        /// <returns></returns>
        public DataTable GetAllOrganisationFeatureAccess()
        {
            using (StoredProcedure sp = new StoredProcedure("prcOrganisation_GetAllFeatureAccess"))
            {
                return sp.ExecuteTable();
            }
        }

        /// <summary>
        /// Return the organisation access to the specified feature name
        /// </summary>
        /// <param name="organisationID"></param>
        /// <param name="featureName"></param>
        /// <returns></returns>
        private bool GetOrganisationFeatureAccess(int organisationID, string featureName)
        {
            using (StoredProcedure sp = new StoredProcedure("prcOrganisation_GetFeatureAccess",
                    StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, organisationID),
                    StoredProcedure.CreateInputParam("@featureName", SqlDbType.NVarChar, 100, featureName)))
            {
                object result = sp.ExecuteScalar();
                if (result == null)
                    return false;
                else
                    return true;
            }
        }

        public DataTable GetOrganisationwithDomainName(string domainname)
        {
            using (StoredProcedure sp = new StoredProcedure("prcOrganisation_GetOne_WithDomainname",
                     StoredProcedure.CreateInputParam("@domainname", SqlDbType.NVarChar, 300, domainname)))
            {
                return sp.ExecuteTable();
            }
        }

        /// <summary>
        /// Update the organisation access
        /// </summary>
        /// <param name="organisationID"></param>
        /// <param name="featureName"></param>
        /// <param name="granted"></param>
        public void SaveOrganisationFeatureAccess(int organisationID, string featureName, int granted)
        {
            using (StoredProcedure sp = new StoredProcedure("prcOrganisation_UpdateFeatureAccess",
                      StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID),
                      StoredProcedure.CreateInputParam("@featurename", SqlDbType.NVarChar, 100, featureName),
                      StoredProcedure.CreateInputParam("@granted", SqlDbType.TinyInt, granted)
                      ))
            {
                sp.ExecuteNonQuery();
            }
        }

        /// <summary>
        /// Get the organisation access to CPD Profile
        /// </summary>
        /// <param name="OrganisationID"></param>
        /// <returns></returns>
        public bool GetOrganisationCPDAccess(int organisationID)
        {
            return GetOrganisationFeatureAccess(organisationID, "cpd profile");
        }
        //Madhuri CPD Event Start
        public bool GetOrganisationCPDEventAccess(int organisationID)
        {
            return GetOrganisationFeatureAccess(organisationID, "cpd event");
        }
        //Madhuri CPD Event End
        /// <summary>
        /// Get the organisation access to Policy
        /// </summary>
        /// <param name="OrganisationID"></param>
        /// <returns></returns>
        public bool GetOrganisationPolicyAccess(int OrganisationID)
        {
            return GetOrganisationFeatureAccess(OrganisationID, "policy");
        }

        /// <summary>
        /// Get the organisation access to Ebook
        /// </summary>
        /// <param name="OrganisationID"></param>
        /// <returns></returns>
        public bool GetOrganisationEbookAccess(int organisationID)
        {
            return GetOrganisationFeatureAccess(organisationID, "ebook");
        }
        /// <summary> Get list of organisations with access to a module </summary>
        public DataTable GetOrganisationList(int moduleID)
        {
            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

            System.Data.SqlClient.SqlParameter[] sqlParams =	{
																	new SqlParameter("@ModuleID", moduleID)
																};

            string sqlSelect = @"
								SELECT     tblModule.ModuleID, tblOrganisation.OrganisationID, tblOrganisation.OrganisationName
								FROM         tblOrganisation INNER JOIN
													tblOrganisationCourseAccess ON tblOrganisation.OrganisationID = tblOrganisationCourseAccess.OrganisationID INNER JOIN
													tblCourse ON tblOrganisationCourseAccess.GrantedCourseID = tblCourse.CourseID INNER JOIN
													tblModule ON tblCourse.CourseID = tblModule.CourseID
								WHERE     (tblModule.ModuleID = @moduleID)
								ORDER BY OrganisationName
								";

            return Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteDataset(connectionString, System.Data.CommandType.Text, sqlSelect, sqlParams).Tables[0];

        }
        /// <summary>
        /// Gets a single Organisations Details.
        /// </summary>
        /// <returns>Returns a DataTable with the details of one Organisation in the SALT database.</returns>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Peter Vranich
        /// Date: 28/01/0/2004
        /// Changes:
        /// </remarks>
        public DataTable GetOrganisation(SqlString LangCode, SqlInt32 orgID)
        {
            using (StoredProcedure sp = new StoredProcedure("prcOrganisation_GetOne",
                StoredProcedure.CreateInputParam("@LangCode", SqlDbType.NVarChar, LangCode),
                StoredProcedure.CreateInputParam("@orgID", SqlDbType.Int, orgID)
            ))
            {
                return sp.ExecuteTable();
            }
        }
        public DataTable getOrgURL(SqlInt32 organisationID)
        {
            using (StoredProcedure sp = new StoredProcedure("prcOrganisation_GetURL",
              StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID)
              ))
            {
                return sp.ExecuteTable();
            }
        }
        /// <summary>
        /// Update domain name for a specific organisation
        /// </summary>
        /// <param name="organisationID"></param>
        /// <param name="domainName"></param>
        public void UpdateDomainName(SqlInt32 organisationID, SqlString domainName)
        {
            using (StoredProcedure sp = new StoredProcedure("prcOrganisation_UpdateDomainName",
                      StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID),
                      StoredProcedure.CreateInputParam("@domainName", SqlDbType.NVarChar, 255, domainName)
                      ))
            {

                SqlDataReader rdr = sp.ExecuteReader();
                int intErrorNumber; // Holds the error number return from the stored procedure.
                string strErrorMessage; // Holds the error message return from the stored procedure.

                //1. Get the response.
                rdr.Read();
                intErrorNumber = rdr.GetInt32(0);
                strErrorMessage = rdr.GetString(1);

                //2. Close the reader.
                rdr.Close();

                //4. Throw the required exception if error number is not 0.
                switch (intErrorNumber)
                {
                    case 0: // Succeeded.
                        {
                            break;
                        }
                    case 1:
                        {
                            throw new RecordNotFoundException(strErrorMessage);
                        }
                    case 4: // Unique constraint.
                        {
                            throw new UniqueViolationException(ResourceManager.GetString("prcOrganisation_UpdateDomainName.4"));
                        }
                    case 5: // Parameter Exception.
                        {
                            throw new ParameterException(strErrorMessage);
                        }
                    case 6: // Permission Denied.
                        {
                            throw new PermissionDeniedException(strErrorMessage);
                        }
                    case 7: // Integrity Violation.
                        {
                            throw new IntegrityViolationException(strErrorMessage);
                        }
                    default: // Whatever is left.
                        {
                            throw new BusinessServiceException(strErrorMessage);
                        }
                }
            }
        }
        /// <summary>
        /// Gets organisation notes.
        /// </summary>
        /// <returns>Returns a string containing the organisation notes</returns>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen Kennedy-Clark
        /// Date: 09/02/2004
        /// Changes: 
        /// </remarks>
        /// <param name="organisationID">ID of the organisation</param>
        public string GetOrganisationNotes(SqlString LangCode, SqlInt32 organisationID)
        {
            using (StoredProcedure sp = new StoredProcedure("prcOrganisation_GetNotesByUser",
                      StoredProcedure.CreateInputParam("@LangCode", SqlDbType.NVarChar, LangCode),
                      StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID)
                      ))
            {
                return (string)sp.ExecuteScalar();
            }
        } //GetOrganisationNotes
        /// <summary>
        /// Gets a List of all the Administrators for a particular organisation.
        /// </summary>
        ///<param name="organisationID"> ID of the Organisation that you wish to get the Admins for.</param>
        /// <returns>Returns a DataTable with the details of all the Administrators for a particular organisation.</returns>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Peter Vranich
        /// Date: 12/02/0/2004
        /// Changes:
        /// </remarks>
        public DataTable GetOrganisationAdministrators(SqlInt32 organisationID)
        {
            using (StoredProcedure sp = new StoredProcedure("prcOrganisation_GetAdminList",
                      StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID)
                      ))
            {
                return sp.ExecuteTable();
            }
        } //GetOrganisationAdministrators
        /// <summary>
        /// Gets a List of all non administrative users for a particular organisation.
        /// </summary>
        /// <param name="organisationID"> ID of the Organisation that you wish to get the Users for.</param>
        /// <param name="firstName"> First name of the user(s) to search for.</param>
        /// <param name="lastName"> Last name of the user(s) to search for.</param>
        /// <returns> Returns a DataTable with the details of all the searched Users for a particular organisation.</returns>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Peter Vranich
        /// Date: 16/02/0/2004
        /// Changes:
        /// </remarks>
        public DataTable GetUsers(SqlInt32 organisationID, SqlString firstName, SqlString lastName)
        {
            using (StoredProcedure sp = new StoredProcedure("prcOrganisation_GetUsers",
                      StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID),
                      StoredProcedure.CreateInputParam("@firstName", SqlDbType.NVarChar, 50, firstName),
                      StoredProcedure.CreateInputParam("@lastName", SqlDbType.NVarChar, 50, lastName)
                      ))
            {
                return sp.ExecuteTable();
            }
        }

        /// <summary>
        /// Removes an Organisation administrator.
        /// </summary>
        /// <param name="updateUserID"> ID of the user to update.</param>
        /// <param name="actionUserID"> ID of the user that is making the change.</param>
        /// <param name="organisationID"> ID of the Organisation that this update is happening to.</param>
        /// <param name="originalDateUpdated"> The date of the record as at the time it was retrieved from the database.</param>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Peter Vranich
        /// Date: 13/02/0/2004
        /// Changes:
        /// </remarks>
        public void RemoveAdministrator(SqlInt32 updateUserID, SqlInt32 actionUserID, SqlInt32 organisationID, SqlDateTime originalDateUpdated)
        {
            using (StoredProcedure sp = new StoredProcedure("prcOrganisation_RemoveAdministrator",
                      StoredProcedure.CreateInputParam("@updateUserID", SqlDbType.Int, updateUserID),
                      StoredProcedure.CreateInputParam("@actionUserID", SqlDbType.Int, actionUserID),
                      StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID),
                      StoredProcedure.CreateInputParam("@originalDateUpdated", SqlDbType.DateTime, originalDateUpdated)
                      ))
            {
                SqlDataReader rdr = sp.ExecuteReader();
                int intErrorNumber; // Holds the error number return from the stored procedure.
                string strErrorMessage; // Holds the error message return from the stored procedure.

                //1. Get the response.
                rdr.Read();
                intErrorNumber = rdr.GetInt32(0);
                strErrorMessage = rdr.GetString(1);

                //2. Close the reader.
                rdr.Close();

                //4. Throw the required exception if error number is not 0.
                switch (intErrorNumber)
                {
                    case 0: // Succeeded.
                        {
                            break;
                        }
                    case 1:
                        {
                            throw new RecordNotFoundException(ResourceManager.GetString("prcOrganisation_RemoveAdministrator.1"));
                        }
                    case 4: // Unique constraint.
                        {
                            throw new UniqueViolationException(strErrorMessage);
                        }
                    case 5: // Parameter Exception.
                        {
                            throw new ParameterException(strErrorMessage);
                        }
                    case 6: // Permission Denied.
                        {
                            throw new PermissionDeniedException(ResourceManager.GetString("prcOrganisation_RemoveAdministrator.6"));
                        }
                    case 7: // Integrity Violation.
                        {
                            throw new IntegrityViolationException(ResourceManager.GetString("prcOrganisation_RemoveAdministrator.7"));
                        }
                    default: // Whatever is left.
                        {
                            throw new BusinessServiceException(strErrorMessage);
                        }
                }
            }
        }
        /// <summary>
        /// Adds an Organisation administrator.
        /// </summary>
        /// <param name="updateUserID"> ID of the user to update.</param>
        /// <param name="actionUserID"> ID of the user that is making the change.</param>
        /// <param name="organisationID"> ID of the Organisation that this update is happening to.</param>
        /// <param name="originalDateUpdated"> The date of the record as at the time it was retrieve from the database.</param>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Peter Vranich
        /// Date: 16/02/0/2004
        /// Changes:
        /// </remarks>
        public void AddAdministrator(SqlInt32 updateUserID, SqlInt32 actionUserID, SqlInt32 organisationID, SqlDateTime originalDateUpdated)
        {
            using (StoredProcedure sp = new StoredProcedure("prcOrganisation_SetAdministrator",
                      StoredProcedure.CreateInputParam("@updateUserID", SqlDbType.Int, updateUserID),
                      StoredProcedure.CreateInputParam("@actionUserID", SqlDbType.Int, actionUserID),
                      StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID),
                      StoredProcedure.CreateInputParam("@originalDateUpdated", SqlDbType.DateTime, originalDateUpdated)
                      ))
            {
                SqlDataReader rdr = sp.ExecuteReader();
                int intErrorNumber; // Holds the error number return from the stored procedure.
                string strErrorMessage; // Holds the error message return from the stored procedure.

                //1. Get the response.
                rdr.Read();
                intErrorNumber = rdr.GetInt32(0);
                strErrorMessage = rdr.GetString(1);

                //2. Close the reader.
                rdr.Close();

                //4. Throw the required exception if error number is not 0.
                switch (intErrorNumber)
                {
                    case 0: // Succeeded.
                        {
                            break;
                        }
                    case 1:
                        {
                            throw new RecordNotFoundException(ResourceManager.GetString("prcOrganisation_SetAdministrator.1"));
                        }
                    case 4: // Unique constraint.
                        {
                            throw new UniqueViolationException(strErrorMessage);
                        }
                    case 5: // Parameter Exception.
                        {
                            throw new ParameterException(strErrorMessage);
                        }
                    case 6: // Permission Denied.
                        {
                            throw new PermissionDeniedException(ResourceManager.GetString("prcOrganisation_SetAdministrator.6"));
                        }
                    case 7: // Integrity Violation.
                        {
                            throw new IntegrityViolationException(ResourceManager.GetString("prcOrganisation_SetAdministrator.7"));
                        }
                    default: // Whatever is left.
                        {
                            throw new BusinessServiceException(strErrorMessage);
                        }
                }
            }
        }
        /// <summary>
        /// Updates the details of a specific organisation.
        /// </summary>
        /// <param name="organisationID"> The ID of the organisation to be updated.</param>
        /// <param name="name"> The name of the organisation.</param>
        /// <param name="notes"> The notes for the organisation.</param>
        /// <param name="logo"> The logo for the organisation.</param>
        /// <param name="lessonFrequency"> The default lesson frequency for the organisation.</param>
        /// <param name="quizFrequency"> The default quiz frequency for the organisation.</param>
        /// <param name="quizPassMark"> The default quiz pass mark for the organisation.</param>
        /// <param name="actionUserID"> The ID of the user creating the organisation.</param>
        /// <param name="originalDateUpdated"> The date of the record as at the time it was retrieved from the database.</param>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Peter Vranich
        /// Date: 18/02/0/2004
        /// Changes:
        /// </remarks>
        public void UpdateOrganisation(SqlString LangCode, SqlInt32 organisationID, SqlString name, SqlString notes,
            SqlString logo, SqlInt32 lessonFrequency, SqlInt32 quizFrequency, SqlInt32 quizPassMark, SqlDateTime lessonCompletionDate,
            SqlDateTime quizCompletionDate, SqlBoolean advancedReporting, SqlInt32 actionUserID, SqlDateTime originalDateUpdated,
            SqlString CPDReportName, SqlInt64 AllocatedDiskSpace, SqlBoolean inclLogo, SqlBoolean PasswordLockout, String SelectedTimeZone,
            SqlBoolean ShowLastPassed, SqlBoolean DisablePasswordField, SqlBoolean EnableUniqueURL, SqlBoolean EnableUserCPDEvent, SqlBoolean DefaultEbookEmailNotification)
        {
            if (AllocatedDiskSpace == 0)
            {
                AllocatedDiskSpace = SqlInt64.Null;
            }

            SqlInt32 TimeZoneID = 0;
            using (StoredProcedure sp = new StoredProcedure("prcTimeZone_GetTZIDfromFLBName", StoredProcedure.CreateInputParam("@FLBName", SqlDbType.NVarChar, SelectedTimeZone)))
            {
                TimeZoneID = Convert.ToInt32(sp.ExecuteScalar());
            }



            SqlParameter paramDateLesson = StoredProcedure.CreateInputParam("@lessonCompletionDate", SqlDbType.DateTime);
            if (lessonCompletionDate == DateTime.Parse("1/1/1900"))
                paramDateLesson.Value = SqlDateTime.Null;
            else
                paramDateLesson.Value = lessonCompletionDate;

            SqlParameter paramDateQuiz = StoredProcedure.CreateInputParam("@quizCompletionDate", SqlDbType.DateTime);
            if (quizCompletionDate == DateTime.Parse("1/1/1900"))
                paramDateQuiz.Value = SqlDateTime.Null;
            else
                paramDateQuiz.Value = quizCompletionDate;

            using (StoredProcedure sp = new StoredProcedure("prcOrganisation_Update",
                StoredProcedure.CreateInputParam("@LangCode", SqlDbType.NVarChar, LangCode),
                StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID),
                StoredProcedure.CreateInputParam("@organisationName", SqlDbType.NVarChar, 50, name),
                StoredProcedure.CreateInputParam("@notes", SqlDbType.NVarChar, 4000, notes),
                StoredProcedure.CreateInputParam("@logo", SqlDbType.VarChar, 100, logo),
                StoredProcedure.CreateInputParam("@lessonFrequency", SqlDbType.Int, lessonFrequency),
                StoredProcedure.CreateInputParam("@quizFrequency", SqlDbType.Int, quizFrequency),
                StoredProcedure.CreateInputParam("@quizPassMark", SqlDbType.Int, quizPassMark),
                paramDateLesson,
                paramDateQuiz,
                StoredProcedure.CreateInputParam("@advancedReporting", SqlDbType.Bit, advancedReporting),
                StoredProcedure.CreateInputParam("@actionUserID", SqlDbType.Int, actionUserID),
                StoredProcedure.CreateInputParam("@originalDateUpdated", SqlDbType.DateTime, originalDateUpdated),
                StoredProcedure.CreateInputParam("@CPDReportName", SqlDbType.NVarChar, 255, CPDReportName),
                StoredProcedure.CreateInputParam("@AllocatedDiskSpace", SqlDbType.BigInt, AllocatedDiskSpace),
                StoredProcedure.CreateInputParam("@inclLogo", SqlDbType.Bit, inclLogo),
                StoredProcedure.CreateInputParam("@PasswordLockout", SqlDbType.Bit, PasswordLockout),
                StoredProcedure.CreateInputParam("@TimeZoneID", SqlDbType.Int, TimeZoneID),
                StoredProcedure.CreateInputParam("@ShowLastPassed", SqlDbType.Bit, ShowLastPassed),
                StoredProcedure.CreateInputParam("@DisablePasswordField", SqlDbType.Bit, DisablePasswordField),
                StoredProcedure.CreateInputParam("@EnableUniqueURL", SqlDbType.Bit, EnableUniqueURL),
                StoredProcedure.CreateInputParam("@EnableUserCPDEvent", SqlDbType.Bit, EnableUserCPDEvent),
                StoredProcedure.CreateInputParam("@DefaultEbookEmailNotification", SqlDbType.Bit, DefaultEbookEmailNotification)

))
            {
                SqlDataReader rdr = sp.ExecuteReader();
                int intErrorNumber; // Holds the error number return from the stored procedure.
                string strErrorMessage; // Holds the error message return from the stored procedure.

                //1. Get the response.
                rdr.Read();
                intErrorNumber = rdr.GetInt32(0);
                strErrorMessage = rdr.GetString(1);

                //2. Close the reader.
                rdr.Close();

                //4. Throw the required exception if error number is not 0.
                switch (intErrorNumber)
                {
                    case 0: // Succeeded.
                        {
                            break;
                        }
                    case 1:
                        {
                            throw new RecordNotFoundException(ResourceManager.GetString("prcOrganisation_Update.1"));
                        }
                    case 4: // Unique constraint.
                        {
                            throw new UniqueViolationException(String.Format(ResourceManager.GetString("prcOrganisation_Update.4"), name));
                        }
                    case 5: // Parameter Exception.
                        {
                            throw new ParameterException(strErrorMessage);
                        }
                    case 6: // Permission Denied.
                        {
                            throw new PermissionDeniedException(ResourceManager.GetString("prcOrganisation_Update.6"));
                        }
                    case 7: // Integrity Violation.
                        {
                            throw new IntegrityViolationException(ResourceManager.GetString("prcOrganisation_Update.7"));
                        }
                    default: // Whatever is left.
                        {
                            throw new BusinessServiceException(strErrorMessage);
                        }
                }
            }
        }

        /// <summary>
        /// Adds a new organisation to the database.
        /// </summary>
        /// <param name="name"> The name of the organisation.</param>
        /// <param name="notes"> The notes for the organisation.</param>
        /// <param name="logo"> The logo for the organisation.</param>
        /// <param name="lessonFrequency"> The default lesson frequency for the organisation.</param>
        /// <param name="quizFrequency"> The default quiz frequency for the organisation.</param>
        /// <param name="quizPassMark"> The default quiz pass mark for the organisation.</param>
        /// <param name="actionUserID"> The ID of the user creating the organisation.</param>
        /// <returns> The ID of the newly created organisation.</returns>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Peter Vranich
        /// Date: 18/02/0/2004
        /// Changes:
        /// </remarks>
        public int AddOrganisation(SqlString name, SqlString notes, SqlString logo, SqlInt32 lessonFrequency, SqlInt32 quizFrequency,
            SqlInt32 quizPassMark, SqlDateTime lessonCompletionDate, SqlDateTime quizCompletionDate, SqlBoolean advancedReporting,
            SqlInt32 actionUserID, SqlString CPDReportName, SqlInt64 AllocatedDiskSpace, SqlBoolean inclLogo, SqlBoolean PasswordLockout,
            String SelectedTimeZone, SqlBoolean ShowLastPassed, SqlBoolean DisablePasswordField, SqlBoolean EnableUniqueURL, SqlBoolean EnableUserCPDEvent, SqlBoolean DefaultEbookEmailNotification)
        {
            int intOrganisationID = 0;
            SqlParameter paramKey = StoredProcedure.CreateOutputParam("@intOrganisationID", SqlDbType.Int, 4, intOrganisationID);

            SqlParameter paramDateLesson = StoredProcedure.CreateInputParam("@lessonCompletionDate", SqlDbType.DateTime);
            if (lessonCompletionDate == DateTime.Parse("1/1/1900"))
                paramDateLesson.Value = SqlDateTime.Null;
            else
                paramDateLesson.Value = lessonCompletionDate;

            SqlParameter paramDateQuiz = StoredProcedure.CreateInputParam("@quizCompletionDate", SqlDbType.DateTime);
            if (quizCompletionDate == DateTime.Parse("1/1/1900"))
                paramDateQuiz.Value = SqlDateTime.Null;
            else
                paramDateQuiz.Value = quizCompletionDate;

            SqlParameter paramCPDReportName = StoredProcedure.CreateInputParam("@CPDReportName", SqlDbType.NVarChar, 255, CPDReportName);
            if (CPDReportName == "")
                paramCPDReportName.Value = SqlString.Null;
            else
                paramCPDReportName.Value = CPDReportName;

            SqlParameter paramAllocatedDiskSpace = StoredProcedure.CreateInputParam("@AllocatedDiskSpace", SqlDbType.Int, AllocatedDiskSpace);
            if (AllocatedDiskSpace == 0)
                paramAllocatedDiskSpace.Value = SqlInt32.Null;
            else
                paramAllocatedDiskSpace.Value = AllocatedDiskSpace;

            SqlInt32 TimeZoneID = 0;
            using (StoredProcedure sp = new StoredProcedure("prcTimeZone_GetTZIDfromFLBName", StoredProcedure.CreateInputParam("@FLBName", SqlDbType.NVarChar, SelectedTimeZone)))
            {
                TimeZoneID = Convert.ToInt32(sp.ExecuteScalar());
            }

            using (StoredProcedure sp = new StoredProcedure("prcOrganisation_Add",
                    paramKey,
                    StoredProcedure.CreateInputParam("@organisationName", SqlDbType.NVarChar, 50, name),
                    StoredProcedure.CreateInputParam("@notes", SqlDbType.NVarChar, 4000, notes),
                    StoredProcedure.CreateInputParam("@logo", SqlDbType.VarChar, 100, logo),
                    StoredProcedure.CreateInputParam("@lessonFrequency", SqlDbType.Int, lessonFrequency),
                    StoredProcedure.CreateInputParam("@quizFrequency", SqlDbType.Int, quizFrequency),
                    StoredProcedure.CreateInputParam("@quizPassMark", SqlDbType.Int, quizPassMark),
                    paramDateLesson,
                    paramDateQuiz,
                    StoredProcedure.CreateInputParam("@advancedReporting", SqlDbType.Bit, advancedReporting),
                    StoredProcedure.CreateInputParam("@actionUserID", SqlDbType.Int, actionUserID),
                    paramCPDReportName,
                    paramAllocatedDiskSpace,
                    StoredProcedure.CreateInputParam("@inclLogo", SqlDbType.Bit, inclLogo),
                    StoredProcedure.CreateInputParam("@PasswordLockout", SqlDbType.Bit, PasswordLockout),
                    StoredProcedure.CreateInputParam("@TimeZoneID", SqlDbType.Int, TimeZoneID),
                    StoredProcedure.CreateInputParam("@ShowLastPassed", SqlDbType.Bit, ShowLastPassed),
                    StoredProcedure.CreateInputParam("@DisablePasswordField", SqlDbType.Bit, DisablePasswordField),
                    StoredProcedure.CreateInputParam("@EnableUniqueURL", SqlDbType.Bit, EnableUniqueURL),
                  StoredProcedure.CreateInputParam("@EnableUserCPDEvent", SqlDbType.Bit, EnableUserCPDEvent),
                    StoredProcedure.CreateInputParam("@DefaultEbookEmailNotification", SqlDbType.Bit, DefaultEbookEmailNotification)
                    ))
            {
                SqlDataReader rdr = sp.ExecuteReader();
                int intErrorNumber; // Holds the error number return from the stored procedure.
                string strErrorMessage; // Holds the error message return from the stored procedure.

                //1. Get the response.
                rdr.Read();
                intErrorNumber = rdr.GetInt32(0);
                strErrorMessage = rdr.GetString(1);

                //2. Close the reader.
                rdr.Close();

                //4. Throw the required exception if error number is not 0.
                switch (intErrorNumber)
                {
                    case 0: // Succeeded.
                        {
                            intOrganisationID = (int)paramKey.Value;
                            return intOrganisationID;
                        }
                    case 4: // Unique constraint.
                        {
                            throw new UniqueViolationException(String.Format(ResourceManager.GetString("prcOrganisation_Add.4"), name));
                        }
                    case 5: // Parameter Exception.
                        {
                            throw new ParameterException(strErrorMessage);
                        }
                    case 6: // Permission Denied.
                        {
                            throw new PermissionDeniedException(ResourceManager.GetString("prcOrganisation_Add.6"));
                        }
                    default: // Whatever is left.
                        {
                            throw new BusinessServiceException(strErrorMessage);
                        }
                }
            }
        }

        /// <summary>
        /// Gets a list of all Courses and flags which one the organisation has access to.
        /// </summary>
        /// <param name="organisationID"> The ID of the organisation that you wish to get the course access list for.</param>
        /// <returns> A datatable with all the courses and a flag indicating which one this organisation has access to.</returns>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Peter Vranich
        /// Date: 20/02/0/2004
        /// Changes:
        /// </remarks>
        /// 

        public DataTable GetCourseAccessList(SqlInt32 organisationID)
        {
            using (StoredProcedure sp = new StoredProcedure("prcOrganisation_GetCourseAccessList",
                StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, 4, organisationID)
            ))
            {
                return sp.ExecuteTable();
            }
        }

        /// <summary>
        /// Saves the course access settings for an organisation.
        /// </summary>
        /// <param name="organisationID"> The ID of the organisation that you wish to save the changes for.</param>
        /// <param name="grantedCourseIDs"> A comma seperated list of CourseIDs that the organisation will have access to.</param>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Peter Vranich
        /// Date: 20/02/0/2004
        /// Changes:
        /// </remarks>
        public void SaveCourseAccess(SqlInt32 organisationID, SqlString grantedCourseIDs)
        {
            using (StoredProcedure sp = new StoredProcedure("prcOrganisation_SaveCourseAccess",
                StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, 4, organisationID),
                StoredProcedure.CreateInputParam("@grantedCourseIDs", SqlDbType.VarChar, 500, grantedCourseIDs)
            ))
            {
                sp.ExecuteNonQuery();
            }
        }
        /// <summary>
        /// Method to update delinquency from Organisation Mail setup screen
        /// </summary>
        /// <returns></returns>
        public void UpdateDeliquency(int orgID, Boolean blnchkWarnMgrs, Boolean blnchkWarnUsers, int intdrpNumberOfWarns,
                int intdrpNumberofDaysDelinq, int intdrpNumberofDaysWarns, int intdrpDaysBefore, bool includeLogo, DateTime quizDueDate)
        {
            using (StoredProcedure sp = new StoredProcedure("prcUpdateOrgDeliquency",
                StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, orgID),
                StoredProcedure.CreateInputParam("@WarnMgrsofDeliquentUsers", SqlDbType.Bit, blnchkWarnMgrs),
                StoredProcedure.CreateInputParam("@WarnUsersofDelinquency", SqlDbType.Bit, blnchkWarnUsers),
                StoredProcedure.CreateInputParam("@NumberOfReminders", SqlDbType.Int, intdrpNumberOfWarns),
                StoredProcedure.CreateInputParam("@DelinquencyPeriod", SqlDbType.Int, intdrpNumberofDaysDelinq),
                StoredProcedure.CreateInputParam("@DelinquencyReminderPeriod", SqlDbType.Int, intdrpNumberofDaysWarns),
                StoredProcedure.CreateInputParam("@DaysWarningBeforeExpiry", SqlDbType.Int, intdrpDaysBefore),
                StoredProcedure.CreateInputParam("@IncludeLogo", SqlDbType.Bit, includeLogo),
                StoredProcedure.CreateInputParam("@QuizDueDate", SqlDbType.DateTime, quizDueDate)))
            {
                sp.ExecuteNonQuery();
            }

        }


        public static DataTable OrganisationModuleAccess()
        {
            string sqlSelect = @"
								SELECT     tblOrganisation.OrganisationID, tblOrganisation.OrganisationName, ISNULL(tblOrganisationModuleAccess.PolicyBuilder, 0) AS PolicyBuilder
								FROM         tblOrganisation LEFT OUTER JOIN
													tblOrganisationModuleAccess ON tblOrganisation.OrganisationID = tblOrganisationModuleAccess.OrganisationID
								ORDER BY tblOrganisation.OrganisationName
								";

            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

            DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlSelect).Tables[0];
            return dt;
        }


        public static void OrganisationModuleAccessSave(int organisationID, string moduleName, bool grantAccess)
        {
            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

            string sqlInsert = "INSERT INTO tblOrganisationModuleAccess(OrganisationID, " + moduleName + ") VALUES (@OrganisationID, @GrantAccess)";
            string sqlUpdate = "UPDATE tblOrganisationModuleAccess set " + moduleName + " = @GrantAccess WHERE OrganisationID = @OrganisationID";

            SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@OrganisationID", organisationID), new SqlParameter("@GrantAccess", grantAccess) };

            int result = SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, sqlUpdate, sqlParams);

            if (result == 0)
                SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, sqlInsert, sqlParams);
        }


        public static bool HasModuleAccess(int organisationID, string moduleName)
        {
            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

            string sqlSelect = "SELECT " + moduleName + " FROM tblOrganisationModuleAccess WHERE OrganisationID = @OrganisationID";

            SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@OrganisationID", organisationID) };

            bool grantAccess = Convert.ToBoolean(SqlHelper.ExecuteScalar(connectionString, CommandType.Text, sqlSelect, sqlParams).ToString());

            return grantAccess;
        }

        /// <summary>
        /// Gets the local time for administrators of an Organisation
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Changes:
        /// </remarks>
        public DateTime getdate(SqlInt32 organisationID)
        {
            SqlString OrgTimeZone = "AUS Eastern Standard Time";
            using (StoredProcedure sp = new StoredProcedure("prcOrganisation_GetTimeZone", StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, organisationID)))
            {
                //get name of timezone
                OrgTimeZone = (SqlString)sp.ExecuteScalar();
            }
            // Get time in local time zone 
            DateTime thisTime = DateTime.Now;

            // Get Organisation Time zone
            TimeZoneInfo tst = TimeZoneInfo.FindSystemTimeZoneById(OrgTimeZone.ToString());
            DateTime tstTime = TimeZoneInfo.ConvertTime(thisTime, TimeZoneInfo.Local, tst);
            return tstTime;

        }

        public DataTable getEscalationConfigForCourse(int orgID, int courseID)
        {
            using (StoredProcedure sp = new StoredProcedure("prcgetEscalationConfigForCourse",
                StoredProcedure.CreateInputParam("@orgID", SqlDbType.Int, orgID),
                StoredProcedure.CreateInputParam("@courseID", SqlDbType.Int, courseID)))
            {
                return sp.ExecuteTable();
            }
        }

        public DataTable getCoursesConfiguredForMail(int orgID, string strLangCode)
        {
            using (StoredProcedure sp = new StoredProcedure("prcGetReminderEscalations",
                StoredProcedure.CreateInputParam("@orgID", SqlDbType.Int, orgID),
                StoredProcedure.CreateInputParam("@langcode", SqlDbType.VarChar, strLangCode)))
            {
                return sp.ExecuteTable();
            }
        }

        public void updateReminderEscalation(int remEscID, int act)
        {
            using (StoredProcedure sp = new StoredProcedure("prcUpdateReminderEscalation",
                StoredProcedure.CreateInputParam("@remEscId", SqlDbType.Int, remEscID),
                StoredProcedure.CreateInputParam("@act", SqlDbType.Int, act)))
            {
                sp.ExecuteNonQuery();
            }
        }


        public void updateMailConfig(SqlInt32 remEscID, SqlInt32 orgID, string courseIDs, SqlInt32 DaysToCompleteCourse
            , SqlBoolean RemindUsers, SqlInt32 NumOfRemNotfy, SqlInt32 RepeatRem, SqlBoolean NotifyMgr, SqlBoolean IndividualNotification
            , SqlBoolean IsCumulative, SqlInt32 NotifyMgrDays, SqlBoolean QuizExpiryWarn, SqlInt32 DaysQuizExpiry, SqlBoolean preExpInit,
            SqlBoolean PostExpReminder, SqlBoolean postExpInitEnrolment, SqlBoolean postExpResitPeriod, SqlBoolean preExpResitPeriod)
        {
            using (StoredProcedure sp = new StoredProcedure("prcEscalationConfigForCourse_Update",
                StoredProcedure.CreateInputParam("@remEscID", SqlDbType.Int, remEscID),
                StoredProcedure.CreateInputParam("@orgID", SqlDbType.Int, orgID),
                StoredProcedure.CreateInputParam("@courseIDs", SqlDbType.VarChar, 8000, courseIDs),
                StoredProcedure.CreateInputParam("@DaysToCompleteCourse", SqlDbType.Int, DaysToCompleteCourse),
                StoredProcedure.CreateInputParam("@RemindUsers", SqlDbType.Bit, RemindUsers),
                StoredProcedure.CreateInputParam("@NumOfRemNotfy", SqlDbType.Int, NumOfRemNotfy),
                StoredProcedure.CreateInputParam("@RepeatRem", SqlDbType.Int, RepeatRem),
                StoredProcedure.CreateInputParam("@NotifyMgr", SqlDbType.Bit, NotifyMgr),
                StoredProcedure.CreateInputParam("@IndividualNotification", SqlDbType.Bit, IndividualNotification),
                StoredProcedure.CreateInputParam("@IsCumulative", SqlDbType.Bit, IsCumulative),
                StoredProcedure.CreateInputParam("@NotifyMgrDays", SqlDbType.Int, NotifyMgrDays),
                StoredProcedure.CreateInputParam("@QuizExpiryWarn", SqlDbType.Bit, QuizExpiryWarn),
                StoredProcedure.CreateInputParam("@DaysQuizExpiry", SqlDbType.Int, DaysQuizExpiry),
                StoredProcedure.CreateInputParam("@preexpiryInitEnrolment", SqlDbType.Bit, preExpInit),
                StoredProcedure.CreateInputParam("@postExpReminder", SqlDbType.Bit, PostExpReminder),
                StoredProcedure.CreateInputParam("@postExpInitEnrolment", SqlDbType.Bit, postExpInitEnrolment),
                StoredProcedure.CreateInputParam("@postExpResitPeriod", SqlDbType.Bit, postExpResitPeriod),
                StoredProcedure.CreateInputParam("@preExpResitPeriod", SqlDbType.Bit, preExpResitPeriod)
                ))
            {
                sp.ExecuteNonQuery();
            }
        }

        public Boolean orgMailFlagConfig(SqlInt32 orgID, SqlInt32 getSet, SqlInt32 userID)
        {
            using (StoredProcedure sp = new StoredProcedure("prcGetSet_MailFlag",
                StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, orgID),
                StoredProcedure.CreateInputParam("@getSet", SqlDbType.Int, getSet),
                StoredProcedure.CreateInputParam("@UserID", SqlDbType.Int, userID)))
            {
                return (bool)sp.ExecuteScalar();
            }
        }

    }
}