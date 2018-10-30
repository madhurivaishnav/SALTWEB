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
namespace Bdw.Application.Salt.Web.ContentAdministration.Modules
{
	/// <summary>
	/// Summary description for ResetQuiz.
	/// </summary>
	public partial class ResetQuiz : System.Web.UI.Page
	{


		private int m_ModuleID = 0;
		private int ModuleID
		{
			get
			{
				if (Request.QueryString["ModuleID"] != null)
					m_ModuleID = int.Parse(Request.QueryString["ModuleID"]);
				else if (ViewState["ModuleID"] != null)
					m_ModuleID = int.Parse(ViewState["ModuleID"].ToString());
	
				return m_ModuleID;
			}
			set
			{
				m_ModuleID = value;
				ViewState.Add("ModuleID", m_ModuleID);
			}
		}



		protected void Page_Load(object sender, System.EventArgs e)
		{
			lnkReturnToModuleDetails.NavigateUrl = "ModuleDetails.aspx?ModuleID=" + this.ModuleID.ToString();

			btnResetStatus.Attributes.Add("onclick",@"javascript:return confirm('" + ResourceManager.GetString("ConfirmMessage").Replace("'", @"\'") + "');");

			if (!IsPostBack)
			{
				pagTitle.InnerText = ResourceManager.GetString("pagTitle");

				cboResetUserRange.Items[0].Text = ResourceManager.GetString("cboResetUserRange.1");
				cboResetUserRange.Items[1].Text = ResourceManager.GetString("cboResetUserRange.2");
				cboResetUserRange.Items[2].Text = ResourceManager.GetString("cboResetUserRange.3");


				//-- Setup the reset list of organisations
				Organisation objOrganisation = new Organisation();
				string strLangCode = Request.Cookies["currentCulture"].Value;
				DataTable dtbOrganisationDetails;
				if (UserContext.UserData.UserType == UserType.SaltAdmin)
					dtbOrganisationDetails = objOrganisation.GetOrganisationList(this.ModuleID);
				else
					dtbOrganisationDetails = objOrganisation.GetOrganisation(strLangCode, UserContext.UserData.OrgID);

				chkOrgList.DataSource = dtbOrganisationDetails;
				chkOrgList.DataTextField = "OrganisationName";
				chkOrgList.DataValueField  = "OrganisationID";
				chkOrgList.DataBind();
			}
		}

	
		private void btnResetStatus_Command(object sender, CommandEventArgs e)
		{
			DataTable dtPreview = new DataTable();
			dtPreview.Columns.Add("Users");
			dtPreview.Columns.Add("Orgs");

			bool previewMode = ((bool)(e.CommandArgument.ToString() == "preview"));
			int userListType = Int32.Parse(cboResetUserRange.SelectedValue);

			foreach(ListItem li in chkOrgList.Items)
			{
				if (li.Selected == true)
				{
					int orgID = Int32.Parse(li.Value);
					int usersAffected = Bdw.Application.Salt.BusinessServices.Module.ResetQuizStatus(userListType, orgID, this.ModuleID, previewMode);
					
					DataRow dr = dtPreview.NewRow();
					dr["Users"] = usersAffected;
					dr["Orgs"] = li.Text;
					dtPreview.Rows.Add(dr);
				}
			}

			//-- Present results
			if (previewMode)
			{
				lblPreview.Visible = true;

				if (dtPreview.Rows.Count == 0)
				{
					lblPreview.Text = ResourceManager.GetString("cmnNoUsersAffected");
					btnResetStatus.Visible = false;
				}
				else
				{
					lblPreview.Text = ResourceManager.GetString("QuizStatusPreviewMode");
					btnResetStatus.Visible = true;
				}

				rptPreview.Visible = true;
				

				rptPreview.DataSource = dtPreview;
				rptPreview.DataBind();
			}
			else
			{
				lblPreview.Visible = false;
				lblMessage.Text = ResourceManager.GetString("lblMessage") + "<br><br>";
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
			this.btnResetStatus.Command +=new CommandEventHandler(btnResetStatus_Command);
			this.btnPreview.Command +=new CommandEventHandler(btnResetStatus_Command);
		}
		#endregion

	}
}
