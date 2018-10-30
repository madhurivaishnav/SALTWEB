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

namespace Bdw.Application.Salt.Web.ContentAdministration.Courses
{
    /// <summary>
    /// This class controls the page and business logic for the AddCourse.aspx page.
    /// </summary>
    /// <remarks>
    /// Assumptions: None.
    /// Notes: None.
    /// Author: Gavin Buddis
    /// Date: 03/03/2004
    /// Changes:
    /// </remarks>
    public partial class AddCourse : System.Web.UI.Page
	{
        #region Protected Variables
        /// <summary>
        /// Text box showing the name of the new course
        /// </summary>
        protected System.Web.UI.WebControls.TextBox txtName;

        /// <summary>
        /// Validator for the txtName text box control
        /// </summary>
        protected System.Web.UI.WebControls.RequiredFieldValidator rvldName;

        /// <summary>
        /// Text box showing the notes for the new course
        /// </summary>
        protected System.Web.UI.WebControls.TextBox txtNotes;

        /// <summary>
        /// The status of the new course
        /// </summary>
        protected System.Web.UI.WebControls.DropDownList cboStatus;

        /// <summary>
        /// The label to hold any messages that need to be displayed to the user.
        /// </summary>
        protected System.Web.UI.WebControls.Label lblMessage;

        /// <summary>
        /// The lable to display the page title
        /// </summary>
        protected System.Web.UI.WebControls.Label lblPageTitle;

        /// <summary>
        /// Link to return back to the admin page
        /// </summary>
        protected LocalizedLinkButton lnkReturnToAdminHomepage;

        /// <summary>
        /// A Validator that is required to validate user input of the course notes
        /// </summary>
        protected System.Web.UI.WebControls.RequiredFieldValidator Requiredfieldvalidator1;


        /// <summary>
        /// The button to save the current course details
        /// </summary>
        protected System.Web.UI.WebControls.Button btnSave;
        # endregion

        #region Private Event Handlers
        /// <summary>
        /// Event handler for the page load.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			cboStatus.Items[0].Text = ResourceManager.GetString("cmnActive" );
			cboStatus.Items[1].Text = ResourceManager.GetString("cmnInactive");
			// Put user code to initialize the page here

		} // Page_Load

        /// <summary>
        /// Event hanlder for clicking the Save button
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnSave_Click(object sender, System.EventArgs e)
        {
            // Save the course details on the page
            SaveCourseDetails();



        } // btnSave_Click

        /// <summary>
        /// Event handler for clicking the Cancel button
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void lnkReturnToAdminHomepage_Click(object sender, System.EventArgs e)
        {
            // Return to the calling page - the Default page as the current user is a 
            // SALT Administrator
            Response.Redirect("/Default.aspx");

        } // lnkReturnToAdminHomepage_Click

        # endregion

        #region Private Methods
        /// <summary>
        /// Save the new course details to the database
        /// </summary>
        private void SaveCourseDetails()
        {
            BusinessServices.Course objCourse = new  BusinessServices.Course();

            bool blnActive;     // UI value for the active status of the course
            int intCourseID;    // New course ID available after database Insert
			
            // Retrieve the values from the UI
            blnActive = (this.cboStatus.SelectedValue == "1");


            // The length of the course notes must be validated seperately because
            // the text area control doesnt have a maximum length.
            if (this.txtNotes.Text.Length>1000)
            {
                this.lblMessage.Text = ResourceManager.GetString("lblMessage.LengthError");
                this.lblMessage.CssClass = "WarningMessage";
                return;
            }

            // Create the course in the database and redirect to the course details page
            try
            {
                intCourseID = objCourse.Create(this.txtName.Text, this.txtNotes.Text, blnActive, UserContext.UserID);
                Response.Redirect(@"/ContentAdministration/Courses/CourseDetails.aspx?CourseID=" + intCourseID.ToString());
            }
            catch(UniqueViolationException ex)
            {
                this.lblMessage.Text = ex.Message;
                this.lblMessage.CssClass = "WarningMessage";
            }
            catch(ParameterException ex)
            {
                this.lblMessage.Text = ex.Message;
                this.lblMessage.CssClass = "WarningMessage";
            }
            catch(PermissionDeniedException ex)
            {
                this.lblMessage.Text = ex.Message;
                this.lblMessage.CssClass = "WarningMessage";
            }
            catch(IntegrityViolationException ex)
            {
                this.lblMessage.Text = ex.Message;
                this.lblMessage.CssClass = "WarningMessage";
            }
            catch(Exception ex)
            {
                throw new ApplicationException(ex.Message);
            }

        } // SaveCourseDetails
        #endregion

		#region Web Form Designer generated code
        /// <summary>
        ///  This call is required by the ASP.NET Web Form Designer.
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
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    

        }
		#endregion
	}
}
