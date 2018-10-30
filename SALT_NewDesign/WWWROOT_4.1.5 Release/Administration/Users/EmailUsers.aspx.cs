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
using System.Text;
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.ErrorHandler; 
using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Web.Utilities;
using Uws.Framework.WebControl;
using System.Web.Mail;
using Localization;
namespace Bdw.Application.Salt.Web.Administration.Users
{
	/// <summary>
	/// Summary description for BuildEmailReport.
	/// </summary>
	public partial class EmailUsers : System.Web.UI.Page
	{

	    #region Protected Variables
    		
		// Editing Area

		/// <summary>
        /// Treeview for selecting units
        /// </summary>
		protected Uws.Framework.WebControl.TreeView trvUnitsSelector;
        
        /// <summary>
        /// Label for displaying errors
        /// </summary>
		protected System.Web.UI.WebControls.Label lblError;

        /// <summary>
        /// Placeholder surrounding Edit Email bits
        /// </summary>
		protected System.Web.UI.WebControls.PlaceHolder plhEditEmail;

		/// <summary>
		/// Textbox containing CC recipients
		/// </summary>
		protected System.Web.UI.WebControls.TextBox txtCC;

		/// <summary>
        /// Textbox containing email subject
        /// </summary>
		protected System.Web.UI.WebControls.TextBox txtEmailSubject;

        /// <summary>
        /// Textbox containing email body
        /// </summary>
		protected System.Web.UI.WebControls.TextBox txtEmailBody;

		protected Localization.LocalizedLabel lblConfirmWarning;

		// Done Page

        /// <summary>
        /// Placeholdering surrounding done section
        /// </summary>
		protected System.Web.UI.WebControls.PlaceHolder plhComplete;

		/// <summary>
		/// text box containing all user id's
		/// </summary>
		protected System.Web.UI.WebControls.TextBox txtAllUserIDs;

		/// <summary>
		/// User control for report criteria
		/// </summary>
		protected Bdw.Application.Salt.Web.General.UserControls.ReportCriteria ucCriteria;

		#endregion

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
		    /// Displays the appropriate form type when the page is loaded
		    /// </summary>
		    /// <param name="sender"></param>
		    /// <param name="e"></param>
		    protected void Page_Load(object sender, System.EventArgs e)
		    {
				pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			    // Put user code to initialize the page here
			    if (!(this.IsPostBack))
			    {
				    DisplayUnits();
			    }
			    else
			    {
				    lblError.Text="";
			    }
		    }


		    /// <summary>
		    /// This methods handles the Initialise components event.
		    /// </summary>
		    private void InitializeComponent()
		    {    
				this.btnSendEmail.Attributes.Add("onclick", "return confirm('" + ResourceManager.GetString("lblConfirmWarning") + "');");

			}

	    #endregion

	    #region Private Methods

		/// <summary>
		/// This method displays all the units that the logged in use is an administrator of.
		/// </summary>
		private void DisplayUnits()
		{
			BusinessServices.Unit objUnit = new BusinessServices.Unit();
			DataSet dstUnits ;
    			
			// Get Units accessable to this user.
			try 
			{
				// Gets the units that the current user is an administrator of.
				dstUnits = objUnit.GetUnitsTreeByUserID(UserContext.UserData.OrgID ,UserContext.UserID,'A');
				if (dstUnits.Tables[0].Rows.Count==0)
				{
					this.lblError.Text += "<BR>" + ResourceManager.GetString("lblError.NoUnit");
                    this.lblError.CssClass = "FeedbackMessage";
					this.plhEditEmail.Visible=false;
				}
				else
				{
					// Convert this to an xml string for rendering by the UnitTreeConverter.
					string strUnits = UnitTreeConvert.ConvertXml(dstUnits);
					// Change to the appropriate view and load the Units in
					this.trvUnitsSelector.LoadXml(strUnits);
				}
			}
			catch (Exception Ex)
			{
				// General Exception occured, log it
				ErrorLog objError = new ErrorLog(Ex,ErrorLevel.Medium,"BulkAssignUsers.aspx.cs","DisplayUnits","Displaying Units");
				throw (Ex);
			}
		}
    		
