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

using System.IO;
using System.Configuration;

using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.Data;
using Localization;
using System.Collections.Generic;
using Bdw.Application.Salt.Web.Reporting;
using System.Data.Linq;
using System.Linq;

namespace Bdw.Application.Salt.Web.Administration.Users
{
	/// <summary>
	/// Summary description for ArchiveUsers.
	/// </summary>
	public partial class ArchiveUsers : System.Web.UI.Page
	{
		#region declaration 
		protected System.Web.UI.HtmlControls.HtmlTable tblSearchCriteria;
		#endregion
	
		#region private methods
		/// <summary>
		/// Get Data
		/// </summary>
		/// <returns></returns>
		private DataView GetData()
		{
			DataTable dt= null;
			//DataTable dtb = null;
			DateTime dTime;
			int i = 0;
			

			try
			{
				

				if (this.chkIncludeNewUsers.Checked)
				{
					i = 1;
				}
			
				dTime = new DateTime(int.Parse(cboYear.SelectedValue),int.Parse(cboMonth.SelectedValue),int.Parse(cboDay.SelectedValue));
						
				Bdw.Application.Salt.BusinessServices.User u = new User();

				dt = u.GetArchiveUsers(dTime,i,UserContext.UserData.OrgID, UserContext.UserID);					
			}
			catch(Exception ex)
			{
				lblError.Text = ex.ToString();
				lblError.CssClass = "WarningMessage";
				lblError.Visible = true;
			}

			return dt.DefaultView;
		}
		/// <summary>
		/// Set order field
		/// </summary>
		/// <param name="orderByField"></param>
		private void SetSortOrder(string orderByField)
		{
			string	strOldOrderByField, strOldOrderByDirection;
			string  strOrderByDirection;

			// Get from viewstate
			strOldOrderByField =(string)ViewState["OrderByField"];
			strOldOrderByDirection =(string)ViewState["OrderByDirection"];

			// Compare to desired sort field
			if(strOldOrderByField == orderByField)
			{
				switch(strOldOrderByDirection.ToUpper())
				{
					case "ASC":
						strOrderByDirection = "DESC";
						break;
					case "DESC":
						strOrderByDirection = "ASC";
						break;
					default:
						strOrderByDirection = "ASC";
						break;
				}
			}
			else
			{
				strOrderByDirection = "ASC";
			}

			//save the order by direction and field to the view state.
			ViewState["OrderByField"] = orderByField;
			ViewState["OrderByDirection"] = strOrderByDirection;
		}

		/// <summary>
		/// Show Paging Data
		/// </summary>
		private void ShowData(int pageIndex)
		{
			//1. Get data
			DataView  dvwPagination = GetData();
			int intRowCount = dvwPagination.Table.Rows.Count; 
			if (intRowCount > 0)
			{
				//2. Use pagination if necessary
				if (intRowCount > ApplicationSettings.PageSize)
				{
					if(intRowCount > 100)
					{
						dgrResults.PageSize = 50;
					}
					dgrResults.AllowPaging=true;
					dgrResults.CurrentPageIndex = pageIndex;
				}
				else
				{
					dgrResults.PageSize = ApplicationSettings.PageSize;
					dgrResults.AllowPaging=false;
				}
				if (intRowCount > 1)
				{
					//3. Sort Data
					dgrResults.AllowSorting=true;
					dvwPagination.Sort = (string)ViewState["OrderByField"] + " " + (string)ViewState["OrderByDirection"];
				}
				else
				{
					dgrResults.AllowSorting=false;
				}

				
				// reset the list of users to archive
				this.txtUserIDs.Text="";
				foreach (DataRow drwItem in dvwPagination.Table.Rows)
				{
					this.txtUserIDs.Text += drwItem.ItemArray[6].ToString() + ",";
				}
				if (this.txtUserIDs.Text.Length>0)
				{
					this.txtUserIDs.Text = (this.txtUserIDs.Text.Substring(0,this.txtUserIDs.Text.Length-1));
				}
			
				//4. Bind Data
				dgrResults.DataSource = dvwPagination;
				dgrResults.DataKeyField = "UserID";
				dgrResults.DataBind();
				lblUserCount.Text = String.Format(ResourceManager.GetString("lblUserCount"), intRowCount.ToString());
				plhPreviewUsers.Visible=true;
				lblError.Visible = false;
				btnArchiveUsers.Visible = true;
			}
			else
			{
				lblError.Text = ResourceManager.GetString("lblMessage.NoUsersFound");
				lblError.CssClass = "FeedbackMessage";
				lblError.Visible = true;
				plhPreviewUsers.Visible = false;
				btnArchiveUsers.Visible = false;
			}
			
		}
		#endregion
		#region Private Event Handlers

		/// <summary>
		/// 
		/// </summary>
		/// <param name="source"></param>
		/// <param name="e"></param>
		private void dgrResults_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
		{
			ShowData(e.NewPageIndex);
		}


