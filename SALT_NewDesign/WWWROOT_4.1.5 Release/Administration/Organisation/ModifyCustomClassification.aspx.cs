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
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.Utilities;
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.BusinessServices;
using Localization;

namespace Bdw.Application.Salt.Web.Administration.Organisation
{
	/// <summary>
	/// This class controls the page and business logic for the ModifyCustomClassification.aspx page.
	/// This class allows the editing/adding of classification options.
	/// </summary>
	/// <remarks>
	/// Assumptions: This page should only be available to Salt and Organisation administrators.
	/// Notes: None.
	/// Author: Peter Vranich
	/// Date: 19/02/0/2004
	/// Changes:
	/// </remarks>
	public partial class ModifyCustomClassification : System.Web.UI.Page
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
		/// The button for navigating to the next page of the datagrid.
		/// </summary>
		protected System.Web.UI.WebControls.LinkButton btnNext;
		
		/// <summary>
		/// The label to hold any messages that need to be displayed to the user.
		/// </summary>
		protected System.Web.UI.WebControls.Label lblMessage;
        /// <summary>
		/// The label to display the page tilte
		/// </summary>
        protected System.Web.UI.WebControls.Label lblPageTitle;
		
		/// <summary>
		/// Link button to return to the org admin details page.
		/// </summary>
		protected System.Web.UI.WebControls.LinkButton lnkReturnToOrgAdmin;
		#endregion
		
		#region Private Properties
		
		/// <summary>
		/// Gets the ClassificationTypeID.
		/// </summary>
		private int ClassificationTypeID
		{
			get
			{
				return Int32.Parse(Request.QueryString["ClassificationTypeID"]);
			}
		}
		#endregion
		
		#region Private Event Handlers
		/// <summary>
		/// Event Handler for the Page Load event.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			ResourceManager.RegisterLocaleResource("ConfirmMessage");

