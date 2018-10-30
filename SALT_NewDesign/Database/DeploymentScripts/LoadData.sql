
-- Parameters: 
-- This values will be set in the deployment process
-- {0} Databasename
-- {1} WEB SQL Login
-- {2} Salt Administrator username
-- {3} Salt Administrator password

--Load data for lookup tables

SET IDENTITY_INSERT tblCourseStatus on
insert into tblCourseStatus(CourseStatusID,status) values(0,'Unassigned')
insert into tblCourseStatus(CourseStatusID,status) values(1,'InComplete')
insert into tblCourseStatus(CourseStatusID,status) values(2,'Complete')
SET IDENTITY_INSERT tblCourseStatus Off
go
 
SET IDENTITY_INSERT tblErrorLevel on
insert into tblErrorLevel(ErrorLevelID,ErrorLevelDescription) values(1,'High')
insert into tblErrorLevel(ErrorLevelID,ErrorLevelDescription) values(2,'Medium')
insert into tblErrorLevel(ErrorLevelID,ErrorLevelDescription) values(3,'Low')
insert into tblErrorLevel(ErrorLevelID,ErrorLevelDescription) values(4,'Warning')
insert into tblErrorLevel(ErrorLevelID,ErrorLevelDescription) values(5,'Infomation')
SET IDENTITY_INSERT tblErrorLevel Off
go

SET IDENTITY_INSERT tblErrorStatus on
insert into tblErrorStatus(ErrorStatusID,ErrorStatusDescription) values(1,'Un-Assigned')
insert into tblErrorStatus(ErrorStatusID,ErrorStatusDescription) values(2,'Assigned')
insert into tblErrorStatus(ErrorStatusID,ErrorStatusDescription) values(3,'Need More Info')
insert into tblErrorStatus(ErrorStatusID,ErrorStatusDescription) values(4,'No Solution')
insert into tblErrorStatus(ErrorStatusID,ErrorStatusDescription) values(5,'Fixed')
SET IDENTITY_INSERT tblErrorStatus Off
go

SET IDENTITY_INSERT tblLessonStatus on
insert into tblLessonStatus(LessonStatusID,Status) values(0,'Unassigned')
insert into tblLessonStatus(LessonStatusID,Status) values(1,'Not Started')
insert into tblLessonStatus(LessonStatusID,Status) values(2,'In Progress')
insert into tblLessonStatus(LessonStatusID,Status) values(3,'Completed')
insert into tblLessonStatus(LessonStatusID,Status) values(4,'Expired (Time Elapsed)')
insert into tblLessonStatus(LessonStatusID,Status) values(5,'Expired (New Content)')
SET IDENTITY_INSERT tblLessonStatus Off
go

SET IDENTITY_INSERT tblQuizStatus on
insert into tblQuizStatus(QuizStatusID,Status) values(0,'Unassigned')
insert into tblQuizStatus(QuizStatusID,Status) values(1,'Not Started')
insert into tblQuizStatus(QuizStatusID,Status) values(2,'Passed')
insert into tblQuizStatus(QuizStatusID,Status) values(3,'Failed')
insert into tblQuizStatus(QuizStatusID,Status) values(4,'Expired (Time Elapsed)')
insert into tblQuizStatus(QuizStatusID,Status) values(5,'Expired (New Content)')
SET IDENTITY_INSERT tblQuizStatus Off
go

SET IDENTITY_INSERT tblUserType on
insert into tblUserType(UserTypeID,Type) values(1,'Salt Administrator')
insert into tblUserType(UserTypeID,Type) values(2,'Organisation Administrator')
insert into tblUserType(UserTypeID,Type) values(3,'Unit Administrator')
insert into tblUserType(UserTypeID,Type) values(4,'User')
SET IDENTITY_INSERT tblUserType Off
go

