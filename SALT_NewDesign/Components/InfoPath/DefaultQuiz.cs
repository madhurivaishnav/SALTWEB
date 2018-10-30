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
using System.Xml;
using System.Xml.Xsl;
using System.Collections.Specialized;
using System.Configuration;
using System.Net.Mail;

using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.InfoPath;
using Localization;
using Bdw.Application.Salt.Data;
using System.IO;
using Bdw.Application.Salt.Utilities;
using Microsoft.ApplicationBlocks.Data;
using Bdw.Application.Salt.ErrorHandler;

namespace Bdw.Application.Salt.InfoPath
{
	/// <summary>
	/// This is the code-behind class for all Quiz rendering pages (Default.aspx),
	/// </summary>
	public class DefaultQuiz: PageBase
	{
		protected System.Web.UI.WebControls.PlaceHolder plhContent;
		protected Literal pagTitle;
		private const string  cm_strSystemPath = "/General/InfoPath/";
		private const string  cm_strSelectAnswerScript = "<script>\nSelectAnswer('{0}');\n</script>";
    
		#region Page_Load
		private void Page_Load(object sender, System.EventArgs e)
		{
			ResourceManager.RegisterLocaleResource("ConfirmExit");
			pagTitle.Text = ResourceManager.GetString("cmnQuiz");

			//-- Checks for multiple clicks. 
			String strScript = "<script language=\"javascript\" type=\"text/javascript\">" + "\r\n" +
				"<!--" + "\r\n" +
				"// save a reference to the original __doPostBack" + "\r\n" +
				"var __oldDoPostBack = __doPostBack;" + "\r\n" +
				"// replace __doPostBack with another function" + "\r\n" +
				"__doPostBack = AlwaysFireBeforeFormSubmit;" + "\r\n" +
				"\r\n" +
				"var submitCounter=0;" +  "\r\n" +
				"\r\n" +
				"function AlwaysFireBeforeFormSubmit (eventTarget, eventArgument) {" + "\r\n" +
				"   if (!(++submitCounter>1)) {" + "\r\n" +
				"      return __oldDoPostBack (eventTarget, eventArgument);" + "\r\n" +
				"   }" + "\r\n" +
				"}" + "\r\n" +
				"-->" + "\r\n" +
				"</script>" + "\r\n";

			Page.RegisterClientScriptBlock("submitCounter", strScript );



			//1. Handle Page events
			//Fire the Quiz_load event when the Quiz starts
			if (!Page.IsPostBack)
			{
				this.CreateContext();

				//Fire Toolbook Quiz_Load event
				this.Quiz_Load();

			}
				//Handle page events when page is posted back (After start)
			else
			{
				//Fire capture answer event when the question page is posted back.
				if (PageContext.Current.PageType=="Questions")
				{
					Question_CaptureAnswer();
				}
				//Handle page event
				this.HandlePageEvents(Request.Form["__EVENTTARGET"],Request.Form["__EVENTARGUMENT"]);
			}

			//2. Render the page content
			this.RenderPageContent();

			Page.GetPostBackEventReference(this);
			
			if (PageContext.Current.PageType=="Questions")
			{
				Page.RegisterStartupScript("SelectAnswer",String.Format(cm_strSelectAnswerScript, CurrentQuizContext.Answer));
			}

		}

		private QuizPageContext CurrentQuizContext
		{
			get
			{
				return (QuizPageContext)PageContext.Current;
			}
		}

		#endregion

		#region Page events
		/// <summary>
		/// Create context when the lesson starts
		/// </summary>
		private void CreateContext()
		{
			//1. Get Page Context
			QuizPageContext objContext = new QuizPageContext();

			objContext.Path = Request.Url.AbsolutePath.Replace("/default.aspx","");
			objContext.StartTime = DateTime.Now;
			objContext.PageIndex = 0;	
			objContext.Initialize();
            
			PageContext.Current = objContext;
		}

