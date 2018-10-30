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

namespace Bdw.Application.Salt.Web.Reporting
{
    public partial class PeriodicReportInactiveListControl : System.Web.UI.UserControl
    {
        static string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
        PeriodicReportListDataContext prl = new PeriodicReportListDataContext(connectionString);

        private string username;
        private bool isOnInactivate;

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

        public bool IsOnInactivate
        {
            get
            {
                return isOnInactivate;
            }
            set
            {
                isOnInactivate = value;
            }
        }

        protected SortedList<int, int> SelectedForDelete
        {
            get
            {
                if (Session["SelectedForDelete"] == null)
                    return new SortedList<int, int>();
                else
                    return (SortedList<int, int>)Session["SelectedForDelete"];
            }
            set
            {
                Session["SelectedForDelete"] = value;
            }
        }

        protected SortedList<int, int> SelectedForReassign
        {
            get
            {
                if ((object)Session["SelectedForReassign"] == null)
                    return new SortedList<int, int>();
                else
                    return (SortedList<int, int>)Session["SelectedForReassign"];
            }
            set
            {
                Session["SelectedForReassign"] = value;
            }
        }

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

        public List<string> InactivatedUsernames
        {
            get
            {
                if ((object)Session["InactivatedUsernames"] == null)
                {
                    return new List<string>();
                }
                else
                    return (List<string>)Session["InactivatedUsernames"];
            }
            set
            {
                Session["InactivatedUsernames"] = value;
            }
        }

