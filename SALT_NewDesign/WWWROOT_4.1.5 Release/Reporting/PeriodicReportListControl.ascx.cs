using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Data.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Linq.Expressions;
using System.ComponentModel;
using Bdw.Application.Salt.Utilities;
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.BusinessServices;
using Localization;
using System.Globalization;

namespace Bdw.Application.Salt.Web.Reporting
{
    public partial class PeriodicReportListControl : System.Web.UI.UserControl
    {
        static string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
        PeriodicReportListDataContext prl = new PeriodicReportListDataContext(connectionString);

        private string username;

        public string Username
        {
            get
            {
                return username;
            }
            set
            {
                username = value;
            }
        }

        protected List<int> SelectedForDelete
        {
            get
            {
                if (Session["SelectedForDelete"]==null)
                    return new List<int>(); 
                else
                    return (List<int>)Session["SelectedForDelete"];
            }
            set
            {
                Session["SelectedForDelete"] = value;
            }
        }
        
        int scheduleId = 0;

        protected List<int> ScheduleIds
        {
            get
            {
                if ((object)Session["ScheduleIds"] == null)
                    return new List<int>();
                else
                    return (List<int>)Session["ScheduleIds"];
            }
            set
            {
                Session["ScheduleIds"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (UserContext.UserData.UserType == UserType.User)
                Response.Redirect("~/Default.aspx");

            //if (!IsPostBack)
            //{
            LoadPeriodicReportsList();

                //init report dropdown list
            initReportList();
            //}

            if ((Request.QueryString["deleteselected"] != null))
            {
                bool isDelete = false;
                Boolean.TryParse(Request.QueryString["deleteselected"].ToString(), out isDelete);
                if (isDelete)
                {
                    DeleteSelectedReports();
                }
            }
           
        }

        private void LoadPeriodicReportsList()
        {
            if ((Username == null) || (Username == ""))
            {
                UserType userType = UserContext.UserData.UserType;
                if (userType == UserType.SaltAdmin)
                {
                    PeriodicReportsGrid.DataSourceID = "ReportDataSource";
                }
                else if (userType == UserType.UnitAdmin || userType == UserType.OrgAdmin)
                {
                    DataTable dtUser = new User().GetUser(UserContext.UserID);
                    Username = dtUser.Rows[0]["Username"].ToString();
                }
            }

            if ((Username != null) && (Username.Length > 0))
            {
                PeriodicReportsGrid.DataSourceID = "ReportUserDataSource";
                ReportUserDataSource.SelectParameters["Username"].DefaultValue = Username;
            }

            PeriodicReportsGrid.DataBind();

            if (PeriodicReportsGrid.Rows.Count == 0)
            {
                lblNoneFound.Visible = true;
                ExportTypes.Visible = false;
                btnExport.Visible = false;
                SelectAll.Visible = false;
                ClearAll.Visible = false;
                DeleteSelected.Visible = false;
                ReassignSelected.Visible = false;
                ExportType2.Visible = false;
                btnExport2.Visible = false;
            }
            else
            {
                lblNoneFound.Visible = false;
                ExportTypes.Visible = true;
                btnExport.Visible = true;
                SelectAll.Visible = true;
                ClearAll.Visible = true;
                DeleteSelected.Visible = true;
                ReassignSelected.Visible = true;
                ExportType2.Visible = true;
                btnExport2.Visible = true;
            }

            if (UserContext.UserData.UserType == UserType.UnitAdmin)
            {
                // hide admin type column
                PeriodicReportsGrid.Columns[12].Visible = false;
            }
        }

        private void initReportList()
        {
            //init report dropdown list
            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
            string sqlSelect = "SELECT case " +
            " when RI.ReportID = 27 then (select coalesce(LangEntryValue,'Missing Localisation') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = '" + ResourceManager.CurrentCultureName + "') and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Reporting/Admin/AdministrationReport.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'lblPageTitle.2')) " +
            " when RI.ReportID = 26 then (select coalesce(LangEntryValue,'Missing Localisation') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = '" + ResourceManager.CurrentCultureName + "') and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Reporting/Admin/AdministrationReport.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'lblPageTitle.2')) " +
            " when RI.ReportID = 3 then (select coalesce(LangEntryValue,'Missing Localisation') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = '" + ResourceManager.CurrentCultureName + "') and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Reporting/Admin/AdministrationReport.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'lblPageTitle.1')) " +
            " when RI.ReportID = 6 then (select coalesce(LangEntryValue,'Missing Localisation') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = '" + ResourceManager.CurrentCultureName + "') and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Reporting/Admin/AdministrationReport.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'lblPageTitle.1')) " +
            " when RI.ReportID = 36 then (select coalesce(LangEntryValue,'Missing Localisation') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = '" + ResourceManager.CurrentCultureName + "') and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Reporting/Policy/PolicyBuilderReport.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'lblPageTitle')) " +
            " else coalesce(LangEntryValue,'Missing Localisation') " +
            " end as ReportName, ReportID " +
            " FROM (SELECT tblLangValue.LangEntryValue, tblLangInterface.langinterfacename FROM tblLang INNER JOIN " +
            " tblLangValue ON tblLang.LangID = tblLangValue.LangID and tblLang.LangCode = '" + ResourceManager.CurrentCultureName + "' " +
            " INNER JOIN tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID " +
            " INNER JOIN tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID " +
            " AND (tblLangValue.Active = 1) and langresourcename = 'rptreporttitle' ) as TI " +
            " right outer join tblReportinterface RI on RI.paramlanginterfacename = TI.langinterfacename " +
                //" where (RI.ReportID != 6)  and (RI.ReportID != 18) and (RI.ReportID != 24) and (RI.ReportID != 26) and (RI.ReportID != 10)and (RI.ReportID != 23)order by ReportName";
            " where (RI.Active = 1) and (RI.ReportID != 6)  and (RI.ReportID != 18) and (RI.ReportID != 24) and (RI.ReportID != 26) and (RI.ReportID != 10)and (RI.ReportID != 23)   ";
            DataTable dtbReportTable = Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteDataset(connectionString, System.Data.CommandType.Text, sqlSelect).Tables[0];
            

            listReports.DataSource = dtbReportTable;
            listReports.DataValueField = "ReportID";
            listReports.DataTextField = "ReportName";

            listReports.DataBind();

            Organisation objOrganisation = new Organisation();
            if (!(objOrganisation.GetOrganisationCPDAccess(UserContext.UserData.OrgID)))
                listReports.Items.Remove(listReports.Items.FindByValue("30")); // CPD report
            if (!(objOrganisation.GetOrganisationPolicyAccess(UserContext.UserData.OrgID)))
                listReports.Items.Remove(listReports.Items.FindByValue("36")); // policy builder report            
            
        }

        protected void PeriodicReportsGrid_PreRender(object sender, EventArgs e)
        {

            GridViewRow pagerRow = PeriodicReportsGrid.BottomPagerRow;

            if (pagerRow != null && pagerRow.Visible == false)
                pagerRow.Visible = true;

        }

        protected void PeriodicReportsGrid_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            for (int i = 0; i < e.Row.Cells.Count; i++)
            {
                e.Row.Cells[i].Attributes.Add("style", "white-space: nowrap;");
            }
        }

        protected void PeriodicReportsGrid_DataBound(Object sender, EventArgs e)
        {

            DropDownList pageList = null;
            Label pageLabel = null;
            if (PeriodicReportsGrid.Rows.Count > 0)
            {
                // Retrieve the pager row.
                GridViewRow pagerRow = PeriodicReportsGrid.BottomPagerRow;

                // Retrieve the DropDownList and Label controls from the row.
                pageList = (DropDownList)pagerRow.Cells[0].FindControl("PageDropDownList");
                pageLabel = (Label)pagerRow.Cells[0].FindControl("CurrentPageLabel");
            }
            if (pageList != null)
            {

                // Create the values for the DropDownList control based on 
                // the  total number of pages required to display the data
                // source.
                for (int i = 0; i < PeriodicReportsGrid.PageCount; i++)
                {

                    // Create a ListItem object to represent a page.
                    int pageNumber = i + 1;
                    ListItem item = new ListItem(pageNumber.ToString());

                    // If the ListItem object matches the currently selected
                    // page, flag the ListItem object as being selected. Because
                    // the DropDownList control is recreated each time the pager
                    // row gets created, this will persist the selected item in
                    // the DropDownList control.   
                    if (i == PeriodicReportsGrid.PageIndex)
                    {
                        item.Selected = true;
                    }

                    // Add the ListItem object to the Items collection of the 
                    // DropDownList.
                    pageList.Items.Add(item);

                }

            }

            if (pageLabel != null)
            {
                // Calculate the current page number.
                int currentPage = PeriodicReportsGrid.PageIndex + 1;

                int totalRowCount = 0;
                if (PeriodicReportsGrid.DataSourceID == "ReportDataSource")
                {
                    totalRowCount = SelectCount();
                }
                else if (PeriodicReportsGrid.DataSourceID == "ReportUserDataSource")
                {
                    totalRowCount = SelectCountUser(username);
                }
            
                // Update the Label control with the current page information.
                pageLabel.Text = " Of " + PeriodicReportsGrid.PageCount.ToString()
                               + " :    " + (PeriodicReportsGrid.PageIndex * PeriodicReportsGrid.PageSize + 1) + " -- " + (PeriodicReportsGrid.PageIndex * PeriodicReportsGrid.PageSize + PeriodicReportsGrid.Rows.Count) + " Of " + totalRowCount;

            }
        }

        protected void PageDropDownList_SelectedIndexChanged(Object sender, EventArgs e)
        {

            // Retrieve the pager row.
            GridViewRow pagerRow = PeriodicReportsGrid.BottomPagerRow;

            // Retrieve the PageDropDownList DropDownList from the bottom pager row.
            DropDownList pageList = (DropDownList)pagerRow.Cells[0].FindControl("PageDropDownList");

            // Set the PageIndex property to display that page selected by the user.
            PeriodicReportsGrid.PageIndex = pageList.SelectedIndex;

            LoadPeriodicReportsList();

            SelectAll.Checked = false;
            ClearAll.Checked = false;
        }

        protected void btnNewReport_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("PeriodicReport.aspx?ReportID=" + listReports.SelectedValue);
        }

