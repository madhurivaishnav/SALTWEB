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
using Localization;

namespace Bdw.Application.Salt.Web.Reporting.CPD
{
	/// <summary>
	/// Summary description for CPDReport.
	/// </summary>
	public partial class CPDReport : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.DropDownList cboPage;
		protected System.Web.UI.WebControls.Label lblPageCount;
		protected System.Web.UI.WebControls.Label lblCurrentPageRecordCount;
		protected System.Web.UI.WebControls.Label lblTotalRecordCount;

		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			// Put user code to initialize the page here
			if(!Page.IsPostBack)
			{
				
				this.plhSearchCriteria.Visible = true;
				this.plhReportResults.Visible=false;
				this.rfvProfile.ErrorMessage = ResourceManager.GetString("rfvProfile");
				this.LoadProfile();
				ListItem litem = new ListItem("","");
				cboProfile.Items.Insert(0,litem);
				cboProfile.SelectedIndex = 0;

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
            this.Load += new System.EventHandler(this.Page_Load);
            this.btnReset.Click += new System.EventHandler(this.btnReset_Click);
            this.btnGenerate.Click += new System.EventHandler(this.btnGenerate_Click);
            this.rvReport.PageIndexChanged += new System.EventHandler(this.rvReport_PageIndexChanged);
            this.cboProfile.SelectedIndexChanged += new System.EventHandler(this.cboProfile_SelectedIndexChanged);

		}

		protected void cboProfile_SelectedIndexChanged(object sender, System.EventArgs e)
		{
			LoadPeriod();
		}

		private void LoadProfile()
		{
			LoadUnitTree();
			int intOrganisationID = UserContext.UserData.OrgID; // organisation ID
			BusinessServices.Profile objProfile = new BusinessServices.Profile(); //Profile Object
			DataTable dtbProfile = objProfile.GetProfilesForCurrentOrg(intOrganisationID); // List of profiles accesable to the organisation
			if (dtbProfile.Rows.Count==0)
			{
				this.plhSearchCriteria.Visible=false;
				this.lblError.Text=ResourceManager.GetString("lblError.NoProfile");//"No profiles exist within this organisation.";
				this.lblError.CssClass = "FeedbackMessage";
				this.lblError.Visible=true;
				return;
			}
			cboProfile.DataSource = dtbProfile;
			cboProfile.DataValueField = "profileid";
			cboProfile.DataTextField = "ProfileName";
			cboProfile.DataBind();
			
		}

		private void LoadUnitTree()
		{
			BusinessServices.Unit objUnit= new  BusinessServices.Unit(); // Unit Object
			DataSet dstUnits = objUnit.GetUnitsTreeByUserID(UserContext.UserData.OrgID,UserContext.UserID,'A'); // Data set to contain unit details
			if (dstUnits.Tables[0].Rows.Count==0)
			{
				this.plhSearchCriteria.Visible=false;
				this.lblError.Text=ResourceManager.GetString("lblError.NoUnit");//"No units exist within this organisation.";
				this.lblError.Visible=true;

				return;
			}
			string strUnits = UnitTreeConvert.ConvertXml(dstUnits); // comma seperated list of units
			this.trvUnitPath.LoadXml(strUnits);
		}

		private void LoadPeriod()
		{
			string strProfileid = cboProfile.SelectedValue.ToString();
			int intProfileID;

			if (strProfileid=="")// not blank selection 
			{
				cboPeriod.Items.Clear();
			}			
			else
			{
				intProfileID = Int32.Parse(strProfileid); 
				BusinessServices.Profile objProfile = new BusinessServices.Profile(); //Profile Object
				DataTable dtbPeriod = objProfile.GetPeriodsForProfile(intProfileID); // List of periods for the selected profile
				cboPeriod.DataSource = dtbPeriod;
				cboPeriod.DataValueField = "ProfilePeriodID";
				cboPeriod.DataTextField = "PeriodName";
				cboPeriod.DataBind();
			}
		}

		private void btnReset_Click(object sender, System.EventArgs e)
		{
			// Re-call the same page so that the default search criteria values are shown
			Response.Redirect(Request.RawUrl);
		}

		private void btnGenerate_Click(object sender, System.EventArgs e)
		{			
			this.plhSearchCriteria.Visible = false;
			this.plhReportResults.Visible = true;
			this.plhTitle.Visible =false;
			this.lblError.Visible=false;
			// generate the report here
			this.ShowReport();
		}

		private void indx_cng (object sender, System.EventArgs e)
		{
		}

		private void ShowReport()
		{

			//2. Add criteria to the report viewer
			Hashtable parameters = this.rvReport.Parameters;
			string[] selectUnits;
			selectUnits = trvUnitPath.GetSelectedValues();
			//Double check
			BusinessServices.Unit objUnit = new  BusinessServices.Unit();
			selectUnits = objUnit.ReturnAdministrableUnitsByUserID( UserContext.UserID, UserContext.UserData.OrgID, selectUnits);
			string  strParentUnits  = String.Join(",",selectUnits);
			parameters["unitIDs"] = strParentUnits;
			parameters["organisationID"] =  UserContext.UserData.OrgID;
			parameters["adminUserID"] =  UserContext.UserID;
			parameters["langCode"] = Request.Cookies["currentCulture"].Value;
			parameters["langInterfaceName"] = "Report.CPDReport";
			parameters["profileid"] = this.cboProfile.SelectedValue==""?"-1":this.cboProfile.SelectedValue;
			parameters["profileperiodid"] = this.cboPeriod.SelectedValue==""?"-1":this.cboPeriod.SelectedValue;
            parameters["UserFirstName"] = this.txtFirstName.Text;
            parameters["UserLastName"] = this.txtLastName.Text;
			parameters["userName"] = this.txtUserName.Text;
			parameters["shortfallusers"] = this.chbShortFallUsers.Checked?1:0;
			// report title for the CPD Report
			int intOrganisationID = UserContext.UserData.OrgID;
			BusinessServices.Profile objProfile = new BusinessServices.Profile();
			parameters["rptReportTitle"] = objProfile.getCPDReportTitle(intOrganisationID);
		}

		private void rvReport_PageIndexChanged(object sender, System.EventArgs e)
		{
			this.ShowReport();
		}

		protected override void Render(HtmlTextWriter writer)
		{
			//-- Hack. Could not work out how to use the render event in the tree view, therefore this code is run on every page that has a tree view. Hope to refactor after discovering the solution.
			System.Text.StringBuilder sb = new System.Text.StringBuilder();
			System.IO.StringWriter sw = new System.IO.StringWriter(sb);
			HtmlTextWriter newWriter = new HtmlTextWriter(sw);
                  
			base.Render(newWriter);
                  
			sb.Replace("Clear All", ResourceManager.GetString("treeClearAll"));
			sb.Replace("Collapse All", ResourceManager.GetString("treeCollapseAll"));
			sb.Replace("Expand All", ResourceManager.GetString("treeExpandAll"));
			sb.Replace("class=\"TreeView_Node\">Help</a>", "class=\"TreeView_Node\">" + ResourceManager.GetString("treeHelp") + "</a>");
			sb.Replace("Select All", ResourceManager.GetString("treeSelectAll"));

			Response.Write(sb.ToString());
			// -End Hack
			
		}
		#endregion
	}
}
