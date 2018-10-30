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
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.ErrorHandler;
using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Web.Utilities;
using Localization;
namespace Bdw.Application.Salt.Web.Reporting
{
	/// <summary>
	/// This page displays the quiz history for a specified user in a specified module
	/// The quiz history is returned from the BusinessServices Layer via the user class.
	/// </summary>
	public partial class QuizHistory : System.Web.UI.Page
	{
        /// <summary>
        /// Datagrid for quiz history results
        /// </summary>
		protected System.Web.UI.WebControls.DataGrid dgrQuizHistory;

        /// <summary>
        /// Status label for errors etc
        /// </summary>
		protected System.Web.UI.WebControls.Label lblStatus;

        /// <summary>
        /// Table surrounding quiz score
        /// </summary>
		protected System.Web.UI.WebControls.Table tblQuizScore;

        /// <summary>
        /// Table surrounding quiz pass mark
        /// </summary>
		protected System.Web.UI.WebControls.Table tblQuizPassMark;
		
        /// <summary>
        /// Table row quiz score is on
        /// </summary>
		protected System.Web.UI.WebControls.TableRow tbrQuizScore;

        /// <summary>
        /// Table row quiz passmark is on
        /// </summary>
		protected System.Web.UI.WebControls.TableRow tbrQuizPassMark;

        /// <summary>
        /// Cell containing quiz score
        /// </summary>
		protected System.Web.UI.WebControls.TableCell tclQuizScore;

        /// <summary>
        /// Cell containing quiz pass mark
        /// </summary>
		protected System.Web.UI.WebControls.TableCell tclQuizPassMark;

        /// <summary>
        /// Cell containing quiz total
        /// </summary>
		protected System.Web.UI.WebControls.TableCell tclQuizTotal;

        /// <summary>
        /// Cell containing quiz pass mark total
        /// </summary>
		protected System.Web.UI.WebControls.TableCell tclQuizPassMarkTotal;

        /// <summary>
        /// Label for Page title
        /// </summary>
        protected Localization.LocalizedLabel lblPageTitle;

		
        /// <summary>
        /// Label for quiz score
        /// </summary>
		protected System.Web.UI.WebControls.Label lblQuizScore;

        /// <summary>
        /// Link back to report
        /// </summary>
        protected System.Web.UI.WebControls.LinkButton lnkReturnToReport;

        /// <summary>
        /// Label for quiz pass mark.
        /// </summary>
		protected System.Web.UI.WebControls.Label lblQuizPassMark;
		protected Bdw.Application.Salt.Web.General.UserControls.Navigation.HelpLink ucHelp;

		/// <summary>
		/// When this page loads, it renders the Quiz history datagrid.
		/// </summary>
		/// <param name="sender">Unused</param>
		/// <param name="e">Unused</param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			ucHelp.Attributes["Desc"] = ResourceManager.GetString("ucHelp");
			int intUserID;			// Holds the UserID gathered from the Querystring.
			int intModuleID;		// Holds the ModuleID gathered from the Querystring.

            // Store the HTTP referer
            if (!Page.IsPostBack)
            {
				DataSet dstQuizHistory;
                User objUser = new User ();
				string strUserPermission;
				bool blnAccess = false;

                try
                { 
                    // Attempt to gather querystring variables
                    intUserID = Int32.Parse (Request.QueryString["UserID"]);
                    intModuleID = Int32.Parse (Request.QueryString ["ModuleID"]);
					if (UserContext.UserID == intUserID)
					{
						blnAccess= true;
					}
					else
					{
						strUserPermission = objUser.GetPermission(intUserID,UserContext.UserID);
						if (strUserPermission=="F" || strUserPermission=="S")
						{
							blnAccess = true;
						}
					}
					
					if (blnAccess)
					{
					
						// If variables are valid
						if (intUserID>0 && intModuleID>0)
						{
							// Get quiz history from the User Class
                            dstQuizHistory = objUser.GetQuizHistory(intUserID, intModuleID, UserContext.UserData.OrgID);
 
							// Bind data to datagrid
							dgrQuizHistory.DataSource = dstQuizHistory.Tables[0];
							dgrQuizHistory.DataBind();
						}
						else
						{
							// No querystring variables were specified
							lblStatus.Text=ResourceManager.GetString("lblStatus.Supply");//"You must supply a User ID and Module ID";
							lblStatus.CssClass = "WarningMessage";

						}
					}
					else
					{
						this.lblStatus.Text = ResourceManager.GetString("lblStatus.Permission");//"You are not allowed to access these results";
                        this.lblStatus.CssClass = "WarningMessage";
					}
                }
                catch (Exception Ex)
                {
                    // An error occured
                    ErrorLog Error = new ErrorHandler.ErrorLog(Ex,ErrorLevel.Medium,"QuizHistory.aspx","Page_Load","Binding History Datagrid");
                    throw (Ex);
                }
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
			dgrQuizHistory.Columns[1].HeaderText = ResourceManager.GetString("grid_Status");
			dgrQuizHistory.Columns[2].HeaderText = ResourceManager.GetString("grid_Summary");
			dgrQuizHistory.Columns[3].HeaderText = ResourceManager.GetString("grid_PassMark");
			dgrQuizHistory.Columns[4].HeaderText = ResourceManager.GetString("grid_YourMark");
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
            this.dgrQuizHistory.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(this.dgrQuizHistory_ItemDataBound);
		}
		#endregion