        protected void DeleteSelectedReports()
        {
            foreach (int scheduleId in SelectedForDelete)
            {
                BusinessServices.Report objReport = new BusinessServices.Report();
                objReport.DeleteReport(scheduleId);
            }

            LoadPeriodicReportsList();

            SelectedForDelete = null;
        }

        protected void DeleteSelected_OnClick(object sender, EventArgs e)
        {
            List<int> selectedForDelete = SelectedForDelete;
            foreach (GridViewRow report in PeriodicReportsGrid.Rows)
            {
                CheckBox cb = (CheckBox)report.FindControl("ReportSelector");
                if ((cb != null) && (cb.Checked))
                {
                    selectedForDelete.Add((int)PeriodicReportsGrid.DataKeys[report.RowIndex].Values["ScheduleID"]);
                }
            }

            SelectedForDelete = selectedForDelete;

            if ((Request.QueryString["user"] == null) && (Request.QueryString["isoninactivate"] != "true"))
                Page.ClientScript.RegisterStartupScript(this.GetType(), "delete", "<script language='javascript'>if (confirm('Are you sure you want to delete selected reports?')==true) { self.focus(); window.location.href = 'PeriodicReportList.aspx?deleteselected=true'; }</script>");
            if ((Request.QueryString["user"] != null) && (Request.QueryString["isoninactivate"] != "true"))
            {
                string user = Request.QueryString["user"].ToString();
                Page.ClientScript.RegisterStartupScript(this.GetType(), "delete", "<script language='javascript'>if (confirm('Are you sure you want to delete selected reports?')==true) { self.focus(); window.location.href = 'PeriodicReportList.aspx?deleteselected=true&user=" + user + "'; }</script>");
            }
            if ((Request.QueryString["user"] == null) && (Request.QueryString["isoninactivate"] == "true"))
                Page.ClientScript.RegisterStartupScript(this.GetType(), "delete", "<script language='javascript'>if (confirm('Are you sure you want to delete selected reports?')==true) { self.focus(); window.location.href = 'PeriodicReportList.aspx?deleteselected=true&isoninactivate=true'; }</script>");
            if ((Request.QueryString["user"] != null) && (Request.QueryString["isoninactivate"] == "true"))
            {
                string user = Request.QueryString["user"].ToString();
                Page.ClientScript.RegisterStartupScript(this.GetType(), "delete", "<script language='javascript'>if (confirm('Are you sure you want to delete selected reports?')==true) { self.focus(); window.location.href = 'PeriodicReportList.aspx?deleteselected=true&isoninactivate=true&user=" + user + "'; }</script>");
            }

        }

