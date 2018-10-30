using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.Web.Utilities;
using Localization;

namespace Bdw.Application.Salt.Web.Administration.Users
{
    public partial class UserReceivedEmails : System.Web.UI.Page
    {
        /// <summary>
        /// Users user id from querystring
        /// </summary>
        protected int m_intUserID;

        /// <summary>
        /// Counter for alternating row in email list
        /// </summary>
        protected int rowEmailList;

        protected void Page_Load(object sender, EventArgs e)
        {
            ResourceManager.RegisterLocaleResource("ConfirmMessage.Resend");
            pagTitle.InnerText = ResourceManager.GetString("pagTitle");
            this.m_intUserID = int.Parse(Request.QueryString["UserID"]);

            WebSecurity.CheckUserAdministrator(this.m_intUserID);

            if (!Page.IsPostBack)
            {
                LoadData();
            }	
        }

        /// <summary>
        /// Load data the page is first loaded
        /// </summary>
        private void LoadData()
        {
            DateTime dteDateFrom, dteDateTo;
            BusinessServices.User objUser;
            DataTable dtbUser;
            string strName, strEmail;
            int intOrganisationID;

            objUser = new BusinessServices.User();
            dtbUser = objUser.GetUser(this.m_intUserID);

            strName = dtbUser.Rows[0]["FirstName"].ToString() + " " + dtbUser.Rows[0]["LastName"].ToString();
            strEmail = dtbUser.Rows[0]["Email"].ToString();
            intOrganisationID = (int)dtbUser.Rows[0]["OrganisationID"];

            // set to the past to search for emails from the beginning
            // maybe there is a better way to set to the beginning but right now use the hardcoded values
            dteDateFrom = new DateTime(1990, 1, 1);
            dteDateTo = DateTime.Now;

            BusinessServices.Email objEmail = new BusinessServices.Email();
            DataTable dtbEmails = objEmail.SearchByUserID(this.m_intUserID, intOrganisationID);

            if (dtbEmails.Rows.Count == 0)
            {
                this.lblMessage.Text = ResourceManager.GetString("lblMessage.NoEmails");
                this.lblMessage.CssClass = "WarningMessage";
                this.lblMessage.Visible = true;
            }
            else
            {
                this.rptEmailList.DataSource = dtbEmails;
                this.rptEmailList.DataBind();		
                this.lblMessage.Visible = false;
            }
        }

        protected void rptEmailList_ItemCommand(object sender, RepeaterCommandEventArgs e)
        {

            if (e.CommandName == "ResendEmail")
            {
                BusinessServices.User objUser;
                int intOrganisationID, emailID;

                // get the user TO info
                objUser = new BusinessServices.User();
                DataTable dtbUser = objUser.GetUser(this.m_intUserID);
                intOrganisationID = (int)dtbUser.Rows[0]["OrganisationID"];

                // get the user FROM info
                DataTable dtbCurrentUser = objUser.GetUser(UserContext.UserID);

                // convert the emailID text to int
                bool result = Int32.TryParse(e.CommandArgument.ToString(), out emailID);
                if (result)
                {
                    BusinessServices.Email objEmail = new BusinessServices.Email();
                    DataTable dtbEmails = objEmail.Search(emailID, intOrganisationID);

                    if (dtbEmails.Rows.Count != 0)
                    {
                        string strEmailTo = dtbEmails.Rows[0]["toemail"].ToString();
                        string strNameTo = dtbUser.Rows[0]["FirstName"].ToString() + " " + dtbUser.Rows[0]["LastName"].ToString();
                        string strEmailFrom = dtbCurrentUser.Rows[0]["email"].ToString();
                        string strNameFrom = dtbCurrentUser.Rows[0]["FirstName"].ToString() + " " + dtbCurrentUser.Rows[0]["LastName"].ToString();
                        
                        string strBody = dtbEmails.Rows[0]["body"].ToString();
                        string strSubject = dtbEmails.Rows[0]["subject"].ToString();

                        objEmail.setUserCopyEmailBody(strBody);
                        objEmail.SendEmail(strEmailTo, strNameTo, strEmailFrom, strNameFrom, null, null, strSubject, ApplicationSettings.MailServer, intOrganisationID, UserContext.UserID);

                        this.lblMessage.Text = ResourceManager.GetString("lblMessage.EmailSent");
                        this.lblMessage.Visible = true;
                        this.lblMessage.CssClass = "SuccessMessage";
                    }
                } 
            }
        }
    }
}
