using System;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.BusinessServices;
using System.Data.SqlTypes;

using Localization;


namespace Bdw.Application.Salt.Web.General.ToolBook
{
	/// <summary>
	/// This page accepts the form elements that are submitted to it by the
	/// Toolbook application. Depending on one of the parameters, Action ID,
	/// different tasks may be performed depending on what event has taken place
	/// within toolbook.
	/// </summary>
	public partial class ToolBookListener : System.Web.UI.Page
	{
		#region Constants identifying Toolbook Events	
		
		/// <summary>
		/// Event Id raised by toolbook to indicate that a lesson has been loaded.
		/// </summary>
		private const  int cm_intEventLessonOnLoad		= 10;

		/// <summary>
		///  Event Id raised by toolbook to indicate that a lesson page has been loaded.
		/// </summary>
		private const  int cm_intEventLessonPageOnLoad	= 11; 

		/// <summary>
		///  Event Id raised by toolbook to indicate that a lesson has been completed.
		/// </summary>
		private const  int cm_intEventLessonOnExit		= 12; 	

		/// <summary>
		///  Event Id raised by toolbook to indicate that a quiz has been loaded.
		/// </summary>
		private const  int cm_intEventQuizOnLoad         = 16;

		/// <summary>
		///  Event Id raised by toolbook to indicate that a lesson has been completed.
		/// </summary>
		private const  int  cm_intEventQuizOnScore       = 18; 
		
		#endregion

		#region Constants Identifying Toolbook Return Codes
		
		/// <summary>
		/// Response Code when everything is c_strReturnCodeOK. Toolbook can proceed.
		/// </summary>
		private const  int cm_strReturnCodeOK	                =  0;
 
		/// <summary>
		/// Return Code when Salt thinks that there is a problem. Toolbook should immediately redirect to the exit URL.
		/// </summary>
		private const  int cm_strReturnCodeCriticalError        = -1;

		/// <summary>
		/// Return Code when there may be a problem but Toolbook can continue. Toolbook should display any error message that it is sent and continue
		/// </summary>
		private const  int cm_strReturnCodeNonCriticalError     = -2; 
		#endregion

		#region Other Constants
		/// <summary>
		/// The agreaded cm_strDelimiter for comunication from SALT to Toolbook
		/// </summary>
		private const  string  cm_strDelimiter = "~|~"; 

		/// <summary>
		/// url to forward to in when exiting a quiz and viewing the results
		/// </summary>
		private const  string  cm_strReportLocation = @"Reporting/QuizSummary.aspx"; 	

		/// <summary>
		/// url to forward to in the case of an error
		/// </summary>
		private const  string  cm_strErrorLocation = @"general/Errors/ErrorHandler.aspx"; 

		/// <summary>
		/// url to forward to after finishing a quiz
		/// </summary>
		private const  string  cm_strHomeLocation = @"Default.aspx";
		#endregion

        #region Private Variables
        /// <summary>
        /// Root URL of the website
        /// </summary>
        private string m_strRootURL = Utilities.WebTool.GetHttpRoot();

		/// <summary>
		/// string used to uniquly identify a toolbook session. This is a database GUID
		/// generated by the BeforeLoad event and is not related to an ASP session
		/// </summary>
		private string strSessionID = "";
        #endregion

		#region Private Methods
		/// <summary>
		/// Entry point for the Toolbook Listener functionality
		/// No output should be sent to the toolbook except by the appropriate
		/// event handlers for LessonOnLoad etc.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
            try
            {
                ProcessEvent();
            }
            catch (Exception Ex)
            {
                // Log The error but dont let it bubble up ( so that html error messages are not displayed in toolbook
                ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(Ex, ErrorLevel.Medium, "ToolBookListener.aspx.cs", "Page_Load", "TBListener Error 0. Unknown Error. Caught" );
                OutputToToolBook(
                    cm_strReturnCodeCriticalError		// paramater 1 - ReturnCode
                    + cm_strDelimiter  + "TBListener Error 0."	// paramater 2 - Error Message
                    );
                return;
            }
		}

