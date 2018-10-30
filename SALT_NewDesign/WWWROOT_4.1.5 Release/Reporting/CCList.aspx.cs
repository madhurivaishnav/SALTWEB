using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Linq;
using Bdw.Application.Salt.Web.Utilities;
using System.Data.SqlClient;
using System.Data.Linq;

namespace Bdw.Application.Salt.Web.Reporting
{
    public partial class CCList : System.Web.UI.Page
    {
        private int scheduleId;
        private int userGridRowCount;
        private int ccGridRowCount;

        protected List<int> SelectedAddUsers
        {
            get
            {
                if (Session["SelectedAddUsers"] == null)
                    return new List<int>();
                else
                    return ((List<int>)Session["SelectedAddUsers"]);
            }
            set
            {
                Session["SelectedAddUsers"] = (List<int>)value;
            }
        }

        protected List<int> SelectedRemoveUsers
        {
            get
            {
                if (Session["SelectedRemoveUsers"] == null)
                    return new List<int>();
                else
                    return ((List<int>)Session["SelectedRemoveUsers"]);
            }
            set
            {
                Session["SelectedRemoveUsers"] = (List<int>)value;
            }
        }

        public List<int> CCUsers
        {
            get
            {
                return (Session["CCUsers"] == null ? null : (List<int>)Session["CCUsers"]);
            }
            set
            {
                Session["CCUsers"] = value;
            }
        }

        static string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
        CCListDataContext ccl = new CCListDataContext(connectionString);

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (CCUsers == null)
                {
                    LoadInitialCCGrid();
                }
                else
                {
                    DataTable dtCCUsers = new DataTable();
                    DataColumn dc1 = new DataColumn("UserID");
                    DataColumn dc2 = new DataColumn("UserName");
                    dtCCUsers.Columns.Add(dc1);
                    dtCCUsers.Columns.Add(dc2);
                    if (CCUsers != null)
                    {
                        foreach (int userId in CCUsers)
                        {
                            BusinessServices.User user = new BusinessServices.User();
                            DataTable dtUser = user.GetUser(userId);
                            DataRow dr = dtCCUsers.NewRow();
                            dr["UserID"] = (int) dtUser.Rows[0]["UserID"];
                            dr["UserName"] = dtUser.Rows[0]["UserName"].ToString();
                            dtCCUsers.Rows.Add(dr);
                        }

                        ccGridRowCount = dtCCUsers.Rows.Count;

                        CCListGrid.DataSource = dtCCUsers.DefaultView;
                        CCListGrid.DataBind();

                        if (CCListGrid.Rows.Count == 0)
                        {
                            lblCCNone.Visible = true;
                            RemoveSelected.Visible = false;
                            SelectAllCC.Visible = false;
                            ClearAllCC.Visible = false;
                        }
                        else
                        {
                            lblCCNone.Visible = false;
                            RemoveSelected.Visible = true;
                            SelectAllCC.Visible = true;
                            ClearAllCC.Visible = true;
                        }
                    }
                }

