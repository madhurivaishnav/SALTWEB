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
namespace Bdw.Application.Salt.Web.Reporting.CompletedUsers
{
    /// <summary>
    /// Business logic and presentation logic for the completed users report
    /// </summary>
    /// <remarks>
    /// Assumptions: None
    /// Notes: 
    /// Author: Stephen Kennedy-Clark. Pagination By Peter Varanich. Column headings bought to you by Peter Kneale.
    /// Changes:
    /// </remarks>
	public partial class CompletedUsersReport : System.Web.UI.Page
	{
		protected Bdw.Application.Salt.Web.General.UserControls.Navigation.HelpLink ucHelp;
        #region protected variables
        /// <summary>
        /// Search Criteria Place Holder
        /// </summary>
        protected System.Web.UI.WebControls.PlaceHolder plhSearchCriteria;
        /// <summary>
        /// Unit Selector tree view
        /// </summary>
        protected Uws.Framework.WebControl.TreeView trvUnitsSelector;
        /// <summary>
        /// Course selector drop down
        /// </summary>
        protected System.Web.UI.WebControls.DropDownList cboCourse;
        /// <summary>
        /// Generate report button
        /// </summary>
        protected System.Web.UI.WebControls.Button btnRunReport;
        /// <summary>
        /// Status Radio Button
        /// </summary>
        protected System.Web.UI.WebControls.RadioButtonList optStatus;
   
        /// <summary>
        /// Paginated data grid
        /// </summary>
        protected System.Web.UI.WebControls.DataGrid dgrResults;

        /// <summary>
        /// Label for total records
        /// </summary>
		protected System.Web.UI.WebControls.Label lblTotalRecordCount;

        /// <summary>
        /// Label showing records on current page
        /// </summary>
		protected System.Web.UI.WebControls.Label lblCurrentPageRecordCount;

        /// <summary>
        /// Label showing page counter
        /// </summary>
		protected System.Web.UI.WebControls.Label lblPageCount;

        /// <summary>
        /// Drop down list to select page to jump to
        /// </summary>
		protected System.Web.UI.WebControls.DropDownList cboPage;

        /// <summary>
        /// Button to go to next page
        /// </summary>
		protected System.Web.UI.WebControls.LinkButton btnNext;

        /// <summary>
        /// Button to go to previous page
        /// </summary>
		protected System.Web.UI.WebControls.LinkButton btnPrev;

        /// <summary>
        /// Table surrounding pagination
        /// </summary>
		protected System.Web.UI.HtmlControls.HtmlTable tblPagination;

        /// <summary>
        /// Table row surrounding pagination
        /// </summary>
		protected System.Web.UI.HtmlControls.HtmlTableRow trPagination;

        /// <summary>
        /// Report results placeholder
        /// </summary>
        protected System.Web.UI.WebControls.PlaceHolder plhReportResults;

        /// <summary>
        /// Label for page title
        /// </summary>
        protected System.Web.UI.WebControls.Label lblPageTitle;

        /// <summary>
        /// Button to reset form
        /// </summary>
        protected System.Web.UI.WebControls.Button btnReset;

        /// <summary>
        /// Button to generate report
        /// </summary>
        protected System.Web.UI.WebControls.Button btnGenerateReport;

        /// <summary>
        /// Link to return to search screen
        /// </summary>
        protected System.Web.UI.WebControls.LinkButton lnkReturnToSearchScreen;

        /// <summary>
        /// Listbox containing values for the day component of the effective date
        /// </summary>
        protected System.Web.UI.WebControls.DropDownList lstEffectiveDay;

        /// <summary>
        /// Listbox containing values for the month component of the effective date
        /// </summary>
        protected System.Web.UI.WebControls.DropDownList lstEffectiveMonth;

        /// <summary>
        /// Listbox containing values for the year component of the effective date
        /// </summary>
        protected System.Web.UI.WebControls.DropDownList lstEffectiveYear;

        /// <summary>
        /// User control for report criteria
        /// </summary>
        protected Bdw.Application.Salt.Web.General.UserControls.ReportCriteria ucCriteria;

