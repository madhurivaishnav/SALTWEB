namespace Bdw.Application.Salt.Web.General.UserControls.Navigation
{
	using System;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;
	using Bdw.Application.Salt.Web.Utilities;
	using Bdw.Application.Salt.Data;
	using Bdw.Application.Salt.BusinessServices;

	/// <summary>
	///		Summary description for ReportsMenu.
	/// </summary>
	public partial class ReportsMenu : System.Web.UI.UserControl
	{
		#region Protected Variables
		
		protected System.Web.UI.HtmlControls.HtmlTable tblMenu;
		protected System.Web.UI.WebControls.LinkButton lnkCompletedUsersReport;
		protected System.Web.UI.WebControls.LinkButton lnkTrendReport;

		#endregion
		
		#region Private Static Readonly Variables
		/// <summary>
		/// Path to admin reports
		/// </summary>
		private static readonly string m_strAdminReportPath = "/Reporting/Admin/";
		/// <summary>
		/// path to completed users report
		/// </summary>
		private static readonly string m_strCompletedUsersReportPath = "/Reporting/CompletedUsers/";
		/// <summary>
		/// path to email report
		/// </summary>
		private static readonly string m_strEmailReportPath = "/Reporting/Email/";
		/// <summary>
		/// path to individual report
		/// </summary>
		private static readonly string m_strIndividualReportPath = "/Reporting/Individual/";
		/// <summary>
		/// Path to trend report
		/// </summary>
		private static readonly string m_strTrendReportPath = "/Reporting/Trend/";
		/// <summary>
		/// Path to CPD report
		/// </summary>
		private static readonly string m_strCPDReportPath = "/Reporting/CPD/";



		/// <summary>
		/// Path to advanced reports
		/// </summary>
		private static readonly string m_strAdvancedReportPath = "/Reporting/Advanced/";

		#endregion

		#region Private Methods
		protected void Page_Load(object sender, System.EventArgs e)
		{
			HttpContext.Current.Items["Section"] = "Reporting";

			if(!Page.IsPostBack)
			{
				//Set the Menu Visiblity
				this.SetMenuVisibilty();

                //Madhuri Start Salt redesign
                //to avoid after loading ssrs-report menu is not working
                //string csurl, csurl1 = null;
                //string csname = "myscript";
                //string urlhost = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority);
                //csurl = urlhost + "/General/Js/navigationmenu-jquery-latest.min.js";
                //csurl1 = urlhost + "/General/Js/navigationmenuscript.js";
                //if (!Page.ClientScript.IsClientScriptIncludeRegistered(csurl))
                //{
                //    Page.ClientScript.RegisterClientScriptInclude(this.GetType(), "myscript", ResolveClientUrl(csurl));
                //    Page.ClientScript.RegisterClientScriptInclude(this.GetType(), "myscript1", ResolveClientUrl(csurl1));
                //}
                HighlightMenu();
                //Madhuri End Salt redesign
			}
		}
        public void HighlightMenu()
        {
            string str = Request.RawUrl;

            if (Request.RawUrl.Contains("PeriodicReport.aspx"))
            {

                if (Request.QueryString["ReportID"] == "30")
                {
                    trCPDReports.Attributes.Add("class", "has-sub active");
                    ulCPDReports.Style.Add("display", "block");
                    divCPDReport.Attributes.Add("class", "liactive");
                }
                else if (Request.QueryString["ReportID"] == "3")
                {
                    trActiivtyReport.Attributes.Add("class", "has-sub active");
                    uiActiivtyReport.Style.Add("display", "block");
                    divAdminCurrentReport.Attributes.Add("class", "liactive");
                }
                else if (Request.QueryString["ReportID"] == "36")
                {
                    trPolicyReports.Attributes.Add("class", "has-sub active");
                    ulPolicyReports.Style.Add("display", "block");
                    divPolicyBuilderReport.Attributes.Add("class", "liactive");
                }
                else if (Request.QueryString["ReportID"] == "19")
                {
                    trActiivtyReport.Attributes.Add("class", "has-sub active");
                    uiActiivtyReport.Style.Add("display", "block");
                    divAdvancedCourseStatusReport.Attributes.Add("class", "liactive");
                }
                else if (Request.QueryString["ReportID"] == "17")
                {
                    trActiivtyReport.Attributes.Add("class", "has-sub active");
                    uiActiivtyReport.Style.Add("display", "block");
                    divAdvancedCompletedUsersReport.Attributes.Add("class", "liactive");
                }
                else if (Request.QueryString["ReportID"] == "14")
                {
                    trActiivtyReport.Attributes.Add("class", "has-sub active");
                    uiActiivtyReport.Style.Add("display", "block");
                    divAdvancedAtRiskReport.Attributes.Add("class", "liactive");
                }
                else if (Request.QueryString["ReportID"] == "29")
                {
                    trActiivtyReport.Attributes.Add("class", "has-sub active");
                    uiActiivtyReport.Style.Add("display", "block");
                    divAdvancedWarningReport.Attributes.Add("class", "liactive");
                }
                else if (Request.QueryString["ReportID"] == "21")
                {
                    trActiivtyReport.Attributes.Add("class", "has-sub active");
                    uiActiivtyReport.Style.Add("display", "block");
                    divAdvancedProgressReport.Attributes.Add("class", "liactive");
                }
                else if (Request.QueryString["ReportID"] == "22")
                {
                    trOrganisationReportGroup.Attributes.Add("class", "has-sub active");
                    uiOrganisationReportGroup.Style.Add("display", "block");
                    divAdvancedSummaryReport.Attributes.Add("class", "liactive");
                }
                else if (Request.QueryString["ReportID"] == "25")
                {
                    trOrganisationReportGroup.Attributes.Add("class", "has-sub active");
                    uiOrganisationReportGroup.Style.Add("display", "block");
                    divAdvancedTrendReport.Attributes.Add("class", "liactive");
                }

                else if (Request.QueryString["ReportID"] == "2")
                {
                    trAdmininistrationReports.Attributes.Add("class", "has-sub active");
                    ulAdmininistrationReports.Style.Add("display", "block");
                    divActiveInactiveReport.Attributes.Add("class", "liactive");
                }

                else if (Request.QueryString["ReportID"] == "20")
                {
                    trAdmininistrationReports.Attributes.Add("class", "has-sub active");
                    ulAdmininistrationReports.Style.Add("display", "block");
                    divLicensingReport.Attributes.Add("class", "liactive");
                }


            }


            else if (Request.RawUrl.Contains("AdministrationReport.aspx?AdminReportType=Historic"))
            {
                trActiivtyReport.Attributes.Add("class", "has-sub active");
                uiActiivtyReport.Style.Add("display", "block");
                divAdminHistoricalPointReport.Attributes.Add("class", "liactive");
            }

            else if (Request.RawUrl.Contains("IndividualReport"))
            {
                trActiivtyReport.Attributes.Add("class", "has-sub active");
                uiActiivtyReport.Style.Add("display", "block");
                divPersonalReport.Attributes.Add("class", "liactive");
            }


            else if (Request.RawUrl.Contains("BuildEmailReport.aspx"))
            {
                trEmailReport.Attributes.Add("class", "has-sub active");
                ulEmailReport.Style.Add("display", "block");
                divEmailReport.Attributes.Add("class", "liactive");
            }

            else if (Request.RawUrl.Contains("CPDEmailReport.aspx"))
            {
                trEmailReport.Attributes.Add("class", "has-sub active");
                ulEmailReport.Style.Add("display", "block");
                divCPDEmailReport.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("PolicyEmailReport.aspx"))
            {
                trEmailReport.Attributes.Add("class", "has-sub active");
                ulEmailReport.Style.Add("display", "block");
                divPolicyEmailReport.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("EmailSentReport.aspx"))
            {
                trEmailReport.Attributes.Add("class", "has-sub active");
                ulEmailReport.Style.Add("display", "block");
                divAdvancedEmailSentReport.Attributes.Add("class", "liactive");
            }


            else if (Request.RawUrl.Contains("UserDetailReport.aspx"))
            {
                trAdmininistrationReports.Attributes.Add("class", "has-sub active");
                ulAdmininistrationReports.Style.Add("display", "block");
                divUserDetailsReport.Attributes.Add("class", "liactive");
            }



            else if (Request.RawUrl.Contains("UnitPathReport.aspx"))
            {
                trAdmininistrationReports.Attributes.Add("class", "has-sub active");
                ulAdmininistrationReports.Style.Add("display", "block");
                divUnitPathwayReport.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("UnitComplianceReport.aspx"))
            {
                trAdmininistrationReports.Attributes.Add("class", "has-sub active");
                ulAdmininistrationReports.Style.Add("display", "block");
                divUnitComplianceReport.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("UnitAdministratorReport.aspx"))
            {
                trAdmininistrationReports.Attributes.Add("class", "has-sub active");
                ulAdmininistrationReports.Style.Add("display", "block");
                divUnitAdminstratorReport.Attributes.Add("class", "liactive");
            }
            else if (Request.RawUrl.Contains("EbookDownloadReport.aspx"))
            {
                trAdmininistrationReports.Attributes.Add("class", "has-sub active");
                ulAdmininistrationReports.Style.Add("display", "block");
                divEbookDownloadReport.Attributes.Add("class", "liactive");
            }


            else if (Request.RawUrl.Contains("EbookDownloadReport.aspx"))
            {
                trAdmininistrationReports.Attributes.Add("class", "has-sub active");
                ulAdmininistrationReports.Style.Add("display", "block");
                divEbookDownloadReport.Attributes.Add("class", "liactive");
            }

            else if (Request.RawUrl.Contains("PeriodicReportList.aspx"))
            {
                trPeriodicReports.Attributes.Add("class", "has-sub active");
                ulPeriodicReports.Style.Add("display", "block");
                divPeriodicReport.Attributes.Add("class", "liactive");
            }
        }
		
		private void SetMenuVisibilty()
		{
			Organisation objOrganisation = new Organisation();
			this.lbCPDEmailReport.Visible = objOrganisation.GetOrganisationCPDAccess(UserContext.UserData.OrgID);
			//this.lbCPDReport.Visible = objOrganisation.GetOrganisationCPDAccess(UserContext.UserData.OrgID);
			//this.lbPolicyBuilderReport.Visible = objOrganisation.GetOrganisationPolicyAccess(UserContext.UserData.OrgID);
			this.lblPolicyEmailReport.Visible = objOrganisation.GetOrganisationPolicyAccess(UserContext.UserData.OrgID);
            trPolicyReports.Visible = objOrganisation.GetOrganisationPolicyAccess(UserContext.UserData.OrgID);
            trCPDReports.Visible = objOrganisation.GetOrganisationCPDAccess(UserContext.UserData.OrgID);
			//1. If the User is a SaltAdmin hide the Personal/Individual report link.

            // check if the organisation has access to the ebook
            //this.lnkEbookDownloadReport.Visible = objOrganisation.GetOrganisationEbookAccess(UserContext.UserData.OrgID);


			if(UserContext.UserData.UserType == UserType.SaltAdmin)
			{

				this.lnkPersonalReport.Visible = false;
				this.lnkAdvancedCourseStatusReport.Visible = true;
				this.lnkAdvancedCompletedUsersReport.Visible = true;
                this.lnkAdvancedSummaryReport.Visible = true;
                if (lnkAdvancedTrendReport != null)
                    this.lnkAdvancedTrendReport.Visible = true;
                this.lnkAdvancedEmailSentReport.Visible = true;
				this.lnkAdvancedWarningReport.Visible = true;
				this.lnkAdvancedAtRiskReport.Visible = true;
                this.lnkLicensingReport.Visible = true;
                this.lbActiveInactiveReport.Visible = true;
                this.lnkEbookDownloadReport.Visible = true;
			}
				//2. If the user is a normal 'User' then dont show this control
			else if(UserContext.UserData.UserType == UserType.User)
			{
				this.Visible = false;
			}
			else
			{
				if(UserContext.UserData.UserType == UserType.UnitAdmin)
				{
                    this.lnkLicensingReport.Visible = false;
                    this.lbActiveInactiveReport.Visible = false;
				}
				this.lnkAdvancedCourseStatusReport.Visible = UserContext.UserData.AdvancedReporting;
				this.lnkAdvancedCompletedUsersReport.Visible = UserContext.UserData.AdvancedReporting;
                this.lnkAdvancedSummaryReport.Visible = UserContext.UserData.AdvancedReporting;
                if (lnkAdvancedTrendReport != null)
                    this.lnkAdvancedTrendReport.Visible = UserContext.UserData.AdvancedReporting;
                this.lnkAdvancedEmailSentReport.Visible = UserContext.UserData.AdvancedReporting;
				this.lnkAdvancedWarningReport.Visible = UserContext.UserData.AdvancedReporting;
				this.lnkAdvancedAtRiskReport.Visible = UserContext.UserData.AdvancedReporting;
                this.lnkEbookDownloadReport.Visible = false;
			}

		}
		
		#endregion
		

		#region Private Event Handlers
        /// <summary>
        /// Event handler for the periodic report.
        /// </summary>
        /// <param name="sender"> The source of the event.</param>
        /// <param name="e"> Any arguments that the event fires.</param>
        protected void lnkPeriodicReport_Click(object sender, EventArgs e)
        {
            //0. Redirect to the requested page.
            Response.Redirect("/Reporting/PeriodicReportList.aspx");
        } // lnkPeriodicReport_Click

		protected void lbUnitPathwayReport_Click(object sender, System.EventArgs e)
		{
			//1. Redirect to the requested page.
			Response.Redirect(m_strAdvancedReportPath + "UnitPathReport.aspx");
		
		
		}
        protected void lnkLicensingReport_Click(object sender, System.EventArgs e)
        {
            //1. Redirect to the requested page.
            Response.Redirect("/Reporting/PeriodicReport.aspx?&ReportID=20");


        }


        protected void lbUserDetailsReport_Click(object sender, System.EventArgs e)
		{
		
			//1. Redirect to the requested page.
			Response.Redirect(m_strAdvancedReportPath + "UserDetailReport.aspx");
		
		}

        protected void lbActiveInactiveReport_Click(object sender, System.EventArgs e)
		{
		
			//1. Redirect to the requested page.
            Response.Redirect( "/Reporting/PeriodicReport.aspx?&ReportID=2");
		
		}


		protected void lnkPersonalReport_Click(object sender, EventArgs e)
		{
			//1. Redirect to the requested page.
			Response.Redirect(m_strIndividualReportPath + "IndividualReport.aspx");
		}

		protected void lnkAdminCurrentReport_Click(object sender, EventArgs e)
		{
			//1. Redirect to the requested page.
            Response.Redirect( "/Reporting/PeriodicReport.aspx?&ReportID=3");
		}

		protected void lnkAdminHistoricalPointReport_Click(object sender, EventArgs e)
		{
			//1. Redirect to the requested page.
			Response.Redirect(m_strAdminReportPath + "AdministrationReport.aspx?AdminReportType=Historic");
		}

		protected void lnkTrendReport_Click(object sender, EventArgs e)
		{
			//1. Redirect to the requested page.
			Response.Redirect(m_strTrendReportPath + "TrendReport.aspx");
		}

		protected void lnkEmailReport_Click(object sender, EventArgs e)
		{
			//1. Redirect to the requested page.
			Response.Redirect(m_strEmailReportPath + "BuildEmailReport.aspx");
		}

		protected void lnkCompletedUsersReport_Click(object sender, EventArgs e)
		{
			//1. Redirect to the requested page.
			Response.Redirect(m_strCompletedUsersReportPath + "CompletedUsersReport.aspx");
		}


		protected void lnkAdvancedSummaryReport_Click(object sender, System.EventArgs e)
		{
            Response.Redirect( "/Reporting/PeriodicReport.aspx?&ReportID=22");
		}

		protected void lnkAdvancedTrendReport_Click(object sender, System.EventArgs e)
		{
            Response.Redirect( "/Reporting/PeriodicReport.aspx?&ReportID=25");
		}

		protected void lnkAdvancedCompletedUsersReport_Click(object sender, System.EventArgs e)
		{
            Response.Redirect( "/Reporting/PeriodicReport.aspx?&ReportID=17");
		}
		
		protected void lnkAdvancedCourseStatusReport_Click(object sender, System.EventArgs e)
		{
            Response.Redirect( "/Reporting/PeriodicReport.aspx?&ReportID=19");
		}

		protected void lnkAdvancedProgressReport_Click(object sender, System.EventArgs e)
		{
            Response.Redirect( "/Reporting/PeriodicReport.aspx?&ReportID=21");
		}

		protected void lnkAdvancedWarningReport_Click(object sender, System.EventArgs e)
		{
            Response.Redirect( "/Reporting/PeriodicReport.aspx?&ReportID=29");
		}

		protected void lnkAdvancedAtRiskReport_Click(object sender, System.EventArgs e)
		{
            Response.Redirect( "/Reporting/PeriodicReport.aspx?&ReportID=14");
		}

		protected void lnkAdvancedEmailSentReport_Click(object sender, System.EventArgs e)
		{
			Response.Redirect(m_strAdvancedReportPath +"EmailSentReport.aspx");
		}

        protected void lbCPDReport_Click(object sender, EventArgs e)
		{
			//1. Redirect to the requested page.
            Response.Redirect( "/Reporting/PeriodicReport.aspx?&ReportID=30");
		}

        protected void lbCPDEmailReport_Click(object sender, EventArgs e)
		{
			//1. Redirect to the requested page.
			Response.Redirect(m_strCPDReportPath + "CPDEmailReport.aspx");
		}

		protected void lblUnitAdminstratorReport_Click(object sender, EventArgs e)
		{
			//1. Redirect to the requested page.
			Response.Redirect(m_strAdminReportPath + "UnitAdministratorReport.aspx");
		}

		protected void lblUnitComplianceReport_Click(object sender, EventArgs e)
		{
			//1. Redirect to the requested page.
			Response.Redirect(m_strAdminReportPath + "UnitComplianceReport.aspx");
		}

        protected void lnkEbookDownloadReport_Click(object sender, EventArgs e)
        {
            //1. Redirect to the requested page.
            Response.Redirect(m_strAdvancedReportPath + "EbookDownloadReport.aspx");
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
		///		Required method for Designer support - do not modify
		///		the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			if (lbUnitPathwayReport != null) 
				this.lbUnitPathwayReport.Click += new System.EventHandler(this.lbUnitPathwayReport_Click);

			if (lbUserDetailsReport != null) 
				this.lbUserDetailsReport.Click += new System.EventHandler(this.lbUserDetailsReport_Click);

			if (lbActiveInactiveReport != null) 
				this.lbActiveInactiveReport.Click += new System.EventHandler(this.lbActiveInactiveReport_Click);

			if (lnkAdvancedCourseStatusReport != null) 
				this.lnkAdvancedCourseStatusReport.Click += new System.EventHandler(this.lnkAdvancedCourseStatusReport_Click);
			
			if (lnkAdvancedProgressReport != null)
				this.lnkAdvancedProgressReport.Click += new System.EventHandler(this.lnkAdvancedProgressReport_Click);

			if (lnkAdvancedWarningReport != null)
				this.lnkAdvancedWarningReport.Click += new System.EventHandler(this.lnkAdvancedWarningReport_Click);

			if (lnkAdvancedAtRiskReport != null)
				this.lnkAdvancedAtRiskReport.Click += new System.EventHandler(this.lnkAdvancedAtRiskReport_Click);

			if (lbCPDReport!=null)
				this.lbCPDReport.Click += new System.EventHandler(this.lbCPDReport_Click);
			
			if (lbCPDEmailReport!=null)
				this.lbCPDEmailReport.Click += new System.EventHandler(this.lbCPDEmailReport_Click);
		}
		#endregion

		protected void lbPolicyBuilderReport_Click(object sender, System.EventArgs e)
		{
            Response.Redirect("/Reporting/PeriodicReport.aspx?&ReportID=36");
		}
		protected void lbPolicyEmailReport_Click(object sender, System.EventArgs e)
		{
			//1. Redirect to the requested page.
			Response.Redirect(m_strEmailReportPath + "PolicyEmailReport.aspx");

		}
	}
}
