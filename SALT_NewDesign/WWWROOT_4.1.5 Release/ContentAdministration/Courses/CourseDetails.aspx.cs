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
using System.IO;
using System.Configuration;
namespace Bdw.Application.Salt.Web.ContentAdministration.Courses
{
    /// <summary>
    /// This class controls the page and business logic for the CourseDetails.aspx page.
    /// </summary>
    /// <remarks>
    /// Assumptions: None.
    /// Notes: None.
    /// Author: Gavin Buddis
    /// Date: 03/03/2004
    /// Changes:
    /// </remarks>
    public partial class ModifyCourse : System.Web.UI.Page
	{
        # region Protected Variables
        /// <summary>
        /// Drop down list of all courses defined in the application
        /// </summary>
        protected System.Web.UI.WebControls.DropDownList cboCourses;

        /// <summary>
        /// Text box showing the name of the currently selected course
        /// </summary>
        protected System.Web.UI.WebControls.TextBox txtName;

        /// <summary>
        /// Validator for the txtName text box control
        /// </summary>
        protected System.Web.UI.WebControls.RequiredFieldValidator rvldName;

        /// <summary>
        /// Text box showing the notes for the currently selected course
        /// </summary>
        protected System.Web.UI.WebControls.TextBox txtNotes;

        /// <summary>
        /// The label to hold any messages that need to be displayed to the user
        /// </summary>
        protected System.Web.UI.WebControls.Label lblMessage;

        /// <summary>
        /// The button to save the current course details
        /// </summary>
        protected System.Web.UI.WebControls.Button btnSave;

        /// <summary>
        /// The datagrid of modules in the current course
        /// </summary>
        protected System.Web.UI.WebControls.DataGrid grdModules;

        /// <summary>
        /// The lable to display the page title
        /// </summary>
        protected System.Web.UI.WebControls.Label lblPageTitle;

        /// <summary>
        /// Validator for the txtNotes text box control
        /// </summary>
        protected System.Web.UI.WebControls.RequiredFieldValidator rvldNotes;

        /// <summary>
        /// Link back to admin homepage
        /// </summary>
        protected System.Web.UI.WebControls.LinkButton lnkReturnToAdminHomepage;

        /// <summary>
        /// A Validator that is required to validate user input of the course notes
        /// </summary>
        protected System.Web.UI.WebControls.RequiredFieldValidator Requiredfieldvalidator1;
		
		/// <summary>
		/// Label to display no courses
		/// </summary>
		protected System.Web.UI.WebControls.Label lblNoCourses;
		
		/// <summary>
		/// Placeholder surrounding main screen
		/// </summary>
		protected System.Web.UI.WebControls.PlaceHolder plhMainScreen;

        /// <summary>
        /// The status of the current course
        /// </summary>
        protected System.Web.UI.WebControls.DropDownList cboStatus;
        #endregion

        # region Private Event Handlers

        /// <summary>
        /// Event handler for the page load
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, System.EventArgs e)
		{
            ResourceManager.RegisterLocaleResource("ConfirmMessage.DeleteEBook");
            ResourceManager.RegisterLocaleResource("ConfirmMessage.NotifyUsers");
			cboStatus.Items[0].Text = ResourceManager.GetString("cmnActive" );
			cboStatus.Items[1].Text = ResourceManager.GetString("cmnInactive");
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
            if (!this.IsPostBack)
            {
                // Paint the page
                SetPageState();
            }

		} // Page_Load

        /// <summary>
        /// Event handler for the course list changing value
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void cboCourses_SelectedIndexChanged(object sender, System.EventArgs e)
        {
            // Refresh the page with the details of the newly selected course
            SetCourseDetails();

        } // cboCourses_SelectedIndexChanged

