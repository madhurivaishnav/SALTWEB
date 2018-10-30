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
using Bdw.Application.Salt.ErrorHandler; 
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Data;
using Localization;

namespace Bdw.Application.Salt.Web.Administration.Users
{
	/// <summary>
	/// Summary description for MoveUsersToUnit.
	/// </summary>
	public partial class MoveUsersToUnit : System.Web.UI.Page
	{

		#region Protected controls


		/// <summary>
		/// Datagrid for results
		/// </summary>
		protected System.Web.UI.WebControls.DataGrid grdResults;

		/// <summary>
		/// Table containing search criteria
		/// </summary>
		protected System.Web.UI.HtmlControls.HtmlTable tblSearchCriteria;

		/// <summary>
		/// Textbox for first name
		/// </summary>
		protected System.Web.UI.WebControls.TextBox txtFirstName;

		/// <summary>
		/// Textbox for last name
		/// </summary>
		protected System.Web.UI.WebControls.TextBox txtLastName;

		/// <summary>
		/// Textbox for username
		/// </summary>
		protected System.Web.UI.WebControls.TextBox txtUsername;

		/// <summary>
		/// Treeview for unit selection
		/// </summary>
		protected Uws.Framework.WebControl.TreeView trvUnitsSelector;

		/// <summary>
		/// Label for messages to user
		/// </summary>
		protected System.Web.UI.WebControls.Label lblMessage;

		/// <summary>
		/// Placeholder surrounding criteria
		/// </summary>
		protected System.Web.UI.WebControls.PlaceHolder plhCriteria;

		/// <summary>
		/// Placeholder surrounding results
		/// </summary>
		protected System.Web.UI.WebControls.PlaceHolder plhResults;
		protected System.Web.UI.WebControls.Label lblUserCount;

		/// <summary>
		/// Checkbox to include inactive users in search
		/// </summary>
		protected System.Web.UI.WebControls.CheckBox chkInactiveUsers;

		/// <summary>
		/// Checkbox to select all users
		/// </summary>
		protected System.Web.UI.WebControls.CheckBox chkSelectAll;

		/// <summary>
		/// Hidden textbox containing userids
		/// </summary>
		protected System.Web.UI.WebControls.TextBox txtAllUserIDs;

		// Result objects

		/// <summary>
		/// Label showing status
		/// </summary>
		protected System.Web.UI.WebControls.Label lblStatus;

		/// <summary>
		/// Label for total records
		/// </summary>
		protected System.Web.UI.WebControls.Label lblTotalRecordCount;

		/// <summary>
		/// Label for current records per page
		/// </summary>
		protected System.Web.UI.WebControls.Label lblCurrentPageRecordCount;

		/// <summary>
		/// Label for page counter
		/// </summary>
		protected System.Web.UI.WebControls.Label lblPageCount;

		/// <summary>
		/// Drop down list of pages to jump to 
		/// </summary>
		protected System.Web.UI.WebControls.DropDownList cboPage;

		/// <summary>
		/// Next page button
		/// </summary>
		protected System.Web.UI.WebControls.LinkButton btnNext;

		/// <summary>
		/// Previous page button
		/// </summary>
		protected System.Web.UI.WebControls.LinkButton btnPrev;

		/// <summary>
		/// Table for pagination
		/// </summary>
		protected System.Web.UI.HtmlControls.HtmlTable tblPagination;

		/// <summary>
		/// Table row for pagination
		/// </summary>
		protected System.Web.UI.HtmlControls.HtmlTableRow trPagination;

		/// <summary>
		/// Checkbox to add a user
		/// </summary>
		protected System.Web.UI.WebControls.CheckBox chkAddUser;

		/// <summary>
		/// Datagrid for results
		/// </summary>
		protected System.Web.UI.WebControls.DataGrid dgrResults;

		/// <summary>
		/// Button to assign users
		/// </summary>
		protected System.Web.UI.WebControls.Button btnAssign;
		#endregion	

		#region Private Event Handlers
		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			lblError.Text="";
			if (!Page.IsPostBack)
			{
				BusinessServices.Unit objUnit = new BusinessServices.Unit();
			
				DataSet dstUnits = objUnit.GetUnitsTreeByUserID(UserContext.UserData.OrgID, UserContext.UserID, 'A');
			
				// reset the tree view control on each load
				trvUnitsSelector.ClearSelection();
				this.txtAllUserIDs.Text = "";
				this.txtUserIDs.Text =  "";

				string strUnits = UnitTreeConvert.ConvertXml(dstUnits);
				if (strUnits=="")
				{
					this.lblNoSubUnits.Visible=true;
					this.lblNoSubUnits.CssClass="FeedbackMessage";

					this.plhCriteria.Visible=false;
					
				}   
				else
				{
					this.trvUnitsSelector.LoadXml(strUnits);

					this.plhCriteria.Visible=true;
					
				}
				// Show select to unit tree
				DisplayUnits();
				//SetSortOrder("LastName");
			}
		}