        public List<string> InactivatedEmails
        {
            get
            {
                if ((object)Session["InactivatedEmails"] == null)
                {
                    return new List<string>();
                }
                else
                    return (List<string>)Session["InactivatedEmails"];
            }
            set
            {
                Session["InactivatedEmails"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (UserContext.UserData.UserType == UserType.User)
                Response.Redirect("~/Default.aspx");

            if (!IsPostBack)
            {
                LoadPeriodicReportsList();


                if ((Request.QueryString["deleteselected"] != null))
                {
                    bool isDelete = false;
                    Boolean.TryParse(Request.QueryString["deleteselected"].ToString(), out isDelete);
                    if (isDelete)
                    {
                        DeleteSelectedReports();
                    }

                    LoadPeriodicReportsList();
                }

                if ((Request.QueryString["reassignselected"] != null))
                {
                    bool isReassign = false;
                    Boolean.TryParse(Request.QueryString["reassignselected"].ToString(), out isReassign);
                    if (isReassign)
                    {
                        ReassignSelectedReports();
                    }

                    LoadPeriodicReportsList();
                }

                if ((Request.QueryString["reassignuser"] != null))
                {
                    int userid = 0;
                    String strReassign = Request.QueryString["reassignuser"].ToString();

                    // multiple users return everytime reassign is clicked
                    string[] reassignUsers = strReassign.Split(new char[] { ',' });
                    string reassignUser = reassignUsers[reassignUsers.Length - 1];
                    Int32.TryParse(reassignUser, out userid);
                    SortedList<int, int> selectedForReassign = SelectedForReassign;
                    foreach (int schId in ScheduleIds)
                    {
                        if (selectedForReassign.ContainsKey(schId))
                            selectedForReassign.Remove(schId);
                        selectedForReassign.Add(schId, userid);
                    }
                    SelectedForReassign = selectedForReassign;

                    ReloadPeriodicReportList();
                }

                if (Request.UrlReferrer != null)
                {
                    if ((Request.UrlReferrer.GetLeftPart(UriPartial.Path).ToString() == Request.Url.GetLeftPart(UriPartial.Path).ToString()) && (Session["CallingUrl"] != null))
                    {
                        string redirectUrl = Session["CallingUrl"].ToString();

                        if (redirectUrl.Contains("UserDetails.aspx") && !redirectUrl.Contains("UpdatedUser"))
                            redirectUrl += "&message=UpdatedUser";

                        Session["CallingUrl"] = null;

                        Response.Redirect(redirectUrl);
                    }
                    else if (!Request.UrlReferrer.ToString().Contains("Reassign.aspx"))
                        Session["CallingUrl"] = Request.UrlReferrer.PathAndQuery.ToString();
                }
                else if ((Session["CallingUrl"] != null) && ((Request.QueryString["fromreassignpage"] == null)))
                {
                    string redirectUrl = Session["CallingUrl"].ToString();

                    if (redirectUrl.Contains("UserDetails.aspx") && !redirectUrl.Contains("UpdatedUser"))
                        redirectUrl += "&message=UpdatedUser";

                    Session["CallingUrl"] = null;

                    Response.Redirect(redirectUrl);
                }
            }

        }

        private void ReassignSelectedReports()
        {
            BusinessServices.Report report = new BusinessServices.Report();
            BusinessServices.User user = new BusinessServices.User();
            if ((Username != null) && (Username != ""))
            {
                int UserID = user.GetIdFromUsername(Username);
                foreach (KeyValuePair<int, int> keyvalue in SelectedForReassign)
                {
                    report.ReassignReportInactive(keyvalue.Key, UserID, keyvalue.Value);
                }
            }
            else if (InactivatedUsernames.Count > 0)
            {
                foreach (string Uname in InactivatedUsernames)
                {
                    int UserID = user.GetIdFromUsername(Uname);
                    foreach (KeyValuePair<int, int> keyvalue in SelectedForReassign)
                    {
                        report.ReassignReportInactive(keyvalue.Key, UserID, keyvalue.Value);
                    }
                }

                InactivatedUsernames = null;
            }
            else if (InactivatedEmails.Count > 0)
            {
                foreach (string email in InactivatedEmails)
                {
                    int UserID = user.GetIdFromEmail(email);
                    foreach (KeyValuePair<int, int> keyvalue in SelectedForReassign)
                    {
                        report.ReassignReportInactive(keyvalue.Key, UserID, keyvalue.Value);
                    }
                }

                InactivatedEmails = null;
            }

                //LoadPeriodicReportsList();

            SelectedForReassign = null;
        }

        private void LoadPeriodicReportsList()
        {
           List<string> inactivatedEmails = (List<string>)Session["InactivatedEmails"];

            if ((Username != null) && (Username.Length > 0))
            {
                PeriodicReportsGrid.DataSourceID = "ReportUserDataSource";
                ReportUserDataSource.SelectParameters["Username"].DefaultValue = Username;
            }
            else if ((inactivatedEmails != null) && (inactivatedEmails.Count > 0))
                PeriodicReportsGrid.DataSourceID = "ReportEmailsDataSource";
            else
                PeriodicReportsGrid.DataSourceID = "ReportDataSource";

            PeriodicReportsGrid.DataBind();

            if (PeriodicReportsGrid.Rows.Count == 0)
            {
                lblNoneFound.Visible = true;
                SelectAll.Visible = false;
                ClearAll.Visible = false;
                DeleteSelected.Visible = false;
                ReassignSelected.Visible = false;
            }
            else
            {
                lblNoneFound.Visible = false;
                SelectAll.Visible = true;
                ClearAll.Visible = true;
                DeleteSelected.Visible = true;
                ReassignSelected.Visible = true;
            }

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
                    totalRowCount = SelectCount(Session["InactivatedUsernames"]);
                }
                else if (PeriodicReportsGrid.DataSourceID == "ReportEmailsDataSource")
                    totalRowCount = SelectCountEmails(Session["InactivatedEmails"]);
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
        }

        protected void DeleteSelectedReports()
        {
            foreach (KeyValuePair<int, int> keyvalue in SelectedForDelete)
            {
                BusinessServices.Report objReport = new BusinessServices.Report();
                objReport.DeleteReportInactive(keyvalue.Key, keyvalue.Value);
            }

            //LoadPeriodicReportsList();

            SelectedForDelete = null;
        }

        protected void DeleteSelected_OnClick(object sender, EventArgs e)
        {
            SortedList<int, int> selectedForDelete = SelectedForDelete;
            foreach (GridViewRow report in PeriodicReportsGrid.Rows)
            {
                CheckBox cb = (CheckBox)report.FindControl("ReportSelector");
                if ((cb != null) && (cb.Checked))
                {
                    int ScheduleID = 0;
                    Int32.TryParse(PeriodicReportsGrid.DataKeys[report.RowIndex].Values["ScheduleID"].ToString(), out ScheduleID);
                    int UserID = 0;
                    Int32.TryParse(PeriodicReportsGrid.DataKeys[report.RowIndex].Values["UserID"].ToString(), out UserID);
                    selectedForDelete.Add(ScheduleID, UserID);
                }
            }

            SelectedForDelete = selectedForDelete;

            ReloadPeriodicReportList();

        }

        private void ReloadPeriodicReportList()
        {
            // remove from grid only (not from DB) as Save is not yet clicked
            DataTable dtReports = new DataTable();
            DataColumn dc1 = new DataColumn("ScheduleID");
            DataColumn dc2 = new DataColumn("UserID");
            DataColumn dc3 = new DataColumn("ReportID");
            DataColumn dc4 = new DataColumn("ReportTitle");
            DataColumn dc5 = new DataColumn("Username");
            DataColumn dc6 = new DataColumn("ReportName");
            DataColumn dc7 = new DataColumn("ReportFrequency");
            dtReports.Columns.Add(dc1);
            dtReports.Columns.Add(dc2);
            dtReports.Columns.Add(dc3);
            dtReports.Columns.Add(dc4);
            dtReports.Columns.Add(dc5);
            dtReports.Columns.Add(dc6);
            dtReports.Columns.Add(dc7);

            foreach (GridViewRow row in PeriodicReportsGrid.Rows)
            {
                int schId = 0;
                Int32.TryParse(PeriodicReportsGrid.DataKeys[row.RowIndex].Values["ScheduleID"].ToString(), out schId);
                if (!SelectedForDelete.Keys.Contains(schId))
                {
                    DataRow dr = dtReports.NewRow();
                    int scheduleId = 0;
                    Int32.TryParse(PeriodicReportsGrid.DataKeys[row.RowIndex].Values["ScheduleID"].ToString(), out scheduleId);
                    dr["ScheduleID"] = scheduleId;
                    int ReportID = 0;
                    Int32.TryParse(PeriodicReportsGrid.DataKeys[row.RowIndex].Values["ReportID"].ToString(), out ReportID);
                    dr["ReportID"] = ReportID;
                    dr["ReportTitle"] = ((HyperLink)(PeriodicReportsGrid.Rows[row.RowIndex].Cells[4].Controls[0])).Text;
                    int UserID = 0;
                    Int32.TryParse(PeriodicReportsGrid.DataKeys[row.RowIndex].Values["UserID"].ToString(), out UserID);
                    string username = PeriodicReportsGrid.Rows[row.RowIndex].Cells[5].Text;
                    if (SelectedForReassign.Keys.Contains(scheduleId))
                    {
                        int userId = 0;

                        SelectedForReassign.TryGetValue(scheduleId, out userId);
                        UserID = userId;
                        BusinessServices.User user = new BusinessServices.User();
                        DataTable dtUser = user.GetUser(userId);
                        username = dtUser.Rows[0]["Username"].ToString();
                    }
                    dr["UserID"] = UserID;
                    dr["Username"] = username;
                    dr["ReportName"] = PeriodicReportsGrid.Rows[row.RowIndex].Cells[6].Text;
                    dr["ReportFrequency"] = PeriodicReportsGrid.Rows[row.RowIndex].Cells[7].Text;
                    dtReports.Rows.Add(dr);
                }
            }
            DataView dvReports = dtReports.DefaultView;
            PeriodicReportsGrid.DataSourceID = null;
            PeriodicReportsGrid.DataSource = dvReports;
            PeriodicReportsGrid.DataBind();

            if (PeriodicReportsGrid.Rows.Count == 0)
            {
                lblNoneFound.Visible = true;
                SelectAll.Visible = false;
                ClearAll.Visible = false;
                DeleteSelected.Visible = false;
                ReassignSelected.Visible = false;
            }
            else
            {
                lblNoneFound.Visible = false;
                SelectAll.Visible = true;
                ClearAll.Visible = true;
                DeleteSelected.Visible = true;
                ReassignSelected.Visible = true;
            }
        }

        protected void ReassignSelected_Click(object sender, EventArgs e)
        {
            int selectedScheduleId = 0;
            int selectedUserId = 0;

            List<int> scheduleIds = ScheduleIds;
            SortedList<int, int> selectedForReassign = SelectedForReassign;

            foreach (GridViewRow report in PeriodicReportsGrid.Rows)
            {
                if (report.RowType == DataControlRowType.DataRow)
                {
                    CheckBox cb = (CheckBox)report.FindControl("ReportSelector");
                    if ((cb != null) && (cb.Checked))
                    {
                        int ScheduleID = 0;
                        Int32.TryParse(PeriodicReportsGrid.DataKeys[report.RowIndex].Values["ScheduleID"].ToString(), out ScheduleID);
                        selectedScheduleId = ScheduleID;
                        if (!scheduleIds.Contains(selectedScheduleId))
                            scheduleIds.Add(selectedScheduleId);
                        int UserID = 0;
                        Int32.TryParse(PeriodicReportsGrid.DataKeys[report.RowIndex].Values["UserID"].ToString(), out UserID);
                        selectedUserId = UserID;
                        if (selectedForReassign.ContainsKey(selectedScheduleId))
                            selectedForReassign.Remove(selectedScheduleId);
                        selectedForReassign.Add(selectedScheduleId, selectedUserId);
                    }
                }
            }

            ScheduleIds = scheduleIds;
            SelectedForReassign = selectedForReassign;

            if (scheduleIds.Count > 1)
                Page.ClientScript.RegisterStartupScript(this.GetType(), "openWindow", "<script>window.open('Reassign.aspx?isoninactivate=true');</script>");
            else
                Page.ClientScript.RegisterStartupScript(this.GetType(), "openWindow", "<script>window.open('Reassign.aspx?isoninactivate=true&scheduleid=" + selectedScheduleId.ToString() + "');</script>");
        }

        // just to keep "delete" command happy
        protected void PeriodicReportsGrid_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
        }

