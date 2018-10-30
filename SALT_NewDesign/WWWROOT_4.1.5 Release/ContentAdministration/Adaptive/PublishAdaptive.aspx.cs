using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using Ionic.Zip;

using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.Web.Utilities;
using Localization;
using System.IO;
using System.Configuration;

namespace Bdw.Application.Salt.Web.ContentAdministration.Adaptive
{
    public partial class PublishAdaptive : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!this.IsPostBack)
            {
                // Paint the page
                SetPageState();
            }

            //string ZipFileName = @"C:\ANIME\Anti Bribery and Corruption (for 'GRC Solutions', standard mode, allow course review, SCORM 1.2, Any LMS).zip";
            //string unpackDirectory = @"C:\VS2008Projects\SALT_SCROM_Integration\WWWROOT_4.1.5 Release\General\Scorm\AdaptiveFiles";
            //using (ZipFile zip1 = ZipFile.Read(ZipFileName))
            //{
            //    foreach (ZipEntry e1 in zip1)
            //    {
            //        e1.Extract(unpackDirectory, ExtractExistingFileAction.OverwriteSilently);
                    
            //    }

               
            //}
        }
        private void SetPageState()
        {
             BusinessServices.Course objCourse = new BusinessServices.Course();
            DataTable dtbCourses = objCourse.GetCourseList(UserContext.UserData.OrgID);
            if (dtbCourses.Rows.Count > 0)
            {
                cboCourses.DataSource = dtbCourses;
                cboCourses.DataValueField = "CourseID";
                cboCourses.DataTextField = "Name";
                cboCourses.DataBind();
                cboCourses.Items.Insert(0, new ListItem(String.Empty, String.Empty));
                cboCourses.SelectedIndex = 0;
            }
        }

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

        protected void btnPublish_Click(object sender, EventArgs e)
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
                //if (cboCourses.SelectedValue != 0)
                //{

                //}
            }
        }
    }
}