		/// <summary>
		/// Event handler for the find button
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		/// <remarks>Notes:
		/// Executes the search based upon the parameters chosen
		/// </remarks>
		protected void btnFind_Click(object sender, System.EventArgs e)
		{
			//ShowData(0);
			// Reset the record of selected users
			this.txtAllUserIDs.Text = "";
			this.txtUserIDs.Text =  "";
			// Reset the message label
			this.lblStatus.Text = "";
			this.chkSelectAll.Checked = false;
			StartPagination();

		} // btnFind_Click


		/// <summary>
		/// Event handler for the reset button
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void btnReset_Click(object sender, System.EventArgs e)
		{
			Response.Redirect(Request.RawUrl);
		}


		/// <summary>
		/// This method displays the units that are available to the administrator
		/// </summary>
		private void DisplayUnits()
		{
			// Unit object used to gather tree information for the treeview control
			BusinessServices.Unit objUnit = new BusinessServices.Unit();
			
			// Dataset of units returned by the Unit object
			DataSet dstUnits ;
			
			// Get Units accessable to this user.
			try 
			{
				// Gets the units that the current user is an administrator of.
				dstUnits = objUnit.GetUnitsTreeByUserID(UserContext.UserData.OrgID ,UserContext.UserID,'A');
			
				// Convert this to an xml string for rendering by the UnitTreeConverter.
				string strUnits = UnitTreeConvert.ConvertXml(dstUnits);
				if (strUnits=="")
				{
					// No units found.
					this.lblError.Visible = true;
					this.lblError.Text=ResourceManager.GetString("lblError.NoUnit");//"No units found";
					this.lblError.CssClass = "FeedbackMessage";
				}
				else
				{
					// Change to the appropriate view and load the Units in
					this.trvToUnitsSelector.LoadXml(strUnits);
					
				}
			}
			catch (Exception Ex)
			{
				// General Exception occured, log it
				ErrorLog objError = new ErrorLog(Ex,ErrorLevel.Medium,"MoveUsersToUnit.aspx.cs","DisplayUnits","Displaying Units");
			}
		}
		#endregion
		#region Private Methods
		
		#region TreeView User Results
		
