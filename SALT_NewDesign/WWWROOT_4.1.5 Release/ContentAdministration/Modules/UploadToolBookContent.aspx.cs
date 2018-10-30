using System;
using System.Configuration;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Security.Permissions;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.IO;

using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Utilities;
using Bdw.Application.Salt.Web.Utilities;
using Localization;
using Bdw.Application.Salt.Data;
using Ionic.Zip;

namespace Bdw.Application.Salt.Web.ContentAdministration.Modules
{
	/// <summary>
	/// Summary description for UploadToolBookContent.
	/// </summary>
	public partial class UploadToolBookContent : System.Web.UI.Page
	{
        #region Protected Variables

        /// <summary>
        /// Required field validator for name
        /// </summary>
        protected System.Web.UI.WebControls.RequiredFieldValidator rvldName;

        /// <summary>
        /// Textbox for location
        /// </summary>
        protected System.Web.UI.WebControls.TextBox txtLocation;

        /// <summary>
        /// Label for status and error messages
        /// </summary>
        protected System.Web.UI.WebControls.Label lblMessage;

        /// <summary>
        /// Button to upload content
        /// </summary>
        protected System.Web.UI.WebControls.Button btnUpload;

        /// <summary>
        /// Label for page title
        /// </summary>
        protected System.Web.UI.WebControls.Label lblPageTitle;

        /// <summary>
        /// Link back to module details page.
        /// </summary>
        protected System.Web.UI.WebControls.LinkButton lnkReturnToModuleDetails;

        /// <summary>
        /// Label for directory hint
        /// </summary>
        protected System.Web.UI.WebControls.Label lblHint;

        /// <summary>
        /// Label for directory hint example
        /// </summary>
        protected System.Web.UI.WebControls.Label lblHintExample;

        /// <summary>
        /// Checkbox to suppress content expiration
        /// </summary>
        protected System.Web.UI.WebControls.CheckBox chkSuppressExpire;
        #endregion

        #region Private Variables

        /// <summary>
        /// Folder where toolbook content is kept
        /// </summary>
        private const string m_strToolbookLaunchFolder = "ie4";

        /// <summary>
        /// Toolbook file name
        /// </summary>
        private const string m_strToolbookLaunchFile = "index.html";

        /// <summary>
        /// Filename of quick fact sheet
        /// </summary>
        private const string m_strQuickFactSheetFile = "qfs.html";
        #endregion    

        #region Private Event Handlers
		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
            string strPath;
            // Clear any message
            this.lblMessage.Text = "";
            strPath = Server.MapPath(ConfigurationSettings.AppSettings["ImportToolBookSourceDirectory"]);
            this.lblHintExample.Text = strPath;
            this.lblHint.Text = strPath;
            //business requirement 5
			btnUpload.Attributes.Add("onclick","javascript:return confirm('" + ResourceManager.GetString("btnUploadMsg") + "');");
            if (!Page.IsPostBack)
            {
                DataSet SCOs;

                try
                {
                    using (StoredProcedure sp = new StoredProcedure("prcSCORMpublishedcontent"))
                    {

                        SCOs = sp.ExecuteDataSet();

                    }
                }
                catch (Exception)
                {
                    throw;
                }
                lstUploads.DataSource = SCOs;
                lstUploads.DataBind();
            }
        }



        protected void lstUploads_SelectedIndexChanged(object sender, System.EventArgs e)
        {
           txtLocation.Text = lstUploads.SelectedValue;
            // Check that the supplied path exists
           String LaunchPoint = txtLocation.Text;
           LaunchPoint = LaunchPoint.Substring(0, LaunchPoint.IndexOf("?"));
           FileInfo LessonLaunchPoint = new FileInfo(Server.MapPath("/General/") + "Scorm/Publishing/" + LaunchPoint);
           DirectoryInfo dirNewContentSource = new DirectoryInfo(LessonLaunchPoint.Directory.FullName);
           if (!dirNewContentSource.Exists) this.lblMessage.Text = LessonLaunchPoint.Directory.FullName + " NO LONGER EXISTS"; else this.lblMessage.Text = "";
           this.lblMessage.ForeColor = System.Drawing.Color.IndianRed;
        }

