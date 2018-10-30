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

namespace Bdw.Application.Salt.Web.Administration.Organisation
{
	/// <summary>
	/// This class controls the page and business logic for the ImportUsers.aspx page.
	/// This class/page is essentially a wrapper class for the ImportUsers.ascx user control.
	/// This class sets the control hierachy to Organisation.
	/// </summary>
	/// <remarks>
	/// Assumptions: This page should only be available to Salt and Organisation administrators.
	/// Notes: The control hierachy is used by the ImportUsers.ascx user control so that the system knows where to
	/// import the user information to.  That is that if the control hierachy is set to organisation then the users will be
	/// imported to that organisation only.  If the control hierachy is set to Unit then the users will be imported into that
	/// organisation/unit pair.
	/// Author: Peter Vranich
	/// Date: 10/02/0/2004
	/// Changes:
	/// </remarks>
	public partial class ImportUsers : System.Web.UI.Page
	{
        #region Protected Variables

        /// <summary>
        /// Label for page title
        /// </summary>
        protected System.Web.UI.WebControls.Label lblPageTitle;
        #endregion

        #region Private Constants
		/// <summary>
		/// Constant to hold the page hierachy.
		/// </summary>
		private const string cm_strHierachy = "Organisation";

		#endregion
		
		#region Private Event Handlers
		/// <summary>
		/// Event handler for the page load event.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			this.SetControlHierachy();
		} // Page_Load
		#endregion
		
		#region Private Methods
		/// <summary>
		/// Sets the Hierachy of the page.
		/// </summary>
		/// <remarks>
		/// This is so that the user controls knows where to import the users to.
		/// </remarks>
		private void SetControlHierachy()
		{
			HttpContext.Current.Items["Hierachy"] = cm_strHierachy;
		} // SetControlHierachy
		#endregion

		#region Web Form Designer generated code

        /// <summary>
        /// This call is required by the ASP.NET Web Form Designer.
        /// </summary>
        /// <param name="e"></param>
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
		} // OnInit
		
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