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
using System.Xml;
using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.Web.Utilities;
using Localization;

namespace Bdw.Application.Salt.Web.Reporting.Advanced
{
	/// <summary>
	/// Summary description for SummaryReport.
	/// </summary>
	public partial class SummaryReport : System.Web.UI.Page
	{
		protected Bdw.Application.Salt.Web.General.UserControls.Navigation.HelpLink ucHelp;

		#region Private Variables
		// ClassificationType Columns
		private const string CTypeColumnName = "Name";
		private const string CTypeColumnID = "ClassificationTypeID";

		// Classification Item columns
		private const string CListColumnClassificationID = "ClassificationID";
		private const string CListColumnClassificationTypeID = "ClassificationTypeID";
		private const string CListColumnValue = "Value";
		private const string CListColumnActive = "Active";
		#endregion

		#region protected controls


		/// <summary>
		/// Selection of custom classifications (groupings).
		/// </summary>
		protected System.Web.UI.WebControls.DropDownList cboCustomClassification;


	
		#endregion

		#region Event Handlers
		/// <summary>
		/// Event handler for the page load
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			ucHelp.Attributes["Desc"] = ResourceManager.GetString("ucHelp");
			// when the page loads for the first time hide the report results place holder.           
			if(!Page.IsPostBack)
			{
				
				this.plhSearchCriteria.Visible = true;
				this.plhReportResults.Visible = false;
				this.PaintCriteraPageState();
			}
		}


		protected void btnRunReport_Click(object sender, System.EventArgs e)
		{
			if(WebTool.ValidateHistoricDateControl(this.lstEffectiveDay, this.lstEffectiveMonth, this.lstEffectiveYear))
			{
				this.plhSearchCriteria.Visible = false;
				this.plhReportResults.Visible = true;
				this.plhTitle.Visible =false;
				this.lblError.Visible=false;
				this.ShowReport();
			}
			else
			{
				this.plhSearchCriteria.Visible = true;
				this.plhReportResults.Visible = false;
				this.plhTitle.Visible =true;
				this.lblError.Text=ResourceManager.GetString("lblError.Date");//"The effective date must be valid and cannot be greater than today";
				this.lblError.Visible=true; 
			}            
		}

		protected void btnReset_Click(object sender, System.EventArgs e)
		{
			// Re-call the same page so that the default search criteria values are shown
			Response.Redirect(Request.RawUrl);
		}

		protected void rvReport_PageIndexChanged(object sender, System.EventArgs e)
		{
			this.ShowReport();
		}

		#endregion


		#region private methods
		/// <summary>
		/// Paint Critera section of the page
		/// </summary>
		/// <remarks>
		/// </remarks>
		private void PaintCriteraPageState()
		{
			//1. Paint the unit selector
			BusinessServices.Unit objUnit= new  BusinessServices.Unit(); // Unit Object
			DataSet dstUnits = objUnit.GetUnitsTreeByUserID(UserContext.UserData.OrgID,UserContext.UserID,'A'); // Data set to contain unit details
			if (dstUnits.Tables[0].Rows.Count==0)
			{
				this.plhSearchCriteria.Visible=false;
				this.lblError.Text=ResourceManager.GetString("lblError.NoUnit");//No units exist within this organisation.";
				this.lblError.Visible=true;

				return;
			}
			string strUnits = UnitTreeConvert.ConvertXml(dstUnits); // comma seperated list of units
			this.trvUnitsSelector.LoadXml(strUnits);

			//2. Paint the course list details
			int intOrganisationID = UserContext.UserData.OrgID; // organisation ID
			BusinessServices.Course objCourse = new BusinessServices.Course(); //Course Object
			DataTable dtbCourses = objCourse.GetCourseListAccessableToOrg(intOrganisationID); // List of courses accesable to the organisation
			if (dtbCourses.Rows.Count==0)
			{
				this.plhSearchCriteria.Visible=false;
				this.lblError.Text=ResourceManager.GetString("lblError.NoCourse");//"No courses exist within this organisation.";
				this.lblError.CssClass = "FeedbackMessage";
				this.lblError.Visible=true;
				return;
			}
			cboCourse.DataSource = dtbCourses;
			cboCourse.DataValueField = "CourseID";
			cboCourse.DataTextField = "Name";
			cboCourse.DataBind();

			//3. setup date control
			WebTool.SetupHistoricDateControl(this.lstEffectiveDay, this.lstEffectiveMonth, this.lstEffectiveYear);

			//4. show custom classification dropdown if required
			DisplayClassifications();
		}

