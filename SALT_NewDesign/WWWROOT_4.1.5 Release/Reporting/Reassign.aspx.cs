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

namespace Bdw.Application.Salt.Web.Reporting
{
    public partial class Reassign : System.Web.UI.Page
    {
        private int scheduleId;

        int selectedUser;

        protected int UserCount
        {
            get
            {
                if ((object)ViewState["UserCount"] == null)
                    return 0;
                else
                    return (int)ViewState["UserCount"];
            }
            set 
            {
                ViewState["UserCount"] = value;
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

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["scheduleid"] != null)
                Int32.TryParse(Request.QueryString["scheduleid"].ToString(), out this.scheduleId);
        }

        protected void Find_OnClick(object sender, EventArgs e)
        {
            LoadUserList();
        }

        private void LoadUserList()
        {
            BusinessServices.User objUser = new BusinessServices.User();
            DataTable dtbSearchResults = objUser.SearchAdminUsers(UserContext.UserData.OrgID, FirstNameTextBox.Text, LastNameTextBox.Text);

            UserCount = dtbSearchResults.Rows.Count;

            ReassignUserGrid.DataSource = dtbSearchResults.DefaultView;
            ReassignUserGrid.DataBind();

            if (ReassignUserGrid.Rows.Count == 0)
            {
                lblUsersNone.Visible = true;
            }
            else
            {
                lblUsersNone.Visible = false;
            }
        }

        protected void ReassignUserGrid_PreRender(object sender, EventArgs e)
        {

            GridViewRow pagerRow = ReassignUserGrid.BottomPagerRow;

            if (pagerRow != null && pagerRow.Visible == false)
                pagerRow.Visible = true;

        }

        protected void ReassignUserGrid_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            for (int i = 0; i < e.Row.Cells.Count; i++)
            {
                e.Row.Cells[i].Attributes.Add("style", "white-space: nowrap;");
            }
        }

        protected void ReassignUserGrid_DataBound(Object sender, EventArgs e)
        {

            // Retrieve the pager row.
            GridViewRow pagerRow = ReassignUserGrid.BottomPagerRow;
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
                for (int i = 0; i < ReassignUserGrid.PageCount; i++)
                {

                    // Create a ListItem object to represent a page.
                    int pageNumber = i + 1;
                    ListItem item = new ListItem(pageNumber.ToString());

                    // If the ListItem object matches the currently selected
                    // page, flag the ListItem object as being selected. Because
                    // the DropDownList control is recreated each time the pager
                    // row gets created, this will persist the selected item in
                    // the DropDownList control.   
                    if (i == ReassignUserGrid.PageIndex)
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
                int currentPage = ReassignUserGrid.PageIndex + 1;


                // Update the Label control with the current page information.
                pageLabel.Text = " Of " + ReassignUserGrid.PageCount.ToString()
                               + " :    " + (ReassignUserGrid.PageIndex * ReassignUserGrid.PageSize + 1) + " -- " + (ReassignUserGrid.PageIndex * ReassignUserGrid.PageSize + ReassignUserGrid.Rows.Count) + " Of " + UserCount;

            }
        }

        protected void PageDropDownList_SelectedIndexChanged(Object sender, EventArgs e)
        {

            // Retrieve the pager row.
            GridViewRow pagerRow = ReassignUserGrid.BottomPagerRow;

            // Retrieve the PageDropDownList DropDownList from the bottom pager row.
            DropDownList pageList = (DropDownList)pagerRow.Cells[0].FindControl("PageDropDownList");

            // Set the PageIndex property to display that page selected by the user.
            ReassignUserGrid.PageIndex = pageList.SelectedIndex;

            LoadUserList();
        }

        protected void Save_OnClick(object sender, EventArgs e)
        {
            string strUser = Request.Form["gvradio"];

            if (strUser == null)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "select", "<script language='javascript'>confirm('A user must be selected'); </script>");
                return;
            }

            Int32.TryParse(strUser, out selectedUser);
            
            bool isOnInactivate = false;
            if (Request.QueryString["isoninactivate"] != null)
            {
                Boolean.TryParse(Request.QueryString["isoninactivate"].ToString(), out isOnInactivate);
            }

            if (isOnInactivate)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "close", "<script language='javascript'>opener.focus();opener.location.href = opener.location + '&reassignuser=" + selectedUser + "&fromreassignpage=true'; self.close();</script>");
            }
            else
            {
                BusinessServices.Report report = new BusinessServices.Report();
                //if (this.scheduleId > 0)
                //{
                //    report.ReassignReport(this.scheduleId, selectedUser);
                //    ClientScript.RegisterStartupScript(this.GetType(), "close", "<script language='javascript'>opener.focus();opener.location.href = opener.location + '&fromreassignpage=true'; self.close();</script>");
                //}
                //else
                //{
                    foreach (int schId in ScheduleIds)
                    {
                        report.ReassignReport(schId, selectedUser);
                    }
                    ScheduleIds = null;
                    ClientScript.RegisterStartupScript(this.GetType(), "close", "<script language='javascript'>opener.focus();opener.location.href = opener.location + '?fromreassignpage=true'; self.close();</script>");
                //}
            }
        }

        protected void Cancel_OnClick(object sender, EventArgs e)
        {
            bool isOnInactivate = false;
            if (Request.QueryString["isoninactivate"] != null)
            {
                Boolean.TryParse(Request.QueryString["isoninactivate"].ToString(), out isOnInactivate);
            }

            if (isOnInactivate)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "close", "<script language='javascript'>if (confirm('All changes made to this form will be lost?')==true) { opener.focus(); opener.location.href = opener.location + '&fromreassignpage=true'; self.close(); }</script>");
            }
            else
            {
                //if (this.scheduleId > 0)
                //{
                //    ClientScript.RegisterStartupScript(this.GetType(), "close", "<script language='javascript'>if (confirm('All changes made to this form will be lost?')==true) { opener.focus(); opener.location.href = opener.location + '&fromreassignpage=true'; self.close(); }</script>");
                //}
                //else
                //{
                    ClientScript.RegisterStartupScript(this.GetType(), "close", "<script language='javascript'>if (confirm('All changes made to this form will be lost?')==true) { opener.focus(); opener.location.href = opener.location + '?fromreassignpage=true'; self.close(); }</script>");
                //}
            }
        }
    }
}
