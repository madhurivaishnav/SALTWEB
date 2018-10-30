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
namespace Bdw.Application.Salt.Web.ContentAdministration.Modules
{
    /// <summary>
    /// This class controls the page and business logic for the ModuleDetails.aspx page.
    /// </summary>
    /// <remarks>
    /// Assumptions: None.
    /// Notes: None.
    /// Author: Gavin Buddis
    /// Date: 03/03/2004
    /// Changes:
    /// </remarks>
    public partial class ModuleDetails : System.Web.UI.Page
	{
        # region Private Constants
        /// <summary>
        /// Index name used to store the Valid Lesson in ViewState
        /// </summary>
        private const string cm_strLessonViewState = "Lesson";

        /// <summary>
        /// Index name used to store the Valid Quiz in ViewState
        /// </summary>
        private const string cm_strQuizViewState = "Quiz";
        # endregion

        # region Protected Variables
        /// <summary>
        /// Text box showing the name of the current module
        /// </summary>
        protected System.Web.UI.WebControls.TextBox txtName;

        /// <summary>
        /// Validator for the txtName text box control
        /// </summary>
        protected System.Web.UI.WebControls.RequiredFieldValidator rvldName;

        /// <summary>
        /// The status of the current module
        /// </summary>
        protected System.Web.UI.WebControls.DropDownList cboStatus;

        /// <summary>
        /// The label to hold any messages that need to be displayed to the user
        /// </summary>
        protected System.Web.UI.WebControls.Label lblMessage;

        /// <summary>
        /// Text box showing the description for the current module
        /// </summary>
        protected System.Web.UI.WebControls.TextBox txtDescription;

        /// <summary>
        /// The button to save the current module details
        /// </summary>
        protected System.Web.UI.WebControls.Button btnSave;

        /// <summary>
        /// The label to show the current Toolbook Quiz details
        /// </summary>
        protected System.Web.UI.WebControls.Label lblQuizDetails;

        /// <summary>
        /// The label to show the current Toolbook Lesson details
        /// </summary>
        protected System.Web.UI.WebControls.Label lblLessonDetails;

        /// <summary>
        /// The label to display the page title
        /// </summary>
        protected System.Web.UI.WebControls.Label lblPageTitle;


        #endregion

        #region Private Variables
        /// <summary>
        /// Flag to indicate whether there is a valid Toolbook Lesson available
        /// </summary>
        private bool m_bValidLesson;

        /// <summary>
        /// Link back to course details
        /// </summary>
        protected System.Web.UI.WebControls.LinkButton lnkReturnToCourseDetail;

        /// <summary>
        /// Link to upload new content
        /// </summary>
        protected System.Web.UI.WebControls.LinkButton lnkUploadContent;


        /// <summary>
        /// Flag to indicate whether there is a valid Toolbook Quiz available
        /// </summary>
        private bool m_bValidQuiz;
        #endregion

        #region Private Event Handlers
        /// <summary>
        /// Event handler for the page load
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, System.EventArgs e)
        {
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");

            int intModuleID;    // Module ID from the query string if viewing an existing module
            int intCourseID;    // Course ID from the query string for a new module otherwise from the Module ID

            // Retreive the ViewState values for the Valid Lesson and Quiz values
            if (ViewState[cm_strLessonViewState] != null)
            {
                m_bValidLesson = Boolean.Parse(ViewState[cm_strLessonViewState].ToString());
            }
            if (ViewState[cm_strQuizViewState] != null)
            {
                m_bValidQuiz = Boolean.Parse(ViewState[cm_strQuizViewState].ToString());
            }

            if (!Page.IsPostBack)
            {
                // If a ModuleID was supplied via the query string, showing details of an 
                // existing module else retreive the CourseID for a new module
                if (Request.QueryString["ModuleID"] != null)
                {
                    intModuleID = int.Parse(Request.QueryString["ModuleID"]);
                    SetPageState();
                }
                else
                {
                    intCourseID = int.Parse(Request.QueryString["CourseID"]);
                    SetPageState();
                }
            }

            // Save the ViewState values for the Valid Lesson and Quiz values
            ViewState[cm_strLessonViewState] = m_bValidLesson;
            ViewState[cm_strQuizViewState] = m_bValidQuiz;

			cboStatus.Items[0].Text = ResourceManager.GetString("cmnActive" );
			cboStatus.Items[1].Text = ResourceManager.GetString("cmnInactive");
        } // Page_Load