        // to keep update happy
        protected void PeriodicReportsGrid_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
        }

        protected void PeriodicReportsGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int rowIndex = Int32.Parse(e.CommandArgument.ToString());

            int scheduleID = 0;
            Int32.TryParse(PeriodicReportsGrid.DataKeys[rowIndex].Values["ScheduleID"].ToString(), out scheduleID);
            int selectedUserId = 0;
            Int32.TryParse(PeriodicReportsGrid.DataKeys[rowIndex].Values["UserID"].ToString(), out selectedUserId);

            if (e.CommandName == "Delete")
            {
                SortedList<int, int> selectedDeleteUsers = SelectedForDelete;
                selectedDeleteUsers.Add(scheduleID, selectedUserId);
                SelectedForDelete = selectedDeleteUsers;

                ReloadPeriodicReportList();
            }
            else if (e.CommandName == "Reassign")
            {
                List<int> scheduleIds = ScheduleIds;
                SortedList<int, int> selectedForReassign = SelectedForReassign;
                if (!scheduleIds.Contains(scheduleID))
                    scheduleIds.Add(scheduleID);
                if (selectedForReassign.ContainsKey(scheduleID))
                    selectedForReassign.Remove(scheduleID);
                selectedForReassign.Add(scheduleID, selectedUserId);

                ScheduleIds = scheduleIds;
                SelectedForReassign = selectedForReassign;

                Page.ClientScript.RegisterStartupScript(this.GetType(), "openWindow", "<script>window.open('Reassign.aspx?isoninactivate=true&scheduleid=" + scheduleID.ToString() + "');</script>");
            }
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

