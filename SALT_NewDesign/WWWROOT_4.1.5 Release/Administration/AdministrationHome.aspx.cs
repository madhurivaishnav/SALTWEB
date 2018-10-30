using System;
using System.Collections;
using System.ComponentModel;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.Data;
using Localization;

namespace Bdw.Application.Salt.Web.Administration
{
	/// <summary>
	/// Summary description for AdministrationHome.
	/// </summary>
	public partial class AdministrationHome : System.Web.UI.Page
	{
        /// <summary>
        /// Label for administrator welcome text
        /// </summary>
        protected System.Web.UI.WebControls.Label lblAdministrationWelcome;
		#region Private Methods
		/// <summary>
		/// 
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
			if(!Page.IsPostBack)
			{
				//1. Set the non administrative user straight to the UserDetails Page.
				this.SetUserPage();
			}
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
		}
		
		/// <summary>
		/// This method checks the user type and if they are a non administrative user they get sent straight to the 
		/// UserDetails.aspx page as they do not have access to any other resources in this section.
		/// </summary>
		private void SetUserPage()
		{
			//1. Check the user type
			if(UserContext.UserData.UserType == UserType.User)
			{
				//2. Redirect to the UserDetails.aspx page.
				Response.Redirect("Users/UserDetails.aspx");
			}

            //3. Set the welcome message
            this.lblAdministrationWelcome.Text = String.Format(ResourceManager.GetString("lblAdministrationWelcome"), Utilities.ApplicationSettings.AppName, Utilities.ApplicationSettings.TradeMark);//"Welcome to <span class='ApplicationNameInline'>"
//                + Utilities.ApplicationSettings.AppName
  //              + "</span><span class='TradeMarkInline'>"
    //            + Utilities.ApplicationSettings.TradeMark
      //          + "</span> Administration. Please choose an item on the left of the screen to continue.";
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
