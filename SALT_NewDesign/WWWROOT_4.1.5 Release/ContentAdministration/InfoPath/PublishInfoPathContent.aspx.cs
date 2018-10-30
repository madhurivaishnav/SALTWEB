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
using System.IO;
using System.Xml;
using System.Xml.Serialization;

using Bdw.Application.Salt.InfoPath;
using Bdw.Application.Salt.Web.Utilities;
using Localization;
using Bdw.Application.Salt.Data;
namespace Bdw.Application.Salt.Web.ContentAdministration.InfoPath
{
    /// <summary>
    /// Summary description for PublishInfoPathContent.
    /// </summary>
    public partial class PublishInfoPathContent : System.Web.UI.Page
    {
        private const string cm_strDefault = "-- Default --";



        #region event handlers
        protected void Page_Load(object sender, System.EventArgs e)
        {
            if (!IsPostBack)
            {
                pagTitle.InnerText = ResourceManager.GetString("pagTitle");
                // Put user code to initialize the page here
            }
        }



        protected void btnPublishSCOs_Click(object sender, EventArgs e)
        {
            string Destination = lblGeneratePath.Text;
            lbxQFS.SelectedIndex = lstSCOs.SelectedIndex;
            lblGeneratePath.Text += "/" + lstSCOs.SelectedValue + "?QFS=" + lbxQFS.SelectedValue;
            int i = 0;
            foreach (ListItem module in lstSCOs.Items)
            {
                string qfs = "";
                try
                {
                    qfs = lbxQFS.Items[i].Value;
                    if (qfs == "")
                    {
                        lblScormPublishError.Text = ResourceManager.GetString("Error.2");
                        lblScormPublishError.CssClass = "WarningMessage";
                        return;
                    }
                }
                catch (Exception ex)
                {                   
                    qfs = "";
                }
                string quiz = "";
                try
                {
                    quiz = lbxQuiz.Items[i].Value;
                }
                catch (Exception ex)
                {
                    quiz = "";
                }
                i += 1;
                SCORMpublishcontent(Destination + "/" + module.Value, qfs, module.Text, LabelCourse.Text, quiz);
                //                SCORMpublishcontent(Destination + "/" + module.Value, qfs, module.Text, LabelCourse.Text, "A001quiz.html");
            }

            pScorm.Visible = false;
            pGenerated.Visible = true;
        }

