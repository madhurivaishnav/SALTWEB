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

namespace Bdw.Application.Salt.Web.Administration.Organisation
{
	/// <summary>
	/// This class controls the page and business logic for the AddOrganisationAdministrator.aspx page.
	/// This class allows the adding of organisaion administrators.
	/// </summary>
	/// <remarks>
	/// Assumptions: This page should only be available to Salt and Organisation administrators.
	/// Notes: None.
	/// Author: Peter Vranich
	/// Date: 17/02/0/2004
	/// Changes:
	/// 03/05/2004
	/// After successfully adding a unit administrator the user is redirected back to 
	/// OrganisationAdministrators.aspx, not left on the same page.
	/// </remarks>
	public partial class AddOrganisationAdministrator : System.Web.UI.Page
	{
		#region Protected Variables
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
		/// The button for navigating to the next page of the datagrid.
		/// </summary>
		protected System.Web.UI.WebControls.LinkButton btnNext;
		
		/// <summary>
		/// The text box for the first name.  This is used for the search.
		/// </summary>
		protected System.Web.UI.WebControls.TextBox txtFirstName;
		
		/// <summary>
		/// The text box for the last name.  This is used for the search.
		/// </summary>
		protected System.Web.UI.WebControls.TextBox txtLastName;
		
		/// <summary>
		/// The search button.  When clicked this will run the search with the criteria specified.
		/// </summary>
		protected System.Web.UI.WebControls.Button btnFind;
		
		/// <summary>
		/// The reset button.  When clicked this will reset all search criteria fields.
		/// </summary>
        protected System.Web.UI.WebControls.Button btnReset;

        /// <summary>
        /// Label for page title
        /// </summary>
        protected System.Web.UI.WebControls.Label lblPageTitle;
		
		/// <summary>
		/// The label to hold any messages that need to be displayed to the user.
		/// </summary>
		protected System.Web.UI.WebControls.Label lblMessage;
		#endregion
		
		#region Private Event Handlers
		/// <summary>
		/// Event Handler for the Page Load event.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
			if(!Page.IsPostBack)
			{
				this.SetPageState();
			}
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");

		} // Page_Load
		
		/// <summary>
		/// Event Handler for the Add button (Is this event handler needed as ItemCommand is used
		/// for adding new organisation administrators?)
		/// </summary>
		/// <param name="source"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		private void grdPagination_UpdateCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
		{
			//1. Get the UserID
			int intUserID = (int)this.grdPagination.DataKeys[e.Item.ItemIndex];
			
			//2. Get the original updated datetime.
			DataRowView drvAdminDetails = (DataRowView)e.Item.DataItem;
			DateTime dtOriginalUpdatedDate = DateTime.Parse(e.CommandArgument.ToString());
			
			//3. Add the user.
			this.AddAdministrator(intUserID, dtOriginalUpdatedDate);
		} // grdPagination_UpdateCommand

		/// <summary>
		/// Even Handler for when the data is bound to the DataGrid.
		/// This adds the DateUpdated for every record to the commandargument parameter attribute.
		/// </summary>
		/// <param name="source"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		/// <remarks>
		/// This event is fired for every record that is bound to the grid.
		/// It ignores the header row.
		/// </remarks>
		private void grdPagination_ItemDataBound(object source, System.Web.UI.WebControls.DataGridItemEventArgs e)
		{
			if(e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.SelectedItem || e.Item.ItemType == ListItemType.EditItem)
			{
				DataRowView drvAdminDetails = (DataRowView)e.Item.DataItem;
				
				string FirstName = (string)drvAdminDetails["FirstName"];
				string LastName = (string)drvAdminDetails["LastName"];
				DateTime dtOriginalUpdatedDate = (DateTime)drvAdminDetails["DateUpdated"];
								
				//1. Make a reference to the add button.
				LinkButton lnkAddButton;
				lnkAddButton = (LinkButton)e.Item.Cells[3].Controls[0];
					
				//2. The original date updated from the database to the command argument for each record in the grid..
				if (lnkAddButton != null)
				{
					lnkAddButton.CommandArgument = DatabaseTool.ToLongDateTimeString(dtOriginalUpdatedDate);
					lnkAddButton.Text = ResourceManager.GetString("grid_AddButton");
				}

				
			}
			
		} // grdPagination_ItemDataBound
		
		/// <summary>
		/// Event handler for the search button.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void btnFind_Click(object sender, EventArgs e)
		{
			//1. Bind the data
			this.BindGrid();
		} // btnFind_Click
        #endregion
		
