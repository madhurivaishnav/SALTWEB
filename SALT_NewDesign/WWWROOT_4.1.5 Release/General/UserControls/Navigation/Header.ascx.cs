namespace Bdw.Application.Salt.Web.General.UserControls.Navigation
{
	using System;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.Security;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;
	using Bdw.Application.Salt.Web.Utilities;
	using Bdw.Application.Salt.Data;
    using System.Configuration;
	using Localization;

	/// <summary>
	///	This control displays the Organisation logo for the currently logged in User.
	/// It also provides the main navigation for the site.
	/// </summary>
	/// <remarks>
	/// Assumptions: None.
	/// Notes: None.
	/// Author: Peter Vranich
	/// Date: 29/01/0/2004
	/// Changes:
	/// Some HTML was deleted from teh presentation page and references to it have been removed from this page to 
	/// remove the seperate header for the salt administrator 
	/// </remarks>
	public partial class Header : System.Web.UI.UserControl
    {
      
        #region constants
        /// <summary>
        /// path to folder containg Header Images
        /// </summary>
        const string cm_strHeaderImagePath = "/General/Images/Header/";
        #endregion

		#region Protected Variables
		/// <summary>
		/// Link button to exit.  When clicked this will take you back to the login page.
		/// </summary>
		protected System.Web.UI.WebControls.LinkButton lnkExit;
		
		/// <summary>
		/// 
		/// </summary>
		protected System.Web.UI.HtmlControls.HtmlTableRow trDefaultHeader;
		
		/// <summary>
		/// 
		/// </summary>
		protected System.Web.UI.HtmlControls.HtmlTableRow trOrganisationHeader;
		
		/// <summary>
		/// 
		/// </summary>
        protected System.Web.UI.WebControls.Label lblSectionTitle;

        /// <summary>
        /// Label for application trademark
        /// </summary>
        protected System.Web.UI.WebControls.Label lblTradeMark;
		
		/// <summary>
		/// HTML image for the Organisation Logo.
		/// </summary>
		protected System.Web.UI.HtmlControls.HtmlImage imgHeader;

		#endregion
		
		#region Private Methods
		/// <summary>
		/// The Page_Load method calls the GetHeaderImage method.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
        /// 

        public bool isSaltAdmin = false;
		protected void Page_Load(object sender, System.EventArgs e)
		{


            if (UserContext.UserData.UserType == UserType.SaltAdmin)
            {
                isSaltAdmin = true;
            }

            if (!IsPostBack)
            {
                PaintOrgImage();
            }

            //2. Paint the section name, check 
            // & ensure that the trade mark sybbol is not visable unless it neads 2 b
			this.imgSaltLogo.Visible = false;
            lblSectionTitle.CssClass = "SectionTitle";

            if ( Context.Items["SectionTitle"] != null )
            {
                string strSectionTitle = Context.Items["SectionTitle"].ToString();
                if(strSectionTitle == "ApplicationName")
                {
					lblSectionTitle.Visible = false;
					imgSaltLogo.Visible = true;
					this.lblMyTraining.Visible = true;
                }
                else
                {
                    this.lblSectionTitle.Text = strSectionTitle;
					this.lblMyTraining.Visible = false;
                }                
            } 
            else
            {
                string strSectionTitle = System.Configuration.ConfigurationSettings.AppSettings["SectionTitle"];
                if(strSectionTitle == "ApplicationName")
                {
					lblSectionTitle.Visible = false;
					imgSaltLogo.Visible = true;
					
                }
                else
                {
                    this.lblSectionTitle.Text = ResourceManager.GetString("SectionTitle_" + strSectionTitle);
					
                }
            }

			switch(UserContext.UserData.UserType)
			{
					case UserType.SaltAdmin:
					{
						this.lblMyTraining.Visible = false;
						break;
					}
					default:
					{
						this.lblMyTraining.Visible = true;
						break;
					}
			}

			if (Request.ServerVariables["URL"].ToString() == "/Help.aspx")
			{
				this.imgSaltLogo.Visible = false;
				this.lblSectionTitle.Visible = true;
				this.lblSectionTitle.Text = ResourceManager.GetString("lblHelp");				
			}
		}
        private void PaintOrgImage()
        {
            //1. Get the image name from the UserContext.
            string strImageName = UserContext.UserData.OrgLogo;


            // GetOrganisation(SqlString LangCode, SqlInt32 orgID)
            // UserContext.UserData.OrgID
            BusinessServices.Organisation objOrganisation = new BusinessServices.Organisation();
            DataTable dtOrganisation = objOrganisation.GetOrganisation(Request.Cookies["currentCulture"].Value, UserContext.UserData.OrgID);

            if (dtOrganisation.Rows.Count > 0)
            {
                strImageName = dtOrganisation.Rows[0]["Logo"].ToString();
                if (strImageName.Length > 4)
                {

                    this.imgHeader.Src = "/General/Images/Header/" + strImageName;
                    this.imgHeaderAdmin.Src = "/General/Images/Header/" + strImageName;
                    return;
                }
            }

        }
		/// <summary>
		/// This method gets the Header Image/Logo based on the current Users ogranisation.
		/// It gets the organisation information from the UserContext class.
		/// </summary>
		private void GetHeaderImage()
		{
			//1. Get the image name from the UserContext.
			string strImageName = UserContext.UserData.OrgLogo;
			
			//2. Set the src for the image.
			this.imgHeader.Src = cm_strHeaderImagePath + strImageName;
		}
		
		/// <summary>
		/// Click Event for the Exit link button.
		/// When clicked signs out the user and redirects control to the login page.
		/// </summary>
		/// <param name="sender">LinkButton object.</param>
		/// <param name="e">EventArgs for the link button.</param>
		/// <remarks>Signing out refers to the removal of the forms authentication ticket.</remarks>
		protected void lnkExit_Click(object sender, EventArgs e)
		{
            try
            {
                FormsAuthentication.SignOut();
            }
            finally
            {
                //if (FormsAuthentication.RequireSSL)
                //if (FormsAuthentication.LoginUrl.ToUpper().Contains("RESTRICTED"))
                if (Boolean.Parse(ConfigurationSettings.AppSettings["EnableSSL"].ToString()) == true)

                {
                    Response.Redirect("https://" + Request.Url.Host + FormsAuthentication.LoginUrl);
                }
                else
                {
                    Response.Redirect("http://" + Request.Url.Host + FormsAuthentication.LoginUrl);
                }

            }
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
		///	Required method for Designer support - do not modify
		///	the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{

        }
		#endregion
	}
}