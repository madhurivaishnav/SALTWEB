using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Configuration;
using Bdw.Application.Salt.Web.Utilities;
using System.IO;
using Bdw.Application.Salt.Data;


namespace Bdw.Application.Salt.Web.General.eBook
{
    public class EBookDownload : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            int courseID = 0;

            if (context.Request.QueryString["CourseID"] != null)
            {
                bool result = Int32.TryParse(context.Request.QueryString["CourseID"], out courseID);
                if (result)
                {
                    bool hasAccess = false;    // flag to determine if the user has access to this course
                    bool isSaltAdmin = false;

                    BusinessServices.Course objCourse = new BusinessServices.Course();

                    // check if the user attempting to download this has valid permission/access to the course
                    // Salt Administrator can download the file without restriction
                    if (UserContext.UserData.UserType == UserType.SaltAdmin)
                    {
                        // Salt admin always have access
                        isSaltAdmin = true;
                        hasAccess = true;
                    }
                    else
                    {
                        // Course Object
                        DataTable dtbCourses = objCourse.GetCourseListAccessableToUser(UserContext.UserID);
                        // iterate to check if the user has access to this course
                        foreach (DataRow row in dtbCourses.Rows)
                        {
                            int rowCourseID = 0;
                            bool rslCourseID = Int32.TryParse(row["courseid"].ToString(), out rowCourseID);
                            if (rslCourseID && rowCourseID == courseID)
                            {
                                // user has access, break from the loop
                                hasAccess = true;
                                break;
                            }
                        }

                    }

                    // get ebook details
                    DataTable dtbEbook = objCourse.GetEbook(courseID, UserContext.UserData.OrgID);

                    // if ebook exists
                    if (dtbEbook.Rows.Count > 0)
                    {
                        string eBookPath = ConfigurationManager.AppSettings["EBookPath"];
                        // the location of the ebook in the server
                        string eBookFile = context.Server.MapPath(eBookPath + dtbEbook.Rows[0]["ServerFileName"].ToString());
                        // the original filename of the ebook
                        string eBookName = dtbEbook.Rows[0]["EbookFileName"].ToString();
                        // get the ebook id
                        int ebookID = 0;
                        bool rslEbookID = Int32.TryParse(dtbEbook.Rows[0]["ebookid"].ToString(), out ebookID);
                        if (!rslEbookID)
                        {
                            ebookID = 0;    // shouldn't be error...
                        }

                        // log the user's activity to download this ebook
                        string userAgent = context.Request.UserAgent;
                        BusinessServices.User objUser = new BusinessServices.User();

                        // detect the request to see if the user is using iPad
                        if (!userAgent.ToLower().Contains("ipad") && !isSaltAdmin)
                        {
                            objUser.LogEbookDownload(UserContext.UserID, ebookID, userAgent, "unsupported device");
                            context.Response.Redirect("/General/Errors/NoSuchPage.aspx");
                            return;
                        }


                        // if the user has access to the course, we retrieve the ebook
                        if (hasAccess)
                        {
                            // retrieve the file from the server
                            FileInfo fileInfo = new FileInfo(eBookFile);
                            try
                            {
                                if (fileInfo.Exists)
                                {
                                    context.Response.Clear();
                                    context.Response.AddHeader("Content-Disposition", "inline;filename=\"" + eBookName + "\"");
                                    context.Response.AddHeader("Content-Length", fileInfo.Length.ToString());
                                    context.Response.ContentType = "application/epub+zip";
                                    context.Response.TransmitFile(fileInfo.FullName);
                                    context.Response.Flush();
                                }
                            }
                            catch (Exception ex)
                            {
                                context.Response.Redirect("/General/Errors/NoSuchPage.aspx");
                                // log the user's ebook log with the error message
                                objUser.LogEbookDownload(UserContext.UserID, ebookID, userAgent, ex.Message);
                            }
                            finally
                            {
                                context.Response.End();
                                objUser.LogEbookDownload(UserContext.UserID, ebookID, userAgent, "success");
                            }
                        }
                        else
                        {
                            // user has no access
                            objUser.LogEbookDownload(UserContext.UserID, ebookID, userAgent, "no access");
                        }

                        
                    }

                }

                context.Response.Redirect("/General/Errors/NoSuchPage.aspx");
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}