        /// <summary>
        /// Event hanlder for the Save button
        /// </summary>
        protected void btnSave_Click(object sender, System.EventArgs e)
        {
            // Save the module details on the page
            SaveModuleDetails();

        } // btnSave_Click


		
        /// <summary>
        /// Event handler for the Return to Course Details link button.  
        /// Redirects the user back to the course detail page.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void lnkReturnToCourseDetail_Click(object sender, System.EventArgs e)
        {
            int intModuleID;        // Module ID for the currently displayed module
            string szCourseID;      // Course ID for the Course to return to

            // Try and retrieve the Course ID from the query string object
            szCourseID = (Request.QueryString["CourseID"] != null) ? Request.QueryString["CourseID"] : null;

            // If no Course ID in query string, have to get Course ID from the database for the 
            // current module
            if (szCourseID == null)
            {
                intModuleID = (Request.QueryString["ModuleID"] != null) ? int.Parse(Request.QueryString["ModuleID"]) : 0;
                Module objModule = new Module();
                DataTable dtbModule = objModule.GetModule(intModuleID, UserContext.UserData.OrgID);
                szCourseID = dtbModule.Rows[0]["CourseID"].ToString();
            }

            // Return to the course detail page
            Response.Redirect("/ContentAdministration/Courses/CourseDetails.aspx?CourseID=" + szCourseID);

        } // lnkReturnToCourseDetail_Click

        /// <summary>
        /// Event handler to load new Toolbook content (lesson or quiz)
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void lnkUploadContent_Click(object sender, System.EventArgs e)
        {
            int intModuleID = int.Parse(Request.QueryString["ModuleID"]);
            Response.Redirect("/ContentAdministration/Modules/UploadToolBookContent.aspx?ModuleID=" + intModuleID);

        } // lnkUploadCOntent_Click


        # endregion