		/// <summary>
		/// This is the method called when the user elects to add the selected users to the unit
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void btnAssign_Click(object sender, System.EventArgs e)
		{
			lblError.Text = "";
			lblStatus.Text = "";
				// Check if user has select a unit
			if (this.trvToUnitsSelector.GetSelectedValue() == null)
			{
				lblError.Visible = true;
				lblError.Text = ResourceManager.GetString("lblError.Select");//"You must select a unit to continue.";
				this.lblError.CssClass = "WarningMessage";
			}
			else
			{
				try
				{
					int intAdded=0;		// Counter of added users
					int intUnitID;		// Desired Unit ID
					int intUserID;		// User ID
					User objUser = new User();
					
					// Check a unit has been selected
					if (trvToUnitsSelector.GetSelectedValue().ToString() != "")  
					{
						// Get the unit it (its a single select tree)
						intUnitID = Convert.ToInt32 (trvToUnitsSelector.GetSelectedValue()); 
                        
						// Instantiate the unit
						BusinessServices.Unit objUnit = new BusinessServices.Unit();
						DataTable dtbUnit = objUnit.GetUnit(intUnitID);
						string strUnitName = dtbUnit.Rows[0]["Name"].ToString();
                        
						// Update the users on the current page
						foreach (DataGridItem objItem in this.dgrResults.Items)
						{
							// Get the checkbox in the first column
							CheckBox objCheckbox =(CheckBox) objItem.Cells[0].Controls[1];
							
							if (objCheckbox.Checked)
							{
								// Get the user id from the second column which is hidden.
								intUserID = Int32.Parse(objItem.Cells[1].Text);
							
								// Update the actual user.
								objUser.Update (intUserID,intUnitID,UserContext.UserID, UserContext.UserData.OrgID);
								objUser.UpdateUserProfilePeriodAccess(intUserID, intUnitID);
								objUser.UpdateUserPolicyAccess(intUserID, intUnitID);
								//intAdded++;
							}
						}
						
						//if there are users from other pages
						if (this.txtUserIDs.Text.Length>1)
						{
							// Array of user IDs from the txtUserID's field on the page.
							string[] strUserIDs = this.txtUserIDs.Text.Split(','); 

							// For each user id
							foreach (string strUserID in strUserIDs)
							{
								if (strUserID.Length>0)
								{
									// Update those users as well
									objUser.Update (Int32.Parse(strUserID),intUnitID,UserContext.UserID, UserContext.UserData.OrgID);
									intAdded++;
								}
							}
						}
						// If users have been added
						if (intAdded > 0)
						{
							
							// Display status message
							//if (chkSelectAll.Checked)
							//{
								//this.lblStatus.Text=String.Format(ResourceManager.GetString("lblStatus.Assigned"), strUnitName);//"Assigned all users to '" + strUnitName + "'.";
							//}
							//else
							//{
							lblStatus.Visible = true;
								this.lblStatus.Text=String.Format(ResourceManager.GetString("lblStatus.Assigned2"), intAdded.ToString(), strUnitName);//"Assigned " + intAdded.ToString() + " users to '" + strUnitName + "'.";
							//}
							this.lblStatus.CssClass = "SuccessMessage";
							//this.txtUserIDs.Text=",";
							this.chkSelectAll.Checked = false;
							// Reset the record of selected users
							this.txtAllUserIDs.Text = "";
							this.txtUserIDs.Text =  "";
							StartPagination();
						}
						else
						{
							// No users selected
							this.lblError.Text = ResourceManager.GetString("lblError.SelectUsers");//"You must select some users to continue.";
							this.lblError.CssClass = "WarningMessage";
							this.lblStatus.Visible = false;
						}
					}
					else
					{
						// No Unit selected
						if (lblError.Text == "")
						{
							lblError.Visible = true;
							lblError.Text=ResourceManager.GetString("lblError.SelectUnit");//"Please select a unit to assign these users to.";
							this.lblError.CssClass = "WarningMessage";
							this.lblStatus.Visible = false;
						}
						else
						{
							lblError.Visible = true;
							lblError.Text=ResourceManager.GetString("lblError.SelectUnit");//"Please select a unit to assign these users to.";
							this.lblError.CssClass = "WarningMessage";
							this.lblStatus.Visible = false;
						}
					}
				}
				catch (RecordNotFoundException ex)
				{
					lblError.Visible = true;
					lblError.Text=ex.Message;
					this.lblError.CssClass = "WarningMessage";
					this.lblStatus.Visible = false;
				}
				catch(Exception Ex) 
				{
					// Error occurred, Log it.
					throw new Exception(Ex.Message);
				}
			}

		}

		protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
		{
			if (chkSelectAll.Checked)
			{
				//this is to reset in the case that user has ticked another unit between select all/deselect all
				this.txtUserIDs.Text = "";
				this.txtAllUserIDs.Text = "";
				StartPagination();

				this.txtUserIDs.Text = this.txtAllUserIDs.Text;
				StartPagination();
			}
			else
			{
				this.txtUserIDs.Text = "";
				this.txtAllUserIDs.Text = "";
				StartPagination();
			}
			
		}

		/// <summary>
		/// This method is called when the user has moved to the next page and they need to be reticked.
		/// </summary>
		private void Update ()
		{
			foreach (DataGridItem objItem in this.dgrResults.Items)
			{
				// Get the checkbox in the first column
				System.Web.UI.WebControls.CheckBox objCheckbox =(System.Web.UI.WebControls.CheckBox) objItem.Cells[0].Controls[1];
				
				// Get the user id from the second column which is hidden.
				string strUserID = objItem.Cells[1].Text;
				string[] astrUserIDs;
				bool blnExists;
				int intIndex;
					
				// If the user is selected
				if (objCheckbox.Checked)
				{
					if (this.txtUserIDs.Text.Length > 0)
					{
						blnExists = false;
						astrUserIDs = this.txtUserIDs.Text.Split(',');
						for (intIndex=0;intIndex!=astrUserIDs.Length;intIndex++)
						{
							if (astrUserIDs[intIndex] == strUserID)
							{
								blnExists = true;
							}
						}
						if (!(blnExists))
						{
							this.txtUserIDs.Text = string.Join(",",astrUserIDs) + "," + strUserID;
						}
					}
					else
					{
						this.txtUserIDs.Text = strUserID;
					}
					
				}
				else
				{
					// Replace this user as they have been deselected
					if (this.txtUserIDs.Text.Length > 0)
					{
						astrUserIDs = this.txtUserIDs.Text.Split(',');
						for (intIndex=0;intIndex!=astrUserIDs.Length;intIndex++)
						{
							if (astrUserIDs[intIndex] == strUserID)
							{
								astrUserIDs[intIndex]=null;
							}
						}
						this.txtUserIDs.Text = string.Join(",", astrUserIDs);
						this.txtUserIDs.Text = this.txtUserIDs.Text.Replace(",,",",");
						this.txtUserIDs.Text = this.txtUserIDs.Text.TrimStart(',');
						this.txtUserIDs.Text = this.txtUserIDs.Text.TrimEnd(',');
					}
					
					
				}
			}
		}

