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
using System.Configuration;
using System.IO; // remove later?

using Bdw.Application.Salt.InfoPath;
using Bdw.Application.Salt.Utilities;
using Microsoft.ApplicationBlocks.Data;
using Bdw.Application.Salt.ErrorHandler;
using System.Net;


namespace Bdw.Application.Salt.Web.Reporting.Individual
{
    /// <summary>
    /// Business logic and presentation logic for the individual report
    /// </summary>
    /// <remarks>
    /// Assumptions: None
    /// Notes: 
    /// Author: Stephen Kennedy-Clark, 15/02/04
    /// Changes:
    /// </remarks>
    public partial class IndividualReport : System.Web.UI.Page
    {
        protected Bdw.Application.Salt.Web.General.UserControls.Navigation.HelpLink ucHelp;
        /// <summary>
        /// Private member variable used to maintiain the course name across the page headings.
        /// </summary>
        private string strCourse;

        #region protected variables
        /// <summary>
        /// message lable
        /// </summary>
        protected System.Web.UI.WebControls.Label lblError;
        /// <summary>
        /// Moduel resultes data grid
        /// </summary>
        protected System.Web.UI.WebControls.DataGrid dgrResults;

        /// <summary>
        /// Label for total record count
        /// </summary>
        protected System.Web.UI.WebControls.Label lblTotalRecordCount;

        /// <summary>
        /// Label for number of records on current page
        /// </summary>
        protected System.Web.UI.WebControls.Label lblCurrentPageRecordCount;

        /// <summary>
        /// Label for total number of pages.
        /// </summary>
        protected System.Web.UI.WebControls.Label lblPageCount;

        /// <summary>
        /// Combo box to select page to jump to
        /// </summary>
        protected System.Web.UI.WebControls.DropDownList cboPage;

        /// <summary>
        /// Table surrounding pagination
        /// </summary>
        protected System.Web.UI.HtmlControls.HtmlTable tblPagination;

        /// <summary>
        /// Table row surrounding pagination
        /// </summary>
        protected System.Web.UI.HtmlControls.HtmlTableRow trPagination;
        #endregion

        #region Private Event Handlers
        /// <summary>
        /// Page Load
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen K-Clark, 15/02/04
        /// Changes:
        /// </remarks>
        protected void Page_Load(object sender, System.EventArgs e)
        {
            pagTitle.InnerText = ResourceManager.GetString("pagTitle");
            ucHelp.Attributes["Desc"] = ResourceManager.GetString("ucHelp");
            if (!IsPostBack)
            {
                StartPagination();
                // Madhuri CPD Event Start
                StartEventPagination();
                // Madhuri CPD Event End
                //GetTotals();
            }
        } //Page_Load

        private void dgrResults_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            // Colmns in the datagrid for specific values
            int c_intColumnCourse = 0;
            int c_intColumnHyperlink = 1;
            int c_intColumnQuizStatus = 3;
            int c_intColumnModule = 6;
            HyperLink hl = new HyperLink();
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                // Table cell collection of all cells
                TableCellCollection tclCells = e.Item.Cells;
                // Show and hide the Course name
                if (tclCells[c_intColumnCourse].Text != strCourse)
                {
                    // Capture the new Course name
                    strCourse = tclCells[c_intColumnCourse].Text;
                    tclCells[c_intColumnCourse].CssClass = "TableRow2Selected";
                }
                else
                {
                    // Hide the existing Course name
                    tclCells[c_intColumnCourse].Text = "";
                    tclCells[c_intColumnCourse].CssClass = "TableRow1";
                }

                // Adjust the Hyperlink for rows that dont have a mark.
                if (tclCells[c_intColumnQuizStatus].Text == "Not Started")
                {
                    tclCells[c_intColumnHyperlink].Text = tclCells[c_intColumnModule].Text;
                }


