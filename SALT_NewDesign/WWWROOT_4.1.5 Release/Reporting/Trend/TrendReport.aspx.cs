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
namespace Bdw.Application.Salt.Web.Reporting.Trend
{
	/// <summary>
	/// Summary description for TrendReport.
	/// </summary>
	public partial class TrendReport : System.Web.UI.Page
	{
		protected Bdw.Application.Salt.Web.General.UserControls.Navigation.HelpLink ucHelp;
		#region Protected Variables
		/// <summary>
		/// Place Holder for the search criteria.
		/// </summary>
		protected System.Web.UI.WebControls.PlaceHolder plhSearchCriteria;

        /// <summary>
        /// Treeview control for selecting units
        /// </summary>
		protected Uws.Framework.WebControl.TreeView trvUnitsSelector;

        /// <summary>
        /// No subunits exist label
        /// </summary>
		protected System.Web.UI.WebControls.Label lblNoSubUnits;

        /// <summary>
        /// Combo box to select Courses
        /// </summary>
		protected System.Web.UI.WebControls.DropDownList cboCourses;

        /// <summary>
        /// Button to generate report
        /// </summary>
		protected System.Web.UI.WebControls.Button btnGenerate;

        /// <summary>
        /// Label for displaying errors
        /// </summary>
		protected System.Web.UI.WebControls.Label lblError;

        /// <summary>
        /// Table for holding quiz score.
        /// </summary>
		protected System.Web.UI.WebControls.Table tblQuizScore;

        /// <summary>
        /// Table for holding quiz pass mark
        /// </summary>
		protected System.Web.UI.WebControls.Table tblQuizPassMark;

        /// <summary>
        /// Table row for holding quiz score
        /// </summary>
		protected System.Web.UI.WebControls.TableRow tbrQuizScore;

        /// <summary>
        /// Table row for holding quiz pass mark
        /// </summary>
		protected System.Web.UI.WebControls.TableRow tbrQuizPassMark;

        /// <summary>
        /// Table cell for holding quiz score.
        /// </summary>
		protected System.Web.UI.WebControls.TableCell tclQuizScore;

        /// <summary>
        /// Table cell for holding quiz pass mark
        /// </summary>
		protected System.Web.UI.WebControls.TableCell tclQuizPassMark;

        /// <summary>
        /// Table cell for holding quiz total
        /// </summary>
		protected System.Web.UI.WebControls.TableCell tclQuizTotal;

        /// <summary>
        /// Table cell for holding quiz pass mark total
        /// </summary>
		protected System.Web.UI.WebControls.TableCell tclQuizPassMarkTotal;

        /// <summary>
        /// Label for holding quiz score.
        /// </summary>
		protected System.Web.UI.WebControls.Label lblQuizScore;

        /// <summary>
        /// Label for holding quiz pass mark
        /// </summary>
		protected System.Web.UI.WebControls.Label lblQuizPassMark;

		/// <summary>
		/// Place Holder for the report results.
		/// </summary>
		protected System.Web.UI.WebControls.PlaceHolder plhReportResults;

        /// <summary>
        /// Datagrid of results
        /// </summary>
        protected System.Web.UI.WebControls.DataGrid dgrResults;
		
        /// <summary>
        /// Label showing total record count
        /// </summary>
		protected System.Web.UI.WebControls.Label lblTotalRecordCount;

        /// <summary>
        /// Label showing current records on page
        /// </summary>
		protected System.Web.UI.WebControls.Label lblCurrentPageRecordCount;

        /// <summary>
        /// Label showing current page
        /// </summary>
		protected System.Web.UI.WebControls.Label lblPageCount;

        /// <summary>
        /// Comnbo box to jump to a specific page.
        /// </summary>
		protected System.Web.UI.WebControls.DropDownList cboPage;

        /// <summary>
        /// Next button
        /// </summary>
		protected System.Web.UI.WebControls.LinkButton btnNext;

        /// <summary>
        /// Previous button
        /// </summary>
		protected System.Web.UI.WebControls.LinkButton btnPrev;

        /// <summary>
        /// Table containing pagination
        /// </summary>
		protected System.Web.UI.HtmlControls.HtmlTable tblPagination;

        /// <summary>
        /// Page title
        /// </summary>
        protected System.Web.UI.WebControls.Label lblPageTitle;

        /// <summary>
        /// Reset button
        /// </summary>
        protected System.Web.UI.WebControls.Button btnReset;

        /// <summary>
        /// Link back to search criteria
        /// </summary>
        protected System.Web.UI.WebControls.LinkButton lnkReturnToSearchScreen;

