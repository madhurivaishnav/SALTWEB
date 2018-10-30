Declare @strExpiredTimeElapsedReportToUsers		varchar(8000)
Declare @strExpiredTimeElapsedReportToAdministrators varchar(8000)
Declare	@strExpiredNewContentReportToUsers		varchar(8000)
Declare @strExpiredNewContentReportToAdministrators varchar(8000)


-- Email report for Expired (Time Elapsed) users to Administrators
-- Subject:  %APP_NAME% %COURSE_NAME% Training
Set @strExpiredTimeElapsedReportToAdministrators='<BR>Hi,'
Set @strExpiredTimeElapsedReportToAdministrators=@strExpiredTimeElapsedReportToAdministrators + '<BR>The following users have expired (time elapsed) some of their testing in the %APP_NAME% %COURSE_NAME% course.'
Set @strExpiredTimeElapsedReportToAdministrators=@strExpiredTimeElapsedReportToAdministrators + '<BR>%USER_LIST%'
Set @strExpiredTimeElapsedReportToAdministrators=@strExpiredTimeElapsedReportToAdministrators + '<BR>Regards,'
Set @strExpiredTimeElapsedReportToAdministrators=@strExpiredTimeElapsedReportToAdministrators + '<BR>%APP_NAME% Administrator'
INSERT INTO tblOrganisationConfig ([OrganisationID], [Name], [Description], [Value])	
VALUES(null, 'Email_Report_Expired_Time_Elapsed_To_Administrators','Email to Expired (Time Elapsed) Administrators', @strExpiredTimeElapsedReportToAdministrators)

-- Email report for Expired (New Content) users to Administrators
-- Subject:  %APP_NAME% %COURSE_NAME% Training
Set @strExpiredNewContentReportToAdministrators='<BR>Hi,'
Set @strExpiredNewContentReportToAdministrators=@strExpiredNewContentReportToAdministrators + '<BR>The following users have expired (new content) some of their testing in the %APP_NAME% %COURSE_NAME% course.'
Set @strExpiredNewContentReportToAdministrators=@strExpiredNewContentReportToAdministrators + '<BR>%USER_LIST%'
Set @strExpiredNewContentReportToAdministrators=@strExpiredNewContentReportToAdministrators + '<BR>Regards,'
Set @strExpiredNewContentReportToAdministrators=@strExpiredNewContentReportToAdministrators + '<BR>%APP_NAME% Administrator'
INSERT INTO tblOrganisationConfig ([OrganisationID], [Name], [Description], [Value])	
VALUES(null, 'Email_Report_Expired_New_Content_To_Administrators','Email to Expired (New Content) Administrators', @strExpiredNewContentReportToAdministrators)

-- Email report for Expired (Time Elapsed) users to Users
-- Subject:  %APP_NAME% %COURSE_NAME% Training
Set @strExpiredTimeElapsedReportToUsers='<BR>Hi,'
Set @strExpiredTimeElapsedReportToUsers=@strExpiredTimeElapsedReportToUsers + '<BR>Our records show that you have expired the %APP_NAME% %COURSE_NAME% course.'
Set @strExpiredTimeElapsedReportToUsers=@strExpiredTimeElapsedReportToUsers + '<BR>Please return to the %APP_NAME% homepage and complete all outstanding quizzes.  '
Set @strExpiredTimeElapsedReportToUsers=@strExpiredTimeElapsedReportToUsers + '<BR>It is recommended that you review the lesson before attempting a quiz.'
Set @strExpiredTimeElapsedReportToUsers=@strExpiredTimeElapsedReportToUsers + '<BR>Regards,'
Set @strExpiredTimeElapsedReportToUsers=@strExpiredTimeElapsedReportToUsers + '<BR>%APP_NAME% Administrator'
INSERT INTO tblOrganisationConfig ([OrganisationID], [Name], [Description], [Value])	
VALUES(null, 'Email_Report_Expired_Time_Elapsed_To_Users','Email to Expired (Time Elapsed) Users', @strExpiredTimeElapsedReportToUsers)

-- Email report for Expired (New Content) users to Users
-- Subject:  %APP_NAME% %COURSE_NAME% Training
Set @strExpiredNewContentReportToUsers='<BR>Hi,'
Set @strExpiredNewContentReportToUsers=@strExpiredNewContentReportToUsers + '<BR>Our records show that you have expired the %APP_NAME% %COURSE_NAME% course.'
Set @strExpiredNewContentReportToUsers=@strExpiredNewContentReportToUsers + '<BR>Please return to the %APP_NAME% homepage and complete all outstanding quizzes.  '
Set @strExpiredNewContentReportToUsers=@strExpiredNewContentReportToUsers + '<BR>It is recommended that you review the lesson before attempting a quiz.'
Set @strExpiredNewContentReportToUsers=@strExpiredNewContentReportToUsers + '<BR>Regards,'
Set @strExpiredNewContentReportToUsers=@strExpiredNewContentReportToUsers + '<BR>%APP_NAME% Administrator'
INSERT INTO tblOrganisationConfig ([OrganisationID], [Name], [Description], [Value])	
VALUES(null, 'Email_Report_Expired_New_Content_To_Users','Email to Expired (New Content) Users', @strExpiredNewContentReportToUsers) 