		/// <summary>
		/// Render the page content
		/// </summary>
		private void RenderPageContent()
		{
			//1. Load XML Doc
			XmlDocument xmlDocument = PageContext.Current.DataFile;
			
			//2. Load XSL Doc
			XslTransform objTransform = new XslTransform();
			objTransform.Load( Server.MapPath(cm_strSystemPath) +"Layouts\\" + PageContext.Current.Layout + ".xslt" );

			//3. Transform
			XHelper objHelper = new XHelper(xmlDocument,objTransform);
			objHelper.AddParameter("PageID",PageContext.Current.PageID);
			objHelper.AddParameter("QuestionIndex",CurrentQuizContext.QuestionIndex);
			objHelper.AddParameter("QuestionCount",CurrentQuizContext.QuestionCount);
			objHelper.AddParameter("SelectedAnswer",CurrentQuizContext.Answer.ToString());
			objHelper.AddParameter("Preview",PageContext.Current.IsPreviewMode);

			// Language translation
			objHelper.AddParameter("QuestionText",ResourceManager.GetString("QuestionText"));
			objHelper.AddParameter("OfText",ResourceManager.GetString("OfText"));
			objHelper.AddParameter("HomeText",ResourceManager.GetString("HomeText"));
			objHelper.AddParameter("InstructionsText",ResourceManager.GetString("InstructionsText"));
			objHelper.AddParameter("QuickFactsText",ResourceManager.GetString("QuickFactsText"));
			objHelper.AddParameter("PageText",ResourceManager.GetString("PageText"));
			objHelper.AddParameter("ExitPreviewText",ResourceManager.GetString("ExitPreviewText"));
			objHelper.AddParameter("ExitText",ResourceManager.GetString("ExitText"));
			objHelper.AddParameter("DisclaimerText",ResourceManager.GetString("DisclaimerText"));
			objHelper.AddParameter("PreviewModeText",ResourceManager.GetString("PreviewModeText"));
			objHelper.AddParameter("NextAltText",ResourceManager.GetString("NextAltText"));
			objHelper.AddParameter("PreviousAltText",ResourceManager.GetString("PreviousAltText"));


			//4. Rendering
			Literal objLiteral = new Literal();
			// perform translation
			string strContent  = objHelper.Translate();
			// Replace number of questions marker with teh real value
			strContent = strContent.Replace("%System_NumberOfQuestions%",CurrentQuizContext.QuestionCount.ToString());
			objLiteral.Text = strContent;

			plhContent.Controls.Add( objLiteral );

		}

		/// <summary>
		/// Handle page events when the page is posted back
		/// </summary>
		/// <param name="eventName"></param>
		/// <param name="eventArgument"></param>
		private void HandlePageEvents(string eventName, string eventArgument)
		{
			switch (eventName)
			{
				//The following 4 events are Page change events
				case "Home_Click":
				{
					PageContext.Current.PageIndex=0;
					break;
				}
				case "Previous_Click":
				{
					PageContext.Current.PageIndex--;
					break;
				}
				case "Next_Click":
				{
					PageContext.Current.PageIndex++;
					break;
				}
					//The following 2 events are End quiz events
				case "Exit_Click":
				{
					string strCourseID = Request.QueryString["CourseID"].ToString();
					string strProfileID = Request.QueryString["ProfileID"].ToString();
					Response.Redirect("/MyTraining.aspx?CourseID=" + strCourseID + "&ProfileID=" + strProfileID);
					break;
				}
				case "Quiz_End":
				{
					Quiz_End();
					break;
				}  			
			}
		}
		#endregion