		/// <summary>
		/// This handles the bulk of the logic associated with a toolbook event being fired
		/// </summary>
		private void ProcessEvent()
		{
			// TODO: SQL Injection and all other attacks must be dealt with

			// Make sure nothing is sent to the browser
			// Assumption: Buffering is on (it should be on as the default in asp.net)

			// Get the Action ID and convert it into an int
			int intActionID = 0;
			string strActionID = "";
			if (Request.Form["ActionID"] != null)
			{
				strActionID = Request.Form["ActionID"].Trim();
			}
			else
			{
				// There is no Action ID !!! -> toolbook should imediatly close
				// Log the error and then send toolbook a message to close
				Exception ex = new Exception ("TBListener Error 1. The action id was missing. 'ActionID' is a manditory field and must be one of the agreed constant");
				ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(ex, ErrorLevel.Medium, "ToolBookListener.aspx.cs", "Page_Load", "Check ActionID isn't missing" );
 
				// Send toolbook a message to close
				OutputToToolBook(
					cm_strReturnCodeCriticalError 
					+ cm_strDelimiter 
					+ "TBListener Error 1. The action id was missing. 'ActionID' is a manditory field and must be one of the agreaded constant"
					+ cm_strDelimiter 
					+ m_strRootURL + cm_strErrorLocation
					+ "?errnum=1"
					);	
				return;
			}

			// Check that Action ID is numeric
			if (IsInteger(strActionID))
			{
				// Convert the Action ID to an integer
				intActionID = Convert.ToInt32(strActionID);
			}
			else
			{
				// The action id must be an integer -> toolbook should close.
				// Log the error then send toolbook a message to close
				Exception ex = new Exception ("TBListener Error 2. The action id was malformed. 'ActionID' is a manditory field");
				ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(ex, ErrorLevel.Medium, "ToolBookListener.aspx.cs", "Page_Load", "Checking ActionID Is Numeric" );
				
				// Send toolbook a message to close
				OutputToToolBook(
					cm_strReturnCodeCriticalError 
					+ cm_strDelimiter 
					+ "TBListener Error 2. The action id must be a numeric value." 
					+ cm_strDelimiter 
					+ m_strRootURL + cm_strErrorLocation
					+ "?errnum=2"
					);
				return;
			}
       
			// Get the session ID from the form object
			if (Request.Form["SessionData"] != null)
			{
				strSessionID = Request.Form["SessionData"].Trim();
			}
			else
			{
				// There is no Session Data !!! -> toolbook should imediatly close
				// Log the error and then send toolbook a message to close
				Exception ex = new Exception ("TBListener Error 3. The Session Data was missing. 'SessionData' is a manditory field");
				ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(ex, ErrorLevel.Medium, "ToolBookListener.aspx.cs", "Page_Load", "Checking SessionData isn't missing" );
				OutputToToolBook(
					cm_strReturnCodeCriticalError 
					+ cm_strDelimiter 
					+ "TBListener Error 3. The Session Data was missing. 'SessionData' is a manditory field"
					+ cm_strDelimiter 
					+ m_strRootURL + cm_strErrorLocation
					+ "?errnum=3"
					);
				return;
			}  

			// Act on the action id
			switch (intActionID)
			{
				case cm_intEventLessonOnLoad:
					Lesson_OnLoad(strSessionID, Request.Form);					
					break;
				case cm_intEventLessonPageOnLoad:
					LessonPage_OnLoad(strSessionID, Request.Form);
					break;
				case cm_intEventLessonOnExit:
                    Lesson_OnExit(strSessionID, Request.Form);
                    break;
				case cm_intEventQuizOnLoad:
                    Quiz_OnLoad(strSessionID, Request.Form); 
                    break;
				case cm_intEventQuizOnScore:
                    Quiz_OnScore(strSessionID, Request.Form);
                    break;
				default:
					// The ActionID supplied by toolbook does not corespond to a known event
					// Log this as an error and instruct toolbook to quit
					Exception Ex = new Exception ("TBListener Error 4. Unknown ActionID");
					ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(Ex,ErrorLevel.Medium,"ToolBookListener.aspx.cs","Page_Load","Act on the action id" );
				
					OutputToToolBook(
						cm_strReturnCodeCriticalError								// paramater 1 - ReturnCode
						+ cm_strDelimiter + "TBListener Error 4. Unknown ActionID"	// paramater 2 - Error Message
						);
					break;            
			}//switch
		}