                SelectAll.Visible = false;
                ClearAll.Visible = false;
                AddSelected.Visible = false;
            }
           
        }

        protected void Find_OnClick(object sender, EventArgs e)
        {
            ReloadUserList();

            FoundUsers.Text = "Found " + userGridRowCount + " Users";
        }
          
        # region User Grid

        private void LoadInitialUserList()
        {
            CCListUserGrid.DataSource = null;
            CCListUserGrid.DataBind();

            BusinessServices.User objUser = new BusinessServices.User();
            DataTable dtbUserList = objUser.SearchUsers(UserContext.UserData.OrgID, FirstNameTextBox.Text, LastNameTextBox.Text, scheduleId);

            userGridRowCount = dtbUserList.Rows.Count;

            CCListUserGrid.DataSource = dtbUserList.DefaultView;
            CCListUserGrid.DataBind();

            if (CCListUserGrid.Rows.Count == 0)
            {
                lblUsersNone.Visible = true;
                SelectAll.Visible = false;
                ClearAll.Visible = false;
                AddSelected.Visible = false;
            }
            else
            {
                lblUsersNone.Visible = false;
                SelectAll.Visible = true;
                ClearAll.Visible = true;
                AddSelected.Visible = true;
            }
        }

        private void ReloadUserList()
        {
            if (Request.QueryString["scheduleid"] != null)
                Int32.TryParse(Request.QueryString["scheduleid"].ToString(), out this.scheduleId);
            BusinessServices.Report report = new BusinessServices.Report();
            DataTable dtbCCList = report.GetCCList(scheduleId);

            BusinessServices.User objUser = new BusinessServices.User();
            DataTable dtbUserList = objUser.SearchUsers(UserContext.UserData.OrgID, FirstNameTextBox.Text, LastNameTextBox.Text, scheduleId);

            dtbUserList.PrimaryKey = new DataColumn[] { dtbUserList.Columns["UserID"] };
            dtbCCList.PrimaryKey = new DataColumn[] { dtbCCList.Columns["UserID"] };

            foreach (DataRow row in dtbCCList.Rows)
            {
                int userId = 0;
                Int32.TryParse(row["UserID"].ToString(), out userId);

                DataView dvUser = dtbUserList.DefaultView;
                dvUser.RowFilter = "UserID = " + userId;

                if (dvUser.Count > 0)
                {
                    DataRow rowToDelete = dtbUserList.Rows.Find(userId);
                    dtbUserList.Rows.Remove(rowToDelete);

                }
            }

            foreach (int userId in SelectedAddUsers)
            {
                DataView dvUser = dtbUserList.DefaultView;
                dvUser.RowFilter = "UserID = " + userId;

                if (dvUser.Count > 0)
                {
                    DataRow rowToDelete = dtbUserList.Rows.Find(userId);
                    dtbUserList.Rows.Remove(rowToDelete);
                }
            }

            foreach (int userId in SelectedRemoveUsers)
            {
                DataRow rowToDelete = dtbUserList.Rows.Find(userId);

                if (rowToDelete == null)
                {
                    DataTable dtUser = objUser.GetUser(userId);

                    DataRow drUser = dtbUserList.NewRow();
                    drUser["UserID"] = userId;
                    drUser["FirstName"] = dtUser.Rows[0]["FirstName"];
                    drUser["LastName"] = dtUser.Rows[0]["LastName"];
                    drUser["UserName"] = dtUser.Rows[0]["UserName"];
                    drUser["Email"] = dtUser.Rows[0]["Email"];
                    dtbUserList.Rows.Add(drUser);
                }
            }

            DataView dvUserSource = dtbUserList.DefaultView;
            dvUserSource.RowFilter = "";

            userGridRowCount = dtbUserList.Rows.Count;

            CCListUserGrid.DataSource = dtbUserList.DefaultView;
            CCListUserGrid.DataBind();


            if (CCListUserGrid.Rows.Count == 0)
            {
                lblUsersNone.Visible = true;
                SelectAll.Visible = false;
                ClearAll.Visible = false;
                AddSelected.Visible = false;
            }
            else
            {
                lblUsersNone.Visible = false;
                SelectAll.Visible = true;
                ClearAll.Visible = true;
                AddSelected.Visible = true;
            }
        }

        protected void CCListUserGrid_Sorted(object sender, EventArgs e)
        {
            SelectAll.Checked = false;
            ClearAll.Checked = false;
        }

        protected void CCListUserGrid_PreRender(object sender, EventArgs e)
        {

            GridViewRow pagerRow = CCListUserGrid.BottomPagerRow;

            if (pagerRow != null && pagerRow.Visible == false)
                pagerRow.Visible = true;

        }

        protected void CCListUserGrid_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            for (int i = 0; i < e.Row.Cells.Count; i++)
            {
                e.Row.Cells[i].Attributes.Add("style", "white-space: nowrap;");
            }
        }

        protected void CCListUserGrid_DataBound(Object sender, EventArgs e)
        {

            // Retrieve the pager row.
            GridViewRow pagerRow = CCListUserGrid.BottomPagerRow;
            if (pagerRow == null)
                return;

            // Retrieve the DropDownList and Label controls from the row.
            DropDownList pageList = (DropDownList)pagerRow.Cells[0].FindControl("PageDropDownList");
            Label pageLabel = (Label)pagerRow.Cells[0].FindControl("CurrentPageLabel");

            if (pageList != null)
            {

                // Create the values for the DropDownList control based on 
                // the  total number of pages required to display the data
                // source.
                for (int i = 0; i < CCListUserGrid.PageCount; i++)
                {

                    // Create a ListItem object to represent a page.
                    int pageNumber = i + 1;
                    ListItem item = new ListItem(pageNumber.ToString());

                    // If the ListItem object matches the currently selected
                    // page, flag the ListItem object as being selected. Because
                    // the DropDownList control is recreated each time the pager
                    // row gets created, this will persist the selected item in
                    // the DropDownList control.   
                    if (i == CCListUserGrid.PageIndex)
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
                int currentPage = CCListUserGrid.PageIndex + 1;

                // Update the Label control with the current page information.
                pageLabel.Text = " Of " + CCListUserGrid.PageCount.ToString()
                               + " :    " + (CCListUserGrid.PageIndex * CCListUserGrid.PageSize + 1) + " -- " + (CCListUserGrid.PageIndex * CCListUserGrid.PageSize + CCListUserGrid.Rows.Count) + " Of " + userGridRowCount;
            }
        }

        protected void PageDropDownList_CCListUserGrid_SelectedIndexChanged(Object sender, EventArgs e)
        {

            // Retrieve the pager row.
            GridViewRow pagerRow = CCListUserGrid.BottomPagerRow;

            // Retrieve the PageDropDownList DropDownList from the bottom pager row.
            DropDownList pageList = (DropDownList)pagerRow.Cells[0].FindControl("PageDropDownList");

            // Set the PageIndex property to display that page selected by the user.
            CCListUserGrid.PageIndex = pageList.SelectedIndex;

            ReloadUserList();
        }

        protected void AddSelected_Click(object sender, EventArgs e)
        {
            foreach (GridViewRow user in CCListUserGrid.Rows)
            {
                CheckBox cb = (CheckBox)user.FindControl("UserSelector");
                if ((cb != null) && (cb.Checked))
                {
                    int userID = (int)CCListUserGrid.DataKeys[user.RowIndex].Values["UserID"];
                    List<int> selectedAddUsers = SelectedAddUsers;
                    selectedAddUsers.Add(userID);
                    SelectedAddUsers = selectedAddUsers;

                    List<int> selectedRemoveUsers = SelectedRemoveUsers;
                    if (selectedRemoveUsers.Contains(userID))
                    {
                        selectedRemoveUsers.Remove(userID);
                        SelectedRemoveUsers = selectedRemoveUsers;
                    }
                }
            }

            ReloadUserList();
            ReloadCCList();

            SelectAll.Checked = false;
            ClearAll.Checked = false;
        }

        protected void SelectAll_CheckedChanged(object sender, EventArgs e)
        {
            foreach (GridViewRow user in CCListUserGrid.Rows)
            {
                CheckBox cb = (CheckBox)user.FindControl("UserSelector");
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
                foreach (GridViewRow user in CCListUserGrid.Rows)
                {
                    CheckBox cb = (CheckBox)user.FindControl("UserSelector");
                    if (cb != null)
                    {
                        cb.Checked = !ClearAll.Checked;
                    }
                }

                SelectAll.Checked = false;
            }
        }

        protected void CCListUserGrid_RowCommand(Object sender, GridViewCommandEventArgs e)
        {
            int rowIndex = Int32.Parse(e.CommandArgument.ToString());

            if (CCListUserGrid.Rows.Count > 0)
            {
                if (e.CommandName == "Add")
                {
                    int userID = (int)CCListUserGrid.DataKeys[rowIndex].Values["UserID"];
                    List<int> selectedAddUsers = SelectedAddUsers;
                    selectedAddUsers.Add(userID);
                    SelectedAddUsers = selectedAddUsers;

                    List<int> selectedRemoveUsers = SelectedRemoveUsers;
                    if (selectedRemoveUsers.Contains(userID))
                    {
                        selectedRemoveUsers.Remove(userID);
                        SelectedRemoveUsers = selectedRemoveUsers;
                    }
                }
            }

            ReloadUserList();
            ReloadCCList();
        }

        #endregion

        # region CC Grid

        private void LoadInitialCCGrid()
        {
            if (Request.QueryString["scheduleid"] != null)
                Int32.TryParse(Request.QueryString["scheduleid"].ToString(), out this.scheduleId);
            BusinessServices.Report report = new BusinessServices.Report();
            DataTable dtbCCList = report.GetCCList(scheduleId);

            ccGridRowCount = dtbCCList.Rows.Count;

            CCListGrid.DataSource = dtbCCList.DefaultView;
            CCListGrid.DataBind();

            if (CCListGrid.Rows.Count == 0)
            {
                lblCCNone.Visible = true;
                RemoveSelected.Visible = false;
                SelectAllCC.Visible = false;
                ClearAllCC.Visible = false;
            }
            else
            {
                lblCCNone.Visible = false;
                RemoveSelected.Visible = true;
                SelectAllCC.Visible = true;
                ClearAllCC.Visible = true;
            }
        }

        private DataTable getCCUsers()
        {
            DataTable dtCCUsers = new DataTable();
            DataColumn dc0 = new DataColumn("UserId");
            DataColumn dc1 = new DataColumn("UserName");
            dtCCUsers.Columns.Add(dc0);
            dtCCUsers.Columns.Add(dc1);
            if (CCUsers != null)
            {
                foreach (int userId in CCUsers)
                {
                    BusinessServices.User user = new BusinessServices.User();
                    DataTable dtUser = user.GetUser(userId);
                    DataRow dr = dtCCUsers.NewRow();
                    dr["UserId"] = userId;
                    dr["UserName"] = dtUser.Rows[0]["UserName"].ToString();
                    dtCCUsers.Rows.Add(dr);
                }
            }
            return dtCCUsers;
        }

        private void ReloadCCList()
        {
            DataTable dtbCCList = new DataTable();
            if (Request.QueryString["scheduleid"] != null)
            {
                Int32.TryParse(Request.QueryString["scheduleid"].ToString(), out this.scheduleId);
                BusinessServices.Report report = new BusinessServices.Report();
                dtbCCList = report.GetCCList(scheduleId);
            }
            else
                dtbCCList = getCCUsers();

            BusinessServices.User objUser = new BusinessServices.User();
            //DataTable dtbUserList = objUser.SearchUsers(UserContext.UserData.OrgID, FirstNameTextBox.Text, LastNameTextBox.Text, scheduleId);

            //dtbUserList.PrimaryKey = new DataColumn[] { dtbUserList.Columns["UserID"] };
            dtbCCList.PrimaryKey = new DataColumn[] { dtbCCList.Columns["UserID"] };

            //foreach (DataRow row in dtbUserList.Rows)
            //{
            //    int userId = 0;
            //    Int32.TryParse(row["UserID"].ToString(), out userId);

            //    DataView dvCC = dtbCCList.DefaultView;
            //    dvCC.RowFilter = "UserID = " + userId;

            //    if (dvCC.Count > 0)
            //    {
            //        DataRow rowToDelete = dtbCCList.Rows.Find(userId);
            //        dtbCCList.Rows.Remove(rowToDelete);

            //    }
            //}

            foreach (int userId in SelectedRemoveUsers)
            {
                DataView dvCC = dtbCCList.DefaultView;
                dvCC.RowFilter = "UserID = " + userId;

                if (dvCC.Count > 0)
                {
                    DataRow rowToDelete = dtbCCList.Rows.Find(userId);
                    dtbCCList.Rows.Remove(rowToDelete);
                }
            }

            foreach (int userId in SelectedAddUsers)
            {
                DataRow rowToDelete = dtbCCList.Rows.Find(userId);

                if (rowToDelete == null)
                {
                    DataTable dtUser = objUser.GetUser(userId);

                    DataRow drCC = dtbCCList.NewRow();
                    drCC["UserID"] = userId;
                    drCC["UserName"] = dtUser.Rows[0]["UserName"];
                    dtbCCList.Rows.Add(drCC);
                }
            }

            DataView dvCCSource = dtbCCList.DefaultView;
            dvCCSource.RowFilter = "";

            ccGridRowCount = dtbCCList.Rows.Count;

            CCListGrid.DataSource = dtbCCList.DefaultView;
            CCListGrid.DataBind();


            if (CCListGrid.Rows.Count == 0)
            {
                lblCCNone.Visible = true;
                RemoveSelected.Visible = false;
                SelectAllCC.Visible = false;
                ClearAllCC.Visible = false;
            }
            else
            {
                lblCCNone.Visible = false;
                RemoveSelected.Visible = true;
                SelectAllCC.Visible = true;
                ClearAllCC.Visible = true;
            }
        }

        protected void RemoveSelected_Click(object sender, EventArgs e)
        {
            foreach (GridViewRow user in CCListGrid.Rows)
            {
                CheckBox cb = (CheckBox)user.FindControl("CCSelector");
                if ((cb != null) && (cb.Checked))
                {
                    int userID = 0;

                    Int32.TryParse(CCListGrid.DataKeys[user.RowIndex].Values["UserID"].ToString(), out userID);

                    // Remove user from CC
                    List<int> selectedRemoveUsers = SelectedRemoveUsers;
                    selectedRemoveUsers.Add(userID);
                    SelectedRemoveUsers = selectedRemoveUsers;

                    List<int> selectedAddUsers = SelectedAddUsers;
                    if (selectedAddUsers.Contains(userID))
                    {
                        selectedAddUsers.Remove(userID);
                        SelectedAddUsers = selectedAddUsers;
                    }
                }
            }

            ReloadCCList();
            ReloadUserList();

            SelectAllCC.Checked = false;
            ClearAllCC.Checked = false;
        }

        protected void SelectAllCC_CheckedChanged(object sender, EventArgs e)
        {
            foreach (GridViewRow user in CCListGrid.Rows)
            {
                CheckBox cb = (CheckBox)user.FindControl("CCSelector");
                if (cb != null)
                {
                    cb.Checked = SelectAllCC.Checked;
                }
            }
            if (SelectAll.Checked == true)
                ClearAll.Checked = false;
        }

        protected void ClearAllCC_CheckedChanged(object sender, EventArgs e)
        {
            if (ClearAll.Checked == true)
            {
                foreach (GridViewRow user in CCListGrid.Rows)
                {
                    CheckBox cb = (CheckBox)user.FindControl("CCSelector");
                    if (cb != null)
                    {
                        cb.Checked = !ClearAll.Checked;
                    }
                }

                SelectAllCC.Checked = false;
            }
        }

        protected void CCListGrid_Sorted(object sender, EventArgs e)
        {
            SelectAllCC.Checked = false;
            ClearAllCC.Checked = false;
        }

        protected void CCListGrid_PreRender(object sender, EventArgs e)
        {

            GridViewRow pagerRow = CCListGrid.BottomPagerRow;

            if (pagerRow != null && pagerRow.Visible == false)
                pagerRow.Visible = true;

        }

        protected void CCListGrid_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            for (int i = 0; i < e.Row.Cells.Count; i++)
            {
                e.Row.Cells[i].Attributes.Add("style", "white-space: nowrap;");
            }
        }

        protected void CCListGrid_DataBound(Object sender, EventArgs e)
        {

                // Retrieve the pager row.
                GridViewRow pagerRow = CCListGrid.BottomPagerRow;
                if (pagerRow == null)
                    return;

                // Retrieve the DropDownList and Label controls from the row.
                DropDownList pageList = (DropDownList)pagerRow.Cells[0].FindControl("PageDropDownList2");
                Label pageLabel = (Label)pagerRow.Cells[0].FindControl("CurrentPageLabel2");
 

            if (pageList != null)
            {

                // Create the values for the DropDownList control based on 
                // the  total number of pages required to display the data
                // source.
                for (int i = 0; i < CCListGrid.PageCount; i++)
                {

                    // Create a ListItem object to represent a page.
                    int pageNumber = i + 1;
                    ListItem item = new ListItem(pageNumber.ToString());

                    // If the ListItem object matches the currently selected
                    // page, flag the ListItem object as being selected. Because
                    // the DropDownList control is recreated each time the pager
                    // row gets created, this will persist the selected item in
                    // the DropDownList control.   
                    if (i == CCListUserGrid.PageIndex)
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
                int currentPage = CCListGrid.PageIndex + 1;


                // Update the Label control with the current page information.
                pageLabel.Text = " Of " + CCListGrid.PageCount.ToString()
                               + " :    " + (CCListGrid.PageIndex * CCListGrid.PageSize + 1) + " -- " + (CCListGrid.PageIndex * CCListGrid.PageSize + CCListGrid.Rows.Count) + " Of " + ccGridRowCount;

            }
        }

        protected void PageDropDownList_CCListGrid_SelectedIndexChanged(Object sender, EventArgs e)
        {

            // Retrieve the pager row.
            GridViewRow pagerRow = CCListGrid.BottomPagerRow;

            // Retrieve the PageDropDownList DropDownList from the bottom pager row.
            DropDownList pageList = (DropDownList)pagerRow.Cells[0].FindControl("PageDropDownList2");

            // Set the PageIndex property to display that page selected by the user.
            CCListGrid.PageIndex = pageList.SelectedIndex;

            ReloadCCList();
        }

        protected void CCListGrid_RowCommand(Object sender, GridViewCommandEventArgs e)
        {
            int rowIndex = Convert.ToInt32(e.CommandArgument); 

            if (e.CommandName == "Remove")
            {
                int userID = 0;

                Int32.TryParse(CCListGrid.DataKeys[rowIndex].Values["UserID"].ToString(), out userID);

                // Remove user from CC
                List<int> selectedRemoveUsers = SelectedRemoveUsers;
                selectedRemoveUsers.Add(userID);
                SelectedRemoveUsers = selectedRemoveUsers;

                List<int> selectedAddUsers = SelectedAddUsers;
                if (selectedAddUsers.Contains(userID))
                {
                    selectedAddUsers.Remove(userID);
                    SelectedAddUsers = selectedAddUsers;
                }
            }
            ReloadCCList();
            ReloadUserList();
        }

        #endregion

        protected void Save_OnClick(object sender, EventArgs e)
        {
            if (Request.QueryString["scheduleid"] != null)
                Int32.TryParse(Request.QueryString["scheduleid"].ToString(), out this.scheduleId);
            BusinessServices.Report report = new BusinessServices.Report();
            BusinessServices.User user = new BusinessServices.User();
            DataTable dtbCCList = report.GetCCList(scheduleId);

            foreach (int userId in SelectedAddUsers)
            {
                DataRow dr = dtbCCList.NewRow();
                dr["UserID"] = userId;
                DataTable dtUser = user.GetUser(userId);
                dr["Username"] = dtUser.Rows[0]["UserName"].ToString();
                dtbCCList.Rows.Add(dr);
            }

            foreach (int userId in SelectedRemoveUsers)
            {
                for (int i = 0; i < dtbCCList.Rows.Count; i++)
                {
                    int rowUserId = 0;
                    Int32.TryParse(dtbCCList.Rows[i]["UserID"].ToString(), out rowUserId);
                    if (rowUserId == userId)
                        dtbCCList.Rows.RemoveAt(i);
                }
                //DataRow dr = dtbCCList.NewRow();
                //dr["UserID"] = userId;
                //DataTable dtUser = user.GetUser(userId);
                //dr["Username"] = dtUser.Rows[0]["UserName"].ToString();
                //dtbCCList.Rows.Remove(dr);
            }

            List<int> CC = new List<int>();
            List<DataRow> drList = dtbCCList.AsEnumerable().ToList<DataRow>();
            foreach (DataRow dr in drList)
            {
                int CCUserId = 0;
                Int32.TryParse(dr["UserID"].ToString(), out CCUserId);
                CC.Add(CCUserId);
            }

            //if (CCUsers == null)
                CCUsers = CC;

            //ClientScript.RegisterStartupScript(this.GetType(), "closeOnSave", "<script language='javascript'>opener.focus();opener.location.href = (opener.location + '&fromCC=true'); self.close();</script>");
                ClientScript.RegisterStartupScript(this.GetType(), "closeOnSave", "<script language='javascript'>opener.focus();opener.__doPostBack('CCGridUpdatePanel', ''); self.close();</script>");
        }

        protected void Cancel_OnClick(object sender, EventArgs e)
        {
            SelectedAddUsers = null;
            SelectedRemoveUsers = null;

            ClientScript.RegisterStartupScript(this.GetType(), "close", "<script language='javascript'>if (confirm('All changes made to this form will be lost?')==true) { opener.focus(); opener.location.href = (opener.location + '&fromCC=true'); self.close(); }</script>");
        }

    }
}