		#region Toolbook events
		/// <summary>
		/// Quiz load event
		/// </summary>
		private void Quiz_Load()
		{
			if (!PageContext.Current.IsPreviewMode)
			{
				BusinessServices.Toolbook objToolbook = new BusinessServices.Toolbook();
				if (!objToolbook.StartQuiz(PageContext.Current.SessionID))
				{
					Response.Write(ResourceManager.GetString("QuizLesson_Error"));
					Response.End();
					//throw new Exception("Quiz has already been started");
				}
			}
		}
		/// <summary>
		/// Capture the answer when a answer is selected in a question page.
		/// This event will fire when a question page is posted back.
		/// </summary>
		private void Question_CaptureAnswer()
		{
			if (Request.Form["Answer"]!=null && Request.Form["Answer"].Length>0)
			{
				string strValue = Request.Form["Answer"];
                    
				CurrentQuizContext.Answer=strValue;
			}
		}
        
		/// <summary>
		/// Page Load event
		/// </summary>
		/// <remarks>
		/// This event fires when a user goes to a page. It is used to track a user’s progress through a lesson and determine when they have completed their training requirement.
		/// The event will call the Toolbook.RecordPageVisited method.
		/// </remarks>
		private void Page_Load()
		{
			if (!PageContext.Current.IsPreviewMode)
			{
				BusinessServices.Toolbook objToolbook = new BusinessServices.Toolbook();
				objToolbook.RecordPageVisited(PageContext.Current.SessionID,PageContext.Current.PageID);
			}
		}

		/// <summary>
		/// Quiz End event
		/// </summary>
		/// <remarks>
		/// This event fires when a student clicks the “Submit answers” button on the last page. The event will 
		///		.Score: Calculate the score (Question number with correct answer/Total question number * 100)
		///		.Duration: Calculate the duration of the testing.
		///		.QuizQuestionAudit: Record quiz question audit.
		///		.QuizAnswerAudit: Record quiz answer audit
		/// </remarks>
		public  void Quiz_End()
        {
            //certemail(956, 42, 0);
			if (!PageContext.Current.IsPreviewMode)
			{
				try
				{
					BusinessServices.Toolbook objToolbook = new BusinessServices.Toolbook();
					NameValueCollection nvcAnswers = CurrentQuizContext.Answers;
					DataTable endQuizInfo;
					int intUserID;
					int intQuizID;
					int intPassMark;
					int intUnitID;
					int intModuleID;
					int intQuizFrequency;
					int intOldCourseStatus;
					int intNewCourseStatus;
					int intNewQuizStatus;
					int intCourseID;
					DateTime dtmQuizCompletionDate;
					
					foreach (string strKey in nvcAnswers.AllKeys)
					{
						objToolbook.CreateQuizQuestionAudit(PageContext.Current.SessionID,strKey);
						objToolbook.CreateQuizAnswerAudit(PageContext.Current.SessionID,strKey,Convert.ToInt32( nvcAnswers[strKey] ));
					}
	            
					int intScore = objToolbook.GetQuizScore(PageContext.Current.SessionID);
					TimeSpan objTimeSpan = DateTime.Now.Subtract(PageContext.Current.StartTime);
	            
					//objToolbook.EndQuizSession(PageContext.Current.SessionID,objTimeSpan.Seconds,intScore);

					endQuizInfo = objToolbook.BeforeQuizEnd(PageContext.Current.SessionID,objTimeSpan.Seconds,intScore);
					
					DataRow tmpRow = endQuizInfo.Rows[0];
					intUserID = Int32.Parse(tmpRow["UserID"].ToString());
					intQuizID = Int32.Parse(tmpRow["QuizID"].ToString());
					intPassMark = Int32.Parse(tmpRow["PassMark"].ToString());
					intUnitID = Int32.Parse(tmpRow["UnitID"].ToString());
					intModuleID = Int32.Parse(tmpRow["ModuleID"].ToString());
					intQuizFrequency = tmpRow["QuizFrequency"] == null ? Int32.Parse(tmpRow["QuizFrequency"].ToString()): 0;
					intOldCourseStatus = Int32.Parse(tmpRow["OldCourseStatus"].ToString());
					intNewCourseStatus = Int32.Parse(tmpRow["NewCourseStatus"].ToString());
					intNewQuizStatus = Int32.Parse(tmpRow["NewQuizStatus"].ToString());
					intCourseID = Int32.Parse(tmpRow["CourseID"].ToString());					
					int intProfileID = Int32.Parse(Request.QueryString["ProfileID"].ToString());
					dtmQuizCompletionDate = (tmpRow["QuizCompletionDate"] == System.DBNull.Value ? DateTime.Parse("1/1/1900"): (DateTime)tmpRow["QuizCompletionDate"]);
                    
                    endQuizInfo = objToolbook.EndQuizSession_UpdateTables(PageContext.Current.SessionID, objTimeSpan.Seconds, intScore, intUserID, intQuizID, intPassMark, intUnitID, intModuleID, intCourseID, intOldCourseStatus, intNewQuizStatus, intNewCourseStatus, intQuizFrequency, dtmQuizCompletionDate);
                    tmpRow = endQuizInfo.Rows[0];
                    Boolean blnSendCert = (bool)tmpRow["sendcert"];
                    if (blnSendCert)
                    {
                        certemail(intUserID, intCourseID, intProfileID);
                    }


                    //obtain profileIDs for all profiles that have access to module and apply points
					BusinessServices.Profile objProfile = new BusinessServices.Profile();
					DataTable dtProfiles = objProfile.ProfilesWithModuleAccess(intUserID, intModuleID);
					foreach (DataRow dr in dtProfiles.Rows)
					{
						int ProfileID = int.Parse(dr["ProfileID"].ToString());
						ApplyProfilePoints(ProfileID, intNewQuizStatus, intModuleID, intUserID);
					}
					Session["CourseID"] = intCourseID.ToString();
					Session["CourseID_ProfileID"] = "CourseID=" + intCourseID.ToString() + "&ProfileID=" + intProfileID.ToString();					
				}
				catch(Exception ex)
				{
					if (ex.Message.ToLower().StartsWith("violation of primary key"))
					{
						Response.Write(ResourceManager.GetString("QuizLesson_Error"));
						Response.End();
					}
                    else
                    {
                        //throw ex;
                        ErrorHandler.ErrorLog el = new ErrorHandler.ErrorLog(ex);

                    }
				}

				Response.Redirect("/Reporting/QuizResult.aspx?QuizSessionID=" + PageContext.Current.SessionID);
			}
			
		}
		#endregion



