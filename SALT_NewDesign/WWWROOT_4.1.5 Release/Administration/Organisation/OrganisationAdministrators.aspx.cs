using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Globalization;
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.Utilities;
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.BusinessServices;
using Localization;
using Bdw.Application.Salt.Web.Reporting;
using System.Configuration;
using System.Linq;
using System.Data.Linq;

namespace Bdw.Application.Salt.Web.Administration.Organisation
{
	/// <summary>
	/// This class controls the page and business logic for the ModifyLinks.aspx page.
	/// </summary>
	/// <remarks>
	/// Assumptions: None.
	/// Notes: None.
	/// Author: Peter Vranich
	/// Date: 12/02/0/2004
	/// Changes:
	/// </remarks>
	public partial class OrganisationAdministrators : System.Web.UI.Page
	{
		#region Protected Controls
		/// <summary>
		/// The dropdown list for the pagination.
		/// </summary>
		protected System.Web.UI.WebControls.DropDownList cboPage;
		
		/// <summary>
		/// The label for the page count.
		/// </summary>
		protected System.Web.UI.WebControls.Label lblPageCount;
		
		/// <summary>
		/// The label for the current page record count.
		/// </summary>
		protected System.Web.UI.WebControls.Label lblCurrentPageRecordCount;
		
		/// <summary>
		/// The label for the total record count.
		/// </summary>
		protected System.Web.UI.WebControls.Label lblTotalRecordCount;
		
		/// <summary>
		/// The button for navigating to the previous page.
		/// </summary>
		protected System.Web.UI.WebControls.LinkButton btnPrev;
		
		/// <summary>
		/// The datagrid for the results of the search.
		/// </summary>
		protected System.Web.UI.WebControls.DataGrid grdPagination;
		
		/// <summary>
		/// The table for the search results and pagination controls.
		/// </summary>
		protected System.Web.UI.HtmlControls.HtmlTable tblPagination;
		
		/// <summary>
		/// The table row for the pagination controls.
		/// </summary>
		protected System.Web.UI.HtmlControls.HtmlTableRow trPagination;
		
		/// <summary>
		/// Link button for navigating to the next page of the datagrid.
		/// </summary>
		protected System.Web.UI.WebControls.LinkButton btnNext;
		
		/// <summary>
		/// The label to hold any messages that need to be displayed to the user.
		/// </summary>
		protected System.Web.UI.WebControls.Label lblMessage;
		
		/// <summary>
		/// Link button to pass control to the Add Organisation Administrator page.
		/// </summary>
		protected System.Web.UI.WebControls.LinkButton lnkAddOrganisationAdministrator;

        /// <summary>
        /// Label for page title
        /// </summary>
        protected System.Web.UI.WebControls.Label lblPageTitle;
		
		/// <summary>
		/// Link button to return to the org admin details page.
		/// </summary>
		protected System.Web.UI.WebControls.LinkButton lnkReturnToOrgAdmin;
		#endregion
		
		#region Private Event Handlers
		/// <summary>
		/// Event handler method for the Page Load event.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
            ResourceManager.RegisterLocaleResource("RemoveConfirm");
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			if(!Page.IsPostBack)
			{
				this.SetPageState();
			}
		} // Page_Load
		
		/// <summary>
		/// Event handler method for the Remove Admin button.
		/// </summary>
		/// <param name="e"> Any arguments that the event fires.</param>
		/// <param name="source">The source of the event</param>
		private void grdPagination_UpdateCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
		{
			//1. Get the UserID
			int intUserID = (int)this.grdPagination.DataKeys[e.Item.ItemIndex];
			
			//2. Get the original updated datetime.
			DataRowView drvAdminDetails = (DataRowView)e.Item.DataItem;
			DateTime dtOriginalUpdatedDate = DateTime.Parse(e.CommandArgument.ToString());
			
			//3. Remove the user.
			this.RemoveAdministrator(intUserID, dtOriginalUpdatedDate);
		} // grdPagination_UpdateCommand
		
		/// <summary>
		/// Even handler method for when the data is bound to the DataGrid.
		/// </summary>
		/// <param name="e"> Any arguments that the event fires.</param>
		/// <param name="source">The source of the event</param>
		/// <remarks> This event is fired for every record that is bound to the grid.</remarks>
		private void grdPagination_ItemDataBound(object source, System.Web.UI.WebControls.DataGridItemEventArgs e)
		{
			if(e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.SelectedItem || e.Item.ItemType == ListItemType.EditItem)
			{
				DataRowView drvAdminDetails = (DataRowView)e.Item.DataItem;
				
				string FirstName = (string)drvAdminDetails["FirstName"];
				string LastName = (string)drvAdminDetails["LastName"];
				DateTime dtOriginalUpdatedDate = (DateTime)drvAdminDetails["DateUpdated"];
				
                string strFullName = FirstName + " " + LastName;
                strFullName = strFullName.Replace("'","\\'");

				//1. Make a reference to the remove button.
				LinkButton lnkRemoveButton;
				lnkRemoveButton = (LinkButton)e.Item.Cells[3].Controls[0];
					
				//2. Add an onlick event for every remove button.
				if (lnkRemoveButton != null)
				{
					lnkRemoveButton.CommandArgument = dtOriginalUpdatedDate.ToString("yyyy-MM-dd HH:mm:ss.fff");
					lnkRemoveButton.Attributes.Add("onclick", "javascript:return removeConfirm('" + strFullName + "');");
					lnkRemoveButton.Text = ResourceManager.GetString("grid_lnkRemoveButton");
				}
			}
		} // grdPagination_ItemDataBound
		
