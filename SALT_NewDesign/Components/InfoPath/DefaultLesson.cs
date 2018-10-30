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

using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.InfoPath;
using Localization;

namespace Bdw.Application.Salt.InfoPath
{

	
	/// <summary>
	/// This is the code-behind class for all lesson rendering pages (Default.aspx),
	/// </summary>
	public class DefaultLesson: PageBase
	{
		protected Literal pagTitle;
		protected System.Web.UI.WebControls.PlaceHolder plhContent;
		private const string cm_strSystemPath = "/General/InfoPath/";
    
		#region Page_Load
		private void Page_Load(object sender, System.EventArgs e)
		{
			ResourceManager.RegisterLocaleResource("ConfirmExit");
			pagTitle.Text = ResourceManager.GetString("cmnLesson");
			//1. Handle Page events
			//Fire the lesson_load event when the lesson starts
			if (!Page.IsPostBack)
			{
				this.CreateContext();

				//Fire Toolbook Lesson_Load event
				this.Lesson_Load();
			}
				//Handle page events when page is posted back (After start)
			else
			{
				this.HandlePageEvents(Request.Form["__EVENTTARGET"],Request.Form["__EVENTARGUMENT"]);
			}

			//2. Fire Toolbook Page_Load event
			this.Page_Load();

			//3. Render the page content
			this.RenderPageContent();

			Page.GetPostBackEventReference(this);
		}
		#endregion

		#region Page events
		/// <summary>
		/// Create context when the lesson starts
		/// </summary>
		private void CreateContext()
		{
			//1. Get Page Context
			LessonPageContext objContext = new LessonPageContext();
    
			objContext.Path = Request.Url.AbsolutePath.Replace("/default.aspx","");
			objContext.StartTime = DateTime.Now;
			objContext.PageIndex = 0;	
			objContext.Initialize();

			PageContext.Current = objContext;

			//2. Get the bookmark, and change the current page index if bookmark exists
			if (!PageContext.Current.IsPreviewMode)
			{
				BusinessServices.Toolbook objToolbook = new BusinessServices.Toolbook();
	            
				string strBookmarkPageID = objToolbook.GetBookmark(objContext.SessionID);

				if (strBookmarkPageID!=null)
				{
                    try
                    {
                        objContext.PageIndex = objContext.FindPageIndex(strBookmarkPageID);
                    }
                    catch (ApplicationException)
                    {
                        // if a bookmark could not be found - ignore it.
                    }
                    
				}
			}
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
			objTransform.Load( Server.MapPath(cm_strSystemPath) +"Layouts\\" + PageContext.Current.Layout  + ".xslt");

			//3. Transform
			XHelper objHelper = new XHelper(xmlDocument,objTransform);
			objHelper.AddParameter("PageID",PageContext.Current.PageID);
			objHelper.AddParameter("PageIndex",PageContext.Current.PageIndex);
			objHelper.AddParameter("PageCount",PageContext.Current.PageCount);
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

			strContent = strContent.Replace("The players involved in this scenario are:", ResourceManager.GetString("PlayersInvolved"));

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
					//The following 5 events are Page change events
				case "TableOfContents_Click":
				{
					string strPageID = eventArgument;
					int intNewPageIndex = PageContext.Current.FindPageIndex(strPageID);
					PageContext.Current.PageIndex = intNewPageIndex;
					break;
				}
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
					//The following 2 events are End lesson events
					//End the lesson, and record the current visisted page as bookmark if the current page is not the last page
				case "Exit_Click":
				{
					Lesson_End();
					break;
				}
					//End the lesson, no bookmark to be recorded
				case "Lesson_End":
				{
					Lesson_End();
					break;
				}  
				default:
				{
					break;
				}
			}
		}
		#endregion