        protected void radSCORM_checkedChanged(object sender, System.EventArgs e)
        {
            if (radSCORM.Checked)
            {
                //txtLocation.Text = "SCORM";
                //txtLocation.Height = 0;
                lstUploads.Height = 200;
                //txtLocation.Width = 0;
                lstUploads.Width = 450;
                inputFile.Visible = false;
            }
            else if (radAdaptive.Checked)
            {
                txtLocation.Height = 0;
                txtLocation.Width = 0;
                lstUploads.Height = 0;
                lstUploads.Width = 0;
                inputFile.Visible = true;
                
            }
            else
            {
                // txtLocation.Text = "";
                // txtLocation.Height = 30;
                lstUploads.Height = 0;
                // txtLocation.Width = 300;
                lstUploads.Width = 0;
                inputFile.Visible = false;
            }

        }



		/// <summary>
		/// Event Handler for the Upload button
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
        protected void btnUpload_Click(object sender, System.EventArgs e)
        {
            UploadContent();
        }

		/// <summary>
		/// Event handler for the Cancel button
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
        protected void lnkReturnToModuleDetails_Click(object sender, System.EventArgs e)
        {
            // Redirect to the Module Details page
            Response.Redirect("ModuleDetails.aspx?ModuleID=" + Request.QueryString["ModuleID"]);

        } // lnkReturnToModuleDetails_Click
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

        #region Private Methods


        private void CheckForFiles()
        {
            if (inputFile.PostedFile.FileName.Length == 0)
            {
                throw new Exception(ResourceManager.GetString("Error.1"));
            }
            if ((inputFile.PostedFile.FileName.ToLower().IndexOf(".zip") == -1))
            {

                throw new Exception(ResourceManager.GetString("Error.2"));

            }

        }

        private Boolean IsZIP()
        {
            return (inputFile.PostedFile.FileName.ToUpper().EndsWith("ZIP"));
        }

        private void UploadContent()
        {
            //if (radSCORM.Checked) txtLocation.Text = lstUploads.SelectedValue; 
            if (txtLocation.Text.ToString().Trim() != "")
            {
                if (txtLocation.Text.Contains(".html"))
                {
                    UploadScormContent();
                }
                else
                {
                    UploadTBkContent();
                }
            }
            else
            {
                try
                {
                    CheckForFiles();
                }
                catch (Exception ex)
                {
                    //lblUploadMessage.Text = ex.Message;
                    //lblUploadMessage.CssClass = "FeedbackMessage";
                    return;
                }
                if (IsZIP())
                {
                    UploadAdaptiveContent();
                }
            }
        }

