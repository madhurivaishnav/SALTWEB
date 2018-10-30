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

namespace Bdw.Application.Salt.Web.General.Errors
{
	/// <summary>
	/// Summary description for ValidationException.
	/// </summary>
	public partial class SqlConnectionException : System.Web.UI.Page
	{
		/// <summary>
		/// Page title
		/// </summary>
		protected System.Web.UI.WebControls.Label lblPageTitle;

		/// <summary>
		/// Hyperlink to support email address
		/// </summary>
		protected System.Web.UI.WebControls.HyperLink lnkSupport;
    
		/// <summary>
		/// Page Load event.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
//			string supportEmail = Utilities.ApplicationSettings.SupportEmail;
//			this.lnkSupport.NavigateUrl = "mailto:" + supportEmail;
//			this.lnkSupport.Text = supportEmail;
		}

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