-- AboutWarningText
insert into tblAppConfig(name, value) values('AboutWarningText', 'This program and the data contained in or processed by this program belong to Blake Dawson and are protected by copyright law. It is a breach of copyright law to reproduce, modify or communicate to the public any part of this program or those data, without our prior consent. ')
-- AppName
insert into tblAppConfig(name, value) values('AppName', 'Salt')
-- BrandingCompanyName
insert into tblAppConfig(name, value) values('BrandingCompanyName', 'Blake Dawson')
-- BrandingCompanyURL
insert into tblAppConfig(name, value) values('BrandingCompanyURL', 'http://www.blakedawson.com')
-- ButtonSet
insert into tblAppConfig(name, value) values('ButtonSet', 'BDW')
-- CopyrightYear
insert into tblAppConfig(name, value) values('CopyrightYear', '2007')
-- ExternalLinkDisclaimer
insert into tblAppConfig(name, value) values('ExternalLinkDisclaimer', 'DISCLAIMER\r\nThe site you are about to visit is not part of this SALT training program.\r\nBlake Dawson has no control over the content, goods and services offered on or through that site.\r\nThis link to that site does not indicate endorsement, approval or recommendation of that site or the operators of that site by Blake Dawson.\r\n\r\nClick ''OK'' to continue to the link or ''Cancel'' to return to the SALT training program.')
-- FromEmail

-- FromName

-- HomePageFooter
insert into tblAppConfig(name, value) values('HomePageFooter', 'contains fictitious characters and companies which are designed as training aids. The fictitious characters and companies typically appear in screens titled "Meet the Players" and in hypothetical scenarios where users are required to answer questions. Any resemblance between these fictitious characters and companies and any person living or deceased or any company, venture, business or partnership is purely coincidental.')
-- LisencedTo
insert into tblAppConfig(name, value) values('LisencedTo', 'Blake Dawson')
-- MailServer
insert into tblAppConfig(name, value) values('MailServer', 'mailhost.blakedawson.com')
-- PageSize
insert into tblAppConfig(name, value) values('PageSize', '10')
-- PrivacyPolicyURL
insert into tblAppConfig(name, value) values('PrivacyPolicyURL', 'http://www.blakedawson.com/scripts/privacy.asp')
-- ShowDetailedHelp
INSERT INTO tblOrganisationConfig ([OrganisationID], [Name], [Description],[Value])	VALUES(null, 'ShowDetailedHelp', 'Show Detailed Help (Y/N)','Y')
-- StyleSheet
insert into tblAppConfig(name, value) values('StyleSheet', 'unknown.css')
-- SupportEmail
insert into tblAppConfig(name, value) values('SupportEmail', 'productsupport@blakedawson.com')
-- TermsOfUseURL
insert into tblAppConfig(name, value) values('TermsOfUseURL', '/termsofuse.html')
-- ToolbookDelay
insert into tblAppConfig(name, value) values('ToolbookDelay', '500')
-- TradeMark
insert into tblAppConfig(name, value) values('TradeMark', 'TM')
go

                                                                                           
insert into tblVersion(Version) values('Salt 4.2.1')
go
  
--Load Default data
--Insert  salt admin
SET IDENTITY_INSERT tblUser On
insert into tblUser(UserID,FirstName,LastName,UserName,Password,Email,UserTypeID,Active,CreatedBy)
			values(1, 'Administrator','Application','{2}','{3}','ProductSupport@blakedawson.com', 1,1, 1)
SET IDENTITY_INSERT tblUser Off
go

--Insert default organisation
SET IDENTITY_INSERT tblOrganisation On
insert into tblOrganisation(OrganisationID,OrganisationName,Logo,Notes,DefaultLessonFrequency,DefaultQuizFrequency,DefaultQuizPassMark,CreatedBy)
			values(1, 'My Organisation Name','logo.gif','This is created during installation.', 12,12,80,1)
			
SET IDENTITY_INSERT tblOrganisation Off
go

-- Default css for organisations
INSERT INTO tblOrganisationConfig ([OrganisationID], [Name], [Description], [Value])	
VALUES(null, 'css', 'Stylesheet','default.css')

-- Default number of questions to ask
INSERT INTO tblOrganisationConfig ([OrganisationID], [Name], [Description],[Value])	
VALUES(null, 'Number_Of_Quiz_Questions', 'Quiz Questions To Ask','10')


go