        private void UploadAdaptiveContent()
        {
            int intModuleID;					// The current Module ID
            int intCourseID;					// The current Course ID
            Module objModule;					// Used to access the Module Details
            DataTable dtbModule;				// Datatable containing Module Details
            DirectoryInfo dirNewContentSource;	// Directory info about the source directory
            DirectoryInfo dirNewContentDestination;	// Directory info about the destination directory 
            DirectoryInfo dirNewContentDestination2;	// Directory info about the destination directory 
            DirectoryInfo dirOldContentDestination;	// Directory info about the destination directory 


            string strContentType;				// The content type, Quiz or a Lesson
            string strUploadType;				// The Upload Type, a correction or an update
            string strNewContentDestination;	// 
            string strOldContentDestination;	// 
            string strFilename = "";
            string strQFS = "";
            // Retrieve the Module ID from the query string and Course ID from the database
            intModuleID = int.Parse(Request.QueryString["ModuleID"].ToString());

            // Get module details
            objModule = new Module();
            dtbModule = objModule.GetModule(intModuleID, UserContext.UserData.OrgID);
            intCourseID = int.Parse(dtbModule.Rows[0]["CourseID"].ToString());
            FileInfo zip = new FileInfo(inputFile.PostedFile.FileName);
            strFilename = inputFile.PostedFile.FileName.ToString();

            string strContentDestinationNew = ConfigurationSettings.AppSettings["ImportSCORMDestinationDirectory"];// +"/AdaptiveFiles";
            DirectoryInfo dirContentDestination = new DirectoryInfo(WebTool.MapToPhysicalPath(strContentDestinationNew));

            strNewContentDestination = strContentDestinationNew + "/" + intCourseID + "/" + intModuleID.ToString();
            if (!System.IO.Directory.Exists(dirContentDestination + "\\" + intCourseID + "\\" + intModuleID))
            {

                System.IO.Directory.CreateDirectory(dirContentDestination + "\\" + intCourseID + "\\" + intModuleID);
                string strContentDestination = dirContentDestination + "\\" + intCourseID + "\\" + intModuleID.ToString();
                using (ZipFile zipRead = ZipFile.Read(inputFile.PostedFile.InputStream))
                {
                    zipRead.ExtractAll(strContentDestination, ExtractExistingFileAction.OverwriteSilently);
                }

            }     
            else
            {
                string strContentDestination = dirContentDestination + "/" + intCourseID + "/" + intModuleID.ToString();
                using (ZipFile zipRead = ZipFile.Read(inputFile.PostedFile.InputStream))
                {
                    zipRead.ExtractAll(strContentDestination, ExtractExistingFileAction.OverwriteSilently);
                }
               
            }
            try
            {
                using (StoredProcedure sp = new StoredProcedure("prcSCORMimportAdaptive",
                    //								  StoredProcedure.CreateInputParam("@intLessonID", SqlDbType.Int, intLessonID),
                          StoredProcedure.CreateInputParam("@intModuleID", SqlDbType.Int, intModuleID),
                    //								  StoredProcedure.CreateInputParam("@strToolbookID", SqlDbType.VarChar,50, strToolbookID),
                          StoredProcedure.CreateInputParam("@strToolLocation", SqlDbType.VarChar, 100, strNewContentDestination + "/imsmanifest.xml"),
                          //StoredProcedure.CreateInputParam("@strQFSLocation", SqlDbType.VarChar, 100, strNewContentDestination + "/" + strQFS),
                    //                                  StoredProcedure.CreateInputParam("@strToolLocation", SqlDbType.VarChar, 100, dirNewContentDestination.FullName + "/" + strFilename),
                          //StoredProcedure.CreateInputParam("@DatePublished", SqlDbType.DateTime, dirNewContentSource.LastWriteTime),
                          StoredProcedure.CreateInputParam("@intUserID", SqlDbType.VarChar, 1000, UserContext.UserID)
                          //StoredProcedure.CreateInputParam("@SCORMsource", SqlDbType.VarChar, 100, LaunchPoint)
)
                          )
                {
                    sp.ExecuteNonQuery();
                }
            }
            catch (Exception)
            {
                throw;
            }


        }
		/// <summary>
		/// This method handles the uploading of data from the xml file to the sql server database
		/// </summary>
        private void UploadTBkContent()
        {
            int intModuleID;					// The current Module ID
            int intCourseID;					// The current Course ID
            Module objModule;					// Used to access the Module Details
            DataTable dtbModule;				// Datatable containing Module Details
            DirectoryInfo dirNewContentSource;	// Directory info about the source directory
            DirectoryInfo dirNewContentDestination;	// Directory info about the destination directory 
            ImportToolbook objImport;			// Used to perform the actual import
            DataSet dstImportResults;			// Dataset containing the import results
            string strContentType;				// The content type, Quiz or a Lesson
            string strUploadType;				// The Upload Type, a correction or an update
            string strNewContentDestination;	// 

            // Retrieve the Module ID from the query string and Course ID from the database
            intModuleID = int.Parse(Request.QueryString["ModuleID"].ToString());

			// Get module details
			objModule = new Module();
            dtbModule = objModule.GetModule(intModuleID, UserContext.UserData.OrgID);
            intCourseID = int.Parse(dtbModule.Rows[0]["CourseID"].ToString());

            // Verify that the ASP.NET user has the necessary permission to the content 
            // destination folder before beginning content upload
            string strContentDestinationTest = ConfigurationSettings.AppSettings["ImportToolBookDestinationDirectory"] + "/Test";
            DirectoryInfo dirContentDestinationTest = new DirectoryInfo(WebTool.MapToPhysicalPath(strContentDestinationTest));
            try
            {
                // Try to create a test folder, will throw an IOException if insufficient permissions
                dirContentDestinationTest.Create();
                // Tidy up
                dirContentDestinationTest.Delete(true);
            }
            catch (Exception ex)
            {
                this.lblMessage.Text = ex.Message;
                this.lblMessage.CssClass = "WarningMessage";
            }

            try
            {
                // Create a directory info object for the specified path
                dirNewContentSource = new DirectoryInfo(txtLocation.Text);
            }
            catch (Exception ex)
            {
                this.lblMessage.Text = ex.Message;
                this.lblMessage.CssClass = "WarningMessage";
                return;
            }

            // Check that the supplied path exists
            if (dirNewContentSource.Exists)
            {
                try
                {
                    CheckForContent();
                }
                catch (Exception ex)
                {
                    this.lblMessage.Text = ex.Message;
                    this.lblMessage.CssClass = "WarningMessage";
                    return;
                }


                // Create an ImportToolbook object to import the content in the XML file
                string strXMLFile = dirNewContentSource.FullName + @"\" + ConfigurationSettings.AppSettings["ImportToolBookXMLFileName"].ToString();
                string strXSDFile =  WebTool.MapToPhysicalPath(ConfigurationSettings.AppSettings["ToolBookXSD"]);
                objImport = new ImportToolbook(strXMLFile, strXSDFile, ConfigurationSettings.AppSettings["XMLNamespace"]);
                objImport.ModuleID = intModuleID;
				objImport.CourseID = intCourseID;
				objImport.UserID = UserContext.UserID;

                // Preview the XML to determine the content and upload type
                try
                {
                    dstImportResults = objImport.Preview();
                }
                catch(Exception ex)
                {
                    this.lblMessage.Text = ResourceManager.GetString("lblMessage1") + Environment.NewLine + ex.Message;
                    this.lblMessage.CssClass = "WarningMessage";
                    return;
                }
                switch (dstImportResults.Tables.Count)
                {
                    case 2:
                        // XML file loaded successfully
                        strUploadType = dstImportResults.Tables[0].Rows[0].ItemArray[0].ToString();
                        strContentType = dstImportResults.Tables[0].Rows[0].ItemArray[1].ToString();
						break;

                    case 1:
                        // Error condition - could be that a correction has been rejected
                        this.lblMessage.Text = ResourceManager.GetString("lblMessage2") + " " + dstImportResults.Tables[0].Rows[0].ItemArray[0].ToString();
                        this.lblMessage.CssClass = "WarningMessage";
                        return;

                    default:
                        // Unknown error condition
                        this.lblMessage.Text = ResourceManager.GetString("lblMessage3");
                        this.lblMessage.CssClass = "WarningMessage";
                        return;
                }

				// Construct the path on the web server where the Toolbook files will be placed
				strNewContentDestination = ConfigurationSettings.AppSettings["ImportToolBookDestinationDirectory"].ToString();
				strNewContentDestination += "/" + intCourseID.ToString() + "/" + intModuleID.ToString();
				strNewContentDestination += "/" + strContentType;


				// The import procedure just needs to the logical path, not the physical
                if (radInfoPath.Checked)
                {
                    objImport.ToolbookLocation  = strNewContentDestination + @"/default.aspx";
                }
                if (radToolbook.Checked)
                {
                    objImport.ToolbookLocation  = strNewContentDestination + @"/ie4/index.html";
                }

                
				strNewContentDestination = WebTool.MapToPhysicalPath(strNewContentDestination);

//check for qfs
                // If the upload is a lesson, verify that the Quick facts sheet is present
//                if ( (strContentType.ToUpper() == "LESSON") && (dirNewContentSource.GetFiles(m_strQuickFactSheetFile).Length == 0) )
//                {
//                    // The Quick facts sheet does not exist
//                    this.lblMessage.Text += "Error uploading new content: '" + dirNewContentSource.FullName + @"\" + m_strQuickFactSheetFile + "' does not exist";
//                    this.lblMessage.CssClass = "WarningMessage";
//                    return;
//                }

                // Load the content into the database
                try
                {
                    dstImportResults = objImport.Load();
                }
                catch (Exception ex)
                {
                    ErrorHandler.ErrorLog el = new ErrorHandler.ErrorLog(ex, ErrorLevel.High, "UploadToolBookContent.aspx.cs", "UploadContent", ex.Message);
                    this.lblMessage.Text = ResourceManager.GetString("lblMessage4");//"Unknown error uploading new content.";
                    this.lblMessage.CssClass = "WarningMessage";
                    return;
                }
                if (dstImportResults.Tables.Count != 2) 
                {
                    // Error condition
                    this.lblMessage.Text = ResourceManager.GetString("lblMessage5");//"Error uploading new content.";
                    this.lblMessage.CssClass = "WarningMessage";
                    return;
                }


                // Ensure the destination directory on the web server exists
                dirNewContentDestination = new DirectoryInfo(strNewContentDestination);
                if (dirNewContentDestination.Exists)
                {
                    // Delete the contents of the current content destination folder
                    try
                    {
                        dirNewContentDestination.Delete(true);
                    }
                    catch (Exception ex)
                    {
                        this.lblMessage.Text = ex.Message;
                        this.lblMessage.CssClass = "WarningMessage";
                        return;
                    }
                }

                // Copy the source Toolbook files into the destination directory
                try
                {
                    // Create the content destination folder
                    dirNewContentDestination.Create();

                    // Copy the Toolbook files to the required destination on the web server
                    WebTool.CopyDirectory(dirNewContentSource.FullName, dirNewContentDestination.FullName);
                }
                catch (Exception ex)
                {
                    this.lblMessage.Text = ex.Message;
                    this.lblMessage.CssClass = "WarningMessage";
                    new ErrorHandler.ErrorLog(ex, Bdw.Application.Salt.Data.ErrorLevel.High, "UploadToolbookContent.aspx", "UploadContent", "dirNewContentDestination.Create()");
                    return;
                }


                // Display a success message
				switch (strContentType)
				{
					case "quiz": 
						this.lblMessage.Text = ResourceManager.GetString("QuizUpload");
						break;

					case "lesson":
						this.lblMessage.Text = ResourceManager.GetString("LessonUpload");
						break;
				}
                this.lblMessage.CssClass = "SuccessMessage";
            }
            else
            {
                this.lblMessage.Text = String.Format(ResourceManager.GetString("lblMessage5"), Request.ServerVariables["SERVER_NAME"]);//"The specified physical path does not exist on " + Request.ServerVariables["SERVER_NAME"];
                this.lblMessage.CssClass = "WarningMessage";
                return;
            }
        } // UploadToolBokkContent


