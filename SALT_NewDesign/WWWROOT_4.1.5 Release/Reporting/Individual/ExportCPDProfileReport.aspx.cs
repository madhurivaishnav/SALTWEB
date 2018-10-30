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
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.BusinessServices;
using Localization;

using System.Diagnostics;
using System.IO;
using System.Configuration;
using Bdw.Application.Salt.InfoPath;
using Bdw.Application.Salt.Utilities;
using Microsoft.ApplicationBlocks.Data;
using Bdw.Application.Salt.ErrorHandler;
namespace Bdw.Application.Salt.Web.Reporting.Individual
{
    public partial class ExportCPDProfileReport : System.Web.UI.Page
    {
        protected Bdw.Application.Salt.Web.General.UserControls.Navigation.HelpLink ucHelp;

        private string strCourse;

        #region protected variables

        protected System.Web.UI.WebControls.Label lblError;

        protected System.Web.UI.WebControls.DataGrid dgrResults;




        protected System.Web.UI.WebControls.Label lblTotalRecordCount;


        protected System.Web.UI.WebControls.Label lblCurrentPageRecordCount;


        protected System.Web.UI.WebControls.Label lblPageCount;


        protected System.Web.UI.WebControls.DropDownList cboPage;


        protected System.Web.UI.HtmlControls.HtmlTable tblPagination;


        protected System.Web.UI.HtmlControls.HtmlTableRow trPagination;
        #endregion

        #region Private Event Handlers
        public int UserId;
        public int OrganisationId;
        protected void Page_Load(object sender, System.EventArgs e)
        {
            pagTitle.InnerText = ResourceManager.GetString("pagTitle");
            //ucHelp.Attributes["Desc"] = ResourceManager.GetString("ucHelp");
            if (!IsPostBack)
            {
               // UserId = Convert.ToInt32(Request.QueryString["UserId"]);
               // OrganisationId = Convert.ToInt32(Request.QueryString["OrgID"]);
                if (HttpContext.Current.User.Identity.Name != "")
                {
                    UserId = UserContext.UserID;
                    OrganisationId = UserContext.UserData.OrgID;
                }
                else
                {
                    UserId = int.Parse(Request.QueryString["userid"].ToString());
                    OrganisationId = int.Parse(Request.QueryString["orgid"].ToString());
                }
                StartPagination();

            }
        } //Page_Load

