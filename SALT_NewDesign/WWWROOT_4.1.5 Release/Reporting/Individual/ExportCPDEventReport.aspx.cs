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
using System.IO;

using Bdw.Application.Salt.InfoPath;
using Bdw.Application.Salt.Utilities;
using Microsoft.ApplicationBlocks.Data;
using Bdw.Application.Salt.ErrorHandler;


namespace Bdw.Application.Salt.Web.Reporting.Individual
{
    public partial class ExportCPDEventReport : System.Web.UI.Page
    {

        private string strCourse;
        public int UserId;
        public int OrganisationId;
        protected void Page_Load(object sender, EventArgs e)
        {
            
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
                    UserId = int.Parse(Request.QueryString["UserId"].ToString());
                    OrganisationId = int.Parse(Request.QueryString["OrgID"].ToString());
                }

                StartPagination();
                //DataSet dtbEventIndividual = this.GetEventPaginationData();
                //dgrEvent.DataKeyField = "EventPeriodID";
                //dgrEvent.DataSource = dtbEventIndividual;
                ////dgrEvent.PageSize = intEventPageSize;
                ////dgrEvent.CurrentPageIndex = currentEventPageIndex;
                //dgrEvent.DataBind();
            }
        }
        override protected void OnInit(EventArgs e)
        {
            //
            // CODEGEN: This call is required by the ASP.NET Web Form Designer.
            //
            InitializeComponent();
            base.OnInit(e);
        }
        private void InitializeComponent()
        {
            this.dgrEvent.ItemDataBound += new DataGridItemEventHandler(dgrEvent_ItemDataBound);

        }
        private void StartPagination()
        {
            try
            {
                this.ShowEventPagination(0);
            }
            catch (Exception Ex)
            {
                ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(Ex, ErrorLevel.Medium, "ExportCPDEventReport.aspx.cs", "StartPagination()", "Binding Data to Datagrid");
                throw (Ex);
            }
        }

        private void ShowEventPagination(int currentEventPageIndex)
        {
            try
            {
                HtmlTableRow trEventPagination = FindControl("trEventPagination") as HtmlTableRow;

                //1. Get data
                DataSet dtbEventIndividual = this.GetEventPaginationData();
                DataView dvwEventPagination = dtbEventIndividual.Tables[0].DefaultView;

                if (dvwEventPagination.Table.Rows.Count == 0)
                {
                    this.lblError.Text = ResourceManager.GetString("lblError.NoUsers");//"No users found.";
                    this.lblError.CssClass = "FeedbackMessage";
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
                    //string strUserID = UserContext.UserID.ToString();
                    string strUserID = UserId.ToString();
                    //string strUserID = "1381";
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

                dgrEvent.DataKeyField = "EventPeriodID";
                dgrEvent.DataSource = dvwEventPagination;
                //dgrEvent.PageSize = intEventPageSize;
                //dgrEvent.CurrentPageIndex = currentEventPageIndex;
                dgrEvent.DataBind();
            }
            catch (Exception Ex)
            {
                ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(Ex, ErrorLevel.Medium, "ExportCPDEventReport.aspx.cs", "ShowEventPagination()", "Binding Data to Datagrid");
                throw (Ex);
            }
        }
        private DataSet GetEventPaginationData()
        {
            try
            {
                Event objEvent = new Event();
                DataSet odtReport = new DataSet();
                
                //odtReport = objEvent.GetUserEventReportNew(UserContext.UserID, UserContext.UserData.OrgID);   // report data    
                odtReport = objEvent.GetUserEventReportNew(UserId,OrganisationId);   // report data    
                //odtReport = objEvent.GetUserEventReportNew(1381,2);   // report data    
                if (odtReport.Tables[0].Rows.Count == 0)
                {
                    this.lblError.Text += "No results found.";
                    this.lblError.CssClass = "FeedbackMessage";
                }
                return odtReport;
            }

            catch (Exception Ex)
            {
                ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(Ex, ErrorLevel.Medium, "ExportCPDEventReport.aspx.cs", "GetEventPaginationData()", "Binding Data to Datagrid");
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
            }
            catch (Exception Ex)
            {
                ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(Ex, ErrorLevel.Medium, "ExportCPDEventReport.aspx.cs", "SetEventPaginationPanel()", "Binding Data to Datagrid");
                throw (Ex);
            }

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

                    //ds = objEvent.GetUserEventReportNew(UserContext.UserID, UserContext.UserData.OrgID);   // report data   
                    ds = objEvent.GetUserEventReportNew(UserId, OrganisationId);   // report data   
                    //ds = objEvent.GetUserEventReportNew(1381, 2);  
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
                ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(Ex, ErrorLevel.Medium, "ExportCPDEventReport.aspx.cs", "dgrEvent_ItemDataBound", "Binding Data to Datagrid");
                throw (Ex);
            }
        }


    }
}
