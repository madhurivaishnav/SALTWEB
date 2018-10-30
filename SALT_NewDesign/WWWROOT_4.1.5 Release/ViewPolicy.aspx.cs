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
using System.IO;
using Microsoft.ApplicationBlocks.Data;
using System.Configuration;
using Localization;

namespace Bdw.Application.Salt.Web
{
	/// <summary>
	/// Summary description for ViewPolicy.
	/// </summary>
	public partial class ViewPolicy : System.Web.UI.Page
	{
	
		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			GetTitle();
			if(!Page.IsPostBack)
			{
				LoadPolicy();
			}
			else
			{
				this.HandlePageEvents(Request.Form["__EVENTTARGET"],Request.Form["__EVENTARGUMENT"]);
			}
			
		}

		protected void btnFinish_Click(object sender, System.EventArgs e)
		{
			int PolicyID = int.Parse(Request.QueryString["PolicyID"].ToString());
			//int ProfileID = int.Parse(Request.QueryString["ProfileID"].ToString());
			int UserID = UserContext.UserID;
			
			BusinessServices.User objUser = new BusinessServices.User();
			DataTable dtUserProfiles = objUser.GetProfilePeriodList(UserID);

			BusinessServices.Policy objPolicy = new BusinessServices.Policy();
			// Only want to do anything if user has read and understood the policy
			if(this.chkAgree.Checked)
			{
				// Check if policy marked as accepted
				// If not then mark user as accepted the policy
				if(!objPolicy.CheckAccepted(PolicyID, UserID))
				{
					objPolicy.Accept(PolicyID, UserID);
				}

				// Check if points have already been assigned for this policy and user
				// If not then assign points for the policy to the user
				foreach (DataRow dr in dtUserProfiles.Rows)
				{
					int ProfileID = Int32.Parse(dr["ProfileID"].ToString());
					if(!objPolicy.CheckPointsAssigned(PolicyID, UserID, ProfileID)) 
					{
						if(objPolicy.CheckProfileExists(PolicyID, UserID, ProfileID))
						{
							objPolicy.AssignPoints(PolicyID, UserID, ProfileID);
						}
					}
				}
			}
			Response.Redirect("/MyTraining.aspx");
			//Response.Write("<script language='javascript'> {opener.location.reload(); self.close(); }</script>");

		}

		private void HandlePageEvents(string eventName, string eventArgument)
		{
			switch (eventName)
			{
				//The following events are Page change events
				case "Exit_Click":
				{
					Response.Redirect("/MyTraining.aspx?CourseID=-1&ProfileID=-1");
					break;
				}				
			}
		}

		private void GetTitle()
		{
			int PolicyID = int.Parse(Request.QueryString["PolicyID"].ToString());
			BusinessServices.Policy objPolicy = new BusinessServices.Policy();
            DataTable dtPolicy = objPolicy.GetPolicy(PolicyID, UserContext.UserData.OrgID);
			string PolicyName = dtPolicy.Rows[0]["PolicyName"].ToString();
			lblTitle.Text = PolicyName;
		}

		private void LoadPolicy()
		{
            int UserID = UserContext.UserID;
            BusinessServices.User objUser = new BusinessServices.User();
			DataTable dtUserProfiles = objUser.GetProfilePeriodList(UserID);

			int PolicyID = int.Parse(Request.QueryString["PolicyID"].ToString());
			BusinessServices.Policy objPolicy = new BusinessServices.Policy();

            // if the policy as not accepted, enable to checkbox
            if (!objPolicy.CheckAccepted(PolicyID, UserID))
            {
			string ConfirmationMessage = objPolicy.GetConfirmationMessage(PolicyID);
                this.chkAgree.Text = ConfirmationMessage;
            }
            else
            {
                this.chkAgree.Enabled = false;
                this.chkAgree.Checked = true;
                string lastAccepted = objPolicy.GetLastAccepted(UserID, UserContext.UserData.OrgID, PolicyID);
                this.chkAgree.Text = ResourceManager.GetString("lblLastAccepted") + " " + lastAccepted;
            }


            string PolicyName = objPolicy.GetPolicyFileName(PolicyID, UserContext.UserData.OrgID);
			string PolicyDir = @"\General\Policy\" + UserContext.UserData.OrgID.ToString();
			this.pdfFrame.Attributes["src"] = PolicyDir + @"\" + PolicyName;
			this.pdfFrame.Visible = true;
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
	}
}