		/// <summary>
		/// Compiles the list of users to which the email should be sent,
		/// and attempts to send it to that list + anyone on the CC list
		/// + the current user.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void btnSendEmail_Click(object sender, System.EventArgs e)
		{

			string strUnitIDs="";
			string strUserIDs="";
    				
			lblError.Text="";
    	
			try
			{
				// Get selected units
                BusinessServices.Unit objUnit = new  BusinessServices.Unit();
                string[] astrUnitIDs = astrUnitIDs = objUnit.ReturnAdministrableUnitsByUserID( UserContext.UserID, UserContext.UserData.OrgID, trvUnitsSelector.GetSelectedValues() );
				foreach (string strUnit in astrUnitIDs)
				{
					strUnitIDs+=strUnit + ",";
				}
                if (strUnitIDs.Length>0)
                {
                    strUnitIDs = strUnitIDs.Substring(0,strUnitIDs.Length-1);
                }
				
				// Get users
				DataTable dtbResults = new Email().GetUsersToEmail(UserContext.UserData.OrgID, strUnitIDs);
				foreach (DataRow drwUser in dtbResults.Rows)
				{
					strUserIDs += drwUser.ItemArray[0].ToString() + ",";
				}
				if (strUserIDs.Length > 0)
				{
					strUserIDs = strUserIDs.Substring(0,strUserIDs.Length-1);
				}

				// Validate that the user has a valid recipient, subject and body.
				if (strUserIDs.Length > 0 && this.txtEmailSubject.Text.Length > 0 && this.txtEmailBody.Text.Length > 0)
				{
					// Config
					BusinessServices.AppConfig objAppConfig = new BusinessServices.AppConfig();
					DataTable dtbAppConfig = objAppConfig.GetList();
					this.lblError.Text="";

					// Email setup
					BusinessServices.User objUser = new BusinessServices.User();
                    DataTable dtbCurrentUserDetails = objUser.GetUser(UserContext.UserID);
					string strEmailFromName = dtbCurrentUserDetails.Rows[0]["FirstName"].ToString() + " " + dtbCurrentUserDetails.Rows[0]["LastName"].ToString();
					string strEmailFromEmail =  dtbCurrentUserDetails.Rows[0]["Email"].ToString();
					string strEmailSubject=this.txtEmailSubject.Text;
					string strUsers="\n\nSent To:";
					BusinessServices.Email objEmail = new BusinessServices.Email();

					// target users
					string strEmailToName="";
					string strEmailToEmail="";
					DataTable dtbEmailAddresses = objUser.GetEmails(strUserIDs);
					foreach(DataRow drwEmailAddress in dtbEmailAddresses.Rows)
					{
						strEmailToEmail = drwEmailAddress.ItemArray[3].ToString();
						strEmailToName = drwEmailAddress.ItemArray[0].ToString() + " " + drwEmailAddress.ItemArray[1].ToString();
                        int intUserId = Int32.Parse(drwEmailAddress.ItemArray[1].ToString());
                        objEmail.SetEmailBody(this.txtEmailBody.Text, intUserId, "", "", "", "", "", "", "", "");
                        strEmailSubject = objEmail.emailHeaderSub(strEmailSubject);
                        objEmail.SendEmail(strEmailToEmail, strEmailToName, strEmailFromEmail, strEmailFromName, null, null, strEmailSubject, ApplicationSettings.MailServer, UserContext.UserData.OrgID, intUserId);

						// accumulate user list to append to current user email
						strUsers += "\n\t" + strEmailToName;
					}

					// CC list.
					string strEmailCCName="";
					strUsers += "\n\nCC:";
					foreach (string addr in this.txtCC.Text.Split(new char[] {',', ';'}))
					{
						string strEmailCCEmail = addr.Trim();
						if (strEmailCCEmail != "")
						{
							try
							{
                                objEmail.SendEmail(strEmailCCEmail, strEmailCCName, strEmailFromEmail, strEmailFromName, null, null, strEmailSubject, ApplicationSettings.MailServer, UserContext.UserData.OrgID, 0);
								strUsers += "\n\t" + strEmailCCEmail;
							}
							catch (Exception )
							{
                                objEmail.setCCSendError(strEmailCCEmail);
                                objEmail.SendEmail(strEmailFromEmail, strEmailFromName, strEmailFromEmail, strEmailFromName, null, null, "Error sending mail to CC recipient", ApplicationSettings.MailServer, UserContext.UserData.OrgID, UserContext.UserID);
							}
						}
					}

                    // copy to Current user
                    objEmail.setUserCopyEmailBody(this.txtEmailBody.Text + strUsers);
					objEmail.SendEmail(strEmailFromEmail, strEmailFromName,strEmailFromEmail, strEmailFromName,null,null,strEmailSubject, ApplicationSettings.MailServer, UserContext.UserData.OrgID, UserContext.UserID);
				
					this.plhEditEmail.Visible=false;
					this.plhComplete.Visible=true;
				}
				else
				{
					lblError.Text=ResourceManager.GetString("lblError.OneRecip");//"To send an email you must have at least one recipient, an email subject and an email body.";
					this.lblError.CssClass = "WarningMessage";
				}
			}
			catch (Exception ex)
			{
				//Catch and throw error
				ErrorLog objError = new ErrorLog(ex,ErrorLevel.High,"EmailUsers.aspx.cs","btnSendEmail_Click","General error occurred attempting to send email");
				throw (ex);
			}

    		
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void btnBack_Click(object sender, System.EventArgs e)
		{
			Response.Redirect("../AdministrationHome.aspx");
		}

        #endregion
    	
		protected override void Render(HtmlTextWriter writer)
		{
			//-- Hack. Could not work out how to use the render event in the tree view, therefore this code is run on every page that has a tree view. Hope to refactor after discovering the solution.
			System.Text.StringBuilder sb = new System.Text.StringBuilder();
			System.IO.StringWriter sw = new System.IO.StringWriter(sb);
			HtmlTextWriter newWriter = new HtmlTextWriter(sw);
                  
			base.Render(newWriter);
                  
			sb.Replace("Clear All", ResourceManager.GetString("treeClearAll"));
			sb.Replace("Collapse All", ResourceManager.GetString("treeCollapseAll"));
			sb.Replace("Expand All", ResourceManager.GetString("treeExpandAll"));
			sb.Replace("class=\"TreeView_Node\">Help</a>", "class=\"TreeView_Node\">" + ResourceManager.GetString("treeHelp") + "</a>");
			sb.Replace("Select All", ResourceManager.GetString("treeSelectAll"));

			Response.Write(sb.ToString());
			// -End Hack
			
		}
	}
}