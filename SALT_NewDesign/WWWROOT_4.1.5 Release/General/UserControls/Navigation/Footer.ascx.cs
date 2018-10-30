namespace Bdw.Application.Salt.Web.General.UserControls.Navigation
{
	using System;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;
	using System.Collections;

	using Bdw.Application.Salt.App_Code.API;
	using Bdw.Application.Salt.Web.Utilities;
	using Bdw.Application.Salt.Data;
	using Bdw.Application.Salt.BusinessServices;
	

	/// <summary>
	///		Summary description for Footer.
	/// </summary>
	public partial class Footer : System.Web.UI.UserControl
	{ 
        /// <summary>
        /// Label for Company Link
        /// </summary>
        protected System.Web.UI.WebControls.HyperLink lnkCompany;
        /// <summary>
        /// Label for copyright year
        /// </summary>
        protected System.Web.UI.WebControls.Label lblCopyRightYear;


		protected void Page_Load(object sender, System.EventArgs e)
		{
			// Put user code to initialize the page here
            this.lblCopyRightYear.Text = Utilities.ApplicationSettings.CopyrightYear;
            this.lnkCompany.Text = Utilities.ApplicationSettings.BrandingCompanyName;
            this.lnkCompany.NavigateUrl = Utilities.ApplicationSettings.BrandingCompanyURL;


			if (!IsPostBack && UserContext.UserData.UserType == UserType.SaltAdmin)
			{
				panLanguageAdmin.Visible = true;
				if (Request.Cookies["LanguagePreviewMode"] != null)
					ddlLanguagePreviewMode.SelectedValue = Convert.ToInt32(Request.Cookies["LanguagePreviewMode"].Value).ToString();
		
				ddlLanguageList.DataSource = LangAPI.LanguageAdminList();
				ddlLanguageList.DataBind();
			
				if (Request.Cookies["currentCulture"] != null && ddlLanguageList.Items.FindByValue(Request.Cookies["currentCulture"].Value) != null)
					ddlLanguageList.SelectedValue = Request.Cookies["currentCulture"].Value;
			}

		}

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
		///		Required method for Designer support - do not modify
		///		the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			ddlLanguagePreviewMode.SelectedIndexChanged+=new EventHandler(ddlLanguagePreviewMode_SelectedIndexChanged);
			ddlLanguageList.SelectedIndexChanged+=new EventHandler(ddlLanguageList_SelectedIndexChanged);
        }
		#endregion

		private void ddlLanguagePreviewMode_SelectedIndexChanged(object sender, EventArgs e)
		{
			Response.Cookies["LanguagePreviewMode"].Value = ddlLanguagePreviewMode.SelectedValue;
			Response.Cookies["LanguagePreviewMode"].Expires = DateTime.Now.AddYears(1);
			
			foreach(DictionaryEntry item in Cache)
			{
				Cache.Remove(item.Key.ToString());
			}

			Response.Redirect(Request.Url.ToString());
		}

		private void ddlLanguageList_SelectedIndexChanged(object sender, EventArgs e)
		{
			string cultureName = ddlLanguageList.SelectedValue;
			System.Globalization.CultureInfo c = new System.Globalization.CultureInfo("en-AU");
			System.Globalization.CultureInfo c2 = new System.Globalization.CultureInfo(cultureName);
			System.Threading.Thread.CurrentThread.CurrentCulture = c;
			System.Threading.Thread.CurrentThread.CurrentUICulture = c2;

			Response.Cookies["currentCulture"].Value = cultureName;
			Response.Cookies["currentCulture"].Expires = DateTime.Now.AddYears(1);

			Response.Redirect(Request.Url.ToString());
		}
	}
}