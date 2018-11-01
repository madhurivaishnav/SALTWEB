namespace Bdw.Application.Salt.Web.General.UserControls
{
	using System;
	using System.Data;
	using System.Drawing;
	using System.Web;
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
    using System.Text;
    using System.Security.Cryptography;
    using System.IO;

	/// <summary>
	///		Summary description for Login.
	/// </summary>
	public partial class Login : System.Web.UI.UserControl
	{
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
        
        /// <summary>
        /// Login button
        /// </summary>
		protected System.Web.UI.WebControls.Button btnLogin;

		



		//private string c_strPermissionError="An illegal action was performed or your role has been changed. You have been logged out of [APPNAME].";
		//private string c_strLoginDetailsError="The login details you have entered are not correct.";
		//private string c_strInactiveError="Your login was not successful.  Please see your Organisation Administrator.";

        /// <summary>
        /// Page load event handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, System.EventArgs e)
        {
            litLogin.Text = ResourceManager.GetString("pagTitle");
            txtUserName.Focus();
            Organisation getorgdetails = new Organisation();
            string strlnk = Request.Url.Authority.ToString();
            DataTable dtorgdetails = getorgdetails.GetOrganisationwithDomainName(Request.Url.Authority.ToString());
            //DataTable dtorgdetails = getorgdetails.GetOrganisationwithDomainName("demo.saltcompliance.com");
            if (dtorgdetails.Rows.Count > 0)
            {
                if (dtorgdetails.Rows[0]["EnableUniqueURL"].ToString() == "True")
                {
                    urlRequest.Visible = true;
                }
                else
                {
                    urlRequest.Visible = false;
                }
            }

            if (!Page.IsPostBack)
            {

                string strRedirectUrl;
                strRedirectUrl = Request.QueryString["ReturnUrl"];
                if (strRedirectUrl != null && strRedirectUrl.ToLower() != "/default.aspx")
                {
                    //this.lblErrorMessage.Text =String.Format(ResourceManager.GetString("Message.Permission"), ApplicationSettings.AppName);//c_strPermissionError.Replace("[APPNAME]",ApplicationSettings.AppName);
                    //this.lblErrorMessage.CssClass = "WarningMessageLoginPage";49182643
                }
                string AutoLoginUserID, AutoLoginEncPass;
                AutoLoginUserID = Request.QueryString["AutoLgnUSID"];
                AutoLoginEncPass = Request.QueryString["AutoLgnPass"];
                if (AutoLoginUserID != null && AutoLoginEncPass != null)
                {
                    User objUser = new User();
                    DataTable dtbAuthentication1;
                    DataTable dtbAuthentication;
                    int intUserID = 0;
                    if (Request.QueryString["AutoLgnUSID"] != null)
                    {
                        intUserID = int.Parse(Request.QueryString["AutoLgnUSID"].ToString());
                    }
                    string strPassword = Request.QueryString["AutoLgnPass"];


                    dtbAuthentication = objUser.GetUser(intUserID);
                    dtbAuthentication1 = objUser.Login(dtbAuthentication.Rows[0]["UserName"].ToString(), Request.Url.Host);
                    if (dtbAuthentication.Rows.Count > 0)
                    {
                        txtUserName.Text = dtbAuthentication.Rows[0]["UserName"].ToString();
                        txtUserName.ReadOnly = true;

                        if (dtbAuthentication.Rows[0]["EncryptPassword"].ToString() == strPassword && bool.Parse(dtbAuthentication.Rows[0]["AccessStatus"].ToString()) == false)
                        {

                            objUser.UpdatePassword(intUserID, dtbAuthentication.Rows[0]["Password"].ToString(), strPassword);

                            bool blnAdvancedReporting;
                            string strOrgLog;
                            string strUserName = dtbAuthentication.Rows[0]["UserName"].ToString();
                            int intUserTypeID, intOrganisationID, intLoginFailCount;
                            intUserID = (int)dtbAuthentication.Rows[0]["UserID"];
                            intUserTypeID = (int)dtbAuthentication.Rows[0]["UserTypeID"];

                            // Password login successful - reset the login attempts for the
                            // UserID back to 0
                            intLoginFailCount = 0;
                            objUser.UpdateLoginAttempts(intUserID, intLoginFailCount);

                            if (dtbAuthentication.Rows[0]["OrganisationID"] == DBNull.Value)
                            {
                                // The person must be a salt admin so just select the first organisation by default
                                Organisation objOrganisation = new Organisation();
                                // Data table to hold the organisation details.
                                DataTable dtbOrganisationDetails;
                                // Get a list of all organisations
                                dtbOrganisationDetails = objOrganisation.GetOrganisationList();
                                if (dtbOrganisationDetails.Rows.Count > 0)
                                {
                                    intOrganisationID = (int)dtbOrganisationDetails.Rows[0]["OrganisationID"];
                                }
                                else
                                {
                                    intOrganisationID = 0;
                                }
                            }
                            else
                            {
                                intOrganisationID = (int)dtbAuthentication.Rows[0]["OrganisationID"];
                            }

                            objUser.LogLogin(intUserID);
                            strOrgLog = dtbAuthentication1.Rows[0]["Logo"].ToString();

                            if ((UserType)intUserTypeID == UserType.SaltAdmin)
                            {
                                blnAdvancedReporting = true;
                            }
                            else
                            {
                                blnAdvancedReporting = (bool)dtbAuthentication1.Rows[0]["AdvancedReporting"];
                            }

                            UserData objUserData = new UserData((UserType)intUserTypeID, intOrganisationID, strOrgLog, blnAdvancedReporting);

                            WebSecurity.SetAuthData(intUserID.ToString(), objUserData.ToString());
                            if (Request.Url.Host.ToLower().Equals("127.0.0.2"))
                            {
                                Response.Redirect("https://127.0.0.2/Default.aspx");

                            }

                            else
                            {
                                //Response.Redirect("http://"+Request.Url.Host+"/Default.aspx");
                                Response.Redirect("http://" + Request.Url.Authority + "/Default.aspx");//Modified by Joseph for local testing
                                //Response.Redirect("http://localhost:51864/Default.aspx");//Modified by Joseph for local testing
                            }


                        }
                        else
                        {

                            lblErrorMessage.Text = "Url already used!!";
                            lblErrorMessage.ForeColor = System.Drawing.Color.Red;
                        }
                    }
                }



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
			Bind_FlagRepeater();
		}
		
		/// <summary>
		///		Required method for Designer support - do not modify
		///		the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			rptFlag.ItemCreated+=new RepeaterItemEventHandler(rptFlag_ItemCreated);
			ddlLanguageList.SelectedIndexChanged+=new EventHandler(ddlLanguageList_SelectedIndexChanged);
            this.Load += new System.EventHandler(this.Page_Load);
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

        //public static string Encrypt(string strData)
        //{

        //    return Convert.ToBase64String(Encrypt(Encoding.UTF8.GetBytes(strData)));
        //    // reference https://msdn.microsoft.com/en-us/library/ds4kkd55(v=vs.110).aspx

        //}

        public static class Global
        {
            // set password
            //public const string strPassword = "LetMeIn99$";

            // set permutations
            public const String strPermutation = "ouiveyxaqtd";
            public const Int32 bytePermutation1 = 0x19;
            public const Int32 bytePermutation2 = 0x59;
            public const Int32 bytePermutation3 = 0x17;
            public const Int32 bytePermutation4 = 0x41;
        }
        //// decoding
        //public static string Decrypt(string strData)
        //{
        //    return Encoding.UTF8.GetString(Decrypt(Convert.FromBase64String(strData)));
        //    // reference https://msdn.microsoft.com/en-us/library/system.convert.frombase64string(v=vs.110).aspx

        //}

        //// encrypt
        
        //public static byte[] Encrypt(byte[] strData)
        //{
        //    PasswordDeriveBytes passbytes =
        //    new PasswordDeriveBytes(Global.strPermutation,
        //    new byte[] { Global.bytePermutation1,
        //                 Global.bytePermutation2,
        //                 Global.bytePermutation3,
        //                 Global.bytePermutation4
        //    });

        //    MemoryStream memstream = new MemoryStream();
        //    Aes aes = new AesManaged();
        //    aes.Key = passbytes.GetBytes(aes.KeySize / 8);
        //    aes.IV = passbytes.GetBytes(aes.BlockSize / 8);

        //    CryptoStream cryptostream = new CryptoStream(memstream,
        //    aes.CreateEncryptor(), CryptoStreamMode.Write);
        //    cryptostream.Write(strData, 0, strData.Length);
        //    cryptostream.Close();
        //    return memstream.ToArray();
        //}

        //// decrypt
        //public static byte[] Decrypt(byte[] strData)
        //{
        //    PasswordDeriveBytes passbytes =
        //    new PasswordDeriveBytes(Global.strPermutation,
        //    new byte[] { Global.bytePermutation1,
        //                 Global.bytePermutation2,
        //                 Global.bytePermutation3,
        //                 Global.bytePermutation4
        //    });

        //    MemoryStream memstream = new MemoryStream();
        //    Aes aes = new AesManaged();
        //    aes.Key = passbytes.GetBytes(aes.KeySize / 8);
        //    aes.IV = passbytes.GetBytes(aes.BlockSize / 8);

        //    CryptoStream cryptostream = new CryptoStream(memstream,
        //    aes.CreateDecryptor(), CryptoStreamMode.Write);
        //    cryptostream.Write(strData, 0, strData.Length);
        //    cryptostream.Close();
        //    return memstream.ToArray();
        //}

		protected void btnLogin_Click(object sender, System.EventArgs e)
		{
            string inputString="Password"+DateTime.Now;
            SHA256 sha256 = SHA256Managed.Create();
            byte[] bytes = Encoding.UTF8.GetBytes(inputString);
            byte[] hash = sha256.ComputeHash(bytes);
            string str= GetStringFromHash(hash);

			User objUser = new User();
			DataTable dtbAuthentication;
			int intUserID,intUserTypeID, intOrganisationID, intLoginFailCount;
			string strOrgLog;
            string strUserName = txtUserName.Text;
			bool blnAdvancedReporting;


            try
            {
                //dtbAuthentication = objUser.Login(strUserName,Request.Url.Host);
                dtbAuthentication = objUser.Login(strUserName, "demo.saltcompliance.com");
                //dtbAuthentication = objUser.Login(strUserName, "arabbank.saltcompliance.com");


                //Test Code

                //string encPass = Encrypt(txtPassword.Text.ToString().Trim());
                //string decPass = Decrypt(txtPassword.Text.ToString().Trim());
                //End test coded

                //1. User name doesn't exist
                if (dtbAuthentication.Rows.Count == 0)
                {
                    lblErrorMessage.Text = ResourceManager.GetString("Message.LoginFailure");
                    this.lblErrorMessage.CssClass = "WarningMessageLoginPage";
                }
                // Password Lockout - Check login attempts by UserID and if greater than 3 then
                // inform user that they have been locked out

                //1.1. User has unsucessfully attempted to login three times 
                else if ((int.Parse(dtbAuthentication.Rows[0]["LoginFailCount"].ToString()) >= 3))
                {
                    lblErrorMessage.Text = ResourceManager.GetString("Message.PasswordLockout");
                    this.lblErrorMessage.CssClass = "WarningMessageLoginPage";
                }
                //2. Password is not correct
                else if (dtbAuthentication.Rows[0]["Password"].ToString() != txtPassword.Text)
                {
                    lblErrorMessage.Text = ResourceManager.GetString("Message.LoginFailure");
                    this.lblErrorMessage.CssClass = "WarningMessageLoginPage";
                    //Password Lockout - increment login attempts for the UserID (but only if not SaltAdmin)
                    if (((UserType)int.Parse(dtbAuthentication.Rows[0]["UserTypeID"].ToString()) != UserType.SaltAdmin) && (bool.Parse(dtbAuthentication.Rows[0]["PasswordLockout"].ToString()) == true))
                    {
                        intUserID = (int)dtbAuthentication.Rows[0]["UserID"];
                        intLoginFailCount = int.Parse(dtbAuthentication.Rows[0]["LoginFailCount"].ToString());
                        intLoginFailCount++;
                        objUser.UpdateLoginAttempts(intUserID, intLoginFailCount);
                    }
                }
                //3. The user is has a status of inactive.
                else if (!(bool)dtbAuthentication.Rows[0]["Active"])
                {
                    lblErrorMessage.Text = ResourceManager.GetString("Message.LoginFailure2");
                    this.lblErrorMessage.CssClass = "WarningMessageLoginPage";
                }
                else
                {

                    intUserID = (int)dtbAuthentication.Rows[0]["UserID"];
                    intUserTypeID = (int)dtbAuthentication.Rows[0]["UserTypeID"];

                    // Password login successful - reset the login attempts for the
                    // UserID back to 0
                    intLoginFailCount = 0;
                    objUser.UpdateLoginAttempts(intUserID, intLoginFailCount);

                    if (dtbAuthentication.Rows[0]["OrganisationID"] == DBNull.Value)
                    {
                        // The person must be a salt admin so just select the first organisation by default
                        Organisation objOrganisation = new Organisation();
                        // Data table to hold the organisation details.
                        DataTable dtbOrganisationDetails;
                        // Get a list of all organisations
                        dtbOrganisationDetails = objOrganisation.GetOrganisationList();
                        if (dtbOrganisationDetails.Rows.Count > 0)
                        {
                            intOrganisationID = (int)dtbOrganisationDetails.Rows[0]["OrganisationID"];
                        }
                        else
                        {
                            intOrganisationID = 0;
                        }
                    }
                    else
                    {
                        intOrganisationID = (int)dtbAuthentication.Rows[0]["OrganisationID"];
                    }

                    objUser.LogLogin(intUserID);
                    strOrgLog = dtbAuthentication.Rows[0]["Logo"].ToString();

                    if ((UserType)intUserTypeID == UserType.SaltAdmin)
                    {
                        blnAdvancedReporting = true;
                    }
                    else
                    {
                        blnAdvancedReporting = (bool)dtbAuthentication.Rows[0]["AdvancedReporting"];
                    }

                    UserData objUserData = new UserData((UserType)intUserTypeID, intOrganisationID, strOrgLog, blnAdvancedReporting);

                    WebSecurity.SetAuthData(intUserID.ToString(), objUserData.ToString());
                    if (Request.Url.Host.ToLower().Equals("127.0.0.2"))
                    {
                        Response.Redirect("https://127.0.0.2/Default.aspx");

                    }

                    else
                    {
                        //Response.Redirect("http://"+Request.Url.Host+"/Default.aspx");
                        Response.Redirect("http://" + Request.Url.Authority + "/Default.aspx");//Modified by Joseph for local testing
                        //Response.Redirect("http://localhost:51864/Default.aspx");//Modified by Joseph for local testing
                    }
                    //FormsAuthentication.RedirectFromLoginPage(strUserName, true);

                }
            }
            catch
            {
                string connectionString = ConfigurationSettings.AppSettings["RptConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
                dtbAuthentication = objUser.Login228(strUserName, Request.Url.Host, connectionString);
                //dtbAuthentication = objUser.Login(strUserName, "demo.saltcompliance.com");
                if (dtbAuthentication.Rows[0]["Password"].ToString() != txtPassword.Text)
                {
                    lblErrorMessage.Text = ResourceManager.GetString("Message.LoginFailure");
                    this.lblErrorMessage.CssClass = "WarningMessageLoginPage";
                }
                else
                {

                    intUserID = (int)dtbAuthentication.Rows[0]["UserID"];
                    intUserTypeID = (int)dtbAuthentication.Rows[0]["UserTypeID"];

                    // Password login successful - reset the login attempts for the
                    // UserID back to 0
                    intLoginFailCount = 0;


                    if (dtbAuthentication.Rows[0]["OrganisationID"] == DBNull.Value)
                    {
                        // The person must be a salt admin so just select the first organisation by default
                        Organisation objOrganisation = new Organisation();
                        // Data table to hold the organisation details.
                        DataTable dtbOrganisationDetails;
                        // Get a list of all organisations
                        dtbOrganisationDetails = objOrganisation.GetOrganisationList228(connectionString);
                        if (dtbOrganisationDetails.Rows.Count > 0)
                        {
                            intOrganisationID = (int)dtbOrganisationDetails.Rows[0]["OrganisationID"];
                        }
                        else
                        {
                            intOrganisationID = 0;
                        }
                    }
                    else
                    {
                        intOrganisationID = (int)dtbAuthentication.Rows[0]["OrganisationID"];
                    }

                    objUser.LogLogin(intUserID);
                    strOrgLog = dtbAuthentication.Rows[0]["Logo"].ToString();

                    if ((UserType)intUserTypeID == UserType.SaltAdmin)
                    {
                        blnAdvancedReporting = true;
                    }
                    else
                    {
                        blnAdvancedReporting = (bool)dtbAuthentication.Rows[0]["AdvancedReporting"];
                    }

                    UserData objUserData = new UserData((UserType)intUserTypeID, intOrganisationID, strOrgLog, blnAdvancedReporting);

                    WebSecurity.SetAuthData(intUserID.ToString(), objUserData.ToString());
                    if (Request.Url.Host.ToLower().Equals("127.0.0.2"))
                    {
                        Response.Redirect("https://127.0.0.2/Default.aspx");

                    }

                    else
                    {

                        //Response.Redirect("http://"+Request.Url.Host+"/Default.aspx");
                        Response.Redirect("http://" + Request.Url.Authority + "/Default.aspx");//Modified by Joseph for local testing
                        //Response.Redirect("http://localhost:51864/Default.aspx");//Modified by Joseph for local testing
                    }

                    //FormsAuthentication.RedirectFromLoginPage(strUserName, true);

                }
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
			if(e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
			{
				LangValue langValue = (LangValue)e.Item.DataItem;

				ImageButton imgFlag = (ImageButton)e.Item.FindControl("imgFlag");
				imgFlag.ImageUrl = "/General/Images/Flags/" + langValue.LangCode + ".jpg";
				imgFlag.AlternateText = langValue.LangEntryValue;
				imgFlag.CommandArgument = langValue.LangCode;
				imgFlag.Command+=new CommandEventHandler(imgFlag_Command);
			}
		}

		private void imgFlag_Command(object sender, CommandEventArgs e)
		{
            
			Response.Redirect(Request.Url.Scheme+"//"+Request.Url.Host+Request.Url.LocalPath+"?l=" + e.CommandArgument.ToString());
		}

		private void ddlLanguageList_SelectedIndexChanged(object sender, EventArgs e)
		{
            Response.Redirect(Request.Url.Scheme + "//" + Request.Url.Host + Request.Url.LocalPath + "?l=" + ddlLanguageList.SelectedValue.ToString());
		}
		#endregion

	}
}