-- Insert default email content
Declare @strCompleteReportToAdministrators      nvarchar(4000)
Declare @strInCompleteReportToAdministrators    nvarchar(4000)
Declare @strFailedReportToAdministrators        nvarchar(4000)
Declare @strNotStartedReportToAdministrators    nvarchar(4000)
Declare @strCompleteReportToUsers               nvarchar(4000)
Declare @strInCompleteReportToUsers             nvarchar(4000)
Declare @strFailedReportToUsers                 nvarchar(4000)
Declare @strNotStartedReportToUsers             nvarchar(4000)
Declare @strExpiredTimeElapsedReportToUsers		nvarchar(4000)
Declare @strExpiredTimeElapsedReportToAdministrators nvarchar(4000)
Declare	@strExpiredNewContentReportToUsers		nvarchar(4000)
Declare @strExpiredNewContentReportToAdministrators nvarchar(4000)

-- Email report for Completed users to Administrators
-- Subject:  salt %COURSE_NAME% Report
Set @strCompleteReportToAdministrators='<BR>Hi %FirstName%,'
Set @strCompleteReportToAdministrators=@strCompleteReportToAdministrators + '<BR>The following users have completed their %APP_NAME% %COURSE_NAME% course between %DATE_FROM% and %DATE_TO%:'
Set @strCompleteReportToAdministrators=@strCompleteReportToAdministrators + '<BR>%USER_LIST%'
Set @strCompleteReportToAdministrators=@strCompleteReportToAdministrators + '<BR>Regards,'
Set @strCompleteReportToAdministrators=@strCompleteReportToAdministrators + '<BR>%APP_NAME% Administrator'
INSERT INTO tblOrganisationConfig ([OrganisationID], [Name], [Description], [Value])	
VALUES(null, 'Email_Report_Complete_To_Administrators','Email to Completed Users Administrators', @strCompleteReportToAdministrators)

-- Email report for InCompleted users to Administrators
-- Subject:  salt %COURSE_NAME% Report
Set @strInCompleteReportToAdministrators='<BR>Hi %FirstName%,'
Set @strInCompleteReportToAdministrators=@strInCompleteReportToAdministrators + '<BR>The following users have not completed their %APP_NAME% %COURSE_NAME% course'
Set @strInCompleteReportToAdministrators=@strInCompleteReportToAdministrators + '<BR>%USER_LIST%'
Set @strInCompleteReportToAdministrators=@strInCompleteReportToAdministrators + '<BR>Regards,'
Set @strInCompleteReportToAdministrators=@strInCompleteReportToAdministrators + '<BR>%APP_NAME% Administrator'
INSERT INTO tblOrganisationConfig ([OrganisationID], [Name], [Description], [Value])	
VALUES(null, 'Email_Report_InComplete_To_Administrators','Email to Incompleted Users Administrators', @strInCompleteReportToAdministrators)


-- Email report for Failed users to Administrators
-- Subject:  %APP_NAME% %COURSE_NAME% Report
Set @strFailedReportToAdministrators='<BR>Hi %FirstName%,'
Set @strFailedReportToAdministrators=@strFailedReportToAdministrators + '<BR>The following users have failed some of their testing in the %APP_NAME% %COURSE_NAME% course.'
Set @strFailedReportToAdministrators=@strFailedReportToAdministrators + '<BR>%USER_LIST%'
Set @strFailedReportToAdministrators=@strFailedReportToAdministrators + '<BR>Regards,'
Set @strFailedReportToAdministrators=@strFailedReportToAdministrators + '<BR>%APP_NAME% Administrator'
INSERT INTO tblOrganisationConfig ([OrganisationID], [Name], [Description], [Value])	
VALUES(null, 'Email_Report_Failed_To_Administrators','Email to Failed Users Administrators', @strFailedReportToAdministrators)

-- Email report for Not Started users to Administrators
-- Subject:  %APP_NAME% %COURSE_NAME% Report
Set @strNotStartedReportToAdministrators='<BR>Hi %FirstName%,'
Set @strNotStartedReportToAdministrators=@strNotStartedReportToAdministrators + '<BR>The following users have not started some of their testing in the %APP_NAME% %COURSE_NAME% course.'
Set @strNotStartedReportToAdministrators=@strNotStartedReportToAdministrators + '<BR>%USER_LIST%'
Set @strNotStartedReportToAdministrators=@strNotStartedReportToAdministrators + '<BR>Regards,'
Set @strNotStartedReportToAdministrators=@strNotStartedReportToAdministrators + '<BR>%APP_NAME% Administrator'
INSERT INTO tblOrganisationConfig ([OrganisationID], [Name], [Description], [Value])	
VALUES(null, 'Email_Report_Not_Started_Administrators','Email to Not Started Users Administrators',@strNotStartedReportToAdministrators )

