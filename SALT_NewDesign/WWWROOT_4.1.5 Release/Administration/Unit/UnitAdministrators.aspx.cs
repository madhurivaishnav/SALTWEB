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
using System.Configuration;
using Bdw.Application.Salt.Web.Reporting;
using System.Data.Linq;
using System.Linq;
namespace Bdw.Application.Salt.Web.Administration.Unit
{
	/// <summary>
	/// Summary description for UnitAdministrators.
	/// </summary>
	public partial class UnitAdministrators : System.Web.UI.Page
	{
        /// <summary>
        /// Datagrid for results
        /// </summary>
		protected System.Web.UI.WebControls.DataGrid grdPagination;

        /// <summary>
        /// Drop downlist to jump to selected page
        /// </summary>
		protected System.Web.UI.WebControls.DropDownList cboPage;

        /// <summary>
        /// Label for total number of pages
        /// </summary>
		protected System.Web.UI.WebControls.Label lblPageCount;

        /// <summary>
        /// Label for current records on page
        /// </summary>
		protected System.Web.UI.WebControls.Label lblCurrentPageRecordCount;

        /// <summary>
        /// Label for total records returned
        /// </summary>
		protected System.Web.UI.WebControls.Label lblTotalRecordCount;

        /// <summary>
        /// Previous page button
        /// </summary>
		protected System.Web.UI.WebControls.LinkButton btnPrev;

        /// <summary>
        /// Next page button
        /// </summary>
		protected System.Web.UI.WebControls.LinkButton btnNext;

        /// <summary>
        /// Table surrounding pagination
        /// </summary>
		protected System.Web.UI.HtmlControls.HtmlTable tblPagination;

        /// <summary>
        /// Table row surrounding pagination
        /// </summary>
		protected System.Web.UI.HtmlControls.HtmlTableRow trPagination;

        /// <summary>
        /// Label for page title
        /// </summary>
        protected System.Web.UI.WebControls.Label lblPageTitle;

		/// <summary>
		/// Unit id of the unit that is being administered
		/// </summary>
		protected int m_intUnitID;

        /// <summary>
        /// Page load event handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
			ResourceManager.RegisterLocaleResource("RemoveMessage");
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			this.m_intUnitID = int.Parse(Request.QueryString["UnitID"]);

			WebSecurity.CheckUnitAdministrator(this.m_intUnitID);
			
			if (!Page.IsPostBack)
			{
				this.StartPagination();
			}
		}

        /// <summary>
        /// This event is fired with each row bound to the datagrid
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
		private void grdPagination_ItemDataBound(object sender, System.Web.UI.WebControls.DataGridItemEventArgs e)
		{
			if (e.Item.ItemType ==ListItemType.Item || e.Item.ItemType ==ListItemType.AlternatingItem || e.Item.ItemType ==ListItemType.SelectedItem || e.Item.ItemType ==ListItemType.EditItem)
			{
				DataRowView drvUser =(DataRowView)e.Item.DataItem;
				string strFirstName, strLastName, strFullName;
				
				strFirstName = (string)drvUser["FirstName"];
				strLastName = (string)drvUser["LastName"];
				strFullName = strFirstName + " " + strLastName;

				strFullName = strFullName.Replace("'","\\'");

				LinkButton btnRemove = (LinkButton)e.Item.Cells[4].FindControl("btnRemove");
				if (btnRemove!=null)
				{
					btnRemove.Attributes.Add("onclick", "javascript:return RemovingConfirm('" + strFullName + "');");
					btnRemove.Text = ResourceManager.GetString("grid_btnRemove");
				}
			}

		}
		private void grdPagination_DeleteCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
		{
			int intUserID = (int)this.grdPagination.DataKeys[e.Item.ItemIndex];

			BusinessServices.Unit objUnit;
			
			objUnit= new  BusinessServices.Unit();
			
			objUnit.RemoveAdministrator(this.m_intUnitID,intUserID,UserContext.UserID);
			
			this.ShowPagination(this.grdPagination.CurrentPageIndex);

            int periodicReportsCount = PeriodicReportCountUser(intUserID);
            if (periodicReportsCount > 0)
                Response.Redirect("/Reporting/PeriodicReportList.aspx?user=" + intUserID + "&isoninactivate=true");
		}

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
			grdPagination.Columns[0].HeaderText = ResourceManager.GetString("cmnUserName");
			grdPagination.Columns[1].HeaderText = ResourceManager.GetString("cmnLastName");
			grdPagination.Columns[2].HeaderText = ResourceManager.GetString("cmnFirstName");
			grdPagination.Columns[3].HeaderText = ResourceManager.GetString("cmnEmail" );

		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
            this.grdPagination.SortCommand += new System.Web.UI.WebControls.DataGridSortCommandEventHandler(this.grdPagination_SortCommand);
            this.grdPagination.DeleteCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.grdPagination_DeleteCommand);
            this.grdPagination.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(this.grdPagination_ItemDataBound);

        }
		#endregion

	
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
			BusinessServices.Unit objUnit;
			DataTable dtbUsers;
			
			objUnit= new  BusinessServices.Unit();

			dtbUsers = objUnit.GetAdministrators(this.m_intUnitID);
			
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
			this.SetPaginationPanel(intPageSize, dvwPagination.Count, ref currentPageIndex);

			//4. Bind Data
			grdPagination.DataKeyField = "UserID";
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
