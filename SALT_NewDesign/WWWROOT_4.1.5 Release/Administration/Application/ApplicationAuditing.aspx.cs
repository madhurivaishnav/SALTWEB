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

using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.Utilities;
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.BusinessServices;
using Localization;

namespace Bdw.Application.Salt.Web.Administration.Application
{
	/// <summary>
	/// Summary description for ApplicationAuditing.
	/// </summary>
	public partial class ApplicationAuditing : System.Web.UI.Page
	{
        /// <summary>
        /// General message label
        /// </summary>
		protected System.Web.UI.WebControls.Label lblMessage;
        

        /// <summary>
        /// Page Title
        /// </summary>
        protected System.Web.UI.WebControls.Label lblPageTitle;

        /// <summary>
        /// Label indicating when Module status update routine was last run
        /// </summary>
        protected System.Web.UI.WebControls.Label lblModuleStatusUpdateLastRun;

        /// <summary>
        /// Button to run the Module Status Update
        /// </summary>
        protected System.Web.UI.WebControls.Button btnRunModuleStatusUpdate;
        
        /// <summary>
        /// Label indicating the SQL server Agent status
        /// </summary>
        protected System.Web.UI.WebControls.Label lblSqlAgentRunningStatus;

	
        /// <summary>
        /// Page Load Event handler.
        /// </summary>
        /// <param name="sender">object</param>
        /// <param name="e">System.EventArgs</param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
			if (!Page.IsPostBack) 
			{

				SetLastRunDate();
                SetSqlAgentRunningStatus();
				
				this.btnRunModuleStatusUpdate.Attributes.Add("onclick", "return confirmUpdateModuleStatus();");

			}
			ResourceManager.RegisterLocaleResource("ConfirmMessage");
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");


		}

		// Set the label showing when the module status update job was last run
		private void SetLastRunDate()
		{
            string strDateTimeUpdateLastRun;

			BusinessServices.Application objApp = new BusinessServices.Application();
            strDateTimeUpdateLastRun = objApp.GetDateModuleStatusUpdateLastRun(UserContext.UserData.OrgID).ToString("F");
            if (strDateTimeUpdateLastRun == DateTime.MinValue.ToString("F"))
            {
                this.lblModuleStatusUpdateLastRun.ForeColor = Color.Red;
                this.lblModuleStatusUpdateLastRun.Text = ResourceManager.GetString("lblModuleStatusUpdateLastRun");//"Never";

            }
            else
            {
				//TODO_DATE
                this.lblModuleStatusUpdateLastRun.Text = objApp.GetDateModuleStatusUpdateLastRun(UserContext.UserData.OrgID).ToString("F");
            }

		}

        // Set the label showing the sql server agent running status
        private void SetSqlAgentRunningStatus()
        {
            string strSqlAgentRunningStatus="";

            BusinessServices.Application objApp = new BusinessServices.Application();
            try
            {
                strSqlAgentRunningStatus = objApp.GetSqlAgentRunningStatus().ToString();
            }
            catch(DatabaseException)
            {
                strSqlAgentRunningStatus = ResourceManager.GetString("strSqlAgentRunningStatus");//"This feature is not currently enabled. <br />To enable this feature EXECUTE permission must be enabled on object 'xp_servicecontrol'<br/>in database 'master' for the website database user<br />If you require this feature please contact your database administrator";
            }
            this.lblSqlAgentRunningStatus.Text = strSqlAgentRunningStatus;
            

        }
        #region Private Events
        protected void btnRunModuleStatusUpdate_Click(object sender, System.EventArgs e)
        {
            // Run the module status update job
            BusinessServices.Application objApp = new BusinessServices.Application();
            objApp.RunModuleStatusUpdate(UserContext.UserData.OrgID);

			SetLastRunDate();
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

        }
		#endregion
	}
}