        /// <summary>
        /// Event hanlder for the Save button
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnSave_Click(object sender, System.EventArgs e)
        {
            // Save the course details on the page
            SaveCourseDetails();

            // process the ebook upload
            if ((UploadFile_EBook.PostedFile != null) && (UploadFile_EBook.PostedFile.ContentLength > 0))
            {
                string FileName = Path.GetFileName(UploadFile_EBook.PostedFile.FileName);
                string strExtension = Path.GetExtension(FileName).ToLower();

                // only epub file is supported for the upload
                if (strExtension != ".epub")
                {
                    // lblMessage.UnsupportedFormat
                    this.lblUploadMessage.Text = ResourceManager.GetString("lblMessage.UnsupportedFormat");
                    this.lblUploadMessage.CssClass = "WarningMessage";
                    this.lblUploadMessage.Visible = true;
                }
                else
                {
                    string eBookPath = ConfigurationManager.AppSettings["EBookPath"];
                    string eBookFileName = Guid.NewGuid().ToString() + strExtension;

                    string SaveLocation = Server.MapPath(eBookPath + eBookFileName);

                    try
                    {
                        // save the ebook to the server
                        this.UploadFile_EBook.PostedFile.SaveAs(SaveLocation);

                        // update the ebook to the database
                        BusinessServices.Course objCourse = new BusinessServices.Course();
                        // delete the previous ebook if exist
                        objCourse.DeleteEbook(int.Parse(cboCourses.SelectedValue));
                        // then add the new one
                        objCourse.AddEbook(int.Parse(cboCourses.SelectedValue), FileName, eBookFileName);

                        this.lblUploadMessage.Visible = false;

                        // populate with the ebook details
                        SetEbookDetails();
                    }
                    catch (Exception ex)
                    {
                        // lblMessage.UploadError
                        this.lblUploadMessage.Text = ResourceManager.GetString("lblMessage.UploadError") + " " + FileName;
                        this.lblUploadMessage.CssClass = "WarningMessage";
                        this.lblUploadMessage.Visible = true;
                    }
                }
            }
            else
            {
                this.lblUploadMessage.Visible = false;
            }
        } // btnSave_Click


        protected void lnkDeleteEBook_Click(object sender, System.EventArgs e)
        {
            // delete the ebook from this course
            BusinessServices.Course objCourse = new BusinessServices.Course();
            objCourse.DeleteEbook(int.Parse(cboCourses.SelectedValue));

            // refresh the page
            Page.Response.Redirect(HttpContext.Current.Request.Url.ToString(), true);
        }


        protected void lnkNotifyUsers_Click(object sender, System.EventArgs e)
        {
            // Email to the target user
            string strEmailToName = "";
            string strEmailToEmail = "";
            string strEmailFromName = "";
            string strEmailFromEmail = "";
            string strEmailBody = "";
            string strEmailSubject = "";
            string strUsers = "";

            BusinessServices.Email objEmail = new BusinessServices.Email();
            BusinessServices.User objUser = new BusinessServices.User();
            BusinessServices.Course objCourse = new BusinessServices.Course();

            OrganisationConfig objOrgConfig = new OrganisationConfig();
            strEmailSubject = objOrgConfig.GetOne(UserContext.UserData.OrgID, "Ebook_NewUpdate_Subject");
            strEmailBody = objOrgConfig.GetOne(UserContext.UserData.OrgID, "Ebook_NewUpdate_Body");

            // Get the application conffiguration details
            BusinessServices.AppConfig objAppConfig = new BusinessServices.AppConfig();
            DataTable dtbAppConfig = objAppConfig.GetList();

            DataTable dtbEbook = objCourse.GetEbook(int.Parse(cboCourses.SelectedValue), UserContext.UserData.OrgID);

            // if ebook exists
            if (dtbEbook.Rows.Count > 0)
            {
                int currentEbookID = 0;
                Int32.TryParse(dtbEbook.Rows[0]["ebookid"].ToString(), out currentEbookID);

                // Get the course name and replace
                string strCourseName = "";
                DataTable dtbCourse = objCourse.GetCourse(int.Parse(cboCourses.SelectedValue), UserContext.UserData.OrgID);
                if(dtbCourse.Rows.Count > 0) {
                    strCourseName = dtbCourse.Rows[0]["Name"].ToString();
                }
                strEmailSubject = strEmailSubject.Replace("%COURSE_NAME%", strCourseName);
                

                // iterate over each users
                DataTable dtbEbookUsers = objCourse.GetEbookUsersToNotify(currentEbookID, int.Parse(cboCourses.SelectedValue));
                foreach (DataRow drwEmailAddress in dtbEbookUsers.Rows)
                {
                    // get the userID
                    int userID = 0;
                    Int32.TryParse(drwEmailAddress["userid"].ToString(), out userID);

                    // get the organisationID
                    int organisationID = 0;
                    Int32.TryParse(drwEmailAddress["organisationID"].ToString(), out organisationID);

                    strEmailToEmail = drwEmailAddress["email"].ToString();
                    strEmailToName = drwEmailAddress["firstname"].ToString() + " " + drwEmailAddress["lastname"].ToString();

                    objEmail.SetEmailBody(strEmailBody, userID, strCourseName, "", "", "", "", "", "", "");
                    strEmailSubject = objEmail.emailHeaderSub(strEmailSubject);
                    // send email to the users
                    objEmail.SendEmail(strEmailToEmail, strEmailToName, strEmailFromEmail, strEmailFromName, null, null, strEmailSubject, ApplicationSettings.MailServer, UserContext.UserData.OrgID, userID);
                    strUsers += "<BR>" + strEmailToName + "<BR>&nbsp;" + drwEmailAddress["organisationname"].ToString();

                    // update the date notified in tblUserEbook
                    int userebookid = 0;
                    Int32.TryParse(drwEmailAddress["userebookid"].ToString(), out userebookid);

                    objUser.UpdateEbookNotify(userebookid);
                }

                string strEmailUserCopyBody = String.Format(ResourceManager.GetString("EmailReceiptBody"), Utilities.ApplicationSettings.AppName, DateTime.Today.ToShortDateString(), strEmailBody, strUsers).Replace(@"\n", Environment.NewLine);
                string strEmailUserCopySubject = ResourceManager.GetString("EbookEmailReceipt") + " " + strEmailSubject;

                objEmail.setUserCopyEmailBody(strEmailUserCopyBody);
                // send receipt email
                objEmail.SendEmail(strEmailFromEmail, strEmailFromName, strEmailFromEmail, strEmailFromName, null, null, strEmailUserCopySubject, ApplicationSettings.MailServer, UserContext.UserData.OrgID, UserContext.UserID);
            }

        }