		private void dgrResults_ItemDataBound(object sender, DataGridItemEventArgs e)
		{
			if(e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
			{
				DataRowView drv = (DataRowView)e.Item.DataItem;
				Label lblLastLogin = (Label)e.Item.FindControl("lblLastLogin");

				//-- French culture does not support AMPM
				if (drv["LastLogin"].ToString() != "Never")
				{
					string ampm = "AM";
					if (Int32.Parse(DateTime.Parse(drv["LastLogin"].ToString()).ToString("%H")) >= 12)
						ampm = "PM";

					lblLastLogin.Text = DateTime.Parse(drv["LastLogin"].ToString()).ToString("d/MM/yyyy h:mm") + " " + ampm;
				}
				else
					lblLastLogin.Text = ResourceManager.GetString("lblNever");

				//TODO: Remove this watch line.
				lblLastLogin.Text = lblLastLogin.Text;

			}
		}

        protected void btnPeriodicReport_Click(object sender, EventArgs e)
        {
            int periodicReportsCount = SelectCountUsers();
            if (periodicReportsCount > 0)
                Response.Redirect("~/Reporting/PeriodicReportList.aspx?isoninactivate=true");
            else
            {
                // todo: localise
                this.lblError.Visible = true;
                this.lblError.Text = "No Periodic Reports found";
                this.lblError.CssClass = "FeedbackMessage";
            }
        }

        private int SelectCountUsers()
        {
            int OrgID = UserContext.UserData.OrgID;
            List<string> inactivatedUsernames = (List<string>)Session["InactivatedUsernames"];

            List<prcGetPeriodicReportListOnInactivateUserResult> InactiveSchedules = new List<prcGetPeriodicReportListOnInactivateUserResult>();
            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

            PeriodicReportListDataContext prl = new PeriodicReportListDataContext(connectionString);

            foreach (string username in inactivatedUsernames)
            {
                ISingleResult<prcGetPeriodicReportListOnInactivateUserResult> result = prl.prcGetPeriodicReportListOnInactivateUser(OrgID, username);
                var qry = from pr in result.AsQueryable<prcGetPeriodicReportListOnInactivateUserResult>() select pr;
                InactiveSchedules.AddRange(qry.ToList<prcGetPeriodicReportListOnInactivateUserResult>());
            }

            var query = InactiveSchedules.AsQueryable<prcGetPeriodicReportListOnInactivateUserResult>();

            return query.Count<prcGetPeriodicReportListOnInactivateUserResult>();
        }

		protected void btnArchiveUsers_Click(object sender, System.EventArgs e)
		{
			if(txtUserIDs.Text != "")
			{
				Bdw.Application.Salt.BusinessServices.User u = new User();
				u.ArchiveUsers(txtUserIDs.Text,UserContext.UserID);

				lblError.Text = ResourceManager.GetString("lblMessage.UsersArchived");
				lblError.CssClass = "FeedbackMessage";
				lblError.Visible = true;
				plhPreviewUsers.Visible = false;
				btnArchiveUsers.Visible = false;

                // for periodic reports owned by archived users
                Session["InactivatedUsernames"] = null;
                string[] archivedUserIds = txtUserIDs.Text.Split(new char[] {','});
                List<string> inactivatedUsernames = new List<string>();
                for (int i = 0; i < archivedUserIds.Length; i++)
                {
                    int userid = 0;
                    Int32.TryParse(archivedUserIds[i], out userid);
                    BusinessServices.User user = new BusinessServices.User();
                    DataTable dtUser = user.GetUser(userid);
                    string username = dtUser.Rows[0]["UserName"].ToString();
                    inactivatedUsernames.Add(username);
                }
                Session["InactivatedUsernames"] = inactivatedUsernames;

                btnPeriodicReport.Visible = true;
			}
		}
		
		protected void btnPreview_Click(object sender, System.EventArgs e)
		{
            this.btnPeriodicReport.Visible = false;

			if (cboYear.SelectedValue.ToString() != "" && cboDay.SelectedValue.ToString() != "" && cboMonth.SelectedValue.ToString() != "")
			{
				if( Bdw.Application.Salt.Web.Utilities.WebTool.ValidateHistoricDateControl(cboDay,cboMonth,cboYear))
				{
					ShowData(0);
				}
				else
				{
					lblError.Text = ResourceManager.GetString("lblMessage.SelectPastDate");
					lblError.CssClass = "WarningMessage";
					lblError.Visible = true;
				}
			}
			else
			{
				lblError.Text = ResourceManager.GetString("lblMessage.SelectDate");
				lblError.CssClass = "WarningMessage";
				lblError.Visible = true;
			}
				
		}

		protected void Page_Load(object sender, System.EventArgs e)
		{
			this.lblPageTitle.Text = ResourceManager.GetString("lblPageTitle");
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			if(!Page.IsPostBack)
			{
				Bdw.Application.Salt.Web.Utilities.WebTool.SetupHistoricDateControl(cboDay, cboMonth, cboYear);

			}

			SetSortOrder("LastName");
		}
		#endregion
		
		#region Web Form Designer generated code
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
			this.dgrResults.PageIndexChanged += new System.Web.UI.WebControls.DataGridPageChangedEventHandler(this.dgrResults_PageIndexChanged);
			this.dgrResults.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(this.dgrResults_ItemDataBound);

		}


		#endregion




	}
}
