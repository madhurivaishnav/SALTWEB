//===============================================================================
//
//	Salt Business Service Layer
//
//===============================================================================

using System;
using System.Data;
using System.Data.SqlTypes;
using System.Data.SqlClient;
using System.Net.Mail;
using System.Configuration;
using System.Net;
using System.Web;
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.Utilities;
using Microsoft.ApplicationBlocks.Data;
using System.Threading;

namespace Bdw.Application.Salt.BusinessServices
{
	/// <summary>
	/// Handles logging of emails sent to the salt database.
	/// Handles searching of the above email log
	/// </summary>
	/// <remarks>
	/// Assumptions: None
	/// Notes: 
	/// Author: All Developers
	/// Changes:
	/// </remarks>
    public class Email
    {
        private String APP_NAME = "";
        private int OrgID = -1;
        private String orgURL = "";
        private String orgName = "";
        private String emailBody = "";

        public Email()
        {
            // initilize appname variable for use in the email
            AppConfig ac = new AppConfig();
            APP_NAME = ac.getConfigValue("AppName");

        }


        /// <summary>
        /// search email sent within the selected date range to a email and contain text in subject or body
        /// </summary>
        /// <param name="dateFrom">From Email sent</param>
        /// <param name="dateTo">To Date Email sent</param>
        /// <param name="toEmail">Email address that the email sent to</param>
        /// <param name="subject">The text subject contains</param>
        /// <param name="body">The text body contains</param>
        /// <returns>DataTable containing search results as per criteria specified</returns>
        public DataTable Search(DateTime dateFrom, DateTime dateTo,string toEmail, string subject,string body, int organisationID)
        {
            using(StoredProcedure sp = new StoredProcedure("prcEmail_Search",
                      StoredProcedure.CreateInputParam("@dateFrom", SqlDbType.DateTime, dateFrom),
                      StoredProcedure.CreateInputParam("@dateTo", SqlDbType.DateTime, dateTo),
                      StoredProcedure.CreateInputParam("@toEmail", SqlDbType.NVarChar,50, toEmail),
                      StoredProcedure.CreateInputParam("@subject", SqlDbType.NVarChar,50, subject),
                      StoredProcedure.CreateInputParam("@body", SqlDbType.NVarChar,50, body),
                      StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID)
                      ))
            {
                return sp.ExecuteTable();
            }
        } // Search


