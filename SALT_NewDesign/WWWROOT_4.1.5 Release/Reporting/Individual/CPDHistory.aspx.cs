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
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.BusinessServices;

namespace Bdw.Application.Salt.Web.Administration.CPD
{
	/// <summary>
	/// Summary description for CPDHistory.
	/// </summary>
	public partial class CPDHistory : System.Web.UI.Page
	{
		#region protected variables
			/// <summary>
			/// message lable
			/// </summary>
			protected System.Web.UI.WebControls.Label lblError;
			/// <summary>
			/// Module resultes data grid
			/// </summary>
			protected System.Web.UI.WebControls.DataGrid dgrResults;
			/// <summary>
			/// Page Title Label
			/// </summary>
			protected System.Web.UI.WebControls.Label lblPageTitle;


		# endregion


		protected void Page_Load(object sender, System.EventArgs e)
		{
			// Put user code to initialize the page here
			if (!Page.IsPostBack)
			{
				// get the required criteria
				int intUserID = UserContext.UserID;
				int intProfileID = Int32.Parse (Request.QueryString ["ProfileID"]);

				Profile objProfile = new Profile();
				DataView dvCPDHistory = new DataView();	

				if (Request.QueryString ["ModuleID"] !=null)
				{
					int intModuleID = Int32.Parse (Request.QueryString ["ModuleID"]);
					// get the data for the Grid
                    dvCPDHistory = objProfile.GetCPDModuleHistory(intProfileID, intModuleID, intUserID, UserContext.UserData.OrgID);

					if (dvCPDHistory.Table.Rows.Count ==0)
					{
						this.lblError.Text+="No results found.";
						this.lblError.CssClass = "FeedbackMessage";
					}
					else
					{
						this.plhModuleHist.Visible = true;
						this.plhModuleHist.Visible = true;
						dgrResults.DataSource = dvCPDHistory;
						dgrResults.DataBind();
					}
				}
				else
				{
					dvCPDHistory = objProfile.GetCPDProfileHistory(intProfileID,intUserID);

					if (dvCPDHistory.Table.Rows.Count ==0)
					{
						this.lblError.Text+="No results found.";
						this.lblError.CssClass = "FeedbackMessage";
					}
					else
					{
						this.plhProfileHist.Visible = true;
						dgrProfileHist.DataSource = dvCPDHistory;
						dgrProfileHist.DataBind();
					}
				}
			}
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
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
		}
		#endregion
	}
}
