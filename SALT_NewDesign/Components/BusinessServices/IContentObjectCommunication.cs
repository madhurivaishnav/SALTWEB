//===============================================================================
//
//	Salt Business Service Layer
//
//	Bdw.Application.Salt.BusinessServices IContentObjectCommunication Interface
//
//  Interface defining Retrieve and update operations on 
//	Content Modules and related information
//
//===============================================================================
using System;
using System.Data;
using System.Data.SqlTypes;
using Bdw.Application.Salt.Data;

namespace Bdw.Application.Salt.BusinessServices
{
	/// <summary>
	/// Summary description for IContentObjectCommunication.
	/// </summary>
	interface IContentObjectCommunication
	{

		/// <summary>
		/// This method loads the new XML content into the relevant tables.
		/// </summary>
		/// <param name="contentXml">A string containg the new xml content</param>
		/// <param name="userID">The userID of the user uploading this new content.</param>
		/// <param name="moduleID">The module for which this content is to be used.</param>
		/// <param name="courseID">The course for which this content is to be used.</param>
		/// <param name="toolLocation">The Location (path) for this Content Module</param>
		/// <returns>
		/// A Dataset containing information regarding the success of the upload. For
		/// further information please see the stored procedure.
		/// </returns>
		DataSet UploadContentObjectXML(SqlString contentXml,SqlInt32 userID,SqlInt32 moduleID, SqlInt32 courseID, SqlString toolLocation);
	
		/// <summary>
		/// This method previews the new XML content without loading it into the database.
		/// It validates that the xml content is valid in compared to the existing salt database content.
		/// </summary>
		/// <param name="contentXml">A string containg the new xml content</param>
		/// <param name="moduleID">The module for which this content is to be used.</param>
		/// <returns>
		/// DataSet containing the results of the attempted validation. See
		/// See the stored procedure for more information
		/// </returns>
		DataSet UploadContentObjectXMLPreview(string contentXml,int moduleID,int userID);
		
	
		/// <summary>
		/// This method creates a new quiz audit entry that indicates a person has attempted a quiz.
		/// </summary>
		/// <param name="sessionID">The session id of the Quiz Session</param>
		/// <param name="ContentObjectPageID">The Content Module Page ID of the quiz attempted by the person</param>
		void CreateQuizQuestionAudit(string sessionID, string ContentObjectPageID);

		/// <summary>
		/// This method creates a new QuizAnswer audit entry that indicates a person has answered a question.
		/// </summary>
		/// <param name="sessionID">The session id of the Quiz Session</param>
		/// <param name="ContentObjectPageID">The Content Module Page ID of the question attempted by the person</param>
		/// <param name="quizAnswerID">The answer selected by the person</param>
		void CreateQuizAnswerAudit(string sessionID, string ContentObjectPageID, int quizAnswerID);

		/// <summary>
		/// This method creates a new QuizAnswer audit entry that indicates a person has answered a question.
		/// </summary>
		/// <param name="quizSessionID">The session id of the Quiz Session, unique GUID that identifies this Content Module quiz session</param>
		/// <param name="duration">The duration in seconds of the quiz as messured by Content Module</param>
		/// <param name="score">The score as mesured by Content Module</param>
		void EndQuizSession(string quizSessionID, int duration, int score);

		/// <summary>
		/// This method returns the ModuleID of the module that the session is linked to.
		/// </summary>
		/// <param name="sessionID">ID of the session.</param>
		/// <returns>ID of the associated module.</returns>
		int GetModuleIDBySessionID(string sessionID);

		/// <summary>
		/// BeforeQuizStart - Prepears to start a unique quiz - returns a GUID
		/// </summary>
		/// <returns>DataTable containing values necessary to launch the Content Module.</returns>
		/// <param name="userID">The User attempting the Quiz.</param>
		/// <param name="moduleID">The module the User is attempting.</param>
		DataTable BeforeQuizStart(int userID, int moduleID);

		/// <summary>
		/// Starts a quiz session for a particular user attempting a particular quiz.
		/// </summary>
		/// <returns> A boolean value indicating whether the session started successfully or not.
		/// </returns>
		/// <param name="QuizSessionID">User ID of the user starting the quiz.</param>
		bool StartQuiz(string QuizSessionID);

		/// <summary>
		/// This method returns a Quiz ID from a Content Module ID
		/// </summary>
		/// <param name="sessionID">The session ID from which to get the Quiz ID</param>
		/// <returns>QuizID</returns>
		int GetQuizIDBySessionID(string sessionID);

		/// <summary>
		/// This method returns a users User ID based on a current Sesion Id.
		/// </summary>
		/// <param name="SessionID">The session ID from which to get the User ID</param>
		/// <returns>UserID of the user matching the sessionid </returns>
		int GetUserIDBySessionID(string SessionID);

		/// <summary>
		/// This method returns a users Unit ID based on their UserID
		/// </summary>
		/// <param name="UserID">UserID of desired user.</param>
		/// <returns>UnitID of the Unit that the user belongs to.</returns>
		int GetUnitIDByUserID(int UserID);