        /// <summary>
        /// Search the email sent filtered by the userID
        /// Only available in 4.4.1 where the email log table is altered to include userID
        /// Any emails prior to 4.4.1 will not be returned as they will not have any userid associated to the emails
        /// </summary>
        /// <param name="userID"></param>
        /// <returns></returns>
        public DataTable SearchByUserID(int userID, int organisationID)
        {
            using (StoredProcedure sp = new StoredProcedure("prcEmail_SearchByUserID",
                      StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID),
                      StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID)
                      ))
            {
                return sp.ExecuteTable();
            }
        }



        /// <summary>
        /// Retrieve email by the specified emailID
        /// </summary>
        /// <param name="emailID"></param>
        /// <param name="organisationID"></param>
        /// <returns></returns>
        public DataTable Search(int emailID, int organisationID)
        {
            using (StoredProcedure sp = new StoredProcedure("prcEmail_SearchByID",
                      StoredProcedure.CreateInputParam("@emailID", SqlDbType.Int, emailID),
                      StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID)
                      ))
            {
                return sp.ExecuteTable();
            }
        } // Search

        /// <summary>
        /// This function logs to tblEmail the fact that an email has been successfully sent
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Peter Kneale 03/03/04
        /// Changes:
        /// </remarks>
        /// <param name="toEmail">The email address of the recipient of the email</param>
        /// <param name="toName">The name of the recipient of the email</param>
        /// <param name="fromEmail">The email address of the sender of the email</param>
        /// <param name="fromName">The name of the sender of the email</param>
        /// <param name="CC">The CC list on the email</param>
        /// <param name="BCC">The BCC list on the email</param>
        /// <param name="subject">The Subject of the email</param>
        /// <param name="body">The body of the email</param>
        /// <param name="organisationID">the organisation the email is being sent from and to</param>
        public void LogSentEmail(string toEmail, string toName, string fromEmail, string fromName, string CC, string BCC, string subject, string body, int organisationID, int userID)
        {

			System.Data.SqlClient.SqlConnection con = new System.Data.SqlClient.SqlConnection();
			System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand();

				try
				{
									
					con.ConnectionString = ConfigurationSettings.AppSettings["LogConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
					con.Open();

					//Test app connnection
					
					
					cmd.CommandType = CommandType.StoredProcedure;

					SqlParameter p1 = new SqlParameter("@toEmail", SqlDbType.NVarChar,1000);
					p1.Value = toEmail;
					p1.Direction = ParameterDirection.Input;

					SqlParameter p2 = new SqlParameter("@toName", SqlDbType.NVarChar,128);
					p2.Value = toName;
					p2.Direction = ParameterDirection.Input;

					SqlParameter p3 = new SqlParameter("@fromEmail", SqlDbType.NVarChar,128);
					p3.Value = fromEmail;
					p3.Direction = ParameterDirection.Input;

					SqlParameter p4 = new SqlParameter("@fromName", SqlDbType.NVarChar,128);
					p4.Value = fromName;
					p4.Direction = ParameterDirection.Input;

					SqlParameter p5 = new SqlParameter("@CC", SqlDbType.NVarChar,1000);
					p5.Value = CC;
					p5.Direction = ParameterDirection.Input;

					SqlParameter p6 = new SqlParameter("@BCC", SqlDbType.NVarChar,1000);
					p6.Value = BCC;
					p6.Direction = ParameterDirection.Input;

					SqlParameter p7 = new SqlParameter("@subject", SqlDbType.NVarChar,256);
					p7.Value = subject;
					p7.Direction = ParameterDirection.Input;

					SqlParameter p8 = new SqlParameter("@body", SqlDbType.NText);
					p8.Value = body;
					p8.Direction = ParameterDirection.Input;

					SqlParameter p9 = new SqlParameter("@organisationID", SqlDbType.Int);
					p9.Value = organisationID;
					p9.Direction = ParameterDirection.Input;

                    SqlParameter p10 = new SqlParameter("@userID", SqlDbType.Int);
                    p10.Value = userID;
                    p10.Direction = ParameterDirection.Input;

					cmd.Parameters.Add(p1);
					cmd.Parameters.Add(p2);
					cmd.Parameters.Add(p3);
					cmd.Parameters.Add(p4);
					cmd.Parameters.Add(p5);
					cmd.Parameters.Add(p6);
					cmd.Parameters.Add(p7);
					cmd.Parameters.Add(p8);
					cmd.Parameters.Add(p9);
                    cmd.Parameters.Add(p10);

					cmd.CommandText = "prcEmail_LogSentEmail";
				
					cmd.Connection = con;
					
					cmd.ExecuteNonQuery();
				}
				catch(Exception e)
				{
					try 
					{
						using(StoredProcedure sp = new StoredProcedure("prcEmail_LogSentEmail",
								  StoredProcedure.CreateInputParam("@toEmail", SqlDbType.VarChar,1000, toEmail),
								  StoredProcedure.CreateInputParam("@toName", SqlDbType.VarChar,128, toName),
								  StoredProcedure.CreateInputParam("@fromEmail", SqlDbType.VarChar,128, fromEmail),
								  StoredProcedure.CreateInputParam("@fromName", SqlDbType.VarChar,128, fromName),
								  StoredProcedure.CreateInputParam("@CC", SqlDbType.VarChar,1000, CC),
								  StoredProcedure.CreateInputParam("@BCC", SqlDbType.VarChar,1000, BCC),
								  StoredProcedure.CreateInputParam("@subject", SqlDbType.VarChar,256, subject),
								  StoredProcedure.CreateInputParam("@body", SqlDbType.Text, body),
                                  StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID),
                                  StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID)
								  ))
						{
							sp.ExecuteNonQuery();
						}
					} 
					catch(Exception )
					{
						throw;
					}
				}
				finally
				{
					if (con != null)
					{
						if (con.State != ConnectionState.Closed)
						{
							con.Close();
						}
					}

					con=null;
					cmd = null;
				}
        } //LogSentEmail

        /// <summary>
        /// This method send an email using the MailMessage object.
        /// </summary>
        /// <param name="toEmail">Recipients Email Address</param>
        /// <param name="toName">Recipients Name</param>
        /// <param name="fromEmail">Senders Email Address</param>
        /// <param name="fromName">Senders Name</param>
        /// <param name="CC">CC Email List</param>
        /// <param name="BCC">BCC Email List</param>
        /// <param name="subject">Email Subject</param>
        /// <param name="body">Email Body</param>
        /// <param name="serverName">serverName</param>
        /// <param name="organisationID">organisation sending the email</param>
        public void SendEmail(string toEmail, string toName, string fromEmail, string fromName, string CC, string BCC, string subject, string serverName, int organisationID, int userID)
        {

            SendEmail(toEmail, toName, fromEmail, fromName, CC, BCC, subject, emailBody, serverName);
            LogSentEmail(toEmail, toName, fromEmail, fromName, CC, BCC, subject, emailBody, organisationID, userID);
        }



        public void setUserCopyEmailBody(String strAdminEmail)
        {
            emailBody = strAdminEmail;
        }

        public void setCCSendError(String strCCEmail)
        {
            emailBody = "Message unable to be sent to " + strCCEmail + "\n\n" + emailBody;
        }



        public String emailHeaderSub(String strHeader)
        {

            strHeader = GeneralUtilities.ReplaceCaseInsensitive(strHeader, "%APP_NAME%", APP_NAME);
            strHeader = GeneralUtilities.ReplaceCaseInsensitive(strHeader, "%ORG_NAME%", orgName);
            return strHeader;
        }

        public String getEmailBody()
        {
            return emailBody;
        }


        public void SetEmailBody(String strBody, int UserID, String pCourseName, String pDtFrom, String pDtTo, String pUserList,
            String pCourseList, String pAdminName, String pAdminUnit, String pPolicy)
        {

            // get the user details and replace first and last name
            User u = new User();
            DataTable dt = u.GetUser(UserID);
            
            int pOrgId= -1;
            emailBody = "";
            emailBody = strBody;


            if (dt.Rows.Count == 1)
            {
                DataRow dr = dt.Rows[0];
                // we have a record replace the first and last name
                emailBody = GeneralUtilities.ReplaceCaseInsensitive(emailBody, "%FirstName%", dr.ItemArray[1].ToString());
                emailBody = GeneralUtilities.ReplaceCaseInsensitive(emailBody, "%LastName%", dr.ItemArray[2].ToString());
                emailBody = GeneralUtilities.ReplaceCaseInsensitive(emailBody, "%USERNAME%", dr.ItemArray[3].ToString());
                emailBody = GeneralUtilities.ReplaceCaseInsensitive(emailBody, "%PASSWORD%", dr.ItemArray[4].ToString());
                pOrgId = Int32.Parse(dr.ItemArray[7].ToString());
            }
       
            
            // if the organisation has changed then get the org URL
            // usually the same org so saves it from hitting the dbevery time
            if(pOrgId!=OrgID && !pOrgId.Equals(""))
            {
                Organisation o = new Organisation();
                dt = o.getOrgURL(pOrgId);
                orgURL =(String) dt.Rows[0]["ORGURL"];
                orgName = (String)dt.Rows[0]["organisationname"];
                OrgID = pOrgId;
            }

            // only do this if there are assigned courses
            if (strBody.Contains("%ASSIGNED_COURSES%"))
            {
                Course c = new Course();
                string strcourselist = c.GetCourseListAccessableToUsr(UserID);
                emailBody = GeneralUtilities.ReplaceCaseInsensitive(emailBody, "%ASSIGNED_COURSES%", strcourselist);
            }

            emailBody = GeneralUtilities.ReplaceCaseInsensitive(emailBody, "%COURSE_NAME%", pCourseName);
            emailBody = GeneralUtilities.ReplaceCaseInsensitive(emailBody, "%COURSE%", pCourseName);
            emailBody = GeneralUtilities.ReplaceCaseInsensitive(emailBody, "%COURSE_NAMES%", pCourseList);

            emailBody = GeneralUtilities.ReplaceCaseInsensitive(emailBody, "%DATE_FROM%", pDtFrom);
            emailBody = GeneralUtilities.ReplaceCaseInsensitive(emailBody, "%DATE_TO%", pDtTo);

            emailBody = GeneralUtilities.ReplaceCaseInsensitive(emailBody, "%USER_LIST%", pUserList);

            emailBody = GeneralUtilities.ReplaceCaseInsensitive(emailBody, "%APP_NAME%", APP_NAME);
            emailBody = GeneralUtilities.ReplaceCaseInsensitive(emailBody, "%URL%", orgURL);
            emailBody = GeneralUtilities.ReplaceCaseInsensitive(emailBody, "%ORG_NAME%", orgName);

            // policy builder specific params
            emailBody = GeneralUtilities.ReplaceCaseInsensitive(emailBody, "%ADMIN_NAME%", pAdminName);
            emailBody = GeneralUtilities.ReplaceCaseInsensitive(emailBody, "%ADMIN_UNIT%", pAdminUnit);

            if (pPolicy.Equals("") && strBody.Contains("%POLICIES%"))
            {
                User usr = new User();
                pPolicy = usr.getPoliciesAssignedToUser(UserID, OrgID);
                emailBody = GeneralUtilities.ReplaceCaseInsensitive(emailBody, "%POLICIES%", pPolicy);
            }
            else
            {
                emailBody = GeneralUtilities.ReplaceCaseInsensitive(emailBody, "%POLICY%", pPolicy);
                emailBody = GeneralUtilities.ReplaceCaseInsensitive(emailBody, "%POLICIES%", pPolicy);
            }

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="toEmail"></param>
        /// <param name="toName"></param>
        /// <param name="fromEmail"></param>
        /// <param name="fromName"></param>
        /// <param name="CC"></param>
        /// <param name="BCC"></param>
        /// <param name="subject"></param>
        /// <param name="body"></param>
        /// <param name="serverName"></param>
        public void SendEmail(string toEmail, string toName, string fromEmail, string fromName, string CC, string BCC, string subject, string body, string serverName)
        {
            MailMessage objMail = new MailMessage(getOnBehalfOfEmail(), toEmail, subject, body);
            
            objMail.IsBodyHtml = true;

            objMail.From = new MailAddress(getOnBehalfOfEmail());

            objMail.Sender = new MailAddress(fromEmail);

            SmtpClient SmtpMail = new SmtpClient(serverName);
            SmtpMail.Credentials = new System.Net.NetworkCredential();

            //SmtpClient SmtpMail = new SmtpClient("smtp.nsw.exemail.com.au");
            //SmtpMail.DeliveryMethod = System.Net.Mail.SmtpDeliveryMethod.Network;
            //SmtpMail.Credentials = new System.Net.NetworkCredential("PROD\\custadmin", "Cs8UwHMVCycHThNU");//.CredentialCache.DefaultNetworkCredentials;
            
            objMail.Headers.Add("Reply-To", objMail.Sender.ToString());
            objMail.ReplyTo = objMail.Sender;
            int milliseconds = 1000;
            Thread.Sleep(milliseconds);
            SmtpMail.Send(objMail);            
        }


        private string getOnBehalfOfEmail()
        {
            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

            string strSQL = @"select dbo.udfUser_GetAdministratorsOnBehalfOfEmailAddress(1) as onbehalfof";

            DataTable dtOnBehalfOf = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];

            return dtOnBehalfOf.Rows[0]["onbehalfof"].ToString();

        }

		/// <summary>
		/// Searches for the users within the current organisation, in the specified units.
		/// </summary>
		/// <param name="organisationID"></param>
		/// <param name="unitIDs">comma seperated list of unit ids</param>
		/// <remarks>
		/// Author: Mark Donald 03/08/2009
		/// Changes:
		/// </remarks>
		/// <returns>DataTable of user details</returns>
		public DataTable GetUsersToEmail (int organisationID, string unitIDs)
		{
			using(StoredProcedure sp = new StoredProcedure("prcEmail_Users",
					  StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID),
					  StoredProcedure.CreateInputParam("@unitIDs", SqlDbType.VarChar,-1, unitIDs)
					  ))																																													
			{
				return sp.ExecuteTable();
			}
		}

        public void purgeAutoEmails()
        {
            using (StoredProcedure sp = new StoredProcedure("prcEmail_Purge"))
            {
                sp.ExecuteNonQuery();
            }
 
        }

        


    }

}