        /// <summary>
        /// This method handles the uploading of data from the xml file to the sql server database
        /// </summary>
        private void UploadScormContent()
        {
            int intModuleID;					// The current Module ID
            int intCourseID;					// The current Course ID
            Module objModule;					// Used to access the Module Details
            DataTable dtbModule;				// Datatable containing Module Details
            DirectoryInfo dirNewContentSource;	// Directory info about the source directory
            DirectoryInfo dirNewContentDestination;	// Directory info about the destination directory 
            DirectoryInfo dirNewContentDestination2;	// Directory info about the destination directory 
            DirectoryInfo dirOldContentDestination;	// Directory info about the destination directory 


            string strContentType;				// The content type, Quiz or a Lesson
            string strUploadType;				// The Upload Type, a correction or an update
            string strNewContentDestination;	// 
            string strOldContentDestination;	// 
            string strFilename = ""; 
            string strQFS = "";
            // Retrieve the Module ID from the query string and Course ID from the database
            intModuleID = int.Parse(Request.QueryString["ModuleID"].ToString());

            // Get module details
            objModule = new Module();
            dtbModule = objModule.GetModule(intModuleID, UserContext.UserData.OrgID);
            intCourseID = int.Parse(dtbModule.Rows[0]["CourseID"].ToString());

            // Verify that the ASP.NET user has the necessary permission to the content 
            // destination folder before beginning content upload
            string strContentDestinationTest = ConfigurationSettings.AppSettings["ImportSCORMDestinationDirectory"] + "/Test";
            DirectoryInfo dirContentDestinationTest = new DirectoryInfo(WebTool.MapToPhysicalPath(strContentDestinationTest));
            try
            {
                // Try to create a test folder, will throw an IOException if insufficient permissions
                dirContentDestinationTest.Create();
                // Tidy up
                dirContentDestinationTest.Delete(true);
            }
            catch (Exception ex)
            {
                this.lblMessage.Text = ex.Message;
                this.lblMessage.CssClass = "WarningMessage";
            }
            String LaunchPoint;
           // LaunchPoint = txtLocation.Text;
            //Code by joseph
            //if (LaunchPoint.Contains("launchpage.html"))
            //{
            //    string strContentDestinationNew = ConfigurationSettings.AppSettings["ImportSCORMDestinationDirectory"];// +"/AdaptiveFiles";
            //    DirectoryInfo dirContentDestination = new DirectoryInfo(WebTool.MapToPhysicalPath(strContentDestinationNew));

            //    strNewContentDestination = strContentDestinationNew + "/" + intCourseID + "/" + intModuleID.ToString();
            //    if (!System.IO.Directory.Exists(dirContentDestination + "\\" + intCourseID + "\\" + intModuleID))
            //    {

            //        System.IO.Directory.CreateDirectory(dirContentDestination + "\\" + intCourseID + "\\" + intModuleID);
            //        string strContentDestination = dirContentDestination + "\\" + intCourseID + "\\" + intModuleID.ToString();
            //       //
            //        System.IO.File.Copy(strContentDestination, strNewContentDestination, true);
            //    }
            //    else
            //    {
            //        string strContentDestination = dirContentDestination + "/" + intCourseID + "/" + intModuleID.ToString();
            //        //

            //    }
            //}
            //else
            //{
                //end
                try
                {
                    // Create a directory info object for the specified path
                    LaunchPoint = txtLocation.Text;
                    dirNewContentSource = dirContentDestinationTest;
                    if (LaunchPoint.Contains("launchpage.html"))
                    {
                        LaunchPoint = LaunchPoint.Split('/')[0].ToString();
                        FileInfo LessonLaunchPoint = new FileInfo(Server.MapPath("/General/") + "Scorm/Publishing/" + LaunchPoint);
                        strFilename = "launchpage.html";
                        dirNewContentSource = new DirectoryInfo(LessonLaunchPoint.Directory.FullName+"/"+ LaunchPoint.Split('/')[0].ToString());
                        LaunchPoint = txtLocation.Text;
                    }
                    else
                    {
                        LaunchPoint = LaunchPoint.Substring(0, LaunchPoint.IndexOf("?"));
                        FileInfo LessonLaunchPoint = new FileInfo(Server.MapPath("/General/") + "Scorm/Publishing/" + LaunchPoint);
                        strFilename = LessonLaunchPoint.Name;
                        dirNewContentSource = new DirectoryInfo(LessonLaunchPoint.Directory.FullName);
                        LaunchPoint = txtLocation.Text;
                    }
                    strQFS = LaunchPoint.Substring(LaunchPoint.IndexOf("?") + 5, LaunchPoint.Length - LaunchPoint.IndexOf("?") - 5);
                    LaunchPoint = LaunchPoint.Substring(0, LaunchPoint.IndexOf("?"));
                }
                catch (Exception ex)
                {
                    this.lblMessage.Text = ex.Message;
                    this.lblMessage.CssClass = "WarningMessage";
                    return;
                }

                // Check that the supplied path exists
                if (dirNewContentSource.Exists)
                {



                    // Construct the path on the web server where the new SCORM files will be placed
                    strNewContentDestination = ConfigurationSettings.AppSettings["ImportSCORMDestinationDirectory"].ToString();
                    strNewContentDestination += "/" + intCourseID.ToString() + "/" + intModuleID.ToString();
                    if (!LaunchPoint.Contains("launchpage.html"))
                    {
                        strNewContentDestination += "/" + "lesson";
                    }
                    // Construct the path on the web server where the OLD SCORM files will be moved to (if they exist)
                    strOldContentDestination = ConfigurationSettings.AppSettings["ImportSCORMDestinationDirectory"].ToString();
                    strOldContentDestination += "/Superseded/" + intCourseID.ToString() + "/" + intModuleID.ToString();

                    if (!LaunchPoint.Contains("launchpage.html"))
                    {
                        strOldContentDestination += "/" + "lesson";
                    } 
                    strOldContentDestination = WebTool.MapToPhysicalPath(strOldContentDestination);

                    //strNewContentDestination = txtLocation.Text;



                    //strNewContentDestination = WebTool.MapToPhysicalPath(strNewContentDestination);





                    // Ensure the destination directory on the web server exists
                    dirNewContentDestination2 = new DirectoryInfo(WebTool.MapToPhysicalPath(strNewContentDestination));
                    if (dirNewContentDestination2.Exists)
                    {
                        // Delete the contents of the current content destination folder
                        try
                        {
                            dirOldContentDestination = new DirectoryInfo(strOldContentDestination);
                            dirOldContentDestination.Create();
                            dirNewContentDestination2.MoveTo(strOldContentDestination + "/" + DateTime.Now.Ticks);

                        }
                        catch (Exception ex)
                        {
                            this.lblMessage.Text = ex.Message;
                            this.lblMessage.CssClass = "WarningMessage";
                            return;
                        }
                    }

                    dirNewContentDestination = new DirectoryInfo(WebTool.MapToPhysicalPath(strNewContentDestination));
                    // Copy the source Toolbook files into the destination directory
                    try
                    {
                        // Create the content destination folder
                        dirNewContentDestination.Create();

                        // Copy the Toolbook files to the required destination on the web server
                        WebTool.CopyDirectory(dirNewContentSource.FullName, dirNewContentDestination.FullName);
                    }
                    catch (Exception ex)
                    {
                        this.lblMessage.Text = ex.Message;
                        this.lblMessage.CssClass = "WarningMessage";
                        new ErrorHandler.ErrorLog(ex, Bdw.Application.Salt.Data.ErrorLevel.High, "UploadToolbookContent.aspx", "UploadContent", "dirNewContentDestination.Create()");
                        return;
                    }

                    try
                    {
                        string contentdest;
                        if(LaunchPoint.Contains("launchpage.html"))
                        {
                            contentdest= strNewContentDestination + "/shared/" + strFilename;
                        }
                        else{
                            contentdest= strNewContentDestination + "/" + strFilename;
                        }
                        using (StoredProcedure sp = new StoredProcedure("prcSCORMimport",
                            //								  StoredProcedure.CreateInputParam("@intLessonID", SqlDbType.Int, intLessonID),
                                  StoredProcedure.CreateInputParam("@intModuleID", SqlDbType.Int, intModuleID),
                            //								  StoredProcedure.CreateInputParam("@strToolbookID", SqlDbType.VarChar,50, strToolbookID),
                                 // StoredProcedure.CreateInputParam("@strToolLocation", SqlDbType.VarChar, 100, strNewContentDestination + "/" + strFilename),By Joseph
                                  StoredProcedure.CreateInputParam("@strToolLocation", SqlDbType.VarChar, 100,contentdest),
                                  StoredProcedure.CreateInputParam("@strQFSLocation", SqlDbType.VarChar, 100, strNewContentDestination + "/" + strQFS),
                            //                                  StoredProcedure.CreateInputParam("@strToolLocation", SqlDbType.VarChar, 100, dirNewContentDestination.FullName + "/" + strFilename),
                                  StoredProcedure.CreateInputParam("@DatePublished", SqlDbType.DateTime, dirNewContentSource.LastWriteTime),
                                  StoredProcedure.CreateInputParam("@intUserID", SqlDbType.VarChar, 1000, UserContext.UserID),
                                  StoredProcedure.CreateInputParam("@SCORMsource", SqlDbType.VarChar, 100, LaunchPoint)
)
                                  )
                        {
                            sp.ExecuteNonQuery();
                        }
                    }
                    catch (Exception)
                    {
                        throw;
                    }





                    // Display a success message
                    this.lblMessage.Text = ResourceManager.GetString("LessonUpload");

                    this.lblMessage.CssClass = "SuccessMessage";
                }
                else
                {
                    this.lblMessage.Text = String.Format(ResourceManager.GetString("lblMessage5"), Request.ServerVariables["SERVER_NAME"]);//"The specified physical path does not exist on " + Request.ServerVariables["SERVER_NAME"];
                    this.lblMessage.CssClass = "WarningMessage";
                    return;
                }
            //}
        } // UploadScormContent




