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
//using Bdw.Application.Salt.Utilities;
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.BusinessServices;
using Localization;

namespace Bdw.Application.Salt.Web.Administration.Users
{
    /// <summary>
    /// This class controls the page and business logic for the SALT Administrators.
    /// </summary>
    /// <remarks>
    /// Assumptions: None.
    /// Notes: None.
    /// Author: Gavin Buddis
    /// Date: 23/03/2004
    /// Changes:
    /// </remarks>
    public partial class SALTAdministrators : System.Web.UI.Page
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
        /// The label to hold any messages that need to be displayed to the user.
        /// </summary>
        protected System.Web.UI.WebControls.Label lblMessage;

        /// <summary>
        /// Link to add salt administrators
        /// </summary>
        protected System.Web.UI.WebControls.LinkButton lnkAddSALTAdministrator;
		
        /// <summary>
        /// Link button to return to the org admin details page.
        /// </summary>
        protected System.Web.UI.WebControls.LinkButton lnkReturnToAdminHomepage;
        #endregion
		
        #region Private Event Handlers
        /// <summary>
        /// Event handler method for the Page Load event.
        /// </summary>
        /// <param name="sender"> The source of the event.</param>
        /// <param name="e"> Any arguments that the event fires.</param>
        protected void Page_Load(object sender, System.EventArgs e)
        {
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
            if(!Page.IsPostBack)
            {
                this.SetPageState();
            }
        } // Page_Load
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
		
//        /// <summary>
//        /// Toggles the active status of the selected SALT ADministrator.
//        /// </summary>
//        /// <param name="userID">ID of the Admin to be updated.</param>
//        private void ToggleInactive(int userID, DateTime originalDateUpdated)
//        {
//            try
//            {
//                //1. Toggle the active status of the selected SALT Administrator
//                BusinessServices.User objUser = new BusinessServices.User();
//                System.Data.DataTable dtbUser = objUser.GetUser(userID);
//                objUser.Update(userID, 0, dtbUser.Rows[0]["FirstName"].ToString(), dtbUser.Rows[0]["LastName"].ToString(), dtbUser.Rows[0]["Username"].ToString(), dtbUser.Rows[0]["Email"].ToString(), !Convert.ToBoolean(dtbUser.Rows[0]["Active"]), int.Parse(dtbUser.Rows[0]["UserTypeID"].ToString()), UserContext.UserID, originalDateUpdated.ToString());
//				
//                this.lblMessage.Text = "The selected administrator has been set " + (Convert.ToBoolean(dtbUser.Rows[0]["Active"]) ? "Inactive" : "Active") + ".";
//                this.lblMessage.CssClass = "SuccessMessage";
//
//                //2. Reset the item index and rebind the DataGrid.
//                this.grdPagination.EditItemIndex = -1;
//                this.BindGrid();
//            }
//            catch (RecordNotFoundException ex)
//            {
//                this.lblMessage.Text = ex.Message;
//                this.lblMessage.CssClass = "WarningMessage";
//            }
//            catch (ParameterException ex)
//            {
//                throw ex;
//            }
//            catch (PermissionDeniedException)
//            {				
//                FormsAuthentication.SignOut();
//                Response.Redirect("/Login.aspx");
//            }
//            catch (IntegrityViolationException ex)
//            {
//                this.lblMessage.Text = ex.Message;
//                this.lblMessage.CssClass = "WarningMessage";
//            }
//            catch (Exception ex)
//            {
//                throw ex;
//            }
//        } // RemoveAdministrator
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

			grdPagination.Columns[0].HeaderText = ResourceManager.GetString("cmnLastName");
			grdPagination.Columns[1].HeaderText = ResourceManager.GetString("cmnFirstName");
			grdPagination.Columns[2].HeaderText = ResourceManager.GetString("cmnEmail" );
        }
		
        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
			this.grdPagination.SortCommand += new System.Web.UI.WebControls.DataGridSortCommandEventHandler(this.grdPagination_SortCommand);

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
        /// <returns> DataView with all users that are SALT administrators.</returns>
        private DataView GetPaginationData()
        {
            // Get all SALT Administrators defined in the application but do not show the 
            // currently logged on SALT Administrator
            BusinessServices.User objUser = new BusinessServices.User();
            DataTable dtbAdmins = objUser.GetSALTAdministrators(UserContext.UserID, UserContext.UserData.OrgID);
			
            // Customize, and return DataView
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
        /// <param name="source">object</param>
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