-- Email report for Expired (Time Elapsed) users to Administrators
-- Subject:  %APP_NAME% %COURSE_NAME% Training
Set @strExpiredTimeElapsedReportToAdministrators='<BR>Hi %FirstName%,'
Set @strExpiredTimeElapsedReportToAdministrators=@strExpiredTimeElapsedReportToAdministrators + '<BR>The following users have expired (time elapsed) some of their testing in the %APP_NAME% %COURSE_NAME% course.'
Set @strExpiredTimeElapsedReportToAdministrators=@strExpiredTimeElapsedReportToAdministrators + '<BR>%USER_LIST%'
Set @strExpiredTimeElapsedReportToAdministrators=@strExpiredTimeElapsedReportToAdministrators + '<BR>Regards,'
Set @strExpiredTimeElapsedReportToAdministrators=@strExpiredTimeElapsedReportToAdministrators + '<BR>%APP_NAME% Administrator'
INSERT INTO tblOrganisationConfig ([OrganisationID], [Name], [Description], [Value])	
VALUES(null, 'Email_Report_Expired_Time_Elapsed_To_Administrators','Email to Expired (Time Elapsed) Users', @strExpiredTimeElapsedReportToAdministrators)

-- Email report for Expired (New Content) users to Administrators
-- Subject:  %APP_NAME% %COURSE_NAME% Training
Set @strExpiredNewContentReportToAdministrators='<BR>Hi %FirstName%,'
Set @strExpiredNewContentReportToAdministrators=@strExpiredNewContentReportToAdministrators + '<BR>The following users have expired (new content) some of their testing in the %APP_NAME% %COURSE_NAME% course.'
Set @strExpiredNewContentReportToAdministrators=@strExpiredNewContentReportToAdministrators + '<BR>%USER_LIST%'
Set @strExpiredNewContentReportToAdministrators=@strExpiredNewContentReportToAdministrators + '<BR>Regards,'
Set @strExpiredNewContentReportToAdministrators=@strExpiredNewContentReportToAdministrators + '<BR>%APP_NAME% Administrator'
INSERT INTO tblOrganisationConfig ([OrganisationID], [Name], [Description], [Value])	
VALUES(null, 'Email_Report_Expired_New_Content_To_Administrators','Email to Expired (New Content) Users', @strExpiredNewContentReportToAdministrators)

-- Email report for Completed users to Users
-- Subject:  %APP_NAME% Courses
Set @strCompleteReportToUsers='<BR>Hi %FirstName%,'
Set @strCompleteReportToUsers=@strCompleteReportToUsers + '<BR>Congratulations!  You have completed the following %APP_NAME% courses:'
Set @strCompleteReportToUsers=@strCompleteReportToUsers + '<BR>	%COURSE_NAMES%<BR>'
Set @strCompleteReportToUsers=@strCompleteReportToUsers + '<BR>Please log on to the %APP_NAME% Online Compliance Training website to print your certificate of completion.'
Set @strCompleteReportToUsers=@strCompleteReportToUsers + '<BR>Thank you for your efforts.'
Set @strCompleteReportToUsers=@strCompleteReportToUsers + '<BR>Regards,'
Set @strCompleteReportToUsers=@strCompleteReportToUsers + '<BR>%APP_NAME% Administrator'
INSERT INTO tblOrganisationConfig ([OrganisationID], [Name], [Description], [Value])	
VALUES(null, 'Email_Report_Complete_To_Users','Email to Completed Users', @strCompleteReportToUsers)

-- Email report for InCompleted users to Users
-- Subject:  %APP_NAME% Courses
Set @strInCompleteReportToUsers='<BR>Hi %FirstName%,'
Set @strInCompleteReportToUsers=@strInCompleteReportToUsers + '<BR>Our records show that you have not completed the following %APP_NAME% courses:'
Set @strInCompleteReportToUsers=@strInCompleteReportToUsers + '<BR>	%COURSE_NAMES%<BR>'
Set @strInCompleteReportToUsers=@strInCompleteReportToUsers + '<BR>Please return to the %APP_NAME% Online Compliance Training website and complete all outstanding quizzes.'
Set @strInCompleteReportToUsers=@strInCompleteReportToUsers + '<BR>It is recommended that you review the lessons before attempting a quiz.'
Set @strInCompleteReportToUsers=@strInCompleteReportToUsers + '<BR>Regards,'
Set @strInCompleteReportToUsers=@strInCompleteReportToUsers + '<BR>%APP_NAME% Administrator'
INSERT INTO tblOrganisationConfig ([OrganisationID], [Name], [Description], [Value])	
VALUES(null, 'Email_Report_Incomplete_To_Users','Email to InCompleted Users', @strInCompleteReportToUsers)