        protected void Save_OnClick(object sender, EventArgs e)
        {
            if ((Request.QueryString["user"] == null) && (Request.QueryString["isoninactivate"] != "true"))
                Page.ClientScript.RegisterStartupScript(this.GetType(), "deletereassign", "<script language='javascript'>if (confirm('Are you sure you want to save changes?')==true) { window.location.href = 'PeriodicReportList.aspx?deleteselected=true&reassignselected=true'; }</script>");
            if ((Request.QueryString["user"] != null) && (Request.QueryString["isoninactivate"] != "true"))
            {
                string user = Request.QueryString["user"].ToString();
                Page.ClientScript.RegisterStartupScript(this.GetType(), "deletereassign", "<script language='javascript'>if (confirm('Are you sure you want to save changes?')==true) { window.location.href = 'PeriodicReportList.aspx?deleteselected=true&reassignselected=true&user=" + user + "'; }</script>");
            }
            if ((Request.QueryString["user"] == null) && (Request.QueryString["isoninactivate"] == "true"))
                Page.ClientScript.RegisterStartupScript(this.GetType(), "deletereassign", "<script language='javascript'>if (confirm('Are you sure you want to save changes')==true) { window.location.href = 'PeriodicReportList.aspx?deleteselected=true&reassignselected=true&isoninactivate=true'; }</script>");
            if ((Request.QueryString["user"] != null) && (Request.QueryString["isoninactivate"] == "true"))
            {
                string user = Request.QueryString["user"].ToString();
                Page.ClientScript.RegisterStartupScript(this.GetType(), "deletereassign", "<script language='javascript'>if (confirm('Are you sure you want to save changes?')==true) { window.location.href = 'PeriodicReportList.aspx?deleteselected=true&reassignselected=true&isoninactivate=true&user=" + user + "'; }</script>");
            }
        }

