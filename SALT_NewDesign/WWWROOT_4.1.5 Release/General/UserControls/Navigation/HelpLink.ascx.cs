namespace Bdw.Application.Salt.Web.General.UserControls.Navigation
{
	using System;
	using System.Data;
    using System.Configuration;
	using System.Drawing;
	using System.Web;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;

    using Bdw.Application.Salt.BusinessServices;
	/// <summary>
	///		Summary description for HelpLink.
	/// </summary>
	public partial class HelpLink : System.Web.UI.UserControl
	{
		/// <summary>
		/// Link to the help entry on the help page.
		/// </summary>
        protected System.Web.UI.WebControls.HyperLink lnkToHelpFile;

		protected void Page_Load(object sender, System.EventArgs e)
		{
            OrganisationConfig objOrgConfig = new OrganisationConfig();
            string strShow = objOrgConfig.GetOne(Utilities.UserContext.UserData.OrgID,"ShowDetailedHelp");
            if (strShow[0].ToString().ToLower()=="y")
            {
                string strKey = this.Attributes["Key"].ToString();            
                string strDesc = this.Attributes["Desc"].ToString();
            
                this.lnkToHelpFile.Text=strDesc;
                this.lnkToHelpFile.NavigateUrl="/Help.aspx#" + strKey;
            }
            else
            {
                this.lnkToHelpFile.Visible=false;
            }
		}
        
		#region Web Form Designer generated code

		/// <summary>
		/// 
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
		///		Required method for Designer support - do not modify
		///		the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{

        }
		#endregion
	}
}
