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

namespace Bdw.Application.Salt.Web.Administration.CPD
{
	/// <summary>
	/// Summary description for cpddefault.
	/// </summary>
	public partial class cpddefault : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.Repeater rptPolicy;
		protected Localization.LocalizedLinkButton lnkEdit;
		protected Localization.LocalizedLinkButton lnkSave;
		protected Localization.LocalizedLinkButton lnkCancel;

		private int Gprofileid ;
		private int Gprofilerowcount;
	
		protected void Page_Load(object sender, System.EventArgs e)
		{
			//Response.AddHeader("Refresh", Convert.ToString((Session.Timeout*60)-10));
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			if (!Page.IsPostBack)
			{
				BusinessServices.Organisation objOrganisation = new BusinessServices.Organisation();
				if (objOrganisation.GetOrganisationCPDAccess(UserContext.UserData.OrgID))
				{
					CPDBindGrid();
				}
				else// dosnt have access to CPD 
				{					
					panCPD.Visible = false;
					this.btnCreateProfile.Visible = false;
					lblMessage.Text = ResourceManager.GetString("NoAccess");
					lblMessage.CssClass = "WarningMessage";
				}
			}
			
		}

		private void CPDBindGrid()
		{
			DataTable dtProfiles = GetProfiles();
			dgrCPD.DataSource = dtProfiles;
			dgrCPD.DataBind();
			DisplayProfiles(dtProfiles);
		}

		private DataTable GetProfiles()
		{
			int OrganisationID = UserContext.UserData.OrgID;
			BusinessServices.Organisation org = new BusinessServices.Organisation();
			DataTable dtPolicies = org.GetOrganisationProfiles(OrganisationID);
			return dtPolicies;
		}

		private void DisplayProfiles(DataTable dtProfiles)
		{
			lblMessage.Text = String.Empty;
			panCPD.Visible = (dtProfiles.Rows.Count > 0);

			if (dtProfiles.Rows.Count == 0)
			{
				lblMessage.Text = ResourceManager.GetString("NoProfiles");
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
			dgrCPD.Columns[2].HeaderText = ResourceManager.GetString("profile_name");
			dgrCPD.Columns[3].HeaderText = ResourceManager.GetString("current_period");
			dgrCPD.Columns[4].HeaderText = ResourceManager.GetString("future_period");
			dgrCPD.Columns[5].HeaderText = ResourceManager.GetString("status");
			dgrCPD.Columns[6].HeaderText = ResourceManager.GetString("action");
			EditCommandColumn ecc = (EditCommandColumn)dgrCPD.Columns[6];
			ecc.EditText = ResourceManager.GetString("edit");
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
			this.dgrCPD.ItemCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.dgrCPD_ItemCommand);
			this.dgrCPD.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(this.dgrCPD_ItemDataBound);

		}
		#endregion

		protected void btnCreateProfile_Click(object sender, System.EventArgs e)
		{
			// Get existing data source
//			DataTable dtProfiles = GetProfiles();
//			
//			// add new row to data source
//			DataRow drProfiles = dtProfiles.NewRow();
//			dtProfiles.Rows.Add(drProfiles);//DataSet.newRow
//			// databind to repeater control
//			dgrCPD.DataSource = dtProfiles;
//			dgrCPD.EditItemIndex = (dtProfiles.Rows.Count - 1); //TODO - need to change this to get index of newly added row
//			dgrCPD.DataBind();
//			
//			DisplayProfiles(dtProfiles);
			//Above redundant - new functional spec specifies that on create new profile should direct to cpddetail.aspx page
			Session["ProfileID"] = @"-1";
			Session["ProfilePeriodID"] = @"-1";
			Response.Redirect(@"\Administration\CPD\cpddetail.aspx");
		}

