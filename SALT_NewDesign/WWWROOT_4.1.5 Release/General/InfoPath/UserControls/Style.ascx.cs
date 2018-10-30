namespace Bdw.Application.Salt.Web.General.InfoPath.UserControls
{
	using System;
    using System.Collections;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;

    using Bdw.Application.Salt.InfoPath;
	/// <summary>
	///		Summary description for Style.
	/// </summary>
	public partial class Style : System.Web.UI.UserControl
	{

        protected void Page_Load(object sender, System.EventArgs e)
        {
            SetupStyle();
        }
        private void SetupStyle()
        {
            string strCss = PageContext.Current.Style;

            litPresentationStyle.Text = "<link href=\"/General/Infopath/Styles/" + strCss + "/Presentation.css\" rel=\"stylesheet\" type=\"text/css\">";
            litLayoutStyle.Text = "<link href=\"/General/Infopath/Styles/" + strCss + "/layout.css\" rel=\"stylesheet\" type=\"text/css\">";
			litPageLayoutStyle.Text = "<link href=\"/General/Infopath/Styles/" + strCss + "/" + PageContext.Current.Layout +  ".css\" rel=\"stylesheet\" type=\"text/css\">";
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
		///		Required method for Designer support - do not modify
		///		the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{

		}
		#endregion
	}
}
