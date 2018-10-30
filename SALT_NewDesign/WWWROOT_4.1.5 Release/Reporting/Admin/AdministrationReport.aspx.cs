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
using Bdw.Application.Salt.Utilities;
using Bdw.Application.Salt.ErrorHandler;
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Data;
using Uws.Framework.WebControl;
using Localization;
namespace Bdw.Application.Salt.Web.Reporting.Admin
{
	/// <summary>
	/// This page generates the Current and Historic administration summary reports.
	/// </summary>
	public partial class AdministrationReport : System.Web.UI.Page
	{
		protected Bdw.Application.Salt.Web.General.UserControls.Navigation.HelpLink ucHelp;

		#region Private Variables
 
		/// <summary>
		/// Enumeration of the report types.
		/// </summary>
		private enum  AdminReportType : int
		{
			Current = 1,
			Historic = 2
		}
 
		/// <summary>
		/// Place Holder for the search criteria.
		/// </summary>
		protected System.Web.UI.WebControls.Panel panelSearchCriteria;
 
		// Query string parameter name for report type
		private const string cm_strAdminReportTypeParameterName = "AdminReportType";
		private const string cm_strAdminReportTypeCurrent = "Current";
		private const string cm_strAdminReportTypeHistoric = "Historic";
 
		// ClassificationType Columns
		private const string CTypeColumnName = "Name";
		private const string CTypeColumnID = "ClassificationTypeID";
 
		// Classification Item columns
		private const string CListColumnClassificationID = "ClassificationID";
		private const string CListColumnClassificationTypeID = "ClassificationTypeID";
		private const string CListColumnValue = "Value";
		private const string CListColumnActive = "Active";
		#endregion
 
		#region Protected Variables
		/// <summary>
		/// Label to display any errors.
		/// </summary>
		protected System.Web.UI.WebControls.Label lblError;
 
		/// <summary>
		/// Selection of courses to search.
		/// </summary>
		protected System.Web.UI.WebControls.ListBox lstCourses;
 
		/// <summary>
		/// Text box to restrict search by for first name.
		/// </summary>
		protected System.Web.UI.WebControls.TextBox txtFirstName;
 
		/// <summary>
		/// Text box to restrict search by for last name.
		/// </summary>
		protected System.Web.UI.WebControls.TextBox txtLastName;
 
		/// <summary>
		/// Text box to restrict search by for user name.
		/// </summary>
		protected System.Web.UI.WebControls.TextBox txtUserName;
 
		/// <summary>
		/// Text box to restrict search by for email.
		/// </summary>
		protected System.Web.UI.WebControls.TextBox txtEmail;
 
		/// <summary>
		/// Selection of custom classifications (groupings).
		/// </summary>
		protected System.Web.UI.WebControls.DropDownList cboCustomClassification;
 
		/// <summary>
		/// Selection of day for effective date.
		/// </summary>
		protected System.Web.UI.WebControls.DropDownList lstEffectiveDay;
 
		/// <summary>
		/// Selection of month for effective date.
		/// </summary>
		protected System.Web.UI.WebControls.DropDownList lstEffectiveMonth;
 
		/// <summary>
		/// Selection of year for effective year.
		/// </summary>
		protected System.Web.UI.WebControls.DropDownList lstEffectiveYear;
 
		/// <summary>
		/// Place Holder for the report results (UNIT_USER).
		/// </summary>
		protected System.Web.UI.WebControls.Panel panelReportResults;
 
		/// <summary>
		/// Place Holder for the report results (COURSE).
		/// </summary>
		protected System.Web.UI.WebControls.Panel panelReportResultsByCourse;
 
		/// <summary>
		/// Place Holder for the effective date input search criteria.
		/// </summary>
		protected System.Web.UI.WebControls.PlaceHolder plhDateEffective;
 
		/// <summary>
		/// Tree view to select unit(s) to search
		/// </summary>
		protected Uws.Framework.WebControl.TreeView trvUnitsSelector;
 
		/// <summary>
		/// Label displaying the page title
		/// </summary>
		protected System.Web.UI.WebControls.Label lblPageTitle;
 
		/// <summary>
		/// Radio button group for Group By search criteria.
		/// </summary>
		protected System.Web.UI.WebControls.RadioButtonList radGroupBy;
 
		/// <summary>
		/// Selection of how to sort results when Group by Course selected.
		/// </summary>
		protected System.Web.UI.WebControls.DropDownList lstWithinUserSort;
 
		/// <summary>
		/// Checkbox for including inactive user 
		/// </summary>
		protected System.Web.UI.WebControls.CheckBox  chbInclInactiveUser;
		protected Localization.LocalizedLabel lblFormat;
		protected Localization.LocalizedLiteral litPage;
		protected Localization.LocalizedLiteral Localizedliteral1;
		protected Localization.LocalizedLiteral litOf;
		protected Localization.LocalizedLiteral litDisplayed;
 
