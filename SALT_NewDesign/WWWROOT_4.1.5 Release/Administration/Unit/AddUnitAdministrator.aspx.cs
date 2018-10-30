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

using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.Web.Utilities;
using Localization;
namespace Bdw.Application.Salt.Web.Administration.Unit
{
	/// <summary>
	/// Summary description for AddUnitAdministrator.
	/// </summary>
	public partial class AddUnitAdministrator : System.Web.UI.Page
	{
        /// <summary>
        /// 
        /// </summary>
		protected System.Web.UI.WebControls.Label lblMessage;

        /// <summary>
        /// 
        /// </summary>
		protected System.Web.UI.WebControls.TextBox txtFirstName;

        /// <summary>
        /// 
        /// </summary>
		protected System.Web.UI.WebControls.TextBox txtLastName;

        /// <summary>
        /// Button to find unit admins
        /// </summary>
		protected System.Web.UI.WebControls.Button btnFind;

        /// <summary>
        /// Datagrid that holds results
        /// </summary>
		protected System.Web.UI.WebControls.DataGrid grdPagination;

        /// <summary>
        /// Combo box to select page to jump to 
        /// </summary>
		protected System.Web.UI.WebControls.DropDownList cboPage;

        /// <summary>
        /// Label showing page count
        /// </summary>
		protected System.Web.UI.WebControls.Label lblPageCount;

        /// <summary>
        /// Label showing current records on page.
        /// </summary>
		protected System.Web.UI.WebControls.Label lblCurrentPageRecordCount;

        /// <summary>
        /// Label showing total record count
        /// </summary>
		protected System.Web.UI.WebControls.Label lblTotalRecordCount;

        /// <summary>
        /// Previous page button
        /// </summary>
		protected System.Web.UI.WebControls.LinkButton btnPrev;

        /// <summary>
        /// next page button
        /// </summary>
		protected System.Web.UI.WebControls.LinkButton btnNext;

        /// <summary>
        /// Table containingn pagination
        /// </summary>
		protected System.Web.UI.HtmlControls.HtmlTable tblPagination;

        /// <summary>
        /// Button to add Unit admin
        /// </summary>
		protected System.Web.UI.WebControls.Button btnAdd;

        /// <summary>
        /// 
        /// </summary>
		protected System.Web.UI.WebControls.CheckBox chkAdminSub;

        /// <summary>
        /// Table row for pagination
        /// </summary>
		protected System.Web.UI.HtmlControls.HtmlTableRow trPagination;

        /// <summary>
        /// Label for page title
        /// </summary>
        protected System.Web.UI.WebControls.Label lblPageTitle;
	
		/// <summary>
		/// This is the Unit ID passed in via querystring.
		/// It is the unit to which the administrator must be added
		/// </summary>
		protected int m_intUnitID;

		/// <summary>
		/// Event handler for the page load event
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			// Get the unit id from the querystring
			this.m_intUnitID = int.Parse(Request.QueryString["UnitID"]);

			WebSecurity.CheckUnitAdministrator(this.m_intUnitID);


			if (!Page.IsPostBack)
			{
				BusinessServices.Unit objUnit= new  BusinessServices.Unit();
				DataSet dstUnits = objUnit.GetUnitsTreeByUserID(UserContext.UserData.OrgID,UserContext.UserID,'A');
				
				// Get permissions of the user on this unit
				string strPermission = objUnit.GetPermission(this.m_intUnitID,UserContext.UserID);
				
				// If administrator
				if (strPermission=="A")
				{
					this.chkAdminSub.Visible = false;
				}

				this.tblPagination.Visible = false;


			}

		}

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
			grdPagination.Columns[1].HeaderText = ResourceManager.GetString("cmnUserName");
			grdPagination.Columns[2].HeaderText = ResourceManager.GetString("cmnLastName");
			grdPagination.Columns[3].HeaderText = ResourceManager.GetString("cmnFirstName");
			grdPagination.Columns[4].HeaderText = ResourceManager.GetString("grid_PathWay");
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

		/// <summary>
		/// Event handler for the Add button
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void btnAdd_Click(object sender, System.EventArgs e)
		{
			// Unit object used to add the adminisrator
			BusinessServices.Unit objUnit;
			
			// The userif from the previous form
			int intUserID;	

			// boolean flag indicating if the SubUnit option was checked
			bool blnAdminSubUnit;

			// Gather variables
            if(Request.Form["UserID"] == null)
            {
                this.lblMessage.Text = ResourceManager.GetString("lblMessage.NoUser");//"You did not select a user!";
                this.lblMessage.CssClass = "WarningMessage";
            }
            else
            {
                intUserID = int.Parse(Request.Form["UserID"]);
                blnAdminSubUnit = this.chkAdminSub.Checked;
			
                objUnit= new  BusinessServices.Unit();
			
                // Add Administrator to new unit
                objUnit.AddAdministrator(this.m_intUnitID,intUserID,blnAdminSubUnit,UserContext.UserID);
                
                Response.Redirect("UnitAdministrators.aspx?UnitID=" + m_intUnitID.ToString());
            }
		}

