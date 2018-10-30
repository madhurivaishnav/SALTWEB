using System;

namespace Bdw.Application.Salt.Data
{
    /// <summary>
    /// This is the public enum for the user type.
    /// </summary>
    /// <remarks>
    /// Assumptions: The values in the database table do not change and always match the values here.
    /// Notes: This maps to the database table tblUserType.
    /// Author: Peter Vranich, 28/01/0/2004
    /// Changes:
    /// </remarks>
    public enum UserType
    {
        /// <summary>
        /// Salt Administrator
        /// </summary>
        SaltAdmin = 1,
        /// <summary>
        /// Organisational Administrator
        /// </summary>
        OrgAdmin = 2,
        /// <summary>
        /// Unit Administrator
        /// </summary>
        UnitAdmin = 3,
        /// <summary>
        /// Regular User
        /// </summary>
        User = 4
    }
	
    /// <summary>
    /// This is the public enum for the CSV to XML conversion types.
    /// </summary>
    /// <remarks>
    /// Assumptions:.
    /// Notes:.
    /// Author: Peter Kneale, 07/05/2004
    /// Changes:
    /// </remarks>
    public enum CSVtoXMLConverterTypes
    {
        /// <summary>
        /// Convert a CSV file to an XML file containing users
        /// </summary>
        User=1,
        /// <summary>
        /// Convert a CSV file to an XML file containing units
        /// </summary>
        Unit=2
    };

    /// <summary>
    /// This is the public enum for the lesson status.
    /// </summary>
    /// <remarks>
    /// Assumptions: The values in the database table do not change and always match the values here.
    /// Notes: This maps to the database table tblLessonStatus.
    /// Author: Peter Vranich, 28/01/0/2004
    /// Changes:
    /// </remarks>
    public enum LessonStatus
    {
        /// <summary>
        /// The user has not been assigned to the lesson
        /// </summary>
        Unassigned = 0,
        
        /// <summary>
        /// User has not started 
        /// </summary>
        NotStarted = 1,
        
        /// <summary>
        /// The lesson is in progress
        /// </summary>
        InProgress = 2,
        
        /// <summary>
        /// The lesson is complete
        /// </summary>
        Completed = 3,
        
        /// <summary>
        /// The lesson status has expired due to the time elapsed.
        /// </summary>
        ExpiredTimeElapsed = 4,
        
        /// <summary>
        /// The lesson status has been overridden by new content arriving in the system
        /// </summary>
        ExpiredNewContent = 5
    }
	
    /// <summary>
    /// This is the public enum for the quiz status.
    /// </summary>
    /// <remarks>
    /// Assumptions: The values in the database table do not change and always match the values here.
    /// Notes: This maps to the database table tblQuizStatus.
    /// Author: Peter Vranich, 28/01/0/2004
    /// Changes:
    /// </remarks>
    public enum QuizStatus
    {
        /// <summary>
        /// The user has not been assigned to the quiz
        /// </summary>
        Unassigned = 0,
        
        /// <summary>
        /// The user has not started the quiz
        /// </summary>
        NotStarted = 1,
        
        /// <summary>
        /// The user has passed the quiz
        /// </summary>
        Passed = 2,
        
        /// <summary>
        /// The user has failed the quiz
        /// </summary>
        Failed = 3,
        
        /// <summary>
        /// The users quiz status has expired due to the time elapsed.
        /// </summary>
        ExpiredTimeElapsed = 4,
        
        /// <summary>
        /// The users quiz status has expired due to new content being present.
        /// </summary>
        ExpiredNewContent = 5
    }
	
    /// <summary>
    /// This is the public enum for the course status.
    /// </summary>
    /// <remarks>
    /// Assumptions: The values in the database table do not change and always match the values here.
    /// Notes: This maps to the database table tblCourseStatus.
    /// Author: Gavin Buddis, 2/04/2004
    /// Changes:
    /// </remarks>
    public enum CourseStatus
    {
        /// <summary>
        /// The user is not currently assigned to the course (but previously was)
        /// </summary>
        Unassigned = 0,
        
        /// <summary>
        /// Course is incomplete
        /// </summary>
        InComplete = 1,
        
        /// <summary>
        /// Course is complete
        /// </summary>
        Complete = 2
    }
	
    /// <summary>
    /// This is the public enum for the error level.
    /// </summary>
    /// <remarks>
    /// Assumptions: The values in the database table do not change and always match the values here.
    /// Notes: This maps to the database table tblErrorLevel.
    /// Author: Peter Vranich, 28/01/0/2004
    /// Changes:
    /// </remarks>
    public enum ErrorLevel
    {
        /// <summary>
        /// High Severity Error
        /// </summary>
        High = 1,

