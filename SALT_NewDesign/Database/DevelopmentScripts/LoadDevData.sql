 -- Script generated on 10/03/2004 2:46 PM
-- By: Jack Liu
-- Server: DEV2K41

-- Parameters: 
-- This values will be set in the deployment process
-- {0} Databasename
-- {1} WEB SQL Login
-- {2} Salt Administrator username
-- {3} Salt Administrator password

--Load data for lookup tables
Delete from tblCourseStatus
SET IDENTITY_INSERT tblCourseStatus on
insert into tblCourseStatus(CourseStatusID,status) values(0,'UnAssigned')
insert into tblCourseStatus(CourseStatusID,status) values(1,'InComplete')
insert into tblCourseStatus(CourseStatusID,status) values(2,'Complete')
SET IDENTITY_INSERT tblCourseStatus Off
go
Delete from tblErrorLog
Delete from tblErrorLevel
SET IDENTITY_INSERT tblErrorLevel on
insert into tblErrorLevel(ErrorLevelID,ErrorLevelDescription) values(1,'High')
insert into tblErrorLevel(ErrorLevelID,ErrorLevelDescription) values(2,'Medium')
insert into tblErrorLevel(ErrorLevelID,ErrorLevelDescription) values(3,'Low')
insert into tblErrorLevel(ErrorLevelID,ErrorLevelDescription) values(4,'Warning')
insert into tblErrorLevel(ErrorLevelID,ErrorLevelDescription) values(5,'Infomation')
SET IDENTITY_INSERT tblErrorLevel Off
go
Delete from tblErrorStatus
SET IDENTITY_INSERT tblErrorStatus on
insert into tblErrorStatus(ErrorStatusID,ErrorStatusDescription) values(1,'Un-Assigned')
insert into tblErrorStatus(ErrorStatusID,ErrorStatusDescription) values(2,'Assigned')
insert into tblErrorStatus(ErrorStatusID,ErrorStatusDescription) values(3,'Need More Info')
insert into tblErrorStatus(ErrorStatusID,ErrorStatusDescription) values(4,'No Solution')
insert into tblErrorStatus(ErrorStatusID,ErrorStatusDescription) values(5,'Fixed')
SET IDENTITY_INSERT tblErrorStatus Off
go

Delete from tblLessonStatus
SET IDENTITY_INSERT tblLessonStatus on
insert into tblLessonStatus(LessonStatusID,Status) values(0,'Unassigned')
insert into tblLessonStatus(LessonStatusID,Status) values(1,'Not Started')
insert into tblLessonStatus(LessonStatusID,Status) values(2,'In Progress')
insert into tblLessonStatus(LessonStatusID,Status) values(3,'Completed')
insert into tblLessonStatus(LessonStatusID,Status) values(4,'Expired (Time Elapsed)')
insert into tblLessonStatus(LessonStatusID,Status) values(5,'Expired (New Content)')
SET IDENTITY_INSERT tblLessonStatus Off
go

Delete from tblQuizStatus
SET IDENTITY_INSERT tblQuizStatus on
insert into tblQuizStatus(QuizStatusID,Status) values(0,'Unassigned')
insert into tblQuizStatus(QuizStatusID,Status) values(1,'Not Started')
insert into tblQuizStatus(QuizStatusID,Status) values(2,'Passed')
insert into tblQuizStatus(QuizStatusID,Status) values(3,'Failed')
insert into tblQuizStatus(QuizStatusID,Status) values(4,'Expired (Time Elapsed)')
insert into tblQuizStatus(QuizStatusID,Status) values(5,'Expired (New Content)')
SET IDENTITY_INSERT tblQuizStatus Off
go

Delete from tblUserType
SET IDENTITY_INSERT tblUserType on
insert into tblUserType(UserTypeID,Type) values(1,'Salt Administrator')
insert into tblUserType(UserTypeID,Type) values(2,'Organisation Administrator')
insert into tblUserType(UserTypeID,Type) values(3,'Unit Administrator')
insert into tblUserType(UserTypeID,Type) values(4,'User')
SET IDENTITY_INSERT tblUserType Off
go

Delete from tblAppConfig
go


--Load custom data
delete from tblAppConfig



