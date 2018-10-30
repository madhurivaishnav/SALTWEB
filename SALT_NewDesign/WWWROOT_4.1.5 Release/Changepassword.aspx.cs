/*
 * This page can be customized by BDW developers. There are no business logic behind this, all contents are static html,
 * The user control login.ascx encapsulated all user authentication logic.
 * 
 * 
 * */
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


using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.Web.Utilities;
using Localization;
using System.Collections;
using System.Configuration;

using System.Web.Security;
using Bdw.Application.Salt.App_Code.API;
using Bdw.Application.Salt.App_Code.Entity;

namespace Bdw.Application.Salt.Web
{
    /// <summary>
    /// Summary description for Login.
    /// </summary>
    public partial class Changepassword : System.Web.UI.Page
    {
        #region Protected Variables
        /// <summary>
        /// Dynamic application name in small font (eg. 'salt')
        /// </summary>
        protected System.Web.UI.WebControls.Label lblApplicationNameSmall;

        /// <summary>
        /// Dynamic application name (eg. 'salt')
        /// </summary>
        protected System.Web.UI.WebControls.Label lblApplicationName;

        /// <summary>
        /// User control to login with.
        /// </summary>
        protected Bdw.Application.Salt.Web.General.UserControls.Login Login1;

        /// <summary>
        /// 1st Label for formatted Trademark text
        /// </summary>
        protected System.Web.UI.WebControls.Label lblTradeMark1;

        /// <summary>
        /// 2nd Label for formatted Trademark text
        /// </summary>
        protected System.Web.UI.WebControls.Label lblTradeMark2;

        /// <summary>
        /// hyperlink that opens the company website - driven by app configuration
        /// </summary>
        protected System.Web.UI.WebControls.HyperLink lnkCompany;

        /// <summary>
        /// Label for copyright year text
        /// </summary>
        protected System.Web.UI.WebControls.Label lblCopyrightYear;

        /// <summary>
        /// Link for privacy policy text
        /// </summary>
        protected System.Web.UI.WebControls.HyperLink lnkPrivacyPolicy;

        /// <summary>
        /// hyperlink that opens the company terms of use - driven by app configuration
        /// </summary>
        protected System.Web.UI.WebControls.HyperLink lnkTermsOfUse;
        /// <summary>
        /// Label for the error message
        /// </summary>
        protected System.Web.UI.WebControls.Label lblErrorMessage;

        /// <summary>
        /// Textbox for the username
        /// </summary>
        protected System.Web.UI.WebControls.TextBox txtUserName;

        /// <summary>
        /// Textbox for the password
        /// </summary>
        protected System.Web.UI.WebControls.TextBox txtPassword;

        /// <summary>
        /// Validator for username field
        /// </summary>
        protected System.Web.UI.WebControls.RequiredFieldValidator vldUserName;

        /// <summary>
        /// Validator for password field
        /// </summary>
        protected System.Web.UI.WebControls.RequiredFieldValidator vldPassword;
        protected System.Web.UI.HtmlControls.HtmlControl divchangepassword;




        #endregion

        /// <summary>
        /// Event handler for the page load
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, System.EventArgs e)
        {
            litLogin.Text = ResourceManager.GetString("pagTitle");
            txtUserName.Focus();
            try
            {

                if (!Page.IsPostBack)
                {
                    User objUser = new User();
                    DataTable dtbAuthentication;
                   // DataTable dtbUserOrgPassLock;
                    int intUserID = int.Parse(Request.QueryString["UID"].ToString());
                    string strPassword = Request.QueryString["P"].ToString();
                    //dtbUserOrgPassLock = objUser.GetUserOrganisation(intUserID);
                    //if (dtbUserOrgPassLock.Rows.Count > 0)
                    //{
                    //    if (dtbUserOrgPassLock.Rows[0]["PasswordLockout"].ToString().Trim().ToLower() == "true")
                    //    {
                            dtbAuthentication = objUser.GetUser(intUserID);
                            if (dtbAuthentication.Rows.Count > 0)
                            {
                                txtUserName.Text = dtbAuthentication.Rows[0]["UserName"].ToString();
                                txtUserName.ReadOnly = true;

                                if (dtbAuthentication.Rows[0]["EncryptPassword"].ToString() == strPassword && bool.Parse(dtbAuthentication.Rows[0]["AccessStatus"].ToString()) == false)
                                {
                                    btnChangePassword.Visible = true;
                                    divchangepassword.Visible = true;
                                }
                                else
                                {
                                    btnChangePassword.Visible = false;
                                    divchangepassword.Visible = false;
                                    lblErrorMessage.Text = "Url already used!!";
                                    lblErrorMessage.ForeColor = System.Drawing.Color.Red;
                                }
                            }
                    //    }
                    //    else
                    //    {
                    //        lblErrorMessage.Text = "You dont have permission to change the password. Please contact your administrator.";
                    //        lblErrorMessage.ForeColor = System.Drawing.Color.Red;
                    //    }
                    //}
                    
                }

                pagTitle.InnerText = ResourceManager.GetString("pagTitle");
                if (VerifyDatabaseConnection())
                {
                    // Put user code to initialize the page here
                    string strApplicationName = Utilities.ApplicationSettings.AppName; // the name of the application
                    string strTradeMarkSymbol = Utilities.ApplicationSettings.TradeMark; // The trade mark symbol if there is one or an empty string
                    this.lblApplicationNameSmall.Text = strApplicationName;
                    this.lblApplicationName.Text = strApplicationName;
                    this.lblTradeMark1.Text = strTradeMarkSymbol;
                    this.lblTradeMark2.Text = strTradeMarkSymbol;
                    this.lblCopyrightYear.Text = Utilities.ApplicationSettings.CopyrightYear;
                    this.lnkCompany.Text = Utilities.ApplicationSettings.BrandingCompanyName;
                    this.lnkCompany.NavigateUrl = Utilities.ApplicationSettings.BrandingCompanyURL;
                    this.lnkTermsOfUse.NavigateUrl = Utilities.ApplicationSettings.TermsOfUseURL;
                    this.lnkPrivacyPolicy.NavigateUrl = Utilities.ApplicationSettings.PrivacyPolicyURL;
                }
                else
                {
                    //Response.Write("Application Unavailable");

                    Response.Write(ResourceManager.GetString("lblSaltUnavailable"));
                    Response.End();
                }
            }
            catch
            {

            }
        }
        protected void cvlConfirmPassword_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
        {
            if (txtConfirmPassword.Text.Length == 0 && txtPassword.Text.Length > 0)
            {
                args.IsValid = false;
            }
            else
            {
                args.IsValid = true;
            }
        }
        private bool VerifyDatabaseConnection()
        {
            try
            {
                string strTemp = "";
                // Just call a stored procedure and discard its return value
                using (StoredProcedure sp = new StoredProcedure("prcVersion_Get"))
                {
                    strTemp = sp.ExecuteScalar().ToString();
                }
                return (true);
            }
            catch
            {
                return (false);
            }
        }
        #region Web Form Designer generated code