                for (int i = 8; i < tclCells.Count; i++)// 8 onwards are the auto generated columns in the grid
                {
                    hl = (HyperLink)tclCells[i].Controls[0];// get the hyperlink
                    tclCells[i].Controls.Remove(tclCells[i].Controls[0]);

                    // if its a hyperlink colum or if there is history for the module
                    if (hl.NavigateUrl != "" && hl.Text != "0")
                    {
                        if (hl.Text == "-1")
                        {
                            //tclCells[i].Text="0";
                            hl.Text = "0";
                        }

                        hl.NavigateUrl += tclCells[c_intColumnModule + 1].Text;
                        tclCells[i].Controls.Add(hl);
                    }
                    else // id column or no points  & no history
                    {
                        tclCells[i].Text = "0";
                    }
                }
            }
            if (e.Item.ItemType == ListItemType.Footer)
            {
                Profile pf = new Profile();
                DataView dt = new DataView();

                dt = pf.GetTotalCurrentPointsForProfile(UserContext.UserID);
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
                            hl = new HyperLink();
                            hl.NavigateUrl = "/Reporting/Individual/CPDHistory.aspx?ProfileID=" + dr1[i + 1];
                            hl.Text = dr1[i] + "<BR><B>" + dr1[i + 2] + "</B>";
                            e.Item.Cells[j].Controls.Add(hl);
                            j += 2;
                        }

                    }
                }// end if
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

            //Madhuri CPD Event Start	
            dgrEvent.Columns[0].HeaderText = ResourceManager.GetString("grid_Eventname");
            dgrEvent.Columns[1].HeaderText = ResourceManager.GetString("grid_EventItem");
            dgrEvent.Columns[2].HeaderText = ResourceManager.GetString("grid_FileStatus");
            dgrEvent.Columns[3].HeaderText = ResourceManager.GetString("grid_Points");
            //Madhuri CPD Event End
        }


        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.dgrResults.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(this.dgrResults_ItemDataBound);
            //Madhuri CPD Event Start	
            this.dgrEvent.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(this.dgrEvent_ItemDataBound);
            //Madhuri CPD Event End
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
        private void StartEventPagination()
        {

            this.tblEventPagination.Visible = true;


            this.ShowEventPagination(0);

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
                odtReport = objReport.GetIndividualReport(UserContext.UserID);   // report data    
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
            this.ShowEventPagination(this.dgrEvent.CurrentPageIndex);
        }

        /// <summary>
        /// Go to next page.
        /// </summary>
        protected void btnNext_Click(object sender, System.EventArgs e)
        {
            this.ShowPagination(this.dgrResults.CurrentPageIndex + 1);
            this.ShowEventPagination(this.dgrEvent.CurrentPageIndex);
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
            dgrResults.PageSize = intPageSize;
            dgrResults.CurrentPageIndex = currentPageIndex;
            dgrResults.DataBind();
            // do this for all the new columns we just added
            dgrResults.ItemStyle.CssClass = dgrResults.Columns[5].ItemStyle.CssClass;
        }
        private DataGridColumn CreateBoundColumn(DataColumn c)
        {
            string strUserID = UserContext.UserID.ToString();
            string strColName = c.ColumnName;
            HyperLinkColumn col = new HyperLinkColumn();

            col.DataTextField = strColName;
            col.HeaderText = strColName;
            //col.FooterText ="test<BR>test" ;

            ///*
            if (strColName.Length < 3) // Need to perform this check because if the column name happens to be 2 characters then will cause a system error - if < 2 char then can assume that not an "ID~" column
            {
                col.DataNavigateUrlField = c.ColumnName + "ID~";
                col.DataNavigateUrlFormatString = "/Reporting/Individual/CPDHistory.aspx?ProfileID={0}&ModuleID=";
            }
            else if (strColName.Substring(strColName.Length - 3, 3) != "ID~")
            {
                // if it is the id column (determined by the last 3 idiotic characters) then hideit and also dont set the url stuff
                col.DataNavigateUrlField = c.ColumnName + "ID~";
                col.DataNavigateUrlFormatString = "/Reporting/Individual/CPDHistory.aspx?ProfileID={0}&ModuleID=";
            }
            else
            //
            //if (strColName.Substring(strColName.Length-3,3)!="ID~")
            {
                col.Visible = false;
            }
            return col;
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
        #endregion

        #region EventReport
        // Madhuri CPD Event Start
        private void ShowEventPagination(int currentEventPageIndex)
        {
            try
            {
                Organisation objOrganisation = new Organisation();
                this.tdevent.Visible = objOrganisation.GetOrganisationCPDEventAccess(UserContext.UserData.OrgID);


                HtmlTableRow trEventPagination = FindControl("trEventPagination") as HtmlTableRow;

                //1. Get data
                DataSet dtbEventIndividual = this.GetEventPaginationData();
                DataView dvwEventPagination = dtbEventIndividual.Tables[0].DefaultView;

                if (dvwEventPagination.Table.Rows.Count == 0)
                {
                    this.lblEventError.Text = ResourceManager.GetString("lblEventError.NoEvents");//"No users found.";
                    this.lblEventError.CssClass = "FeedbackMessage";
                    dgrEvent.Visible = false;
                    btnExportpdf.Visible = false;
                    lblCPDEventProfile.Visible = false;
                    btnExportpdf.Visible = false;
                    lblEventError.Visible = false;
                }
                else
                {
                    dgrEvent.Visible = true;
                    btnExportpdf.Visible = true;
                    lblCPDEventProfile.Visible = true;
                    btnExportpdf.Visible = true;
                    lblEventError.Visible = true;
                }
                if (dvwEventPagination.Count <= ApplicationSettings.PageSize)
                {
                    trEventPagination.Visible = false;
                }
                else
                {
                    trEventPagination.Visible = true;
                }

                if (dvwEventPagination.Count == 0)
                {
                    this.trEventPagination.Visible = false;
                }

                //2. Set pagination panel
                int intEventPageSize;
                intEventPageSize = ApplicationSettings.PageSize;
                this.SetEventPaginationPanel(intEventPageSize, dvwEventPagination.Count, currentEventPageIndex);

                //3. Bind Data
                // add columns as required for the profiles & points

                int colCount = dtbEventIndividual.Tables[0].Columns.Count;

                for (int i = 11; i < colCount; i++)
                {

                    string strUserID = UserContext.UserID.ToString();
                    string strColName = dtbEventIndividual.Tables[0].Columns[i].ToString();

                    BoundColumn test = new BoundColumn();
                    test.DataField = strColName;
                    test.HeaderText = strColName;

                    if (strColName.Substring(strColName.Length - 3, 3) == "ID~")
                    {
                        test.Visible = false;
                    }
                    test.ItemStyle.CssClass = "tablerow2";
                    dgrEvent.Columns.Add(test);

                }
                if (dvwEventPagination.Table.Rows.Count > 0)
                {
                    dgrEvent.DataKeyField = "EventPeriodID";
                    dgrEvent.DataSource = dvwEventPagination;
                    dgrEvent.PageSize = intEventPageSize;
                    dgrEvent.CurrentPageIndex = currentEventPageIndex;
                    dgrEvent.DataBind();
                }
            }

            catch (Exception Ex)
            {
                ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(Ex, ErrorLevel.Medium, "IndividualReport.aspx.cs", "ShowEventPagination()", "Binding Data to Datagrid");
                throw (Ex);
            }
        }
        private DataSet GetEventPaginationData()
        {

            try
            {
                Event objEvent = new Event();
                DataSet odtReport = new DataSet();

                odtReport = objEvent.GetUserEventReportNew(UserContext.UserID, UserContext.UserData.OrgID);
                if (odtReport.Tables[0].Rows.Count == 0)
                {
                    this.lblEventError.Text += "No results found.";
                    this.lblEventError.CssClass = "FeedbackMessage";
                }
                return odtReport;
            }

            catch (Exception Ex)
            {
                ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(Ex, ErrorLevel.Medium, "IndividualReport.aspx.cs", "GetEventPaginationData()", "Binding Data to Datagrid");
                throw (Ex);
            }



        }
        private void SetEventPaginationPanel(int pageSize, int totalRecordCount, int currentPageIndex)
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
                this.cboEventPage.Items.Clear();
                for (int i = 1; i <= intPageCount; i++)
                {
                    objItem = new ListItem(i.ToString());
                    if (i == currentPageIndex + 1)
                    {
                        objItem.Selected = true;
                    }
                    this.cboEventPage.Items.Add(objItem);
                }

                //2.2 Set Page numbers
                this.lblEventPageCount.Text = intPageCount.ToString();
                this.lblEventCurrentPageRecordCount.Text = intCurrentPageStart.ToString() + " - " + intCurrentPageEnd.ToString();
                this.lblEventTotalRecordCount.Text = intTotalRecordCount.ToString();

                //2.3 Disable prev, next buttons
                this.btnEventPrev.Enabled = true;
                this.btnEventNext.Enabled = true;
                //First Page
                if (currentPageIndex == 0)
                {
                    this.btnEventPrev.Enabled = false;
                }
                //Last Page
                if (currentPageIndex == intPageCount - 1)
                {
                    this.btnEventNext.Enabled = false;
                }
            }

            catch (Exception Ex)
            {
                ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(Ex, ErrorLevel.Medium, "IndividualReport.aspx.cs", "SetEventPaginationPanel()", "Binding Data to Datagrid");
                throw (Ex);
            }
        }
        protected void btnEventPrev_Click(object sender, System.EventArgs e)
        {

            this.ShowPagination(this.dgrResults.CurrentPageIndex);
            this.ShowEventPagination(this.dgrEvent.CurrentPageIndex - 1);
        }
        protected void btnEventNext_Click(object sender, System.EventArgs e)
        {

            this.ShowPagination(this.dgrResults.CurrentPageIndex);
            this.ShowEventPagination(this.dgrEvent.CurrentPageIndex + 1);
        }
        protected void cboEventPage_SelectedIndexChanged(object sender, System.EventArgs e)
        {
            int intPageIndex;
            intPageIndex = int.Parse(this.cboEventPage.SelectedValue);
            this.ShowEventPagination(intPageIndex - 1);
        }
        void dgrEvent_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            try
            {
                Label hl = new Label();
                // Colmns in the datagrid for specific values

                //int c_intColumnCourse = 0;
                if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
                {

                    TableCellCollection tclCells = e.Item.Cells;

                    if (tclCells[0].Text != strCourse)
                    {
                        // Capture the new Course name
                        strCourse = tclCells[0].Text;
                        tclCells[0].CssClass = "tablerow2Selected";

                    }
                    else
                    {
                        // Hide the existing Course name
                        tclCells[0].Text = "";
                    }
                }
                if (e.Item.ItemType == ListItemType.Footer)
                {

                    Profile pf = new Profile();
                    DataSet ds = new DataSet();
                    Event objEvent = new Event();

                    ds = objEvent.GetUserEventReportNew(UserContext.UserID, UserContext.UserData.OrgID);   // report data   
                    DataRow dr1 = ds.Tables[1].Rows[0];

                    e.Item.Cells[3].Text = ResourceManager.GetString("totals") + ":<BR><B>" + ResourceManager.GetString("shortfall") + ":</B>";

                    // add columns as required for the profiles & points
                    int colCount = ds.Tables[1].Columns.Count;
                    string strColName;

                    if (colCount > 1)// user has cpd access?
                    {

                        int j = 6;

                        for (int i = 1; i < colCount - 1; i += 3)// 0index 
                        {
                            bool addHl = false;
                            strColName = ds.Tables[1].Columns[i].ColumnName;
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
                                hl = new Label();
                                hl.Text = dr1[i] + "<BR><B>" + dr1[i + 2] + "</B>";
                                e.Item.Cells[j].Controls.Add(hl);
                                j += 2;
                            }

                        }
                    }// end if
                }
            }

            catch (Exception Ex)
            {
                ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(Ex, ErrorLevel.Medium, "IndividualReport.aspx.cs", "dgrEvent_ItemDataBound", "Binding Data to Datagrid");
                throw (Ex);
            }
        }
        protected void btnExportpdf_Click(object sender, EventArgs e)
        {

            try
            {
                //UserContext.UserID, UserContext.UserData.OrgID
                BusinessServices.User objUser = new BusinessServices.User();
                DataTable dtUser = objUser.GetUser(UserContext.UserID);

                string username = dtUser.Rows[0]["UserName"].ToString();
                string strHostname = HttpContext.Current.Request.Url.Authority.ToString();

                string strUrl = null;
                if (strHostname.ToLower().Equals("127.0.0.2"))
                {
                    strUrl = "https://" + strHostname;

                }
                else
                {
                    strUrl = "http://" + strHostname;
                }
                strUrl = "https://" + strHostname;
                // strUrl = "http://" + strHostname; --use http for demosite
              
                string pdfFileName = "CPDEvent_" + username + "_" + DateTime.Now.ToString("yyyyMMddHHmmss") + ".pdf";
                //bool status = HtmlToPdf.WKHtmlToPdf(strUrl + @"/Reporting/Individual/ExportCPDEventReport.aspx", pdfFileName);

                //WebClient client = new WebClient();
                //String htmlCode = client.DownloadString(strUrl + @"/Reporting/Individual/ExportCPDEventReport.aspx?UserId=" + UserContext.UserID + "&OrgID=" + UserContext.UserData.OrgID);
                ////Session["htmlContent"] = htmlCode;
                //Globals.MyGlobalValue = "";
                //Globals.MyGlobalValue = htmlCode;
                //bool status = HtmlToPdf.WKHtmlToPdf(strUrl + @"/Reporting/Individual/TestCPD.aspx", pdfFileName);
                bool status = HtmlToPdf.WKHtmlToPdf(strUrl + @"/Reporting/Individual/ExportCPDEventReport.aspx?UserId=" + UserContext.UserID + "&OrgID=" + UserContext.UserData.OrgID, pdfFileName); 


                string filename = "";

                if (status)
                {
                    filename = HttpContext.Current.Server.MapPath(ConfigurationSettings.AppSettings["WorkingFolder"]) + "\\" + pdfFileName;
                }
                else
                {
                    ErrorLog objError = new ErrorLog(new Exception("Export to PDF"), ErrorLevel.Medium, "IndividualReport.cs", "ExportCPDEventReport", "Export PDF generation failed: " + pdfFileName);
                }


                FileInfo fileInfo = new FileInfo(filename);
                try
                {
                    if (fileInfo.Exists)
                    {
                        Response.Clear();
                        Response.Buffer = true;
                        Response.ClearHeaders();
                        Response.ContentType = "application/pdf";
                        Response.AddHeader("Content-Disposition", "attachment; filename=" + pdfFileName + "");
                        Response.TransmitFile(Server.MapPath("~/General/wkhtmltopdf/" + pdfFileName));
                        Response.Flush();
                    }



                    try
                    {
                        FileInfo fileinfo = new FileInfo(filename);
                        if (fileinfo.Exists)
                            File.Delete(filename);
                    }
                    catch (Exception ex)
                    {
                        ErrorLog objError = new ErrorLog(new Exception("Export to PDF"), ErrorLevel.Medium, "IndividualReport.cs", "ExportCPDEventReport", "Delete cpd event PDF  failed: " + pdfFileName);
                    } 
                }
                catch (Exception ex)
                {

                }


            }

            catch (Exception Ex)
            {
                ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(Ex, ErrorLevel.Medium, "IndividualReport.aspx.cs", "btnExportpdf_Click", "Export to PDF");
                throw (Ex);
            }

        }
        protected void btnCPDExportpdf_Click(object sender, EventArgs e)
        {
            try
            {
                BusinessServices.User objUser = new BusinessServices.User();
                DataTable dtUser = objUser.GetUser(UserContext.UserID);

                string username = dtUser.Rows[0]["UserName"].ToString();
                string strHostname = HttpContext.Current.Request.Url.Authority.ToString();

                string strUrl = null;
                if (strHostname.ToLower().Equals("127.0.0.2"))
                {
                    strUrl = "https://" + strHostname;

                }
                else
                {
                    strUrl = "http://" + strHostname;
                }
                strUrl = "https://" + strHostname;
               // strUrl = "http://" + strHostname; --use http for demosite
                string pdfFileName = "PersonalReport_" + username + "_" + DateTime.Now.ToString("yyyyMMddHHmmss") + ".pdf";

              

                //bool status = HtmlToPdf.WKHtmlToPdf(strUrl + @"/Reporting/Individual/TestCPD.aspx", pdfFileName);
                //WebClient client = new WebClient();
                //String htmlCode = client.DownloadString(strUrl + @"/Reporting/Individual/ExportCPDProfileReport.aspx");
                ////Session["htmlContent"] = htmlCode;
                //Globals.MyGlobalValue = "";
                //Globals.MyGlobalValue = htmlCode;
                //bool status = HtmlToPdf.WKHtmlToPdf(strUrl + @"/Reporting/Individual/TestCPD.aspx", pdfFileName);
                //bool status = HtmlToPdf.WKHtmlToPdf(strUrl + @"/Reporting/Individual/TestCPD.aspx", pdfFileName);
                //bool status = HtmlToPdf.WKHtmlToPdf(@"http://demo.saltcompliance.com/Reporting/Individual/TestCPD.aspx", pdfFileName);
                bool status = HtmlToPdf.WKHtmlToPdf(strUrl + @"/Reporting/Individual/ExportCPDProfileReport.aspx?UserId=" + UserContext.UserID + "&OrgID=" + UserContext.UserData.OrgID, pdfFileName); 
                string filename = "";

                if (status)
                {
                    filename = HttpContext.Current.Server.MapPath(ConfigurationSettings.AppSettings["WorkingFolder"]) + "\\" + pdfFileName;
                }
                else
                {
                    ErrorLog objError = new ErrorLog(new Exception("Export to PDF"), ErrorLevel.Medium, "IndividualReport.cs", "btnCPDExportpdf_Click", "Export to PDF generation failed: " + pdfFileName);
                }

                FileInfo fileInfo = new FileInfo(filename);
                try
                {
                    if (fileInfo.Exists)
                    {
                        Response.Clear();
                        Response.Buffer = true;
                        Response.ClearHeaders();
                        Response.ContentType = "application/pdf";
                        Response.AddHeader("Content-Disposition", "attachment; filename=" + pdfFileName + "");
                        Response.TransmitFile(Server.MapPath("~/General/wkhtmltopdf/" + pdfFileName));
                        Response.Flush();
                    }
                    try
                    {
                        FileInfo fileinfo = new FileInfo(filename);
                        if (fileinfo.Exists)
                            File.Delete(filename);
                    }
                    catch (Exception ex)
                    {
                        ErrorLog objError = new ErrorLog(new Exception("Export to PDF"), ErrorLevel.Medium, "IndividualReport.cs", "btnCPDExportpdf_Click", "Delete Personal Report PDF  failed: " + pdfFileName);
                    } 
                }
                catch (Exception ex)
                {

                }
            }

            catch (Exception Ex)
            {
                ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(Ex, ErrorLevel.Medium, "IndividualReport.cs", "btnCPDExportpdf_Click", "Export to PDF");
                throw (Ex);
            }

        }
        // Madhuri CPD Event End
        #endregion
       
    }
    public static class Globals
    {
        public static string MyGlobalValue;
    }
}
