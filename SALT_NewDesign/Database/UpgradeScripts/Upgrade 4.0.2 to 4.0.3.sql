-- LINK
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS 
		where TABLE_NAME='tblLink' 
		and COLUMN_NAME='LinkOrder')
	ALTER TABLE dbo.tblLink ADD
		LinkOrder int NULL
	GO
	if not exists (select * from dbo.SYSOBJECTS  where id = OBJECT_ID(N'[dbo].[DF_tblLink_LinkOrder]'))
	ALTER TABLE dbo.tblLink ADD CONSTRAINT
		DF_tblLink_LinkOrder DEFAULT 0 FOR LinkOrder
	GO
	

	-- Monday, 7 April 2008 - 10:35:32 AM
	INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) VALUES('grid_Sort', '', 1, getdate(), newid());SELECT @@IDENTITY AS [@@IDENTITY]


	-- Monday, 7 April 2008 - 10:35:36 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
						SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
						(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Administration/Organisation/ModifyLinks.aspx'), 
						(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'grid_Sort'), 
						'Sort', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]
-- /LINK

-- Fix Email Subject for lost password
	-- Wednesday, 9 April 2008 - 11:28:47 AM
	INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) VALUES('EmailSubject', '', 1, getdate(), newid());SELECT @@IDENTITY AS [@@IDENTITY]


	-- Wednesday, 9 April 2008 - 11:28:47 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
						SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
						(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/PasswordRecovery.aspx'), 
						(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'EmailSubject'), 
						'Login Information', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]

-- /Fix Email Subject for lost password

-- Completed User Report Additions
	-- Monday, 14 April 2008 - 4:20:02 PM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
						SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
						(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Advanced/CompletedUsersReport.aspx'), 
						(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'optStatus.3'), 
						'Incomplete (with details)', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]
-- /Completed User Report Additions

