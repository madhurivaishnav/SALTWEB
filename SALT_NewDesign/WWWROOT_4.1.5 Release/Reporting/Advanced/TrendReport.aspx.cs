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
using Bdw.Application.Salt.ErrorHandler;
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Data;
using Uws.Framework.WebControl;
using Localization;
namespace Bdw.Application.Salt.Web.Reporting.Advanced
{
	/// <summary>
	/// Summary description for TrendReport.
	/// </summary>
	public partial class TrendReport : System.Web.UI.Page
	{
		protected Bdw.Application.Salt.Web.General.UserControls.Navigation.HelpLink ucHelp;





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

		protected void btnGenerate_Click(object sender, System.EventArgs e)
		{
			// Check if the selected dates are valid
			if(WebTool.ValidateHistoricDateControl(this.lstEffectiveDay, this.lstEffectiveMonth, this.lstEffectiveYear) &&
				WebTool.ValidateHistoricDateControl(this.lstEffectiveToDay, this.lstEffectiveToMonth, this.lstEffectiveToYear))
			{
				if ((this.lstEffectiveYear.SelectedValue.Length > 0)&& (this.lstEffectiveToYear.SelectedValue.Length > 0))
				{//Both From and To Dates are selected
					DateTime dtFromDate = new DateTime(int.Parse(this.lstEffectiveYear.SelectedValue), int.Parse(this.lstEffectiveMonth.SelectedValue), int.Parse(this.lstEffectiveDay.SelectedValue));
					DateTime dtToDate = new DateTime(int.Parse(this.lstEffectiveToYear.SelectedValue), int.Parse(this.lstEffectiveToMonth.SelectedValue), int.Parse(this.lstEffectiveToDay.SelectedValue));
		
					if(dtFromDate < dtToDate)
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
						this.lblError.Text=ResourceManager.GetString("lblError.Date");//"The effective from date must be less than to date";
						this.lblError.Visible=true; 
					}
				}
				else
				{
					this.plhSearchCriteria.Visible = false;
					this.plhReportResults.Visible = true;
					this.plhTitle.Visible =false;
					this.lblError.Visible=false;
					this.ShowReport();
				}
			}
			else
			{
				this.plhSearchCriteria.Visible = true;
				this.plhReportResults.Visible = false;
				this.plhTitle.Visible =true;
				this.lblError.Text=ResourceManager.GetString("lblError.Date2");//"The effective date must be valid and cannot be greater than today";
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


		#region private method
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
				this.lblError.Text=ResourceManager.GetString("lblError.NoUnit");//"No units exist within this organisation.";
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

			WebTool.SetupHistoricDateControl(this.lstEffectiveDay, this.lstEffectiveMonth, this.lstEffectiveYear);
			WebTool.SetupHistoricDateControl(this.lstEffectiveToDay, this.lstEffectiveToMonth, this.lstEffectiveToYear);
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
			
			// Get the selected course
			int intCourseID = Convert.ToInt32(cboCourse.SelectedValue);
			
			// Gather date parts for trend date
			DateTime dtEffective;
			DateTime dtEffectiveTo;
			
			if ( (this.lstEffectiveDay.SelectedValue.Length > 0) && (this.lstEffectiveMonth.SelectedValue.Length > 0) && (this.lstEffectiveYear.SelectedValue.Length > 0) )
			{
				dtEffective = new DateTime(int.Parse(this.lstEffectiveYear.SelectedValue), int.Parse(this.lstEffectiveMonth.SelectedValue), int.Parse(this.lstEffectiveDay.SelectedValue));
			}
			else 
			{// The user select 'To Date' only 
				// Set the from date to a past date to cover all the record has been created
				dtEffective = new DateTime(1997,1,1);
			}
			

			

			if ((this.lstEffectiveToDay.SelectedValue.Length > 0) && (this.lstEffectiveToMonth.SelectedValue.Length > 0) && (this.lstEffectiveToYear.SelectedValue.Length > 0))
			{
				dtEffectiveTo = new DateTime(int.Parse(this.lstEffectiveToYear.SelectedValue), int.Parse(this.lstEffectiveToMonth.SelectedValue), int.Parse(this.lstEffectiveToDay.SelectedValue));
			}
			else
			{
				dtEffectiveTo = DateTime.Today;
			}

			//2. Add criteria to the report viewer
			Hashtable parameters = this.rvReport.Parameters;
			parameters["organisationID"] =  UserContext.UserData.OrgID;
			parameters["adminUserID"] =  UserContext.UserID;

			parameters["unitIDs"] =  strParentUnits;
			parameters["courseIDs"] =  intCourseID;
			parameters["FromDate"] = dtEffective;
			parameters["ToDate"] = dtEffectiveTo;

			parameters["langCode"] = Request.Cookies["currentCulture"].Value;
			parameters["langInterfaceName"] = "Report.Trend";
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
