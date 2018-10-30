//===============================================================================
//
//	Salt Business Service Layer
//
//	Bdw.Application.Salt.Data.Toolbook
//
//  Retrieves and update toolbook related information
//
//===============================================================================
using System;
using System.Data;
using System.Data.SqlTypes;
using Bdw.Application.Salt.Data;

namespace Bdw.Application.Salt.BusinessServices
{
    /// <summary>
    /// Retrieves and updates toolbook information.
    /// </summary>
    /// <remarks>
    /// Assumptions: None
    /// Notes: 
    /// Author: All Developers
    /// Changes:
    /// </remarks>
	public class Toolbook : Bdw.Application.Salt.Data.DatabaseService, Bdw.Application.Salt.BusinessServices.IContentObjectCommunication
	{
		
		#region constructors
		
        /// <summary>
        /// This object represents the toolbooks and their associated functionality.
        /// </summary>
		public Toolbook()
		{
			//
			// TODO: Add constructor logic here
			//
		}
		#endregion		

		#region Public Methods

		/// <summary>
		/// This method loads the new XML content into the relevant tables.
		/// </summary>
		/// <param name="contentXml">A string containg the new xml content</param>
		/// <param name="userID">The userID of the user uploading this new content.</param>
		/// <param name="moduleID">The module for which this content is to be used.</param>
		/// <param name="courseID">The course for which this content is to be used.</param>
		/// <param name="toolLocation">The Location (path) for this toolbook</param>
		/// <returns>
		/// A Dataset containing information regarding the success of the upload. For
		/// further information please see the stored procedure.
		/// </returns>
		public  DataSet UploadContentObjectXML(SqlString contentXml,SqlInt32 userID,SqlInt32 moduleID, SqlInt32 courseID, SqlString toolLocation)
		{
			using(StoredProcedure sp = new StoredProcedure("prcToolbook_Import",
					  StoredProcedure.CreateInputParam("@strXMLData", SqlDbType.NText , contentXml),
					  StoredProcedure.CreateInputParam("@intUserID",SqlDbType.Int , userID),
					  StoredProcedure.CreateInputParam("@intModuleID",SqlDbType.Int , moduleID),
					  StoredProcedure.CreateInputParam("@intCourseID",SqlDbType.Int , courseID),
					  StoredProcedure.CreateInputParam("@strToolLocation",SqlDbType.VarChar,500 , toolLocation)
                                                                                                   ))
			{
				return sp.ExecuteDataSet();
			}
		} // UploadToolbookXML