-- Latest change batch from BD
	UPDATE tblLangValue set LangEntryValue = '<b>salt™</b> provides training to assist you in understanding the legal obligations of your company and you.', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Login.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'lblIntroduction')                         
	UPDATE tblLangValue set LangEntryValue = '(Click here to request further information)', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Login.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'lnkFurtherInformation')                         
	UPDATE tblLangValue set LangEntryValue = '<td vAlign="top">The following courses are now available:<br>  <br>  &nbsp;&gt; <b>salt™</b> Code of Banking Practice<br>  &nbsp;&gt; <b>salt™</b> Commerce Act<br>  &nbsp;&gt; <b>salt™</b> Consumer Guarantees<br>  &nbsp;&gt; <b>salt™</b> Contract Fundamental<br>  &nbsp;&gt; <b>salt™</b> Employment<br>  &nbsp;&gt; <b>salt™</b> Fair Trading<br>  &nbsp;&gt; <b>salt™</b> Health and Safety<br>  &nbsp;&gt; <b>salt™</b> Money Laundering<br>  &nbsp;&gt; <b>salt™</b> Official Information Act<br>  &nbsp;&gt; <b>salt™</b> Privacy<br>  &nbsp;&gt; <b>salt™</b> Resource Management  </td>', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Login.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'litCourseList')                         
	UPDATE tblLangValue set LangEntryValue = 'Email Password', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/PasswordRecovery.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'btnRecover')                         
	UPDATE tblLangValue set LangEntryValue = 'Or Lesson Completion Date', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Administration/Organisation/OrganisationDetails.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'lblLessDate')                         
	UPDATE tblLangValue set LangEntryValue = 'Quiz Completion Date', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Administration/Organisation/OrganisationDetails.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'lblQuizDate')                         
	UPDATE tblLangValue set LangEntryValue = 'Complete', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Reporting/Advanced/CompletedUsersReport.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'optStatus.1')                         
	UPDATE tblLangValue set LangEntryValue = 'Incomplete', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Reporting/Advanced/CompletedUsersReport.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'optStatus.2')                         
	UPDATE tblLangValue set LangEntryValue = 'Complete', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Reporting/Advanced/CourseStatusReport.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'optStatus.1')                         
	UPDATE tblLangValue set LangEntryValue = 'Incomplete', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Reporting/Advanced/CourseStatusReport.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'optStatus.2')                         
	UPDATE tblLangValue set LangEntryValue = 'Fail', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Reporting/Advanced/CourseStatusReport.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'optStatus.3')                         
	UPDATE tblLangValue set LangEntryValue = 'Not Started', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Reporting/Advanced/CourseStatusReport.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'optStatus.4')                         
	UPDATE tblLangValue set LangEntryValue = 'Expired (Time Elapsed)', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Reporting/Advanced/CourseStatusReport.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'optStatus.5')                         
	UPDATE tblLangValue set LangEntryValue = 'Expired (New Content)', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Reporting/Advanced/CourseStatusReport.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'optStatus.6')                         
	UPDATE tblLangValue set LangEntryValue = 'Incomplete', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Reporting/CompletedUsers/CompletedUsersReporting.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'optStatus.2')                         
	UPDATE tblLangValue set LangEntryValue = 'Complete', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Reporting/Email/BuildEmailReport.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'radCourseModuleStatus.1')                         
	UPDATE tblLangValue set LangEntryValue = 'Incomplete - Includes Failed and Not Started', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Reporting/Email/BuildEmailReport.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'radCourseModuleStatus.2')                         
	UPDATE tblLangValue set LangEntryValue = 'Failed', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Reporting/Email/BuildEmailReport.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'radCourseModuleStatus.3')                         
	UPDATE tblLangValue set LangEntryValue = 'Not Started', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Reporting/Email/BuildEmailReport.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'radCourseModuleStatus.4')                         
	UPDATE tblLangValue set LangEntryValue = 'Expired (Time Elapsed)', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Reporting/Email/BuildEmailReport.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'radCourseModuleStatus.5')                         
	UPDATE tblLangValue set LangEntryValue = 'Expired (New Content)', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Reporting/Email/BuildEmailReport.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'radCourseModuleStatus.6')                         
	UPDATE tblLangValue set LangEntryValue = 'Forgot your password?', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = 'GLOBAL.UserControls.Login.ascx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'litForgotPassword')                         
	UPDATE tblLangValue set LangEntryValue = 'HOW TO CREATE REPORT', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Help.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'Help9')                         
	UPDATE tblLangValue set LangEntryValue = 'Quiz History', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Help.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'Help92')                         
	UPDATE tblLangValue set LangEntryValue = '<p>Welcome to {0} - an interactive Self Administered Legal Training  product developed by Blake Dawson Lawyers. {0} will teach  you about an area of law that is important to your organisation.</p>  <p>Each {0} course is divided into a number of legal topics, or "modules" which are listed on the home page. Each module contains a lesson and  a quiz.  </p>  <p>Successful {0} training is usually achieved by a status of "Passed", indicated by a tick symbol in the Quiz column, for each module shown on the user Home page.  However, there may be additional requirements for you set by the {0} Administrator for your organisation.</p>  <p>The level of access assigned to your {0} login will determine the options available for Reporting and Administration. {0} Administrators should refer to the Administration Guide for details, please contact Blake Dawson for a copy of the most recent revision.</p>', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Help.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'litHelpTextIntro')                         
	UPDATE tblLangValue set LangEntryValue = '<p>{0} may incorporate links to websites and written information (such as the full text of legislation) relevant to the area of law in which you are training. As well as the hyperlinks within the lesson pages there is a Links tab on your Home page where your {0} Administrator can provide you with access to relevant materials outside of the {0} program.</p>  <p>To view links related to the {0} course you are using, click the Links tab on the menu bar.</p>  <p>To navigate to the site or information you wish to view click the corresponding hyperlink. This will open a new browser window displaying the contents of the link. Simply close the new browser window when you are finished and you will return to the {0} application.</p>', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Help.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'litHelpText10')                         
	UPDATE tblLangValue set LangEntryValue = '<p>When you complete a lesson for the first time, the status changes from "Not Started" to "Completed." If you exit a lesson before reaching the last page, the status will change from "Not Started" to "In Progress".</p>   <p>When you complete a quiz for the first time, your quiz status will change from "Not Started" to "Passed" or "Failed" depending on your score. Other events and considerations that may change the status of your quiz or lesson include:</p>   <ul>  <li>Content updates to a lesson or quiz   <li>A change in the Compliance Rules relevant to your organisational Unit   <li>Your {0} administrator moving you to an organisational Unit which has different Compliance Rules  <li>Expiry of lesson or quiz due to period of time elapsed since completion/pass  </ul>', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Help.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'litHelpText96')                         
	UPDATE tblLangValue set LangEntryValue = '<p>On the Home page, to the right of the module headings, there are icons which indicate your lesson and quiz status. These icons indicate your progress for that module. The Status Key displayed below the modules identifies the icon for each status and further detail is listed here:</p>   <p>"Not Started" - In the Quiz column this indicates that a set of quiz answers has not yet been submitted for this module (in the Lesson column this indicates that none of the lesson pages have been viewed).</p>  <p>"Passed" - This indicates that you have submitted a set of quiz answers that have met or exceeded the criteria for this module.</p>  <p>"Failed" - This indicates that you have submitted a set of quiz answers but they have not met the criteria set for this module.</p>  <p>"New Content" - This star indicates that the quiz has been updated since you last viewed it.  Organisations usually require you to re-submit answers to the quiz for this module when you see "New Content" star(s).  New Content may be required because of updates to the relevant legislation or because of changes to policy in your organisation.</p>  <p>"Expired" - The quiz status icon for a module will only remain as "Passed" for a period of time set by the {0} Administrator for your organisation.  The "Expired" status icon indicates that it has been longer than the period allowed since you last successfully completed the quiz. For the status icon to change back to "Passed" you must go back into the quiz and submit another set of answers that meet or exceed the criteria for this module.</p>  <p>"In Progress" and "Completed" status icons relate to the Lesson column and do not display as Quiz status indicators.</p>', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Help.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'litHelpText95')                         
	UPDATE tblLangValue set LangEntryValue = '<p>It is good practice to change your password when you first login to {0} and at regular intervals afterwards.  Once you have logged into {0} the steps to change your password are:</p>  <ul>  <li>Select Administration on the Home page, this displays the Personal Details screen  <li>In the Old Password box, enter your existing password  <li>In the New Password box, enter your new password (minimum of 8 characters)  <li>In the Confirm Password box, re-enter your new password  </ul>  <p>Click the Save button</p>', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Help.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'litHelpText94')                         
	UPDATE tblLangValue set LangEntryValue = '<p>To view the set of answers you gave for a quiz, click on the date of the quiz attempt you are interested in. You cannot update or amend the answers recorded in a set.  This report shows the answers you gave in that particular quiz attempt.</p>   <p>This page is titled "Quiz Summary" and will show the quiz information in a grid:</p>   <ul>  <li>Question   <li>Correct Answer   <li>Your Answer   <li>Result (Correct or Incorrect shown by a tick or a cross)  </ul>  <p>The following detail will also be shown at the top of the page:</p>  <ul>  <li>Module (name / heading)  <li>Your First and Last Name   <li>Quiz score  </ul>', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Help.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'litHelpText93')                         
	UPDATE tblLangValue set LangEntryValue = '<p>You can click on a module heading to see the Quiz History for that module.</p>   <p>The Quiz History view enables you to "drill down" into your history for a particular quiz. It is accessed by clicking on the module heading hyperlink in the Personal Report.</p>   <p>This page is formatted as a list of the dates when sets of quiz answers have been submitted and will show the following:</p>  <ul>  <li>Quiz History table with the following columns   <li>Status (Pass/Fail/New Content/Expired)   <li>Summary (date hyperlink to Quiz Answers)   <li>Pass Mark   <li>Your Mark (displayed as text and graphically)  </ul>  <p>The dates in the list will display as active hyperlinks.  You can use these hyperlinks to review each set of quiz answers you have submitted.</p>', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Help.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'litHelpText92')                         
	UPDATE tblLangValue set LangEntryValue = '<p>This report will show you a list of all Courses and modules which are currently assigned to you, along with the status of each module. If you are a {0} User this is accessed by clicking the ''Reports'' link. If you are a {0} Administrator this report is accessed by clicking the ''Personal Reports''.</p>   <p>The following details are displayed on this page:</p>  <ul>  <li>Course   <li>Modules within the course you have been assigned (links to Quiz History, see below)   <li>Current Lesson Status   <li>Current Quiz Status   <li>Quiz Score   <li>Current Pass Mark for Quiz  </ul>  <p>The Module names / headings will display as active hyperlinks where you have submitted a set of answers to a quiz for that module.  You can use these hyperlinks to review the history of quiz answers you have submitted.</p>', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Help.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'litHelpText91')                         
	UPDATE tblLangValue set LangEntryValue = 'The report available to a User training on {0} is the Personal Report, which covers all courses and modules assigned to them. {0} Administrators can access a suite of reports, and should refer to the Administration Guide for details.', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Help.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'litHelpText9')                         
	UPDATE tblLangValue set LangEntryValue = '<p>Each module in each course has its own set of Compliance Rules. Compliance Rules refer to training and testing frequency periods and pass marks.</p>   <p>A compliance period indicates how often you must complete your training and testing for a module. For example, you may need to complete a lesson and a quiz for a module every 12 months. The compliance period is set by the {0} Administrator for your organisation.</p>   <ul>  <li>Quiz Frequency Period - The frequency with which the Users in an organisational unit need to repeat the quiz. If you do not repeat the quiz within this period, your status for the quiz will change to "Expired (Time Elapsed)".   <li>Lesson Frequency Period - The frequency with which the Users in an organisational unit need to repeat the lesson. If you do not restart the lessons within this period, your status for the lesson will change to "Expired (Time Elapsed)".   <li>Pass Mark - The mark on the quiz that members of this organisational unit must achieve to be regarded as "Passed". If you submit a quiz and do not achieve the Pass Mark your status for the quiz will display as "Failed".  </ul>', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Help.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'litHelpText8')                         
	UPDATE tblLangValue set LangEntryValue = '<p>When you complete a lesson for the first time, the status changes from "Not Started" to "Completed." If you exit a lesson before reaching the last page, the status will change from "Not Started" to "In Progress".</p>   <p>When you complete a quiz for the first time, your quiz status will change from "Not Started" to "Passed" or "Failed" depending on your score. Other events and considerations that may change the status of your quiz or lesson include:</p>   <ul>  <li>Content updates to a lesson or quiz   <li>A change in the Compliance Rules relevant to your organisational Unit   <li>Your {0} administrator moving you to an organisational Unit which has different Compliance Rules  <li>Expiry of lesson or quiz due to period of time elapsed since completion/pass  </ul>', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Help.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'litHelpText6')                         
	UPDATE tblLangValue set LangEntryValue = '<p>Each module contains a lesson and a quiz. You can complete quizzes in any order, but we recommend that you work through the quizzes in the order that they appear on the home page after you complete the lesson. </p> <p>To navigate through a quiz, simply answer the question presented, and click the page forward button. The button will not appear on the page until you have provided an answer to that question. </p> <p>You should only use the navigation buttons within the {0} program. Do not use your browser''s navigation buttons as this will cause the program to exit. </p> <p>Note that in order to save your quiz results, you must complete the quiz session. You are advised not to use the exit function in the middle of a quiz session. If you do, your results will not be saved. </p>', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Help.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'litHelpText51')                         
	UPDATE tblLangValue set LangEntryValue = '<p>A Quick Facts page is available for each lesson. It is a short summary of the information contained in the lesson, and is a useful as a preview or as a refresher.</p>   <p>To <strong>view</strong> the Quick Facts click the Quick Facts button, which appears to the right of each lesson name on the Home page. You can also open the Quick Facts page from within a lesson by clicking on "Quick Facts" in the lesson menu bar, top right of the lesson page.</p>  <p>To <strong>print</strong> the Quick Facts click with your right mouse button on the displayed page, and select "Print" or follow the printing instructions at the bottom of the Quick Facts screen.</p>', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Help.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'litHelpText4')                         
	UPDATE tblLangValue set LangEntryValue = '<p>You can work through the lessons for each module as many times as you like. There is also a quick fact sheet to assist you to summarise what you have read in each lesson. See the section on ''View and Print Quick Facts''. The lessons are there to give you confidence with your understanding of the subject matter. When you understand the lesson you are more likely to pass the quiz. Even so, you are also permitted to work through and submit a quiz for each module as many times as you like. The intention of {0} is to work with you to build your knowledge of your compliance responsibilities in your job role.  </p>', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Help.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'litHelpText36')                         
	UPDATE tblLangValue set LangEntryValue = '<p>On the Home page, to the right of the module headings, there are icons which indicate your lesson and quiz status. These icons indicate your progress for that module. The Status Key displayed below the modules identifies the icon for each status and further detail is listed here:</p>   <p>"Not Started" - In the Lesson column. This indicates that none of the lesson pages have been viewed (in the Quiz column this indicates that a set of quiz answers has not yet been submitted for this module).</p>  <p>"In Progress" - This indicates that you have navigated to some but not all of the pages in the lesson.</p>  <p>"Completed" - This indicates that you have navigated to every page in the lesson.</p>  <p>"New Content" – This symbol indicates that the lesson has been updated since you last viewed it.  Organisations usually require you to navigate through the lesson and re-submit answers to the quiz for this module when you see the New Content symbol(s).  New Content may be required because of updates to the relevant legislation or because of changes to policy in your organisation.</p>  <p>"Expired" - The lesson status icon for a module will only remain as "Completed" for a period of time set by the {0} Administrator for your organisation.  The "Expired" status icon indicates that it has been longer than the period allowed since you last completed the lesson. For the status icon to change back to "Completed" you must go back into the lesson and navigate through every page.</p>  <p>"Passed" and "Failed" status icons relate to the Quiz column and do not display as Lesson status indicators.</p>', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Help.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'litHelpText35')                         
	UPDATE tblLangValue set LangEntryValue = '<p>On the final page of each lesson is a button labelled ''End Lesson''. If you click on this button you will automatically be taken back to your Home page. You can then choose to undertake a quiz for that module, or you can start another lesson.</p>   <p>If you decide to exit {0} when you are part-way through a lesson, simply click the ''Exit'' tab on the lesson menu bar. {0} will bookmark the page you are exiting so that when you return to that lesson, you will be automatically be returned to the same page.</p>   <p>The status icon in the Lesson column on your Home page will only show as "Completed" if you have navigated to every page in the lesson.  If you have viewed some but not all of the pages in a lesson, your status icon will display as "In Progress".</p>', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Help.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'litHelpText34')                         
	UPDATE tblLangValue set LangEntryValue = '<p>At various stages throughout the lessons optional information has been provided. Click hyperlinks to see examples of relevant cases, additional information, helpful reminders or to navigate to other useful websites. To close an additional information box you have displayed on the lesson page, scroll to the bottom of the dialog box and click on the ''[Hide]'' link.  </p>', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Help.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'litHelpText33')                         
	UPDATE tblLangValue set LangEntryValue = '<p>As you work through the lesson you will be presented with screens of information about the law. You will also be introduced to some fictitious ''players'' who are involved in hypothetical situations. You may also be asked to answer some questions. In the lessons your answers are not recorded and explanations are displayed once you make a choice, so feel free to explore different answers to the questions. This only occurs in lesson pages, assistance is not provided within a quiz.  </p>', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Help.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'litHelpText32')                         
	UPDATE tblLangValue set LangEntryValue = '<p>Modules relevant to you are listed on the Home page. Each module contains a lesson and a quiz. You can complete lessons in any order, but we recommend that you work through each lesson and quiz in the order that they appear on the Home page.</p>  <p>To <strong>begin</strong> a lesson, click on the ''Lesson'' icon next to the first module.</p>   <p>To <strong>navigate</strong> through the lesson use the ''Previous'' and ''Next'' buttons in the bottom right-hand corner of the screen. The page indicator in the top left-hand corner of the screen tells you what page you are on and how many pages there are in the lesson. The items to the right of the page indicator such as ''Home'', ''Quick Facts'', ''Disclaimer'' and ''Exit'' form the lesson menu bar.</p>', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Help.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'litHelpText31')                         
	UPDATE tblLangValue set LangEntryValue = '<p>If you have been assigned more than one course there will be a course selector below the welcome message on your Home page. Select the course you need to complete from the dropdown list. If you only have access to one course then you will only see module(s) for that course listed on the Home page. If you have not been allocated a course, the message "You do not have access to any courses" will be displayed.  </p>', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Help.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'litHelpText2')                         
	UPDATE tblLangValue set LangEntryValue = 'Email Assitance', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Help.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'Help111')                         
	UPDATE tblLangValue set LangEntryValue = 'If you are unsure of how to proceed with your Salt™ training or need further information about how to use Salt™, you may contact the Product Support helpdesk at Blake Dawson using the information provided below. We would also like to know if you notice any error messages that display regularly whilst you are using Salt™.  This will alert us to problems that we may otherwise be unaware of and we would value your comments.  Blake Dawson is unable to assist you with providing hints or answers to the quiz questions, please contact your organisation''s Salt™ Administrator for this type of assistance.', DateModified = getdate()  WHERE     LangID =                            (SELECT     LangID                              FROM          tblLang                              WHERE      LangCode = 'en-AU') AND LangInterfaceID =                            (SELECT     LangInterfaceID                              FROM          tblLangInterface                              WHERE      LangInterfaceName = '/Help.aspx') AND LangResourceID =                            (SELECT     LangResourceID                              FROM          tblLangResource                              WHERE      LangResourceName = 'litHelpText11')                         
