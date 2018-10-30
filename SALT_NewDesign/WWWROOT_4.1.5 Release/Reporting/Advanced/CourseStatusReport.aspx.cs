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
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Data;
using Localization;
namespace Bdw.Application.Salt.Web.Reporting.Advanced
{
    /// <summary>
    /// Business logic and presentation logic for the completed users report
    /// </summary>
    /// <remarks>
    /// Notes: 
    /// Author: Jack Liu
    /// Changes:
    /// </remarks>
	public partial class CourseStatusReport : System.Web.UI.Page
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

//		protected System.Web.UI.WebControls.DropDownList cboCourse;

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
			// Check if the selected dates are valid
			if(WebTool.ValidateHistoricDateControl(this.lstEffectiveDay, this.lstEffectiveMonth, this.lstEffectiveYear) &&
				WebTool.ValidateHistoricDateControl(this.lstEffectiveToDay, this.lstEffectiveToMonth, this.lstEffectiveToYear))
			{
				if ((this.lstEffectiveYear.SelectedValue.Length > 0)&& (this.lstEffectiveToYear.SelectedValue.Length > 0))
				{//Both From and To Dates are selected
					DateTime dtFromDate = new DateTime(int.Parse(this.lstEffectiveYear.SelectedValue), int.Parse(this.lstEffectiveMonth.SelectedValue), int.Parse(this.lstEffectiveDay.SelectedValue));
					DateTime dtToDate = new DateTime(int.Parse(this.lstEffectiveToYear.SelectedValue), int.Parse(this.lstEffectiveToMonth.SelectedValue), int.Parse(this.lstEffectiveToDay.SelectedValue));
		
					if(dtFromDate <= dtToDate)
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
				this.lblError.Text=ResourceManager.GetString("lblError.NoUnit");//"No units exist within this organisation.";
				this.lblError.Visible=true;

				return;
			}
			string strUnits = UnitTreeConvert.ConvertXml(dstUnits); // comma seperated list of units
			this.trvUnitsSelector.LoadXml(strUnits);

			//2. Paint the course list details
			int intOrganisationID = UserContext.UserData.OrgID; // organisation ID
			BusinessServices.Course objCourse = new BusinessServices.Course(); //Course Object
			// Get Courses accessable to this organisation
			DataTable dtbCourses = objCourse.GetCourseListAccessableToOrg(intOrganisationID); // List of courses accesable to the organisation

			if (dtbCourses.Rows.Count>0)
			{
				lstCourses.DataSource = dtbCourses;
				lstCourses.DataTextField = "Name";
				lstCourses.DataValueField ="CourseID";
				lstCourses.DataBind();
			}
			else
			{
				this.plhSearchCriteria.Visible=false;
				this.lblError.Text=ResourceManager.GetString("lblError.NoCourse");//"No courses exist within this organisation.";
				this.lblError.CssClass = "FeedbackMessage";
				this.lblError.Visible=true;
				return;
			}
			// If there is at least one course then select it.
			if (lstCourses.Items.Count>0)
			{lstCourses.SelectedIndex=0;} 

			//3. setup date control
			WebTool.SetupHistoricDateControl(this.lstEffectiveDay, this.lstEffectiveMonth, this.lstEffectiveYear);
			WebTool.SetupHistoricDateControl(this.lstEffectiveToDay, this.lstEffectiveToMonth, this.lstEffectiveToYear);

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
			string strCourses ="";
			selectUnits = trvUnitsSelector.GetSelectedValues();
			
			DateTime dtEffective;
			DateTime dtEffectiveTo;
			//Double check
			BusinessServices.Unit objUnit = new  BusinessServices.Unit();
			selectUnits = objUnit.ReturnAdministrableUnitsByUserID( UserContext.UserID, UserContext.UserData.OrgID, selectUnits);
			string  strParentUnits  = String.Join(",",selectUnits);
			
			// Get the selected course and Complete / Incomplete status
//			int intCourseID = Convert.ToInt32(cboCourse.SelectedValue);
			int bolStatus = Int32.Parse(optStatus.SelectedValue.ToString());

			// Get the selected courses
			for (int intIndex=0;intIndex != this.lstCourses.Items.Count;intIndex++)
			{
				if (this.lstCourses.Items[intIndex].Selected)
				{
					if(intIndex == 0)
					{
						strCourses += this.lstCourses.Items[intIndex].Value;					
					}
					else
					{
						strCourses += "," + this.lstCourses.Items[intIndex].Value ;
					}
				}
			}                         
			
			// Gather date parts for historic date
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

			int intIncludeIncative =0;
			if (chbInclInactiveUser.Checked)
			{
				intIncludeIncative = 1;
			}
			int intClassificationID = 0;
			if (this.cboCustomClassification.SelectedIndex > 0)
			{
				intClassificationID = int.Parse(this.cboCustomClassification.SelectedValue);
			}

			//2. Add criteria to the report viewer
			Hashtable parameters = this.rvReport.Parameters;
			parameters["organisationID"] =  UserContext.UserData.OrgID;
			parameters["adminUserID"] =  UserContext.UserID;
			parameters["unitIDs"] =  strParentUnits;
			parameters["courseIDs"] =  strCourses;
//			parameters["CourseName"] = cboCourse.SelectedItem.ToString();
			//parameters["completed"] =  bolStatus;
			parameters["courseModuleStatus"] =  bolStatus;
		
			parameters["dateFrom"] =  dtEffective.ToString("s");
			
			parameters["dateTo"] = dtEffectiveTo.ToString("yyyy-MM-dd");
			parameters["IncludeInactive"] = intIncludeIncative;
			parameters["langCode"] = Request.Cookies["currentCulture"].Value;
			parameters["langInterfaceName"] = "Report.CourseStatus";
			parameters["classificationID"] = intClassificationID;

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
			
			optStatus.Items[0].Text = ResourceManager.GetString("optStatus.1");
			optStatus.Items[1].Text = ResourceManager.GetString("optStatus.2");
			optStatus.Items[2].Text = ResourceManager.GetString("optStatus.3");
			optStatus.Items[3].Text = ResourceManager.GetString("optStatus.4");
			optStatus.Items[4].Text = ResourceManager.GetString("optStatus.5");
			optStatus.Items[5].Text = ResourceManager.GetString("optStatus.6");

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