		/// <summary>
		/// Event handler method for the Add Organisation Administrator link button.
		/// Redirects control to the AddOrganisationAdministrator.aspx page.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void lnkAddOrganisationAdministrator_Click(object sender, EventArgs e)
		{
			Response.Redirect("AddOrganisationAdministrator.aspx");
		} // lnkAddOrganisationAdministrator_Click
		#endregion
		
		#region Private Methods
		/// <summary>
		/// Sets the State of the page
		/// </summary>
		private void SetPageState()
		{
			this.BindGrid();
		} // SetPageState
		
		/// <summary>
		/// Gets the data from the tblLink table and binds it to the DataGrid.
		/// </summary>
		private void BindGrid()
		{					
			//1. Show DataGrid Details pagination
			this.StartPagination();
		} // BindGrid
		
		/// <summary>
		/// Updates an Admin to be an non administratove user.
		/// </summary>
		/// <param name="userID">ID of the Admin to be pudated.</param>
		/// <param name="originalDateUpdated">Original date updated</param>
		private void RemoveAdministrator(int userID,  DateTime originalDateUpdated)
		{
			try
			{
				//1. Delete the link from the tblLink table.
				Bdw.Application.Salt.BusinessServices.Organisation objOrganisation = new Bdw.Application.Salt.BusinessServices.Organisation();
				objOrganisation.RemoveAdministrator(userID, UserContext.UserID, UserContext.UserData.OrgID, originalDateUpdated);
				
				this.lblMessage.Text = ResourceManager.GetString("lblMessage");//"The selected organisation administrator has been successfully removed.";
                this.lblMessage.CssClass = "SuccessMessage";

                //2. Reset the item index and rebind the DataGrid.
				this.grdPagination.EditItemIndex = -1;
				this.BindGrid();

                int periodicReportCount = PeriodicReportCountUser(userID);
                if (periodicReportCount > 0)
                    Response.Redirect("/Reporting/PeriodicReportList.aspx?user=" + userID + "&isoninactivate=true");
			}
			catch(RecordNotFoundException ex)
			{
				this.lblMessage.Text = ex.Message;
                this.lblMessage.CssClass = "WarningMessage";
			}
			catch(ParameterException ex)
			{
				throw ex;
			}
			catch(PermissionDeniedException)
			{				
				FormsAuthentication.SignOut();
                if (FormsAuthentication.RequireSSL)
                {
                    Response.Redirect("https://" + Request.Url.Host + FormsAuthentication.LoginUrl);
                }
                else
                {
                    Response.Redirect("http://" + Request.Url.Host + FormsAuthentication.LoginUrl);
                }

			}
			catch(IntegrityViolationException ex)
			{
				this.lblMessage.Text = ex.Message;
                this.lblMessage.CssClass = "WarningMessage";
			}
			catch(Exception ex)
			{
				throw ex;
			}
		} // RemoveAdministrator

