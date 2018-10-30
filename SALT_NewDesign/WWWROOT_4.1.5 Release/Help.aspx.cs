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
	/// Summary description for Help.
	/// </summary>
	public partial class HelpTextIntro : System.Web.UI.Page
	{
        protected System.Web.UI.WebControls.Label lblApplicationName;
        
        #region Protected variables
        /// <summary>
        /// HTML TD Control containg the help text
        /// </summary>
        protected System.Web.UI.HtmlControls.HtmlTableCell tdHelpText;
        #endregion

        #region Private Events
		protected void Page_Load(object sender, System.EventArgs e)
		{
            string strApplicationName = Utilities.ApplicationSettings.AppName; // the name of the application
            string strTradeMarkSymbol = Utilities.ApplicationSettings.TradeMark; // The trade mark symbol if there is one or an empty string
            string strAppAndTradeMark = "<span class='helpApplicationName'>" + strApplicationName + "</span>" + "<span class='HelpTradeMarkInlineInheritColour'>" + strTradeMarkSymbol + "</span>";
            //string strHelpContent = tdHelpText.InnerHtml.ToString(); // worker string holding the help content being updated.

            //lblApplicationName.Text = strApplicationName;
           // strHelpContent = strHelpContent.Replace("%ApplicationName%",strAppAndTradeMark);
            //tdHelpText.InnerHtml = strHelpContent;

			lblIntroduction1.Text = String.Format(ResourceManager.GetString("lblIntroduction"), strApplicationName);
			lblIntroduction2.Text = String.Format(ResourceManager.GetString("lblIntroduction"), strApplicationName);

			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
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

		protected override void Render(HtmlTextWriter writer)
		{

			//-- Replace all {0} placeholders with the company name.
			string strApplicationName = Utilities.ApplicationSettings.AppName; // the name of the application
			string strTradeMarkSymbol = Utilities.ApplicationSettings.TradeMark; // The trade mark symbol if there is one or an empty string
			string strAppAndTradeMark = "<span class='helpApplicationName'>" + strApplicationName + "</span>" + "<span class='HelpTradeMarkInlineInheritColour'>" + strTradeMarkSymbol + "</span>";


			System.Text.StringBuilder sb = new System.Text.StringBuilder();
			System.IO.StringWriter sw = new System.IO.StringWriter(sb);
			HtmlTextWriter newWriter = new HtmlTextWriter(sw);
                  
			base.Render(newWriter);
                  
			sb.Replace("{0}", strAppAndTradeMark);

			Response.Write(sb.ToString());
			
		}

	}
}