			if(!Page.IsPostBack)
			{
				this.SetPageState();
			}
		} // Page_Load
		
		/// <summary>
		/// Event Handler for the Cancel button.
		/// </summary>
		/// <param name="e"> Any arguments that the event fires.</param>
		/// <param name="source">source of the command raised</param>
		private void grdPagination_CancelCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
		{			
			this.grdPagination.EditItemIndex = -1;
			this.BindGrid();
		} // grdPagination_CancelCommand
		
		/// <summary>
		/// Event Handler for the Modify/Add/Edit button.
		/// </summary>
		/// <param name="e"> Any arguments that the event fires.</param>
		/// <param name="source">The source of the event</param>
		private void grdPagination_EditCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
		{
			this.grdPagination.EditItemIndex = (int)e.Item.ItemIndex;
			ShowPagination(grdPagination.CurrentPageIndex);
		} // grdPagination_EditCommand
		
		/// <summary>
		/// Event Handler for the Update button.
		/// </summary>
		/// <param name="e"> Any arguments that the event fires.</param>
		/// <param name="source">the source of the event</param>
		private void grdPagination_UpdateCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
		{
			//1. get the ClassificationID
			int intClassificationID = (int)this.grdPagination.DataKeys[e.Item.ItemIndex];
			
			//2. Check to see if it is a new record or not. If it
			// is a new record the ClassificationID will be 0.
			if(intClassificationID == 0)
			{
				//3. Get the new values from the DataGrid.
				string strName = ((TextBox)e.Item.FindControl("txtName")).Text;
				bool blnActive = ((CheckBox)e.Item.FindControl("chkActiveEnabled")).Checked;
				
				//4. Add the new record.
				this.AddClassification(strName, blnActive);
			}
			else
			{
				//5. Get the values from the DataGrid.				
				string strName = ((TextBox)e.Item.FindControl("txtName")).Text;
				bool blnActive = ((CheckBox)e.Item.FindControl("chkActiveEnabled")).Checked;
				
				//6. Update the record.
				this.UpdateClassification(intClassificationID, strName, blnActive);
			}
		} // grdPagination_UpdateCommand
		
        /// <summary>
        ///Sorts the data.
        /// </summary>
        /// <param name="source"> The source of the event.</param>
        /// <param name="e"> Any arguments that the event fires.</param>
        private void grdPagination_SortCommand(object source, System.Web.UI.WebControls.DataGridSortCommandEventArgs e)
        {
            this.SetSortOrder(e.SortExpression);
            this.ShowPagination(0);
        }

        /// <summary>
        /// Sets the order by field.
        /// </summary>
        /// <param name="orderByField"> The field to order by.</param>
        private void SetSortOrder(string orderByField)
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
        } // SetSortOrder
		
        /// <summary>
        /// Page changed
        /// </summary>
        /// <param name="source"></param>
        /// <param name="e"></param>
        private void grdPagination_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
        {
            ShowPagination(e.NewPageIndex);
        }
		
		/// <summary>
		/// Event handler for the return to organisation admin button.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		/// 
		protected void lnkReturnToOrgAdmin_Click(object sender, EventArgs e)
		{
			Response.Redirect("OrganisationDetails.aspx");
		} // lnkReturnToOrgAdmin_Click
		#endregion
		
		#region Private Methods
		/// <summary>
		/// Sets the State of the page.
		/// </summary>
		private void SetPageState()
		{
            // Set the page title to include the custom classification name
            Classification objClassification = new Classification();
            DataTable dtbClassificationType = objClassification.GetClassificationType(UserContext.UserData.OrgID);
            this.lblPageTitle.Text = String.Format(ResourceManager.GetString("lblPageTitle.Modify"), dtbClassificationType.Rows[0]["Name"].ToString());//"Modify '" + dtbClassificationType.Rows[0]["Name"].ToString() + "' Grouping Options";

            this.BindGrid();
		} // SetPageState
		
		/// <summary>
		/// Gets the data from the tblClassification table and binds it to the DataGrid.
		/// </summary>
		private void BindGrid()
		{			
			//1. Show Upload Details pagination
			this.StartPagination();
		} // BindGrid
		
		/// <summary>
		/// Adds a new classification to the tblClassification table.
		/// </summary>
		/// <param name="name"> The new value for the classification.</param>
		/// <param name="active"> The new setting for active.</param>
		private void AddClassification(string name, bool active)
		{	
			//1. Add the new record.
			Classification objClassification = new Classification();
			objClassification.AddClassification(name, active, this.ClassificationTypeID);
			
			this.grdPagination.EditItemIndex = -1;
            this.BindGrid();
		} // AddClassification
		
		/// <summary>
		/// Updates a classification to the tblClassification table.
		/// </summary>
		/// <param name="classificationID">ID of the classification to be updated.</param>
		/// <param name="name"> The new value for the classification.</param>
		/// <param name="active"> The new setting for the active status.</param>
		private void UpdateClassification(int classificationID, string name, bool active)
		{
			try
			{	
				//1. Update the record.
				Classification objClassification = new Classification();
				objClassification.UpdateClassification(name, active, classificationID, this.ClassificationTypeID);
				
				//2. Reset the item index and rebind the DataGrid.
				this.grdPagination.EditItemIndex = -1;
				this.BindGrid();
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
			catch(UniqueViolationException ex)
			{
				this.lblMessage.Text = ex.Message;
                this.lblMessage.CssClass = "WarningMessage";
			}
			catch(Exception ex) //Unexpected error.
			{
				throw ex;
			}
		} // UpdateClassification
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
			grdPagination.Columns[0].HeaderText = ResourceManager.GetString("grid_ClassValue");
			grdPagination.Columns[1].HeaderText = ResourceManager.GetString("cmnActive" );
			grdPagination.Columns[2].HeaderText = ResourceManager.GetString("grid_Action");
		} // OnInit
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
            this.grdPagination.PageIndexChanged += new System.Web.UI.WebControls.DataGridPageChangedEventHandler(this.grdPagination_PageIndexChanged);
            this.grdPagination.CancelCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.grdPagination_CancelCommand);
            this.grdPagination.EditCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.grdPagination_EditCommand);
            this.grdPagination.SortCommand += new System.Web.UI.WebControls.DataGridSortCommandEventHandler(this.grdPagination_SortCommand);
            this.grdPagination.UpdateCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.grdPagination_UpdateCommand);
			this.grdPagination.ItemDataBound +=new DataGridItemEventHandler(grdPagination_ItemDataBound);

        }		
        #endregion
		
		#region Pagination customisation (Change this section according to business logic)
		/// <summary>
		/// Start Pagination
		/// </summary>
		private void StartPagination()
		{
			//Initialize Pagination settings
			ViewState["OrderByField"] = "";
			ViewState["OrderByDirection"] = "";
			this.SetPaginationOrder("Value"); //customization

			this.tblPagination.Visible = true;
			
			this.ShowPagination(0);
		}
		
		/// <summary>
		/// Get Pagination Data
		/// </summary>
		/// <returns></returns>
		private DataView GetPaginationData()
		{
			Classification objClassification = new Classification();
			DataTable dtbClassification = objClassification.GetClassificationListAll(this.ClassificationTypeID);
			
			//Customize, and return DataView
			return dtbClassification.DefaultView;
		}
		#endregion

		#region Pagination Event Handlers (Don't make any changes to this section)
		

		/// <summary>
		/// Sets the order by field.
		/// </summary>
		/// <param name="orderByField"> The field to order by.</param>
		private void SetPaginationOrder(string orderByField)
		{
			string strOldOrderByField, strOldOrderByDirection;
			string strOrderByDirection;

			strOldOrderByField = (string)ViewState["OrderByField"];
			strOldOrderByDirection = (string)ViewState["OrderByDirection"];
			
			//set the orderby direction.
			if(strOldOrderByField == orderByField)
			{
				switch(strOldOrderByDirection.ToUpper())
				{
					case "ASC":
					{
						strOrderByDirection = "DESC";
						break;
					}
					case "DESC":
					{
						strOrderByDirection = "ASC";
						break;
					}
					default:
					{
						strOrderByDirection = "ASC";
						break;
					}
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
		/// <param name="currentPageIndex"> Index of the current page.</param>
		private void ShowPagination(int currentPageIndex)
		{
			//1. Get data
			DataView  dvwPagination = this.GetPaginationData();
			
			
			//3. Sort Data
			string strOrderByField;
			string strOrderByDirection;
			strOrderByField = (string)ViewState["OrderByField"];
			strOrderByDirection = (string)ViewState["OrderByDirection"];

			dvwPagination.Sort = strOrderByField + " " + strOrderByDirection;

			//4. Set pagination panel
			int intPageSize;
			intPageSize = ApplicationSettings.PageSize ;
			
			//5. Set the Key field for the DataGrid
			grdPagination.DataKeyField = "ClassificationID";
			grdPagination.DataSource = dvwPagination;
			grdPagination.PageSize = intPageSize;
			grdPagination.CurrentPageIndex = currentPageIndex;
			grdPagination.DataBind();
		}

		
		#endregion

        protected void btnAdd_Click(object sender, System.EventArgs e)
        {
            string strName = txtValue.Text;
            if (txtValue.Text.Length==0)
            {
                lblMessage.Text = ResourceManager.GetString("lblMessage.Supply");//"You must supply a value";
                lblMessage.CssClass="WarningMessage";
                return;
            }
            try
            {

                AddClassification(strName, true);
                txtValue.Text="";
                lblMessage.Text = ResourceManager.GetString("lblMessage.Added");//"Value has been added";
                lblMessage.CssClass="SuccessMessage";
            }
            catch (Exception ex)
            {
                lblMessage.Text = ex.Message;
                lblMessage.CssClass="WarningMessage";
            }
        }


		private void grdPagination_ItemDataBound(object sender, DataGridItemEventArgs e)
		{
			if(e.Item.ItemType == ListItemType.EditItem)
			{
				LinkButton lnkUpdateButton = (LinkButton)e.Item.Cells[2].Controls[0];
				if (lnkUpdateButton != null)
					lnkUpdateButton.Text = ResourceManager.GetString("grid_Update");

				LinkButton lnkCancelButton = (LinkButton)e.Item.Cells[2].Controls[2];
				if (lnkCancelButton != null)
					lnkCancelButton.Text = ResourceManager.GetString("cmnCancel");

			}

			if(e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.SelectedItem)
			{
				LinkButton lnkModifyButton = (LinkButton)e.Item.Cells[2].Controls[0];
				if (lnkModifyButton != null)
					lnkModifyButton.Text = ResourceManager.GetString("grid_Modify");
			}
		}
	}
}