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
using System.Xml;

using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.Web.Utilities;
using Localization;

namespace Bdw.Application.Salt.Web.Administration.Unit
{
	/// <summary>
	/// Summary description for UnitSearch.
	/// </summary>
	public partial class UnitSearch : System.Web.UI.Page
    {
        #region Protected controls

        /// <summary>
        /// Table surrounding search criteria
        /// </summary>
		protected System.Web.UI.HtmlControls.HtmlTable tblSearchCriteria;

        /// <summary>
        /// Treeview for unit selection
        /// </summary>
		protected Uws.Framework.WebControl.TreeView trvUnitsSelector;

        /// <summary>
        /// Textbox for unit name
        /// </summary>
		protected System.Web.UI.WebControls.TextBox txtUnitName;

        /// <summary>
        /// Checkbox to include inactive units in search results
        /// </summary>
		protected System.Web.UI.WebControls.CheckBox chkInactiveUnits;

        /// <summary>
        /// Label for displaying error messages.
        /// </summary>
        protected System.Web.UI.WebControls.Label lblMessage;

        /// <summary>
        /// Datagrid holding results
        /// </summary>
		protected System.Web.UI.WebControls.DataGrid grdResults;

        /// <summary>
        /// Placeholder surrounding Criteria
        /// </summary>
		protected System.Web.UI.WebControls.PlaceHolder plhCriteria;

        /// <summary>
        /// Placeholder surrounding Results
        /// </summary>
		protected System.Web.UI.WebControls.PlaceHolder plhResults;

        /// <summary>
        /// Next page button
        /// </summary>
		protected System.Web.UI.WebControls.LinkButton btnNext;
        #endregion
	    
        #region Private Event Handlers
        /// <summary>
        /// Page Load event
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
            txtUnitID.ToolTip = ResourceManager.GetString("tooltipExactID");

            if (!Page.IsPostBack)
			{
				//Show Parent Units tree
				BusinessServices.Unit objUnit= new  BusinessServices.Unit();
				DataSet dstUnits = objUnit.GetUnitsTreeByUserID(UserContext.UserData.OrgID, UserContext.UserID, 'A',false);
                if (dstUnits.Tables[0].Rows.Count==0)
                {
                    this.lblNoSubUnits.Visible=true;
                    this.lblNoSubUnits.CssClass="FeedbackMessage";

                    this.plhCriteria.Visible=false;
					this.plhResults.Visible=false;
                }
                else
				{
                    string strUnits = UnitTreeConvert.ConvertXml(dstUnits);

                    this.trvUnitsSelector.LoadXml(strUnits);
			
                    this.plhCriteria.Visible=true;
					this.plhResults.Visible=false;
                }
                SetPaginationOrder("Name"); 
			}
				
		}

        /// <summary>
        /// Search button event handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnFind_Click(object sender, System.EventArgs e)
        {
            ShowData(0);
        }

        /// <summary>
        /// Reset button event handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnReset_Click(object sender, System.EventArgs e)
        {
            Response.Redirect(Request.RawUrl);
        }

        /// <summary>
        /// Sort order changed
        /// </summary>
        /// <param name="source"></param>
        /// <param name="e"></param>
        private void grdResults_SortCommand(object source, DataGridSortCommandEventArgs e)
        {
            SetPaginationOrder(e.SortExpression);
            ShowData(0);
        }
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
        /// Get Pagination Data
        /// </summary>
        /// <returns></returns>
        private DataView GetData()
        {
            //Customize, and return DataView
            string strParentUnits, strUnitName;
            int unitID;

            bool result = Int32.TryParse(this.txtUnitID.Text, out unitID);
            if (!result)
                unitID = 0;

            strParentUnits = String.Join(",", this.trvUnitsSelector.GetSelectedValues());
            strUnitName = this.txtUnitName.Text.Trim();

            BusinessServices.Unit objUnit= new  BusinessServices.Unit();
            DataTable dtbUnits = objUnit.Search(UserContext.UserData.OrgID, strParentUnits, strUnitName, UserContext.UserID, unitID, this.chkInactiveUnits.Checked);
			
            return dtbUnits.DefaultView;
        }

        /// <summary>
        /// Set order field
        /// </summary>
        /// <param name="orderByField"></param>
        private void SetPaginationOrder(string orderByField)
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
                lblUnitCount.Text = String.Format(ResourceManager.GetString("lblUnitCount"), intRowCount.ToString());//intRowCount.ToString();
                plhResults.Visible=true;
            }
            else
            {
                lblMessage.Text = ResourceManager.GetString("lblMessage.NoUnits");//"No Matching Units Found";
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
			grdResults.Columns[0].HeaderText = ResourceManager.GetString("cmnUnitID");
            grdResults.Columns[1].HeaderText = ResourceManager.GetString("cmnName");
			grdResults.Columns[2].HeaderText = ResourceManager.GetString("grid_Pathway");
        }
		
        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {   
			this.grdResults.PageIndexChanged += new System.Web.UI.WebControls.DataGridPageChangedEventHandler(this.grdResults_PageIndexChanged);
			this.grdResults.SortCommand += new System.Web.UI.WebControls.DataGridSortCommandEventHandler(this.grdResults_SortCommand);

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