        public static void sendCertEmail(int userid, int courseid, int orgid, string certPath)
        {
            Organisation org = new Organisation();
            AppConfig a = new AppConfig();
            if (!org.orgMailFlagConfig(orgid, 0, userid) && a.getConfigValue("SEND_AUTO_EMAILS").ToUpper().Equals("YES") )
            {

                User usr = new User();
                DataTable dtUser = usr.GetUser(userid);
                MailAddress emailTo = new MailAddress(dtUser.Rows[0]["Email"].ToString());

                string strEmailFrom = null;

                using (StoredProcedure sp = new StoredProcedure("prcUser_GetAdministratorsEmailAddress",
                    StoredProcedure.CreateInputParam("@UserId", SqlDbType.Int, userid))
                    )
                {
                    strEmailFrom = sp.ExecuteScalar().ToString();
                }
                MailAddress emailFrom = new MailAddress(strEmailFrom);
                MailMessage emailCert = new MailMessage(emailFrom, emailTo);
                
                OrganisationConfig orgConfig = new OrganisationConfig();

                Course course = new Course();
                DataTable dtCourse = course.GetCourse(courseid, orgid);
                Email eml = new Email();
                string strEmailBody = orgConfig.GetOne(orgid, "Course_Completion_Certificate");
                eml.SetEmailBody(strEmailBody, userid, dtCourse.Rows[0]["Name"].ToString(), "", "", "", "", "", "", "");
                strEmailBody = eml.getEmailBody();

                emailCert.Body = strEmailBody;
                emailCert.Subject = eml.emailHeaderSub ("%APP_NAME% - " + dtCourse.Rows[0]["Name"].ToString());
                Attachment cert = new Attachment(certPath);
                if (!certPath.Equals(""))
                {
                    emailCert.Attachments.Add(cert);
                }

                emailCert.IsBodyHtml = true;

                emailCert.From = new MailAddress(getOnBehalfOfEmail());

                emailCert.Sender = emailFrom;

                //SmtpClient client = new SmtpClient();
                string MailServer = (string)HttpContext.Current.Application["MailServer"];
                SmtpClient SmtpMail = new SmtpClient(MailServer);
                SmtpMail.Credentials = new System.Net.NetworkCredential();//.CredentialCache.DefaultNetworkCredentials;
                emailCert.Headers.Add("Reply-To", emailCert.Sender.ToString()); //for IIS7 and below
                emailCert.ReplyTo = emailCert.Sender;                           //for IIS7.5 and above
                //SmtpClient smtp = new SmtpClient();
                //smtp.Host = "smtp.nsw.exemail.com.au";
                //smtp.Port = 25;
                //smtp.UseDefaultCredentials = false;
                ////smtp.DeliveryMethod = System.Net.Mail.SmtpDeliveryMethod.Network;
                //smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
                ////smtp.Credentials = new NetworkCredential("custadmin", "decemBer25TH1");
                //smtp.Credentials = new System.Net.NetworkCredential("Joseph.Karithanam@grcsolutions.com.au", "abcd-1234");
                //smtp.EnableSsl = true;
                ////smtp.EnableSsl = false;
                //smtp.Timeout = 20000;
               

                try
                {
                    SmtpMail.Send(emailCert);
                    //smtp.Send(emailCert);
                    
                    eml.LogSentEmail(dtUser.Rows[0]["Email"].ToString(),
                        dtUser.Rows[0]["FirstName"].ToString() + " " + dtUser.Rows[0]["LastName"].ToString(),
                        emailFrom.Address,emailFrom.Address,"","",emailCert.Subject,emailCert.Body,orgid,userid);
                    
                }
                catch (Exception e)
                {
                    // General Exception occured, log it
                    ErrorLog objError = new ErrorLog(e, ErrorLevel.Medium, "DefaultQuiz.cs", "SendCourseCompletionCertificateEmail", "Course completion send email failed: " + certPath);
                }

               //SmtpClient client = new SmtpClient();
                //client.Send(emailCert);
                finally
                {
                    cert.ContentStream.Close();
                }
            }
        }