		/// <summary>
		/// Event handler for the Find button
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void btnFind_Click(object sender, System.EventArgs e)
		{
	
			this.tblPagination.Visible = true;


			StartPagination();
		}

		#region Pagination customization(Change this section according to business logic)
		/// <summary>
		/// Start Pagination
		/// </summary>
		private void StartPagination()
		{
			//Initialize Pagination settings
			ViewState["OrderByField"]="";
			ViewState["OrderByDirection"]="";
			this.SetPaginationOrder("LastName"); //customization
			this.ShowPagination(0);
		}

		/// <summary>
		/// Get Pagination Data
		/// </summary>
		/// <returns></returns>
		private DataView GetPaginationData()
		{
			BusinessServices.User objUser;
			DataTable dtbUsers;
			
			 string strFirstName, strLastName;
			
			strFirstName = this.txtFirstName.Text.Trim();
			strLastName = this.txtLastName.Text.Trim();
			
			objUser= new BusinessServices.User();
            dtbUsers = objUser.Search(UserContext.UserData.OrgID,null,strFirstName,strLastName,UserContext.UserID,false);
			
			return dtbUsers.DefaultView;
		}

		#endregion

		#region Pagination event handler(Don't make any changes to this section)
		/// <summary>
		/// Go to previous page
		/// </summary>
		protected void btnPrev_Click(object sender, System.EventArgs e)
		{
			
			this.ShowPagination(this.grdPagination.CurrentPageIndex-1);
		}
		/// <summary>
		/// Go to next page	
		/// </summary>
		protected void btnNext_Click(object sender, System.EventArgs e)
		{
			this.ShowPagination(this.grdPagination.CurrentPageIndex+1);
		}

		/// <summary>
		/// Go to a specific page
		/// </summary>
		protected void cboPage_SelectedIndexChanged(object sender, System.EventArgs e)
		{
			int intPageIndex;
			intPageIndex = int.Parse(this.cboPage.SelectedValue);
			this.ShowPagination(intPageIndex-1);
		}

		/// <summary>
		///Sort data
		/// </summary>
		private void grdPagination_SortCommand(object source, System.Web.UI.WebControls.DataGridSortCommandEventArgs e)
		{
			this.SetPaginationOrder(e.SortExpression);
			this.ShowPagination(0);
		}

		/// <summary>
		/// Set order field
		/// </summary>
		/// <param name="orderByField"></param>
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
		/// Show Paging Data
		/// </summary>
		/// <param name="currentPageIndex"></param>
		private void ShowPagination(int currentPageIndex)
		{
			//1. Get data
			DataView  dvwPagination = this.GetPaginationData();
			//2. Sort Data
			string	strOrderByField, strOrderByDirection;
			strOrderByField =(string)ViewState["OrderByField"];
			strOrderByDirection =(string)ViewState["OrderByDirection"];

			dvwPagination.Sort = strOrderByField + " " + strOrderByDirection;

			//3. Set pagination panel
			int intPageSize;
			intPageSize = ApplicationSettings.PageSize ;
			this.SetPaginationPanel(intPageSize, dvwPagination.Count,ref currentPageIndex);

			//4. Bind Data
			grdPagination.DataSource = dvwPagination;
			grdPagination.PageSize = intPageSize;
			grdPagination.CurrentPageIndex = currentPageIndex;
			grdPagination.DataBind();
		}


		/// <summary>
		///Set pagination panel 
		/// </summary>
		/// <param name="pageSize"></param>
		/// <param name="totalRecordCount"></param>
		/// <param name="currentPageIndex"></param>
		private void SetPaginationPanel(int pageSize, int totalRecordCount, ref int currentPageIndex)
		{
			//1. Get pagination info
			int intPageSize,intTotalRecordCount,intPageCount,intCurrentPageStart, intCurrentPageEnd;
			ListItem objItem;
			

			intPageSize = pageSize;
			intTotalRecordCount = totalRecordCount;
			intPageCount = ((int)(intTotalRecordCount-1)/intPageSize)+1;

			//Check currentPageIndex
			if (currentPageIndex<0)
			{
				currentPageIndex=0;
			}
			else if (currentPageIndex>intPageCount-1)
			{
				currentPageIndex=intPageCount-1;
			}

			//Page start record number
			if (intTotalRecordCount!=0)
			{
				intCurrentPageStart = intPageSize * currentPageIndex+1;
			}
			else
			{
				intCurrentPageStart = 0;
			}
			//Page end record number
			if (currentPageIndex<intPageCount-1)
			{
				intCurrentPageEnd =  intPageSize * (currentPageIndex+1);
			}
				//Last page, the page record count is the remaining records
			else
			{
				intCurrentPageEnd = intTotalRecordCount;
			}
			
			//2. Set  pagination
			//2.1 Set dropdown page selector
			this.cboPage.Items.Clear();
			for(int i=1;i<= intPageCount; i++)
			{
				objItem = new ListItem(i.ToString());
				if (i==currentPageIndex+1)
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
			if (currentPageIndex==0)
			{	
				this.btnPrev.Enabled = false;
			}
			//Last Page
			if (currentPageIndex==intPageCount-1)
			{	
				this.btnNext.Enabled = false;
			}
		}
		#endregion
	}
}