		/// <summary>
		/// Lesson_OnLoad
		/// </summary>
		/// <param name="sessionID">This is the session id that maps to the lesson that is currently loading</param>
		/// <param name="postData">This is the collection of http post data variables</param>
		private void Lesson_OnLoad(SqlString sessionID, NameValueCollection postData)
		{
			try
			{
				string strPagesVisited = "";		// List of pages already visited within this lesson
				string strBookmark = "";			// Bookmarked page, if any
				string strUsersName = "";			// User's full name
				DataTable dtbPagesVisitedResults;
				BusinessServices.Toolbook objToolBook = new BusinessServices.Toolbook();

				//
				// TODO: any other validation including - dateExported, toolbookID
				//

               
				// Validate that this lesson has not been started before (based on the guid)
				// it should have no date completed
				if ( !objToolBook.StartLesson(sessionID) )
				{
					//TODO: check this redirect : Response.Redirect(c_strHomeUrl);

					OutputToToolBook(
						cm_strReturnCodeCriticalError  			// paramater 1 - ReturnCode
						+ cm_strDelimiter  + ResourceManager.GetString("Error1") //"Please make sure you do not use your browser's backwards and forwards buttons. Navigate lessons and quizzes using the buttons in the bottom right hand corner."	// paramater 2 - Error Message
						+ cm_strDelimiter + m_strRootURL + cm_strHomeLocation+ "?SessionID=" + (string) sessionID			// paramater 3 - ExitURL
						);
					return;
				}

				// Get pages visited			
				dtbPagesVisitedResults = objToolBook.GetPagesVisited(sessionID);			
				foreach(DataRow objPageVisited in dtbPagesVisitedResults.Rows)
				{
					if (strPagesVisited.Length > 0)
					{
						strPagesVisited += ",";
					}
					strPagesVisited += objPageVisited["ToolBookPageID"].ToString();
				}

				// Get any Bookmark
				strBookmark = objToolBook.GetBookmark(sessionID);

				// Get user's full name
				strUsersName = objToolBook.GetUser(sessionID);

				OutputToToolBook(
					cm_strReturnCodeOK						// paramater 1 - ReturnCode
					+ cm_strDelimiter + strPagesVisited	// paramater 2 - Pages Visited
					+ cm_strDelimiter + strBookmark		// paramater 3 - BookMark
					+ cm_strDelimiter + strUsersName        // paramater 4 - UserName
					+ cm_strDelimiter + m_strRootURL + cm_strHomeLocation+ "?SessionID=" + (string) sessionID   // paramater 5 - ExitURL
					+ cm_strDelimiter + m_strRootURL + cm_strErrorLocation + "?errnum=14"// paramater 6 - ErrorURL
					+ cm_strDelimiter + ""                  // paramater 7 - Error Message			
					);

                // scussfully started lesson
                //  - increase the session timeout
                Session.Timeout = 40;
				return;
			
			}
			catch(Exception ex)
			{
				//TODO: log this error
				OutputToToolBook(
					cm_strReturnCodeCriticalError			            // paramater 1 - ReturnCode
					+ cm_strDelimiter  + "TBListner Error 15. Unknown Error" + ex.Message// paramater 2 - Error Message
					+ cm_strDelimiter + m_strRootURL + cm_strHomeLocation// paramater 3 - ExitURL
					);
				return;
			}

		}//Lesson_OnLoad
		