insert into tblAppConfig(name, value) values('AboutWarningText', 'This program and the data contained in or processed by this program belong to Blake Dawson Waldron and are protected by copyright law. It is a breach of copyright law to reproduce, modify or communicate to the public any part of this program or those data, without our prior consent. ')
insert into tblAppConfig(name, value) values('AppName', 'salt')
insert into tblAppConfig(name, value) values('BrandingCompanyName', 'Blake Dawson Waldron')
insert into tblAppConfig(name, value) values('BrandingCompanyURL', 'http://www.bdw.com')
insert into tblAppConfig(name, value) values('ButtonSet', 'BDW')
insert into tblAppConfig(name, value) values('CopyrightYear', '2004')
insert into tblAppConfig(name, value) values('ExternalLinkDisclaimer', 'DISCLAIMER\r\nThe site you are about to visit is not part of this SALT training program.\r\nBlake Dawson Waldron has no control over the content, goods and services offered on or through that site.\r\nThis link to that site does not indicate endorsement, approval or recommendation of that site or the operators of that site by Blake Dawson Waldron.\r\n\r\nClick ''OK'' to continue to the link or ''Cancel'' to return to the SALT training program.')
insert into tblAppConfig(name, value) values('HomePageFooter', 'contains fictitious characters and companies which are designed as training aids. The fictitious characters and companies typically appear in screens titled "Meet the Players" and in hypothetical scenarios where users are required to answer questions. Any resemblance between these fictitious characters and companies and any person living or dead or any company, venture, business or partnership is purely coincidental.')
insert into tblAppConfig(name, value) values('LisencedTo', 'MyCompanyName')
insert into tblAppConfig(name, value) values('MailServer', 'mailhost.bdw.com')
insert into tblAppConfig(name, value) values('PageSize', '10')
insert into tblAppConfig(name, value) values('PrivacyPolicyURL', 'http://www.bdw.com/scripts/privacy.asp')
insert into tblAppConfig(name, value) values('ShowDetaildHelp', 'true')
insert into tblAppConfig(name, value) values('StyleSheet', 'unknown.css')
insert into tblAppConfig(name, value) values('SupportEmail', 'productsupport@bdw.com')
insert into tblAppConfig(name, value) values('TermsOfUseURL', '/termsofuse.html')
insert into tblAppConfig(name, value) values('ToolbookDelay', '500')
insert into tblAppConfig(name, value) values('TradeMark', 'TM')


go 
Delete from tblVersion
                                                                                            
insert into tblVersion(Version) values('Salt 3.0.13')
go


--Insert  salt admin

Delete from tblUser
SET IDENTITY_INSERT tblUser On
insert into tblUser(UserID,FirstName,LastName,UserName,Password,Email,UserTypeID,Active,CreatedBy)
			values(1, 'Administrator','Application','saltadmin','password','ProductSupport@bdw.com',1,1,1)
SET IDENTITY_INSERT tblUser Off
go