		/// <summary>
		/// This method previews the new XML content without loading it into the database.
		/// It validates that the xml content is valid in compared to the existing salt database content.
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Kneale 3/02/2004
		/// Changes:
		/// </remarks>
		/// <param name="contentXml">A string containg the new xml content</param>
		/// <param name="moduleID">The module for which this content is to be used.</param>
		/// <returns>
		/// DataSet containing the results of the attempted validation. See
		/// See the stored procedure for more information
		/// </returns>
		public  DataSet UploadContentObjectXMLPreview(string contentXml,int moduleID,int userID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcToolbook_Preview",
					  StoredProcedure.CreateInputParam("@strXMLData", SqlDbType.Text , contentXml),
                      StoredProcedure.CreateInputParam("@intModuleID", SqlDbType.Int, moduleID),
                	  StoredProcedure.CreateInputParam("@intUserID",SqlDbType.Int , userID)
))
			{
				return sp.ExecuteDataSet();
			}
		} //UploadToolbookXMLPreview
		
		/// <summary>
		/// This method creates a new quiz audit entry that indicates a person has attempted a quiz.
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Kneale 3/02/2004
		/// Changes:
		/// </remarks>
		/// <param name="sessionID">The session id of the Quiz Session</param>
		/// <param name="toolbookPageID">The toolbook Page ID of the quiz attempted by the person</param>
		public void CreateQuizQuestionAudit(string sessionID, string toolbookPageID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcQuizSession_CreateQuizAudit",
					  StoredProcedure.CreateInputParam("@strQuizSessionID", SqlDbType.VarChar,50 , sessionID),
					  StoredProcedure.CreateInputParam("@strToolbookPageID",SqlDbType.VarChar,50 , toolbookPageID)
						  ))
			{
				sp.ExecuteNonQuery ();
			}
		} //CreateQuizQuestionAudit

		/// <summary>
		/// This method creates a new QuizAnswer audit entry that indicates a person has answered a question.
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Kneale 3/02/2004
		/// Changes:
		/// </remarks>
		/// <param name="sessionID">The session id of the Quiz Session</param>
		/// <param name="toolbookPageID">The toolbook Page ID of the question attempted by the person</param>
		/// <param name="quizAnswerID">The answer selected by the person</param>
		public void CreateQuizAnswerAudit(string sessionID, string toolbookPageID, int quizAnswerID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcQuizSession_CreateQuizAnswerAudit",
					  StoredProcedure.CreateInputParam("@strQuizSessionID", SqlDbType.VarChar,50 , sessionID),
					  StoredProcedure.CreateInputParam("@strToolbookPageID", SqlDbType.VarChar,50 , toolbookPageID),
					  StoredProcedure.CreateInputParam("@intToolbookAnswerID", SqlDbType.Int , quizAnswerID)
						 ))
			{
				sp.ExecuteNonQuery ();
			}
		} //CreateQuizAnswerAudit
		
		/// <summary>
		/// This method creates a new QuizAnswer audit entry that indicates a person has answered a question.
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Kneale 3/02/2004
		/// Changes:
		/// </remarks>
		/// <param name="quizSessionID">The session id of the Quiz Session, unique GUID that identifies this toolbook quiz session</param>
		/// <param name="duration">The duration in seconds of the quiz as messured by toolbook</param>
		/// <param name="score">The score as mesured by toolbook</param>
		public void EndQuizSession(string quizSessionID, int duration, int score)
		{
			using(StoredProcedure sp = new StoredProcedure("prcQuizSession_EndQuiz",
					  StoredProcedure.CreateInputParam("@quizSessionID", SqlDbType.VarChar,50 , quizSessionID),
					  StoredProcedure.CreateInputParam("@duration", SqlDbType.Int , duration),
					  StoredProcedure.CreateInputParam("@score", SqlDbType.Int , score)
						 ))
			{
				sp.ExecuteNonQuery ();
			}
		} //EndQuizSessionq

		/// <summary>
		/// This method returns the ModuleID of the module that the session is linked to.
		/// </summary>
		/// <remarks>
		/// Assumptions:None
		/// Notes:
		/// Author: Peter Kneale, 05/02/2004
		/// Changes:
		/// </remarks>
		/// <param name="sessionID">ID of the session.</param>
		/// <returns>ID of the associated module.</returns>
		public int GetModuleIDBySessionID(string sessionID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcQuiz_GetModuleIDBySessionID",
						StoredProcedure.CreateInputParam("@sessionID", SqlDbType.VarChar, 50, sessionID)
						))
			{
				return Convert.ToInt32 (sp.ExecuteScalar());
			}
		} //GetModuleIDBySessionID



		/// <summary>
		/// BeforeQuizStart - Prepears to start a unique quiz - returns a GUID
		/// </summary>
		/// <returns>DataTable containing values necessary to launch toolbook.</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Kneale, 03/02/2004
		/// Changes:
		/// </remarks>
		/// <param name="userID">The User attempting the Quiz.</param>
		/// <param name="moduleID">The module the User is attempting.</param>
		public DataTable BeforeQuizStart(int userID, int moduleID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcQuizSession_BeforeStartQuiz",
					  StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID),
					  StoredProcedure.CreateInputParam("@moduleID", SqlDbType.Int, moduleID)
					  ))
			{
				return sp.ExecuteTable();
			}
		} //BeforeQuizStart

        /// <summary>
        /// BeforeQuizStart - Check if this is adaptive course
        /// </remarks>
        /// <param name="userID">The User attempting the Quiz.</param>
        /// <param name="moduleID">The module the User is attempting.</param>
        public DataTable CheckAdaptiveCourse(int moduleID)
        {
            using (StoredProcedure sp = new StoredProcedure("prcUser_AdaptiveAccess",
                      StoredProcedure.CreateInputParam("@moduleID", SqlDbType.Int, moduleID)
                      ))
            {
                return sp.ExecuteTable();
            }
        } //BeforeQuizStart



		/// <summary>
		/// Starts a quiz session for a particular user attempting a particular quiz.
		/// </summary>
		/// <returns> A boolean value indicating whether the session started successfully or not.
		/// </returns>
		/// <remarks>
		/// Assumptions:None
		/// Notes:
		/// Author: Peter Kneale, 05/02/2004
		/// Changes:
		/// </remarks>
		/// <param name="QuizSessionID">User ID of the user starting the quiz.</param>
		public bool StartQuiz(string QuizSessionID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcQuizSession_StartQuiz",
					  StoredProcedure.CreateInputParam("@QuizSessionID", SqlDbType.VarChar, 50, QuizSessionID)
					  ))
			{
				return (Convert.ToBoolean (sp.ExecuteScalar ()));
			}
		} //StartQuiz

		
		
		/// <summary>
		/// This method returns a Quiz ID from a ToolBook ID
		/// </summary>
		/// <remarks>
		/// Assumptions:None
		/// Notes:
		/// Author: Peter Kneale, 05/02/2004
		/// Changes:
		/// </remarks>
		/// <param name="sessionID">The session ID from which to get the Quiz ID</param>
		/// <returns>QuizID</returns>
		public int GetQuizIDBySessionID(string sessionID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcQuizSession_GetQuizIDBySessionID",
					  StoredProcedure.CreateInputParam("@strSessionID", SqlDbType.VarChar, 50, sessionID)
					  ))
			{
				return Convert.ToInt32 (sp.ExecuteScalar());
			}
		} //GetQuizIDBySessionID

		/// <summary>
		/// This method returns a users User ID based on a current Sesion Id.
		/// </summary>
		/// <remarks>
		/// Assumptions:None
		/// Notes:
		/// Author: Peter Kneale, 05/02/2004
		/// Changes:
		/// </remarks>
		/// <param name="SessionID">The session ID from which to get the User ID</param>
		/// <returns>UserID of the user matching the sessionid </returns>
		public int GetUserIDBySessionID(string SessionID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUser_GetUserIDBySessionID",
					  StoredProcedure.CreateInputParam("@SessionID", SqlDbType.VarChar,50, SessionID)
					  ))
			{
				return Convert.ToInt32 (sp.ExecuteScalar());
			}
		}	//GetUserIDBySessionID


		/// <summary>
		/// This method returns a users Unit ID based on their UserID
		/// </summary>
		/// <remarks>
		/// Assumptions:None
		/// Notes:
		/// Author: Peter Kneale, 05/02/2004
		/// Changes:
		/// </remarks>
		/// <param name="UserID">UserID of desired user.</param>
		/// <returns>UnitID of the Unit that the user belongs to.</returns>
		public int GetUnitIDByUserID(int UserID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUser_GetUnitIDByUserID",
					  StoredProcedure.CreateInputParam("@UserId", SqlDbType.Int , UserID)
					  ))
			{
				return Convert.ToInt32 (sp.ExecuteScalar());
			}
		}	//GetUnitIDByUserID

		/// <summary>
		/// Gets the pass mark of the quiz that belongs to the specified Unit and Module.
		/// </summary>
		/// <remarks>
		/// Assumptions:None
		/// Notes:
		/// Author: Peter Kneale, 05/02/2004
		/// Changes:
		/// </remarks>
		/// <param name="UnitID">UnitID that the quiz belongs to.</param>
		/// <param name="ModuleID">ModuleID that the quiz belongs to.</param>
		/// <returns></returns>
		public int GetQuizPassMark(int UnitID, int ModuleID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcQuiz_GetPassMark",
					  StoredProcedure.CreateInputParam("@UnitID", SqlDbType.Int , UnitID),
					  StoredProcedure.CreateInputParam("@ModuleID", SqlDbType.Int , ModuleID)
						  ))
			{
				return Convert.ToInt32 (sp.ExecuteScalar());
			}
		} //GetQuizPassMark


		/// <summary>
		/// This method returns the number of questions in a particular quiz.
		/// </summary>
		/// <remarks>
		/// Assumptions:None
		/// Notes:
		/// Author: Peter Kneale, 05/02/2004
		/// Changes:
		/// </remarks>
		/// <param name="QuizID">QuizID of the Quiz that we wish to could the questions in.</param>
		/// <returns>The number of questions.</returns>
		public int GetQuizQuestionsCountByQuizID(int QuizID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcQuiz_CountQuestions",
					  StoredProcedure.CreateInputParam("@QuizID", SqlDbType.Int, QuizID)
					  ))
			{
				return Convert.ToInt32 (sp.ExecuteScalar());
			}
		}	//GetQuizQuestionsCountByQuizID


		/// <summary>
		/// ValidateAccess
		/// </summary>
		/// <returns>Returns true if a user can access a module.</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Stephen Kennedy-Clark, 03/02/0/2004
		/// Changes:
		/// </remarks>
		/// <param name="userID">integer containg the user id</param>
		/// <param name="moduleID">integer containg the module id</param>
		public bool ValidateAccess(int userID, int moduleID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUserModuleAccess_Validate",
					  StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID),
					  StoredProcedure.CreateInputParam("@moduleID", SqlDbType.Int, moduleID)
					  ))
			{
				return (Convert.ToBoolean(sp.ExecuteScalar()));
			}
		} //ValidateAccess

		/// <summary>
		/// BeforeLessonStart - Prepears to start a unique lesson - returns a GUID
		/// </summary>
		/// <returns>DataTable containg the GUID for the session</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Stephen Kennedy-Clark, 03/02/0/2004
		/// Changes:
		/// </remarks>
		/// <param name="userID">integer containg the user id</param>
		/// <param name="moduleID">integer containg the module id</param>
		public DataTable BeforeLessonStart(int userID, int moduleID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcLessonSession_BeforeStartLesson",
					  StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID),
					  StoredProcedure.CreateInputParam("@moduleID", SqlDbType.Int, moduleID)
					  ))
			{
				return sp.ExecuteTable();
			}
		} //BeforeLessonStart

		/// <summary>
		/// StartLesson - updates a prepared lesson, starts it if it has not already been started and return true, else return false
		/// </summary>
		/// <returns>Returns true if a session has not been strated before</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes:
		///  this function is to ensure that the lesson onload event only fires once
		///  for each toolbook - and that no attempt is made (ie hitting the 
		///  back / forward button) to restart a lesson
		/// Author: Stephen Kennedy-Clark, 03/02/0/2004
		/// Changes:
		/// </remarks>
		/// <param name="sessionID">String containg the session GUID</param>
		public bool StartLesson(SqlString sessionID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcLessonSession_StartLesson",
					  StoredProcedure.CreateInputParam("@lessonSessionID", SqlDbType.VarChar, 50 , sessionID)))
			{
				return Convert.ToBoolean(sp.ExecuteScalar());
			}
		} //StartLesson
		
		/// <summary>
		/// SessionIsUnique
		/// </summary>
		/// <returns>Returns true if a session has not been used before</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes:
		///  this function is to ensure that the lesson onload event only fires once
		///  for each toolbook - and that no attempt is made (ie hitting the 
		///  back / forward button) to restart a lesson
		/// Author: Stephen Kennedy-Clark, 03/02/0/2004
		/// Changes:
		/// </remarks>
		/// <param name="sessionID">String containg the session GUID</param>
		public bool SessionIsUnique(SqlString sessionID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcLessonQuizSession_CheckSessionUnique",
					  StoredProcedure.CreateInputParam("@sessionID", SqlDbType.VarChar, 50, sessionID)))
			{
				return Convert.ToBoolean(sp.ExecuteScalar());
			}
		} //SessionIsUnique

		/// <summary>
		/// GetPagesVisited
		/// </summary>
		/// <returns>Returns a data table of pages that the user has visited in this toolbook</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes:
		///  this function is to ensure that the lesson onload event only fires once
		///  for each toolbook - and that no attempt is made (ie hitting the 
		///  back / forward button) to restart a lesson
		/// Author: Stephen Kennedy-Clark, 03/02/0/2004
		/// Changes:
		/// </remarks>
		/// <param name="sessionID">String containg the session GUID</param>
		public DataTable GetPagesVisited(SqlString sessionID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcLessonPageAudit_GetPagesVisitedBySessionID",
					  StoredProcedure.CreateInputParam("@lessonSessionID", SqlDbType.VarChar, 50, sessionID)))
			{
				return sp.ExecuteTable();
			}
		} //GetPagesVisited


		/// <summary>
		/// RecordPageVisited
		/// </summary>
		/// <returns>Returns boolean true if the lesson was not already finished and the page visited exists in the toolbook</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes:
		///  This function records the fact that a student has visited a page in a toolbook
		///  it requires the toolbook pageid and the session id
		///  The underlying stored proc will not accept the page if the lesson has already been finished
		///  or if salt cannot match the pageID to a page in the lesson
		/// Author: Stephen Kennedy-Clark, 03/02/0/2004
		/// Changes:
		/// </remarks>
		/// <param name="sessionID">String containg the session GUID</param>
		/// <param name="pageID">Integer containg the page id</param>
		public bool RecordPageVisited(SqlString sessionID, SqlString pageID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcLessonPageAudit_InsertPageVisited",
					  StoredProcedure.CreateInputParam("@lessonSessionID", SqlDbType.VarChar,50, sessionID),
					  StoredProcedure.CreateInputParam("@toolBookPageID", SqlDbType.VarChar, 50, pageID)
					  ))
			{
				return Convert.ToBoolean(sp.ExecuteScalar());
			}
		} //RecordPageVisited
		
		/// <summary>
		/// GetBookmark
		/// </summary>
		/// <returns>Returns the ToolBookPageID for the page in the current toolbook that a user has set</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes:
		/// Author: Stephen Kennedy-Clark, 03/02/0/2004
		/// Changes:
		/// </remarks>
		/// <param name="sessionID">String containg the session GUID</param>
		public string GetBookmark(SqlString sessionID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcBookMark_GetBookMarkBySessionID",
					  StoredProcedure.CreateInputParam("@lessonSessionID", SqlDbType.VarChar,50,  sessionID)))
			{
				return (string) sp.ExecuteScalar();
			}
		} //GetBookmark

		/// <summary>
		/// EndLessonSession
		/// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes:
        /// Author: Stephen Kennedy-Clark, 03/02/0/2004
        /// Changes:
        /// </remarks>
		/// <param name="sessionID">String containg the session GUID</param>
		/// <param name="duration">Integer - The number of seconds that the lesson was running</param>
		/// <param name="bookmark">string containg teh toolbook page id to be bookmarked</param>
		/// <returns>Return true if the lesson was ended sucessfully</returns>
		public bool EndLessonSession(SqlString sessionID, SqlInt32 duration, SqlString bookmark)
		{
			using(StoredProcedure sp = new StoredProcedure("prcLessonSession_EndLesson",
					  StoredProcedure.CreateInputParam("@lessonSessionID", SqlDbType.VarChar, 50, sessionID),
					  StoredProcedure.CreateInputParam("@duration", SqlDbType.Int, duration),
					  StoredProcedure.CreateInputParam("@bookmark", SqlDbType.VarChar, 50, bookmark)
					  ))
			{
				return Convert.ToBoolean(sp.ExecuteScalar());
			}
		} //EndLessonSession

		/// <summary>
		/// GetUser
		/// </summary>
		/// <returns>
		/// Returns the user's first and last names concatenated with a space
		/// </returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes:
		/// Author: Stephen Kennedy-Clark, 03/02/0/2004
		/// Changes:
		/// </remarks>
		/// <param name="sessionID">String containg the session GUID</param>
		public string GetUser(SqlString sessionID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUser_GetNameBySessionID",
						StoredProcedure.CreateInputParam("@sessionID", SqlDbType.VarChar, 50, sessionID)))
			{
				return (string) sp.ExecuteScalar();
			}
		} //GetUser


        /// <summary>
        /// prcQuiz_GetScore
        /// </summary>
        /// <returns>
        /// Returns the user score based on their session id
        /// </returns>
        /// <remarks>
        /// Assumptions: None
        /// Notes:
        /// Author: Peter Kneale, 24 / 2 / 05
        /// Changes:
        /// </remarks>
        /// <param name="sessionID">String containg the session GUID</param>
        public int GetQuizScore(SqlString sessionID)
        {
            using(StoredProcedure sp = new StoredProcedure("prcQuiz_GetScore",
                      StoredProcedure.CreateInputParam("@QuizSessionID", SqlDbType.VarChar, 50, sessionID)))
            {
                return (int) sp.ExecuteScalar();
            }
        } //GetUser

		/// <summary>
		/// BeforeQuizEnd - Prepears to end a unique quiz 
		/// </summary>
		/// <returns>DataTable containing values necessary to end a quiz.</returns>
		/// <remarks>
		/// Assumptions: 
		/// Notes: 
		/// Author: Li Zhang, 17/10/2005
		/// Changes:
		/// </remarks>
		/// <param name="quizSessionID">The unique quiz session ID.</param>
		/// <param name="duration">The duration in seconds.</param>
		/// <param name="score">The score as measured by toolbook</param>
		public DataTable BeforeQuizEnd(string quizSessionID, int duration, int score)
		{
			using(StoredProcedure sp = new StoredProcedure("prcQuizSession_GetEndQuizInfo",
					  StoredProcedure.CreateInputParam("@quizSessionID", SqlDbType.VarChar,50 , quizSessionID),
					  StoredProcedure.CreateInputParam("@duration", SqlDbType.Int , duration),
					  StoredProcedure.CreateInputParam("@score", SqlDbType.Int , score)
					  ))
			{
				return sp.ExecuteTable();
			}
		}
        public DataTable BeforeQuizEnd2(int intUserID, int intModuleID, int duration, int score)
        {
            using (StoredProcedure sp = new StoredProcedure("prcQuizSession_GetEndQuizInfo2",
                      StoredProcedure.CreateInputParam("@intUserID", SqlDbType.Int, intUserID),
                      StoredProcedure.CreateInputParam("@intModuleID", SqlDbType.Int, intModuleID),
                      StoredProcedure.CreateInputParam("@duration", SqlDbType.Int, duration),
                      StoredProcedure.CreateInputParam("@score", SqlDbType.Int, score)
                      ))
            {
                return sp.ExecuteTable();
            }
        } 
		/// <summary>
		/// This method creates a new QuizAnswer audit entry that indicates a person has answered a question.
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Li Zhang 17/10/2006
		/// Changes:
		/// </remarks>
		/// <param name="quizSessionID">The session id of the Quiz Session, unique GUID that identifies this toolbook quiz session</param>
		/// <param name="duration">The duration in seconds of the quiz as messured by toolbook</param>
		/// <param name="score">The score as mesured by toolbook</param>
		/// <param name="userID">The user who took the quiz</param>
		/// <param name="quizID">The quiz ID</param>
		/// <param name="passMark">The quiz pass mark</param>
		/// <param name="unitID">The user's unit ID</param>
		/// <param name="moduleID">The module ID</param>
		/// <param name="courseID">The course ID</param>
		/// <param name="oldCourseStatus">The old course ID</param>
		/// <param name="newQuizStatus">The new quiz status ID</param>
		/// <param name="newCourseStatus">The new course status ID</param>
		/// <param name="quizFrequency">The quiz frequency </param>
		public DataTable EndQuizSession_UpdateTables(string quizSessionID, int duration, int score, int userID, int quizID, int passMark, int unitID, int moduleID, int courseID, int oldCourseStatus, int newQuizStatus, int newCourseStatus, int quizFrequency, DateTime quizCompletionDate)
		{
			System.Data.SqlClient.SqlParameter paramQuizDate = StoredProcedure.CreateInputParam("@QuizCompletionDate", SqlDbType.DateTime);

			if (quizCompletionDate == DateTime.Parse("1/1/1900"))
				paramQuizDate.Value = System.DBNull.Value;
			else
				paramQuizDate.Value = quizCompletionDate;



			using(StoredProcedure sp = new StoredProcedure("prcQuizSession_UpdateEndQuizInfo",
					  StoredProcedure.CreateInputParam("@QuizSessionID", SqlDbType.VarChar,50,quizSessionID),
					  StoredProcedure.CreateInputParam("@Duration", SqlDbType.Int,duration),
					  StoredProcedure.CreateInputParam("@Score", SqlDbType.Int,score),
					  StoredProcedure.CreateInputParam("@UserID", SqlDbType.Int,userID),
					  StoredProcedure.CreateInputParam("@quizID", SqlDbType.Int,quizID),
					  StoredProcedure.CreateInputParam("@PassMark", SqlDbType.Int,passMark),
					  StoredProcedure.CreateInputParam("@UnitID", SqlDbType.Int,unitID),
					  StoredProcedure.CreateInputParam("@ModuleID", SqlDbType.Int,moduleID),
					  StoredProcedure.CreateInputParam("@CourseID", SqlDbType.Int,courseID),
					  StoredProcedure.CreateInputParam("@OldCourseStatus", SqlDbType.Int,oldCourseStatus),
					  StoredProcedure.CreateInputParam("@NewQuizStatus", SqlDbType.Int,newQuizStatus),
					  StoredProcedure.CreateInputParam("@NewCourseStatus", SqlDbType.Int,newCourseStatus),
					  StoredProcedure.CreateInputParam("@QuizFrequency", SqlDbType.Int,quizFrequency),
					  paramQuizDate
					  ))
			{
				return sp.ExecuteTable ();
			}
		} 
		#endregion	
		
	}
}
