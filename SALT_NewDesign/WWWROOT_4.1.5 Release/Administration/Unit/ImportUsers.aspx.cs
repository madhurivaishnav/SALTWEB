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
using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.Web.Utilities;
using Localization;
namespace Bdw.Application.Salt.Web.Administration.Unit
{
	/// <summary>
	/// Summary description for ImportUsers.
	/// </summary>
	public partial class ImportUsers : System.Web.UI.Page
	{
		#region Declarations
		/// <summary>
		/// 
		/// </summary>
		private const string cm_strHierachy = "Unit";
		#endregion
		
		#region Protected Variables
		/// <summary>
		/// Unit id member variable
		/// </summary>
		protected int m_intUnitID;

       
        /// <summary>
        /// Label for page title
        /// </summary>
        protected System.Web.UI.WebControls.Label lblPageTitle;
        #endregion
		
		#region Private Event Handlers
		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			this.m_intUnitID = int.Parse(Request.QueryString["UnitID"]);

			WebSecurity.CheckUnitAdministrator(this.m_intUnitID);

			this.SetControlHeirachy();
		}

        #endregion
		
		#region Private Methods
		private void SetControlHeirachy()
		{
			HttpContext.Current.Items["Hierachy"] = cm_strHierachy;
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