        protected void ReassignSelected_Click(object sender, EventArgs e)
        {
            int selectedScheduleId = 0;

            List<int> scheduleIds = ScheduleIds;

            foreach (GridViewRow report in PeriodicReportsGrid.Rows)
            {
                if (report.RowType == DataControlRowType.DataRow)
                {
                    CheckBox cb = (CheckBox)report.FindControl("ReportSelector");
                    if ((cb != null) && (cb.Checked))
                    {
                        selectedScheduleId = ((int)PeriodicReportsGrid.DataKeys[report.RowIndex].Values["ScheduleID"]);
                        scheduleIds.Add(selectedScheduleId);
                    }
                }
            }

            ScheduleIds = scheduleIds;

            //if (scheduleIds.Count > 1)
            Page.ClientScript.RegisterStartupScript(this.GetType(), "openWindow", "<script>window.open('Reassign.aspx');</script>");
            //else
            //    Page.ClientScript.RegisterStartupScript(this.GetType(), "openWindow", "<script>window.open('Reassign.aspx?scheduleid=" + selectedScheduleId.ToString() + "');</script>");
        }

        protected void SelectAll_CheckedChanged(object sender, EventArgs e)
        {
            foreach (GridViewRow report in PeriodicReportsGrid.Rows)
            {
                CheckBox cb = (CheckBox)report.FindControl("ReportSelector");
                if (cb != null)
                {
                    cb.Checked = SelectAll.Checked;
                }
            }
            if (SelectAll.Checked == true)
                ClearAll.Checked = false;
        }

