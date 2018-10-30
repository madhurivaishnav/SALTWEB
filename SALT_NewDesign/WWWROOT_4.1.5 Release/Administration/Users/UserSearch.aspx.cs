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
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Data;
using Localization;

namespace Bdw.Application.Salt.Web.Administration.Users
{
	/// <summary>
	/// User Search page which allows an administrator to search
	/// for and select users to edit.
	/// </summary>
	/// /// <remarks>
	/// Assumptions: User must be and administrator to view this page.
	/// Notes: 
	/// Author: John Crawford
	/// Date: 18/02/2004
	/// Changes:
	/// </remarks>
	public partial class UserSearch : System.Web.UI.Page
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
		/// Textbox for username
		/// </summary>
		protected System.Web.UI.WebControls.TextBox txtEmail;

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

        /// <summary>
        /// Checkbox to include inactive users in search
        /// </summary>
		protected System.Web.UI.WebControls.CheckBox chkInactiveUsers;
		#endregion	
	
		#region Private Event Handlers
		/// <summary>
		/// Event Handler for the Page Load event.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
            pagTitle.InnerText = ResourceManager.GetString("pagTitle");
            // tooltip
            txtUserID.ToolTip = ResourceManager.GetString("tooltipExactID");

            if (!Page.IsPostBack)
			{
                BusinessServices.Unit objUnit = new BusinessServices.Unit();
			
                DataSet dstUnits = objUnit.GetUnitsTreeByUserID(UserContext.UserData.OrgID, UserContext.UserID, 'A');
			
                // reset the tree view control on each load
                trvUnitsSelector.ClearSelection();

                string strUnits = UnitTreeConvert.ConvertXml(dstUnits);
                if (strUnits=="")
                {
                    this.lblNoSubUnits.Visible=true;
                    this.lblNoSubUnits.CssClass="FeedbackMessage";

                    this.plhCriteria.Visible=false;
                    this.plhResults.Visible=false;
                }   
                else
                {
                    this.trvUnitsSelector.LoadXml(strUnits);

                    this.plhCriteria.Visible=true;
                    this.plhResults.Visible=false;
                }
                SetSortOrder("LastName");
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
			 ShowData(0);
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
		///Sorts the data.
		/// </summary>
		private void grdResults_SortCommand(object source, System.Web.UI.WebControls.DataGridSortCommandEventArgs e)
		{
			SetSortOrder(e.SortExpression);
			ShowData(0);
		}

        /// <summary>
        /// 
        /// </summary>
        /// <param name="source"></param>
        /// <param name="e"></param>
        private void grdResults_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
        {
            ShowData(e.NewPageIndex);
        }


		private void grdResults_ItemDataBound(object sender, DataGridItemEventArgs e)
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
        #endregion

		#region Private Methods
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
            int userID;

            strParentUnits = String.Join(",", this.trvUnitsSelector.GetSelectedValues());
            // convert the user ID text to int
            bool result = Int32.TryParse(this.txtUserID.Text, out userID);
            if (!result)
                userID = 0;
            
            BusinessServices.User objUser = new BusinessServices.User();
            DataTable dtbSearchResults = objUser.Search(UserContext.UserData.OrgID, strParentUnits, this.txtFirstName.Text, this.txtLastName.Text, this.txtUsername.Text, UserContext.UserID, this.chkInactiveUsers.Checked, this.txtEmail.Text, userID);
			
            return dtbSearchResults.DefaultView;
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
                grdResults.DataBind();
                lblUserCount.Text = String.Format(ResourceManager.GetString("lblUserCount"), intRowCount.ToString());
                plhResults.Visible=true;
            }
            else
            {
                lblMessage.Text = ResourceManager.GetString("lblMessage.NoUsersFound");
                lblMessage.CssClass = "FeedbackMessage";
                plhResults.Visible = false;
            }
			
        }
		#endregion

        #region Web Form Designer generated code
        /// <summary>
        ///  This call is required by the ASP.NET Web Form Designer.
        /// </summary>
        /// <param name="e"></param>
        override protected void OnInit(EventArgs e)
        {
            //
            // CODEGEN: This call is required by the ASP.NET Web Form Designer.
            //
            InitializeComponent();
            base.OnInit(e);

            grdResults.Columns[0].HeaderText = ResourceManager.GetString("cmnUserID");
			grdResults.Columns[1].HeaderText = ResourceManager.GetString("cmnLastName");
			grdResults.Columns[2].HeaderText = ResourceManager.GetString("cmnFirstName");
			grdResults.Columns[3].HeaderText = ResourceManager.GetString("grid_LastLogin");
			grdResults.Columns[4].HeaderText = ResourceManager.GetString("grid_UnitPathway");
        }
		
        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {    
			this.grdResults.PageIndexChanged += new System.Web.UI.WebControls.DataGridPageChangedEventHandler(this.grdResults_PageIndexChanged);
			this.grdResults.SortCommand += new System.Web.UI.WebControls.DataGridSortCommandEventHandler(this.grdResults_SortCommand);
			this.grdResults.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(this.grdResults_ItemDataBound);

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

	}
}
