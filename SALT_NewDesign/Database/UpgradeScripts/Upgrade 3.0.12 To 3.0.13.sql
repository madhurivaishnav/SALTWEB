-- Default option to display help
INSERT INTO tblOrganisationConfig ([OrganisationID], [Name], [Description],[Value])	
VALUES(null, 'ShowDetailedHelp', 'Show Detailed Help (Y/N)','Y')
 
-- Fixes issues raised with bug 269
--  During an import no external id results in an empty string. 
--  During normal user creation a NULL value is used to indicate no external id
UPDATE [tblUser]
SET 
	[ExternalID]=NULL
WHERE 
	[ExternalID]=''

-- Fixes issues raised with bug 268
--  the word "dead" changed to "deceased". 
Update [tblAppConfig]
Set
	[Value] = 'contains fictitious characters and companies which are designed as training aids. The fictitious characters and companies typically appear in screens titled "Meet the Players" and in hypothetical scenarios where users are required to answer questions. Any resemblance between these fictitious characters and companies and any person living or deceased or any company, venture, business or partnership is purely coincidental.'
Where
	[Name] = 'HomePageFooter'
And
	[Value] = 'contains fictitious characters and companies which are designed as training aids. The fictitious characters and companies typically appear in screens titled "Meet the Players" and in hypothetical scenarios where users are required to answer questions. Any resemblance between these fictitious characters and companies and any person living or dead or any company, venture, business or partnership is purely coincidental.'

-- This isnt used by anything
ALTER TABLE tblEmail
DROP COLUMN BodyPath

-- http://bugs.salt.devbdw.com/edit_bug.aspx?id=291
-- Log the date at which a user last logged in.
ALTER TABLE tblUser
ADD LastLogin DateTime Null

-- Alter default setting and remove hardcoded dates
Declare @strCompleteReportToAdministrators      varchar(8000)
Set @strCompleteReportToAdministrators='<BR>Hi,'
Set @strCompleteReportToAdministrators=@strCompleteReportToAdministrators + '<BR>The following users have completed their %APP_NAME% %COURSE_NAME% course between %DATE_FROM% and %DATE_TO%:'
Set @strCompleteReportToAdministrators=@strCompleteReportToAdministrators + '<BR>%USER_LIST%'
Set @strCompleteReportToAdministrators=@strCompleteReportToAdministrators + '<BR>Regards,'
Set @strCompleteReportToAdministrators=@strCompleteReportToAdministrators + '<BR>%APP_NAME% Administrator'
Update 
	tblOrganisationConfig 
Set 
	[Value] = @strCompleteReportToAdministrators
Where
	Name = 'Email_Report_Complete_To_Administrators'