        public string SCORMpublishcontent(string LessonLaunchPoint, string QFS, string ModuleName, string CourseName, string QuizLaunchPoint)
        {
            using (StoredProcedure sp = new StoredProcedure("prcSCORMpublishcontent",

                       StoredProcedure.CreateInputParam("@LessonLaunchPoint", SqlDbType.VarChar, 100, LessonLaunchPoint),
                       StoredProcedure.CreateInputParam("@QFS", SqlDbType.VarChar, 100, QFS),
                       StoredProcedure.CreateInputParam("@QuizLaunchPoint", SqlDbType.VarChar, 100, QuizLaunchPoint),
                       StoredProcedure.CreateInputParam("@CourseName", SqlDbType.VarChar, 100, CourseName),
                       StoredProcedure.CreateInputParam("@ModuleName", SqlDbType.VarChar, 100, ModuleName)

                       ))
            {
                return (string)sp.ExecuteScalar();
            }

        }
        protected void btnUpload_Click(object sender, EventArgs e)
        {
            try
            {
                CheckForFiles();
            }
            catch (Exception ex)
            {
                lblUploadMessage.Text = ex.Message;
                lblUploadMessage.CssClass = "FeedbackMessage";
                return;
            }
            if (IsZIP())
            {
                ProcessManifest();
            }
            else
            {
                string strOutputPath = GenerateContent();

                if (strOutputPath != null)
                {

                    lstDefaultLayout.DataSource = Publisher.GetLayouts(Server.MapPath(ApplicationSettings.InfoPathSystemPath + "Layouts"));
                    lstDefaultLayout.DataBind();

                    lstStyle.DataSource = Publisher.GetStyles(Server.MapPath(ApplicationSettings.InfoPathSystemPath + "Styles"));
                    lstStyle.DataBind();

                    // Hide the link when the values are changed
                    lstDefaultLayout.Attributes.Add("onclick", "HidePreviewLink();");
                    lstStyle.Attributes.Add("onclick", "HidePreviewLink();");

                    //List Pages for layout design
                    dgrPages.DataSource = Publisher.GetPages(strOutputPath + "InfoPathContent.xml");
                    dgrPages.DataBind();

                    lblGeneratePath.Text = strOutputPath;

                }
            }
        }
        private string GetNewFolder(String ContentRepository)
        {
            // Create necessary directories for new content
            string newDir = Guid.NewGuid().ToString();
            string strOutputPath = ContentRepository + "Scorm/Publishing/" + newDir + "/";

            //1. Create a publising temporary folder
            try
            {
                Directory.CreateDirectory(strOutputPath);
            }
            catch (Exception ex)
            {
                return null;
            }

            return strOutputPath;
        }
        private void ProcessManifest()
        {
            btnGenerate.Text = btnPublishContent.Text;
            SCOcontent SCOutil = new SCOcontent();
            String GenerateDir = GetNewFolder(Server.MapPath("/General/"));
            FileInfo zip = new FileInfo(inputFile.PostedFile.FileName);

            inputFile.PostedFile.SaveAs(GenerateDir + "/" + zip.Name);
            DataSet SCOs = SCOutil.ListSCOs(GenerateDir, GenerateDir + "/" + zip.Name, Server.MapPath("/General/"));
            DirectoryInfo GeneratePath = new DirectoryInfo(GenerateDir);
            lblGeneratePath.Text = GeneratePath.Name;
            LabelCourse.Text = SCOutil.CourseName;
            pScorm.Visible = true;
            lnkScormPreview.Visible = true;
            pUpload.Visible = false;
            lstSCOs.DataSource = SCOs;
            lstSCOs.DataBind();
            lbxQFS.DataSource = SCOs;
            lbxQFS.DataBind(); 
            lbxQuiz.DataSource = SCOs;
            lbxQuiz.DataBind();
        }

        private void dgrPages_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                ListBox lstPageLayout = (ListBox)e.Item.FindControl("lstPageLayout");
                ArrayList lstLayouts = Publisher.GetLayouts(Server.MapPath(ApplicationSettings.InfoPathSystemPath + "Layouts"));

                ListItem objItem = new ListItem(cm_strDefault, cm_strDefault);
                lstLayouts.Insert(0, objItem);
                lstPageLayout.Attributes.Add("onclick", "HidePreviewLink();");