        protected void Cancel_OnClick(object sender, EventArgs e)
        {
            SelectedForDelete = null;
            SelectedForReassign = null;

            LoadPeriodicReportsList();

            string redirectUrl = Session["CallingUrl"].ToString();
            if (redirectUrl.Contains("UserDetails.aspx") && !redirectUrl.Contains("UpdatedUser"))
                redirectUrl += "&message=UpdatedUser";

            Response.Redirect(redirectUrl);
        }


        #region General Periodic Report List for inactive users

        public List<prcGetPeriodicReportListOnInactivateUserResult> SelectAllReports(object InactivatedUsernames, string sSortType, int iBeginRowIndex, int iMaximumRows)
        {
            int OrgID = UserContext.UserData.OrgID;
            List<string> inactivatedUsernames = (List<string>)InactivatedUsernames;

            List<prcGetPeriodicReportListOnInactivateUserResult> InactiveSchedules = new List<prcGetPeriodicReportListOnInactivateUserResult>();

            foreach (string username in inactivatedUsernames)
            {
                ISingleResult<prcGetPeriodicReportListOnInactivateUserResult> result = prl.prcGetPeriodicReportListOnInactivateUser(OrgID, username);
                var qry = from pr in result.AsQueryable<prcGetPeriodicReportListOnInactivateUserResult>() select pr;
                InactiveSchedules.AddRange(qry.ToList<prcGetPeriodicReportListOnInactivateUserResult>());
            }

            var query = InactiveSchedules.AsQueryable<prcGetPeriodicReportListOnInactivateUserResult>();

            //sort
            query = SelectAllReportsSort(query, sSortType);

            // paginate    
            query = query.Skip(iBeginRowIndex).Take(iMaximumRows);

            return query.ToList();
        }

        public List<prcGetPeriodicReportListOnInactivateEmailResult> SelectAllReportsEmails(object InactivatedEmails, string sSortType, int iBeginRowIndex, int iMaximumRows)
        {
            int OrgID = UserContext.UserData.OrgID;
            List<string> inactivatedEmails = (List<string>)InactivatedEmails;

            List<prcGetPeriodicReportListOnInactivateEmailResult> InactiveSchedules = new List<prcGetPeriodicReportListOnInactivateEmailResult>();

            foreach (string email in inactivatedEmails)
            {
                ISingleResult<prcGetPeriodicReportListOnInactivateEmailResult> result = prl.prcGetPeriodicReportListOnInactivateEmail(OrgID, email);
                var qry = from pr in result.AsQueryable<prcGetPeriodicReportListOnInactivateEmailResult>() select pr;
                InactiveSchedules.AddRange(qry.ToList<prcGetPeriodicReportListOnInactivateEmailResult>());
            }

            var query = InactiveSchedules.AsQueryable<prcGetPeriodicReportListOnInactivateEmailResult>();

            //sort
            query = SelectAllReportsSortEmails(query, sSortType);

            // paginate    
            query = query.Skip(iBeginRowIndex).Take(iMaximumRows);

            return query.ToList();
        }


        public int SelectCount(object InactivatedUsernames)
        {
            int OrgID = UserContext.UserData.OrgID;
            List<string> inactivatedUsernames = (List<string>)InactivatedUsernames;

            List<prcGetPeriodicReportListOnInactivateUserResult> InactiveSchedules = new List<prcGetPeriodicReportListOnInactivateUserResult>();

            foreach (string username in inactivatedUsernames)
            {
                ISingleResult<prcGetPeriodicReportListOnInactivateUserResult> result = prl.prcGetPeriodicReportListOnInactivateUser(OrgID, username);
                var qry = from pr in result.AsQueryable<prcGetPeriodicReportListOnInactivateUserResult>() select pr;
                InactiveSchedules.AddRange(qry.ToList<prcGetPeriodicReportListOnInactivateUserResult>());
            }

            var query = InactiveSchedules.AsQueryable<prcGetPeriodicReportListOnInactivateUserResult>();

            return query.Count<prcGetPeriodicReportListOnInactivateUserResult>();
        }

