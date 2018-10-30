using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Text;

using Bdw.Application.Salt.Web.Utilities;
using Localization;
using System.Security.Cryptography;
using System.Web.Security;
using Bdw.Application.Salt.BusinessServices;
namespace Bdw.Application.Salt.Web
{
	/// <summary>
	/// Summary description for PasswordRecovery.
	/// </summary>
	public partial class PasswordRecovery : System.Web.UI.Page
	{
    
		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
            if (!Page.IsPostBack)
            {
                //User objUser = new User();
                //DataTable dtbOrgPassLock;
                //string RedirectionCheck = Request.QueryString["Rdct"];
                //if (RedirectionCheck != "UniqueURL")
                //{
                //    dtbOrgPassLock = objUser.GetUserOrganisationPasswordLock(HttpContext.Current.Request.Url.Authority.ToString());
                //    if (dtbOrgPassLock.Rows.Count > 0)
                //    {
                //        if (dtbOrgPassLock.Rows[0]["PasswordLockout"].ToString().Trim().ToLower() == "true")
                //        {
                //            btnRecover.Visible = false;
                //            txtEmail.Visible = false;
                //            lblMessage.Text = "You dont have permission to change the password. Please contact your administrator Or proceed on with URL request on Login Page. ";
                //            lblMessage.ForeColor = Color.Red;
                //            lblMessage.CssClass = "WarningMessage";
                //        }

                //    }
                //}
             
            }
           
		}

		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    

        }
		#endregion

        private static string GetStringFromHash(byte[] hash)
        {
            StringBuilder result = new StringBuilder();
            for (int i = 0; i < hash.Length; i++)
            {
                result.Append(hash[i].ToString("X2"));
            }
            return result.ToString();
        }

        protected void btnRecover_Click(object sender, System.EventArgs e)
        {
            if (txtEmail.Text.Length>0)
            {
                //if (Request.QueryString.Count > 0)
                //{
                //    string RedirectionCheck = Request.QueryString["Rdct"].ToString().Trim();
                //    if (RedirectionCheck == "UniqueURL")
                //    {
                //        RecoverClick();
                //        //Response.Redirect("https://" + Request.Url.Host + FormsAuthentication.LoginUrl+"?Auto=entry");
                //    }
                //}//
                RecoverClick();
            }
        }

        public void RecoverClick()
        {
            string strEmail = txtEmail.Text;
            BusinessServices.User objUser = new BusinessServices.User();
            DataTable dtbUser = objUser.GetDetailsByEmailAndDomain(strEmail, HttpContext.Current.Request.Url.Host.ToString());
            //DataTable dtbUser = objUser.GetDetailsByEmailAndDomain(strEmail, "demo.saltcompliance.com");

            if (dtbUser.Rows.Count > 0 && Convert.ToBoolean(dtbUser.Rows[0]["Active"]))
            {
                // found user - gather details
                string strFirstName = dtbUser.Rows[0]["FirstName"].ToString();
                string strLastName = dtbUser.Rows[0]["LastName"].ToString();
                string strUserName = dtbUser.Rows[0]["UserName"].ToString();
                string strPassword = dtbUser.Rows[0]["Password"].ToString();
                string strUserId = dtbUser.Rows[0]["UserID"].ToString();
                //Password encryption code
                string inputString = strPassword + DateTime.Now;
                SHA256 sha256 = SHA256Managed.Create();
                byte[] bytes = Encoding.UTF8.GetBytes(inputString);
                byte[] hash = sha256.ComputeHash(bytes);
                string encryptedPassword = GetStringFromHash(hash);

                //Insert code for SP to insert new encrypted password
                objUser.UpdateEncryptedPassword(strUserName, encryptedPassword);


                string strFromName = ApplicationSettings.AppName;
                string strFromEmail = ApplicationSettings.SupportEmail;

                BusinessServices.Email objEmail = new BusinessServices.Email();
                string strHREF = "";
                string RedirectionCheck = Request.QueryString["Rdct"];
                string strBody = "";

                DataTable dtbOrgDisablePassword;
                string strDisabledpass = "";
                  dtbOrgDisablePassword = objUser.GetUserOrganisationPasswordLock(HttpContext.Current.Request.Url.Authority.ToString());
                  //dtbOrgDisablePassword = objUser.GetUserOrganisationPasswordLock("demo.saltcompliance.com");
                  if (dtbOrgDisablePassword.Rows.Count > 0)
                  {
                      if (dtbOrgDisablePassword.Rows[0]["PasswordLockout"].ToString().Trim().ToLower() == "true")
                      {
                          strDisabledpass = "Disabled";
                      }
                      else
                      {
                          strDisabledpass = "";
                      }
                  }
                  if (strDisabledpass == "Disabled")
                  {
                      strHREF = "";
                      strBody = GetBodyUniqueURL(strFirstName, strLastName, strUserName, strPassword, strUserId, encryptedPassword, strHREF);
                  }
                else if (RedirectionCheck == "UniqueURL")
                {
                    //strHREF = "http://localhost:51864/Default.aspx?AutoLgnUSID=" + strUserId + "&AutoLgnPass=" + encryptedPassword;
                    strHREF = "https://" + HttpContext.Current.Request.Url.Host + "/Default.aspx?AutoLgnUSID=" + strUserId + "&AutoLgnPass=" + encryptedPassword;
                    strBody = GetBodyUniqueURL(strFirstName, strLastName, strUserName, strPassword, strUserId, encryptedPassword, strHREF);
                }
                else
                {
                    strHREF = "https://" + HttpContext.Current.Request.Url.Host + "/ChangePassword.aspx?UID=" + strUserId + "&P=" + encryptedPassword;
                     strBody = GetBody(strFirstName, strLastName, strUserName, strPassword, strUserId, encryptedPassword, strHREF);
                }
                
                try
                {
                    // Found user send email
                    objEmail.SendEmail(strEmail, strFirstName + " " + strLastName, strFromEmail, strFromName, null, null, ResourceManager.GetString("EmailSubject"), strBody, ApplicationSettings.MailServer);
                    lblMessage.Text = String.Format(ResourceManager.GetString("lblMessage.Sent"), strEmail); //"Login Information has been sent to:<BR>" + strEmail;
                    lblMessage.CssClass = "WarningMessage";
                    btnRecover.Visible = false;
                    txtEmail.Visible = false;
                    lblText.Visible = false;

                }
                catch (Exception ex)
                {
                    // Found user but unable to send email
                    lblMessage.Text = ResourceManager.GetString("UserNotFound") + ex.Message;
                    lblMessage.CssClass = "WarningMessage";
                    btnRecover.Visible = false;
                    txtEmail.Visible = false;
                }
            }
            else
            {
                // inactive user : user not found
                lblMessage.Text = ResourceManager.GetString(dtbUser.Rows.Count > 0 ? "lblMessage.Inactive" : "lblMessage.NotFound");
                lblMessage.CssClass = "WarningMessage";
            }
        }
        /// <summary>
        /// Builds a string to populate email body with
        /// </summary>
        /// <param name="firstName"></param>
        /// <param name="lastName"></param>
        /// <param name="userName"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        private string GetBody(string firstName, string lastName,string userName, string password,string userID,string encryptedPassword, string strURL)
        {
            StringBuilder sbBody = new StringBuilder();

            string strHREF = "'" + strURL + "'";
            // Details
            sbBody.Append( firstName + " " + lastName + "," + "<BR>");
            sbBody.Append( "<BR>" );

            sbBody.Append( String.Format(ResourceManager.GetString("lblEmail.1"), ApplicationSettings.AppName));
            if (strHREF != "")
            {
                sbBody.Append("<a href=" + strHREF + ">URL</a>");
            }
            else
            {
                sbBody.Append("<BR>");
                sbBody.Append("<BR>");
                sbBody.Append(ResourceManager.GetString("litUserName") + " " + userName);
                sbBody.Append("<BR>");
                sbBody.Append(ResourceManager.GetString("litPassword") + " " + password);
            }
            sbBody.Append( "<BR>" );
            sbBody.Append( "<BR>" );

            sbBody.Append( ResourceManager.GetString("lblEmail.2"));
            sbBody.Append( "<BR>" );
            sbBody.Append( "<BR>" );

            // At
            sbBody.Append( ResourceManager.GetString("lblEmail.3"));
            sbBody.Append( "<BR>" );
            sbBody.Append( "----------------------");
            sbBody.Append( "<BR>" );
            sbBody.Append( ResourceManager.GetString("lblEmail.4"));
            sbBody.Append( "<BR>" );
            sbBody.Append( ResourceManager.GetString("lblEmail.5") + " " + DateTime.Now.ToString("dd/MM/yyyy") );
            sbBody.Append( "<BR>" );
            sbBody.Append( ResourceManager.GetString("lblEmail.6") + " " + DateTime.Now.ToLongTimeString() );
            sbBody.Append( "<BR>" );
            sbBody.Append( "<BR>" );
            
            // From
            try
            {
                sbBody.Append( ResourceManager.GetString("lblEmail.7"));
                sbBody.Append( "<BR>" );
                sbBody.Append( "----------------------");
                sbBody.Append( "<BR>" );
                sbBody.Append( ResourceManager.GetString("lblEmail.8"));
                sbBody.Append( "<BR>" );
                sbBody.Append( ResourceManager.GetString("lblEmail.9") + " " + Request.UserHostName );
                sbBody.Append( "<BR>" );
                sbBody.Append( ResourceManager.GetString("lblEmail.7") + " " + Request.UserHostAddress );
                sbBody.Append( "<BR>" );
            }
            catch {}
            
            
            return sbBody.ToString();
        }

        private string GetBodyUniqueURL(string firstName, string lastName, string userName, string password, string userID, string encryptedPassword, string strURL)
        {
            StringBuilder sbBody = new StringBuilder();

            string strHREF = "'" + strURL + "'";
            // Details
            sbBody.Append(firstName + " " + lastName + "," + "<BR>");
            sbBody.Append("<BR>");
            if (strURL.ToString().Trim() != "")
            {
                sbBody.Append("Please select the following link to automatically login, this link will only work once :");

                sbBody.Append("<a href=" + strHREF + ">URL</a>");
            }
            else
            {
                sbBody.Append("<BR>");
                sbBody.Append("<BR>");
                sbBody.Append(ResourceManager.GetString("litUserName") + " " + userName);
                sbBody.Append("<BR>");
                sbBody.Append(ResourceManager.GetString("litPassword") + " " + password);
            }
            sbBody.Append("<BR>");
            sbBody.Append("<BR>");

            sbBody.Append(ResourceManager.GetString("lblEmail.2"));
            sbBody.Append("<BR>");
            sbBody.Append("<BR>");

            // At
            sbBody.Append(ResourceManager.GetString("lblEmail.3"));
            sbBody.Append("<BR>");
            sbBody.Append("----------------------");
            sbBody.Append("<BR>");
            sbBody.Append(ResourceManager.GetString("lblEmail.4"));
            sbBody.Append("<BR>");
            sbBody.Append(ResourceManager.GetString("lblEmail.5") + " " + DateTime.Now.ToString("dd/MM/yyyy"));
            sbBody.Append("<BR>");
            sbBody.Append(ResourceManager.GetString("lblEmail.6") + " " + DateTime.Now.ToLongTimeString());
            sbBody.Append("<BR>");
            sbBody.Append("<BR>");

            // From
            try
            {
                sbBody.Append(ResourceManager.GetString("lblEmail.7"));
                sbBody.Append("<BR>");
                sbBody.Append("----------------------");
                sbBody.Append("<BR>");
                sbBody.Append(ResourceManager.GetString("lblEmail.8"));
                sbBody.Append("<BR>");
                sbBody.Append(ResourceManager.GetString("lblEmail.9") + " " + Request.UserHostName);
                sbBody.Append("<BR>");
                sbBody.Append(ResourceManager.GetString("lblEmail.7") + " " + Request.UserHostAddress);
                sbBody.Append("<BR>");
            }
            catch { }


            return sbBody.ToString();
        }

	}
}