        /// <summary>
        /// Label to show errors warnings etc.
        /// </summary>
		protected System.Web.UI.WebControls.Label lblError;

        /// <summary>
        /// Holds the persistant column heading name for the units
        /// </summary>
        private string strUnit;

        #endregion

        #region Private Event Handlers
        /// <summary>
        /// Page Load event
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, System.EventArgs e)
        {
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			ucHelp.Attributes["Desc"] = ResourceManager.GetString("ucHelp");
			lblPageTitle.Text =  ResourceManager.GetString("lblPageTitle");
            this.SetPageState();          
        }
        #endregion
		
        #region Private Methods

        /// <summary>
        /// Set the state of the page       
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen K-Clark
        /// Changes:
        /// </remarks>
        private void SetPageState()
        {           
            // when the page loads for the first time hide the report results place holder.           
            if(!Page.IsPostBack)
            {
                //this.tblPagination.Visible = false;
                this.plhReportResults.Visible = false;
                plhSearchCriteria.Visible = true;
                this.PaintCriteraPageState();
            }
            else
            {
                if(Convert.ToBoolean(optStatus.SelectedValue))
                {
                    lblPageTitle.Text = ResourceManager.GetString("lblPageTitle.1");//"Completed Users Report";
                }
                else
                {
                    lblPageTitle.Text = ResourceManager.GetString("lblPageTitle.2");//"Incomplete Users Report";
                }
            }
        }

        /// <summary>
        /// Paint Critera section of the page
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen K-Clark
        /// Changes:
        /// </remarks>
        private void PaintCriteraPageState()
        {
            // Paint the unit selector
            BusinessServices.Unit objUnit= new  BusinessServices.Unit(); // Unit Object
            DataSet dstUnits = objUnit.GetUnitsTreeByUserID(UserContext.UserData.OrgID,UserContext.UserID,'A'); // Data set to contain unit details
			if (dstUnits.Tables[0].Rows.Count>0)
			{
				string strUnits = UnitTreeConvert.ConvertXml(dstUnits); // comma seperated list of units
				this.trvUnitsSelector.LoadXml(strUnits);

				// Paint the course list details
				int intOrganisationID = UserContext.UserData.OrgID; // organisation ID
				BusinessServices.Course objCourse = new BusinessServices.Course(); //Course Object
				DataTable dtbCourses = objCourse.GetCourseListAccessableToOrg(intOrganisationID); // List of courses accesable to the organisation
				if (dtbCourses.Rows.Count==0)
				{
					this.plhSearchCriteria.Visible=false;
					this.lblError.Text+=ResourceManager.GetString("lblError.NoCourse");//"No courses exist within this organisation.";
                    this.lblError.CssClass = "FeedbackMessage";
					this.lblError.Visible=true;
				}
				else
				{
					cboCourse.DataSource = dtbCourses;
					cboCourse.DataValueField = "CourseID";
					cboCourse.DataTextField = "Name";
					cboCourse.DataBind();
				}

                SetupDateControl(this.lstEffectiveDay, this.lstEffectiveMonth, this.lstEffectiveYear);
			}
			else
			{
				this.plhSearchCriteria.Visible=false;
				this.lblError.Text+=ResourceManager.GetString("lblError.NoUnit");//"No units exist within this organisation.";
                this.lblError.CssClass = "FeedbackMessage";
				this.lblError.Visible=true;
			}
		}

        /// <summary>
        /// Sets up a date control to display the current date by default
        /// This should be moved to a utility class as the Admin report also accesses this code
        /// </summary>
        /// <param name="objDayListbox">The Day Listbox</param>
        /// <param name="objMonthListbox">The Month Listbox</param>
        /// <param name="objYearListbox">The Year Listbox</param>
        private void SetupDateControl(DropDownList objDayListbox, DropDownList objMonthListbox, DropDownList objYearListbox)
        {
            // Setup 'Effective' Date Controls
            objDayListbox.Items.Add("");
            for (int intDay=1; intDay<=31; intDay++)
            {
                objDayListbox.Items.Add(intDay.ToString());
            }

            objMonthListbox.Items.Add("");
            for (int intMonth=1; intMonth<=12; intMonth++)
            {
                objMonthListbox.Items.Add(intMonth.ToString());
            }

            objYearListbox.Items.Add("");
            for (int intYear=System.DateTime.Today.Year; intYear!=System.DateTime.Today.Year - 10; intYear--)
            {
                objYearListbox.Items.Add(intYear.ToString());
            }

            // Select the current Day and month
            objDayListbox.SelectedIndex = 0;
            objMonthListbox.SelectedIndex = 0;
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
			optStatus.Items[0].Text = ResourceManager.GetString("optStatus.1");
			optStatus.Items[1].Text = ResourceManager.GetString("optStatus.2");
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
            this.dgrResults.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(this.dgrResults_ItemDataBound);

        }
		#endregion