		/// <summary>
		/// Gets the pass mark of the quiz that belongs to the specified Unit and Module.
		/// </summary>
		/// <param name="UnitID">UnitID that the quiz belongs to.</param>
		/// <param name="ModuleID">ModuleID that the quiz belongs to.</param>
		/// <returns></returns>
		int GetQuizPassMark(int UnitID, int ModuleID);

		/// <summary>
		/// This method returns the number of questions in a particular quiz.
		/// </summary>
		/// <param name="QuizID">QuizID of the Quiz that we wish to could the questions in.</param>
		/// <returns>The number of questions.</returns>
		int GetQuizQuestionsCountByQuizID(int QuizID);

		/// <summary>
		/// ValidateAccess
		/// </summary>
		/// <returns>Returns true if a user can access a module.</returns>
		/// <param name="userID">integer containg the user id</param>
		/// <param name="moduleID">integer containg the module id</param>
		bool ValidateAccess(int userID, int moduleID);

		/// <summary>
		/// BeforeLessonStart - Prepears to start a unique lesson - returns a GUID
		/// </summary>
		/// <returns>DataTable containg the GUID for the session</returns>
		/// <param name="userID">integer containg the user id</param>
		/// <param name="moduleID">integer containg the module id</param>
		DataTable BeforeLessonStart(int userID, int moduleID);

		/// <summary>
		/// StartLesson - updates a prepared lesson, starts it if it has not already been started and return true, else return false
		/// </summary>
		/// <returns>Returns true if a session has not been strated before</returns>
		/// <param name="sessionID">String containg the session GUID</param>
		bool StartLesson(SqlString sessionID);

		/// <summary>
		/// SessionIsUnique
		/// </summary>
		/// <returns>Returns true if a session has not been used before</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes:
		///  this function is to ensure that the lesson onload event only fires once
		///  for each Content Module - and that no attempt is made (ie hitting the 
		///  back / forward button) to restart a lesson
		/// Author: Stephen Kennedy-Clark, 03/02/0/2004
		/// Changes:
		/// </remarks>
		/// <param name="sessionID">String containg the session GUID</param>
		bool SessionIsUnique(SqlString sessionID);

		/// <summary>
		/// GetPagesVisited
		/// </summary>
		/// <returns>Returns a data table of pages that the user has visited in this Content Module</returns>
		/// <param name="sessionID">String containg the session GUID</param>
		DataTable GetPagesVisited(SqlString sessionID);

		/// <summary>
		/// RecordPageVisited
		/// </summary>
		/// <returns>Returns boolean true if the lesson was not already finished and the page visited exists in the Content Module</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes:
		///  This function records the fact that a student has visited a page in the Content Module
		///  it requires the Content Module Page ID and the SessionID
		///  The underlying stored proc will not accept the page if the lesson has already been finished
		///  or if salt cannot match the pageID to a page in the lesson
		/// </remarks>
		/// <param name="sessionID">String containg the session GUID</param>
		/// <param name="pageID">Integer containg the page id</param>
		bool RecordPageVisited(SqlString sessionID, SqlString pageID);

		/// <summary>
		/// GetBookmark
		/// </summary>
		/// <returns>Returns the Content Module Page ID for the page in the current Content Module that a user has set</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes:
		/// Author: Stephen Kennedy-Clark, 03/02/0/2004
		/// Changes:
		/// </remarks>
		/// <param name="sessionID">String containg the session GUID</param>
		string GetBookmark(SqlString sessionID);

		/// <summary>
		/// EndLessonSession
		/// </summary>
		/// <param name="sessionID">String containg the session GUID</param>
		/// <param name="duration">Integer - The number of seconds that the lesson was running</param>
		/// <param name="bookmark">string containg teh Content Module page id to be bookmarked</param>
		/// <returns>Return true if the lesson was ended sucessfully</returns>
		bool EndLessonSession(SqlString sessionID, SqlInt32 duration, SqlString bookmark);

		/// <summary>
		/// GetUser
		/// </summary>
		/// <returns>
		/// Returns the user's first and last names concatenated with a space
		/// </returns>
		/// <param name="sessionID">String containg the session GUID</param>
		string GetUser(SqlString sessionID);

		/// <summary>
		/// BeforeQuizEnd - Prepears to end a unique quiz 
		/// </summary>
		/// <param name="quizSessionID">The unique quiz session ID.</param>
		/// <param name="duration">The duration in seconds.</param>
		/// <param name= "score">The score as mesured by toolbook</param>
		/// <returns>
		///  Returns a data table contains information needed to end a quiz
		/// </returns>
		DataTable BeforeQuizEnd(string quizSessionID, int duration, int score);

		/// <summary>
		/// EndQuizSession_UpdateTables
		/// </summary>
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
	 
		DataTable EndQuizSession_UpdateTables(string quizSessionID, int duration, int score, int userID, int quizID, int passMark, int unitID, int moduleID, int courseID, int oldCourseStatus, int newQuizStatus, int newCourseStatus, int quizFrequency, DateTime quizCompletionDate);
	}


}
