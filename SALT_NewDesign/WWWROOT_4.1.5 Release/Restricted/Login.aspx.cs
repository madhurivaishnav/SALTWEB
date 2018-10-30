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


using Bdw.Application.Salt.Data;

using Bdw.Application.Salt.App_Code.API;
using Bdw.Application.Salt.App_Code.Entity;
using Localization;

namespace Bdw.Application.Salt.Web
{
    /// <summary>
	/// Summary description for Login.
	/// </summary>
	public partial class Login : System.Web.UI.Page
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

        #endregion

        /// <summary>
        /// Event handler for the page load
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, System.EventArgs e)
            
        {//            bool status = Bdw.Application.Salt.Utilities.HtmlToPdf.WKHtmlToPdf("http://bgtest.saltcompliance.com/Certificate.aspx?courseid=42&profileid=-1&userid=956&orgid=2&css=default.css", "cert_sblanks_42_20141128134536123.pdf");
            //bool status = Bdw.Application.Salt.Utilities.HtmlToPdf.WKHtmlToPdf("http://localhost:58672/Certificate.aspx?courseid=42&profileid=-1&userid=956&orgid=2&css=default.css", "cert_sblanks_42_20141128134536123.pdf");
            if (!Page.IsPostBack)
            {
                //certemail(956, 42, -1);
                
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





        public void certemail(int intUserID, int intCourseID, int intProfileID)
        {
            int orgid;

            BusinessServices.User objUser = new BusinessServices.User();
            DataTable dtUser = objUser.GetUser(intUserID);
            Int32.TryParse(dtUser.Rows[0]["OrganisationID"].ToString(), out orgid);
            string username = dtUser.Rows[0]["UserName"].ToString();

            BusinessServices.AppConfig objAppConfig = new BusinessServices.AppConfig();
            DataTable dtbAppConfig = objAppConfig.GetList();
            //string strHostname = HttpContext.Current.Request.Url.Host.ToString();
            string strHostname = HttpContext.Current.Request.Url.Authority.ToString();
            bool isSSL = bool.Parse(dtbAppConfig.Select("Name='SSL'")[0]["Value"].ToString());
            string strUrl = null;
            if (strHostname.ToLower().Equals("127.0.0.2"))
            {
                strUrl = "https://" + strHostname;

            }
            else
            {
                strUrl = "http://" + strHostname;
            }
            //strUrl = "http://" + strHostname;

            Bdw.Application.Salt.BusinessServices.OrganisationConfig objOrgConfig = new Bdw.Application.Salt.BusinessServices.OrganisationConfig();
            string strCss = objOrgConfig.GetOne(orgid, "css");

            string pdfFileName = "cert_" + username + "_" + intCourseID.ToString() + "_" + DateTime.Now.ToString("yyyyMMddHHmmss") + ".pdf";

            bool status = Bdw.Application.Salt.Utilities.HtmlToPdf.WKHtmlToPdf(strUrl + @"/Certificate.aspx?courseid=" + intCourseID + "&profileid=" + intProfileID + "&userid=" + intUserID + "&orgid=" + orgid + "&css=" + strCss, pdfFileName);

            string filename = "";

            if (status)
            {
                filename = HttpContext.Current.Server.MapPath(System.Configuration.ConfigurationSettings.AppSettings["WorkingFolder"]) + "\\" + pdfFileName;
            }
            else
            {
                Bdw.Application.Salt.ErrorHandler.ErrorLog objError = new Bdw.Application.Salt.ErrorHandler.ErrorLog(new Exception("Course completion certificate"), ErrorLevel.Medium, "DefaultQuiz.cs", "GenerateCourseCompletionCertificate", "Course completion certificate generation failed: " + pdfFileName);
            }


            //sendCertEmail(intUserID, intCourseID, orgid, filename);

            try
            {
                System.IO.FileInfo fileinfo = new System.IO.FileInfo(filename);
                if (fileinfo.Exists)
                    System.IO.File.Delete(filename);
            }
            catch (Exception e)
            {
                Bdw.Application.Salt.ErrorHandler.ErrorLog objError = new Bdw.Application.Salt.ErrorHandler.ErrorLog(e, ErrorLevel.Medium, "DefaultQuiz.cs", "DeleteCourseCompletionCertificate", "Course completion certificate deletion failed: " + pdfFileName);
            }
        }

        /// <summary>
        /// Attempts to connect to the database
        /// </summary>
        /// <returns>boolean value indicating if database is available</returns>
        private bool VerifyDatabaseConnection()
        {
            try
            {
                string strTemp="";
                // Just call a stored procedure and discard its return value
                using(StoredProcedure sp = new StoredProcedure("prcVersion_Get"))
                {
                    strTemp = sp.ExecuteScalar().ToString();
                }
                return (true);
            }
            catch 
            {
                return(false);
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

        protected void Button1_Click(object sender, EventArgs e)
        {
            Bdw.Application.Salt.InfoPath.DefaultQuiz DQ = new Bdw.Application.Salt.InfoPath.DefaultQuiz();
            DQ.Quiz_End();
        }

	}
}