		#region Private Event Handlers

		/// <summary>
		/// Handles the event raised by the user selecting the generate report button
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
        protected void btnRunReport_Click(object sender, System.EventArgs e)
        {
            if( validateDateControl(this.lstEffectiveYear.SelectedValue, this.lstEffectiveMonth.SelectedValue, this.lstEffectiveDay.SelectedValue) )
            {
				plhReportResults.Visible = true;
				plhSearchCriteria.Visible = false;
				this.lblError.Text="";
                this.lblError.Visible=false;            
                this.StartPagination();
            }
            else
            {
				plhReportResults.Visible = false;
				plhSearchCriteria.Visible = true;
                this.lblError.Text=ResourceManager.GetString("lblError.Date");//"The effective date must be valid and cannot be greater than today";
                this.lblError.Visible=true; 
            }            
        }

        
        /// <summary>
        /// checks that the date entered in the date controll is valid
        /// </summary>
        /// <param name="year">year as string</param>
        /// <param name="month">month as string</param>
        /// <param name="day">day as string</param>
        private bool validateDateControl(string year, string month,string day)
        {
            bool bRetVal = true;
            if (!(year.Length == 0 && month.Length == 0 && day.Length == 0))
            {
                try
                {
                    DateTime dtTest = new DateTime(int.Parse(year), int.Parse(month), int.Parse(day));
                    if (dtTest.CompareTo(System.DateTime.Today) >= 1)
                    {
                        // Can't provide a historic date in the future
                        throw new ArgumentOutOfRangeException();
                    }
                }
                catch
                {
                    bRetVal = false;
                }
            }

            return bRetVal;
        }

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
        }

        /// <summary>
        /// Event handler for returning to the search criteria screen
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void lnkReturnToSearchScreen_Click(object sender, System.EventArgs e)
        {
            this.plhReportResults.Visible = false;
            this.plhSearchCriteria.Visible = true; 
        }

		/// <summary>
		/// Event handler for the item being bound to the column
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void dgrResults_ItemDataBound(object sender, DataGridItemEventArgs e)
		{
			int c_intColumnUnit=0;			// Column 0 is the Unit
			// If its a regular data row (normal or alternate)
			if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
			{
				// Table cell collection of all cells
				TableCellCollection tclCells = e.Item.Cells;

				// Show and hide the unit name
				if (tclCells[c_intColumnUnit].Text != strUnit)
				{
					// Capture the new unit name
					strUnit = tclCells[c_intColumnUnit].Text;
					tclCells[c_intColumnUnit].CssClass="tablerow2Selected";
				}
				else
				{
					// Hide the existing unit name
					tclCells[c_intColumnUnit].Text = "&nbsp;";
					tclCells[c_intColumnUnit].CssClass="TableRow1";
				}
			}
		}

        #endregion
	
		#region Pagination customisation (Change this section according to business logic)

		/// <summary>
		/// Start Pagination
		/// </summary>
		private void StartPagination()
		{
			this.tblPagination.Visible = true;
			this.ShowPagination(0);
		}
		

		/// <summary>
		/// Get Pagination Data
		/// </summary>
		/// <returns> DataView with all users that are not organisation administrators.</returns>
		private DataView GetPaginationData()
		{
                // Get the selected units
                // string  strParentUnits  = String.Join(",",this.trvUnitsSelector.GetSelectedValues());
                BusinessServices.Unit objUnit = new  BusinessServices.Unit();
    			string  strParentUnits  = String.Join(",",objUnit.ReturnAdministrableUnitsByUserID( UserContext.UserID, UserContext.UserData.OrgID, trvUnitsSelector.GetSelectedValues() ));
                if (strParentUnits.Length == 0)
                {
                    strParentUnits = null;
                }

                // Get the selected course and Complete / Incomplete status
                int intCourseID = Convert.ToInt32(cboCourse.SelectedValue);
                bool bolStatus = Convert.ToBoolean(optStatus.SelectedValue);

                // Gather date parts for historic date
                DateTime dtEffective;

                if ( (this.lstEffectiveDay.SelectedValue.Length > 0) && (this.lstEffectiveMonth.SelectedValue.Length > 0) && (this.lstEffectiveYear.SelectedValue.Length > 0) )
                {
                    dtEffective = new DateTime(int.Parse(this.lstEffectiveYear.SelectedValue), int.Parse(this.lstEffectiveMonth.SelectedValue), int.Parse(this.lstEffectiveDay.SelectedValue));
                    if (dtEffective.CompareTo(System.DateTime.Today) >= 1)
                    {
                        // Can't provide a historic date in the future
                        throw new ArgumentOutOfRangeException();
                    }
                }
                else
                {
                    dtEffective = DateTime.MinValue;
                }

                // Execute the report
                BusinessServices.Report objReport = new BusinessServices.Report();
                DataTable dtblReport = objReport.GetCompletedUsersReport(UserContext.UserData.OrgID, strParentUnits, intCourseID, dtEffective, bolStatus);
                if (dtblReport.Rows.Count == 0)
                {
                    this.lblError.Visible = true;
                    this.lblError.Text += ResourceManager.GetString("lblError.NoUsers");//"No users found.";
                    this.lblError.CssClass = "FeedbackMessage";
                }
                else
                {
                    BusinessServices.User objUser = new BusinessServices.User();
                    DataTable dtbUser = objUser.GetUser(UserContext.UserID);
                    if (dtbUser.Rows.Count>0)
                    {
                        // Display Report Criteria
                        this.ucCriteria.Criteria.Add(ResourceManager.GetString("ReportRunBy"),dtbUser.Rows[0]["LastName"].ToString()+ ", " + dtbUser.Rows[0]["FirstName"].ToString());
                        this.ucCriteria.Criteria.Add(ResourceManager.GetString("ReportRunAt"),DateTime.Now.ToString("dd/MM/yyyy") + " " + DateTime.Now.ToLongTimeString());
                    }
                    if (trvUnitsSelector.GetSelectedValues().Length==0)
                    {
                        this.ucCriteria.AddUnits(null); 
                    }
                    else
                    {
                        this.ucCriteria.AddUnits(strParentUnits);
                    }
                    this.ucCriteria.AddCourses(intCourseID.ToString()); 
                    if (bolStatus)
                    {
                        this.ucCriteria.Criteria.Add(ResourceManager.GetString("cmnStatus"),ResourceManager.GetString("optStatus.1"));
                    }
                    else
                    {
                        this.ucCriteria.Criteria.Add(ResourceManager.GetString("cmnStatus"),ResourceManager.GetString("optStatus.2"));
                    }
                    if (dtEffective != DateTime.MinValue)
                    {
                        this.ucCriteria.Criteria.Add(ResourceManager.GetString("EffectiveDate"),dtEffective.ToString("dd/MM/yyyy"));
                    }
                    else
                    {
                        this.ucCriteria.Criteria.Add(ResourceManager.GetString("EffectiveDate"),DateTime.Now.ToString("dd/MM/yyyy"));
                    }
                    this.ucCriteria.Render();
                }
                //Customize, and return DataView
                return dtblReport.DefaultView;
            
			
		}
		
		#endregion

		#region Pagination Event Handlers (Don't make any changes to this section)	
		
		/// <summary>
		/// Go to previous page.
		/// </summary>
		protected void btnPrev_Click(object sender, System.EventArgs e)
		{
			this.ShowPagination(this.dgrResults.CurrentPageIndex - 1);
		}

		/// <summary>
		/// Go to next page.
		/// </summary>
		protected void btnNext_Click(object sender, System.EventArgs e)
		{
			this.ShowPagination(this.dgrResults.CurrentPageIndex + 1);
		}

		/// <summary>
		/// Go to a specific page.
		/// </summary>
		protected void cboPage_SelectedIndexChanged(object sender, System.EventArgs e)
		{
			int intPageIndex;
			intPageIndex = int.Parse(this.cboPage.SelectedValue);
			this.ShowPagination(intPageIndex - 1);
		}

		
		/// <summary>
		/// Show Paging Data.
		/// </summary>
		/// <param name="currentPageIndex"></param>
		private void ShowPagination(int currentPageIndex)
		{
			//1. Get data
            
            DataView dvwPagination = this.GetPaginationData();
            if (dvwPagination.Table.Rows.Count > 0)
            {
                this.plhSearchCriteria.Visible = false;
                this.plhReportResults.Visible = true;
		
                if(dvwPagination.Count == 0)
                {
                    this.tblPagination.Visible = false;
                }
		
                //3. Set pagination panel
                int intPageSize;
                intPageSize = ApplicationSettings.PageSize ;
                this.SetPaginationPanel(intPageSize, dvwPagination.Count, currentPageIndex);

                //4. Bind Data
                //5. Set the Key field for the DataGrid
                dgrResults.DataKeyField = "UserID";
                dgrResults.DataSource = dvwPagination;
                dgrResults.PageSize = intPageSize;
                dgrResults.CurrentPageIndex = currentPageIndex;
                dgrResults.DataBind();


                // Switch the placeholders to show the appropriate view.
                this.plhSearchCriteria.Visible = false; 
                this.plhReportResults.Visible = true;

            }
            else
            {
                this.plhSearchCriteria.Visible = true;
                this.plhReportResults.Visible = false;
            }
        
            
			
		}

		/// <summary>
		/// Sets the pagination panel.
		/// </summary>
		/// <param name="pageSize"></param>
		/// <param name="totalRecordCount"></param>
		/// <param name="currentPageIndex"></param>
		private void SetPaginationPanel(int pageSize, int totalRecordCount, int currentPageIndex)
		{
			//1. Get pagination info
			int intPageSize;
			int intTotalRecordCount;
			int intPageCount;
			int intCurrentPageStart;
			int intCurrentPageEnd;
			ListItem objItem;

			intPageSize = pageSize;
			intTotalRecordCount = totalRecordCount;
			intPageCount = ((int)(intTotalRecordCount - 1) / intPageSize) + 1;
			
			//Page start record number
			if(intTotalRecordCount!=0)
			{
				intCurrentPageStart = intPageSize * currentPageIndex + 1;
			}
			else
			{
				intCurrentPageStart = 0;
			}
			//Page end record number
			if (currentPageIndex < intPageCount - 1)
			{
				intCurrentPageEnd =  intPageSize * (currentPageIndex + 1);
			}
				//Last page, the page record count is the remaining records
			else
			{
				intCurrentPageEnd = intTotalRecordCount;
			}		
			//2. Set  pagination
			//2.1 Set dropdown page selector
			this.cboPage.Items.Clear();
			for(int i = 1; i <=  intPageCount; i++)
			{
				objItem = new ListItem(i.ToString());
				if (i == currentPageIndex + 1)
				{
					objItem.Selected = true;
				}		
				this.cboPage.Items.Add(objItem);
			}
			
			//2.2 Set Page numbers
			this.lblPageCount.Text = intPageCount.ToString();
			this.lblCurrentPageRecordCount.Text = intCurrentPageStart.ToString() +" - " + intCurrentPageEnd.ToString();
			this.lblTotalRecordCount.Text = intTotalRecordCount.ToString();
			
			//2.3 Disable prev, next buttons
			this.btnPrev.Enabled = true;
			this.btnNext.Enabled = true;
			//First Page
			if (currentPageIndex == 0)
			{	
				this.btnPrev.Enabled = false;
			}
			//Last Page
			if (currentPageIndex == intPageCount - 1)
			{	
				this.btnNext.Enabled = false;
			}
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