        /// <summary>
        /// This call is required by the ASP.NET Web Form Designer.
        /// </summary>
        /// <param name="e">EventArgs</param>
        override protected void OnInit(EventArgs e)
        {
            //
            // CODEGEN: This call is required by the ASP.NET Web Form Designer.
            //
            InitializeComponent();
            base.OnInit(e);
            Bdw.Application.Salt.BusinessServices.ESTimeZone objTimeZone = new Bdw.Application.Salt.BusinessServices.ESTimeZone();
            objTimeZone.AddNewTimeZones();

            Bind_FlagRepeater();

        }

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.ID = "Login";
            this.Load += new System.EventHandler(this.Page_Load);
        }
        #endregion
        protected void btnChangePassword_Click(object sender, System.EventArgs e)
        {
            try
            {
                if (Page.IsValid)
                {
                    if (txtPassword.Text.Length != 0)
                    {
                        User objUser = new User();
                        int intUserID = int.Parse(Request.QueryString["UID"].ToString());
                        string strPassword = Request.QueryString["P"].ToString();
                        objUser.UpdatePassword(intUserID, txtPassword.Text, strPassword);
                        if (Boolean.Parse(ConfigurationSettings.AppSettings["EnableSSL"].ToString()) == true)
                        {
                            Response.Redirect("https://" + Request.Url.Host + FormsAuthentication.LoginUrl);
                        }
                        else
                        {
                            Response.Redirect("http://" + Request.Url.Host + FormsAuthentication.LoginUrl);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblErrorMessage.Text = "Invalid data!!";
                lblErrorMessage.ForeColor = System.Drawing.Color.Red;

            }


        }
        #region LanguageStuff
        private void Bind_FlagRepeater()
        {
            ArrayList flagList = null;

            bool languagePreviewMode = false;
            if (Request.Cookies["LanguagePreviewMode"] != null)
                languagePreviewMode = (Request.Cookies["LanguagePreviewMode"].Value.ToString() == "1");

            flagList = LangValueAPI.LoadFlagList(!languagePreviewMode);

            if (Boolean.Parse(ConfigurationSettings.AppSettings["ShowLanguageFlags"].ToString()) == true)
            {
                rptFlag.Visible = true;
                rptFlag.DataSource = flagList;
                rptFlag.DataBind();
            }
            else
            {
                ddlLanguageList.Visible = true;

                ddlLanguageList.DataTextField = "LangEntryValue";
                ddlLanguageList.DataValueField = "LangCode";

                ddlLanguageList.DataSource = flagList;
                ddlLanguageList.DataBind();

                if (Request.QueryString["l"] != null && ddlLanguageList.Items.FindByValue(Request.QueryString["l"].ToString()) != null)
                    ddlLanguageList.SelectedValue = Request.QueryString["l"].ToString();
                else if (Request.Cookies["currentCulture"] != null && ddlLanguageList.Items.FindByValue(Request.Cookies["currentCulture"].Value) != null)
                    ddlLanguageList.SelectedValue = Request.Cookies["currentCulture"].Value;
            }
        }
        private void rptFlag_ItemCreated(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LangValue langValue = (LangValue)e.Item.DataItem;

                ImageButton imgFlag = (ImageButton)e.Item.FindControl("imgFlag");
                imgFlag.ImageUrl = "/General/Images/Flags/" + langValue.LangCode + ".jpg";
                imgFlag.AlternateText = langValue.LangEntryValue;
                imgFlag.CommandArgument = langValue.LangCode;
                imgFlag.Command += new CommandEventHandler(imgFlag_Command);
            }
        }
        private void imgFlag_Command(object sender, CommandEventArgs e)
        {

            Response.Redirect(Request.Url.Scheme + "//" + Request.Url.Host + Request.Url.LocalPath + "?l=" + e.CommandArgument.ToString());
        }
        private void ddlLanguageList_SelectedIndexChanged(object sender, EventArgs e)
        {
            Response.Redirect(Request.Url.Scheme + "//" + Request.Url.Host + Request.Url.LocalPath + "?l=" + ddlLanguageList.SelectedValue.ToString());
        }
        #endregion
    }
}
