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

namespace Bdw.Application.Salt.Web.Administration.Application
{
	/// <summary>
	/// Summary description for OrgModAccess.
	/// </summary>
	public partial class OrgModAccess : System.Web.UI.Page
	{

		protected void Page_Load(object sender, System.EventArgs e)
		{
			// Put user code to initialize the page here
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");

			if (!IsPostBack)
			{
				rptAccess.DataSource = BusinessServices.Organisation.OrganisationModuleAccess();
				rptAccess.DataBind();
			}
		}


		private void rptAccess_ItemDataBound(object sender, RepeaterItemEventArgs e)
		{
			if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
			{
				DataRowView drv = (DataRowView)e.Item.DataItem;

				CheckBox chkPolicyBuilder = (CheckBox)e.Item.FindControl("chkPolicyBuilder");
				chkPolicyBuilder.Attributes.Add("OrganisationID", drv["OrganisationID"].ToString());
			}
		}
		
		private void butSaveAll_Click(object sender, EventArgs e)
		{

			foreach(RepeaterItem i in rptAccess.Items)
			{
				CheckBox chkPolicyBuilder = (CheckBox)i.FindControl("chkPolicyBuilder");

				if (chkPolicyBuilder != null)
				{
					int organisationID = Int32.Parse(chkPolicyBuilder.Attributes["OrganisationID"]);
					BusinessServices.Organisation.OrganisationModuleAccessSave(organisationID, "PolicyBuilder", chkPolicyBuilder.Checked);
				}
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
			this.butSaveAll.Click+=new EventHandler(butSaveAll_Click);
			this.rptAccess.ItemDataBound+=new RepeaterItemEventHandler(rptAccess_ItemDataBound);
		}
		#endregion

	}
}