--Insert default organisation
Delete from tblOrganisation
SET IDENTITY_INSERT tblOrganisation On
insert into tblOrganisation(OrganisationID,OrganisationName,Logo,Notes,DefaultLessonFrequency,DefaultQuizFrequency,DefaultQuizPassMark,CreatedBy)
			values(1, 'My Organisation Name','logo.gif','
			This is created during installation.', 12,12,80,1)
insert into tblOrganisationPolicyAccess(OrganisationID,GrantPolicyAccess)
			values(1, 1)		
insert into tblOrganisationCPDAccess(OrganisationID,GrantCPDAccess)
			values(1, 1)		
SET IDENTITY_INSERT tblOrganisation Off
go

Delete from tblOrganisationConfig

-- Default css for organisations
INSERT INTO tblOrganisationConfig ([OrganisationID], [Name], [Description], [Value])	
VALUES(null, 'css', 'Stylesheet','default.css')

-- Default number of questions to ask
INSERT INTO tblOrganisationConfig ([OrganisationID], [Name], [Description],[Value])	
VALUES(null, 'Number_Of_Quiz_Questions', 'Quiz Questions To Ask','10')

go
-- Insert default email content
Declare @strCompleteReportToAdministrators      varchar(8000)
Declare @strInCompleteReportToAdministrators    varchar(8000)
Declare @strFailedReportToAdministrators        varchar(8000)
Declare @strNotStartedReportToAdministrators    varchar(8000)
Declare @strCompleteReportToUsers               varchar(8000)
Declare @strInCompleteReportToUsers             varchar(8000)
Declare @strFailedReportToUsers                 varchar(8000)
Declare @strNotStartedReportToUsers             varchar(8000)

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
VALUES(null, 'Email_Report_InComplete_To_Administrators','Email to Inompleted Users Administrators', @strInCompleteReportToAdministrators)

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


-- Email report for Completed users to Users
-- Subject:  %APP_NAME% %COURSE_NAME% Course
Set @strCompleteReportToUsers='<BR>Hi %FirstName%,'
Set @strCompleteReportToUsers=@strCompleteReportToUsers + '<BR>Congratulations!  You have completed your %APP_NAME% %COURSE_NAME% course.'
Set @strCompleteReportToUsers=@strCompleteReportToUsers + '<BR>Please return to the %APP_NAME% homepage and print your certificate of completion.'
Set @strCompleteReportToUsers=@strCompleteReportToUsers + '<BR>Thank you for your efforts.'
Set @strCompleteReportToUsers=@strCompleteReportToUsers + '<BR>Regards,'
Set @strCompleteReportToUsers=@strCompleteReportToUsers + '<BR>%APP_NAME% Administrator'
INSERT INTO tblOrganisationConfig ([OrganisationID], [Name], [Description], [Value])	
VALUES(null, 'Email_Report_Complete_To_Users','Email to Completed Users', @strCompleteReportToUsers)

-- Email report for InCompleted users to Users
-- Subject:  %APP_NAME% %COURSE_NAME% Course
Set @strInCompleteReportToUsers='<BR>Hi %FirstName%,'
Set @strInCompleteReportToUsers=@strInCompleteReportToUsers + '<BR>Our records show that you have not completed your %APP_NAME% %COURSE_NAME% course.'
Set @strInCompleteReportToUsers=@strInCompleteReportToUsers + '<BR>Please return to the %APP_NAME% homepage and complete all outstanding quizzes.'
Set @strInCompleteReportToUsers=@strInCompleteReportToUsers + '<BR>It is recommended that you review the lessons before attempting a quiz.'
Set @strInCompleteReportToUsers=@strInCompleteReportToUsers + '<BR>Regards,'
Set @strInCompleteReportToUsers=@strInCompleteReportToUsers + '<BR>%APP_NAME% Administrator'
INSERT INTO tblOrganisationConfig ([OrganisationID], [Name], [Description], [Value])	
VALUES(null, 'Email_Report_Incomplete_To_Users','Email to Incompleted Users', @strInCompleteReportToUsers)

-- Email report for Failed users to Users
-- Subject:  %APP_NAME% %COURSE_NAME% Training
Set @strFailedReportToUsers='<BR>Hi %FirstName%,'
Set @strFailedReportToUsers=@strFailedReportToUsers + '<BR>Our records show that you have failed some of your %APP_NAME% %COURSE_NAME% course.'
Set @strFailedReportToUsers=@strFailedReportToUsers + '<BR>Please return to the %APP_NAME% homepage and redo your failed quizzes.  '
Set @strFailedReportToUsers=@strFailedReportToUsers + '<BR>It is also recommended that you review the lesson before attempting the quiz.'
Set @strFailedReportToUsers=@strFailedReportToUsers + '<BR>Regards,'
Set @strFailedReportToUsers=@strFailedReportToUsers + '<BR>%APP_NAME% Administrator'
INSERT INTO tblOrganisationConfig ([OrganisationID], [Name], [Description], [Value])	
VALUES(null, 'Email_Report_Failed_To_Users','Email to Failed Users', @strFailedReportToUsers)


-- Email report for Not Started users to Users
-- Subject:  %APP_NAME% %COURSE_NAME% Training
Set @strNotStartedReportToUsers='<BR>Hi %FirstName%,'
Set @strNotStartedReportToUsers=@strNotStartedReportToUsers + '<BR>Our records show that you have not started the %APP_NAME% %COURSE_NAME% course.'
Set @strNotStartedReportToUsers=@strNotStartedReportToUsers + '<BR>Please return to the %APP_NAME% homepage and complete all outstanding quizzes.  '
Set @strNotStartedReportToUsers=@strNotStartedReportToUsers + '<BR>It is recommended that you review the lesson before attempting a quiz.'
Set @strNotStartedReportToUsers=@strNotStartedReportToUsers + '<BR>Regards,'
Set @strNotStartedReportToUsers=@strNotStartedReportToUsers + '<BR>%APP_NAME% Administrator'
INSERT INTO tblOrganisationConfig ([OrganisationID], [Name], [Description], [Value])	
VALUES(null, 'Email_Report_Not_Started_To_Users','Email to Not Started Users', @strNotStartedReportToUsers)


-- Default option to display help
INSERT INTO tblOrganisationConfig ([OrganisationID], [Name], [Description],[Value])	
VALUES(null, 'ShowDetailedHelp', 'Show Detailed Help (Y/N)','Y')


insert into tblAppConfig(name, value) values('XsltPageElementPath', '/General/InfoPath/PageElements/')
insert into tblAppConfig(name, value) values('XsltLayoutPath', '/General/InfoPath/Layouts/')
insert into tblAppConfig(name, value) values('CssStylesPath', '/General/InfoPath/Styles/')
insert into tblAppConfig(name, value) values('PublishingPath', '/General/InfoPath/Publishing/')
insert into tblAppConfig(name, value) values('RenderingPath', '/General/InfoPath/Rendering/')
