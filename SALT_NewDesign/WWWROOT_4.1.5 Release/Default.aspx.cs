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
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.BusinessServices;

using Localization;

namespace Bdw.Application.Salt.Web
{
    /// <summary>
    /// Default page - this is the Homepage
    /// </summary>
    /// <remarks>
    /// Author: Stephen Kennedy-Clark
    /// Date: May 2004
    /// </remarks>
    public partial class Default : System.Web.UI.Page
    {
        #region Private Variables

        /// <summary>
        /// Constant: relative page a toolbook must to post back
        /// </summary>
        private const string c_strPostBackPage = "General/ToolBook/ToolBookListener.aspx";

        #endregion

        #region Protected Variables

        /// <summary>
        /// CopyRight Year label
        /// </summary>
        protected System.Web.UI.WebControls.Label lblCopyRightYear;

        /// <summary>
        /// Application name label
        /// </summary>
        protected System.Web.UI.WebControls.Label lblApplicationName;

        /// <summary>
        /// Organisation image
        /// </summary>
        protected System.Web.UI.WebControls.PlaceHolder phdOrgImage;

        /// <summary>
        /// Users name preceading welcom lesson
        /// </summary>
        protected System.Web.UI.WebControls.Label lblHomepagePersonalisation;

        /// <summary>
        /// Welcom text
        /// </summary>
        protected System.Web.UI.WebControls.Label lblHomepageWelcome;

        /// <summary>
        /// Title next to org notes - not used in version 3
        /// </summary>
        protected System.Web.UI.WebControls.Label lblOrgNotesTitle;

        /// <summary>
        /// Organisation notes
        /// </summary>
        protected System.Web.UI.WebControls.Label lblOrgNotes;

        /// <summary>
        /// Step 1 label
        /// </summary>
        protected System.Web.UI.WebControls.Label lblStep1Label;

        /// <summary>
        /// Step 1 text label
        /// </summary>
        protected System.Web.UI.WebControls.Label lblStep1Text;

        /// <summary>
        /// Step 2 label
        /// </summary>
        protected System.Web.UI.WebControls.Label lblStep2Label;

        /// <summary>
        /// Step 2 text label
        /// </summary>
        protected System.Web.UI.WebControls.Label lblStep2Text;

        /// <summary>
        /// Clurse label
        /// </summary>
        protected System.Web.UI.WebControls.Label lblCourse;

        /// <summary>
        /// Select Course Combo box
        /// </summary>
        protected System.Web.UI.WebControls.DropDownList cboSelectCourse;
        protected Localization.LocalizedHyperLink lnkViewCertificate;

        /// <summary>
        /// Modules Repeater
        /// </summary>
        protected System.Web.UI.WebControls.Repeater rptModules;

        /// <summary>
        /// Header Image
        /// </summary>
        protected System.Web.UI.HtmlControls.HtmlImage imgHeader;

        /// <summary>
        /// Div containing the certificate
        /// </summary>
        protected System.Web.UI.HtmlControls.HtmlGenericControl divViewCertificate;

        /// <summary>
        /// Header Image
        /// </summary>
        protected System.Web.UI.HtmlControls.HtmlImage imgLesson1;

        /// <summary>
        /// Home Page Footer
        /// </summary>
        protected System.Web.UI.WebControls.Label lblHomePageFooter;

        /// <summary>
        /// Hyperlink to the company
        /// </summary>
        protected System.Web.UI.WebControls.HyperLink lnkCompany;

        /// <summary>
        /// Trademark label
        /// </summary>
        protected System.Web.UI.WebControls.Label lblTradeMark;

        /// <summary>
        /// Table containing modules.
        /// </summary>
        protected System.Web.UI.HtmlControls.HtmlTable tblModule;
        protected Localization.LocalizedLabel locModule;
        protected Localization.LocalizedLabel locBegin;
        protected Localization.LocalizedLabel locQuickFacts;
        protected Localization.LocalizedLabel locStatus;
        protected Localization.LocalizedLabel Localizedlabel1;
        protected Localization.LocalizedLabel LocalizedLabel2;
        protected Localization.LocalizedLabel Localizedlabel3;
        protected Localization.LocalizedLabel lblLegend_StatusKey;
        protected Localization.LocalizedLabel lblLegend_NotStarted;
        protected Localization.LocalizedLabel lblLegend_InProgress;
        protected Localization.LocalizedLabel lblLegend_Completed;
        protected Localization.LocalizedLabel lblLegend_NewContent;
        protected Localization.LocalizedLabel lblLegend_Expired;
        protected Localization.LocalizedLabel lblLegend_Passed;
        protected Localization.LocalizedLabel lblLegend_Failed;

        /// <summary>
        /// Div holding the legend and key
        /// </summary>
        protected System.Web.UI.HtmlControls.HtmlGenericControl divKeyTable;

