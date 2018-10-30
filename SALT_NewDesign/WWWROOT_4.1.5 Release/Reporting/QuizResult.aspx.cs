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
using Localization;

using System.Net;
using System.IO;
using System.Xml;
using System.Web.Security;
using Bdw.Application.Salt.Web.Utilities;

namespace Bdw.Application.Salt.Web.Reporting
{
	/// <summary>
	/// Summary description for QuizResult.
	/// </summary>
	public partial class QuizResult : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.Label lblModuleName;
		protected System.Web.UI.WebControls.Label lblPassmark;
		protected System.Web.UI.WebControls.Label lblScore;
	
		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			// Gather the Quiz Session ID from the Querystring
			string strQuizSessionID;
			DataSet dstQuizSummary;
			DataTable dtbQuizSummary;
			string strModuleName;
			int intScore, intPassmark;

			strQuizSessionID = Request.QueryString["QuizSessionID"];
			// Get summary information and bind to the datagrid
			User objUser = new User ();	
			dstQuizSummary = objUser.GetQuizSummary(strQuizSessionID);
			dtbQuizSummary = dstQuizSummary.Tables[0];

			strModuleName = dtbQuizSummary.Rows[0]["Module"].ToString();

            if (!DBNull.Value.Equals(dtbQuizSummary.Rows[0]["QuizPassmark"]))
            {
                intPassmark = (int)dtbQuizSummary.Rows[0]["QuizPassmark"];
                intScore = (int)dtbQuizSummary.Rows[0]["QuizScore"];
                lblPassed.Visible = (intScore >= intPassmark);
                lblFailed.Visible = !(intScore >= intPassmark);


                if (intScore >= intPassmark)
                {
                    tdImage.Attributes["Class"] = "Quiz_Result_Pass";
                }
                else
                {
                    tdImage.Attributes["Class"] = "Quiz_Result_Fail";
                }

                lblPassed.Text = String.Format(ResourceManager.GetString("lblPassed"), strModuleName);
                lblFailed.Text = String.Format(ResourceManager.GetString("lblFailed"), strModuleName);
                lblPassMarkText.Text = String.Format(ResourceManager.GetString("lblPassMarkText"), intPassmark.ToString(), intScore.ToString());

                this.lnkQuizSummaryReport.NavigateUrl = "/Reporting/QuizSummary.aspx?QuizSessionID=" + strQuizSessionID;
            }
            else {
                Response.Redirect("/MyTraining.aspx");
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