        /// <summary>
        /// Event handler for the Cancel button
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void lnkReturnToAdminHomepage_Click(object sender, System.EventArgs e)
        {
            // Return to the calling page - the Default page as the current user is a 
            // SALT Administrator
            Response.Redirect("/Default.aspx");

        } // lnkReturnToAdminHomepage_Click

        /// <summary>
        /// Event handler for an Item link in the Modules datagrid
        /// </summary>
        /// <example>MoveUp / MoveDown / New action</example>
        /// <param name="source"></param>
        /// <param name="e"></param>
        private void grdModules_ItemCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
        {
            // Process the MoveUp or MoveDown command
            Course objCourse = new Course();
            int intModuleID = (int) this.grdModules.DataKeys[e.Item.ItemIndex];

            // Determine which link was clicked
            switch (e.CommandName)
            {
                case "MoveUp":
                    if (intModuleID == 0)
                    {
                        // Redirect to the module detail page supplying the parent course id
                        Response.Redirect("/ContentAdministration/Modules/ModuleDetails.aspx?CourseID=" + cboCourses.SelectedValue.ToString());
                    }
                    else
                    {
                        // Move the current module up one position in the module list
                        objCourse.DecrementModuleSequence(intModuleID, UserContext.UserID, UserContext.UserData.OrgID);
                    }
                    break;

                case "MoveDown":
                    // Move the current module down one position in the module list
                    objCourse.IncrementModuleSequence(intModuleID, UserContext.UserID, UserContext.UserData.OrgID);
                    break;
            }

            // Refresh the list of modules
            SetCourseModules();

        } // grdModules_ItemCommand