        /// <summary>
        /// Table row containing pagination
        /// </summary>
		protected System.Web.UI.HtmlControls.HtmlTableRow trPagination;

        /// <summary>
        /// User control for report criteria
        /// </summary>
        protected Bdw.Application.Salt.Web.General.UserControls.ReportCriteria ucCriteria;

		#endregion

		#region Private Event Handlers
		/// <summary>
		/// 
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			lblPageTitle.Text =  ResourceManager.GetString("lblPageTitle");
			ucHelp.Attributes["Desc"] = ResourceManager.GetString("ucHelp");
			this.SetPageState();
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void lnkReturnToSearchScreen_Click(object sender, System.EventArgs e)
		{
			plhReportResults.Visible = false;
			plhSearchCriteria.Visible = true; 
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void btnGenerate_Click(object sender, System.EventArgs e)
		{
			StartPagination();
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

		private string strUnit;
		private string strModule;

		/// <summary>
		/// This even is trigged as the grid renders each row.
		/// </summary>
		/// <param name="source"></param>
		/// <param name="e"></param>
		private void dgrResults_ItemDataBound(object source, DataGridItemEventArgs e)
		{
			// Columns holding various fields.
			//int c_intColumnCourse = 0;
			int c_intColumnUnit = 0;
			int c_intColumnModule = 1;
			
			int c_intColumnPassMark = 3;
			int c_intColumnAvgMark = 4;
			if(e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.SelectedItem || e.Item.ItemType == ListItemType.EditItem)
			{
				Table tblPassMark;		// Table containing the Graphical Mark
				Table tblAvgMark;			// Table containing the Graphical Mark
				Label lblPassMark;		// Label containing the Textual Pass Mark
				Label lblAvgMark;			// Label containing the Textual Mark
				
				int intQuizPassMark;
				int intQuizAvgScore;	
				
				TableCellCollection tclCells = e.Item.Cells;

				// Show and hide the Module name
				if (tclCells[c_intColumnModule].Text != strModule)
				{
					// Capture the new Module name
					strModule = tclCells[c_intColumnModule].Text;
					tclCells[c_intColumnModule].CssClass="TableRow2";
				}
				else
				{
					// Hide the existing Module name
					tclCells[c_intColumnModule].Text = "";
					tclCells[c_intColumnModule].CssClass="TableRow1";
				}


				// Show and hide the Unit name
				if (tclCells[c_intColumnUnit].Text != strUnit)
				{
					// Capture the new Unit name
					strUnit = tclCells[c_intColumnUnit].Text;
					tclCells[c_intColumnUnit].CssClass="TableRow2";
					// Reshow the module name because we have just redraw the unit name
					tclCells[c_intColumnModule].CssClass="TableRow2";
					tclCells[c_intColumnModule].Text=strModule;
				}
				else
				{
					// Hide the existing Unit name
					tclCells[c_intColumnUnit].Text = "";
					tclCells[c_intColumnUnit].CssClass="TableRow1";
				}


				try
				{
					//Get the table which is in the fourth cell
					tblPassMark		= (Table)e.Item.Cells[c_intColumnPassMark].Controls[1];
					tblAvgMark		= (Table)e.Item.Cells[c_intColumnAvgMark].Controls[1];
					
					// Get the label that resides in it
					lblPassMark	= (Label)tblPassMark.Rows[0].Cells[0].Controls[0]; 
					lblAvgMark	= (Label)tblAvgMark.Rows[0].Cells[0].Controls[0]; 
					// Get the current DataRow from e
					DataRowView drwQuizAttempt = (DataRowView)e.Item.DataItem;
					
					
					// Draw the passmark graphically
					if (drwQuizAttempt["QuizPassMark"] == DBNull.Value)
					{
                        intQuizAvgScore=0;
                        lblAvgMark.Text = "N/A";                      
                        tblAvgMark.Rows[0].Cells[0].Attributes.Add ("class","BarChartNA"); 
                        tblAvgMark.Rows[0].Cells[1].Visible = false;
                        //tblPassMark.Visible=false;
					}
					else
					{
						// Get the Quiz pass mark from the QuizPassMark column
						intQuizPassMark = Int32.Parse(drwQuizAttempt["QuizPassMark"].ToString());

						// If the passmark is to be displayed as an expanding column use this line and add a colour style.
						//tblPassMark.Rows[0].Cells[0].Attributes.Add ("Width",intQuizPassMark.ToString() +"%");
                        // If the passmark is to be displayed as a static field set the width to a fixed % - 5% is good
                        tblPassMark.Rows[0].Cells[0].Attributes.Add ("Width","5%");

						// Column one is the barchar background
						lblPassMark.Text = intQuizPassMark.ToString() + "%";
					}

					// Draw the average score graphically
					if (drwQuizAttempt["AvgScore"] == DBNull.Value)
					{
                        intQuizAvgScore=0;
                        lblAvgMark.Text = "N/A";                      
                        tblAvgMark.Rows[0].Cells[0].Attributes.Add ("class","BarChartNA"); 
                        tblAvgMark.Rows[0].Cells[1].Visible = false;
                        //tblAvgMark.Visible=false;
					}
					else
					{
                        // Get the Average Quiz Pass Mark from the QuizScore column
                        intQuizPassMark = Int32.Parse(drwQuizAttempt["QuizPassMark"].ToString());
                        // Get the Average Quiz Score from the QuizScore column
                        intQuizAvgScore = Int32.Parse(drwQuizAttempt["AvgScore"].ToString());

                        if (intQuizAvgScore < 5)
                        {
                            tblAvgMark.Rows[0].Cells[0].Attributes.Add ("Width","5%");
                        }
                        else
                        {

                            // Get the Quiz Score from the QuizScore column
                            intQuizAvgScore = Int32.Parse(drwQuizAttempt["AvgScore"].ToString());
                            // The width of the TD is what gives the barchart like effect.
                            tblAvgMark.Rows[0].Cells[0].Attributes.Add ("Width",intQuizAvgScore.ToString() +"%");
                            if(intQuizAvgScore >= intQuizPassMark)
                            {
                                // green for pass
                                tblAvgMark.Rows[0].Cells[0].Attributes.Add ("class","BarChartPass");
                            }
                            else
                            {
                                // red for fail
                               tblAvgMark.Rows[0].Cells[0].Attributes.Add ("class","BarChartFail");             
                            }
                            // if the score was 100% then there is no need to have a spacer filling out the rest of the column
                            if(intQuizAvgScore == 100)
                            {
                                 tblAvgMark.Rows[0].Cells[1].Visible = false;
                            }
                            // Column one is the barchar background
                            lblAvgMark.Text = intQuizAvgScore.ToString() + "%";
                        }
					}
				}
				catch(Exception Ex)
				{
					ErrorLog Error = new ErrorHandler.ErrorLog(Ex,ErrorLevel.Medium,"TrendReport.aspx","dgrQuizHistory_ItemDataBound","Displaying Quiz Score");
					throw (Ex);
				}
			}
		}
		#endregion
		
		#region Private Methods
		/// <summary>
		/// 
		/// </summary>
		private void SetPageState()
		{
			lblError.Text="";
			if (!(this.IsPostBack ))
			{
				ConfigureParameterScreen();
			}
			
		}

		/// <summary>
		/// 
		/// </summary>
		private void ConfigureParameterScreen()
		{
			int intOrgID=UserContext.UserData.OrgID;
			
			Course objCourse = new Course();
			User objUser = new User();
			BusinessServices.Unit objUnit = new BusinessServices.Unit();
			string strUnits;

			// Courses
			DataTable dtbCourses = objCourse.GetCourseListAccessableToOrg(intOrgID);
			cboCourses.DataSource = dtbCourses;
			cboCourses.DataTextField = "Name";
			cboCourses.DataValueField ="CourseID";
			cboCourses.DataBind();
			if (cboCourses.Items.Count>0)  
			{		
				cboCourses.SelectedIndex=0;
			}
			else
			{
				this.plhSearchCriteria.Visible=false;
				this.lblError.Text+=ResourceManager.GetString("lblError.NoCourse");//"No courses exist within this organisation.";
				this.lblError.Visible=true;
			}
			
			// Units
			DataSet dstUnits = objUnit.GetUnitsTreeByUserID(UserContext.UserData.OrgID ,UserContext.UserID,'A');
			if (dstUnits.Tables[0].Rows.Count==0)  
			{		
				this.plhSearchCriteria.Visible=false;
				this.lblError.Text+=ResourceManager.GetString("lblError.NoUnit");//"No units exist within this organisation.";
				this.lblError.Visible=true;
			}
			else
			{
				if(trvUnitsSelector.HasControls())
				{
					this.trvUnitsSelector.ClearSelection();
				}
				strUnits = UnitTreeConvert.ConvertXml(dstUnits);
				if (strUnits=="")
				{
					this.trvUnitsSelector.Visible= false;
					this.lblNoSubUnits.Visible = true;
				}
				else
				{
					this.trvUnitsSelector.OutputStyle = Uws.Framework.WebControl.TreeOutputStyle.MultipleSelection;   
					this.trvUnitsSelector.Visible= true;
					this.lblNoSubUnits.Visible = false;
					this.trvUnitsSelector.LoadXml(strUnits);
				}
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
            this.dgrResults.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(this.dgrResults_ItemDataBound);

			dgrResults.Columns[0].HeaderText = ResourceManager.GetString("grid_Unit");
			dgrResults.Columns[1].HeaderText = ResourceManager.GetString("grid_Module");
			dgrResults.Columns[2].HeaderText = ResourceManager.GetString("grid_QuizCount");
			dgrResults.Columns[3].HeaderText = ResourceManager.GetString("grid_PassMark");
			dgrResults.Columns[4].HeaderText = ResourceManager.GetString("grid_Avg");

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
		/// <returns></returns>
		private DataView GetPaginationData()
		{
			// Customize, and return DataView
			// conduct search based on criteria
			Report objReport = new Report();
			
			string[] astrUnits;
			string strUnits;
			string strCourse;
			
            strCourse="";
            strUnits = "";
			DataTable dtbResults = new DataTable();
			this.lblError.Text="";
			this.lblError.Visible=false;
			try
			{
                BusinessServices.Unit objUnit = new  BusinessServices.Unit();
				astrUnits =  objUnit.ReturnAdministrableUnitsByUserID( UserContext.UserID, UserContext.UserData.OrgID, this.trvUnitsSelector.GetSelectedValues() );
				// Convert array back to a csv string.
				foreach(string strUnit in astrUnits)
				{
					strUnits += strUnit + ",";
				}
				if (astrUnits.Length > 0)
				{
					strUnits = strUnits.Substring(0,strUnits.Length-1);
				}
                else
                {
                    strUnits = null;
                }
				strCourse = cboCourses.SelectedValue;  
				if (strCourse.Length>0)
				{
					dtbResults = objReport.GetTrendReport (UserContext.UserData.OrgID, strUnits,Convert.ToInt32(strCourse));
					if (dtbResults.Rows.Count==0)
					{
						this.lblError.Text+=ResourceManager.GetString("lblError.NoUser");//"No users found";
						this.lblError.Visible=true;
					}
					else
					{
                        this.plhSearchCriteria.Visible = false; 
                        this.plhReportResults.Visible = true;

                        BusinessServices.User objUser = new BusinessServices.User();
                        DataTable dtbUser = objUser.GetUser(UserContext.UserID);
                        if (dtbUser.Rows.Count>0)
                        {
                            // Display Report Criteria
                            this.ucCriteria.Criteria.Add(ResourceManager.GetString("Reportrunby"),dtbUser.Rows[0]["LastName"].ToString()+ ", " + dtbUser.Rows[0]["FirstName"].ToString());
                            this.ucCriteria.Criteria.Add(ResourceManager.GetString("Reportrunat"),DateTime.Now.ToString("dd/MM/yyyy") + " " + DateTime.Now.ToLongTimeString());
                        }
                        if (trvUnitsSelector.GetSelectedValues().Length==0)
                        {
                            this.ucCriteria.AddUnits(null);
                        }
                        else
                        {
                            this.ucCriteria.AddUnits(strUnits);
                        }
                        this.ucCriteria.AddCourses(strCourse); 
                        this.ucCriteria.Render();

                        BusinessServices.Course objCourse = new Course();
                        DataTable dtbCourseDetails = objCourse.GetCourse(Int32.Parse(strCourse), UserContext.UserData.OrgID);
                        
                        this.lblPageTitle.Text = String.Format(ResourceManager.GetString("lblPageTitle.1"), dtbCourseDetails.Rows[0]["Name"].ToString());//"Trend Report - " + dtbCourseDetails.Rows[0]["Name"].ToString();
						plhSearchCriteria.Visible=false;
						plhReportResults.Visible=true;
						lblError.Visible=false;
					}
				}
				else
				{
					lblError.Visible=true;
					lblError.Text = ResourceManager.GetString("lblError.OnCourse");//"You must select at least one course.";
				}
					
				
			}
			catch(Exception Ex)
			{
				ErrorLog Error = new ErrorLog(Ex,ErrorLevel.Medium,"TrendReport.aspx","btnGenerate_Click","");
				throw (Ex);
			}
			return dtbResults.DefaultView;
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
			DataView  dvwPagination = this.GetPaginationData();

			if (dvwPagination.Table.Rows.Count > 0)
			{
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
				dgrResults.DataKeyField = "Course";
				dgrResults.DataSource = dvwPagination;
				dgrResults.PageSize = intPageSize;
				dgrResults.CurrentPageIndex = currentPageIndex;
				dgrResults.DataBind();
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