                lstPageLayout.DataSource = lstLayouts;
                lstPageLayout.DataBind();
            }
        }

        protected void loadLink(object sender, EventArgs e)
        {
            // get the publishing path
            string strPreviewPath = ApplicationSettings.ScormSystemPath + "Publishing/";
            // append the guid and default.apsx path
            strPreviewPath += GetFolderName(lblGeneratePath.Text) + "/" + lstSCOs.SelectedValue;

            lnkScormPreview.NavigateUrl = "/General/Scorm/ScormDiv.aspx?&SCO=" + strPreviewPath + "&ModuleID=0";
            lnkScormPreview.Attributes.Add("onclick", "window.open('/General/Scorm/ScormDiv.aspx?&SCO=" + strPreviewPath + "&ModuleID=0','','width=1024,height=786')");
            lnkScormPreview.Visible = true;

        }

        protected void btnPreviewContent_Click(object sender, EventArgs e)
        {
            try
            {
                GenerateControlFile();
                // get the publishing path
                string strPreviewPath = ApplicationSettings.InfoPathSystemPath + "Publishing/";
                // append the guid and default.apsx path
                strPreviewPath += GetFolderName(lblGeneratePath.Text) + "/default.aspx";

                lnkPreview.NavigateUrl = strPreviewPath;
                lnkPreview.Visible = true;

                lblPreviewMessage.Text = ResourceManager.GetString("lblPreviewMessage");//"Preview Generated";
                lblPreviewMessage.CssClass = "SuccessMessage";

            }
            catch (Exception ex)
            {
                lblPreviewMessage.Text = ex.Message;
                lblPreviewMessage.CssClass = "WarningMessage";
                lnkPreview.Visible = false;
            }
        }

        protected void btnPublishContent_Click(object sender, EventArgs e)
        {
            GenerateControlFile();
            pGenerated.Visible = true;
            pLayout.Visible = false;
        }
        #endregion


        #region private methods
        /// <summary>
        /// Get the uploaded file, convert and show page list for layout design
        /// </summary>
        /// <returns></returns>
        private string GenerateContent()
        {
            // Create necessary directories for new content
            string strSystemPath = Server.MapPath(ApplicationSettings.InfoPathSystemPath);
            string strOutputPath = strSystemPath + "Publishing\\" + Guid.NewGuid().ToString() + "\\";

            //1. Create a publising temporary folder
            try
            {
                Directory.CreateDirectory(strOutputPath);
                Directory.CreateDirectory(strOutputPath + "\\Images");
            }
            catch (Exception ex)
            {
                lblMessage.Text = ResourceManager.GetString("lblMessage.1") + " " + strOutputPath + ex.Message;
                lblMessage.CssClass = "FeedbackMessage";
                return null;
            }


            //2. Upload files into this new directory
            string strFilename;
            try
            {
                strFilename = GetUploadedFile(strOutputPath);
            }
            catch (Exception ex)
            {
                lblMessage.Text = ResourceManager.GetString("lblMessage.2") + " " + ex.Message;
                lblMessage.CssClass = "FeedbackMessage";
                return null;
            }
            try
            {
                GetQfs(strOutputPath);
            }
            catch (Exception ex)
            {
                lblMessage.Text = ResourceManager.GetString("lblMessage.3") + " " + ex.Message;
                lblMessage.CssClass = "FeedbackMessage";
                return null;
            }

            //3. Import the XML file and convert this file
            XmlDocument objDoc = new XmlDocument();
            try
            {
                objDoc.Load(strFilename);
            }
            catch (Exception ex)
            {
                lblMessage.Text = ResourceManager.GetString("lblMessage.4") + " " + ex.Message;
                lblMessage.CssClass = "FeedbackMessage";
                return null;
            }

            Importer objImporter = new Importer(objDoc);

            try
            {
                objImporter.Convert(strSystemPath, strOutputPath);
            }
            catch (Exception ex)
            {
                lblMessage.Text = ResourceManager.GetString("lblMessage.5") + " " + ex.Message;
                lblMessage.CssClass = "FeedbackMessage";
                return null;
            }

            pUpload.Visible = false;
            pLayout.Visible = true;

            return strOutputPath;
        }


        /// <summary>
        /// Generate control file 
        /// </summary>
        private void GenerateControlFile()
        {
            string strPageID;
            string strDefaultLayout;
            string strPageLayout;
            string strPageType;

            ArrayList objPages = new ArrayList();


            //1. Get the required data
            strDefaultLayout = lstDefaultLayout.SelectedValue;

            foreach (DataGridItem dgrItem in dgrPages.Items)
            {
                ListBox lstLayout = (ListBox)dgrItem.FindControl("lstPageLayout");
                Literal litPageID = (Literal)dgrItem.FindControl("litPageID");
                Literal litPageType = (Literal)dgrItem.FindControl("litPageType");

                // Get the page layout value
                strPageLayout = lstLayout.SelectedValue;
                strPageID = litPageID.Text;
                strPageType = litPageType.Text;

                // If layout contains the '-- Use Default--' stlye entry then use the page level entry
                if (strPageLayout == cm_strDefault)
                {
                    strPageLayout = strDefaultLayout;
                }

                objPages.Add(new ControlFilePage(strPageID, strPageLayout, strPageType));
            }

            //2. Populate the control file
            ControlFile objControlFile = new ControlFile(objPages);
            objControlFile.DefaultLayout = strDefaultLayout;
            objControlFile.Style = lstStyle.SelectedValue;

            //3. Serialize the control class to Xml file
            XmlSerializer objSer = new XmlSerializer(objControlFile.GetType());
            FileStream fsControlFile = new FileStream(lblGeneratePath.Text + "\\Control.xml", FileMode.Create, FileAccess.Write, FileShare.ReadWrite);
            objSer.Serialize(fsControlFile, objControlFile);

            // Flush close and quit
            fsControlFile.Flush();
            fsControlFile.Close();
        }

        /// <summary>
        /// Check whether the file is SCORM (i.e. is ZIP)
        /// </summary>
        private Boolean IsZIP()
        {
            return (inputFile.PostedFile.FileName.ToUpper().EndsWith("ZIP"));
        }

        /// <summary>
        /// Check whether the required files are provided
        /// </summary>
        private void CheckForFiles()
        {
            if (inputFile.PostedFile.FileName.Length == 0)
            {
                throw new Exception(ResourceManager.GetString("Error.1"));
            }
            if ((radLesson.Checked) && (inputFile.PostedFile.FileName.ToLower().IndexOf(".zip") == -1))
            {
                if (inputQfs.PostedFile.FileName.Length == 0)
                {
                    throw new Exception(ResourceManager.GetString("Error.2"));
                }
            }
            if (radQuiz.Checked)
            {
                if (inputQfs.PostedFile.FileName.Length != 0)
                {
                    throw new Exception(ResourceManager.GetString("Error.3"));
                }
            }
        }

        /// <summary>
        /// Saves the InfoPath XML file to the specified directory.
        /// </summary>
        private string GetUploadedFile(string outputPath)
        {
            if (inputFile.PostedFile.FileName != "")
            {
                string strFullFilename = outputPath + "InfoPathContent.xml";

                inputFile.PostedFile.SaveAs(strFullFilename);

                return strFullFilename;
            }
            else
            {
                throw new Exception(ResourceManager.GetString("Error.4"));
            }

        } // GetUploadedFile


        /// <summary>
        /// Saves the qfs to the specified directory.
        /// </summary>
        private void GetQfs(string outputPath)
        {
            if (inputQfs.PostedFile.FileName != "")
            {
                string strFullFilename = outputPath + "qfs.html";

                inputQfs.PostedFile.SaveAs(strFullFilename);
            }

        } // GetUploadedFile

        /// <summary>
        /// Get the folder name of physicalPath; 
        /// </summary>
        /// <param name="physicalPath"></param>
        /// <returns></returns>
        private string GetFolderName(string physicalPath)
        {
            string strInput = physicalPath;
            // remove tailing slash
            if (strInput.LastIndexOf("\\") == strInput.Length - 1)
            {
                strInput = strInput.Substring(0, strInput.Length - 1);
            }
            int intLastSlash = strInput.LastIndexOf("\\") + 1;
            return strInput.Substring(intLastSlash, strInput.Length - intLastSlash);
        }

        #endregion


        #region Web Form Designer generated code
        override protected void OnInit(EventArgs e)
        {
            //
            // CODEGEN: This call is required by the ASP.NET Web Form Designer.
            //
            InitializeComponent();
            base.OnInit(e);
            dgrPages.Columns[2].HeaderText = ResourceManager.GetString("grid_PageTitle");
            dgrPages.Columns[3].HeaderText = ResourceManager.GetString("grid_PageType");
        }

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.dgrPages.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(this.dgrPages_ItemDataBound);

        }
        #endregion




    }
}