        /// <summary>
        /// Event handler for a row being added to the datagrid
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void grdModules_ItemDataBound(object sender, System.Web.UI.WebControls.DataGridItemEventArgs e)
        {
            LinkButton lnkUpdateButton; // Link button to alter the properties of

            // If the ItemIndex is less than zero then exit
            if (e.Item.ItemIndex < 0)
            {
                return;
            }

            // Retrieve the total number of modules in the course
            int intTotalModules = ((DataTable) ((DataGrid) sender).DataSource).Rows.Count;

            switch (e.Item.ItemIndex)
            {
                case 0:
                    // First row in the datagrid - set the MoveUp button caption to Add
//                    lnkUpdateButton = (LinkButton) e.Item.Cells[2].Controls[0];
///                    lnkUpdateButton.Text = ResourceManager.GetString("lnkUpdateButton.Add");//"Add New Module";
//                    e.Item.Cells[2].Controls.Add(lnkUpdateButton);

                    // Set the MoveDown button caption invisible
                    lnkUpdateButton = (LinkButton) e.Item.Cells[3].Controls[0];
                    lnkUpdateButton.Visible = false;

                    lnkUpdateButton = (LinkButton)e.Item.Cells[2].Controls[0];
                    lnkUpdateButton.Text = ResourceManager.GetString("lnkUpdateButton.Add");

                    break;

                case 1:
                    // First module in the datagrid - hide its MoveUp button
                    lnkUpdateButton = (LinkButton) e.Item.Cells[2].Controls[0];
                    lnkUpdateButton.Visible = false;

					lnkUpdateButton = (LinkButton) e.Item.Cells[3].Controls[0];
					lnkUpdateButton.Text = ResourceManager.GetString("btnMoveDown");
                    break;

				default:
					lnkUpdateButton = (LinkButton) e.Item.Cells[2].Controls[0];
					lnkUpdateButton.Text = ResourceManager.GetString("btnMoveUp");
					lnkUpdateButton = (LinkButton) e.Item.Cells[3].Controls[0];
					lnkUpdateButton.Text = ResourceManager.GetString("btnMoveDown");
					break;
            }

            // Check if it is the last row in the datagrid
            if ( (intTotalModules > 0) && (e.Item.ItemIndex == intTotalModules - 1) )
            {
                lnkUpdateButton = (LinkButton) e.Item.Cells[3].Controls[0];
                lnkUpdateButton.Visible = false;
				lnkUpdateButton.Text = ResourceManager.GetString("btnMoveDown");
            }

        } // grdModules_ItemDataBound

        # endregion

        #region Private Methods

        /// <summary>
        /// Set the initial page state
        /// </summary>
        private void SetPageState()
        {
            int intCourseID;                // ID of the course to automatically display (from AddCourse.aspx)
            string strSelectedCourse = "";  // Used to temporarily store the currently selected course whilst list is refreshed

            // Store the currently selected course to redisplay its details once the course 
            // list has been refreshed
            if (cboCourses.SelectedValue.Length != 0)
            {
                strSelectedCourse = cboCourses.SelectedValue;
            }

            // (Re)Load the list of courses and bind to the course list combo box
            BusinessServices.Course objCourse = new BusinessServices.Course();
            DataTable dtbCourses = objCourse.GetCourseList(UserContext.UserData.OrgID);
            if (dtbCourses.Rows.Count>0)
            {
                cboCourses.DataSource = dtbCourses;

                cboCourses.DataValueField = "CourseID";
                cboCourses.DataTextField= "Name";
                cboCourses.DataBind();

                // If a course was previously selected then display its details, otherwise if a 
                // course ID was supplied via the query string then display its details
                if (strSelectedCourse.Length != 0)
                {
                    cboCourses.SelectedValue = strSelectedCourse;
                }
                else if (Request.QueryString["CourseID"] != null)
                {
                    intCourseID = int.Parse(Request.QueryString["CourseID"]);
                    if (intCourseID > 0)
                    {
                        cboCourses.SelectedValue = intCourseID.ToString();
                    }
                }

                // If there's at least 1 course, set the details for the selected course
                if (cboCourses.Items.Count > 0)
                {
                    SetCourseDetails();
                }
            }
            else
            {
                this.plhMainScreen.Visible=false;
                this.lblNoCourses.Visible=true;
            }

        } // SetPageState


        /// <summary>
        /// Display's the currently selected course's details on the page
        /// </summary>
        private void SetCourseDetails()
        {
            // Retrieve the selected course's details
            BusinessServices.Course objCourse = new BusinessServices.Course();
            DataTable dtbCourse = objCourse.GetCourse(int.Parse(cboCourses.SelectedValue), UserContext.UserData.OrgID);

            // Populate the UI controls with the course's details
            txtName.Text = dtbCourse.Rows[0]["Name"].ToString();
            txtNotes.Text = dtbCourse.Rows[0]["Notes"].ToString();
            if (Convert.ToBoolean(dtbCourse.Rows[0]["Active"]))
            {
                this.cboStatus.SelectedIndex = 0;
            }
            else
            {
                this.cboStatus.SelectedIndex = 1;
            }

            // populate the ebook details
            SetEbookDetails();

            // Populate the datagrid of modules for the current course
            SetCourseModules();

        } // SetCourseDetails