        private void dgrResults_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            try
            {
                // Colmns in the datagrid for specific values
                int c_intColumnCourse = 0;
                int c_intColumnHyperlink = 1;
                int c_intColumnQuizStatus = 3;
                int c_intColumnModule = 6;
                Label hl = new Label();

                if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
                {
                    // Table cell collection of all cells
                    TableCellCollection tclCells = e.Item.Cells;

                    // Show and hide the Course name
                    if (tclCells[c_intColumnCourse].Text != strCourse)
                    {
                        // Capture the new Course name
                        strCourse = tclCells[c_intColumnCourse].Text;
                        tclCells[c_intColumnCourse].CssClass = "tablerow2Selected";
                    }
                    else
                    {
                        // Hide the existing Course name
                        tclCells[c_intColumnCourse].Text = "";
                        tclCells[c_intColumnCourse].CssClass = "tablerow1";
                    }

                    // Adjust the Hyperlink for rows that dont have a mark.
                    if (tclCells[c_intColumnQuizStatus].Text == "Not Started")
                    {
                        tclCells[c_intColumnHyperlink].Text = tclCells[c_intColumnModule].Text;
                    }


                    //for (int i = 8; i < tclCells.Count; i++)// 8 onwards are the auto generated columns in the grid
                    //{
                    //    hl = (Label)tclCells[i].Controls[0];// get the hyperlink
                    //    tclCells[i].Controls.Remove(tclCells[i].Controls[0]);

                    //    // if its a hyperlink colum or if there is history for the module
                    //    if (hl.Text != "" && hl.Text != "0")
                    //    {
                    //        if (hl.Text == "-1")
                    //        {
                    //            //tclCells[i].Text="0";
                    //            hl.Text = "0";

                    //        }

                    //        hl.NavigateUrl += tclCells[c_intColumnModule + 1].Text;
                    //        tclCells[i].Controls.Add(hl);
                    //    }
                    //    else // id column or no points  & no history
                    //    {
                    //        tclCells[i].Text = "0";
                    //    }
                    //}
                }
                if (e.Item.ItemType == ListItemType.Footer)
                {

                    Profile pf = new Profile();
                    DataView dt = new DataView();

                    //dt = pf.GetTotalCurrentPointsForProfile(UserContext.UserID);
                    dt = pf.GetTotalCurrentPointsForProfile(UserId);
                    DataRow dr1 = dt.Table.Rows[0];

                    // add columns as required for the profiles & points
                    int colCount = dt.Table.Columns.Count;
                    string strColName;

                    if (colCount > 1)// user has cpd access?
                    {
                        e.Item.Cells[5].Text = ResourceManager.GetString("totals") + ":<BR><B>" + ResourceManager.GetString("shortfall") + ":</B>";
                        int j = 8;

                        for (int i = 1; i < colCount - 1; i += 3)// 0index 
                        {
                            bool addHl = false;
                            strColName = dt.Table.Columns[i].ColumnName;
                            if (strColName.Length < 3)
                            {
                                addHl = true;
                            }
                            else if (strColName.Substring(strColName.Length - 3, 3) != "ID~")
                            {
                                addHl = true;
                            }

                            if (addHl)
                            {
                                Label Ll = new Label();
                                //hl.NavigateUrl = "/Reporting/Individual/CPDHistory.aspx?ProfileID=" + dr1[i + 1];
                                Ll.Text = dr1[i] + "<BR><B>" + dr1[i + 2] + "</B>";
                                e.Item.Cells[j].Controls.Add(Ll);
                                j += 2;
                            }

                        }
                    }// end if
                }
            }
            catch (Exception Ex)
            {
                ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(Ex, ErrorLevel.Medium, "ExportCPDProfileReport.aspx.cs", "dgrResults_ItemDataBound", "Binding Data to Datagrid");
                throw (Ex);
            }
        } // dgrResults_ItemDataBound

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
            dgrResults.Columns[0].HeaderText = ResourceManager.GetString("grid_Course");
            dgrResults.Columns[1].HeaderText = ResourceManager.GetString("grid_Module");
            dgrResults.Columns[2].HeaderText = ResourceManager.GetString("grid_LessonStatus");
            dgrResults.Columns[3].HeaderText = ResourceManager.GetString("grid_QuizStatus");
            dgrResults.Columns[4].HeaderText = ResourceManager.GetString("grid_QuizScore");
            dgrResults.Columns[5].HeaderText = ResourceManager.GetString("grid_QuizPassMark");


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
        private DataTable GetPaginationData()
        {
            // Customize, and return DataView
            // conduct search based on criteria
            Report objReport = new Report();
            DataTable odtReport = new DataTable();


            try
            {
                //odtReport = objReport.GetIndividualReport(UserContext.UserID);   // report data    
                odtReport = objReport.GetIndividualReport(UserId);   // report data    
                if (odtReport.Rows.Count == 0)
                {
                    this.lblError.Text += "No results found.";
                    this.lblError.CssClass = "FeedbackMessage";
                }

            }

            catch (Exception Ex)
            {
                ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(Ex, ErrorLevel.Medium, "IndividualReport.aspx.cs", "GetPaginationData()", "Binding Data to Datagrid");
                throw (Ex);
            }


            return odtReport;
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
            try
            {
                //1. Get data
                DataTable dtbIndividual = this.GetPaginationData();
                DataView dvwPagination = dtbIndividual.DefaultView;

                if (dvwPagination.Table.Rows.Count == 0)
                {
                    this.lblError.Text = ResourceManager.GetString("lblError.NoUsers");//"No users found.";
                    this.lblError.CssClass = "FeedbackMessage";
                }
                if (dvwPagination.Count <= ApplicationSettings.PageSize)
                {
                    this.trPagination.Visible = false;
                }
                else
                {
                    this.trPagination.Visible = true;
                }

                if (dvwPagination.Count == 0)
                {
                    this.tblPagination.Visible = false;
                }

                //3. Set pagination panel
                int intPageSize;
                intPageSize = ApplicationSettings.PageSize;
                this.SetPaginationPanel(intPageSize, dvwPagination.Count, currentPageIndex);

                //4. Bind Data
                // add columns as required for the profiles & points

                int colCount = dtbIndividual.Columns.Count;


                for (int i = 11; i < colCount; i++)// 0index //11th column of the data set not of the grid!!!
                {
                    dgrResults.Columns.Add(CreateBoundColumn(dtbIndividual.Columns[i]));
                }

                //5. Set the Key field for the DataGrid
                dgrResults.DataKeyField = "UserID";
                dgrResults.DataSource = dvwPagination;
                //dgrResults.PageSize = intPageSize;
                //dgrResults.CurrentPageIndex = currentPageIndex;
                dgrResults.DataBind();
                // do this for all the new columns we just added
                dgrResults.ItemStyle.CssClass = dgrResults.Columns[5].ItemStyle.CssClass;
            }
            catch (Exception Ex)
            {
                ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(Ex, ErrorLevel.Medium, "ExportCPDProfileReport.aspx.cs", "ShowPagination()", "Binding Data to Datagrid");
                throw (Ex);
            }
        }