		/// <summary>
		/// LessonPage_OnLoad
		/// </summary>
        /// <param name="sessionID">This is the session id that maps to the lesson that is currently loading</param>
        /// <param name="postData">This is the collection of http post data variables</param>
        private void LessonPage_OnLoad(SqlString sessionID, NameValueCollection postData)
		{
            string strToolbookPageID;

			// Verify the necessary post parameters have been supplied
			strToolbookPageID = postData.Get("TBPageID");
			if (strToolbookPageID.Length == 0)
			{
				OutputToToolBook(
					cm_strReturnCodeCriticalError		// paramater 1 - ReturnCode
					+ cm_strDelimiter  + "TBListener Error 1. Missing required parameter: TBPageID"	// paramater 2 - Error Message
					);
				return;
			}

			try
			{
				BusinessServices.Toolbook objToolBook = new BusinessServices.Toolbook();
				if ( objToolBook.RecordPageVisited(sessionID, strToolbookPageID) )
				{
					// Normal condition -> tell TB "c_strReturnCodeOK", i.e. it can continue
					OutputToToolBook(
						cm_strReturnCodeOK				// paramater 1 - ReturnCode
						+ cm_strDelimiter	+ ""		// paramater 2 - Error Message
						);
					return;
				}
				else
				{
					// Error condition
					OutputToToolBook(
						cm_strReturnCodeCriticalError	// paramater 1 - ReturnCode
						+ cm_strDelimiter  + "TBListener Error 15. " + ResourceManager.GetString("Error2") //"	// paramater 2 - Error Message
						);
					return;
				}
			}
			catch (Exception ex)
			{				
				// log the error
				ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(ex);
   
				OutputToToolBook(
					cm_strReturnCodeCriticalError		// paramater 1 - ReturnCode
					+ cm_strDelimiter + "TBListener Error 16. Unknown Error" // paramater 2 - Error Message
					);
				return;
			}
		} // LessonPage_OnLoad


		/// <summary>
		/// Lesson_OnExit
		/// </summary>
        /// <param name="sessionID">This is the session id that maps to the lesson that is currently loading</param>
        /// <param name="postData">This is the collection of http post data variables</param>
        private void Lesson_OnExit(SqlString sessionID, NameValueCollection postData)
		{
            int iDuration;
            string strDuration, strBookmark;

            // Verify the necessary post parameters have been supplied
            strDuration = postData.Get("Duration");
            if (strDuration.Length == 0)
            {
                OutputToToolBook(
                    cm_strReturnCodeCriticalError		// paramater 1 - ReturnCode
                    + cm_strDelimiter  + "TBListener Error 1. Missing required parameter: Duration"	// paramater 2 - Error Message
                    );
                return;
            }

            // Check that Duration contains a numeric value
            if (IsInteger(strDuration))
            {
                iDuration = Convert.ToInt32(strDuration);
            }
            else
            {
                OutputToToolBook(
                    cm_strReturnCodeCriticalError		// paramater 1 - ReturnCode
                    + cm_strDelimiter  + "TBListener Error 1. Invalid parameter type: Duration"	// paramater 2 - Error Message
                    );
                return;
            }

            // Bookmark is optionial
            strBookmark = postData.Get("Bookmark");

            try
			{
				BusinessServices.Toolbook objToolBook = new BusinessServices.Toolbook();
				if ( objToolBook.EndLessonSession(sessionID, iDuration, strBookmark) )
				{   
                    // Normal condition -> tell TB "cm_strReturnCodeOK", i.e. it can continue
					OutputToToolBook(
						cm_strReturnCodeOK			// paramater 1 - ReturnCode
						+ cm_strDelimiter	+ ""	// paramater 2 - Error Message
						);
					return;
				}
				else
				{   
                    // log the error
                    Exception Ex = new Exception ("TBListener Error 17.  The lesson_OnExit event for session '" + (string) sessionID + "' has failed. One reason for this may be that the lesson has already ended and toolbook has firing the event twice. Except for this.");
                    ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(Ex,ErrorLevel.Medium,"ToolBookListener.aspx.cs","lesson_OnExit","TBListener Error 17. The Stored proc prcLessonSession_EndLesson returned false - indicating that it could not or has already finished this lesson" );
				
                    
                    // error condition -> TB is closing any way so no need to send a critical error, just advise user that there is a problem
                    
					OutputToToolBook(
						cm_strReturnCodeNonCriticalError // paramater 1 - ReturnCode
						+ cm_strDelimiter  + "TBListener Error 17. " + ResourceManager.GetString("Error3") //There was a problem recording the finishing of your lesson, details may not have been saved :-("	// paramater 2 - Error Message
						);
					return;
				}
			}
			catch (Exception ex)
			{
				// log the error
				ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(ex);
				OutputToToolBook(
					cm_strReturnCodeCriticalError	 // paramater 1 - ReturnCode
					+ cm_strDelimiter + "TBListener Error 18. Unknown Error" // paramater 2 - Error Message
					);
				return;
			}
			
		}//Lesson_OnExit