-- Email report for Failed users to Users
-- Subject:  %APP_NAME% Courses
Set @strFailedReportToUsers='<BR>Hi %FirstName%,'
Set @strFailedReportToUsers=@strFailedReportToUsers + '<BR>Our records show that you have failed some of the following %APP_NAME% courses:'
Set @strFailedReportToUsers=@strFailedReportToUsers + '<BR>	%COURSE_NAMES%<BR>'
Set @strFailedReportToUsers=@strFailedReportToUsers + '<BR>Please return to the %APP_NAME% Online Compliance Training website and redo your failed quizzes.'
Set @strFailedReportToUsers=@strFailedReportToUsers + '<BR>It is also recommended that you review the lesson before attempting the quiz.'
Set @strFailedReportToUsers=@strFailedReportToUsers + '<BR>Regards,'
Set @strFailedReportToUsers=@strFailedReportToUsers + '<BR>%APP_NAME% Administrator'
INSERT INTO tblOrganisationConfig ([OrganisationID], [Name], [Description], [Value])	
VALUES(null, 'Email_Report_Failed_To_Users','Email to Failed Users', @strFailedReportToUsers)


-- Email report for Not Started users to Users
-- Subject:  %APP_NAME% Courses
Set @strNotStartedReportToUsers='<BR>Hi %FirstName%,'
Set @strNotStartedReportToUsers=@strNotStartedReportToUsers + '<BR>Our records show that you have not started the following %APP_NAME% courses:'
Set @strNotStartedReportToUsers=@strNotStartedReportToUsers + '<BR>	%COURSE_NAMES%<BR>'
Set @strNotStartedReportToUsers=@strNotStartedReportToUsers + '<BR>Please log on to the %APP_NAME% Online Compliance Training website and complete all outstanding quizzes.'
Set @strNotStartedReportToUsers=@strNotStartedReportToUsers + '<BR>It is recommended that you review the lesson before attempting a quiz.'
Set @strNotStartedReportToUsers=@strNotStartedReportToUsers + '<BR>Regards,'
Set @strNotStartedReportToUsers=@strNotStartedReportToUsers + '<BR>%APP_NAME% Administrator'
INSERT INTO tblOrganisationConfig ([OrganisationID], [Name], [Description], [Value])	
VALUES(null, 'Email_Report_Not_Started_To_Users','Email to Not Started Users', @strNotStartedReportToUsers)


-- Email report for Expired (Time Elapsed) users to Users
-- Subject:  %APP_NAME% Courses
Set @strExpiredTimeElapsedReportToUsers='<BR>Hi %FirstName%,'
Set @strExpiredTimeElapsedReportToUsers=@strExpiredTimeElapsedReportToUsers + '<BR>Our records show that your training for the following %APP_NAME% courses has expired:'
Set @strExpiredTimeElapsedReportToUsers=@strExpiredTimeElapsedReportToUsers + '<BR>	%COURSE_NAMES%<BR>'
Set @strExpiredTimeElapsedReportToUsers=@strExpiredTimeElapsedReportToUsers + '<BR>Please return to the %APP_NAME% Online Compliance Training website and complete all outstanding quizzes.'
Set @strExpiredTimeElapsedReportToUsers=@strExpiredTimeElapsedReportToUsers + '<BR>It is recommended that you review the lesson before attempting a quiz.'
Set @strExpiredTimeElapsedReportToUsers=@strExpiredTimeElapsedReportToUsers + '<BR>Regards,'
Set @strExpiredTimeElapsedReportToUsers=@strExpiredTimeElapsedReportToUsers + '<BR>%APP_NAME% Administrator'
INSERT INTO tblOrganisationConfig ([OrganisationID], [Name], [Description], [Value])	
VALUES(null, 'Email_Report_Expired_Time_Elapsed_To_Users','Email to Expired (Time Elapsed) Users', @strExpiredTimeElapsedReportToUsers)