-- /Latest change batch from BD

-- Add HELP label to top right of help page
	-- Monday, 21 April 2008 - 9:02:54 AM
	INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) VALUES('lblHelp', '', 1, getdate(), newid());SELECT @@IDENTITY AS [@@IDENTITY]


	-- Monday, 21 April 2008 - 9:02:54 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
						SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
						(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = 'GLOBAL.UserControls.Header.ascx'), 
						(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblHelp'), 
						'Help', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]
-- /Add HELP label to top right of help page

-- CompletedUsersReportDetails additions
-- Friday, May 02, 2008 - 10:42:41 AM
INSERT INTO tblLangInterface(LangInterfaceName, InterfaceType, UserCreated, DateCreated, RecordLock) VALUES('Report.IncompleteUserWithDetails', 'aspx', 1, getdate(), newid())


-- Friday, May 02, 2008 - 10:43:47 AM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = 'Report.IncompleteUserWithDetails'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'rptReportTitle'), 
					'Incomplete Users (with details) Report', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]

-- Friday, May 02, 2008 - 11:13:46 AM
INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) VALUES('rptModules', '', 1, getdate(), newid());SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, May 02, 2008 - 11:13:46 AM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = 'Report.GLOBAL'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'rptModules'), 
					'Modules', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]