        private void SetEbookDetails()
        {
            BusinessServices.Course objCourse = new BusinessServices.Course();
            DataTable dtbEbook = objCourse.GetEbook(int.Parse(cboCourses.SelectedValue), UserContext.UserData.OrgID);
            if (dtbEbook.Rows.Count > 0)
            {
                this.hypFile.Text = dtbEbook.Rows[0]["EbookFileName"].ToString();
                this.hypFile.NavigateUrl = "/General/eBook/EBookDownload.ashx?CourseID=" + int.Parse(cboCourses.SelectedValue);
                this.hypFile.Visible = true;
                this.lblEBookDateUploaded.Text = ResourceManager.GetString("lblEBookDateUploaded") + " " + dtbEbook.Rows[0]["DateCreated"].ToString();
                this.lblEBookDateUploaded.Visible = true;
                this.lblNoUploadedFile.Visible = false;
                this.lnkDeleteEBook.Visible = true;
                this.chkNotifyUsers.Visible = true;
            }
            else
            {
                // Populate the ebook details with no file found
                this.lblNoUploadedFile.Text = ResourceManager.GetString("lblMessage.NoFile");
                this.lblNoUploadedFile.Visible = true;
                this.lblEBookDateUploaded.Visible = false;
                this.hypFile.Visible = false;
                this.lnkDeleteEBook.Visible = false;
                this.chkNotifyUsers.Visible = false;
            }

        }


        /// <summary>
        /// Display's the currently selected course's list of modules on the page
        /// </summary>
        private void SetCourseModules()
        {
            DataTable dtbModules;

            // Get the list of modules for the current course
            BusinessServices.Module objModule = new BusinessServices.Module();
            dtbModules = objModule.GetModuleListByCourse(int.Parse(cboCourses.SelectedValue), UserContext.UserData.OrgID);

            //Add a new row to the table
            DataRow drNew = dtbModules.NewRow();
			
            // Set the initial values for the new row
            drNew["ModuleID"] = 0;
            drNew["Name"] = "";

            // Add the row to the start of the DataTable
            dtbModules.Rows.InsertAt(drNew, 0);

            // Set selected properties on the datagrid
            grdModules.DataSource = dtbModules;
            grdModules.DataKeyField = "ModuleID";
            grdModules.PageSize = (dtbModules.Rows.Count > 1) ? dtbModules.Rows.Count : 1;

            // Bind the data table to the data grid
            grdModules.DataBind();
        } // SetCourseModules

        /// <summary>
        /// Save the current course's details to the database
        /// </summary>
        private void SaveCourseDetails()
        {
            string strName;
            string strNotes;
            bool blnActive;
            BusinessServices.Course objCourse;
			    
            // Retreive the course details from the UI
            strName = this.txtName.Text;
            strNotes = this.txtNotes.Text;

            // The length of the course notes must be validated seperately because
            // the text area control doesnt have a maximum length.
            if (strNotes.Length>1000)
            {
                this.lblMessage.Text = ResourceManager.GetString("lblMessage.1000");//"The course notes may contain no more than 1000 characters.";
                this.lblMessage.CssClass = "WarningMessage";
                return;
            }

            blnActive = (this.cboStatus.SelectedIndex==0);

            // Use a Course object to update the course details to the database
            objCourse = new BusinessServices.Course();	
            try
            {
                objCourse.Update(int.Parse(cboCourses.SelectedValue), strName, strNotes, blnActive, UserContext.UserID);
                this.lblMessage.Text = ResourceManager.GetString("lblMessage.Saved");//"The course details were saved successfully";
                this.lblMessage.CssClass = "SuccessMessage";
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

            // Refresh the page
            SetPageState();

        } // SaveCourseDetails
        # endregion

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

			grdModules.Columns[1].HeaderText = ResourceManager.GetString("cmnName" );
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
            this.grdModules.ItemCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.grdModules_ItemCommand);
            this.grdModules.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(this.grdModules_ItemDataBound);

        }
		#endregion
	}
}