        private DataGridColumn CreateBoundColumn(DataColumn c)
        {
            try
            {
                //string strUserID = UserContext.UserID.ToString();
                string strUserID = UserId.ToString();
                string strColName = c.ColumnName;




                BoundColumn col = new BoundColumn();

                col.DataField = strColName;
                col.HeaderText = strColName;
                //col.FooterText ="test<BR>test" ;

                ///*
                //if (strColName.Length < 3) // Need to perform this check because if the column name happens to be 2 characters then will cause a system error - if < 2 char then can assume that not an "ID~" column
                //{
                //    col.DataNavigateUrlField = c.ColumnName + "ID~";
                //    col.DataNavigateUrlFormatString = "/Reporting/Individual/CPDHistory.aspx?ProfileID={0}&ModuleID=";
                //}
                //else if (strColName.Substring(strColName.Length - 3, 3) != "ID~")
                //{
                //    // if it is the id column (determined by the last 3 idiotic characters) then hideit and also dont set the url stuff
                //    col.DataNavigateUrlField = c.ColumnName + "ID~";
                //    col.DataNavigateUrlFormatString = "/Reporting/Individual/CPDHistory.aspx?ProfileID={0}&ModuleID=";
                //}
                //else
                ////
                if (strColName.Contains("ID~")) 
                {
                    col.Visible = false;
                }
                return col;
            }
            catch (Exception Ex)
            {
                ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(Ex, ErrorLevel.Medium, "ExportCPDProfileReport.aspx.cs", "CreateBoundColumn()", "Binding Data to Datagrid");
                throw (Ex);
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
            try
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
                if (intTotalRecordCount != 0)
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
                    intCurrentPageEnd = intPageSize * (currentPageIndex + 1);
                }
                //Last page, the page record count is the remaining records
                else
                {
                    intCurrentPageEnd = intTotalRecordCount;
                }
                //2. Set  pagination
                //2.1 Set dropdown page selector
                this.cboPage.Items.Clear();
                for (int i = 1; i <= intPageCount; i++)
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
                this.lblCurrentPageRecordCount.Text = intCurrentPageStart.ToString() + " - " + intCurrentPageEnd.ToString();
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
            catch (Exception Ex)
            {
                ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(Ex, ErrorLevel.Medium, "ExportCPDProfileReport.aspx.cs", "SetPaginationPanel()", "Binding Data to Datagrid");
                throw (Ex);
            }
        }
        #endregion



    }
}