		#region Private Methods
		/// <summary>
		/// Sets the State of the page
		/// </summary>
		private void SetPageState()
		{
			//1. Hide the datagrid table.
			this.tblPagination.Visible = false;
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
		/// Updates a User to be an organisation administrator.
		/// </summary>
		/// <param name="userID"> ID of the Admin to be updated.</param>
		/// <param name="originalDateUpdated">Date/time user was updated when page was loaded</param>
		private void AddAdministrator(int userID,  DateTime originalDateUpdated)
		{
			try
			{
				//1. Update the user to be an organisation administrator.
				Bdw.Application.Salt.BusinessServices.Organisation objOrganisation = new Bdw.Application.Salt.BusinessServices.Organisation();
				objOrganisation.AddAdministrator(userID, UserContext.UserID, UserContext.UserData.OrgID, originalDateUpdated);
				
                /*
                 * Changed 03/05/2004 Peter Kneale
                 * User now redirected back to OrganisationAdministrators page after successfully adding one.
                 * 
				this.lblMessage.Text = "The selected user has been successfully added as organisation administrator.";
                this.lblMessage.CssClass = "SuccessMessage";

                //2. Reset the item index and rebind the DataGrid.
				this.grdPagination.EditItemIndex = -1;
				this.BindGrid();
                */
                Response.Redirect ("OrganisationAdministrators.aspx");
			}
			catch (RecordNotFoundException ex)
			{
				this.lblMessage.Text = ex.Message;
                this.lblMessage.CssClass = "WarningMessage";
			}
			catch (ParameterException ex)
			{
				throw ex;
			}
			catch (PermissionDeniedException)
			{	
				WebSecurity.SignOut();
			}
			catch (IntegrityViolationException ex)
			{
				this.lblMessage.Text = ex.Message;
                this.lblMessage.CssClass = "WarningMessage";
			}
			catch (Exception ex)
			{
				throw ex;
			}
		} // AddAdministrator
		#endregion
		
		#region Web Form Designer generated code

        /// <summary>
        /// This call is required by the ASP.NET Web Form Designer.
        /// </summary>
        /// <param name="e"></param>
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
			grdPagination.Columns[3].HeaderText = ResourceManager.GetString("grid_AddAdmin");
		} // OnInit
		
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
			// Initialize Pagination settings
			ViewState["OrderByField"] = "";
			ViewState["OrderByDirection"] = "";
			this.SetPaginationOrder("FirstName"); //customisation

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
			DataTable dtbUsers = objOrganisation.GetUsers(UserContext.UserData.OrgID, this.txtFirstName.Text, this.txtLastName.Text);
			
			// Customize, and return DataView
			return dtbUsers.DefaultView;
		} // GetPaginationData
		#endregion

		#region Pagination Event Handlers (Don't make any changes to this section)
		/// <summary>
		/// Go to previous page.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void btnPrev_Click(object sender, System.EventArgs e)
		{
			this.ShowPagination(this.grdPagination.CurrentPageIndex - 1);
		} // btnPrev_Click
		
		/// <summary>
		/// Go to next page.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void btnNext_Click(object sender, System.EventArgs e)
		{
			this.ShowPagination(this.grdPagination.CurrentPageIndex + 1);
		} // btnNext_Click

		/// <summary>
		/// Go to a specific page.
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
		/// Sorts the data.
		/// </summary>
		/// <param name="source"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
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
		} // SetPaginationOrder
		
		/// <summary>
		/// Show Paging Data.
		/// </summary>
		/// <param name="currentPageIndex"> The index of the current page.</param>
		private void ShowPagination(int currentPageIndex)
		{
			//1. Get data
			DataView  dvwPagination = this.GetPaginationData();
			
			//2. If the total rows returned is equal to or less than the page size then hide the pagination.
			if (dvwPagination.Count <= ApplicationSettings.PageSize)
			{
				this.trPagination.Visible = false;
			}
			
			if (dvwPagination.Count == 0)
			{
				this.tblPagination.Visible = false;
				this.lblMessage.Text = ResourceManager.GetString("lblError.NoUsers");//"No users found.";
                this.lblMessage.CssClass = "FeedbackMessage";
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
			this.grdPagination.DataKeyField = "UserID";
			this.grdPagination.DataSource = dvwPagination;
			this.grdPagination.PageSize = intPageSize;
			this.grdPagination.CurrentPageIndex = currentPageIndex;
			this.grdPagination.DataBind();
		} // ShowPagination

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
		} // SetPaginationPanel
		#endregion
	}
}