-- Friday, May 02, 2008 - 12:04:14 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = 'Report.IncompleteUserWithDetails'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'rptUnitTotal'), 
					'Unit Total', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]
-- End CompletedUsersReportDetails additions



IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'prcReport_CourseStatusSearch')
	BEGIN
		PRINT 'Dropping Procedure prcReport_CourseStatusSearch'
		DROP  Procedure  prcReport_CourseStatusSearch
	END

GO

PRINT 'Creating Procedure prcReport_CourseStatusSearch'
GO
/******************************************************************************
**		File: 
**		Name: prcReport_CourseStatusSearch
**		Desc: Given a list of unit IDs, course IDs, 
**
**		This template can be customized:
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**		Input							Output
**     ----------							-----------
**
**		Auth: 
**		Date: 
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		--------		--------				-------------------------------------------
**    
*******************************************************************************/


CREATE       Procedure prcReport_CourseStatusSearch
(
@organisationID		int,
@unitIDs 		varchar(8000),
@courseIDs 		varchar(8000),
@courseModuleStatus	int,
@dateFrom 		datetime,
@dateTo 		datetime
)
AS
------------------------------------------
Set Nocount On

Declare
@CONST_INCOMPLETE     	int,
@CONST_COMPLETE     	int,
@CONST_FAILD            int,
@CONST_NOTSTARTED 	    int,
@CONST_EXPIRED_TIMELAPSED 	        int,
@CONST_EXPIRED_NEWCONTENT		int