        #endregion

        private void CheckForContent()
        {
            string strUploadPath = txtLocation.Text;

            #region Common Files

            // Check for the xml file that will be imported in to sql server
            string strXmlUploadFileName = strUploadPath +"\\"+ ConfigurationSettings.AppSettings["ImportToolBookXMLFileName"];
            if (!File.Exists(strXmlUploadFileName))
            {
                throw new FileNotFoundException(String.Format(ResourceManager.GetString("FileError1"), strXmlUploadFileName));
            } 

            #endregion

            #region Toolbook Specific Files
            if (radToolbook.Checked)
            {
                
                // Check for the ie4 or ie5 directory
                string strDirectoryName = strUploadPath + "\\" + m_strToolbookLaunchFolder;
                if (!Directory.Exists(strDirectoryName))
                {
                    throw new DirectoryNotFoundException(String.Format(ResourceManager.GetString("FileError2"), strDirectoryName));//"Cannot find directory:" + strDirectoryName);
                }
            }
            #endregion

            #region InfoPath Specific Files
            if (radInfoPath.Checked)
            {
                // Check for Control File
                if (!File.Exists(strUploadPath + "\\Control.xml"))
                {
                    throw new FileNotFoundException(ResourceManager.GetString("FileError3"));
                }

                // Check for Data File
                if (!File.Exists(strUploadPath + "\\Data.xml"))
                {
                    throw new FileNotFoundException(ResourceManager.GetString("FileError4"));
                }

                // Check for default File
                if (!File.Exists(strUploadPath + "\\default.aspx"))
                {
                    throw new FileNotFoundException(ResourceManager.GetString("FileError5"));
                }

                // Check for default File
                if (!File.Exists(strUploadPath + "\\InfoPathContent.xml"))
                {
                    throw new FileNotFoundException(ResourceManager.GetString("FileError6"));
                }
            }
            #endregion

        }

	}
}