        #region Private Methods
        /// <summary>
        /// Set the initial page state
        /// </summary>
        private void SetPageState()
        {
            int intModuleID;

            // Set the Lesson and Quiz details to their default values
            lblLessonDetails.Text = ResourceManager.GetString("Message.NoLesson");
            lblQuizDetails.Text = ResourceManager.GetString("Message.NoQuiz");;

            // Load the module details if displaying an existing module, otherwise if a
            // parent course was supplied display a page for a new module
            intModuleID = (Request.QueryString["ModuleID"] != null) ? int.Parse(Request.QueryString["ModuleID"]) : 0;
            if (intModuleID != 0)
            {
                // Retrieve the module's details from the database
                Module objModule = new BusinessServices.Module();
                DataTable dtbModule = objModule.GetModule(intModuleID, UserContext.UserData.OrgID);

                // Populate the UI controls with the module's details
                this.txtName.Text = dtbModule.Rows[0]["Name"].ToString();
                this.txtDescription.Text = dtbModule.Rows[0]["Description"].ToString();
                if ( Convert.ToBoolean(dtbModule.Rows[0]["Active"].ToString()) )
                {
                    this.cboStatus.SelectedIndex = 0;
                }
                else
                {
                    this.cboStatus.SelectedIndex = 1;
                }


                // Display the details for the Toolbook quiz
                DataTable dtbQuiz = objModule.GetQuiz(intModuleID, UserContext.UserData.OrgID);
                if (dtbQuiz.Rows.Count > 0)
                {
                    if (dtbQuiz.Rows[0]["LectoraBookmark"].ToString() == "imsmanifest.xml")
                    {
                        m_bValidQuiz = true;

                        rfvQWorksiteID.Enabled = true;
                        txtQWorksiteID.Visible = true;
                        txtQWorksiteID.Text = dtbQuiz.Rows[0]["WorkSiteID"].ToString();


                        lblQuizDetails.Text = String.Format(ResourceManager.GetString("lblQuizDetails.2"), dtbQuiz.Rows[0]["ToolbookID"].ToString(), DateTime.Parse(dtbQuiz.Rows[0][6].ToString()).ToString("d"));

                        m_bValidLesson = true;


                        //-- Worksite IDs
                        txtLWorksiteID.Visible = true;
                        txtQFWorksiteID.Visible = true;
                        rfvLWorksiteID.Enabled = true;
                        rfvQFWorksiteID.Enabled = true;
                        txtLWorksiteID.Text = "1";
                        txtQFWorksiteID.Text = "1";


                        lblLessonDetails.Text = "SCORM Adaptive";
                    }
                    else
                    {
                        switch (dtbQuiz.Rows.Count)
                        {
                            case 0:
                                lblQuizDetails.Text = ResourceManager.GetString("lblQuizDetails.1");//"No Quiz loaded. This module cannot be made active until a Quiz is uploaded.";
                                lblQWorksiteMsg.Text = ResourceManager.GetString("lblQWorksiteMsg.1");//"No Quiz Loaded.";
                                m_bValidQuiz = false;
                                break;
                            case 1:
                                m_bValidQuiz = true;

                                rfvQWorksiteID.Enabled = true;
                                txtQWorksiteID.Visible = true;
                                txtQWorksiteID.Text = dtbQuiz.Rows[0]["WorkSiteID"].ToString();


                                lblQuizDetails.Text = String.Format(ResourceManager.GetString("lblQuizDetails.2"), dtbQuiz.Rows[0]["ToolbookID"].ToString(), DateTime.Parse(dtbQuiz.Rows[0][6].ToString()).ToString("d"));
                                break;
                            default:
                                // Unexpected error
                                m_bValidQuiz = false;
                                lblQuizDetails.Text = ResourceManager.GetString("lblQuizDetails.3");//"Error: More than 1 Quiz available. Please correct this before saving."; // Should only the most recent quiz for this module be kept active?
                                lblQuizDetails.CssClass = "WarningMessage";
                                break;
                        }



                        // Display the details for the Toolbook lesson
                        DataTable dtbLesson = objModule.GetLesson(intModuleID, UserContext.UserData.OrgID);
                        switch (dtbLesson.Rows.Count)
                        {
                            case 0:
                                lblLessonDetails.Text = ResourceManager.GetString("lblLessonDetails.1");//"No Lesson loaded. This module cannot be made active until a Lesson is uploaded.";

                                lblLWorksiteMsg.Text = ResourceManager.GetString("lblLWorksiteMsg");//"No Lesson Loaded.";
                                lblQFWorksiteMsg.Text = ResourceManager.GetString("lblQFWorksiteMsg");//"No Lesson Loaded.";

                                m_bValidLesson = false;
                                break;
                            case 1:
                                m_bValidLesson = true;


                                //-- Worksite IDs
                                txtLWorksiteID.Visible = true;
                                txtQFWorksiteID.Visible = true;
                                rfvLWorksiteID.Enabled = true;
                                rfvQFWorksiteID.Enabled = true;
                                txtLWorksiteID.Text = dtbLesson.Rows[0]["LWorkSiteID"].ToString();
                                txtQFWorksiteID.Text = dtbLesson.Rows[0]["QFWorkSiteID"].ToString();


                                lblLessonDetails.Text = String.Format(ResourceManager.GetString("lblLessonDetails"), dtbLesson.Rows[0]["ToolbookID"].ToString(), DateTime.Parse(dtbLesson.Rows[0][6].ToString()).ToString("d"));
                                //				"Lesson: " + dtbLesson.Rows[0]["ToolbookID"].ToString() + " uploaded on " + DateTime.Parse(dtbLesson.Rows[0]["DateLoaded"].ToString()).ToString("d");
                                break;
                            default:
                                // Unexpected error
                                m_bValidLesson = false; // Should only the most recent quiz for this module be kept active?
                                lblLessonDetails.Text = ResourceManager.GetString("lblLessonDetails.2");//"Error: More than 1 Lesson available. Please correct this before saving.";
                                lblLessonDetails.CssClass = "WarningMessage";
                                break;
                        }
                    }
                }
				lnkResetLesson.NavigateUrl = "ResetLesson.aspx?ModuleID=" + intModuleID.ToString();
				lnkResetQuiz.NavigateUrl = "ResetQuiz.aspx?ModuleID=" + intModuleID.ToString();
            }
            else
            {
                // Set the Lesson and Quiz labels
                lblLessonDetails.Text = ResourceManager.GetString("lblLessonDetails.3");//"Cannot upload a Lesson until the Module has been saved";
                lblQuizDetails.Text = ResourceManager.GetString("lblQuizDetails.4");//"Cannot upload a Quiz until the Module has been saved";

                // Hide the load content button
                this.lnkUploadContent.Visible = false;
				this.lnkResetLesson.Visible = false;
				this.lnkResetQuiz.Visible = false;
            }
               

        } // SetPageState