        /// <summary>
        /// The event handler for returning to the page where the user navigated to
        /// </summary>
        /// <param name="sender">object</param>
        /// <param name="e">System.EventArgs</param>
        private void lnkReturnToReport_Click(object sender, System.EventArgs e)
        {
            // Redirect to the calling page
            Response.Redirect(ViewState["HTTPReferer"].ToString());
        }
		

		/// <summary>
		/// This event is trigged as the grid renders each row.
		/// </summary>
		/// <param name="source"></param>
		/// <param name="e"></param>
		private void dgrQuizHistory_ItemDataBound(object source, DataGridItemEventArgs e)
		{
			// Columns holding various fields.
            //int c_intColumnStatus = 1;
            int c_intColumnSummary = 2;
			int c_intColumnPassMark = 3;
			int c_intColumnQuizMark = 4;
			if(e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.SelectedItem || e.Item.ItemType == ListItemType.EditItem)
			{
				Table tblMark;			// Table containing the Graphical Mark
				Table tblPassMark;		// Table containing the Graphical Mark
				Label lblMark;			// Label containing the Textual Mark
				Label lblPassMark;		// Label containing the Textual Pass Mark

				int intQuizScore;	// Quiz score.
				int intQuizPassMark;
                try
                {
                    //Get the table which is in the fourth cell
                    tblPassMark = (Table)e.Item.Cells[c_intColumnPassMark].Controls[1];
                    tblMark		= (Table)e.Item.Cells[c_intColumnQuizMark].Controls[1];
					
                    // Get the label that resides in it
                    lblMark = (Label)tblMark.Rows[0].Cells[0].Controls[0]; 
                    lblPassMark = (Label)tblPassMark.Rows[0].Cells[0].Controls[0]; 
                    // Get the current DataRow from e
                    DataRowView drwQuizAttempt = (DataRowView)e.Item.DataItem;
					
					
                    // Draw the passmark graphically
                    if (drwQuizAttempt["QuizPassMark"] == DBNull.Value)
                    {
                        lblPassMark.Text = ResourceManager.GetString("NA");//"N/A";
                        tblPassMark.Rows[0].Cells[0].Attributes.Add ("Width","5%");
                    }
                    else
                    {
                        // Get the Quiz pass mark from the QuizPassMark column
                        intQuizPassMark = Int32.Parse(drwQuizAttempt["QuizPassMark"].ToString());
                        if (intQuizPassMark < 5)
                        {
                            tblPassMark.Rows[0].Cells[0].Attributes.Add ("Width","5%");
                        }
                        else
                        {
                            // If the passmark is to be displayed as an expanding column use this line and add a colour style.
                            //tblPassMark.Rows[0].Cells[0].Attributes.Add ("Width",intQuizPassMark.ToString() +"%");
                            // If the passmark is to be displayed as a static field set the width to a fixed % - 5% is good
                            tblPassMark.Rows[0].Cells[0].Attributes.Add ("Width","5%");
                            
                        }
                        // Column one is the barchar background
                        lblPassMark.Text = intQuizPassMark.ToString() + "%";
                    }   




                    // Draw the score graphically
                    if (drwQuizAttempt["QuizScore"] == DBNull.Value)
                    {

                        // If no score was registered then there should be no link to the quiz summary
                        // See bug ID #380
                        HyperLink objLink = (HyperLink)e.Item.Cells[c_intColumnSummary].Controls[0];
                        Literal objLiteral = new Literal();
                        objLiteral.Text = objLink.Text;

                        // Remove hte hyper link and add a literal in its place.
                        e.Item.Cells[c_intColumnSummary].Controls.Remove(objLink);
                        e.Item.Cells[c_intColumnSummary].Controls.Add(objLiteral);
                        
                        
                        intQuizScore=0;
                        lblMark.Text = "N/A";                      
                        tblMark.Rows[0].Cells[0].Attributes.Add ("class","BarChartNA"); 
                        tblMark.Rows[0].Cells[1].Visible = false;
                    }
                    else
                    {
                        // Get the Quiz Score from the QuizScore column
                        intQuizPassMark = Int32.Parse(drwQuizAttempt["QuizPassMark"].ToString());
                        intQuizScore = Int32.Parse(drwQuizAttempt["QuizScore"].ToString());
                        if (intQuizScore < 5)
                        {
                            tblMark.Rows[0].Cells[0].Attributes.Add ("Width","5%");
                        }
                        else
                        {
                            // The width of the TD is what gives the barchart like effect.
                            tblMark.Rows[0].Cells[0].Attributes.Add ("Width",intQuizScore.ToString() +"%");
                            if(intQuizScore >= intQuizPassMark)
                            {
                                // green for pass
                                tblMark.Rows[0].Cells[0].Attributes.Add ("class","BarChartPass");
                            }
                            else
                            {
                                // red for fail
                                tblMark.Rows[0].Cells[0].Attributes.Add ("class","BarChartFail");                                
                            }
                            // if the score was 100% then there is no need to have a spacer filling out the rest of the column
                            if(intQuizScore == 100)
                            {
                                tblMark.Rows[0].Cells[1].Visible = false;
                            }
                        }
                        
                        // Column one is the barchar background
                        lblMark.Text = intQuizScore.ToString() + "%";
                    }
                }
                catch(Exception Ex)
                {
                    ErrorLog Error = new ErrorHandler.ErrorLog(Ex,ErrorLevel.Medium,"QuizHistory.aspx","dgrQuizHistory_ItemDataBound","Displaying Quiz Score");
                    throw (Ex);
                }
    		}
		}
	}
}