set @CONST_INCOMPLETE	= 0
set @CONST_COMPLETE	= 1
set @CONST_FAILD	= 2
set @CONST_NOTSTARTED	= 3
set @CONST_EXPIRED_TIMELAPSED   = 4
set @CONST_EXPIRED_NEWCONTENT	= 5

DECLARE @Units TABLE
(
	UnitID INT PRIMARY KEY(UnitID)
)

DECLARE @Courses TABLE
(
	CourseID INT PRIMARY KEY(CourseID)
)

DECLARE @CoursesWithAccess 	TABLE (CourseID INT PRIMARY KEY(CourseID))
DECLARE @UserModuleWithAccess TABLE(UserID INT, ModuleID INT, UnitID INT PRIMARY KEY(UserID, ModuleID, UnitID))
DECLARE @AllModules TABLE(ModuleID INT PRIMARY KEY(ModuleID))
DECLARE @Users TABLE(UserID INT , UnitID INT PRIMARY KEY(UserID, UnitID))
DECLARE @UsersNQuizStatus
TABLE
(
	UserID	INT,
	ModuleID INT, 
	LatestQuizID INT, 
	QuizStatusID INT, 
	QuizScore INT
	PRIMARY KEY(UserID, ModuleID, LatestQuizID, QuizStatusID)
)

DECLARE @UsersQuizStatusNOTSTARTED
TABLE
(
	UserID	INT,
	ModuleID INT, 
	LatestQuizID INT, 
	QuizStatusID INT, 
	QuizScore INT
	PRIMARY KEY(UserID, ModuleID, LatestQuizID, QuizStatusID)
)

INSERT INTO @Courses SELECT * FROM dbo.udfCsvToInt(@courseIDs)
INSERT INTO @Units SELECT * FROM  dbo.udfCsvToInt(@unitIDs)

--Get Rid of courses which do not have access to specified org
INSERT INTO @CoursesWithAccess
SELECT A.CourseID FROM @Courses A, tblOrganisationCourseAccess B, tblCourse C
WHERE A.CourseID = B.GrantedCourseID AND B.OrganisationID = @organisationID AND
A.CourseID = C.CourseID AND C.Active = 1

--Get All Modules for courses with access
--INSERT INTO @AllModules
--SELECT ModuleID FROM tblModule A, @CoursesWithAccess B
--WHERE A.CourseID = B.CourseID And A.Active = 1

--Get All the users for all specfied units
INSERT INTO @Users
SELECT DISTINCT A.UserID, A.UnitiD FROM tblUser A, @Units B, tblUnit C
WHERE A.UnitID = B.UnitID AND B.UnitID = C.UnitID AND A.Active = 1 AND C.Active = 1