        public void certemail(int intUserID, int intCourseID, int intProfileID)
        {
            int orgid;

            BusinessServices.User objUser = new BusinessServices.User();
            DataTable dtUser = objUser.GetUser(intUserID);
            Int32.TryParse(dtUser.Rows[0]["OrganisationID"].ToString(), out orgid);
            string username = dtUser.Rows[0]["UserName"].ToString();

            BusinessServices.AppConfig objAppConfig = new BusinessServices.AppConfig();
            DataTable dtbAppConfig = objAppConfig.GetList();
            string strHostname = HttpContext.Current.Request.Url.Authority.ToString();
            bool isSSL = bool.Parse(dtbAppConfig.Select("Name='SSL'")[0]["Value"].ToString());
            string strUrl = null;
            if (strHostname.ToLower().Equals("127.0.0.2"))
            {
                strUrl = "https://" + strHostname;

            }
            else
            {
                strUrl = "http://" + strHostname;
            }
            strUrl = "https://" + strHostname;
            //WriteErrorLog(strUrl.ToString());
            OrganisationConfig objOrgConfig = new OrganisationConfig();
            string strCss = objOrgConfig.GetOne(orgid, "css");

            string pdfFileName = "cert_" + username + "_" + intCourseID.ToString() + "_" + DateTime.Now.ToString("yyyyMMddHHmmss") + ".pdf";
            bool status = HtmlToPdf.WKHtmlToPdf(strUrl + @"/Certificate.aspx?courseid=" + intCourseID + "&profileid=" + intProfileID + "&userid=" + intUserID + "&orgid=" + orgid + "&css=" + strCss, pdfFileName);
            string filename = "";

            if (status)
            {
                filename = HttpContext.Current.Server.MapPath(ConfigurationSettings.AppSettings["WorkingFolder"]) + "\\" + pdfFileName;
            }
            else
            {
                ErrorLog objError = new ErrorLog(new Exception("Course completion certificate"), ErrorLevel.Medium, "DefaultQuiz.cs", "GenerateCourseCompletionCertificate", "Course completion certificate generation failed: " + pdfFileName);
            }


            sendCertEmail(intUserID, intCourseID, orgid, filename);            

            try
            {
                FileInfo fileinfo = new FileInfo(filename);
                if (fileinfo.Exists)
                    File.Delete(filename);
            }
            catch (Exception e)
            {
                ErrorLog objError = new ErrorLog(e, ErrorLevel.Medium, "DefaultQuiz.cs", "DeleteCourseCompletionCertificate", "Course completion certificate deletion failed: " + pdfFileName);
            }            
        }

