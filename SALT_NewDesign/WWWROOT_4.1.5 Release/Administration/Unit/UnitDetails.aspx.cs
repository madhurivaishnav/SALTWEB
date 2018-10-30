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
	/// Summary description for UnitDetails.
	/// </summary>
	public partial class UnitDetails : System.Web.UI.Page
    {
        /// <summary>
        /// Textbox for unit name
        /// </summary>
		protected System.Web.UI.WebControls.TextBox txtName;

		/// <summary>
		/// Textbox for unit ID
		/// </summary>
		protected System.Web.UI.WebControls.TextBox txtUnitID;

        /// <summary>
        /// Required field validator for name
        /// </summary>
		protected System.Web.UI.WebControls.RequiredFieldValidator rvldName;

        /// <summary>
        /// Drop down list of status's for user
        /// </summary>
		protected System.Web.UI.WebControls.DropDownList cboStatus;

        /// <summary>
        /// Label for unit pathway
        /// </summary>
		protected System.Web.UI.WebControls.Label lblPathway;

        /// <summary>
        /// Treeview control for unit selection
        /// </summary>
		protected Uws.Framework.WebControl.TreeView trvSubUnits;

        /// <summary>
        /// Label to inform user of there being no subunits
        /// </summary>
		protected System.Web.UI.WebControls.Label lblNoSubUnits;

        /// <summary>
        /// Label to inform user of warnings errors etc.
        /// </summary>
		protected System.Web.UI.WebControls.Label lblMessage;

        /// <summary>
        /// Button to save settings
        /// </summary>
		protected System.Web.UI.WebControls.Button btnSave;

        /// <summary>
        /// Table that surrounds pagination
        /// </summary>
		protected System.Web.UI.HtmlControls.HtmlTable tblPagination;

        /// <summary>
        /// Datagrid of results
        /// </summary>
		protected System.Web.UI.WebControls.DataGrid grdPagination;

        /// <summary>
        /// Drop down list of pages to jump to
        /// </summary>
		protected System.Web.UI.WebControls.DropDownList cboPage;

        /// <summary>
        /// Label for page Counter
        /// </summary>
		protected System.Web.UI.WebControls.Label lblPageCount;

        /// <summary>
        /// Label for records on page
        /// </summary>
		protected System.Web.UI.WebControls.Label lblCurrentPageRecordCount;

        /// <summary>
        /// Label for total records
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
        /// Table that surrounds pagination controls
        /// </summary>
		protected System.Web.UI.HtmlControls.HtmlTableRow trPagination;

        /// <summary>
        /// Label for page title
        /// </summary>
        protected System.Web.UI.WebControls.Label lblPageTitle;

        /// <summary>
        /// Link to import users
        /// </summary>
        protected System.Web.UI.WebControls.LinkButton lnkImportUsers;

        /// <summary>
        /// Link to add a new user
        /// </summary>
        protected System.Web.UI.WebControls.LinkButton lnkAddNewUser;

        /// <summary>
        /// Unit that is being updated
        /// </summary>
		protected int m_intUnitID;

		/// <summary>
		/// Gets or Sets the OriginalDateUpdated.
		/// </summary>
		/// <remarks> The OriginalDateUpdated is stored in the ViewState.</remarks>
		private string OriginalDateUpdated
		{
			get
			{
				return (string)ViewState["OriginalDateUpdated"];
			}
			set
			{
				ViewState["OriginalDateUpdated"] = value;
			}
		}

        /// <summary>
        /// Page load event handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			this.m_intUnitID = int.Parse(Request.QueryString["UnitID"]);
			WebSecurity.CheckUnitAdministrator(this.m_intUnitID);

			if (!Page.IsPostBack)
			{
				//1. Get Unit's Details	
				this.GetDetails();
				//2. Get user List
				this.StartPagination();
                //3. Hide links that require an active unit
                if (this.cboStatus.SelectedIndex == 1)
                {
                    this.lnkImportUsers.Visible = false;
                    this.lnkAddNewUser.Visible = false;
                }
			}
			cboStatus.Items[0].Text = ResourceManager.GetString("cmnActive" );
			cboStatus.Items[1].Text = ResourceManager.GetString("cmnInactive");
		}
		/// <summary>
		/// Get Unit's Details	
		/// </summary>
		private void GetDetails()
		{
			BusinessServices.Unit objUnit;
			DataTable dtbUnit;
			int intOrganisationID;

			//1. Get Unit details	
			objUnit = new BusinessServices.Unit();
			dtbUnit = objUnit.GetUnit(this.m_intUnitID);
			this.txtName.Text = dtbUnit.Rows[0]["Name"].ToString();
			this.txtUnitID.Text = this.m_intUnitID.ToString();
			if (dtbUnit.Rows[0]["Active"].ToString()=="True")
			{
				this.cboStatus.SelectedIndex=0;
			}
			else
			{
				this.cboStatus.SelectedIndex=1;
			}

			this.lblPathway.Text = dtbUnit.Rows[0]["Organisation"].ToString() + " > " + dtbUnit.Rows[0]["Pathway"].ToString();
			

			DateTime dteOriginalDateUpdated = (DateTime)dtbUnit.Rows[0]["DateUpdated"];
			this.OriginalDateUpdated = DatabaseTool.ToLongDateTimeString(dteOriginalDateUpdated);
			
			intOrganisationID =(int) dtbUnit.Rows[0]["OrganisationID"];

			//2. Get Sub-Units tree
			DataSet dstUnits = objUnit.GetUnitsByOrganisation(intOrganisationID,"","","",this.m_intUnitID);

			string strUnits = UnitTreeConvert.ConvertXml(dstUnits);
			if (strUnits=="")
			{
				this.trvSubUnits.Visible = false;
				this.lblNoSubUnits.Visible = true;
			}
			else
			{
				this.trvSubUnits.Visible = true;
				this.lblNoSubUnits.Visible = false;
				this.trvSubUnits.LoadXml(strUnits);
			}
		}

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

        }
		#endregion

		protected void btnSave_Click(object sender, System.EventArgs e)
		{
			string strName;
			bool blnActive;
			BusinessServices.Unit objUnit;
			
			//1. Get Unit Details
			strName = this.txtName.Text;
			blnActive = (this.cboStatus.SelectedIndex==0);

			DateTime dteOriginalDateUpdated = DateTime.Parse(this.OriginalDateUpdated);

			//2. Save Details
			objUnit = new BusinessServices.Unit();	

			try
			{
                objUnit.Update(this.m_intUnitID, strName, blnActive, UserContext.UserID, dteOriginalDateUpdated, UserContext.UserData.OrgID);

				//3. Reload the unit's details
				//This will reset the updated date time for integrity checking
				this.GetDetails();
				this.lblMessage.Text = ResourceManager.GetString("btnSave_Click");//"The Unit's Details have been updated successfully";
                this.lblMessage.CssClass = "SuccessMessage";
			}
			catch(IntegrityViolationException ex)
			{
				this.lblMessage.Text =  ex.Message.Replace("[Url]","UnitDetails.aspx?UnitID=" + this.m_intUnitID.ToString());
                this.lblMessage.CssClass = "WarningMessage";
			}
			catch(BusinessServiceException ex)
			{
				this.lblMessage.Text =  ex.Message;
                this.lblMessage.CssClass = "WarningMessage";
			}
		}

        protected void lnkImportUsers_Click(object sender, System.EventArgs e)
        {
            // Redirect to the Import Users page
            Response.Redirect("ImportUsers.aspx?UnitID=" + m_intUnitID);
        }

        protected void lnkAddNewUser_Click(object sender, System.EventArgs e)
        {
            // Redirect to Add User page
            Response.Redirect("/Administration/Users/UserDetails.aspx?UserID=0&UnitID=" + m_intUnitID);
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
			BusinessServices.Unit objUnit;
			DataTable dtbUsers;
			
			objUnit= new  BusinessServices.Unit();

			dtbUsers = objUnit.GetUsers(this.m_intUnitID);
			
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