		#region Toolbook events
		/// <summary>
		/// Lesson load event
		/// </summary>
		private void Lesson_Load()
		{
			if (!PageContext.Current.IsPreviewMode)
			{
				BusinessServices.Toolbook objToolbook = new BusinessServices.Toolbook();
				if (!objToolbook.StartLesson(PageContext.Current.SessionID))
				{
					Response.Write(ResourceManager.GetString("QuizLesson_Error"));
					Response.End();
					//throw new Exception("Lesson has already been started");
				}
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
		/// Lesson End event
		/// </summary>
		/// <remarks>
		/// A user can exit a lesson at any point by clicking on the Exit button.  Alternatively, when they reach the end of a lesson they will be presented with a screen indicating they have completed the lesson for the current module and provide a link to exit the lesson.  Any of these 2 actions will trigger the Lesson_OnExit event.
		/// The event will call the Toolbook.EndLessonSession method by passing the following parameters:
		///		.Bookmark: The bookmark is the current page ID. 
		///					If they selected the Exit button on any page other than the last page the book mark parameter will be sent. 
		///					If the user selects to exit on the last page by pressing the exit button in the toolbar a bookmark parameter should not be sent to the SALT LMS as part of the event.
		///		.Duration: The system needs to keep track of the duration of a lesson. The duration, in seconds as an integer needs to be supplied as part of the EndLessonSession method of objToolBook. 
		/// </remarks>
		private void Lesson_End()
		{
			if (!PageContext.Current.IsPreviewMode)
			{
					try
					{
						string bookmark;
						if (!PageContext.Current.IsLastPage)
						{
							bookmark = PageContext.Current.PageID;
						}
						else
						{
							bookmark=null;
						}

						TimeSpan objTimeSpan = DateTime.Now.Subtract(PageContext.Current.StartTime);

						BusinessServices.Toolbook objToolbook = new BusinessServices.Toolbook();
						objToolbook.EndLessonSession(PageContext.Current.SessionID,objTimeSpan.Seconds,bookmark);

						//obtain profileIDs for all profiles that have access to module and apply points
						BusinessServices.Profile objProfile = new BusinessServices.Profile();
						int ModuleID = Int32.Parse(Request.QueryString["ModuleID"].ToString());
						int UserID = Int32.Parse(Request.QueryString["UserID"].ToString());
						int intCourseID = Int32.Parse(Request.QueryString["CourseID"].ToString());
						int intProfileID = Int32.Parse(Request.QueryString["ProfileID"].ToString());
						DataTable dtProfiles = objProfile.ProfilesWithModuleAccess(UserID, ModuleID);
						foreach (DataRow dr in dtProfiles.Rows)
						{
							int ProfileID = int.Parse(dr["ProfileID"].ToString());
							ApplyProfilePoints(ProfileID);
						}
						Response.Redirect("/MyTraining.aspx");
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
							throw ex;
						}
					}
				}
			
		}

		private void ApplyProfilePoints(int ProfileID)
		{
			BusinessServices.Profile objProfile = new BusinessServices.Profile();
			bool ApplyToQuiz = objProfile.QuizRequiredForPoints(ProfileID);
			bool ApplyToLesson = objProfile.LessonRequiredForPoints(ProfileID);

			int ModuleID = Int32.Parse(Request.QueryString["ModuleID"].ToString());
			int UserID = Int32.Parse(Request.QueryString["UserID"].ToString());

			// If both Quiz and Lesson need to be completed to gain points
			if(ApplyToQuiz && ApplyToLesson)
			{
				//Check if quiz has been completed
				//if it has and if lesson completed then apply points to user
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
				if(ApplyToLesson) // lesson only
				{
					// if lesson completed then apply points to user
					if(!(objProfile.CheckLessonPointsAlreadyGivenForPeriod(ProfileID, UserID, ModuleID, 0)))
					{
						objProfile.ApplyCPDPoints(ProfileID, UserID, ModuleID, 0);
					}
				}
				// not worried about quiz in this scenario as have just completed lesson
			}
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