        public int SelectCountEmails(object InactivatedEmails)
        {
            int OrgID = UserContext.UserData.OrgID;
            List<string> inactivatedEmails = (List<string>)InactivatedEmails;

            List<prcGetPeriodicReportListOnInactivateEmailResult> InactiveSchedules = new List<prcGetPeriodicReportListOnInactivateEmailResult>();

            foreach (string email in inactivatedEmails)
            {
                ISingleResult<prcGetPeriodicReportListOnInactivateEmailResult> result = prl.prcGetPeriodicReportListOnInactivateEmail(OrgID, email);
                var qry = from pr in result.AsQueryable<prcGetPeriodicReportListOnInactivateEmailResult>() select pr;
                InactiveSchedules.AddRange(qry.ToList<prcGetPeriodicReportListOnInactivateEmailResult>());
            }

            var query = InactiveSchedules.AsQueryable<prcGetPeriodicReportListOnInactivateEmailResult>();

            return query.Count<prcGetPeriodicReportListOnInactivateEmailResult>();
        }


        protected IQueryable<prcGetPeriodicReportListOnInactivateUserResult> SelectAllReportsSort(IQueryable<prcGetPeriodicReportListOnInactivateUserResult> query, String sSortType)
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
                case "Report Owner":
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => o.Username);
                    else
                        query = query.OrderByDescending(o => o.Username);
                    break;
                case "ReportName":
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => o.ReportName);
                    else
                        query = query.OrderByDescending(o => o.ReportName);
                    break;
                case "ReportFrequency":
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => o.ReportFrequency);
                    else
                        query = query.OrderByDescending(o => o.ReportFrequency);
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

        protected IQueryable<prcGetPeriodicReportListOnInactivateEmailResult> SelectAllReportsSortEmails(IQueryable<prcGetPeriodicReportListOnInactivateEmailResult> query, String sSortType)
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
                case "Report Owner":
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => o.Username);
                    else
                        query = query.OrderByDescending(o => o.Username);
                    break;
                case "ReportName":
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => o.ReportName);
                    else
                        query = query.OrderByDescending(o => o.ReportName);
                    break;
                case "ReportFrequency":
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => o.ReportFrequency);
                    else
                        query = query.OrderByDescending(o => o.ReportFrequency);
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

        #region Periodic Report List for User

        public List<prcGetPeriodicReportListOnInactivateUserResult> SelectAllReportsUser(string sSortType, int iBeginRowIndex, int iMaximumRows, string Username)
        {
            int OrgID = UserContext.UserData.OrgID;
            ISingleResult<prcGetPeriodicReportListOnInactivateUserResult> result = prl.prcGetPeriodicReportListOnInactivateUser(OrgID, Username);

            var query = from pr in result.AsQueryable<prcGetPeriodicReportListOnInactivateUserResult>() select pr;

            //sort
            query = SelectAllReportsUserSort(query, sSortType);

            // paginate    
            query = query.Skip(iBeginRowIndex).Take(iMaximumRows);

            return query.ToList();

        }

        public int SelectCountUser(string Username)
        {
            int OrgID = UserContext.UserData.OrgID;

            ISingleResult<prcGetPeriodicReportListOnInactivateUserResult> result = prl.prcGetPeriodicReportListOnInactivateUser(OrgID, Username);

            var query = from pr in result.AsQueryable<prcGetPeriodicReportListOnInactivateUserResult>() select pr;

            return query.Count<prcGetPeriodicReportListOnInactivateUserResult>();
        }

        protected IQueryable<prcGetPeriodicReportListOnInactivateUserResult> SelectAllReportsUserSort(IQueryable<prcGetPeriodicReportListOnInactivateUserResult> query, String sSortType)
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
                case "Report Owner":
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => o.Username);
                    else
                        query = query.OrderByDescending(o => o.Username);
                    break;
                case "ReportName":
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => o.ReportName);
                    else
                        query = query.OrderByDescending(o => o.ReportName);
                    break;
                case "ReportFrequency":
                    if (sortDirection == "asc")
                        query = query.OrderBy(o => o.ReportFrequency);
                    else
                        query = query.OrderByDescending(o => o.ReportFrequency);
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