if @courseModuleStatus = @CONST_COMPLETE or @courseModuleStatus = @CONST_INCOMPLETE
begin -- completed / -- InComplete
--------------------
-- Completed --
--------------------
-- A user is completed if they became complete and remained completed in the period of interest
-- the query only needs to check to see status at the max date in this period as a line item
-- as tblUserCourseStatus is only writen to when an event occours that would
-- change the status.
-- When "Course/Module Status" is set to "Complete"
-- This will find users that:
-- - Belong to any of the Units in @unitIDs
-- - AND are currently assigned Modules from the selected Course
-- - AND have the Custom Classification option (if provided)
-- - AND have (at the end of the time-period in question) got a status of Complete in tblUserCourseStatus
-- - AND the event that made them complete happened some time in the time-period in question
--------------------
-- InComplete
--------------------
-- A user is in-completed if for any reason they are not complete but do have access to the course
-- This will find users that:
-- - Belong to any of the Units in @unitIDs
-- - AND are currently assigned Modules from the selected Courses
-- - AND have the Custom Classification option (if provided)
-- - AND have (at the end of the time-period in question) got a status of Incomplete in tblUserCourseStatus
-- - AND the event that made them complete happened some time in the time-period in question
/*
select
tblUser.UserID,
tblUser.UnitID,
tblUser.FirstName + ' ' + tblUser.LastName as 'Name',
tblUser.LastName as 'LastName',
dbo.udfGetUnitPathway(tblUser.UnitID) as 'UnitPathWay',
currentStatus.DateCreated as 'Date',
tblUser.Username as 'UserName',
tblUser.Email as 'Email',
tblUser.ExternalID as 'ExternalID',
tblCourse.[Name] as 'CourseName'
From
--< Get user details >--
tblUser
--< Filter By Date Range, Course and only get the latest result for each user>--
inner join
dbo.udfReport_HistoricUserCourseStatusWithinRange(@dateFrom, @dateTo) as currentStatus
on currentStatus.UserID = tblUser.UserID
and currentStatus.CourseStatusID = case @courseModuleStatus
when @CONST_COMPLETE then 2   -- Complete
when @CONST_INCOMPLETE then 1 -- InComplete
end
and tblUser.Active = 1
inner join dbo.udfCsvToInt(@courseIDs) invCourses
on currentStatus.CourseID = invCourses.IntValue
inner join tblCourse
on tblCourse.CourseID = currentStatus.CourseID
--<filter by unit - (on the user table)>--
inner join dbo.udfCsvToInt(@unitIDs) invUnits
on  tblUser.UnitID = invUnits.IntValue
--group by [Name], UnitID
order by tblCourse.[Name], tblUser.UnitID, tblUser.Username
*/

--Find the latest status of courses
SELECT
	A.UserID, D.UnitID,
	D.FirstName + ' ' + D.LastName as 'Name',
	D.LastName as 'LastName',
	F.HierarchyName AS 'UnitPathWay',
	C.DateCreated as 'Date', 
	D.Username as 'UserName',
	D.Email as 'Email',
	D.ExternalID as 'ExternalID',
	E.[Name] as 'CourseName'
FROM
(
SELECT
	A.UserID, A.CourseID, MAX(A.UserCourseStatusID) AS 'LatestCourseStatus'
FROM
	tblUserCourseStatus A, @CoursesWithAccess B
WHERE
	A.DateCreated < DATEADD(DD, 1, @dateTo)
	and
	A.CourseID = B.CourseID
GROUP BY
	A.UserID, A.CourseID
) A, @Users B, tblUserCourseStatus C, tblUser D, tblCourse E, tblUnitHierarchy F
WHERE
	A.UserID = B.UserID AND B.UserID = C.UserID AND 
	A.LatestCourseStatus = C.UserCourseStatusID AND
	(C.DateCreated BETWEEN @dateFrom AND dateadd(d,1,@dateTo)) AND
	C.CourseStatusID = case @courseModuleStatus
				when @CONST_COMPLETE then 2   -- Complete
				when @CONST_INCOMPLETE then 1 -- InComplete
				end AND
	A.UserID = D.UserID AND A.CourseID = E.CourseID AND
	D.UnitID = F.UnitID

end -- completed / -- InComplete


if @courseModuleStatus = @CONST_FAILD or @courseModuleStatus = @CONST_EXPIRED_TIMELAPSED or @courseModuleStatus = @CONST_EXPIRED_NEWCONTENT
begin -- Failed
--------------------
-- Failed  --
--------------------
-- When "Course/Module Status" is set to "Failed"
-- This will find users that:
--  - Belong to any of the Units in @unitIDs
--  - AND are currently assigned Modules from the selected Courses
--  - AND took a quiz, for a Module within the selected Course, within the date range of DateCreated in UserQuizStatus and failed it
--  - AND who currently have a status other than "Passed" for that same quiz
--------------------
/*
Declare @tblResult TABLE
(
-- General
UserID		Int,
Unit		Varchar(200),
[Name]	Varchar(255),
LastName		Varchar(100),
UnitPathWay	Varchar(4000),
[Date]	Datetime,
UserName	varchar(100),
Email	Varchar(255),
ExternalID	varchar(50),
CourseName	varchar(300),
CurrentStatusID int

)
insert into @tblResult
select
tblUser.UserID,
tblUser.UnitID,
tblUser.FirstName + ' ' + tblUser.LastName as 'Name',
tblUser.LastName as 'LastName',
dbo.udfGetUnitPathway(tblUser.UnitID) as 'UnitPathWay',
tblUserQuizStatus.DateCreated as 'Date',
tblUser.Username as 'UserName',
tblUser.Email as 'Email',
tblUser.ExternalID as 'ExternalID',
tblCourse.[Name] as 'CourseName',
currentStatus.UserQuizStatusID -- hidden
From
--< Get user details >--
tblUser
inner join tblUserQuizStatus
on tblUser.UserID = tblUserQuizStatus.UserID

and tblUser.Active = 1
--< Filter By Date Range, Course (via tblModule) and only get the latest result for each user in the date range>--
inner join
(
select
--< Only consider the max (i.e. last added) record in the table, per user (date range is in the where clause)>--
max(UserQuizStatusID) UserQuizStatusID --UserQuizStatusID is identity
from
tblUserQuizStatus
--< tblUserQuizStatus dosent record courseID - have to join on to table module to get it and filter by it >--
inner join tblModule
on tblUserQuizStatus.ModuleID = tblModule.ModuleID
inner join dbo.udfCsvToInt(@courseIDs) invCourses
on tblModule.CourseID = invCourses.IntValue
where tblUserQuizStatus.DateCreated between @dateFrom and dateadd(dd, 1, @dateTo)
and tblModule.Active = 1
group by
UserID, tblUserQuizStatus.ModuleID
) currentStatus
on tblUserQuizStatus.UserQuizStatusID = currentStatus.UserQuizStatusID
and tblUserQuizStatus.QuizStatusID =  case @courseModuleStatus
when @CONST_FAILD then 3   -- Failed
when @CONST_EXPIRED_TIMELAPSED then 4 -- Expired time lapsed
when @CONST_EXPIRED_NEWCONTENT then 5 -- Expired new content
end
--<filter by unit - (on the user table)>--
inner join dbo.udfCsvToInt(@unitIDs) invUnits
on  tblUser.UnitID = invUnits.IntValue
inner join tblModule
on tblUserQuizStatus.ModuleID = tblModule.ModuleID
inner join tblCourse
on tblModule.CourseID = tblCourse.CourseID
select 	UserID,
Unit,
[Name],
LastName,
UnitPathWay,
max([Date]) as [Date],
UserName,
Email,
ExternalID,
CourseName
from @tblResult
group by CourseName,UnitPathWay,Unit,UserName, UserID,[Name],LastName, Email, ExternalID
having (count(CourseName) >= 1)
order by CourseName, Unit, UserID*/

