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
using Localization;
namespace Bdw.Application.Salt.Web.Reporting
{
	/// <summary>
	/// This page displays a quiz summary for a particular Quiz Session ID
	/// </summary>
	public partial class QuizSummary : System.Web.UI.Page
	{
		protected Bdw.Application.Salt.Web.General.UserControls.Navigation.HelpLink ucHelp;
		#region Protected Variables
        /// <summary>
        /// Datagrid for quiz summary
        /// </summary>
		protected System.Web.UI.WebControls.DataGrid dgrQuizSummary;

        /// <summary>
        /// Datagrid for quiz header
        /// </summary>
		protected System.Web.UI.WebControls.DataGrid dgrQuizHeader;

        /// <summary>
        /// Label for page title
        /// </summary>
        protected System.Web.UI.WebControls.Label lblPageTitle;

        /// <summary>
        /// Label for error
        /// </summary>
		protected System.Web.UI.WebControls.Label lblError;

        /// <summary>
        /// Image for correct or incorrect image
        /// </summary>
		protected System.Web.UI.WebControls.Image imgCorrect;
		
        /// <summary>
        /// Hyperlink back to previous page.
        /// </summary>
        protected System.Web.UI.WebControls.HyperLink lnkPreviousScreen;
		#endregion
		
		#region Private Event Handlers
		/// <summary>
		/// When this page loads it renders the summary data grid with the 
		/// data provided by the GetQuizSummary Method of the user class.
		/// </summary>
		/// <param name="sender">object</param>
		/// <param name="e">System.EventArgs</param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			ucHelp.Attributes["Desc"] = ResourceManager.GetString("ucHelp");
            // If this page was accessed from the toolbook it wont have a url referrer
            if (this.Request.UrlReferrer != null && this.Request.UrlReferrer.AbsolutePath.ToLower().IndexOf("quizresult") == -1)
            {
                // Return to the the last page in history
                this.lnkPreviousScreen.Text = ResourceManager.GetString("lnkPreviousScreen2");//"Return to previous screen";
                
                lnkHome.Visible=false;
                lnkPreviousScreen.Visible=true;
            }
            else
            {	
				this.lnkHome.NavigateUrl = "/MyTraining.aspx";
                lnkHome.Visible=true;
                lnkPreviousScreen.Visible=false;
            }

			User objUser = new User ();							// User Object
			DataSet dstQuizSummary;								// Dataset returned by the user object
			DataTable dtbQuizSummary;							// Datatable to hold summary results
			DataTable dtbQuizSummaryHeader;						// Datatable to hold summary results
			DataTable dtbQuizSummaryResults = new DataTable();	// Datatable to hold summary results to be bound
			DataRow drwSummaryRow;
			
			int intIndex=0;
			int intQuizQuestionID=0;
			int intTotalCorrectAnswers=0;
			int intGivenCorrectAnswers=0;
			int intGivenInCorrectAnswers = 0;

			string strQuizSessionID;						// Holds the Quiz Session ID
			string [] astrRowValues = new string[4];		// Array list of values for the datarow
			astrRowValues[0]="";
			// Add columns to the datatable.
			dtbQuizSummaryResults.Columns.Add ("Question",typeof(string));
			dtbQuizSummaryResults.Columns.Add ("CorrectAnswer",typeof(string));
			dtbQuizSummaryResults.Columns.Add ("GivenAnswer",typeof(string));
			dtbQuizSummaryResults.Columns.Add ("Correct",typeof(string));
			