		/// <summary>
		/// This method is called when a Quiz is Loaded.
		/// It looks up various pieces of data from the Salt tables
		/// before returning them to the Toolbook application
		/// </summary>
        /// <param name="sessionID">This is the session id that maps to the lesson that is currently loading</param>
        /// <param name="postData">This is the collection of http post data variables</param>
        private void Quiz_OnLoad(string sessionID, NameValueCollection postData)
		{
            string strToolbookID;		// the toolbook ID as per the toolbook application
            string strUserName;			// the username
			int intUserID;				// User ID of the current User
			int intModuleID;			// Module ID that this quiz belongs to
			int intQuizID;				// QuizID that the user is currently sitting
			int intPassMark;			// The passmark for the quiz that the user is currently sitting
			int intUnitID;				// The unit ID of the current user
			bool blnError;				// Boolean flag indicating the presence of an error

            // Verify the necessary post parameters have been supplied
            strToolbookID = postData.Get("ToolbookID");
            if (strToolbookID.Length == 0)
            {
                OutputToToolBook(
                    cm_strReturnCodeCriticalError                                                        // paramater 1 - ReturnCode
                    + cm_strDelimiter  + "TBListener Error 1. Missing required parameter: ToolbookID"    // paramater 2 - Error Message
                    );
                return;
            }
			
			// toolbook object used to return necessary information below..
            BusinessServices.Toolbook objToolBook = new BusinessServices.Toolbook();
			
			// Get UserName and ID
			strUserName			= objToolBook.GetUser(sessionID);
			intUserID			= objToolBook.GetUserIDBySessionID(sessionID);
			
			// Get Module ID and UserID to determine Access
			intModuleID			= objToolBook.GetModuleIDBySessionID(sessionID);
			intUnitID			= objToolBook.GetUnitIDByUserID(intUserID);
			
			// Get Quiz ID, Number of Quiz Questions and PassMark
			intQuizID			= objToolBook.GetQuizIDBySessionID(sessionID);
			intPassMark			= objToolBook.GetQuizPassMark(intUnitID, intModuleID);
			
			// Assume no errors to start with.
			blnError = false;

			// If no username
			if (strUserName.Length == 0) 
			{
				OutputToToolBook(
					cm_strReturnCodeCriticalError 
					+ cm_strDelimiter 
					+ "TBListener Error 5. The User Name could not be found" 
					+ cm_strDelimiter 
					+ m_strRootURL + cm_strErrorLocation 
					+ "?errnum=5"
					);
				blnError = true;
			}

			// If no Quiz ID
			if (intQuizID <= 0) 
			{
				OutputToToolBook(
					cm_strReturnCodeCriticalError 
					+ cm_strDelimiter 
					+ "TBListener Error 6. The Quiz ID could not be found" 
					+ cm_strDelimiter 
					+ m_strRootURL + cm_strErrorLocation 
					+ "?errnum=6"
					);
				blnError = true;
			}

			// If no module ID
			if (intModuleID <= 0) 
			{
				OutputToToolBook(
					cm_strReturnCodeCriticalError 
					+ cm_strDelimiter 
					+ "TBListener Error 8. The Module ID Could not be found" 
					+ cm_strDelimiter 
					+ m_strRootURL + cm_strErrorLocation 
					+ "?errnum=8"
					);
				blnError = true;
			}

			// If no Unit ID
			if (intUnitID <= 0) 
			{
				OutputToToolBook(
					cm_strReturnCodeCriticalError 
					+ cm_strDelimiter 
					+ "TBListener Error 9. The Unit ID Could not be found" 
					+ cm_strDelimiter 
					+ m_strRootURL + cm_strErrorLocation 
					+ "?errnum=9"
					);
				blnError = true;
			}
			// If no error has occurred
			if (!blnError)
			{
				// Start the quiz
				if (objToolBook.StartQuiz (sessionID))
				{
					// Let Toolbook know that we have successfully started the quiz
					OutputToToolBook(
						cm_strReturnCodeOK 										// paramater 1 - ReturnCode
						+ cm_strDelimiter + intPassMark							// paramater 3 - PassMark
						+ cm_strDelimiter + strUserName							// paramater 4 - User Name
						+ cm_strDelimiter + m_strRootURL + cm_strHomeLocation  + "?SessionID=" + sessionID // paramater 5 - Exit Home URL
						+ cm_strDelimiter + m_strRootURL + cm_strReportLocation + "?QuizSessionID=" + sessionID // paramater 6 - Exit Report URL
						+ cm_strDelimiter + m_strRootURL + cm_strErrorLocation	// paramater 7 - Error URL
						+ cm_strDelimiter + ""									// paramater 8 - Error Message			
						);
                    return;
				}
				else
				{

					OutputToToolBook(
						cm_strReturnCodeCriticalError 
						+ cm_strDelimiter + ResourceManager.GetString("Error1") //"Please make sure you do not use your browser's backwards and forwards buttons. Navigate lessons and quizzes using the buttons in the bottom right hand corner." 
						+ cm_strDelimiter + m_strRootURL + cm_strHomeLocation  + "?errnum=2" //cm_strErrorLocation
						);
                    return;
                }
			}
		} // Quiz_OnLoad


