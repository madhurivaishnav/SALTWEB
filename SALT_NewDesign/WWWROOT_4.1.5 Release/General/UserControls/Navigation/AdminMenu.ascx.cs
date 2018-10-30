namespace Bdw.Application.Salt.Web.General.UserControls.Navigation
{
	using System;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.Security;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;
	using Bdw.Application.Salt.Web.Utilities;
	using Bdw.Application.Salt.Data;
	using Bdw.Application.Salt.BusinessServices;
	using Localization;

	/// <summary>
	///	This class controls the administrattion menu business logic and presentation logic.
	/// The presentation logic is dependant on the logged in users permissions.
	/// It also displays a drop down list of organisations in the system if the logged in user is a 
	/// Salt Administrator.
	/// </summary>
	/// <remarks>
	/// Assumptions: None.
	/// Notes: 
	///		If the logged in user is a Salt Administrator and there is only one organisation
	///		in the system then the drop down list will not be displayed.
	///		This drop down list is another user control <see cref="Bdw.Application.Salt.Web.General.UserControls.Navigation.SelectOrganisation"/>
	///		which is loaded by this user control.
	/// Author: Peter Vranich
	/// Date: 30/01/2004
	/// Changes:
	/// </remarks>
	public partial class AdminMenu : System.Web.UI.UserControl
	{
		#region Class Declarations

		/// <summary>
		/// HTML table row control.  This controls the visibility of the organisation list user control.
		/// </summary>
        protected System.Web.UI.HtmlControls.HtmlTableRow trOrganisationList;
        
		/// <summary>
		/// Link button for the application configuration link.
		/// </summary>
		protected Localization.LocalizedLinkButton lnkAppConfig;
		
		/// <summary>
		/// Link button for the application depenancies link.
		/// </summary>
		protected Localization.LocalizedLinkButton lnkAppDependencies;
		
		/// <summary>
		/// Link button for the application auditing link.
		/// </summary>
		protected Localization.LocalizedLinkButton lnkAppAuditing;
		
		/// <summary>
		/// Link button for the view application error log link.
		/// </summary>
		protected Localization.LocalizedLinkButton lnkViewErrorLog;

        /// <summary>
        /// Link button for the view application periodic report.
        /// </summary>
        protected Localization.LocalizedLinkButton lnkPeriodicReport; //alee

        ///// <summary>
        ///// Link button for the view Mail Throughput.
        ///// </summary>
        //protected Localization.LocalizedLinkButton lnkMailThroughput;

		/// <summary>
		///  Link button for the 
		/// </summary>
        protected System.Web.UI.HtmlControls.HtmlGenericControl trApplication;
		
		/// <summary>
		/// HTML table row control.  This is used to control the visibility of the organisation menu options.
		/// </summary>
        protected System.Web.UI.HtmlControls.HtmlGenericControl trOrganisation;
		
		/// <summary>
		/// HTML table row control.  This is used to control the visibility of the unit menu options.
		/// </summary>
        protected System.Web.UI.HtmlControls.HtmlGenericControl trUnit;
		
		/// <summary>
		/// HTML table row control.  This is used to control the visibility of the user menu options.
		/// </summary>
        protected System.Web.UI.HtmlControls.HtmlGenericControl trUser;
		
		/// <summary>
		/// HTML table control.  This is used to control the visibility of the whole menu.
		/// </summary>
        protected System.Web.UI.HtmlControls.HtmlTable tblMenu;
		
		/// <summary>
		/// Link button for the organisation bulk asign users link.
		/// </summary>
		protected Localization.LocalizedLinkButton lnkBulkAssignUsers;
		
		/// <summary>
		/// Link button for the organisation course access link.
		/// </summary>
		protected Localization.LocalizedLinkButton lnkCourseAccess;
		
		/// <summary>
		/// Link button for the organisation administrators link.
		/// </summary>
		protected Localization.LocalizedLinkButton lnkOrgAdministrators;

		/// <summary>
		/// Link button for the modify organisation links link.
		/// </summary>
		protected Localization.LocalizedLinkButton lnkModifyLinks;
		
		/// <summary>
		/// Link button for the 
		/// </summary>
		protected Localization.LocalizedLinkButton lnkOrganisationDetails;
		
		/// <summary>
		/// Link button for the organisation import users link.
		/// </summary>
		protected Localization.LocalizedLinkButton lnkOrgImportUsers;
		
		/// <summary>
		/// Link button for the unit search link.
		/// </summary>
		protected Localization.LocalizedLinkButton lnkUnitSearch;
		
		/// <summary>
		/// Link button for the add unit link.
		/// </summary>
		protected Localization.LocalizedLinkButton lnkAddUnit;
		
		/// <summary>
		/// Link button for the unit management link.
		/// </summary>
		protected Localization.LocalizedLinkButton lnkUnitMangement;
		
		/// <summary>
		/// Link button for the personal details link.
		/// </summary>
		protected Localization.LocalizedLinkButton lnkPersonDetails;
		
		/// <summary>
		/// Link button for the user search link.
		/// </summary>
		protected Localization.LocalizedLinkButton lnkUserSearch;
		
		/// <summary>
		/// Link button for the add user link.
		/// </summary>
		protected Localization.LocalizedLinkButton lnkAddUser;
		
		/// <summary>
		/// Link button for the user search link.
		/// </summary>
		protected Localization.LocalizedLinkButton lnkMoveUsersToUnit;

		/// <summary>
		/// Link button for the add course link.
		/// </summary>
		protected Localization.LocalizedLinkButton lnkAddCourse;
		
		/// <summary>
		/// Link button for the edit course link.
		/// </summary>
		protected Localization.LocalizedLinkButton lnkEditCourse;
		
		/// <summary>
		/// Link button for the add organisation link.
		/// </summary>
		protected Localization.LocalizedLinkButton lnkAddOrganisation;

        /// <summary>
        /// Link button for the add time zone link.
        /// </summary>
        protected Localization.LocalizedLinkButton lnkTimeZone;

        /// <summary>
        /// Link button to add new info path content
        /// </summary>
        protected Localization.LocalizedLinkButton lnkPublishContent;
		
		/// <summary>
		/// HTML table row for the content administration menu options.
		/// </summary>
        protected System.Web.UI.HtmlControls.HtmlGenericControl trContent;






				
		#endregion
		
		#region Constants
		/// <summary>
		/// This constant holds the path to the application administration folder.
		/// </summary>
		private const string cm_strApplicationAdminPath = "/Administration/Application/";
		
		/// <summary>
		/// This constant holds the path to the organisation administration folder.
		/// </summary>
		private const string cm_strOrganisationAdminPath = "/Administration/Organisation/";

		/// <summary>
		/// This constant holds the path to the Policy administration folder.
		/// </summary>
		private const string cm_strPolicyAdminPath = "/Administration/Policy/";
		
		/// <summary>
		/// This constant holds the path to the CPD administration folder.
		/// </summary>
		private const string cm_strCPDAdminPath = "/Administration/CPD/";

		/// <summary>
		/// This constant holds the path to the unit administration folder.
		/// </summary>
		private const string cm_strUnitAdminPath = "/Administration/Unit/";
		
		/// <summary>
		/// This constant holds the path to the user administration folder.
		/// </summary>
		private const string cm_strUserAdminPath = "/Administration/Users/";

        /// <summary>
        /// Link to Application administrators page
        /// </summary>
        protected Localization.LocalizedLinkButton lnkApplicationAdministrators;
        
        /// <summary>
        /// Link to organisational configuration page.
        /// </summary>
        protected Localization.LocalizedLinkButton lnkOrganisationConfiguration;

        /// <summary>
        /// This constant holds the path to the course content administration folder.
        /// </summary>
        private const string cm_strCourseAdminPath = "/ContentAdministration/Courses/";
		private const string cm_strLicensingAdminPath = "/ContentAdministration/Licensing/";
		private const string cm_strContentAdminPath = "/ContentAdministration/InfoPath/";
		private const string cm_strLanguageAdminPath = "/Administration/Language/";
		protected Localization.LocalizedLinkButton lnPolicyBuilder;
        
        /// <summary>
        /// This constant holds the path to the course content administration folder.
        /// </summary>

        #endregion
		
		#region Private Event Handlers
		/// <summary>
		/// Event Handler for the Page Load event.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
			HttpContext.Current.Items["Section"] = "Admin";
            //Madhuri Start
            string csurl, csurl1 = null;
            string csname = "myscript";
            string urlhost = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority);
            csurl = urlhost + "/General/Js/navigationmenu-jquery-latest.min.js";
            csurl1 = urlhost + "/General/Js/navigationmenuscript.js";
            if (!Page.ClientScript.IsClientScriptIncludeRegistered(csurl))
            {
                Page.ClientScript.RegisterClientScriptInclude(this.GetType(), "myscript", ResolveClientUrl(csurl));

                Page.ClientScript.RegisterClientScriptInclude(this.GetType(), "myscript1", ResolveClientUrl(csurl1));
            }
            //Madhuri End
			if(!Page.IsPostBack)
			{
				// Set the Menu Visiblity
				this.SetMenuVisibilty();
                HighlightMenu();
			}
		} // Page_Load


        public void HighlightMenu()
        {
            string str = Request.RawUrl;
            if (Request.RawUrl.Contains("ApplicationAdministrators"))
            {
                trUser.Attributes.Add("class", "has-sub active");
                uiUser.Style.Add("display", "block");
                divApplicationAdministrators.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("UserSearch"))
            {
                trUser.Attributes.Add("class", "has-sub active");
                uiUser.Style.Add("display", "block");
                divUserSearch.Attributes.Add("class", "liactive");

            }
            else if (Request.RawUrl.Contains("UserDetails") && Request.RawUrl.Contains("UserID"))
            {
                trUser.Attributes.Add("class", "has-sub active");
                uiUser.Style.Add("display", "block");
                divAddUser.Attributes.Add("class", "liactive");
            }

            else if (Request.RawUrl.Contains("UserDetails"))
            {
                trUser.Attributes.Add("class", "has-sub active");
                uiUser.Style.Add("display", "block");
                divPersonDetails.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("ArchiveUsers"))
            {
                trUser.Attributes.Add("class", "has-sub active");
                uiUser.Style.Add("display", "block");
                divArchiveUsers.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("EmailUsers"))
            {
                trUser.Attributes.Add("class", "has-sub active");
                uiUser.Style.Add("display", "block");
                divEmailUsers.Attributes.Add("class", "liactive");
            }

            else if (Request.RawUrl.Contains("UnitSearch"))
            {
                trUnit.Attributes.Add("class", "has-sub active");
                uiUnit.Style.Add("display", "block");
                divUnitSearch.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("AddUnit"))
            {
                trUnit.Attributes.Add("class", "has-sub active");
                uiUnit.Style.Add("display", "block");
                divAddUnit.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("UnitDetails"))
            {
                trUnit.Attributes.Add("class", "has-sub active");
                uiUnit.Style.Add("display", "block");
                divAddUnit.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("UnitModuleAccess"))
            {
                trUnit.Attributes.Add("class", "has-sub active");
                uiUnit.Style.Add("display", "block");
                divAddUnit.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("ComplianceRules"))
            {
                trUnit.Attributes.Add("class", "has-sub active");
                uiUnit.Style.Add("display", "block");
                divAddUnit.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("UnitAdministrators"))
            {
                trUnit.Attributes.Add("class", "has-sub active");
                uiUnit.Style.Add("display", "block");
                divAddUnit.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("UnitManagement"))
            {
                trUnit.Attributes.Add("class", "has-sub active");
                uiUnit.Style.Add("display", "block");
                divUnitManagement.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("OrganisationDetails.aspx?action=add") || Request.RawUrl.Contains("AddOrganisationAdministrator"))
            {
                trOrganisation.Attributes.Add("class", "has-sub active");
                uiOrganisation.Style.Add("display", "block");
                divAddOrganisation.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("OrganisationDetails"))
            {
                trOrganisation.Attributes.Add("class", "has-sub active");
                uiOrganisation.Style.Add("display", "block");
                divOrganisationDetails.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("OrganisationConfiguration"))
            {
                trOrganisation.Attributes.Add("class", "has-sub active");
                uiOrganisation.Style.Add("display", "block");
                divOrganisationConfiguration.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("OrganisationAdministrators"))
            {
                trOrganisation.Attributes.Add("class", "has-sub active");
                uiOrganisation.Style.Add("display", "block");
                divOrgAdministrators.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("OrganisationAdministrators"))
            {
                trOrganisation.Attributes.Add("class", "has-sub active");
                uiOrganisation.Style.Add("display", "block");
                divOrgAdministrators.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("OrganisationMail") || Request.RawUrl.Contains("OrgMailSetup"))
            {
                trOrganisation.Attributes.Add("class", "has-sub active");
                uiOrganisation.Style.Add("display", "block");
                divOrgMailSetup.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("ModifyLinks"))
            {
                trOrganisation.Attributes.Add("class", "has-sub active");
                uiOrganisation.Style.Add("display", "block");
                divModifyLinks.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("ImportUsers"))
            {
                trOrganisation.Attributes.Add("class", "has-sub active");
                uiOrganisation.Style.Add("display", "block");
                divOrgImportUsers.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("BulkAssignUsers"))
            {
                trOrganisation.Attributes.Add("class", "has-sub active");
                uiOrganisation.Style.Add("display", "block");
                divBulkAssignUsers.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("MoveUsersToUnit"))
            {
                trOrganisation.Attributes.Add("class", "has-sub active");
                uiOrganisation.Style.Add("display", "block");
                divMoveUsersToUnit.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("CourseAccess"))
            {
                trOrganisation.Attributes.Add("class", "has-sub active");
                uiOrganisation.Style.Add("display", "block");
                divCourseAccess.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("Licensing/Default.aspx"))
            {
                trOrganisation.Attributes.Add("class", "has-sub active");
                uiOrganisation.Style.Add("display", "block");
                divLicensing.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("Licensing/Detail.aspx"))
            {
                trOrganisation.Attributes.Add("class", "has-sub active");
                uiOrganisation.Style.Add("display", "block");
                divLicensing.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("cpddefault"))
            {
                trOrganisation.Attributes.Add("class", "has-sub active");
                uiOrganisation.Style.Add("display", "block");
                divCPDProfile.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("cpdevent"))
            {
                trOrganisation.Attributes.Add("class", "has-sub active");
                uiOrganisation.Style.Add("display", "block");
                divCPDEvent.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("cpdeventdetail"))
            {
                trOrganisation.Attributes.Add("class", "has-sub active");
                uiOrganisation.Style.Add("display", "block");
                divCPDEvent.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("cpddetail"))
            {
                trOrganisation.Attributes.Add("class", "has-sub active");
                uiOrganisation.Style.Add("display", "block");
                divCPDProfile.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("policydefault") || Request.RawUrl.Contains("policydetails"))
            {
                trOrganisation.Attributes.Add("class", "has-sub active");
                uiOrganisation.Style.Add("display", "block");
                divPolicyBuilder.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("ShowWelcomeScreen"))
            {
                trOrganisation.Attributes.Add("class", "has-sub active");
                uiOrganisation.Style.Add("display", "block");
                divOrganisationWelcomeScreen.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("PublishInfoPathContent"))
            {
                trContent.Attributes.Add("class", "has-sub active");
                uiContent.Style.Add("display", "block");
                divPublishContent.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("AddCourse"))
            {
                trContent.Attributes.Add("class", "has-sub active");
                uiContent.Style.Add("display", "block");
                divAddCourse.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("CourseDetails"))
            {
                trContent.Attributes.Add("class", "has-sub active");
                uiContent.Style.Add("display", "block");
                divEditCourse.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("CourseDetails"))
            {
                trContent.Attributes.Add("class", "has-sub active");
                uiContent.Style.Add("display", "block");
                divEditCourse.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("CourseDetails"))
            {
                trContent.Attributes.Add("class", "has-sub active");
                uiContent.Style.Add("display", "block");
                divEditCourse.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("OrganisationApplicationAccess"))
            {
                trApplication.Attributes.Add("class", "has-sub active");
                uiApplication.Style.Add("display", "block");
                divOrgApplicationAccess.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("ApplicationAuditing"))
            {
                trApplication.Attributes.Add("class", "has-sub active");
                uiApplication.Style.Add("display", "block");
                divAppAuditing.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("ApplicationDependencies"))
            {
                trApplication.Attributes.Add("class", "has-sub active");
                uiApplication.Style.Add("display", "block");
                divAppDependencies.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("ApplicationConfiguration"))
            {
                trApplication.Attributes.Add("class", "has-sub active");
                uiApplication.Style.Add("display", "block");
                divAppConfig.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("DomainNameManagement"))
            {
                trApplication.Attributes.Add("class", "has-sub active");
                uiApplication.Style.Add("display", "block");
                divDomainName.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("EmailDefault"))
            {
                trApplication.Attributes.Add("class", "has-sub active");
                uiApplication.Style.Add("display", "block");
                divApplicationEmailDefault.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("Language/default.aspx"))
            {
                trApplication.Attributes.Add("class", "has-sub active");
                uiApplication.Style.Add("display", "block");
                divLanguageTranslation.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("Language/Interface.aspx"))
            {
                trApplication.Attributes.Add("class", "has-sub active");
                uiApplication.Style.Add("display", "block");
                divLanguageTranslation.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("Language/Resource.aspx"))
            {
                trApplication.Attributes.Add("class", "has-sub active");
                uiApplication.Style.Add("display", "block");
                divLanguageTranslation.Attributes.Add("class", "liactive");
            }


            else if (Request.RawUrl.Contains("ViewErrorLog"))
            {
                trApplication.Attributes.Add("class", "has-sub active");
                uiApplication.Style.Add("display", "block");
                divViewErrorLog.Attributes.Add("class", "liactive");
            }


            else if (Request.RawUrl.Contains("MailThroughput"))
            {
                trApplication.Attributes.Add("class", "has-sub active");
                uiApplication.Style.Add("display", "block");
                divMailThroughput.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("TimeZone"))
            {
                trApplication.Attributes.Add("class", "has-sub active");
                uiApplication.Style.Add("display", "block");
                divTimeZone.Attributes.Add("class", "liactive");
            }
        }


		/// <summary>
		/// Event handler for the application configuration link.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void lnkAppConfig_Click(object sender, EventArgs e)
		{
			//1. Redirect to the requested page.
			Response.Redirect(cm_strApplicationAdminPath + "ApplicationConfiguration.aspx");
		} // lnkAppConfig_Click
		
		/// <summary>
		/// Event handler for the application auditing link.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>	value	"Ajoutez L'Utilisateur"	string

		protected void lnkAppAuditing_Click(object sender, EventArgs e)
		{
			//1. Redirect to the requested page.
			Response.Redirect(cm_strApplicationAdminPath + "ApplicationAuditing.aspx");
		} // lnkAppAuditing_Click

		protected void lnkOrgApplicationAccess_Click(object sender, EventArgs e)
		{
			//1. Redirect to the requested page.
			Response.Redirect(cm_strApplicationAdminPath + "OrganisationApplicationAccess.aspx");
		} // lnkAppAuditing_Click
		
		/// <summary>
		/// Event handler for the application dependencies link.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void lnkAppDependencies_Click(object sender, EventArgs e)
		{
			//1. Redirect to the requested page.
			Response.Redirect(cm_strApplicationAdminPath + "ApplicationDependencies.aspx");
		} // lnkAppDependencies_Click
		
		/// <summary>
		/// Event handler for the view error log link.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void lnkViewErrorLog_Click(object sender, EventArgs e)
		{
			//1. Redirect to the requested page.
			Response.Redirect(cm_strApplicationAdminPath + "ViewErrorLog.aspx");
		} // lnkViewErrorLog_Click

        /// <summary>
        /// Event handler for the periodic report.
        /// </summary>
        /// <param name="sender"> The source of the event.</param>
        /// <param name="e"> Any arguments that the event fires.</param>
        protected void lnkPeriodicReport_Click(object sender, EventArgs e)
        {
            //1. Redirect to the requested page.
            Response.Redirect("/Reporting/PeriodicReport.aspx");
        } // lnkPeriodicReport_Click

        /// <summary>
        /// Event handler for Mail Throughput.
        /// </summary>
        /// <param name="sender"> The source of the event.</param>
        /// <param name="e"> Any arguments that the event fires.</param>
        protected void lnkMailThroughput_Click(object sender, EventArgs e)
        {
            //1. Redirect to the requested page.
            Response.Redirect(cm_strApplicationAdminPath + "MailThroughput.aspx");
        } // lnkMailThroughput_Click

		/// <summary>
		/// Event handler for the organisation administrators link link.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void lnkOrgAdministrators_Click(object sender, EventArgs e)
		{
			//1. Redirect to the requested page.
			Response.Redirect(cm_strOrganisationAdminPath + "OrganisationAdministrators.aspx");
		} // lnkOrgAdministrators_Click

        /// <summary>
        /// Event handler for the organisation mail setup link.
        /// </summary>
        /// <param name="sender"> The source of the event.</param>
        /// <param name="e"> Any arguments that the event fires.</param>
        protected void lnkOrgMailSetup_Click(object sender, EventArgs e)
        {
            //1. Redirect to the requested page.
            Response.Redirect(cm_strOrganisationAdminPath + "OrganisationMail.aspx");
        } // lnkOrgAdministrators_Click
		

		/// <summary>
		/// Event handler for the bul assign users link.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void lnkBulkAssignUsers_Click(object sender, EventArgs e)
		{
			//1. Redirect to the requested page.
			Response.Redirect(cm_strOrganisationAdminPath + "BulkAssignUsers.aspx");
		} // lnkBulkAssignUsers_Click
		
		/// <summary>
		/// Event handler for the organisation course access link.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void lnkCourseAccess_Click(object sender, EventArgs e)
		{
			//1. Redirect to the requested page.
			Response.Redirect(cm_strOrganisationAdminPath + "CourseAccess.aspx");
		} // lnkCourseAccess_Click
		
		/// <summary>
		/// Event handler for the organisation import users link.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void lnkOrgImportUsers_Click(object sender, EventArgs e)
		{
			//1. Redirect to the requested page.
			Response.Redirect(cm_strOrganisationAdminPath + "ImportUsers.aspx");
		} // lnkOrgImportUsers_Click
		
		/// <summary>
		/// Event handler for the modify organisation links link.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void lnkModifyLinks_Click(object sender, EventArgs e)
		{
			//1. Redirect to the requested page.
			Response.Redirect(cm_strOrganisationAdminPath + "ModifyLinks.aspx");
		} // lnkModifyLinks_Click
		
		/// <summary>
		/// Event handler for the organisation details link.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void lnkOrganisationDetails_Click(object sender, EventArgs e)
		{
			//1. Redirect to the requested page.
			Response.Redirect(cm_strOrganisationAdminPath + "OrganisationDetails.aspx");
		} // lnkOrganisationDetails_Click
		
        /// <summary>
        /// Event handler for the organisation config link.
        /// </summary>
        /// <param name="sender"> The source of the event.</param>
        /// <param name="e"> Any arguments that the event fires.</param>
        protected void lnkOrganisationConfiguration_Click(object sender, EventArgs e)
        {
            //1. Redirect to the requested page.
            Response.Redirect(cm_strOrganisationAdminPath + "OrganisationConfiguration.aspx");
        }//lnkOrganisationConfiguration_Click

		/// <summary>
        /// Event handler for the organisation welcome screen link
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void lnkOrganisationWelcomeScreen_Click(object sender, EventArgs e)
        {
            Response.Redirect("/Default.aspx?ShowWelcomeScreen=true");
        }

		/// <summary>
		/// Event handler for the add organisation link.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void lnkAddOrganisation_Click(object sender, EventArgs e)
		{
			//1. Redirect to the requested page.
			Response.Redirect(cm_strOrganisationAdminPath + "OrganisationDetails.aspx?action=add");
		} // lnkAddOrganisation_Click

        /// <summary>
        /// Event handler for the time zone link.
        /// </summary>
        /// <param name="sender"> The source of the event.</param>
        /// <param name="e"> Any arguments that the event fires.</param>
        protected void lnkTimeZone_Click(object sender, EventArgs e)
        {
            //1. Redirect to the requested page.
            Response.Redirect(cm_strOrganisationAdminPath + "TimeZone.aspx");
        } // lnkTimeZone_Click

        /// <summary>
		/// Event handler for the unit search link.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void lnkUnitSearch_Click(object sender, EventArgs e)
		{
			//1. Redirect to the requested page.
			Response.Redirect(cm_strUnitAdminPath + "UnitSearch.aspx");
		} // lnkUnitSearch_Click
		
		/// <summary>
		/// Event handler for the add unit link.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void lnkAddUnit_Click(object sender, EventArgs e)
		{
			//1. Redirect to the requested page.
			Response.Redirect(cm_strUnitAdminPath + "AddUnit.aspx");
		} // lnkAddUnit_Click
		
		/// <summary>
		/// Event handler for the unit management link.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void lnkUnitMangement_Click(object sender, EventArgs e)
		{
			//1. Redirect to the requested page.
			Response.Redirect(cm_strUnitAdminPath + "UnitManagement.aspx");
		} // lnkUnitMangement_Click
		
		/// <summary>
		/// Event handler for the user search link.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void lnkUserSearch_Click(object sender, EventArgs e)
		{
			//1. Redirect to the requested page.
			Response.Redirect(cm_strUserAdminPath + "UserSearch.aspx");
		} // lnkUserSearch_Click
		
        
		/// <summary>
		/// Event handler for the user details link.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void lnkAddUser_Click(object sender, EventArgs e)
		{
			//1. Redirect to the requested page.
			Response.Redirect(cm_strUserAdminPath + "UserDetails.aspx?UserID=0");
		} // lnkAddUser_Click
		
		/// <summary>
		/// Event handler for the user details link.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void lnkMoveUsersToUnit_Click(object sender, EventArgs e)
		{
			//1. Redirect to the requested page.
			Response.Redirect(cm_strOrganisationAdminPath + "MoveUsersToUnit.aspx");
		} // lnkAddUser_Click

        /// <summary>
        /// Event handler for the Application Administrators link.
        /// </summary>
        /// <param name="sender"> The source of the event.</param>
        /// <param name="e"> Any arguments that the event fires.</param>
        protected void lnkApplicationAdministrators_Click(object sender, System.EventArgs e)
        {
            //1. Redirect to the requested page.
            Response.Redirect(cm_strUserAdminPath + "ApplicationAdministrators.aspx");
        } // lnkApplicationAdministrators_Click
        
        /// <summary>
		/// Event handler for the user details link.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void lnkPersonDetails_Click(object sender, EventArgs e)
		{
			//1. Redirect to the requested page.
			Response.Redirect(cm_strUserAdminPath + "UserDetails.aspx");
		} // lnkPersonDetails_Click
		
        /// <summary>
        /// Event handler for publishing new content
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void lnkPublishContent_Click(object sender, EventArgs e)
        {
            Response.Redirect(cm_strContentAdminPath + "PublishInfoPathContent.aspx");
        }
        /// <summary>
        /// Event handler for creating a new course.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
        protected void lnkAddCourse_Click(object sender, System.EventArgs e)
        {
            //1. Redirect to the requested page.
            Response.Redirect(cm_strCourseAdminPath + "AddCourse.aspx");
        } // lnkAddCourse_Click

        /// <summary>
        /// Event handler for editing an existing course.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
        protected void lnkEditCourse_Click(object sender, System.EventArgs e)
        {
            //1. Redirect to the requested page.
            Response.Redirect(cm_strCourseAdminPath + "CourseDetails.aspx");
		} // lnkEditCourse_Click
		
		protected void lnkDomainName_Click(object sender, System.EventArgs e)
		{
			Response.Redirect(cm_strApplicationAdminPath + "DomainNameManagement.aspx");
		}

		protected void lnkPolicyBuilder_Click(object sender, System.EventArgs e)
		{
			Response.Redirect(cm_strPolicyAdminPath + "policydefault.aspx");
		}

		protected void lnkLicensing_Click(object sender, System.EventArgs e)
		{
			Response.Redirect(cm_strLicensingAdminPath + "Default.aspx");
		}

		protected void lnkLanguageTranslation_Click(object sender, System.EventArgs e)
		{
			Response.Redirect(cm_strLanguageAdminPath + "default.aspx");
		}

		protected void lnkCPDProfile_Click(object sender, System.EventArgs e)
		{
			Response.Redirect(cm_strCPDAdminPath + "cpddefault.aspx");
		}

		//Madhuri CPD Event Start
		protected void lnkCPDEvent_Click(object sender, System.EventArgs e)
        {
            Response.Redirect(cm_strCPDAdminPath + "cpdevent.aspx");
        }
		//Madhuri CPD Event End
		protected void lnkArchiveUsers_Click(object sender, System.EventArgs e)
		{
			Response.Redirect(cm_strUserAdminPath + "ArchiveUsers.aspx");
		}

		protected void lnkEmailUsers_Click(object sender, System.EventArgs e)
		{
			Response.Redirect(cm_strUserAdminPath + "EmailUsers.aspx");
		}

        protected void lnkAppEmailDefault_Click(object sender, System.EventArgs e)
        {
            Response.Redirect(cm_strApplicationAdminPath + "EmailDefault.aspx");
        }

		#endregion
		
		#region Private Methods
		/// <summary>
		/// Sets the visbility level of the Menu.
		/// </summary>
		private void SetMenuVisibilty()
		{
			Organisation objOrganisation = new Organisation();
			switch(UserContext.UserData.UserType)
			{
				case UserType.OrgAdmin:
				{
					this.divViewErrorLog.Visible = false;
					this.divAppConfig.Visible = false;
					this.divDomainName.Visible = false;
					this.divAddOrganisation.Visible = false;
					this.divCourseAccess.Visible = false;
                    this.trContent.Visible = false;
                    this.divApplicationAdministrators.Visible = false;
					this.divLicensing.Visible = false;
					this.divLanguageTranslation.Visible = false;
					this.divOrgApplicationAccess.Visible = false;			
					this.divCPDProfile.Visible = objOrganisation.GetOrganisationCPDAccess(UserContext.UserData.OrgID);
					//Madhuri CPD Event Start
					 this.divCPDEvent.Visible = objOrganisation.GetOrganisationCPDEventAccess(UserContext.UserData.OrgID);
					 //Madhuri CPD End
					this.divPolicyBuilder.Visible = objOrganisation.GetOrganisationPolicyAccess(UserContext.UserData.OrgID);
					this.divMoveUsersToUnit.Visible = true;
					this.trApplication.Visible = false;
                    this.divOrganisationWelcomeScreen.Visible = false;
					break;
				}
				case UserType.UnitAdmin:
				{
					this.trApplication.Visible = false;
					this.trOrganisation.Visible = false;
                    this.trContent.Visible = false;
                    this.divApplicationAdministrators.Visible = false;
                    this.divOrganisationConfiguration.Visible=false;
					this.divLicensing.Visible = false;
					this.divLanguageTranslation.Visible = false;
					this.divOrgApplicationAccess.Visible = false;
					this.divCPDProfile.Visible = false;
					//Madhuri CPD Event Start
					this.divCPDEvent.Visible = false;
					//Madhuri CPD Event End
					this.divPolicyBuilder.Visible = false;
					this.divMoveUsersToUnit.Visible = false;
                    this.divOrganisationWelcomeScreen.Visible = false;
                    break;
				}
				case UserType.User:
				{
					this.tblMenu.Visible = false;
                    this.trContent.Visible = false;
                    this.divApplicationAdministrators.Visible = false;
					this.divLicensing.Visible = false;
					this.divLanguageTranslation.Visible = false;
					this.divOrgApplicationAccess.Visible = false;
					this.divCPDProfile.Visible = false;
					//Madhuri CPD Event Start
					this.divCPDEvent.Visible = false;
					//Madhuri CPD Event End
					this.divPolicyBuilder.Visible = false;
					this.divMoveUsersToUnit.Visible = false;
                    this.divOrganisationWelcomeScreen.Visible = false;
                    break;
				}
				default: // User must be a SaltAdmin
				{
					// Everything should be visible except for CPD and Policy which are only visible
					// if the organisation has been granted access to it.
					this.divCPDProfile.Visible = objOrganisation.GetOrganisationCPDAccess(UserContext.UserData.OrgID);
                    //Madhuri CPD Event Start
                    this.divCPDEvent.Visible = objOrganisation.GetOrganisationCPDEventAccess(UserContext.UserData.OrgID);
                    //Madhuri CPD Event End
					this.divPolicyBuilder.Visible = objOrganisation.GetOrganisationPolicyAccess(UserContext.UserData.OrgID);
					break;
				}
			}
		} // SetMenuVisibilty
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
		} // OnInit
		
		/// <summary>
		///		Required method for Designer support - do not modify
		///		the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{

		}        
        #endregion

	
		

    }
}