--Find All Modules for all units with access

INSERT INTO @UserModuleWithAccess
SELECT DISTINCT A.UserID, A.ModuleID, A.UnitID FROM
(
	SELECT A.UserID, A.ModuleID, A.UnitID
		FROM vwUserModuleAccess A where courseid in (SELECT courseid from @Courses) )A, @Users B
		Where A.UserID = B.UserID
/*
INSERT INTO @UserModuleWithAccess
SELECT
	B.UserID, A.ModuleID, B.UnitID
FROM
	@AllModules A, @Users  B
WHERE 
	CAST(A.ModuleID AS VARCHAR(10)) + '-' + CAST(B.UnitID AS VARCHAR(10))
	NOT IN
		(SELECT 
			CAST(DeniedModuleID AS VARCHAR(10)) + '-' + CAST(UnitID AS VARCHAR(10))
			FROM tblUnitModuleAccess) 
UNION
SELECT
	B.UserID, A.ModuleID, B.UnitID
FROM
	@AllModules A, @Users B
WHERE 
	CAST(B.UserID AS VARCHAR(10)) + '-' + CAST(A.ModuleID AS VARCHAR(10)) NOT IN
	(SELECT 
		CAST(UserID AS VARCHAR(10)) + '-' + CAST(ModuleID AS VARCHAR(10))
		FROM tblUserModuleAccess WHERE Granted = 0)
*/

--Find the latest status of all quiz for all the modules
INSERT INTO @UsersNQuizStatus
SELECT DISTINCT
	A.UserID, A.ModuleID, A.LatestQuizID, B.QuizStatusID, B.QuizScore
FROM
	(
SELECT 
	A.UserID, A.ModuleID, MAX(B.UserQuizStatusID) AS 'LatestQuizID'
FROM 
	@UserModuleWithAccess A, tblUserQuizStatus B 
WHERE
	A.UserID = B.UserID AND A.ModuleID = B.ModuleID AND
	(B.DateCreated BETWEEN @dateFrom AND dateadd(d,1,@dateTo))
GROUP BY
	A.UserID, A.ModuleID) A, tblUserQuizStatus B
WHERE
	A.UserID = B.UserID AND A.ModuleID = B.ModuleID AND
	A.LatestQuizID = B.UserQuizStatusID 

INSERT INTO @UsersQuizStatusNOTSTARTED
SELECT * FROM @UsersNQuizStatus WHERE QuizStatusID = case @courseModuleStatus
							when @CONST_FAILD then 3   -- Failed
							when @CONST_EXPIRED_TIMELAPSED then 4 -- Expired time lapsed
							when @CONST_EXPIRED_NEWCONTENT then 5 -- Expired new content
							end

--Get Data in report format
SELECT DISTINCT
	A.UserID, B.UnitID AS 'Unit' ,B.FirstName + ' ' + B.LastName as 'Name',
	B.LastName, E.HierarchyName AS 'UnitPathWay', NULL AS 'Date',B.UserName, 
	B.Email, B.ExternalID,

	C.Name AS 'CourseName'
FROM 
	(select distinct userid, moduleid from @UsersQuizStatusNOTSTARTED) A, 
	tblUser B, tblCourse C, tblModule D, tblUnitHierarchy E
WHERE 
	A.UserID = B.UserID AND B.Active = 1 AND
	A.ModuleID = D.ModuleID AND 
	B.UnitID = E.UnitID AND
	D.CourseID = C.CourseID AND C.Active = 1 AND D.Active = 1 /*
GROUP BY 
	C.[Name],E.HierarchyName,B.UnitID,B.FirstName + ' ' + B.LastName, 


	A.UserID,C.[Name],B.LastName, B.UserName,B.Email, B.ExternalID
HAVING 
	(count(C.[Name]) >= 1)*/
ORDER BY 
	CourseName, Unit, A.UserID

end --/ Failed


-- Not started --

