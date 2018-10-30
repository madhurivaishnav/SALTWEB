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

namespace Bdw.Application.Salt.Web
{
	/// <summary>
	/// Summary description for about.
	/// </summary>
	public partial class about : System.Web.UI.Page
	{
        /// <summary>
        /// Application label
        /// </summary>
        protected System.Web.UI.WebControls.Label lblApplicationName;

        /// <summary>
        /// Version Label
        /// </summary>
        protected System.Web.UI.WebControls.Label lblVersion;

        /// <summary>
        /// Licenced To Label
        /// </summary>
        protected System.Web.UI.WebControls.Label lblLicencedTo;

        /// <summary>
        /// Branding Company Name
        /// </summary>
        protected System.Web.UI.WebControls.Label lblBrandingCompanyName;
        
        /// <summary>
        /// Company Website URL
        /// </summary>
        protected System.Web.UI.WebControls.HyperLink lnkCompanyWebsite;

        /// <summary>
        /// Copyright Year Label
        /// </summary>
        protected System.Web.UI.WebControls.Label lblCopyrightYear;

    
        /// <summary>
        /// Page load event handler
        /// </summary>
        /// <param name="sender">object</param>
        /// <param name="e">System.EventArgs</param>
		protected void Page_Load(object sender, System.EventArgs e)
		{

			pagTitle.InnerText = ResourceManager.GetString("pagTitle");


			// Put user code to initialize the page here
            lblVersion.Text = Utilities.ApplicationSettings.Version.Replace(@"salt","").Replace(@"Salt","");
            lblCopyrightYear.Text = Utilities.ApplicationSettings.CopyrightYear;
            lblApplicationName.Text = Utilities.ApplicationSettings.AppName;
            lblLicencedTo.Text = Utilities.ApplicationSettings.LisencedTo;
            lblBrandingCompanyName.Text = Utilities.ApplicationSettings.BrandingCompanyName;
            lnkCompanyWebsite.Text = Utilities.ApplicationSettings.BrandingCompanyURL.Replace(@"http://","").Replace(@"https://","");
            lnkCompanyWebsite.NavigateUrl = Utilities.ApplicationSettings.BrandingCompanyURL;


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