        protected void ClearAll_CheckedChanged(object sender, EventArgs e)
        {
            if (ClearAll.Checked == true)
            {
                foreach (GridViewRow report in PeriodicReportsGrid.Rows)
                {
                    CheckBox cb = (CheckBox)report.FindControl("ReportSelector");
                    if (cb != null)
                    {
                        cb.Checked = !ClearAll.Checked;
                    }
                }

                SelectAll.Checked = false;
            }
        }

        public void btnExport2_OnClick(object sender, EventArgs e)
        {
            string FileName = GridExport.LocalisedFileName("/Reporting/PeriodicReport.aspx", "lblPageTitle", ResourceManager.CurrentCultureName);
            string SP = "";
            Bdw.Application.Salt.Web.General.UserControls.EmergingControls.DataSetExport.ExportType ET = Bdw.Application.Salt.Web.General.UserControls.EmergingControls.DataSetExport.ExportType.Word;
            if (ExportTypes.SelectedValue.Equals("CSV")) 
            {
                SP = "prcGridExport_PeriodicCSV"; 
                ET = Bdw.Application.Salt.Web.General.UserControls.EmergingControls.DataSetExport.ExportType.CSV;
                GridExport.ExportDataSet(SP, UserContext.UserData.OrgID.ToString(), "", "ReportTitle", ResourceManager.CurrentCultureName, ET, FileName);

            }
            if (ExportTypes.SelectedValue.Equals("PDF")) 
            { 
                SP = "prcGridExport_PeriodicRS"; 
                ET = Bdw.Application.Salt.Web.General.UserControls.EmergingControls.DataSetExport.ExportType.PDF;
                GridExport.ExportDataSetNew(SP, UserContext.UserData.OrgID.ToString(), UserContext.UserID.ToString(), "ReportTitle", ResourceManager.CurrentCultureName, ET, FileName, FileName, "/Reporting/PeriodicReport.aspx", "lblPageTitle","0");

            }
            if (ExportTypes.SelectedValue.Equals("XLS")) 
            { 
                SP = "prcGridExport_PeriodicRS"; 
                ET = Bdw.Application.Salt.Web.General.UserControls.EmergingControls.DataSetExport.ExportType.Excel;
                GridExport.ExportDataSetNew(SP, UserContext.UserData.OrgID.ToString(), UserContext.UserID.ToString(), "ReportTitle", ResourceManager.CurrentCultureName, ET, FileName, FileName, "/Reporting/PeriodicReport.aspx", "lblPageTitle","1");
            }

            //Bdw.Application.Salt.Web.General.UserControls.EmergingControls.DataSetExport DSE = new Bdw.Application.Salt.Web.General.UserControls.EmergingControls.DataSetExport();


        }