-- Email report for Expired (New Content) users to Users
-- Subject:  %APP_NAME% Courses
Set @strExpiredNewContentReportToUsers='<BR>Hi %FirstName%,'
Set @strExpiredNewContentReportToUsers=@strExpiredNewContentReportToUsers + '<BR>Our records show that you have new content for the following %APP_NAME% courses requiring completion:'
Set @strExpiredNewContentReportToUsers=@strExpiredNewContentReportToUsers + '<BR>	%COURSE_NAMES%<BR>'
Set @strExpiredNewContentReportToUsers=@strExpiredNewContentReportToUsers + '<BR>Please return to the %APP_NAME% Online Compliance Training website and complete all outstanding quizzes.'
Set @strExpiredNewContentReportToUsers=@strExpiredNewContentReportToUsers + '<BR>It is recommended that you review the lesson before attempting a quiz.'
Set @strExpiredNewContentReportToUsers=@strExpiredNewContentReportToUsers + '<BR>Regards,'
Set @strExpiredNewContentReportToUsers=@strExpiredNewContentReportToUsers + '<BR>%APP_NAME% Administrator'
INSERT INTO tblOrganisationConfig ([OrganisationID], [Name], [Description], [Value])	
VALUES(null, 'Email_Report_Expired_New_Content_To_Users','Email to Expired (New Content) Users', @strExpiredNewContentReportToUsers)



INSERT [tblOrganisationConfig] ([OrganisationID], [Name], [Description], [Value]) VALUES (NULL, N'Email_Incomplete_CPD_User', N'Email to Incomplete CPD Users', N'<BR>Hi %FirstName%,<BR>You have not completed your Continuous Professional Development.<BR><BR>Regards,<BR>%APP_NAME% Administrator')
INSERT [tblOrganisationConfig] ([OrganisationID], [Name], [Description], [Value]) VALUES (NULL, N'Email_Incomplete_CPD_Administrator', N'Email to Incomplete CPD Administrator', N'<BR>Hi %FirstName%,<BR>The following users have not completed their CPD.<BR>%USER_LIST%<BR><BR>Regards,<BR>%APP_NAME% Administrator')
INSERT [tblOrganisationConfig] ([OrganisationID], [Name], [Description], [Value]) VALUES (NULL, N'Policy_Email_Report_Accepted_To_Users', N'Policy_Email to Accepted Users', N'<BR>Hi %FirstName%,<BR>Thank You for taking the time to Read and accept the %POLICY% policy <BR><BR>Regards,<BR>%APP_NAME% Administrator')
INSERT [tblOrganisationConfig] ([OrganisationID], [Name], [Description], [Value]) VALUES (NULL, N'Policy_Email_Report_Not_Accepted_To_Users', N'Policy_Email to Not Accepted Users', N'<BR>Hi %FirstName%,<BR>Our Records show that you have not logged into %APP_NAME% to read and acknowledge the following policy: <BR> %POLICY% <BR> Please login into %APP_NAME% Online Compliance Training to access the policies assigned to you.<BR><BR>Regards,<BR>%APP_NAME% Administrator')
INSERT [tblOrganisationConfig] ([OrganisationID], [Name], [Description], [Value]) VALUES (NULL, N'Policy_Email_Report_Accepted_To_Administrators', N'Policy_Email to Accepted Users Administrators', N'<BR>Hi %FirstName%,<BR>The following users have accepted their %POLICY% policy between %DATE_FROM% and %DATE_TO%:<BR>%USER_LIST%<BR>Regards,<BR>%APP_NAME% Administrator')
INSERT [tblOrganisationConfig] ([OrganisationID], [Name], [Description], [Value]) VALUES (NULL, N'Policy_Email_Report_Not_Accepted_To_Administrators', N'Policy_Email to Not Accepted Users Administrators', N'<BR>Hi %FirstName%,<BR>The following users have  not read their %POLICY% policy between %DATE_FROM% and %DATE_TO%:<BR>%USER_LIST%<BR>Regards,<BR>%APP_NAME% Administrator')

INSERT [tblOrganisationConfig] ([OrganisationID], [Name], [Description], [Value]) VALUES (NULL, N'Student_Summary_Header', N'Student Summary Header', N'Hi %FirstName% %LastName%, Our Records show that the following changes have occurred to your course status for %APP_NAME%:<BR>')
--Student Summary Header

