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
	/// This page generates the summary report.
	/// </summary>
    public partial class SummaryReport : System.Web.UI.Page
    {
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
        /// Button to run report.
        /// </summary>
        protected System.Web.UI.WebControls.Button btnGenerate;

        /// <summary>
        /// Selection of day for effective date.
        /// </summary>
        protected System.Web.UI.WebControls.DropDownList lstEffectiveDay;

        /// <summary>
        /// Selection of month for effective date.
        /// </summary>
        protected System.Web.UI.WebControls.DropDownList lstEffectiveMonth;

        /// <summary>
        /// Selection of day for effective year.
        /// </summary>
        protected System.Web.UI.WebControls.DropDownList lstEffectiveYear;

        /// <summary>
        /// Place Holder for the search criteria.
        /// </summary>
        protected System.Web.UI.WebControls.PlaceHolder plhSearchCriteria;

        /// <summary>
        /// Place Holder for the report results.
        /// </summary>
        protected System.Web.UI.WebControls.PlaceHolder plhReportResults;

        /// <summary>
        /// Tree view to select unit(s) to search
        /// </summary>
        protected Uws.Framework.WebControl.TreeView trvUnitsSelector;

        /// <summary>
        /// Label displaying the page title
        /// </summary>
        protected System.Web.UI.WebControls.Label lblPageTitle;

        /// <summary>
        /// Datagrid of results
        /// </summary>
        protected System.Web.UI.WebControls.DataGrid dgrResults;


        /// <summary>
        /// Link to return to criteria screen
        /// </summary>
        protected System.Web.UI.WebControls.LinkButton lnkReturnToSearchScreen;

        /// <summary>
        /// Button to reset search criteria
        /// </summary>
        protected System.Web.UI.WebControls.Button btnReset;

        /// <summary>
        /// User control for report criteria
        /// </summary>
        protected Bdw.Application.Salt.Web.General.UserControls.ReportCriteria ucCriteria;
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
            this.lblError.Text="";
            if (!Page.IsPostBack)
            {
                // Setup the page for viewing.
                SetPageState();
            }
        }

        /// <summary>
        /// Switces the visible panes and goes back to the criteria page.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void lnkReturnToSearchScreen_Click(object sender, System.EventArgs e)
        {
            // Change back to the criteria view.
            plhReportResults.Visible = false;
            plhSearchCriteria.Visible = true;

        } // lnkReturnToSearchScreen_Click
 
        /// <summary>
        /// Called when the Generate button is clicked, gathers information from the form and generates report,
        /// then populates it in to the datagrid.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnGenerate_Click(object sender, System.EventArgs e)
        {
            //TODO: generate the report
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
            this.plhSearchCriteria.Visible=true;
            this.plhReportResults.Visible=false; 
            
        }

		/// <summary>
		/// Hide lesson status for the data migrated organisation on migration date
		/// it returns boolean value  
		/// </summary>
		private void ShowLessonStatus()
		{
			
            
		}


        /// <summary>
        /// Creates an new bound column object and sets the standard properties from the 
        /// supplied parameter collection
        /// </summary>
        /// <param name="headerText">Header text for the column</param>
        /// <param name="headerStyleHAlign">Horizontal alignment for the column header</param>
        /// <param name="dataField">Name of the data field returned in the SQL</param>
        /// <param name="itemStyleCSSClass">Name of the CSS for each row item in the datagrid</param>
        /// <param name="itemStyleWidth">Width of each row item in the datagrid</param>
        /// <param name="itemStyleHAlign">Horizontal alignment for each row item in the datagrid</param>
        /// <returns></returns>
        private BoundColumn CreateBoundColumn(string headerText, HorizontalAlign headerStyleHAlign, string dataField, string itemStyleCSSClass, int itemStyleWidth, HorizontalAlign itemStyleHAlign)
        {
            // Create a new bound column object
            BoundColumn objNew = new BoundColumn();

            // Set the prooperties of the new bound column
            objNew.HeaderText = headerText;
            objNew.HeaderStyle.HorizontalAlign = headerStyleHAlign;
            objNew.DataField = dataField;
            objNew.ItemStyle.CssClass = itemStyleCSSClass;
            objNew.ItemStyle.Width = itemStyleWidth;
            objNew.ItemStyle.HorizontalAlign = itemStyleHAlign;

            // Return the new Bound Column object
            return objNew;
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
                // Select the current year
                if (intYear == System.DateTime.Today.Year)
                {
                    itmEntry.Selected=true;
                }
            }

            // Select the current Day and month
            objDayListbox.SelectedIndex = 0;
            objMonthListbox.SelectedIndex = 0;
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