		/// <summary>
		/// Report Viewer UNIT_USER
		/// </summary>

		protected Bdw.SqlServer.Reporting.WebControls.ReportViewer rvReport;
		/// <summary>
		/// Report Viewer COURSE
		/// </summary>
		protected Bdw.SqlServer.Reporting.WebControls.ReportViewer rvReportByCourse;
		#endregion
                        
		#region Web Form Designer generated code
 
		/// <summary>
		///  This call is required by the ASP.NET Web Form Designer.
		/// </summary>
		/// <param name="e">EventArgs</param>
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
 
			lstWithinUserSort.Items[0].Text = ResourceManager.GetString("lstWithinUserSort.1");
			lstWithinUserSort.Items[1].Text = ResourceManager.GetString("lstWithinUserSort.2");
			lstWithinUserSort.Items[2].Text = ResourceManager.GetString("lstWithinUserSort.3");
 
			radGroupBy.Items[0].Text = ResourceManager.GetString("radGroupBy.1");
			radGroupBy.Items[1].Text = ResourceManager.GetString("radGroupBy.2");
		}
                        
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
		}
		#endregion
 
		#region Private Event Handlers
		/// <summary>
		/// Event handler for the page load
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			ucHelp.Attributes["Desc"] = ResourceManager.GetString("ucHelp");
			lblPageTitle.Text =  ResourceManager.GetString("lblPageTitle");
			this.lblError.Text="";
            if (!Page.IsPostBack)
            {
                // Setup the page for viewing.
                SetPageState();

                // Adjust the viewable areas of the screen depending on the type of report.
                ConfigureParameterScreen();
            }
            else // fix bug where it changes to the current admin report on unit expand
            {
                switch ((int)ViewState[cm_strAdminReportTypeParameterName])
                {
                    case (int)AdminReportType.Current:
                        {
                            this.lblPageTitle.Text = ResourceManager.GetString("lblPageTitle.1");//"Current Admin Report";
                            this.chbInclInactiveUser.Visible = false;
                            this.lblInclInactiveUser.Visible = false;
                            this.lblPastCourses.Visible = false;
                            this.lstPastCourses.Visible = false;
                            break;
                        }
                    case (int)AdminReportType.Historic:
                        {
                            this.lblPageTitle.Text = ResourceManager.GetString("lblPageTitle.2");//"Historic Admin Report";
                            this.chbInclInactiveUser.Visible = true;
                            this.lblInclInactiveUser.Visible = true;
                            this.lblPastCourses.Visible = true;
                            this.lstPastCourses.Visible = true;
                            break;
                        }
                }
            }
		}
 
		/// <summary>
		/// Called when the Generate button is clicked, gathers information from the form and generates report
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void btnGenerate_Click(object sender, System.EventArgs e)
		{
			string[] astrUnits;                    // Array of units
			string strCourses="";   // String containing courses in csv format
			int intCustomClassificationID; // Int containing the Custom Classification ID
			DateTime dtEffective = new DateTime(1);
			int intInclInactive = 0;
			int intDay;
			int intMonth;
			int intYear;
			// units
			astrUnits = this.trvUnitsSelector.GetSelectedValues();
			BusinessServices.Unit objUnit = new  BusinessServices.Unit();
			astrUnits = objUnit.ReturnAdministrableUnitsByUserID(UserContext.UserID, UserContext.UserData.OrgID, astrUnits);
			string  strUnits  = String.Join(",", astrUnits);
                                    
			// courses
			for (int intIndex=0;intIndex != this.lstCourses.Items.Count;intIndex++)
			{
				if (this.lstCourses.Items[intIndex].Selected)
				{
					strCourses += this.lstCourses.Items[intIndex].Value + ",";
				}
			}
			for (int intIndex=0;intIndex != this.lstPastCourses.Items.Count;intIndex++)
			{
				if (this.lstPastCourses.Items[intIndex].Selected)
				{
					strCourses += this.lstPastCourses.Items[intIndex].Value + ",";
				}
			}
			if (strCourses.Length > 0)
			{
				strCourses = strCourses.Substring(0,strCourses.Length-1);
			}
 
			// effective date
			switch((int)ViewState[cm_strAdminReportTypeParameterName])
			{
				case (int)AdminReportType.Current:
				{
					dtEffective = System.DateTime.Today;
					break;
				}
				case (int)AdminReportType.Historic:
				{
					// Gather date parts for Effective Day
					intDay = Convert.ToInt16 (this.lstEffectiveDay.SelectedValue);
					intMonth = Convert.ToInt16 (this.lstEffectiveMonth.SelectedValue);
					intYear = Convert.ToInt16 (this.lstEffectiveYear.SelectedValue);
					dtEffective = new DateTime(intYear,intMonth,intDay);
					if (dtEffective.CompareTo(System.DateTime.Today) >= 1)
					{
						// You cant report historically on the future
						throw  new ArgumentOutOfRangeException();
					}
					if (this.chbInclInactiveUser.Checked)
					{
						intInclInactive = 1;
					}
					break;
				}
			}
                                    
			// custom classification
			if (this.cboCustomClassification.Items.Count==0)
			{
				intCustomClassificationID = 0;
			}
			else
			{
				intCustomClassificationID = int.Parse(this.cboCustomClassification.SelectedValue);
			}
 
			// report parameters
			Hashtable parameters;
			if (this.radGroupBy.SelectedValue.ToString() == "UNIT_USER")
			{
				parameters = this.rvReport.Parameters;
			}
			else
			{
				parameters = this.rvReportByCourse.Parameters;
			}
			parameters["organisationID"] = UserContext.UserData.OrgID;
			parameters["unitIDs"] = strUnits;
			parameters["courseIDs"] = strCourses;
			parameters["UserFirstName"] = this.txtFirstName.Text;
			parameters["UserLastName"] = this.txtLastName.Text;
			parameters["userName"] = this.txtUserName.Text;
			parameters["userEmail"] = this.txtEmail.Text;
			parameters["effectiveDate"] = dtEffective;
			parameters["adminUserID"] = UserContext.UserID;
			parameters["classificationID"] = intCustomClassificationID;
			parameters["groupBy"] = this.radGroupBy.SelectedValue.ToString();
			parameters["sortBy"] = this.lstWithinUserSort.SelectedValue.ToString();
			parameters["inclInactive"] = intInclInactive;
			parameters["serverURL"] = Request.Url.Host;
 
			// lang parameters
			parameters["langCode"] = Request.Cookies["currentCulture"].Value;
			parameters["langInterfaceName"] = "Report.Administration";
 
			// switch the placeholders
			this.panelSearchCriteria.Visible = false; 
			if (this.radGroupBy.SelectedValue.ToString() == "UNIT_USER")
			{
				this.panelReportResults.Visible = true;
				this.panelReportResultsByCourse.Visible = false;
			}
			else
			{
				this.panelReportResultsByCourse.Visible = true;
				this.panelReportResults.Visible = false;
			}
		} // btnGenerate_Click
                        
		/// <summary>
		/// This method captures the event associated with clicking the reset button.
		/// It returns the criteria form to its original state.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void btnReset_Click(object sender, System.EventArgs e)
		{
			// Re-call the same page so that the default search criteria values are shown
			Response.Redirect(Request.RawUrl);
 
		} // btnReset_Click
		#endregion
                        
		#region Private Methods
		/// <summary>
		/// Set the state of the page.
		/// </summary>
		private void SetPageState()
		{
			this.panelSearchCriteria.Visible=true;
			this.panelReportResults.Visible=false;
			this.panelReportResultsByCourse.Visible=false;
 
 
			// Store the current report type in the view state.
			switch(Request.QueryString[cm_strAdminReportTypeParameterName].ToString())
			{
				case cm_strAdminReportTypeCurrent:
				{
					ViewState[cm_strAdminReportTypeParameterName]= (int)AdminReportType.Current;
					this.lblPageTitle.Text = ResourceManager.GetString("lblPageTitle.1");//"Current Admin Report";
					this.chbInclInactiveUser.Visible = false;
					this.lblInclInactiveUser.Visible = false;
					this.lblPastCourses.Visible = false;
					this.lstPastCourses.Visible = false;
					break;
				}
				case cm_strAdminReportTypeHistoric:
				{
					ViewState[cm_strAdminReportTypeParameterName]= (int)AdminReportType.Historic;
					this.lblPageTitle.Text = ResourceManager.GetString("lblPageTitle.2");//"Historic Admin Report";
					this.chbInclInactiveUser.Visible = true;
					this.lblInclInactiveUser.Visible = true;
					this.lblPastCourses.Visible = true;
					this.lstPastCourses.Visible = true;
					break;
				}
			}
			trSortBy.Visible=false;
		}
 
                        
		/// <summary>
		/// This method configured the screen to be appropriate for the type of report being generated.
		/// </summary>
		private void ConfigureParameterScreen()
		{
			int intAdminReportType = Convert.ToInt16 (ViewState[cm_strAdminReportTypeParameterName]);
 
			// Hide areas of the screen
			switch(intAdminReportType)
			{
				case (int)AdminReportType.Current:
				{
					// Current reports dont have any date controls.
					HideEffectiveDateControl();
					break;
				}
				case (int)AdminReportType.Historic:
				{
					// Historical reports have just the effective point in history date control
					ShowEffectiveDateControl();
					SetupDateControl(lstEffectiveDay,lstEffectiveMonth,lstEffectiveYear);
					break;
				}
			}
                                    
			DisplayClassifications();
 
			// Get Courses accessable to this organisation
			Course objCourse = new Course();
			DataTable dtbCourses = objCourse.GetCourseListAccessableToOrg(UserContext.UserData.OrgID);
			if (dtbCourses.Rows.Count>0)
			{
				lstCourses.DataSource = dtbCourses;
				lstCourses.DataTextField = "Name";
				lstCourses.DataValueField ="CourseID";
				lstCourses.DataBind();
			}
			else
			{
				this.lblError.Visible = true;
				this.lblError.Text += "<BR>" + ResourceManager.GetString("lblError.NoCourse");//"No courses exist within this organisation.";
				this.lblError.CssClass = "WarningMessage";
				this.panelSearchCriteria.Visible=false;
			}
			// If there is at least one course then select it.
			if (lstCourses.Items.Count>0)
			{lstCourses.SelectedIndex=0;} 
 
			// Populate past courses
			DataTable dtPastCourses = objCourse.GetPastCourseListForOrg(UserContext.UserData.OrgID);
			if (dtPastCourses.Rows.Count > 0)
			{
				lstPastCourses.DataSource = dtPastCourses;
				lstPastCourses.DataTextField = "Name";
				lstPastCourses.DataValueField = "CourseID";
				lstPastCourses.DataBind();
			}
 
			// Get Units accessable to this user.
			BusinessServices.Unit objUnit = new BusinessServices.Unit();
			DataSet dstUnits = objUnit.GetUnitsTreeByUserID(UserContext.UserData.OrgID ,UserContext.UserID,'A');
                                    
			// Convert this to an xml string for rendering by the UnitTreeConverter.
			string strUnits = UnitTreeConvert.ConvertXml(dstUnits);
			if (strUnits=="")
			{
				// No units found.
				this.lblError.Visible = true;
				this.lblError.Text += "<BR>" + ResourceManager.GetString("lblError.NoUnit");//No units exist within this organisation.";
				this.lblError.CssClass = "FeedbackMessage";
				this.panelSearchCriteria.Visible=false;
			}
			else
			{
				// Change to the appropriate view and load the Units in
				this.trvUnitsSelector.LoadXml(strUnits);
			}
		}
 
		/// <summary>
		/// 
		/// </summary>
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
 
		/// <summary>
		/// Hides the effective date control
		/// </summary>
		private void HideEffectiveDateControl()
		{
			plhDateEffective.Visible=false;
		}
                        
		/// <summary>
		/// Shows the effective date control
		/// </summary>
		private void ShowEffectiveDateControl()
		{
			plhDateEffective.Visible=true;
		}
 
		/// <summary>
		/// Sets up a date control to display the current date by default
		/// </summary>
		/// <param name="objDayListbox">The Day Listbox</param>
		/// <param name="objMonthListbox">The Month Listbox</param>
		/// <param name="objYearListbox">The Year Listbox</param>
		private void SetupDateControl(DropDownList objDayListbox, DropDownList objMonthListbox, DropDownList objYearListbox)
		{
			// Setup 'Effective' Date Controls
			for (int intDay=1; intDay<=31; intDay++)
			{
				objDayListbox.Items.Add (intDay.ToString());
			}
 
			for (int intMonth=1; intMonth<=12; intMonth++)
			{
				objMonthListbox.Items.Add (intMonth.ToString());
			}
 
			for (int intYear=System.DateTime.Today.Year-10; intYear!=System.DateTime.Today.Year + 1; intYear++)
			{
				ListItem itmEntry = new ListItem();
				itmEntry.Text = intYear.ToString();
				itmEntry.Value= intYear.ToString();
 
				objYearListbox.Items.Add (itmEntry);				
			}


            BusinessServices.Report r = new Report();

            DataTable dt = r.getYesterdayforOrgTZ(UserContext.UserData.OrgID);
            String strDate = dt.Rows[0].ItemArray[0].ToString();
			// Select the current Day and month
            String[] strarr = strDate.Split(' ');
            strDate = strarr[0];
            strarr = strDate.Split('/');

            objDayListbox.SelectedValue = strarr[0];
            objMonthListbox.SelectedValue = strarr[1];
            objYearListbox.SelectedValue = strarr[2];
            lblTZName.Text  = dt.Rows[0].ItemArray[1].ToString();
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
 
		protected void radGroupBy_SelectedIndexChanged(object sender, System.EventArgs e)
		{
			if (this.radGroupBy.SelectedValue.ToString() == "COURSE")
			{
				trSortBy.Visible=true;
			}
			else
			{
				trSortBy.Visible=false;
			}
		}
 
		protected void chbInclInactiveUser_CheckedChanged(object sender, System.EventArgs e)
		{
                        
		}
	}                              
}
