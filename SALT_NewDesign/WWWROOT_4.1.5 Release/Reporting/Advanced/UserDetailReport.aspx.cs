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
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.BusinessServices;
using Localization;
namespace Bdw.Application.Salt.Web.Reporting
{
	/// <summary>
	/// This is the centeral page for reporting
	/// Normal uses are redirected from this page to their personal report
	/// The only other function of this page is to provide a welcom message for reporting
	/// </summary>
	public partial class UserDetail : System.Web.UI.Page
	{
		#region protected variables
        #endregion

        #region private methods
        /// <summary>
        /// Page load
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen K-Clark, 10/02/04
        /// Changes:
        /// </remarks>
		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			if(!Page.IsPostBack)
			{
				panelReport.Visible = false;
				panelReportParams.Visible = true;
				LoadUnitTree();
			}
		} 


		private void LoadUnitTree()
		{
			BusinessServices.Unit objUnit= new  BusinessServices.Unit(); // Unit Object
			DataSet dstUnits = objUnit.GetUnitsTreeByUserID(UserContext.UserData.OrgID,UserContext.UserID,'A'); // Data set to contain unit details
			if (dstUnits.Tables[0].Rows.Count==0)
			{
				this.panelReportParams.Visible=false;
				this.lblError.Text=ResourceManager.GetString("lblError.NoUnit");//"No units exist within this organisation.";
				this.lblError.Visible=true;

				return;
			}
			string strUnits = UnitTreeConvert.ConvertXml(dstUnits); // comma seperated list of units
			this.trvUnitPath.LoadXml(strUnits);
		}


		protected void btnShowUserDetails_Click(object sender, System.EventArgs e)
		{
			
			panelReport.Visible = true;
			panelReportParams.Visible = false;

			Hashtable parameters = this.rvReport.Parameters;
			parameters["organisationID"] = UserContext.UserData.OrgID;
            parameters["adminUserID"] = UserContext.UserID;
			parameters["effectiveDate"] = DateTime.Now.Date;

			//1.Gather criteria
			// Get the selected units
			// string  strParentUnits  = String.Join(",",this.trvUnitsSelector.GetSelectedValues());
			string[] selectUnits;
			selectUnits = trvUnitPath.GetSelectedValues();
			//Double check
			BusinessServices.Unit objUnit = new  BusinessServices.Unit();
			selectUnits = objUnit.ReturnAdministrableUnitsByUserID( UserContext.UserID, UserContext.UserData.OrgID, selectUnits);
			string  strParentUnits  = String.Join(",",selectUnits);
			parameters["unitIDs"] = strParentUnits;

			if( chkIncludeInactiveUsers.Checked )
				parameters["IncludeInactive"] = 1;
			else
				parameters["IncludeInactive"] = 0;

			parameters["langCode"] = Request.Cookies["currentCulture"].Value;
			parameters["langInterfaceName"] = "Report.UserDetail";
		}
        #endregion


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
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
			this.rvReport.PageIndexChanged += new EventHandler(this.btnShowUserDetails_Click);

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
