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

using Localization;

using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.Utilities;
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.BusinessServices;

namespace Bdw.Application.Salt.Web.Administration.Application
{
	/// <summary>
	/// Summary description for OrganisationApplicationAccess.
	/// </summary>
	public partial class OrganisationApplicationAccess : System.Web.UI.Page
	{
        protected int rowOrganisationList;
	
		protected void Page_Load(object sender, System.EventArgs e)
		{
			if (!Page.IsPostBack)
			{
				this.lblUpdMessage.Text = String.Empty;
				this.BindGrid();
			}
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
		}

		/// <summary>
		/// Get Organisation Feature Access list
		/// </summary>
		private void BindGrid()
		{
			BusinessServices.Organisation objOrganisation = new BusinessServices.Organisation();
            DataTable dtbOrganisations = objOrganisation.GetAllOrganisationFeatureAccess();

            this.rptOrganisationList.DataSource = dtbOrganisations;
            this.rptOrganisationList.DataBind();
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

		}
		#endregion


        protected bool GetAccessStatus(object obj)
        {
            int granted = 0;

            bool result = Int32.TryParse(obj.ToString(), out granted);
            if (result)
            {
                if (granted == 1)
                    return true;
            }

            return false;
        }

		protected void butSaveAll_Click(object sender, System.EventArgs e)
		{

            foreach (RepeaterItem item in this.rptOrganisationList.Items)
			{
                // get the CPD checkbox
                CheckBox chkCPDProfile = item.FindControl("chkCPDProfile") as CheckBox;
                int accessCPDProfile = chkCPDProfile.Checked == true ? 1 : 0;

                // get the Policy checkbox
                CheckBox chkPolicy = item.FindControl("chkPolicy") as CheckBox;
                int accessPolicy = chkPolicy.Checked == true ? 1 : 0;

				//Madhuri CPD Event Start
				CheckBox chkCPDEvent = item.FindControl("chkCPDEvent") as CheckBox;
                int accessCPDEvent = chkCPDEvent.Checked == true ? 1 : 0;
				//Madhuri CPD Event End
                // get the eBook checkbox
                CheckBox chkEbook = item.FindControl("chkEbook") as CheckBox;
                int accessEbook = chkEbook.Checked == true ? 1 : 0;

                // get the organisaitonid
                HiddenField fldOrganisationID = item.FindControl("organisationID") as HiddenField;
                int organisationID = 0;
                bool result = Int32.TryParse(fldOrganisationID.Value, out organisationID);
                if (!result)
                    organisationID = 0;

				BusinessServices.Organisation objOrganisation = new BusinessServices.Organisation();
                objOrganisation.SaveOrganisationFeatureAccess(organisationID, "cpd profile", accessCPDProfile);
                objOrganisation.SaveOrganisationFeatureAccess(organisationID, "policy", accessPolicy);
                objOrganisation.SaveOrganisationFeatureAccess(organisationID, "ebook", accessEbook);
				//Madhuri CPD Event Start
				objOrganisation.SaveOrganisationFeatureAccess(organisationID, "cpd event", accessCPDEvent);
				//Madhuri CPD Event End
			}
			this.BindGrid();

			this.lblUpdMessage.Visible = true;
			this.lblUpdMessage.Text = ResourceManager.GetString("lblMessage.SaveAccess");
			this.lblUpdMessage.CssClass = "SuccessMessage";
		}
		
	}
}
