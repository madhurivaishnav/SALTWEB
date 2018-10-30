using System;
using System.Data;
using System.Configuration;
using System.Collections.Specialized;
using System.Collections.Generic;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.Web.General.Scorm;
using Bdw.Application.Salt.BusinessServices;
using System.Net;
using System.IO;
using System.Text;

using System.Text.RegularExpressions;


namespace Bdw.Application.Salt.Web.General.Scorm
{
    public partial class ScormDiv : System.Web.UI.Page
    {

        #region Protected Variables

        protected System.Web.UI.WebControls.TextBox txtModuleID;

        protected System.Web.UI.WebControls.TextBox txtXML;

        protected System.Web.UI.WebControls.TextBox txtDebug;

        protected System.Web.UI.WebControls.TextBox txtscorm;

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    BusinessServices.User objUser = new User();
                    DataTable dtGetLatestQuizstatus = new DataTable();
                    dtGetLatestQuizstatus = objUser.GetUserQuizStatusID(Convert.ToInt32(UserContext.UserID),Convert.ToInt32(Request.QueryString["ModuleID"]));
                    if (dtGetLatestQuizstatus.Rows.Count > 0)
                    {
                        
                        if ((Convert.ToInt32(dtGetLatestQuizstatus.Rows[0]["QuizStatusID"].ToString().Trim()) == 4 || Convert.ToInt32(dtGetLatestQuizstatus.Rows[0]["QuizStatusID"].ToString().Trim()) == 5) && dtGetLatestQuizstatus.Rows[0]["QuizSessionID"].ToString().Trim() == "")
                        {


                            string strHostname = HttpContext.Current.Request.Url.Authority.ToString();
                            string strUrl = null;
                            if (strHostname.ToLower().Equals("127.0.0.2"))
                            {
                                strUrl = "https://" + strHostname;

                            }
                            else
                            {
                                strUrl = "http://" + strHostname;
                            }
                            strUrl = "https://" +strHostname;
                            string FrameURL = "";
                            //if (strHostname.Contains("localhost"))
                            //{
                            //    FrameURL = Server.MapPath("/General/Scorm/Content/" + Request.QueryString["CourseID"] + "/" + Request.QueryString["ModuleID"] + "/shared/launchpage.html");
                            //}
                            //else
                            //{
                                FrameURL = strUrl + "/General/Scorm/Content/" + Request.QueryString["CourseID"] + "/" + Request.QueryString["ModuleID"] + "/shared/launchpage.html";
                           // }
                            string fileName = Server.MapPath("/General/Scorm/Content/" + Request.QueryString["CourseID"] + "/" + Request.QueryString["ModuleID"] + "/shared/launchpage.html"); 
                            //string fileName = strUrl + "/General/Scorm/Content/" + Request.QueryString["CourseID"] + "/" + Request.QueryString["ModuleID"] + "/shared/launchpage.html";
                            if (File.Exists(fileName))
                            {
                                string htmlCode = "";
                                try
                                {
                                    using (WebClient client = new WebClient())
                                    {
                                        htmlCode = client.DownloadString(fileName);
                                    }
                                }
                                catch (Exception ex)
                                {
                                }
                                int start = htmlCode.IndexOf("apiPrefix", 0) + 12;
                                int End = htmlCode.LastIndexOf("scormMode") - 3;
                                string WithapiPrefixContent = htmlCode.Substring(start, End - start);

                                //Code to insert quizsession id
                                objUser.UpdateQuizSessionOnExpiry(Convert.ToInt32(dtGetLatestQuizstatus.Rows[0]["UserQuizStatusID"].ToString().Trim()), new Guid(Request.QueryString["SessionData"].ToString().Trim()));
                                //end code here


                                //string URL = "https://adaptive.saltcompliance.com/api/v1/shc/learn.jsonp?doorId=2d62e133-693c-4978-be93-80a8fbce9c13&scormPackageId=2501e848-9812-47d8-87be-5c67d53801f2&secret=cJjUyv4FC3AjPSUepUdOgAODB4lc&lmsUserId=" + UserContext.UserID + "&resetProgress=true&callback";
                                string URL = WithapiPrefixContent + "&lmsUserId=" + UserContext.UserID + "&resetProgress=true&callback";
                                HttpWebRequest http = (HttpWebRequest)HttpWebRequest.Create(URL);
                                HttpWebResponse response = (HttpWebResponse)http.GetResponse();
                                using (StreamReader sr = new StreamReader(response.GetResponseStream()))
                                {
                                    string responseJson = sr.ReadToEnd();
                                    int startReset = responseJson.IndexOf("apiPrefix", 0) + 12;
                                    int EndReset = responseJson.LastIndexOf("title") - 3;
                                    string WithapiPrefixContentReset = responseJson.Substring(startReset, EndReset - startReset);
                                    if (WithapiPrefixContentReset != "")
                                    {
                                        int cmdStart = responseJson.IndexOf("cmd=soft-reset-course-inst", 0) + 4;
                                        int cmdEnd = responseJson.IndexOf("href", 0) - 3;
                                        string cmd = responseJson.Substring(cmdStart, cmdEnd - cmdStart);

                                        string api = WithapiPrefixContentReset + "&cmd=" + cmd + "&callback";
                                        HttpWebRequest httpReset = (HttpWebRequest)HttpWebRequest.Create(api);
                                        HttpWebResponse responsehttpReset = (HttpWebResponse)httpReset.GetResponse();
                                        if (responsehttpReset.StatusDescription != "OK")
                                        {
                                            //TODO:Send email
                                            string EmailBody = "URL: " + strUrl + "<br>" +
                                               "CourseID: " + Request.QueryString["CourseID"] + "<br>" +
                                               "ModuleID: " + Request.QueryString["ModuleID"] + "<br>" +
                                               "UserID: " + UserContext.UserID + "<br>" +
                                               "Status Description: " + responsehttpReset.StatusDescription;
                                            StatusResetError(EmailBody);

                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
                catch (Exception ex)
                {
                    StatusResetError(ex.Message);
                }
            }


            Scorm12 s = new Scorm12();
            AppConfig a = new AppConfig();
            Boolean iserror = false;

            txtModuleID.Text = Request.QueryString["ModuleID"];

            if (txtModuleID.Text != "0")
            {
                BusinessServices.Module m = new Module();
                DataTable tblLesson;
                String StrNoq = Request.QueryString["noq"];
                if (null == StrNoq)
                {
                    tblLesson = m.GetLesson(Int32.Parse(txtModuleID.Text), UserContext.UserData.OrgID);
                    txtXML.Text = s.ReadDMEvalue(UserContext.UserID, Int32.Parse(txtModuleID.Text), null, true);
                }
                else
                {
                    tblLesson = m.GetQuiz(Int32.Parse(txtModuleID.Text), UserContext.UserData.OrgID);
                    txtXML.Text = s.ReadDMEvalue(UserContext.UserID, Int32.Parse(txtModuleID.Text), null, false);
                    txtsessid.Text = Request.QueryString["SessionData"];
                }
                //try
                //{
                //if (((string)tblLesson.Rows[0]["ToolbookLocation"]).Contains("launchpage"))
                //{
                //    string oldPathAndName = Server.MapPath((string)tblLesson.Rows[0]["ToolbookLocation"]);
                //    string oldFileName = "launchpage.html";
                //    string newFileName = "launchpage" + UserContext.UserID.ToString() + ".html";
                //    System.IO.File.Copy(oldPathAndName, oldPathAndName.Replace(oldFileName, newFileName), true);
                //    txtscorm.Text = (string)tblLesson.Rows[0]["ToolbookLocation"].ToString().Replace(oldFileName, newFileName);

                //    WebClient client = new WebClient();
                //    String htmlCode = client.DownloadString(Server.MapPath(txtscorm.Text.ToString()));
                //    string launchdata = getBetween(htmlCode, "<script>", "</script>");
                //    string[] apivalues = launchdata.Split(',');
                //    for (int i = 0; i < apivalues.Length; i++)
                //    {
                //        if (apivalues[i].Contains("apiPrefix"))
                //        {
                //            string sap = apivalues[i].ToString();
                //            StringBuilder sb = new StringBuilder();
                //            sb.Append(sap);
                //            sb.Insert(sb.Length - 1, "&lmsUserId=Salt™" + UserContext.UserID + "&callback");

                //            StreamWriter sw = new StreamWriter(Server.MapPath(txtscorm.Text.ToString()));
                //            sw.Write(htmlCode.Replace(apivalues[5].ToString().Trim(), sb.ToString().Trim()));
                //            sw.Close();
                //        }
                //    }
                //}
                //else
                //{
                    txtscorm.Text = (string)tblLesson.Rows[0]["ToolbookLocation"];
               //}
                //}
                //catch { txtscorm.Text = @"/General/Scorm/Content/AdaptiveFiles/403/2994/index_lms.html"; }
                //if (txtscorm.Text.ToString().ToLower().Contains("index_lms.html"))
                //{btnExit.Visible = true;}
                //else { btnExit.Visible = false; }
                    if (txtscorm.Text.ToString().ToLower().Contains("launchpage"))
                { btnExit.Visible = true; }
                else { btnExit.Visible = false; }
                //txtscorm.Text = @"/General/Scorm/Content/405/3001/lesson/launchpage.html";
                // txtscorm.Text = @"http://review.demo.saltcompliance.com/General/Scorm/Content/AdaptiveFiles/402/2994/idex_lms.html";

            }
            txtDebug.Text = a.getConfigValue("SCORM_Debug");

            if (!iserror)
            {
                //throw new Exception("Something bad...");
            }
        }

        public  void WriteErrorLog(string message)
        {
            try
            {
                StreamWriter sw = null;
                string fileName = Server.MapPath("/General/Scorm/");
                sw = new StreamWriter(fileName + "\\logfile.txt", true);
                sw.WriteLine(DateTime.Now.ToString() + ":" + message);
                sw.Flush();
                sw.Close();
            }
            catch
            {
            }
        }
        public void StatusResetError(string strBody)
        {
            BusinessServices.Email objEmail = new BusinessServices.Email();
            objEmail.SendEmail(ApplicationSettings.SupportEmail, "Developer Team", ApplicationSettings.SupportEmail, "Developer Team", null, null, "Error in Adaptive Status Reset from Salt Web Application", strBody, ApplicationSettings.MailServer);
        }
        public static string getBetween(string strSource, string strStart, string strEnd)
        {
            int Start, End;
            if (strSource.Contains(strStart) && strSource.Contains(strEnd))
            {
                Start = strSource.IndexOf(strStart, 0) + strStart.Length;
                End = strSource.IndexOf(strEnd, Start);
                return strSource.Substring(Start, End - Start);
            }
            else
            {
                return "";
            }
        }

        //protected void btnexitall_Click(object sender, EventArgs e)
        //{
        //    Response.Redirect("/MyTraining.aspx");
        //}
        ////    try
        ////    {
        ////        DataTable tblLesson;
        ////        //Scorm12 sc = new Scorm12();
        ////        //sc.ProcessRequest(
        ////        BusinessServices.Module m = new Module();
        ////        String StrNoq = Request.QueryString["noq"];
        ////        if (null == StrNoq)
        ////        {
        ////            tblLesson = m.GetLesson(Int32.Parse(txtModuleID.Text), UserContext.UserData.OrgID);
        ////        }
        ////        else
        ////        {
        ////            tblLesson = m.GetQuiz(Int32.Parse(txtModuleID.Text), UserContext.UserData.OrgID);
        ////        }
        ////        if (((string)tblLesson.Rows[0]["ToolbookLocation"]).Contains("launchpage"))
        ////        {
                    
        ////            string oldPathAndName = Server.MapPath((string)tblLesson.Rows[0]["ToolbookLocation"]);
        ////            string oldFileName = "launchpage.html";
        ////            string newFileName = "launchpage" + UserContext.UserID.ToString() + ".html";
        ////            txtscorm.Text = (string)tblLesson.Rows[0]["ToolbookLocation"].ToString().Replace(oldFileName, newFileName);
        ////            if (File.Exists(Server.MapPath(txtscorm.Text.ToString())))
        ////            {
        ////                File.Delete(Server.MapPath(txtscorm.Text.ToString()));
        ////                Response.Redirect("/MyTraining.aspx");
        ////            }
        ////        }
        ////        else
        ////        {
        ////            Response.Redirect("/MyTraining.aspx");
        ////        }
        ////    }
        ////    catch (Exception ex)
        ////    {
        ////        Response.Redirect("/MyTraining.aspx");
        ////    }
        ////}

    }
}