			// Gather the Quiz Session ID from the Querystring
			strQuizSessionID = Request.QueryString["QuizSessionID"];
			if (strQuizSessionID.Length > 0)
			{
				// Get summary information and bind to the datagrid
				dstQuizSummary = objUser.GetQuizSummary(strQuizSessionID);
				dtbQuizSummaryHeader = dstQuizSummary.Tables[0];
				this.dgrQuizHeader.DataSource = dtbQuizSummaryHeader;
				this.dgrQuizHeader.DataBind();

				dtbQuizSummary = dstQuizSummary.Tables[1];
				// If the tables exist
				if (dstQuizSummary.Tables[1].Rows.Count > 0)
				{
					
                    intQuizQuestionID = (int)dtbQuizSummary.Rows[0]["QuizQuestionID"];
                    for (intIndex=0;intIndex < dtbQuizSummary.Rows.Count;intIndex++)
                    {
                       
                        if (intQuizQuestionID != (int)dtbQuizSummary.Rows[intIndex]["QuizQuestionID"])    
                        {
                            astrRowValues[3] = Convert.ToString(((intGivenCorrectAnswers == intTotalCorrectAnswers) && (intGivenInCorrectAnswers == 0)));
                            
                            // Add final row to datatable
                            drwSummaryRow = dtbQuizSummaryResults.NewRow();
                            drwSummaryRow.ItemArray = astrRowValues;
                            dtbQuizSummaryResults.Rows.Add(drwSummaryRow);
                            intQuizQuestionID = (int)dtbQuizSummary.Rows[intIndex]["QuizQuestionID"];
                            // reset all counters
                            astrRowValues[0] = "";
                            astrRowValues[1] = "";
                            astrRowValues[2] = "";
                            astrRowValues[3] = "";
                            intGivenCorrectAnswers=0;
                            intGivenInCorrectAnswers=0;
                            intTotalCorrectAnswers=0;

                        }
                        if (dtbQuizSummary.Rows[intIndex]["Question"] == DBNull.Value)
                        {
                            if ((bool) dtbQuizSummary.Rows[intIndex]["Correct"])
                            {
                                // user has given a correct answer
                                intGivenCorrectAnswers++;
                            }
                            else
                            {
                                // user has given an incorrect answer
                                intGivenInCorrectAnswers++;
                            }
                            astrRowValues[2] += dtbQuizSummary.Rows[intIndex]["GivenAnswer"].ToString() + "<BR>";
                        }
                        else
                        {
                            // another question present in list of questions
                            astrRowValues[0] = dtbQuizSummary.Rows[intIndex]["Question"].ToString();
                            astrRowValues[1] += dtbQuizSummary.Rows[intIndex]["CorrectAnswer"].ToString() + "<BR>";
                            intTotalCorrectAnswers++;
                        }
                       
                    }
                    // write out the final row
                    astrRowValues[3] = Convert.ToString(((intGivenCorrectAnswers == intTotalCorrectAnswers) && (intGivenInCorrectAnswers == 0)));
                    drwSummaryRow = dtbQuizSummaryResults.NewRow();
                    drwSummaryRow.ItemArray = astrRowValues;
                    dtbQuizSummaryResults.Rows.Add(drwSummaryRow);
                    astrRowValues[0] = "";
                    astrRowValues[1] = "";
                    astrRowValues[2] = "";
                    astrRowValues[3] = "";
					// Bind the results to the table.
					this.dgrQuizSummary.DataSource = dtbQuizSummaryResults;
					this.dgrQuizSummary.DataBind();
				}
				else
				{
					// No records returned.
					this.lblError.Text=ResourceManager.GetString("lblError.NoQuiz");//"No quiz summary information could be found";
					this.dgrQuizSummary.Visible=false;
					this.dgrQuizHeader.Visible=false;
				}
			}
			else
			{
				this.lblError.Text = ResourceManager.GetString("lblError.Unable");//"Unable to retrieve your quiz summary.";
                this.lblError.CssClass = "WarningMessage";
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

			dgrQuizHeader.Columns[0].HeaderText = ResourceManager.GetString("grid1_Module");
			dgrQuizHeader.Columns[1].HeaderText = ResourceManager.GetString("grid1_Name");
			dgrQuizHeader.Columns[2].HeaderText = ResourceManager.GetString("grid1_QuizScore");

			dgrQuizSummary.Columns[0].HeaderText = ResourceManager.GetString("grid2_Question");
			dgrQuizSummary.Columns[1].HeaderText = ResourceManager.GetString("grid2_CorrectAnswers");
			dgrQuizSummary.Columns[2].HeaderText = ResourceManager.GetString("grid2_YourAnswer");
			dgrQuizSummary.Columns[4].HeaderText = ResourceManager.GetString("grid2_Correct");
			
		}

		// This event is fired each time the summary table renders a row
		// it displays the appropriate images.
		private void dgrQuizSummary_ItemDataBound(object sender, DataGridItemEventArgs e)
		{
			// Columns holding various fields
			int m_intColumnCorrect=3;
			int m_intColumnImage=4;
			// The header/footer rows also fire this event so they must be filtered out.
			try
			{
				if(e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.SelectedItem || e.Item.ItemType == ListItemType.EditItem)
				{
					// The table row
					TableRow trwRow = (TableRow)e.Item;		

					// The table cell collection
					TableCellCollection tclCells = trwRow.Cells;
				
					// Find the Image
					System.Web.UI.WebControls.Image imgCorrect = (System.Web.UI.WebControls.Image)tclCells[m_intColumnImage].Controls[1];

					// Switch image depending on column text
					imgCorrect.ImageUrl = tclCells[m_intColumnCorrect].Text;
					if (tclCells[m_intColumnCorrect].Text == bool.TrueString)
					{
						imgCorrect.ImageUrl = "/General/Images/tick.gif";
					}
					else
					{
						if (tclCells[m_intColumnCorrect].Text == bool.FalseString)
						{
							imgCorrect.ImageUrl = "/General/Images/cross.gif";
						}
						else
						{
							imgCorrect.Visible=false;
						}
					}
					
				}
			}
			catch (Exception ex)
			{
				throw (ex);
			}
		}


		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
            this.dgrQuizSummary.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(this.dgrQuizSummary_ItemDataBound);

        }
		#endregion
	}
}
