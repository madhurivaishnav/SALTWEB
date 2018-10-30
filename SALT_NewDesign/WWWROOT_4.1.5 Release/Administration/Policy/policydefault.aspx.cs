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

namespace Bdw.Application.Salt.Web.Administration.Policy
{
	/// <summary>
	/// Summary description for policydefault.
	/// </summary>
	public partial class policydefault : System.Web.UI.Page
	{
		protected Localization.LocalizedLabel lblPolicyIdHeading;
		protected System.Web.UI.WebControls.LinkButton hypModify;
		protected Localization.LocalizedLiteral lnkReturnLink;
	
		protected void Page_Load(object sender, System.EventArgs e)
		{
			BusinessServices.Organisation objOrganisation = new BusinessServices.Organisation();
			if (objOrganisation.GetOrganisationPolicyAccess(UserContext.UserData.OrgID))
			{
				Response.AddHeader("Refresh", Convert.ToString((Session.Timeout*60)-10));

				pagTitle.InnerText = ResourceManager.GetString("pagTitle");

				int OrganisationID = UserContext.UserData.OrgID;
				BusinessServices.Organisation org = new BusinessServices.Organisation();
				DataTable dtPolicies = org.GetOrganisationPolicies(OrganisationID);
				rptPolicy.DataSource = dtPolicies;
				rptPolicy.DataBind();

				panPolicy.Visible = (dtPolicies.Rows.Count > 0);

				if (dtPolicies.Rows.Count == 0)
				{
					lblMessage.Text = ResourceManager.GetString("NoPolicies");
					lblMessage.CssClass = "WarningMessage";
				}
			}
			else
			{
				panPolicy.Visible =false;
				this.btnAddPolicy.Visible = false;
				lblMessage.Text = ResourceManager.GetString("NoAccess");
				lblMessage.CssClass = "WarningMessage";
			}
		}

		#region Web Form Designer generated code
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
			this.rptPolicy.ItemDataBound += new RepeaterItemEventHandler(rptPolicy_ItemDataBound);
			this.rptPolicy.ItemCommand += new RepeaterCommandEventHandler(rptPolicy_ItemCommand);
			this.rptPolicy.ItemCreated += new RepeaterItemEventHandler(rptPolicy_ItemCreated);

		}

		protected void rptPolicy_ItemDataBound(object sender, RepeaterItemEventArgs e)
		{
			if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
			{
				DataRowView drv = (DataRowView)e.Item.DataItem;
				string strPolicyFileName = drv["PolicyFileName"].ToString();
				string strPolicyPath = @"\General\Policy\" + UserContext.UserData.OrgID.ToString();
				string strPolicyFilePath = strPolicyPath + @"\" + strPolicyFileName;
				long lngPolicyFileSize = Int32.Parse(drv["PolicyFileSize"].ToString());
				string strPolicyFileSize;
				if (lngPolicyFileSize < 1024000)
				{
					lngPolicyFileSize = (lngPolicyFileSize/1024); // Size in KiloBytes
					strPolicyFileSize = lngPolicyFileSize.ToString("0") + " KB";
				}
				else
				{
					lngPolicyFileSize = (lngPolicyFileSize/(1024 * 1024)); // Size in MegaBytes
					strPolicyFileSize = lngPolicyFileSize.ToString("0.0") + " MB";
				}

				HyperLink hlPolicy = (HyperLink)e.Item.FindControl("hypPolicyFile");
				hlPolicy.Target = "_blank";
				hlPolicy.NavigateUrl = strPolicyFilePath;
				hlPolicy.Text = strPolicyFileName + " (" + strPolicyFileSize  +")";

			}
		}
		#endregion

		protected void btnAddPolicy_Click(object sender, System.EventArgs e)
		{
			Session["PolicyID"] = @"-1";
			Response.Redirect(@"\Administration\Policy\policydetails.aspx");
		}

		private void rptPolicy_ItemCommand(object source, RepeaterCommandEventArgs e)
		{
			Label PolicyID = (Label)e.Item.FindControl("lblPolicyID");
			string PolicyIDValue = PolicyID.Text;
			Session["PolicyID"] = PolicyIDValue;
			Response.Redirect(@"\Administration\Policy\policydetails.aspx");
		}

		private void rptPolicy_ItemCreated(object sender, RepeaterItemEventArgs e)
		{
			if(e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
			{
				HtmlTableCell tcPolicyID = (HtmlTableCell)e.Item.FindControl("tdPolicyID");
				tcPolicyID.Visible = false;
				
				LinkButton lbModify = (LinkButton)e.Item.FindControl("lnkModify");
				lbModify.Text = ResourceManager.GetString("hypModify");
			}
		}
	}
}