        private int PeriodicReportCountUser(int UserId)
        {
            int OrgID = UserContext.UserData.OrgID;

            BusinessServices.User user = new BusinessServices.User();
            DataTable dtUser = user.GetUser(UserId);
            String Username = dtUser.Rows[0]["UserName"].ToString();

            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
            
            PeriodicReportListDataContext prl = new PeriodicReportListDataContext(connectionString);

            ISingleResult<prcGetPeriodicReportListOnInactivateUserResult> result = prl.prcGetPeriodicReportListOnInactivateUser(OrgID, Username);

            var query = from pr in result.AsQueryable<prcGetPeriodicReportListOnInactivateUserResult>() select pr;

            return query.Count<prcGetPeriodicReportListOnInactivateUserResult>();
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
			grdPagination.Columns[0].HeaderText = ResourceManager.GetString("cmnFirstName");
			grdPagination.Columns[1].HeaderText = ResourceManager.GetString("cmnLastName");
			grdPagination.Columns[2].HeaderText = ResourceManager.GetString("cmnEmail" );
			grdPagination.Columns[3].HeaderText = ResourceManager.GetString("grid_Remove");
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
            this.grdPagination.ItemCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.grdPagination_UpdateCommand);
            this.grdPagination.SortCommand += new System.Web.UI.WebControls.DataGridSortCommandEventHandler(this.grdPagination_SortCommand);
            this.grdPagination.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(this.grdPagination_ItemDataBound);

        }
		#endregion
		
		#region Pagination customisation (Change this section according to business logic)
		/// <summary>
		/// This method starts the pagination.  It initialises the variables required for the pagination and then calls
		/// the ShowPagination mthod.
		/// </summary>
		private void StartPagination()
		{
			//Initialize Pagination settings
			ViewState["OrderByField"] = "";
			ViewState["OrderByDirection"] = "";
			this.SetPaginationOrder("FirstName"); //customization

			this.tblPagination.Visible = true;
			
			this.ShowPagination(0);
		} // StartPagination
		
		/// <summary>
		/// Gets the pagination data.
		/// </summary>
		/// <returns> DataView with all users that are not organisation administrators.</returns>
		private DataView GetPaginationData()
		{
			Bdw.Application.Salt.BusinessServices.Organisation objOrganisation = new Bdw.Application.Salt.BusinessServices.Organisation();
			DataTable dtbAdmins = objOrganisation.GetOrganisationAdministrators(UserContext.UserData.OrgID);
			
			//Customize, and return DataView
			return dtbAdmins.DefaultView;
		} // GetPaginationData
		#endregion

		#region Pagination Event Handlers (Don't make any changes to this section)
		/// <summary>
		/// Event handler method for the previous button click event.
		/// Moves to the previous page of data.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void btnPrev_Click(object sender, System.EventArgs e)
		{
			this.ShowPagination(this.grdPagination.CurrentPageIndex - 1);
		} // btnPrev_Click
		
		/// <summary>
		/// Event handler method for the next button click event.
		/// Moves to the next page of data.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void btnNext_Click(object sender, System.EventArgs e)
		{
			this.ShowPagination(this.grdPagination.CurrentPageIndex + 1);
		} // btnNext_Click

		/// <summary>
		/// Event handler method for the page drop down list change event.
		/// Moves to a specific page of data.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void cboPage_SelectedIndexChanged(object sender, System.EventArgs e)
		{
			int intPageIndex;
			intPageIndex = int.Parse(this.cboPage.SelectedValue);
			this.ShowPagination(intPageIndex - 1);
		} // cboPage_SelectedIndexChanged

		/// <summary>
		/// Event handler method for the 
		/// Sorts the data.
		/// </summary>
		/// <param name="e"> Any arguments that the event fires.</param>
		/// <param name="source">Source of the sort command</param>
		private void grdPagination_SortCommand(object source, System.Web.UI.WebControls.DataGridSortCommandEventArgs e)
		{
			this.SetPaginationOrder(e.SortExpression);
			this.ShowPagination(0);
		} // grdPagination_SortCommand

		/// <summary>
		/// Sets the order by field.
		/// </summary>
		/// <param name="orderByField"> The field to order by.</param>
		private void SetPaginationOrder(string orderByField)
		{
			string	strOldOrderByField, strOldOrderByDirection;
			string  strOrderByDirection;

			strOldOrderByField =(string)ViewState["OrderByField"];
			strOldOrderByDirection =(string)ViewState["OrderByDirection"];
			
			//set the orderby direction.
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
		/// Show Paging Data.
		/// </summary>
		/// <param name="currentPageIndex"> The index of the current page.</param>
		private void ShowPagination(int currentPageIndex)
		{
			//1. Get data
			DataView  dvwPagination = this.GetPaginationData();
			
			//2. If the total rows returned is equal to or less than the page size then hide the pagination.
			if(dvwPagination.Count <= ApplicationSettings.PageSize)
			{
				this.trPagination.Visible = false;
			}
			
			//2. Sort Data
			string strOrderByField;
			string strOrderByDirection;
			strOrderByField = (string)ViewState["OrderByField"];
			strOrderByDirection = (string)ViewState["OrderByDirection"];

			dvwPagination.Sort = strOrderByField + " " + strOrderByDirection;

			//3. Set pagination panel
			int intPageSize;
			intPageSize = ApplicationSettings.PageSize ;
			this.SetPaginationPanel(intPageSize, dvwPagination.Count, currentPageIndex);

			//4. Bind Data
			//5. Set the Key field for the DataGrid
			grdPagination.DataKeyField = "UserID";
			grdPagination.DataSource = dvwPagination;
			grdPagination.PageSize = intPageSize;
			grdPagination.CurrentPageIndex = currentPageIndex;
			grdPagination.DataBind();
		}

		/// <summary>
		/// Sets the pagination panel.
		/// </summary>
		/// <param name="pageSize"> The size of the page to be displayed.</param>
		/// <param name="totalRecordCount"> The total number of records that need to be displayed.</param>
		/// <param name="currentPageIndex"> The index of the current page.</param>
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
	}
}