		private void ClearMessage()
		{
			this.lblMessage.Text = String.Empty;
		}
		private void dgrCPD_ItemCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
		{
			
			string ProfilePeriodIDValue = @"-1";
			string Action = e.CommandName;

			switch (Action)
			{	
				case "Edit":					
					Label ProfileID = (Label)e.Item.FindControl("lblProfileID");
					Label ProfilePeriodID = (Label)e.Item.FindControl("lblProfilePeriodID");
					
					string ProfileIDValue = ProfileID.Text;
					if (ProfilePeriodID.Text != "")
					{
						ProfilePeriodIDValue = ProfilePeriodID.Text;
					}
					Session["ProfileID"] = ProfileIDValue;
					Session["ProfilePeriodID"] = ProfilePeriodIDValue;
					Response.Redirect(@"\Administration\CPD\cpddetail.aspx");
					break;
			}
			
		}

//		private void SaveCPD(string ProfileNameValue, int OrganisationID)
//		{
//			// Save the CPD Profile
//			BusinessServices.Profile objProfile = new BusinessServices.Profile();		
//			objProfile.AddProfile(ProfileNameValue, OrganisationID);
//		}

		private bool PolicyNameExists(string ProfileNameValue, int OrganisationID)
		{
			bool NameExists = false;
			BusinessServices.Profile objProfile = new BusinessServices.Profile();
			DataTable dtCheckPolicyName = objProfile.CheckProfileName(ProfileNameValue, OrganisationID);
			if (dtCheckPolicyName.Rows.Count > 0)
			{
				NameExists = true;
			}
			return NameExists;
		}

		private void dgrCPD_ItemDataBound(object sender, System.Web.UI.WebControls.DataGridItemEventArgs e)
		{
			if(e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
			{
				DataRowView drv = (DataRowView)e.Item.DataItem;
				int profileID = (int)drv["ProfileID"];
				
				BusinessServices.Profile objProfile = new BusinessServices.Profile();
                DataTable dtProfile = objProfile.GetProfile(profileID, -1, UserContext.UserData.OrgID);

				if(dtProfile.Rows.Count > 0)
				{
					if (Gprofileid !=profileID)
					{
						Gprofileid = profileID;
						Gprofilerowcount =0;
					}
					else
					{
						Gprofilerowcount ++;
					}
					if(!dtProfile.Rows[Gprofilerowcount]["DateStart"].Equals(System.DBNull.Value))
					{
						DateTime dtStart = (DateTime)dtProfile.Rows[Gprofilerowcount]["DateStart"];
						if (dtStart < DateTime.Now) //Current Period
						{
							Label lblCurrentDate = (Label)e.Item.FindControl("lblCurrentDate");
								lblCurrentDate.Text = 
									string.Format("{0:dd/MM/yyyy}", (DateTime)dtProfile.Rows[Gprofilerowcount]["DateStart"]) 
									+ " - " + 
									string.Format("{0:dd/MM/yyyy}", (DateTime)dtProfile.Rows[Gprofilerowcount]["DateEnd"]);

							Label lblFutureDate = (Label)e.Item.FindControl("lblFutureDate");
							if (!dtProfile.Rows[Gprofilerowcount]["FutureDateStart"].Equals(System.DBNull.Value))
							{
								lblFutureDate.Text = 
									string.Format("{0:dd/MM/yyyy}", (DateTime)dtProfile.Rows[Gprofilerowcount]["FutureDateStart"]) 
									+ " - " + 
									string.Format("{0:dd/MM/yyyy}", (DateTime)dtProfile.Rows[Gprofilerowcount]["FutureDateEnd"]);
							}
						}
						else //Future Period
						{
							Label lblFutureDate = (Label)e.Item.FindControl("lblFutureDate");
								lblFutureDate.Text = 
									string.Format("{0:dd/MM/yyyy}", (DateTime)dtProfile.Rows[Gprofilerowcount]["DateStart"]) 
									+ " - " + 
									string.Format("{0:dd/MM/yyyy}", (DateTime)dtProfile.Rows[Gprofilerowcount]["DateEnd"]);
						}
					}
				}
			}
		}

		

//		private void dgrCPD_UpdateCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
//		{
//			
//		}
//
//		private void dgrCPD_EditCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
//		{
//			
//		}
//
//		private void dgrCPD_CancelCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
//		{
//			
//		}

//		private void dgrCPD_SelectedIndexChanged(object sender, System.EventArgs e)
//		{
//			
//		}
//
//		private void dgrCPD_ItemDataBound(object sender, System.Web.UI.WebControls.DataGridItemEventArgs e)
//		{
//			
//		}

	}
}