INSERT [tblOrganisationConfig] ([OrganisationID], [Name], [Description], [Value]) VALUES (NULL, N'Student_Summary_Sig', N'Student Summary Sig', N'Regards,%APP_NAME% Administrator ')
--Student Summary Sig

INSERT [tblOrganisationConfig] ([OrganisationID], [Name], [Description], [Value]) VALUES (NULL, N'Student_Summary_ExpiredContent', N'Student Summary - Expired Content', N'The content of the following Courses - Modules has been updated and you are required to redo them')
--Student Summary - Expired Content

INSERT [tblOrganisationConfig] ([OrganisationID], [Name], [Description], [Value]) VALUES (NULL, N'Student_Summary_PassedCourses', N'Student Summary -Passed Courses', N'Congratulations on passing the following courses:<BR>')
--Student Summary -Passed Courses

INSERT [tblOrganisationConfig] ([OrganisationID], [Name], [Description], [Value]) VALUES (NULL, N'Student_Summary_PassedModules ', N'Student Summary - Passed Modules', N'Congratulations on passing the following modules:<BR>')
--Student Summary - Passed Modules

INSERT [tblOrganisationConfig] ([OrganisationID], [Name], [Description], [Value]) VALUES (NULL, N'Student_Summary_At_Risk_Of_Expiry', N'Student Summary - At Risk Of Expiry', N'Your quiz results for the following Courses (Modules) will expire unless you complete the entire course before the dates shown:<BR>')
--Student Summary - At Risk Of Expiry

INSERT [tblOrganisationConfig] ([OrganisationID], [Name], [Description], [Value]) VALUES (NULL, N'Student_Summary_At_RiskOfbeingOverdue', N'Student Summary - At Risk Of being Overdue', N'You were nominated to complete the following courses before the dates shown however our records indicate that the courses are not finished at this time.<BR>Please ensure that the courses are finished by the nominated dates:<BR>')
--Student Summary - At Risk Of being Overdue

INSERT [tblOrganisationConfig] ([OrganisationID], [Name], [Description], [Value]) VALUES (NULL, N'Student_Summary_Subject', N'Student Summary Message Subject', N'%APP_NAME% Summary.')
--Student Summary Message Subject 

INSERT [tblOrganisationConfig] ([OrganisationID], [Name], [Description], [Value]) VALUES (NULL, N'Overdue_Summary_Header', N'Overdue Summary Header', N'Hi %FirstName% %LastName%, The Following students are now Overdue for their %APP_NAME% courses:<BR>')
--Overdue Summary Header

INSERT [tblOrganisationConfig] ([OrganisationID], [Name], [Description], [Value]) VALUES (NULL, N'Overdue_Summary_Sig', N'Overdue Summary Sig', N'<BR>Regards,%APP_NAME% Administrator')
--Overdue Summary Sig

INSERT [tblOrganisationConfig] ([OrganisationID], [Name], [Description], [Value]) VALUES (NULL, N'Overdue_Summary_Subject', N'Overdue Summary Message Subject', N'%APP_NAME% Overdue Summary.')
--Overdue Summary Message Subject 

INSERT [tblOrganisationConfig] ([OrganisationID], [Name], [Description], [Value]) VALUES (NULL, N'Student_Summary_NewStarter', N'Student Summary - New Starter Greeting', N'Hi %FirstName% %LastName%, you have been registered for use of the %APP_NAME% WebSite at %URL%, <BR>Your UserName is %USERNAME% and your initial password is %PASSWORD%.<BR>Please login and change your password as soon as possible.')
--Student Summary - New Starter Greeting

INSERT [tblOrganisationConfig] ([OrganisationID], [Name], [Description], [Value]) VALUES (NULL, N'Email_Failure_delivery_notification', N'Email Failure delivery notification', N'Email Failure delivery notification, the following message failed to be sent for 3 days to the following email address: ')
--Email Failure delivery notification 

if not exists (select * from tblAppConfig where Name ='Email_OnBehalfOf') begin
	insert into tblAppConfig (Name, Value) values('Email_OnBehalfOf','ENTER_ON_BEHALF_OF_EMAIL@ADDRESS.HERE')
end