        //public static void WriteErrorLog(string ex)
        //{
        //    StreamWriter sw = null;
        //    try
        //    {
        //        sw = new StreamWriter(AppDomain.CurrentDomain.BaseDirectory + "\\LogFile.txt", true);
        //        sw.WriteLine(DateTime.Now.ToString() + ":" + ex);
        //        sw.Flush();
        //        sw.Close();
        //    }
        //    catch
        //    {
        //    }
        //}

        private static string getOnBehalfOfEmail()
        {
            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

            string strSQL = @"select dbo.udfUser_GetAdministratorsOnBehalfOfEmailAddress(1) as onbehalfof";

            DataTable dtOnBehalfOf = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];

            return dtOnBehalfOf.Rows[0]["onbehalfof"].ToString();

        }

		private void ApplyProfilePoints(int ProfileID, int QuizStatus, int ModuleID, int UserID)
		{
			BusinessServices.Profile objProfile = new BusinessServices.Profile();
			bool ApplyToQuiz = objProfile.QuizRequiredForPoints(ProfileID);
			bool ApplyToLesson = objProfile.LessonRequiredForPoints(ProfileID);

			// If both Quiz and Lesson need to be completed to gain points
			if(ApplyToQuiz && ApplyToLesson)
			{
				//Check if Lesson has been completed
				if((objProfile.CheckQuizComplete(UserID,ProfileID,ModuleID)) && (objProfile.CheckLessonComplete(UserID,ProfileID,ModuleID)))
				{
					if(!(objProfile.CheckLessonPointsAlreadyGivenForPeriod(ProfileID, UserID, ModuleID, 2)) || !(objProfile.CheckQuizPointsAlreadyGivenForPeriod(ProfileID, UserID, ModuleID, 2)))
					{
						objProfile.ApplyCPDPoints(ProfileID, UserID, ModuleID, 2);
					}
				}
		

			}
			else // then either quiz only or lesson only
			{
				if(ApplyToQuiz) // quiz only
				{
					// if quiz passed then apply points to user
//					if(QuizStatus == 2)
//					{
						if(!(objProfile.CheckQuizPointsAlreadyGivenForPeriod(ProfileID, UserID, ModuleID,1)))
						{
							objProfile.ApplyCPDPoints(ProfileID, UserID, ModuleID, 1);
						}
//					}
				}
				// not worried about lesson in this scenario as have just completed quiz
			}
		}

       

		#region Web Form Designer generated code
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
			this.Load += new EventHandler(Page_Load);
		}
		#endregion

	}
}