        /// <summary>
        /// Medium Severity Error (default)
        /// </summary>
        Medium = 2,

        /// <summary>
        /// Low Severity Error
        /// </summary>
        Low = 3,

        /// <summary>
        /// Warning Error
        /// </summary>
        Warning = 4,

        /// <summary>
        /// Information Only Error
        /// </summary>
        InformationOnly = 5
    }
	
    /// <summary>
    /// This is a public enum for the error status.
    /// </summary>
    /// <remarks>
    /// Assumptions: The values in the database table do not change and always match the values here.
    /// Notes: This maps to the database table tblErrorStatus.
    /// Author: Peter Vranich, 28/01/0/2004
    /// Changes:
    /// </remarks>
    public enum ErrorStatus 
    {
        /// <summary>
        /// The error is unassigned (default)
        /// </summary>
        Unassigned = 1,

        /// <summary>
        /// The error has been assigned
        /// </summary>
        Assigned = 2,

        /// <summary>
        /// More Information is needed 
        /// </summary>
        NeedMoreInformation = 3,

        /// <summary>
        /// No solution is available
        /// </summary>
        NoSolution = 4,

        /// <summary>
        /// This error has been fixed.
        /// </summary>
        Fixed = 5
    }
    /// <summary>
    /// Enumeration of the report type for the email report
    /// </summary>
    public enum EmailReportType
    {
        /// <summary>
        /// Report for completed users sent to administrators
        /// </summary>
        Email_Report_Complete_To_Administrators, 

		/// <summary>
		/// Report for policy accepted users sent to administrators
		/// </summary>
		Policy_Email_Report_Accepted_To_Administrators,

		/// <summary>
		/// Report for policy not accepted users sent to administrators
		/// </summary>
		Policy_Email_Report_Not_Accepted_To_Administrators,

		/// <summary>
		/// Report for policy accepted users sent to users
		/// </summary>
		Policy_Email_Report_Accepted_To_Users,


		/// <summary>
		/// Report for policy not accepted users sent to users
		/// </summary>
		Policy_Email_Report_Not_Accepted_To_Users,

		/// <summary>
        /// Report for failed users sent to administrators
        /// </summary>
        Email_Report_Failed_To_Administrators,  
                                                                                                                                                                                                                 
        /// <summary>
        /// Report for not started users sent to administrators
        /// </summary>
        Email_Report_Not_Started_Administrators,    
        
        /// <summary>
        /// Report for all incomplete users sent to administrators
        /// </summary>
        Email_Report_InComplete_To_Administrators,

		
		/// <summary>
		/// Report for all expired time elapsed users sent to administrators
		/// </summary>
		Email_Report_Expired_Time_Elapsed_To_Administrators,

		/// <summary>
		/// Report for all expired new content users sent to administrators
		/// </summary>
		Email_Report_Expired_New_Content_To_Administrators,

        /// <summary>
        /// Report for completed users sent to users directly
        /// </summary>                                                                                                                                                                                           
        Email_Report_Complete_To_Users,                 
        
        /// <summary>
        /// Report for failed users sent to users directly
        /// </summary>                                                                                                                                                                                           
        Email_Report_Failed_To_Users,                                                                                                                                                                                                                            
        
        /// <summary>
        /// Report for not started users sent to users directly
        /// </summary>                                                                                                                                                                                           
        Email_Report_Not_Started_To_Users,

        /// <summary>
        /// Report for incomplete users sent to users directly
        /// </summary>   
        Email_Report_InComplete_To_Users,

		/// <summary>
		/// Report for expired time elapsed users sent to users directly
		/// </summary>  
		Email_Report_Expired_Time_Elapsed_To_Users,

		/// <summary>
		/// Report for expired new content users sent to users directly
		/// </summary>  
		Email_Report_Expired_New_Content_To_Users,

		Email_Report_Expired_To_Users,

		///<summary>
		///CPD Email reports
		///</summary>
		Email_Incomplete_CPD_User,
		Email_Incomplete_CPD_Administrator,

        /// <summary>
        /// Ebook Email
        /// </summary>
        Ebook_NewUpdate_Subject,
        Ebook_NewUpdate_Body
    }

	/// <summary>
	/// This is a public enum for the different types of stored procedure execution modes.
	/// Currently used in the StoredProcedure & DeadLockManagement classes.
	/// </summary>
    public enum QueryType { NonQuery, Reader, XMLReader, Scalar, DataSet, DataTable }


	public enum CourseResetType
	{
		Unchanged = 1,
		CompleteCourseStatus = 2,
		IncompleteCourseStatus = 3
	}
}