        #region General Periodic Report List

        public List<prcGetPeriodicReportListResult> SelectAllReports(string sSortType, int iBeginRowIndex, int iMaximumRows)
        {
            int OrgID = UserContext.UserData.OrgID;

            ISingleResult<prcGetPeriodicReportListResult> result = prl.prcGetPeriodicReportList(OrgID);

            var query = from pr in result.AsQueryable<prcGetPeriodicReportListResult>() select pr;

            //sort
            query = SelectAllReportsSort(query, sSortType);

            // paginate    
            query = query.Skip(iBeginRowIndex).Take(iMaximumRows);

            return query.ToList();

        }

        public int SelectCount()
        {
            int OrgID = UserContext.UserData.OrgID;
            ISingleResult<prcGetPeriodicReportListResult> result = prl.prcGetPeriodicReportList(OrgID);

            var query = from pr in result.AsQueryable<prcGetPeriodicReportListResult>() select pr;

            return query.Count<prcGetPeriodicReportListResult>();
        }

        protected IQueryable<prcGetPeriodicReportListResult> SelectAllReportsSort(IQueryable<prcGetPeriodicReportListResult> query, String sSortType)
        {
            string[] sortInfo = sSortType.Split(' ');
            string sortExpression = sortInfo[0];

            string sortDirection = "asc";

            if (sortInfo.Length > 1)
                sortDirection = sortInfo[1].ToLower();
                
            switch (sortExpression)
            {
                case "ReportTitle":
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => o.ReportTitle);
                    else
                        query = query.OrderByDescending(o => o.ReportTitle);
                    break;
                case "ReportName":
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => o.ReportName);
                    else
                        query = query.OrderByDescending(o => o.ReportName);
                    break;
                case "ReportFrequency":
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => ReportFrequencyForSort(o.ReportFrequency));
                    else
                        query = query.OrderByDescending(o => ReportFrequencyForSort(o.ReportFrequency));
                    break;
                case "DateCreated":
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => Convert.ToDateTime(o.DateCreated));
                    else
                        query = query.OrderByDescending(o => Convert.ToDateTime(o.DateCreated));
                    break;
                case "ReportStartDate":
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => Convert.ToDateTime(o.ReportStartDate));
                    else
                        query = query.OrderByDescending(o => Convert.ToDateTime(o.ReportStartDate));
                    break;
                case "ReportEndDate":
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => Convert.ToDateTime(o.ReportEndDate));
                    else
                        query = query.OrderByDescending(o => Convert.ToDateTime(o.ReportEndDate));
                    break;
                case "NextRun":
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => o.NextRun);
                    else
                        query = query.OrderByDescending(o => o.NextRun);
                    break;
                case "Username":
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => o.Username);
                    else
                        query = query.OrderByDescending(o => o.Username);
                    break;
                case "Type":
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => o.Type);
                    else
                        query = query.OrderByDescending(o => o.Type);
                    break;
                case "CCUser":
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => o.CCUser);
                    else
                        query = query.OrderByDescending(o => o.CCUser);
                    break;
                default:
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => o.ReportTitle);
                    else
                        query = query.OrderByDescending(o => o.ReportTitle);
                    break;
            }

            //SelectAll.Checked = false;
            //ClearAll.Checked = false;

            return query;
        }

        protected void PeriodicReportsGrid_Sorted(object sender, EventArgs e)
        {
            SelectAll.Checked = false;
            ClearAll.Checked = false;
        }
        
        public void bottomFileType_Changed(object sender, EventArgs e)
        {
            ExportTypes.SelectedIndex = ExportType2.SelectedIndex;
        }
        public void topFileType_Changed(object sender, EventArgs e)
        {
            ExportType2.SelectedIndex = ExportTypes.SelectedIndex;
        }
        #endregion 

        #region Periodic Report List for User

        public List<prcGetPeriodicReportListUserResult> SelectAllReportsUser(string sSortType, int iBeginRowIndex, int iMaximumRows, string Username)
        {
            int OrgID = UserContext.UserData.OrgID;
            ISingleResult<prcGetPeriodicReportListUserResult> result = prl.prcGetPeriodicReportListUser(OrgID, Username);

            var query = from pr in result.AsQueryable<prcGetPeriodicReportListUserResult>() select pr;

            //sort
            query = SelectAllReportsUserSort(query, sSortType);

            // paginate    
            query = query.Skip(iBeginRowIndex).Take(iMaximumRows);

            return query.ToList();

        }

        public int SelectCountUser(string Username)
        {
            int OrgID = UserContext.UserData.OrgID;

            ISingleResult<prcGetPeriodicReportListUserResult> result = prl.prcGetPeriodicReportListUser(OrgID, Username);

            var query = from pr in result.AsQueryable<prcGetPeriodicReportListUserResult>() select pr;

            return query.Count<prcGetPeriodicReportListUserResult>();
        }

        protected int ReportFrequencyForSort(string reportFrequency)
        {
            string num = reportFrequency.Substring(0, 1);
            string unit = reportFrequency.Substring(2);
            int multiplyer = 1;
            switch (unit.Substring(0, 1).ToUpper())
            {
                case "D":
                    multiplyer = 1;
                    break;
                case "W":
                    multiplyer = 7;
                    break;
                case "M":
                    multiplyer = 30;
                    break;
                case "Y":
                    multiplyer = 365;
                    break;
                default:
                    multiplyer = 1;
                    break;
            }

            int number = 0;
            Int32.TryParse(num, out number);

            return (number * multiplyer);
        }

        protected IQueryable<prcGetPeriodicReportListUserResult> SelectAllReportsUserSort(IQueryable<prcGetPeriodicReportListUserResult> query, String sSortType)
        {
            string[] sortInfo = sSortType.Split(' ');
            string sortExpression = sortInfo[0];

            string sortDirection = "asc";

            if (sortInfo.Length > 1)
                sortDirection = sortInfo[1].ToLower();

            switch (sortExpression)
            {
                case "ReportTitle":
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => o.ReportTitle);
                    else
                        query = query.OrderByDescending(o => o.ReportTitle);
                    break;
                case "ReportName":
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => o.ReportName);
                    else
                        query = query.OrderByDescending(o => o.ReportName);
                    break;
                case "ReportFrequency":
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => ReportFrequencyForSort(o.ReportFrequency));
                    else
                        query = query.OrderByDescending(o => ReportFrequencyForSort(o.ReportFrequency));
                    break;
                case "DateCreated":
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => Convert.ToDateTime(o.DateCreated));
                    else
                        query = query.OrderByDescending(o => Convert.ToDateTime(o.DateCreated));
                    break;
                case "ReportStartDate":
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => Convert.ToDateTime(o.ReportStartDate));
                    else
                        query = query.OrderByDescending(o => Convert.ToDateTime(o.ReportStartDate));
                    break;
                case "ReportEndDate":
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => Convert.ToDateTime(o.ReportEndDate));
                    else
                        query = query.OrderByDescending(o => Convert.ToDateTime(o.ReportEndDate));
                    break;
                case "NextRun":
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => o.NextRun);
                    else
                        query = query.OrderByDescending(o => o.NextRun);
                    break;
                case "Report Owner":
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => o.Username);
                    else
                        query = query.OrderByDescending(o => o.Username);
                    break;
                case "Type":
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => o.Type);
                    else
                        query = query.OrderByDescending(o => o.Type);
                    break;
                case "CCUser":
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => o.CCUser);
                    else
                        query = query.OrderByDescending(o => o.CCUser);
                    break;
                default:
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => o.ReportTitle);
                    else
                        query = query.OrderByDescending(o => o.ReportTitle);
                    break;
            }

            return query;
        }

        #endregion 

    }
}