		private void DisplayClassifications()
		{
			try
			{
				// Get Classification Type for the dsiplayed user's organisation
				Classification objClassification = new BusinessServices.Classification();
				DataTable dtbClassificationType = objClassification.GetClassificationType(UserContext.UserData.OrgID);
                
                
				if (dtbClassificationType.Rows.Count > 0)
				{
					this.lblCustomClassification.Text = dtbClassificationType.Rows[0]["Name"].ToString();

					DataTable dtbClassificationList = objClassification.GetClassificationList((int) Convert.ToInt32(dtbClassificationType.Rows[0][CTypeColumnID].ToString()));
					// Add blank row to the datatable
					DataRow drwBlank;
	
					drwBlank = dtbClassificationList.NewRow();

					// Add a blank value
					drwBlank[CListColumnClassificationID] = 0;
					drwBlank[CListColumnClassificationTypeID] = 0;
					drwBlank[CListColumnValue] = ResourceManager.GetString("lblAny");
					drwBlank[CListColumnActive] = 1;

					dtbClassificationList.Rows.InsertAt(drwBlank, 0);
					this.cboCustomClassification.DataSource = dtbClassificationList;

					// Add blank item
					this.cboCustomClassification.DataTextField = CListColumnValue;
					this.cboCustomClassification.DataValueField = CListColumnClassificationID;
					this.cboCustomClassification.DataBind();
				}
				else
				{
					this.lblCustomClassification.Visible=false;
					this.cboCustomClassification.Visible=false;
				}
					
			}
			catch (Exception Ex)
			{
				throw new Exception (Ex.Message);
			}

		}

		private void ShowReport()
		{
			//1.Gather criteria
			// Get the selected units
			// string  strParentUnits  = String.Join(",",this.trvUnitsSelector.GetSelectedValues());
			string[] selectUnits;
			selectUnits = trvUnitsSelector.GetSelectedValues();
			//Double check
			BusinessServices.Unit objUnit = new  BusinessServices.Unit();
			selectUnits = objUnit.ReturnAdministrableUnitsByUserID( UserContext.UserID, UserContext.UserData.OrgID, selectUnits);
			string  strParentUnits  = String.Join(",",selectUnits);
			
			// Get the selected course and Complete / Incomplete status
			int intCourseID = Convert.ToInt32(cboCourse.SelectedValue);

			// Gather date parts for historic date
			DateTime dtEffective;

			if ( (this.lstEffectiveDay.SelectedValue.Length > 0) && (this.lstEffectiveMonth.SelectedValue.Length > 0) && (this.lstEffectiveYear.SelectedValue.Length > 0) )
			{
				dtEffective = new DateTime(int.Parse(this.lstEffectiveYear.SelectedValue), int.Parse(this.lstEffectiveMonth.SelectedValue), int.Parse(this.lstEffectiveDay.SelectedValue));
			}
			else
			{
				dtEffective = DateTime.Today;
			}

			if (this.optReportType.SelectedValue=="Table")
			{
				this.rvReport.ReportPath = this.rvReport.ReportPath;
			}
			else
			{
				this.rvReport.ReportPath = this.rvReport.ReportPath + this.optReportType.SelectedValue;
			}

			int intClassificationID = 0;
			if (this.cboCustomClassification.SelectedIndex > 0)
			{
				intClassificationID = int.Parse(cboCustomClassification.SelectedValue);
			}

			//2. Add criteria to the report viewer
			Hashtable parameters = this.rvReport.Parameters;
			parameters["organisationID"] =  UserContext.UserData.OrgID;
			parameters["adminUserID"] =  UserContext.UserID;

			parameters["unitIDs"] =  strParentUnits;
			parameters["courseIDs"] =  intCourseID;
			if (dtEffective!= DateTime.Today)
			{
				parameters["effectiveDate"] =  dtEffective.ToString("dd/MMM/yyyy");
			}

			parameters["langCode"] = Request.Cookies["currentCulture"].Value;
			parameters["langInterfaceName"] = "Report.Summary";
			parameters["classificationID"] = intClassificationID;

		}
		#endregion


		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);

			optReportType.Items[0].Text = ResourceManager.GetString("optReportType.1");
			optReportType.Items[1].Text = ResourceManager.GetString("optReportType.2");
			optReportType.Items[2].Text = ResourceManager.GetString("optReportType.3");
			optReportType.Items[3].Text = ResourceManager.GetString("optReportType.4");
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    

		}
		#endregion
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

	
	}
}