        /// <summary>
        /// The flag for salt Administrator to view Welcome Screen
        /// </summary>
        protected bool showWelcomeScreen;

        #endregion

        #region Private Methods

        /// <summary>
        /// Set page state
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen K-Clark, 9/02/04
        /// Changes:
        /// </remarks>
        private void SetPageState()
        {
            // if the user is a salt admin they dont have access to anything on this page
            // hide everything else and paint appropriate message.
            if (UserContext.UserData.UserType == UserType.SaltAdmin && !showWelcomeScreen)
            {
                Response.Redirect("/Administration/AdministrationHome.aspx");
            }

            // get the users Organisation ID			
            int intOrganisationID = UserContext.UserData.OrgID;

            // paint the page - Initial Condition for non administrators
            /*if(!IsPostBack && (UserContext.UserData.UserType != UserType.SaltAdmin))
            {
                PaintInitialPage(intOrganisationID);
            }*/

            if (!IsPostBack)
            {
                PaintInitialPage(intOrganisationID);

                // Application Name
                this.lblApplicationName.Text = Utilities.ApplicationSettings.AppName;
                this.lblTradeMark.Text = Utilities.ApplicationSettings.TradeMark;
                this.lblCopyRightYear.Text = Utilities.ApplicationSettings.CopyrightYear;
                this.lblHomePageFooter.Text = Utilities.ApplicationSettings.HomePageFooter;
                this.lnkCompany.Text = Utilities.ApplicationSettings.BrandingCompanyName;
                this.lnkCompany.NavigateUrl = Utilities.ApplicationSettings.BrandingCompanyURL;
            }

        } //SetPageState

        /// <summary>
        /// Paint Page
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen K-Clark, 9/02/04
        /// Changes:
        /// </remarks>
        /// <param name="courseID">ID of the course</param>
        /// <param name="userID">ID of the user</param>
        /// <param name="organisationID">ID of the organisation</param>
        /// <param name="courses">Courses must be supplied (in a datatable)</param>
        private void PaintInitialPage(int organisationID)
        {
            PaintWelcomeMessage();
            PaintOrgNotes(organisationID);
        }

        private void PaintWelcomeMessage()
        {
            BusinessServices.User objUser = new BusinessServices.User();
            DataTable dtblUserDetails = objUser.GetUser(UserContext.UserID);
            if (dtblUserDetails.Rows[0].ItemArray[1].ToString().Length != 0)
            {
                lblHomepagePersonalisation.Text = String.Format(ResourceManager.GetString("lblHi"), dtblUserDetails.Rows[0].ItemArray[1].ToString());
            }
            else
            {
                lblHomepagePersonalisation.Text = "";
            }
            this.lblHomepageWelcome.Text = String.Format(ResourceManager.GetString("lblHomepageWelcome"), Utilities.ApplicationSettings.AppName, Utilities.ApplicationSettings.TradeMark);
        }

        /// <summary>
        /// Paint Organisation Notes
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen K-Clark, 9/02/04
        /// Changes:
        /// </remarks>
        /// <param name="organisationID">Organisation ID</param>
        private void PaintOrgNotes(int organisationID)
        {
            // Paint the Org notes
            string strOrganisationNotes;
            string strLangCode = Request.Cookies["currentCulture"].Value;

            BusinessServices.Organisation objOrganisation = new BusinessServices.Organisation();
            strOrganisationNotes = Server.HtmlDecode(objOrganisation.GetOrganisationNotes(strLangCode, organisationID));
            if (strOrganisationNotes.Length != 0)
            {
                lblOrgNotesTitle.Visible = false;
                lblOrgNotes.Text = strOrganisationNotes.Trim();
                lblOrgNotes.Visible = true;
                lblOrgNotesTitle.Visible = true;
            }
            else
            {
                lblOrgNotesTitle.Visible = false;
                lblOrgNotes.Visible = false;
            }

        }

        #endregion

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
        }

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
        }
        #endregion

        #region Event Handelers


        /// <summary>
        /// Entery Point to the page
        /// </summary>
        /// <param name="sender">default object</param>
        /// <param name="e">default arguments</param>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen K-Clark, 9/02/04
        /// Changes:
        /// </remarks>
        protected void Page_Load(object sender, System.EventArgs e)
        {
            pagTitle.InnerText = ResourceManager.GetString("pagTitle");
            try
            {
                this.Context.Items["SectionTitle"] = ResourceManager.GetString("lblSectionTitle");
            }
            catch
            { 
            }
            // retrieve the parameter ShowWelcomeScreen
            string request = Request.QueryString["ShowWelcomeScreen"];
            if (request == "true")
                showWelcomeScreen = true;
            else
                showWelcomeScreen = false;


            this.lblPageTitle.Visible = false;
            SetPageState();
        }

        #endregion

    }
}