		/// <summary>
		/// This method is called with each row being rendered on the datagrid.
		/// It checks if the user id should be selected and checkes the checkbox appropriately.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void dgrResults_ItemDataBound(object sender, DataGridItemEventArgs e)
		{
			// This event is triggered with ever row drawn by the datagrid
			// but we only want to handle the data rows, not the headers etc.
			if(e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.SelectedItem || e.Item.ItemType == ListItemType.EditItem)
			{
				// Turn the comma seperated values in to a string array
				string[] strUserIDsSelected = this.txtUserIDs.Text.ToString().Split(',');
				
				// Get the user id from the datagrid (its hidden in the second column)
				int intUserID = Convert.ToInt32(e.Item.Cells[1].Text.ToString());
	
				// then get the control
				System.Web.UI.WebControls.CheckBox objCheckbox =(System.Web.UI.WebControls.CheckBox) e.Item.Cells[0].Controls[1];
				objCheckbox.Attributes.Add("onClick","Control_ClickCheckBox('txtUserIDs',this,'" + e.Item.Cells[1].Text +"');");
				objCheckbox.Checked=false;

				foreach (string strUserIDSelected in  strUserIDsSelected)
				{
					// if this userid has been previously selected
					if (intUserID.ToString() == strUserIDSelected)
					{
						// and select it again
						objCheckbox.Checked=true;
						break;
					}
				}
			}
		}
		#endregion


		/// <summary>
		/// isUnitSelected determines whether the user has selected a unit to search for.
		/// </summary>
		/// <returns>boolean whether there is currently a selected Unit and therefore
		/// whether we can execute a search.
		/// </returns>
		private bool isUnitSelected()
		{
			bool blnReturn;

			blnReturn = false;

			if (trvUnitsSelector.GetSelectedValues().Length > 0)
			{
				blnReturn = true;
			}
			
			return(blnReturn);
		}