		/// <summary>
		/// This event is called when a quiz is completed. 
		/// It updates the QuizSession table in Salt with information
		/// provided by the Toolbook application. This information is supplied
		/// via form elements that are posted to this page.
		/// </summary>
        /// <param name="sessionID">This is the session id that maps to the lesson that is currently loading</param>
        /// <param name="postData">This is the collection of http post data variables</param>
        private void Quiz_OnScore(string sessionID, NameValueCollection postData)
		{
            string strDuration;			// This isnt currently implemented in toolbook
            string strResponses;		// The responses given by the user
            string strScore;			// The score of the user
            int intScore;		    	// The score of the user answering the quiz
            int intDuration;            // The uration the user spent doing the quiz

            // Verify the necessary post parameters have been supplied
            strResponses = postData.Get("Responses");
            if (strResponses.Length == 0)
            {
                OutputToToolBook(
                    cm_strReturnCodeCriticalError		// paramater 1 - ReturnCode
                    + cm_strDelimiter  + "TBListener Error 1. Missing required parameter: Responses"	// paramater 2 - Error Message
                    );
                return;
            }

			// Get the duration
            strDuration = postData.Get("Duration");
            if (strDuration.Length == 0)
            {
                OutputToToolBook(
                    cm_strReturnCodeCriticalError		// paramater 1 - ReturnCode
                    + cm_strDelimiter  + "TBListener Error 1. Missing required parameter: Duration"	// paramater 2 - Error Message
                    );
                return;
            }

			// Get the score
            strScore = postData.Get("Score");
            if (strDuration.Length == 0)
            {
                OutputToToolBook(
                    cm_strReturnCodeCriticalError		// paramater 1 - ReturnCode
                    + cm_strDelimiter  + "TBListener Error 1. Missing required parameter: Duration"	// paramater 2 - Error Message
                    );
                return;
            }

            // Check that Duration and Score contain numeric values
            if ( IsInteger(strDuration) && IsInteger(strScore) )
            {
                intDuration = Convert.ToInt32(strDuration);
                intScore = Convert.ToInt32(strScore);
            }
            else
            {
                OutputToToolBook(
                    cm_strReturnCodeCriticalError		// paramater 1 - ReturnCode
                    + cm_strDelimiter  + "TBListener Error 1. Invalid parameter type: Duration or Score"	// paramater 2 - Error Message
                    );
                return;
            }

            try
			{
				// All Answers To All Questions
				string[] aAnswersAllQuestions;

				// Answers to one particular question
				string[] aAnswersOneQuestions;

				// QuizQuestionID
				string strQuestionToolbookPageID;

				int intFirstMarker;
				int intSecondMarker;
				BusinessServices.Toolbook objToolboook = new Toolbook();
				
				// Remove one of the ['s
				strResponses = strResponses.Replace ("[","");

				// Use the other ] as a delimiter to split the string to an array.
				strResponses = strResponses.Substring(0, strResponses.Length-1 ); 
			
				aAnswersAllQuestions = strResponses.Split (']');
				foreach (string strAnswer in aAnswersAllQuestions)
				{	
					// Find first opening square bracket
					intFirstMarker = strAnswer.IndexOf ("{");

					// Find the matching closing bracket.
					intSecondMarker = strAnswer.IndexOf ("}");
				
					// This turns the string "Q1{1,2,3}" into an array containing '1' '2' and '3'
					aAnswersOneQuestions = strAnswer.Substring (intFirstMarker+1,intSecondMarker-intFirstMarker-1).Split(',');

					// Get the Question ID from the start of the string, ignore the Q at the start.
					strQuestionToolbookPageID = strAnswer.Substring(0, intFirstMarker);
					objToolboook.CreateQuizQuestionAudit (sessionID, strQuestionToolbookPageID);
					
					// Iterate through each Answer for this question and add it to the salt database.
					foreach (string strQuizAnswer in aAnswersOneQuestions)
					{
                        // Only add the answer if there is a value provided
                        if (strQuizAnswer.Length > 0)
                        {
                            objToolboook.CreateQuizAnswerAudit(sessionID, strQuestionToolbookPageID, Convert.ToInt32(strQuizAnswer));
                        }
					}
                }

                // Record that the Quiz has finished
				try
				{
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

					//objToolboook.EndQuizSession(sessionID, intDuration, intScore);
					endQuizInfo = objToolboook.BeforeQuizEnd(sessionID,intDuration,intScore);
					
					DataRow tmpRow = endQuizInfo.Rows[0];
					intUserID = Int32.Parse(tmpRow["UserID"].ToString());
					intQuizID = Int32.Parse(tmpRow["QuizID"].ToString());
					intPassMark = Int32.Parse(tmpRow["PassMark"].ToString());
					intUnitID = Int32.Parse(tmpRow["UnitID"].ToString());
					intModuleID = Int32.Parse(tmpRow["ModuleID"].ToString());
					intQuizFrequency = Int32.Parse(tmpRow["QuizFrequency"].ToString());
					intOldCourseStatus = Int32.Parse(tmpRow["OldCourseStatus"].ToString());
					intNewCourseStatus = Int32.Parse(tmpRow["NewCourseStatus"].ToString());
					intNewQuizStatus = Int32.Parse(tmpRow["NewQuizStatus"].ToString());
					intCourseID = Int32.Parse(tmpRow["CourseID"].ToString());
					dtmQuizCompletionDate = tmpRow["QuizCompletionDate"] == null ? DateTime.Parse("1/1/1900"): (DateTime)tmpRow["QuizCompletionDate"];


					objToolboook.EndQuizSession_UpdateTables(sessionID, intDuration, intScore, intUserID, intQuizID, intPassMark, intUnitID, intModuleID, intCourseID, intOldCourseStatus, intNewQuizStatus, intNewCourseStatus, intQuizFrequency, dtmQuizCompletionDate);
				}
				catch(Exception ex)
				{
					ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(ex, ErrorLevel.Medium, "ToolBookListener.aspx.cs", "Quiz_OnScore", "Failed in objToolboook.EndQuizSession" );
					throw (ex);
				}

				// Everything has been saved to Salt successfully.
				// Send OK Return code to Toolbook to indicate completion
				OutputToToolBook(
					cm_strReturnCodeOK				// paramater 1 - ReturnCode
					+ cm_strDelimiter	+ ""		// paramater 2 - Error Message
					);
			}
			catch (Exception ex)
			{				
				ErrorHandler.ErrorLog objError = new ErrorHandler.ErrorLog(ex, ErrorLevel.Medium, "ToolBookListener.aspx.cs", "Quiz_OnScore","");
			}
		} // Quiz_OnScore

		/// <summary>
		/// OutputToToolBook
		/// </summary>
		/// <param name="OutputString"></param>
		private void OutputToToolBook(string OutputString)
		{
			Response.Clear();			
            Response.Write(OutputString);
			Response.Flush();
		}//OutputToToolBook


		/// <summary>
		/// This function returns a boolean value indicating whether a string value can be converted to an
		/// integer.
		/// </summary>
		/// <param name="ValueToCheck">The string value to check</param>
		/// <returns>Return True or False</returns>
		private static bool IsInteger(string ValueToCheck)
		{        
			try
			{
				Convert.ToInt32(ValueToCheck);
				return true;
			} 
			catch 
			{
				return false;
			}
       
		} //IsInteger

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
	}
}