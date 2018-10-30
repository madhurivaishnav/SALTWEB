using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

using Bdw.Application.Salt.Web.Utilities;
using Localization;

namespace Bdw.Application.Salt.Web.Administration.Organisation
{
    public partial class OrganisationMail : System.Web.UI.Page
    {
        protected Bdw.Application.Salt.BusinessServices.Organisation objOrganisation;

        protected int rowCourseList;

        override protected void OnInit(EventArgs e)
        {
            //
            // CODEGEN: This call is required by the ASP.NET Web Form Designer.
            //
            InitializeComponent();
        }


        protected void Page_Load(object sender, EventArgs e)
        {
            Session["RemEscID"] = -1;
            loadData();
        }


        private void InitializeComponent()
        {
            this.rptReminderEsc.ItemCommand += new System.Web.UI.WebControls.RepeaterCommandEventHandler(this.dgrReminders_ItemCommand);
            objOrganisation = new BusinessServices.Organisation();            
        }

        private void loadData()
        {
            string strLangCode = Request.Cookies["currentCulture"].Value;
            DataTable dt = objOrganisation.getCoursesConfiguredForMail(UserContext.UserData.OrgID, strLangCode);
            rptReminderEsc.DataSource = dt;
            rptReminderEsc.DataBind();

            BusinessServices.Organisation objOrg = new BusinessServices.Organisation();
            if (objOrg.orgMailFlagConfig(UserContext.UserData.OrgID, 0, UserContext.UserID))
            {
                btnMailFlag.Text = ResourceManager.GetString("btnStopEmail_Start");
            }
            else
            {
                btnMailFlag.Text = ResourceManager.GetString("btnStopEmail_Stop");
            }

        }


        protected void btnMailFlag_Click(object sender, EventArgs e)
        {
            BusinessServices.Organisation objOrg = new BusinessServices.Organisation();
            if (objOrg.orgMailFlagConfig(UserContext.UserData.OrgID, 1, UserContext.UserID))
            {
                btnMailFlag.Text = ResourceManager.GetString("btnStopEmail_Start");
            }
            else
            {
                btnMailFlag.Text = ResourceManager.GetString("btnStopEmail_Stop");
            }
        }


        private  void dgrReminders_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            int intRemEscID = Int32.Parse(e.CommandArgument.ToString());

            if (e.CommandName.Equals("toggle"))
            {
                objOrganisation.updateReminderEscalation(intRemEscID, 0);
            }
            else if (e.CommandName.Equals("delete"))
            {
                objOrganisation.updateReminderEscalation(intRemEscID, 1);
            }
            else if (e.CommandName.Equals("edit"))
            {
                Session["RemEscID"] = intRemEscID;
                Response.Redirect("OrgMailSetup.aspx");
            }

            loadData();
        }
       
        protected void btnAddNew_Click(object sender, EventArgs e)
        {
            Response.Redirect("OrgMailSetup.aspx");
        }
    }
}