		/// <summary>
		/// Get Data
		/// </summary>
		/// <returns></returns>
		private DataView GetData()
		{
			string strParentUnits;

			strParentUnits = String.Join(",", this.trvUnitsSelector.GetSelectedValues());
            
			BusinessServices.User objUser = new BusinessServices.User();
			DataTable dtbSearchResults = objUser.Search(UserContext.UserData.OrgID, strParentUnits, this.txtFirstName.Text, this.txtLastName.Text, this.txtUsername.Text, UserContext.UserID,this.chkInactiveUsers.Checked);
			
			return dtbSearchResults.DefaultView;
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

			dgrResults.Columns[2].HeaderText = ResourceManager.GetString("cmnLastName");
			dgrResults.Columns[3].HeaderText = ResourceManager.GetString("cmnFirstName");
			dgrResults.Columns[4].HeaderText = ResourceManager.GetString("grid_LastLogin");
			dgrResults.Columns[5].HeaderText = ResourceManager.GetString("grid_UnitPathway");
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{   
			this.dgrResults.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(this.dgrResults_ItemDataBound);

		}
		#endregion

		protected override void Render(HtmlTextWriter writer)
		{
			//-- Hack. Could not work out how to use the render event in the tree view, therefore this code is run on every page that has a tree view. Hope to refactor after discovering the solution.
			System.Text.StringBuilder sb = new System.Text.StringBuilder();
			System.IO.StringWriter sw = new System.IO.StringWriter(sb);
			HtmlTextWriter newWriter = new HtmlTextWriter(sw);
                  
			base.Render(newWriter);
                  
			sb.Replace("Clear All", ResourceManager.GetString("treeClearAll"));
			sb.Replace("Collapse All", ResourceManager.GetString("treeCollapseAll"));
			sb.Replace("Expand All", ResourceManager.GetString("treeExpandAll"));
			sb.Replace("class=\"TreeView_Node\">Help</a>", "class=\"TreeView_Node\">" + ResourceManager.GetString("treeHelp") + "</a>");
			sb.Replace("Select All", ResourceManager.GetString("treeSelectAll"));

			Response.Write(sb.ToString());
			// -End Hack
			
		}

		#region Pagination customisation (Change this section according to business logic)
		/// <summary>
		/// Start Pagination
		/// </summary>
		private void StartPagination()
		{
			//Initialize Pagination settings
			ViewState["OrderByField"] = "";
			ViewState["OrderByDirection"] = "";
			
			//this.tblPagination.Visible = true;
			this.ShowPagination(0);
		}
		
		/// <summary>
		/// Get Pagination Data
		/// </summary>
		/// <returns></returns>
		private DataView GetPaginationData()
		{
			//Customize, and return DataView
			// conduct search based on criteria
			string strParentUnits;

			strParentUnits = String.Join(",", this.trvUnitsSelector.GetSelectedValues());
            
			BusinessServices.User objUser = new BusinessServices.User();
			DataTable dtbSearchResults = objUser.Search(UserContext.UserData.OrgID, strParentUnits, this.txtFirstName.Text, this.txtLastName.Text, this.txtUsername.Text, UserContext.UserID,this.chkInactiveUsers.Checked);
			
			return dtbSearchResults.DefaultView;

		}
		#endregion

		#region Pagination Event Handlers (Don't make any changes to this section)
		/// <summary>
		/// Go to previous page.
		/// </summary>
		protected void btnPrev_Click(object sender, System.EventArgs e)
		{
			Update();
			this.ShowPagination(this.dgrResults.CurrentPageIndex - 1);
		}
		
		/// <summary>
		/// Go to next page.
		/// </summary>
		protected void btnNext_Click(object sender, System.EventArgs e)
		{
			Update();
			this.ShowPagination(this.dgrResults.CurrentPageIndex + 1);
		}

		/// <summary>
		/// Go to a specific page.
		/// </summary>
		protected void cboPage_SelectedIndexChanged(object sender, System.EventArgs e)
		{
			Update();
			int intPageIndex;
			intPageIndex = int.Parse(this.cboPage.SelectedValue);
			this.ShowPagination(intPageIndex - 1);
		}
	
		/// <summary>
		/// Show Paging Data.
		/// </summary>
		/// <param name="currentPageIndex"></param>
		private void ShowPagination(int currentPageIndex)
		{
			//1. Get data
			DataView  dvwPagination = this.GetPaginationData();

			if (dvwPagination.Table.Rows.Count != 0)
			{
				this.plhUserResults.Visible = true;
				this.btnAssign.Visible = true;
				this.lblError.Text = "";
				this.lblError.Visible = false;
			}
			else
			{
				this.plhUserResults.Visible = false;
				this.btnAssign.Visible = false;
				this.lblError.Text = ResourceManager.GetString("lblError.NoUsers");
				this.lblError.CssClass =  "WarningMessage";
				this.lblError.Visible = true;
			}
			if(dvwPagination.Count <= ApplicationSettings.PageSize)
			{
				this.trPagination.Visible = false;
			} 
			else 
			{
				this.trPagination.Visible = true;
			}
			
			if(dvwPagination.Count == 0)
			{
				this.tblPagination.Visible = false;
			}
			
			
			//3. Set pagination panel
			int intPageSize;
			intPageSize = ApplicationSettings.PageSize ;
			this.SetPaginationPanel(intPageSize, dvwPagination.Count, currentPageIndex);

			//4. Bind Data
			//5. Set the Key field for the DataGrid
			dgrResults.DataKeyField = "UserID";
			dgrResults.DataSource = dvwPagination;
			dgrResults.PageSize = intPageSize;
			dgrResults.CurrentPageIndex = currentPageIndex;

			// This is needed by the select all functionality
			if (this.txtAllUserIDs.Text.Length==0)
			{
				foreach (DataRow drwItem in dvwPagination.Table.Rows)
				{
					this.txtAllUserIDs.Text += drwItem.ItemArray[0].ToString() + ",";
				}
				if (this.txtAllUserIDs.Text.Length>0)
				{
					this.txtAllUserIDs.Text = (this.txtAllUserIDs.Text.Substring(0,this.txtAllUserIDs.Text.Length-1));
				}
			}

			dgrResults.DataBind();
		}

		/// <summary>
		/// Sets the pagination panel.
		/// </summary>
		/// <param name="pageSize"></param>
		/// <param name="totalRecordCount"></param>
		/// <param name="currentPageIndex"></param>
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