        /// <summary>
        /// Save the current module's details to the database
        /// </summary>
        private void SaveModuleDetails()
        {
            string szInvalidMessage = "";   // Message displayed if module forced inactive
            int intModuleID;                // Module ID of the current module
            int intCourseID;                // Course ID for which to create the new module
            bool blnActive;                 // Status flag retreived from the UI

			if (!this.IsValid) { return;}

            // Prepare a warning message if either the lesson or quiz is not valid
            if (!m_bValidLesson || !m_bValidQuiz)
            {
                // Invalid lesson and / or quiz
                if (this.cboStatus.SelectedIndex != 1)
                {
                    // Set the module status to Inactive
                    this.cboStatus.SelectedIndex = 1;
                    szInvalidMessage = ResourceManager.GetString("InvalidMessage");//"Module status set inactive as there is no lesson or quiz loaded";
                }
            }

            // Retrieve the Module ID and / or Course ID from the request object
            intModuleID = (Request.QueryString["ModuleID"] != null) ? int.Parse(Request.QueryString["ModuleID"]) : 0;
            intCourseID = (Request.QueryString["CourseID"] != null) ? int.Parse(Request.QueryString["CourseID"]) : 0;

            // Retrive the details from the UI regardless of whether an update or insert will
            // be performed
            if (intModuleID != 0 || intCourseID != 0)
            {
                // Retreive the active value from the UI
                blnActive = (this.cboStatus.SelectedIndex==0);

                // Create the Module object to update the module's details in the database
                Module objModule = new BusinessServices.Module();	
                string strModuleName =  this.txtName.Text;
                string strModuleDesc = this.txtDescription.Text;

                // The length of the module desc must be validated seperately because
                // the text area control doesnt have a maximum length.
                if (strModuleDesc.Length>1000)
                {
                    this.lblMessage.Text = ResourceManager.GetString("lblMessage");//"The module description may contain no more than 1000 characters.";
                    this.lblMessage.CssClass = "WarningMessage";
                    return;
                }

                // Check if an existing module is being updated or a new one is being created
                if (intModuleID != 0)
                {
                    try
                    {
                        // Update the exiting module's details
                        objModule.Update(intModuleID, strModuleName, strModuleDesc, blnActive, UserContext.UserID, txtQWorksiteID.Text, txtLWorksiteID.Text, txtQFWorksiteID.Text);

                        // Prepare the message to display to the user
                        this.lblMessage.Text = ResourceManager.GetString("lblMessage.2");//"The module details were saved succesfully";
                        this.lblMessage.CssClass = "SuccessMessage";
                        if (szInvalidMessage.Length > 0)
                        {
                            this.lblMessage.Text += " " + szInvalidMessage;
                            this.lblMessage.CssClass = "WarningMessage";
                        }
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
                }
                else if (intCourseID != 0)
                {
                    try
                    {
                        // Create a new module
                        intModuleID = objModule.Create(intCourseID,strModuleName, strModuleDesc, blnActive, UserContext.UserID);

                        // Set the new module's sequence value to be one higher than the current 
                        // module count for the course
                        int intNewModuleSequence = objModule.GetModuleListByCourse(intCourseID, UserContext.UserData.OrgID).Rows.Count;
                        objModule.UpdateSequence(intModuleID, intNewModuleSequence, UserContext.UserID);

						// Set all units to have deny permission against every unit (Silly, but its the only way without re-engineerring the app).
						BusinessServices.Unit.DenyAllForModule(intCourseID, intModuleID);


                        // Redirect to the Module Detail page to refresh the UI
                        Response.Redirect("/ContentAdministration/Modules/ModuleDetails.aspx?ModuleID=" + intModuleID);
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
                    catch(ApplicationException ex)
                    {
                        this.lblMessage.Text = ex.Message;
                        this.lblMessage.CssClass = "WarningMessage";
                    }
                    catch(Exception ex)
                    {
                        throw new ApplicationException(ex.Message);
                    }
                }
            }

        } // SaveModuleDetails
        #endregion

		#region Web Form Designer generated code

        /// <summary>
        /// This call is required by the ASP.NET Web Form Designer.
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
