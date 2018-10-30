
using Bdw.Application.Salt.BusinessServices;
using System;
using System.Web.UI.WebControls;
using System.Data;
using Localization;
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.Data;
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
	public partial class ModifyLinks : System.Web.UI.Page
	{
		#region Protected Variables

		/// <summary>
		/// The datagrid for the results of the search.
		/// </summary>
		protected System.Web.UI.WebControls.DataGrid grdResults;
		
		/// <summary>
		/// The label to hold any messages that need to be displayed to the user.
		/// </summary>
		protected System.Web.UI.WebControls.Label lblMessage;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvCaption;


		/// <summary>
		/// The label to hold the page title.
		/// </summary>
		protected System.Web.UI.WebControls.Label lblPageTitle;
		
		#endregion
		
		#region Private Event Handlers
		/// <summary>
		/// Event Handler for the Page Load event.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
			ResourceManager.RegisterLocaleResource("ConfirmMessage");
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			if(!Page.IsPostBack)
			{
				SetSortOrder("LinkOrder"); 
				ShowData(0);
			}
		} // Page_Load
		
		/// <summary>
		/// Adds a link
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void btnAdd_Click(object sender, System.EventArgs e)
		{
			if (txtAddCaption.Text.Trim().Length==0)
			{
				this.lblMessage.Text = ResourceManager.GetString("lblMessage.Caption");//"A caption must be supplied.";
				this.lblMessage.CssClass="FeedbackMessage";
			}
			else
			{
				AddLink(txtAddCaption.Text,txtAddURL.Text,chkAddDisclaimer.Checked);
			}
		}

		


		/// <summary>
		/// Event Handler for the Cancel button.
		/// </summary>
		/// <param name="source"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		private void grdResults_CancelCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
		{			
			this.grdResults.EditItemIndex = -1;
			ShowData(grdResults.CurrentPageIndex);
		} // grdResults_CancelCommand
		
		/// <summary>
		/// Event Handler for the Modify/Add/Edit button.
		/// </summary>
		/// <param name="source"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		private void grdResults_EditCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
		{
			this.grdResults.EditItemIndex = (int)e.Item.ItemIndex;
			ShowData(grdResults.CurrentPageIndex);
		} //grdResults_EditCommand
			
		/// <summary>
		/// Event Handler for the Update button.
		/// </summary>
		/// <param name="source"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		private void grdResults_UpdateCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
		{
			bool blnSuccess = true;
			//1. get the LinkID
			int intLinkID = (int)this.grdResults.DataKeys[e.Item.ItemIndex];
            
			//2. Get the new values from the DataGrid.
			string strCaption = ((TextBox)e.Item.FindControl("txtCaption")).Text.Trim();
			string strUrl = ((TextBox)e.Item.FindControl("txtUrl")).Text.Trim();
			bool blnShowDisclaimer = ((CheckBox)e.Item.FindControl("chkShowDisclaimerEnabled")).Checked;
			int linkOrder = Int32.Parse(((TextBox)e.Item.FindControl("txtLinkOrder")).Text.Trim());
            
			//3. Check to see if it is a new record or not. If it
			// is a new record the LinkID will be 0.
			if (strCaption.Length == 0)
			{
				this.lblMessage.Text = ResourceManager.GetString("lblMessage.SpecifyCaption");//"You must specify the link caption.";
				this.lblMessage.CssClass = "WarningMessage";
				blnSuccess = false;
			}
			if (strUrl.Length==0)
			{
				blnShowDisclaimer=false;
			}

			if (blnSuccess)
			{
				//5. Add the new record.
				this.UpdateLink(intLinkID, strCaption, strUrl, blnShowDisclaimer, linkOrder);
			}
		} // grdResults_UpdateCommand
		
		/// <summary>
		/// Event Handler for the Delete button.
		/// </summary>
		/// <param name="e"> Any arguments that the event fires.</param>
		/// <param name="source">The source of the event</param>
		private void grdResults_DeleteCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
		{
			//1. Get the LinkID
			int intLinkID = (int)this.grdResults.DataKeys[e.Item.ItemIndex];
			this.DeleteLink(intLinkID);
		} // grdResults_DeleteCommand
		

		private void grdResults_ItemCreated(object source, System.Web.UI.WebControls.DataGridItemEventArgs e)
		{
			if(e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.SelectedItem || e.Item.ItemType == ListItemType.EditItem)
			{
				LinkButton lnkUp = (LinkButton)e.Item.Cells[5].Controls[1];
				LinkButton lnkDown = (LinkButton)e.Item.Cells[5].Controls[3];
				
				lnkUp.Click+=new EventHandler(Sort_Click);
				lnkDown.Click+=new EventHandler(Sort_Click);
				
			}
		}
		/// <summary>
		/// Even Handler for when the data is bound to the DataGrid.
		/// </summary>
		/// <param name="source"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		/// <remarks> This event is fired for every record that is bound to the grid.</remarks>
		private void grdResults_ItemDataBound(object source, System.Web.UI.WebControls.DataGridItemEventArgs e)
		{
			if(e.Item.ItemType == ListItemType.EditItem)
			{
				LinkButton lnkUpdateButton = (LinkButton)e.Item.Cells[3].Controls[0];
				if (lnkUpdateButton != null)
					lnkUpdateButton.Text = ResourceManager.GetString("grid_lnkUpdateButton");


				LinkButton lnkCancelButton = (LinkButton)e.Item.Cells[3].Controls[2];
				if (lnkCancelButton != null)
					lnkCancelButton.Text = ResourceManager.GetString("cmnCancel");
			}
			if(e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.SelectedItem)
			{


				int intLinkID; // Holds the LinkID for the last record bound to the grid.
				intLinkID  = (int)this.grdResults.DataKeys[e.Item.ItemIndex];
				

				LinkButton lnkModifyButton = (LinkButton)e.Item.Cells[3].Controls[0];
				if (lnkModifyButton != null)
					lnkModifyButton.Text = ResourceManager.GetString("grid_lnkModifyButton");
			}
			if(e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.SelectedItem || e.Item.ItemType == ListItemType.EditItem)
			{
				LinkButton lnkDeleteButton = (LinkButton)e.Item.Cells[4].Controls[0];
				//5. Add an onlick event for every delete button.
				if (lnkDeleteButton != null)
				{
					lnkDeleteButton.Attributes.Add("onclick", "return deleteConfirm();");
					lnkDeleteButton.Text = ResourceManager.GetString("lnkDeleteButton");
				}

				DataRowView drv = (DataRowView)e.Item.DataItem;

				LinkButton lnkUp = (LinkButton)e.Item.Cells[5].Controls[1];
				LinkButton lnkDown = (LinkButton)e.Item.Cells[5].Controls[3];

				lnkUp.Attributes.Add("LinkID", drv["LinkID"].ToString());
				lnkDown.Attributes.Add("LinkID", drv["LinkID"].ToString());
				lnkUp.Attributes.Add("NewOrder", (Int32.Parse(drv["LinkOrder"].ToString()) - 11).ToString());
				lnkDown.Attributes.Add("NewOrder", (Int32.Parse(drv["LinkOrder"].ToString()) + 11).ToString());
				
			}

		} // grdResults_ItemDataBound

		protected void Sort_Click(object sender, EventArgs e)
		{
			int intLinkID = Int32.Parse(((LinkButton)sender).Attributes["LinkID"].ToString());
			int newOrder = Int32.Parse(((LinkButton)sender).Attributes["NewOrder"].ToString());

			BusinessServices.Link.UpdateOrder(intLinkID, newOrder);

			this.grdResults.EditItemIndex = -1;
			ShowData(grdResults.CurrentPageIndex);
		}


		/// <summary>
		///Sorts the data.
		/// </summary>
		/// <param name="source"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		private void grdResults_SortCommand(object source, System.Web.UI.WebControls.DataGridSortCommandEventArgs e)
		{
			this.SetSortOrder(e.SortExpression);
			this.ShowData(0);
		}

		/// <summary>
		/// Event handler for the return to organisation admin button.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		private void lnkReturnToOrgAdmin_Click(object sender, EventArgs e)
		{
			Response.Redirect("OrganisationDetails.aspx");
		} // lnkReturnToOrgAdmin_Click

		/// <summary>
		/// Page changed
		/// </summary>
		/// <param name="source"></param>
		/// <param name="e"></param>
		private void grdResults_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
		{
			ShowData(e.NewPageIndex);
		}

		#endregion
		
		#region Private Methods
		/// <summary>
		/// Gets the pagination data.
		/// </summary>
		/// <returns> DataView with all users that are not organisation administrators.</returns>
		private DataView GetData()
		{
			DataTable dtbLinks = Link.GetLinksByOrganisation(UserContext.UserData.OrgID);
			
			//Customize, and return DataView
			return dtbLinks.DefaultView;
		} // GetData

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
		/// Adds a new link to the tblLink table.
		/// </summary>
		/// <param name="caption"> The new caption for the link.</param>
		/// <param name="url"> The new Url for the link.</param>
		/// <param name="showDisclaimer"> The new setting for the ShowDisclaimer.</param>
		private void AddLink(string caption, string url, bool showDisclaimer)
		{
			try
			{
				//1. Get the UserID.
				int intUserID  = UserContext.UserID;
				
				//3. Add the new record.
				Link objLink = new Link();
				objLink.Add(UserContext.UserData.OrgID, caption, url, showDisclaimer, intUserID);
				
				this.grdResults.EditItemIndex = -1;
				Response.Redirect("ModifyLinks.aspx");
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
		} // AddLink
		
		/// <summary>
		/// Updates a link in the tblLink table.
		/// </summary>
		/// <param name="linkID"> ID of the link to be updated.</param>
		/// <param name="caption"> The new caption for the link.</param>
		/// <param name="url"> The new Url for the link.</param>
		/// <param name="showDisclaimer"> The new setting for the ShowDisclaimer.</param>
		private void UpdateLink(int linkID, string caption, string url, bool showDisclaimer, int linkOrder)
		{
			try
			{
				if (caption.Length==0)
				{
					this.lblMessage.Text = ResourceManager.GetString("lblMessage.Caption");//"A caption must be supplied.";
					this.lblMessage.CssClass = "WarningMessage";
				}
				else
				{
                    
					//1. Get the UserID.
					int intUserID  = UserContext.UserID;
				
					//2. Add the new record.
					Link objLink = new Link();
					objLink.Update(linkID, caption, url, showDisclaimer, intUserID, linkOrder);
				
					//3. Reset the item index and rebind the DataGrid.
					this.grdResults.EditItemIndex = -1;
					ShowData(0);
				}
				
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
		} // UpdateLink
		
		/// <summary>
		/// Deletes a link from the tblLink table.
		/// </summary>
		/// <param name="linkID"> ID of the link to be deleted.</param>
		private void DeleteLink(int linkID)
		{
			try
			{
				//1. Delete the link from the tblLink table.
				Link objLink = new Link();
				objLink.Delete(linkID);
				
				//2. Reset the item index and rebind the DataGrid.
				this.grdResults.EditItemIndex = -1;
				ShowData(0);
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
			catch(Exception ex)
			{
				throw ex;
			}
		} // DeleteLink
        
		
		private void ShowData(int pageIndex)
		{
			BusinessServices.Link.ResetOrder(UserContext.UserData.OrgID);

			//1. Get data
			DataView  dvwPagination = GetData();



			int intRowCount = dvwPagination.Table.Rows.Count; 
			if (intRowCount > 0)
			{
				//2. Use pagination if necessary
				if (intRowCount > ApplicationSettings.PageSize)
				{
					grdResults.AllowPaging=true;
					grdResults.CurrentPageIndex = pageIndex;
				}
				else
				{
					grdResults.AllowPaging=false;
				}
				if (intRowCount > 1)
				{
					//3. Sort Data
					grdResults.AllowSorting=true;
					dvwPagination.Sort = (string)ViewState["OrderByField"] + " " + (string)ViewState["OrderByDirection"];
				}
				else
				{
					grdResults.AllowSorting=false;
				}
                
				//4. Bind Data
				grdResults.DataSource = dvwPagination;
				grdResults.DataKeyField = "LinkID";
				grdResults.DataBind();
                
				grdResults.Visible=true;
			}
			else
			{
				grdResults.Visible=false;
			}
		}
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
			grdResults.Columns[0].HeaderText = ResourceManager.GetString("grid_LinkCap");
			grdResults.Columns[1].HeaderText = ResourceManager.GetString("grid_Url");
			grdResults.Columns[2].HeaderText = ResourceManager.GetString("grid_ShowDisclaimer");
			grdResults.Columns[5].HeaderText = ResourceManager.GetString("grid_Sort");
		} // OnInit
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.grdResults.PageIndexChanged += new System.Web.UI.WebControls.DataGridPageChangedEventHandler(this.grdResults_PageIndexChanged);
			this.grdResults.CancelCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.grdResults_CancelCommand);
			this.grdResults.EditCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.grdResults_EditCommand);
			this.grdResults.SortCommand += new System.Web.UI.WebControls.DataGridSortCommandEventHandler(this.grdResults_SortCommand);
			this.grdResults.UpdateCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.grdResults_UpdateCommand);
			this.grdResults.DeleteCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.grdResults_DeleteCommand);
			this.grdResults.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(this.grdResults_ItemDataBound);
			this.grdResults.ItemCreated+=new DataGridItemEventHandler(grdResults_ItemCreated);

		}		
        #endregion

	}
}