if @courseModuleStatus = @CONST_NOTSTARTED
begin -- Not started - Any
--------------------
-- Not started  --
--------------------
-- When "Course/Module Status" is set to "Not Started"
-- This will find users that:
--  - Belong to any of the Units in @unitIDs
--  - AND are currently assigned Modules from the selected Courses
--  - AND who have not started ANY of the quizes they have access to in this course within the selected date range(DateCreated in vwUserQuizStatus)
--------------------
/*
Declare @tblUnitPathWay TABLE

(
UnitID int,
UnitPathWay varchar(4000)
)

DECLARE @Courses TABLE
(
CourseID INT
)

DECLARE @Units TABLE
(
UnitID INT
)

INSERT INTO @Courses SELECT * FROM dbo.udfCsvToInt(@courseIDs)
INSERT INTO @Units SELECT * FROM  dbo.udfCsvToInt(@unitIDs)

insert into @tblUnitPathWay
select distinct
tblUser.UnitID,
dbo.udfGetUnitPathway(intUnits.IntValue)
from tblUser
right join dbo.udfCsvToInt(@unitIDs)intUnits
on tblUser.UnitID = intUnits.IntValue


SELECT DISTINCT
A.UserID,B.UnitID,B.FirstName + ' ' + B.LastName as 'Name',
B.LastName, D.UnitPathWay, NULL AS 'Date', B.UserName, B.Email, B.ExternalID, C.Name AS 'CourseName'
FROM
(
SELECT
A.ModuleID, A.CourseID, A.UserID,B.QuizStatusID, B.UserQuizStatusID
FROM
(
SELECT
A.ModuleID, A.CourseID, A.UserID
FROM
vwUserModuleAccess A
WHERE
A.OrganisationID = @organisationID AND CourseID IN (SELECT CourseID FROM @Courses) AND
A.UnitID IN (SELECT UnitID FROM @Units)
) A,
(

SELECT B.UserID, A.ModuleID, A.CourseID, A.QuizStatusID, UserQuizStatusID
FROM vwUserQuizStatus A, tblUser B
WHERE
A.UserID = B.UserID and B.OrganisationID = @organisationID AND
A.QuizStatusID NOT IN (2,3) AND	A.CourseID IN (SELECT CourseID FROM @Courses) AND
A.DateCreated BETWEEN @dateFrom AND dateadd(d,1,@dateTo) AND A.UserID NOT IN
(SELECT UserID
FROM
vwUserQuizStatus
WHERE
QuizStatusID IN (2,3) AND CourseID IN (SELECT CourseID FROM @Courses) AND
DateCreated BETWEEN @dateFrom AND dateadd(d,1,@dateTo))
) B
WHERE A.UserID = B.UserID AND A.CourseID = B.CourseID AND A.ModuleID = A.ModuleID
) A, tblUser B, tblCourse C, @tblUnitPathWay D
WHERE
A.UserID = B.UserID AND A.CourseID = C.CourseID AND
B.UnitID = D.UnitID
*/

--Find All Modules for all units with access

INSERT INTO @UserModuleWithAccess
SELECT DISTINCT A.UserID, A.ModuleID, A.UnitID FROM
(
	SELECT A.UserID, A.ModuleID, A.UnitID
		FROM vwUserModuleAccess A where courseid in (SELECT courseid from @Courses) )A, @Users B
		Where A.UserID = B.UserID
/*
INSERT INTO @UserModuleWithAccess
SELECT
	B.UserID, A.ModuleID, B.UnitID
FROM
	@AllModules A, @Users  B
WHERE 
	CAST(A.ModuleID AS VARCHAR(10)) + '-' + CAST(B.UnitID AS VARCHAR(10))
	NOT IN
		(SELECT 
			CAST(DeniedModuleID AS VARCHAR(10)) + '-' + CAST(UnitID AS VARCHAR(10))
			FROM tblUnitModuleAccess) 
UNION
SELECT
	B.UserID, A.ModuleID, B.UnitID
FROM
	@AllModules A, @Users B
WHERE 
	CAST(B.UserID AS VARCHAR(10)) + '-' + CAST(A.ModuleID AS VARCHAR(10)) NOT IN
	(SELECT 
		CAST(UserID AS VARCHAR(10)) + '-' + CAST(ModuleID AS VARCHAR(10))
		FROM tblUserModuleAccess WHERE Granted = 0)

*/

--Find the latest status of all quiz for all the modules
INSERT INTO @UsersNQuizStatus
SELECT  DISTINCT
	A.UserID, A.ModuleID, A.LatestQuizID, B.QuizStatusID, B.QuizScore
FROM
	(
SELECT 
	A.UserID, A.ModuleID, MAX(B.UserQuizStatusID) AS 'LatestQuizID'
FROM 
	@UserModuleWithAccess A, tblUserQuizStatus B 
WHERE
	A.UserID = B.UserID AND A.ModuleID = B.ModuleID
GROUP BY
	A.UserID, A.ModuleID) A, tblUserQuizStatus B
WHERE
	A.UserID = B.UserID AND A.ModuleID = B.ModuleID AND
	A.LatestQuizID = B.UserQuizStatusID AND
	(B.DateCreated BETWEEN @dateFrom AND dateadd(d,1,@dateTo))

--select * from @UsersNQuizStatus

--Get User with Quiz NOT STARTED
INSERT INTO @UsersQuizStatusNOTSTARTED
SELECT * FROM @UsersNQuizStatus WHERE QuizStatusID NOT IN (2,3,4,5) AND
UserID NOT IN (SELECT UserID FROM @UsersNQuizStatus WHERE QuizStatusID IN (2,3,4,5))

--select * from @UsersQuizStatusNOTSTARTED
--select distinct userid,moduleid from @UsersQuizStatusNOTSTARTED

--Get Data in report format
SELECT DISTINCT
	A.UserID, B.UnitID ,B.FirstName + ' ' + B.LastName as 'Name',
	B.LastName, E.HierarchyName AS 'UnitPathWay', NULL AS 'Date',B.UserName, B.Email, B.ExternalID,
	C.Name AS 'CourseName'
FROM 
	(select distinct userid, moduleid from @UsersQuizStatusNOTSTARTED) A, 
	tblUser B, tblCourse C, tblModule D, tblUnitHierarchy E
WHERE 
	A.UserID = B.UserID AND B.Active = 1 AND
	A.ModuleID = D.ModuleID AND B.UnitID = E.UnitID AND
	D.CourseID = C.CourseID AND C.Active = 1 AND D.Active = 1
end --/ Not started - Any


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
