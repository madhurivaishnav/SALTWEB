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
	public partial class ReportingHome : System.Web.UI.Page
	{
        #region protected variables
        /// <summary>
        /// Reporting Welcome
        /// </summary>
        protected System.Web.UI.WebControls.Label lblReportingWelcome;
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
            // redirect "Users" to their personal report
            if(UserContext.UserData.UserType == UserType.User)
            {
                Response.Redirect("Individual/IndividualReport.aspx");
            }
			PaintPage();
		} //Page_Load

        /// <summary>
        /// Set page state
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen K-Clark, 9/02/04
        /// Changes:
        /// </remarks>
        private void PaintPage()
        {
            if(!IsPostBack)
            {   
               // the page is being run for the first time
               // paint a welcome message
               lblReportingWelcome.Text = String.Format(ResourceManager.GetString("lblReportingWelcome"), Utilities.ApplicationSettings.AppName, Utilities.ApplicationSettings.TradeMark);
            }         
        } //PaintPage

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
