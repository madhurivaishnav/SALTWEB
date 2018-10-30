-- Friday, 24 May 2013 - 11:23:35 AM
UPDATE tblLangValue set LangEntryValue = 'Application Email Template', DateModified = getdate() 
					WHERE LangID = (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU')
						AND LangInterfaceID = (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Administration/Application/EmailDefault.aspx')
						AND LangResourceID = (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'pagTitle')
				


-- Friday, 24 May 2013 - 11:27:30 AM
UPDATE tblLangValue set LangEntryValue = 'Application Email Template', DateModified = getdate() 
					WHERE LangID = (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU')
						AND LangInterfaceID = (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Administration/Application/EmailDefault.aspx')
						AND LangResourceID = (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblPageTitle')

-- Friday, 24 May 2013 - 11:35:41 AM
UPDATE tblLangValue set LangEntryValue = 'Application Email Template', DateModified = getdate() 
					WHERE LangID = (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU')
						AND LangInterfaceID = (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = 'GLOBAL.UserControls.AdminMenu.ascx')
						AND LangResourceID = (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lnkAppEmailDefault')
						

-- add new column to the organisation table
IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tblOrganisation' 
		AND  COLUMN_NAME = 'DefaultEbookEmailNotification')
BEGIN
alter table tblOrganisation
	add DefaultEbookEmailNotification bit not null default 0
END


-- add new column to the user table
IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tblUser' 
		AND  COLUMN_NAME = 'EbookNotification')
BEGIN
alter table tblUser
	add EbookNotification bit not null default 0
END


-- The ebook was intially enabled by default for 4.4.0
-- but since it might not be ready for release, we set them all to disabled by default for this release
-- may be changed in the future release
IF EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tblOrganisationFeatureAccess')
begin
    delete from tblOrganisationFeatureAccess where featurename='ebook'
end

-- Add the new email for ebook into the tblOrganisationConfig
IF EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tblOrganisationConfig')
begin
insert into tblOrganisationConfig (organisationid, name, description, value)
values
(null, 'Ebook_NewUpdate_Subject', 'New Ebook Update Email - Subject', 'New Ebook Update for %COURSE_NAME%'),
(null, 'Ebook_NewUpdate_Body', 'New Ebook Update Email - Body', 'Hi %FirstName%,<br/><br/>The new update ebook for %COURSE_NAME% is available for download. Please login to Salt to download.<br/><br/>Regards,<br/>%APP_NAME% Administrator')
end

-- Add the new field to the tblUserEbook to keep track when the user is notified so we won't spam the users
IF EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tblUserEbook')
begin
alter table tblUserEbook add DateNotified datetime
end

/****** Object:  StoredProcedure [dbo].[prcEmail_SearchByUserID]    Script Date: 04/22/2013 15:29:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcEmail_SearchByUserID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcEmail_SearchByUserID]
GO
/****** Object:  StoredProcedure [dbo].[prcPolicy_GetUserLastAccepted]    Script Date: 04/22/2013 15:29:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcPolicy_GetUserLastAccepted]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcPolicy_GetUserLastAccepted]
GO
/****** Object:  StoredProcedure [dbo].[prcEmail_LogSentEmail]    Script Date: 04/22/2013 15:29:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcEmail_LogSentEmail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcEmail_LogSentEmail]
GO
/****** Object:  StoredProcedure [dbo].[prcEmail_LogSentEmail]    Script Date: 04/22/2013 15:29:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcEmail_LogSentEmail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[prcEmail_LogSentEmail]
@toEmail	nvarchar(1000),
@toName	nvarchar(128),
@fromEmail	nvarchar(128),
@fromName	nvarchar(128),
@CC		nvarchar(1000) = '''',
@BCC 		nvarchar(1000) = '''',
@subject	nvarchar (256),
@body		ntext,
@organisationID	int,
@userID int = 0
As


-- attempt to check if the user exist and find the userid
-- else we just insert 0
-- this is because the service log the email as well and i am unable to find where it can retrieve
-- the userid in a short time
-- hence the workaround
if(@userID=0)
begin

set @userid=coalesce((select top 1 userid from tblUser where organisationid=@organisationid and email=@toemail), 0)

end

Insert Into
tblEmail
(
ToEmail,
ToName,
FromEmail,
FromName,
CC,
BCC,
Subject,
Body,
DateCreated,
OrganisationID,
userID
)

Values
(
@toEmail,
@toName,
@fromEmail,
@fromName,
@CC,
@BCC,
@subject,
@body,
GetUTCDate(),
@organisationID,
@userid
)
' 
END
GO
/****** Object:  StoredProcedure [dbo].[prcPolicy_GetUserLastAccepted]    Script Date: 04/22/2013 15:29:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcPolicy_GetUserLastAccepted]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[prcPolicy_GetUserLastAccepted]
	@userID int,
	@organisationid int,
	@policyID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select 
	convert(varchar(10), dbo.udfUTCtoDaylightSavingTime(dateAccepted,@organisationid), 103) ''dateaccepted''
	from tblUserPolicyAccepted where userid=@userID and policyID = @policyID
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[prcEmail_SearchByUserID]    Script Date: 04/22/2013 15:29:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcEmail_SearchByUserID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
The procedure will search email sent within the selected date range to a email and contain text in subject or body

Returns:


Called By:
Calls:

Remarks:


Author: Jack Liu
Date Created: 25 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
select * from tblEmail


prcEmail_Search''20040102'',''20040228'','''','''',''''

**/

CREATE  PROCEDURE [dbo].[prcEmail_SearchByUserID]
(
@userID int,
@organisationID int
)
as
set nocount on

select
emailid,
ToEmail,
subject,
body,
dbo.udfUTCtoDaylightSavingTime(DateCreated, @organisationID) as DateCreated
from tblEmail
where 
userID = @userID
order by datecreated
' 
END
GO


/****** Object:  StoredProcedure [dbo].[prcOrganisation_GetOne]    Script Date: 04/30/2013 10:59:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_GetOne]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcOrganisation_GetOne]
GO
/****** Object:  StoredProcedure [dbo].[prcOrganisationConfig_GetList]    Script Date: 04/30/2013 10:59:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisationConfig_GetList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcOrganisationConfig_GetList]
GO
/****** Object:  StoredProcedure [dbo].[prcOrganisationConfig_Update]    Script Date: 04/30/2013 10:59:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisationConfig_Update]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcOrganisationConfig_Update]
GO
/****** Object:  StoredProcedure [dbo].[prcUser_Create]    Script Date: 04/30/2013 10:59:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcUser_Create]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcUser_Create]
GO
/****** Object:  StoredProcedure [dbo].[prcUser_Update]    Script Date: 04/30/2013 10:59:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcUser_Update]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcUser_Update]
GO
/****** Object:  StoredProcedure [dbo].[prcReport_UserEbookDownload]    Script Date: 04/30/2013 10:59:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_UserEbookDownload]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcReport_UserEbookDownload]
GO
/****** Object:  StoredProcedure [dbo].[prcUserEbook_UpdateNotify]    Script Date: 04/30/2013 10:59:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcUserEbook_UpdateNotify]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcUserEbook_UpdateNotify]
GO
/****** Object:  StoredProcedure [dbo].[prcOrganisation_Add]    Script Date: 04/30/2013 10:59:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_Add]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcOrganisation_Add]
GO
/****** Object:  StoredProcedure [dbo].[prcOrganisation_Update]    Script Date: 04/30/2013 10:59:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_Update]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcOrganisation_Update]
GO
/****** Object:  StoredProcedure [dbo].[prcUser_GetOne]    Script Date: 04/30/2013 10:59:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcUser_GetOne]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcUser_GetOne]
GO
/****** Object:  StoredProcedure [dbo].[prcOrganisation_DefaultEbookEmailNotification]    Script Date: 04/30/2013 10:59:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_DefaultEbookEmailNotification]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcOrganisation_DefaultEbookEmailNotification]
GO
/****** Object:  StoredProcedure [dbo].[prcCourse_Ebook_GetDownloadUsers]    Script Date: 04/30/2013 10:59:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcCourse_Ebook_GetDownloadUsers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcCourse_Ebook_GetDownloadUsers]
GO
/****** Object:  StoredProcedure [dbo].[prcCourse_Ebook_GetDownloadUsers]    Script Date: 04/30/2013 10:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcCourse_Ebook_GetDownloadUsers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		William Tio
-- Create date: 26 April 2013
-- Description:	Retrieve the users who have downloaded the ebook
--				Ignore the users who have downloaded the latest one			
-- =============================================
CREATE PROCEDURE [dbo].[prcCourse_Ebook_GetDownloadUsers] 
	@ebookid int,
	@courseid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select
	ue.UserBookID ''userebookid'', 
	u.userid,
	u.organisationID,
	o.organisationName,
	u.firstname,
	u.lastname,
	u.email
	from
	tblUserEbook ue
	inner join tblUser u
		on ue.userid=u.userid
	inner join tblEbook e
		on ue.ebookid=e.ebookid
	inner join tblOrganisation o
		on u.organisationid=o.organisationid
	-- if the organisation does not have access to the ebook, don''t send the users email
	inner join tblOrganisationFeatureAccess ofa
		on ofa.organisationid=o.organisationid and ofa.featurename=''ebook''
	where
	u.userid <> 1	-- ignore the Salt Administrator
	and u.active = 1	-- only active people
	and ue.UserBookID in
	(
		select
		max(ue.UserBookID)
		from
		tblUserEbook ue inner join tblEbook e
			on ue.ebookid=e.ebookid
		where
			ue.result = ''success''
			and ue.userid <> 1
		group by
		ue.userid, e.courseid
	)
	and datenotified is null	-- ignore if users have been notified
	and e.ebookID <> @ebookid		-- ignore if users have downloaded the latest ebook
	and e.courseid = @courseid
	-- check if the user allow to send email
	and u.EBookNotification = 1
	-- check if the organisation allow the email sending
	and o.defaultebookemailnotification = 1
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[prcOrganisation_DefaultEbookEmailNotification]    Script Date: 04/30/2013 10:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_DefaultEbookEmailNotification]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[prcOrganisation_DefaultEbookEmailNotification]
(
@OrgID int
)
as
Select
DefaultEbookEmailNotification
From
tblOrganisation
Where
OrganisationID = @OrgID
' 
END
GO
/****** Object:  StoredProcedure [dbo].[prcUser_GetOne]    Script Date: 04/30/2013 10:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcUser_GetOne]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
Summary: Gets the details of one User
Parameters: @userID integer
Returns: UserID, FirstName, LastName, UserName, Password, Email, ExternalID, OrganisationID, UnitID, UserTypeID, Active, CreatedBy, DateCreated, UpdatedBy, DateUpdated

Called By: User.cs
Calls: None

Remarks: Raises an error if the parameter is null

Author: Gavin Buddis
Date Created: 10th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE Procedure [dbo].[prcUser_GetOne]
(
@userID Integer = null -- User ID
)

As
begin

Set NoCount On

If @userID Is Null
Begin
Raiserror(''The Parameter @userID was null.  @userID does not accept Null values.'', 16, 1)
Return
End

Select
UserID,
FirstName,
LastName,
UserName,
Password,
Email,
ExternalID,
OrganisationID,
UnitID,
UserTypeID,
Active,
CreatedBy,
dbo.udfUTCtoDaylightSavingTime(DateCreated, OrganisationID) as DateCreated,
UpdatedBy,
dbo.udfUTCtoDaylightSavingTime(DateUpdated, OrganisationID) as DateUpdated,
dbo.udfUTCtoDaylightSavingTime(LastLogin, OrganisationID) as LastLogin,
TimeZoneID,
DelinquencyManagerEmail,
NotifyMgr,
NotifyUnitAdmin,
NotifyOrgAdmin,
EbookNotification
From
tblUser
Where
UserID = @userID
END



' 
END
GO
/****** Object:  StoredProcedure [dbo].[prcOrganisation_Update]    Script Date: 04/30/2013 10:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prcOrganisation_Update] (
@LangCode nvarchar(10),
@organisationID Integer = Null, -- ID of the organisation to update.
@organisationName nVarChar(50) = Null, -- The name of the organisation.
@notes nVarChar(4000) = Null, -- The notes for the organisation.
@logo VarChar(100) = Null, -- The name of the organisation logo image.
@lessonFrequency Integer = Null, -- Default Lesson frequency for the organisation.
@quizFrequency Integer = Null, -- Default Quiz frequency for the organisation.
@quizPassMark Integer = Null, -- Default Quiz pass mark for the organisation.
@lessonCompletionDate DateTime = Null, -- Default Lesson completion date
@quizCompletionDate DateTime = Null, -- Default Quiz completion date
@advancedReporting bit = 0,
@actionUserID Integer = Null, -- ID of the User that is making the changes.
@originalDateUpdated DateTime, -- original Date of the record.
@CPDReportName nvarchar(255) = Null, -- CPD Report Name
@AllocatedDiskSpace int = Null,
@inclLogo bit = 0,	-- include certificate logo
@PasswordLockout bit,
@TimeZoneID int = Null,
@ShowLastPassed bit =1,
@DisablePasswordField bit = 0,
@DefaultEbookEmailNotification bit = 0
)

As

Set NoCount On
Set Xact_Abort On

Begin Transaction

set @lessonCompletionDate = dbo.udfDaylightSavingTimeToUTC(@lessonCompletionDate, @organisationID)
set @quizCompletionDate = dbo.udfDaylightSavingTimeToUTC(@quizCompletionDate, @organisationID)
set @originalDateUpdated = dbo.udfDaylightSavingTimeToUTC(@originalDateUpdated, @organisationID)

-- Declarations
Declare @strErrorMessage Varchar(200) -- Holds the error message
Declare @intErrorNumber Integer -- Holds the error number
Declare @intUserTypeOrgAdmin Integer -- Holds the value for the OrgAdmin UserTypeID from the tblUserType table.
Declare @dtCurrentDateUpdated DateTime -- Holds the current date updated date.

-- Initialise variables
Set @strErrorMessage = ''''
Set @intErrorNumber = 0
Select @intUserTypeOrgAdmin = UserTypeID From tblUserType Where Type = ''Organisation Administrator''
Select @dtCurrentDateUpdated = DateUpdated From tblOrganisation Where OrganisationID = @organisationID

-- Validation Routines
If(@actionUserID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @userID in stored procedure  prcOrganisation_Update''
Goto Finalise
End

If Not Exists(Select * From tblUser Where UserID = @actionUserID And UserTypeID <= @intUserTypeOrgAdmin)
Begin
Set @intErrorNumber = 6
Set @strErrorMessage = ''You do not have access to modify this Organisation.''
Goto Finalise
End

If(@organisationID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @organisationID in stored procedure  prcOrganisation_Update''
Goto Finalise
End

If(@organisationName Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @organisationName in stored procedure  prcOrganisation_Update''
Goto Finalise
End

If Exists(Select * From tblOrganisation Where OrganisationName = @organisationName And OrganisationID != @organisationID)
Begin
Set @intErrorNumber = 4
Set @strErrorMessage = ''The Organisation Name '' + @organisationName + '' already exists please choose another name for your Organisation.''
Goto Finalise
End

If(@notes Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @notes in stored procedure  prcOrganisation_Update''
Goto Finalise
End

If(@logo Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @logo in stored procedure  prcOrganisation_Update''
Goto Finalise
End

If(@lessonFrequency Is Null and @lessonCompletionDate Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @lessonFrequency, @lessonCompletionDate in stored procedure  prcOrganisation_Update''
Goto Finalise
End

If(@quizFrequency Is Null and @quizCompletionDate Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @quizFrequency, @quizCompletionDate in stored procedure  prcOrganisation_Update''
Goto Finalise
End

If(@quizPassMark Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @quizPassMark in stored procedure  prcOrganisation_Update''
Goto Finalise
End

If(@originalDateUpdated != @dtCurrentDateUpdated)
Begin
Set @intErrorNumber = 7
Set @strErrorMessage = ''The organisation''''s details have been updated by another user, you will need to refresh the organisation''''s details and re-enter your changes.  Click here to refresh.''
Goto Finalise
End

If Exists(Select * From tblOrganisation Where OrganisationID = @organisationID)
Begin
Update tblOrganisation
Set
OrganisationName = @organisationName,
Logo = @logo,
DefaultLessonFrequency = @lessonFrequency,
DefaultQuizFrequency = @quizFrequency,
DefaultQuizPassMark = @quizPassMark,
DefaultLessonCompletionDate = @lessonCompletionDate,
DefaultQuizCompletionDate = @quizCompletionDate,
advancedReporting = IsNull(@advancedReporting,advancedReporting),
UpdatedBy = @actionUserID,
DateUpdated = GETUTCDATE(),
CPDReportName = @CPDReportName,
AllocatedDiskSpace = @AllocatedDiskSpace,
IncludeCertificateLogo = @inclLogo,
PasswordLockout = @PasswordLockout,
TimeZoneID = @TimeZoneID,
ShowLastPassed=@ShowLastPassed,
DisablePasswordField=@DisablePasswordField,
DefaultEbookEmailNotification=@DefaultEbookEmailNotification
Where
OrganisationID = @organisationID

update tblOrganisationNotes
set
Notes = @notes
where OrganisationID = @OrganisationID
and LanguageID = (select LangID from tblLang where LangCode = @LangCode)
End
Else
Begin
Set @intErrorNumber = 1
Set @strErrorMessage = ''Record not found in stored procedure prcOrganisation_Update''
Goto Finalise
End

Finalise:
If(@intErrorNumber > 0)
Begin
Rollback Transaction
Select
@intErrorNumber As ''ErrorNumber'',
@strErrorMessage As ''ErrorMessage''
End
Else
Begin
Commit Transaction
Select
@intErrorNumber As ''ErrorNumber'',
''Successfully Updated'' As ''ErrorMessage''
End


' 
END
GO
/****** Object:  StoredProcedure [dbo].[prcOrganisation_Add]    Script Date: 04/30/2013 10:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
Add a new Organisation.

Parameters:
@intOrganisationID Integer OutPut
@organisationID Integer
@organisationName VarChar(50)
@notes VarChar(1000)
@logo VarChar(100)
@lessonFrequency Integer
@quizFrequency Integer
@quizPassMark Integer
@CPDReportName nvarchar(255)
@AllocatedDiskSpace Integer = Null
@InclLogo bit = 0,
@PasswordLockout bit = 0
@TimeZoneID int = Null


Returns:
Nothing

Called By:
Organisation.cs.

Calls:
Nothing

Remarks:
Exception:
0. Succeed
4. UniqueViolationException
5. MissingParameterException
6. PermissionDeniedException
10. BusinessServiceException (General)

Author: Peter Vranich
Date Created: 18th February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	mikev		30/4/2007		Added @lessonCompletionDate and @quizCompletionDate
#2  aaronc		May 2008		Added @CPDReportName
#3	aaronc		June 2008		Added @AllocatedDiskSpace
#4  aaronc		June2008		Addition of organisation record to tblOrganisationCPDPolicyAccess
#5  vdl			08 June 2011	Time zone

**/
CREATE    Procedure [dbo].[prcOrganisation_Add]
(
@intOrganisationID Integer OutPut, -- The ID of the newly created organisation.
@organisationName nVarChar(50) = Null, -- The name of the organisation.
@notes nVarChar(4000) = Null, -- The notes for the organisation.
@logo VarChar(100) = Null, -- The name of the organisation logo image.
@lessonFrequency Integer = Null, -- Default Lesson frequency for the organisation.
@quizFrequency Integer = Null, -- Default Quiz frequency for the organisation.
@quizPassMark Integer = Null, -- Default Quiz pass mark for the organisation.
@lessonCompletionDate DateTime = Null, -- Default Lesson completion date
@quizCompletionDate DateTime = Null, -- Default Quiz completion date
@advancedReporting bit = 0,
@actionUserID Integer = Null, -- ID of the User that is making the changes.
@CPDReportName nvarchar(255) = Null, -- CPD Report Name
@AllocatedDiskSpace Integer = Null, -- Allocated Disk Space
@InclLogo bit = 0, -- include Certificate Logo
@PasswordLockout bit = 0,
@TimeZoneID int = Null,
@ShowLastPassed bit = 1,
@DisablePasswordField bit = 0,
@DefaultEbookEmailNotification bit = 0
)

As

Set NoCount On
Set Xact_Abort On

Begin Transaction

-- Declarations
Declare @strErrorMessage Varchar(200) -- Holds the error message
Declare @intErrorNumber Integer -- Holds the error number
Declare @intUserTypeOrgAdmin Integer -- Holds the value for the OrgAdmin UserTypeID from the tblUserType table.

-- Initialise variables
Set @strErrorMessage = ''''
Set @intErrorNumber = 0
Select @intUserTypeOrgAdmin = UserTypeID From tblUserType Where Type = ''Organisation Administrator''

-- Validation Routines
If(@actionUserID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @userID in stored procedure prcOrganisation_Add''
Goto Finalise
End

If Not Exists(Select * From tblUser Where UserID = @actionUserID And UserTypeID <= @intUserTypeOrgAdmin)
Begin
Set @intErrorNumber = 6
Set @strErrorMessage = ''You do not have access to modify this Organisation.''
Goto Finalise
End

If(@organisationName Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @organisationName in stored procedure prcOrganisation_Add''
Goto Finalise
End

If Exists(Select * From tblOrganisation Where OrganisationName = @organisationName)
Begin
Set @intErrorNumber = 4
Set @strErrorMessage = ''The Organisation Name '' + @organisationName + '' already exists please choose another name for your Organisation.''
Goto Finalise
End

If(@notes Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @notes in stored procedure prcOrganisation_Add''
Goto Finalise
End

If(@logo Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @logo in stored procedure prcOrganisation_Add''
Goto Finalise
End

If(@lessonFrequency Is Null and @lessonCompletionDate Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @lessonFrequency, @lessonCompletionDate in stored procedure prcOrganisation_Add''
Goto Finalise
End

If(@quizFrequency Is Null and @quizCompletionDate Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @quizFrequency, @quizCompletionDate in stored procedure prcOrganisation_Add''
Goto Finalise
End

If(@quizPassMark Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @quizPassMark in stored procedure prcOrganisation_Add''
Goto Finalise
End

Insert Into tblOrganisation
(
OrganisationName,
Logo,
DefaultLessonFrequency,
DefaultQuizFrequency,
DefaultQuizPassMark,
--	DefaultLessonCompletionDate,
--	DefaultQuizCompletionDate,
advancedReporting,
CreatedBy,
CPDReportName,
AllocatedDiskSpace,
IncludeCertificateLogo,
PasswordLockout,
TimeZoneID,
ShowLastPassed,
DisablePasswordField,
DefaultEbookEmailNotification
)
Values
(
@organisationName,
@logo,
@lessonFrequency,
@quizFrequency,
@quizPassMark,
--	@lessonCompletionDate,
--	@quizCompletionDate,
@advancedReporting,
@actionUserID,
@CPDReportName,
@AllocatedDiskSpace,
@InclLogo,
@PasswordLockout,
@TimeZoneID,
@ShowLastPassed,
@DisablePasswordField,
@DefaultEbookEmailNotification
)


Select @intOrganisationID = @@Identity

-- lesson completion datetime to utc
set @lessonCompletionDate = dbo.udfDaylightSavingTimeToUtc (@lessonCompletionDate, @intOrganisationID)

-- quiz completion time to utc
set @quizCompletionDate = dbo.udfDaylightSavingTimeToUtc (@quizCompletionDate, @intOrganisationID)


--update the org with these utc dates
update
tblOrganisation
set
DefaultLessonCompletionDate = @lessonCompletionDate,
DefaultQuizCompletionDate = @quizCompletionDate
where
OrganisationID =  @intOrganisationID



/* Remove this as the tables below no longer exist
insert into tblOrganisationCPDAccess
(
OrganisationID,
GrantCPDAccess
)
values
(
@intOrganisationID,
0 -- no access initially
)

insert into tblOrganisationPolicyAccess
(
OrganisationID,
GrantPolicyAccess
)
values
(
@intOrganisationID,
0 -- no access initially
)
*/

-- Add values to tblOrganisationNotes
Declare LangIDLOOP CURSOR
for
select LangID from tblLang

open LangIDLOOP

declare @LangID int

FETCH NEXT from LangIDLOOP into @LangID
while @@FETCH_STATUS = 0
BEGIN

insert into tblOrganisationNotes
(
OrganisationID,
LanguageID,
Notes
)
values
(
@intOrganisationID,
@LangID,
@notes
)
FETCH NEXT from LangIDLOOP into @LangID
END
close LangIDLOOP
deallocate LangIDLOOP

Finalise:
If(@intErrorNumber > 0)
Begin
Rollback Transaction
Select
@intErrorNumber As ''ErrorNumber'',
@strErrorMessage As ''ErrorMessage''
End
Else
Begin
Commit Transaction
Select
@intErrorNumber As ''ErrorNumber'',
''Successfully Added'' As ''ErrorMessage''
End
' 
END
GO
/****** Object:  StoredProcedure [dbo].[prcUserEbook_UpdateNotify]    Script Date: 04/30/2013 10:59:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcUserEbook_UpdateNotify]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE  Procedure [dbo].[prcUserEbook_UpdateNotify]
(
@UserEbookID int
)

As


update tblUserEbook
set dateNotified = getUTCDate()
where
UserBookID=@userebookid

' 
END
GO
/****** Object:  StoredProcedure [dbo].[prcReport_UserEbookDownload]    Script Date: 04/30/2013 10:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_UserEbookDownload]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE  PROCEDURE [dbo].[prcReport_UserEbookDownload]
(
@OrganisationID int,
@IncludeInactiveUsers int,
@UnitIDs varchar(max),
@courseIDs varchar(max)
)
AS
SET NOCOUNT ON

begin

DECLARE @Units TABLE
(
UnitID INT PRIMARY KEY(UnitID)
)

DECLARE @Courses TABLE
(
CourseID INT PRIMARY KEY(CourseID)
)

INSERT INTO @Courses SELECT * FROM dbo.udfCsvToInt(@courseIDs)

INSERT INTO @Units SELECT * FROM  dbo.udfCsvToInt(@unitIDs)


select
uh.HierarchyName as UnitPathway,
u.UserID,
u.FirstName,
u.LastName,
u.UnitID,
u.Email,
u.UserName,
u.ExternalID,
ct.Name as GroupBy,
c.Value as Value,
dbo.udfUTCtoDaylightSavingTime(ue.DateDownloaded ,@organisationID) AS ''DateDownloaded''
from
tblUserEbook ue
inner join tblUser u
	on ue.userid=u.userid
inner join tblEbook e
	on ue.UserBookID=e.ebookid
inner join tblUnitHierarchy uh
	on u.unitid=uh.unitid
left join tblUserClassification uc 
	on u.UserID = uc.UserID
left join tblClassification c 
	on uc.ClassificationID = c.ClassificationID
left join tblClassificationType ct 
	on c.ClassificationTypeID = ct.ClassificationTypeID
where
ue.result=''success''
and u.Active = CASE @IncludeInactiveUsers WHEN 0 THEN 1 ELSE u.Active END

END

' 
END
GO
/****** Object:  StoredProcedure [dbo].[prcUser_Update]    Script Date: 04/30/2013 10:59:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcUser_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prcUser_Update]
(
@userID Integer = Null,
@unitID Integer = Null,
@firstName nvarchar(50) = Null,
@lastName nvarchar(50) = Null,
@userName nvarchar(100) = Null,
@email nvarchar(100) = null,
@active bit = null,
@userTypeID Integer = Null,
@updatedByUserID Integer = Null,
@dateUpdated datetime = Null,
@password nvarchar(50) = Null,
@oldPassword nvarchar(50) = Null,
@externalID nvarchar(50) = Null,
@TimeZoneID Integer = Null,
@DelinquencyManagerEmail nvarchar(100) = Null,
@NotifyUnitAdmin bit = null,
@NotifyOrgAdmin bit = null,
@NotifyMgr bit = null,
@EbookNotification bit = 0
)

As BEGIN

Set NoCount On
Set Xact_Abort On

Begin Transaction

-- Declarations
Declare @strErrorMessage Varchar(200) -- Holds the error message
Declare @OrgTimeZone Integer -- Holds the ORG timezone
Declare @intErrorNumber Integer -- Holds the error number
Declare @UpdatedByUserTypeID Integer -- Holds the UserTypeID for the Updating user.
Declare @blnChangePassword bit			-- Boolean value to indentify update of the password
Declare @strCurrentPassword nvarchar(50) -- Holds the current password in the DB for this user
Declare @strCurrentUserName nvarchar(100) -- Holds the current username in the DB for this user
Declare @strCurrentEmail nvarchar(100) -- Holds the current email in the DB for this user
Declare @organisationID Integer -- Used to set the OrgID to null when updating a SALT Administrator
Declare @dteCurrentDateUpdated datetime -- Holds the current dateupdated in the DB for this user

-- Initialise variables
Set @strErrorMessage = ''''
Set @intErrorNumber = 0
Set @blnChangePassword = 0

-- PARAMETER VALIDATION
--==============================================================

-- Verify @UnitID and OrgID
Select
@organisationID = OrganisationID
From
tblUser
Where
UserID = @userID

--==================================================
-- If 0 passed in (for a SALT Admin), insert nulls for
-- Unit and Org IDs
if (@UnitID = 0)
begin
Set @UnitID = null
Set @OrganisationID = null
end

Select
@OrgTimeZone = TimeZoneID
From
tblOrganisation
Where
OrganisationID = @OrganisationID

if (@OrgTimeZone = @TimeZoneID)
begin
Set @TimeZoneID = null
end

--Missing or Null parameter {0} in stored procedure prcUser_Update
--Validate Parameter @userID
If(@userID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @userID in stored procedure prcUser_Update''
Goto Finalise
End

-- If user type is not SALT Administrator, validate parameter @UnitID
If(@userTypeID <> 1)
Begin
If(@unitID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @unitID in stored procedure prcUser_Update''
Goto Finalise
End
End

--Validate Parameter @firstName
If(@firstName Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @firstName in stored procedure prcUser_Update''
Goto Finalise
End

--Validate Parameter @lastName
If(@lastName Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @lastName in stored procedure prcUser_Update''
Goto Finalise

End

--Validate Parameter @userName
If(@userName Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @userName in stored procedure prcUser_Update''
Goto Finalise
End

--Validate Parameter @email
If(@email Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @email in stored procedure prcUser_Update''
Goto Finalise
End

--Validate Parameter @active
If(@active Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @active in stored procedure prcUser_Update''
Goto Finalise
End

--Validate Parameter @userTypeID
If(@userTypeID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @userTypeID in stored procedure prcUser_Update''
Goto Finalise
End

--Validate Parameter @updatedByUserID
If(@updatedByUserID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @updatedByUserID in stored procedure prcUser_Update''
Goto Finalise
End

--Validate Parameter @dateUpdated
If(@dateUpdated Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @dateUpdated in stored procedure prcUser_Update''
Goto Finalise
End

-- Validate User Exists
--=========================================================
If Not Exists(Select * From tblUser Where UserID = @userID)
Begin
Set @intErrorNumber = 1
Set @strErrorMessage = ''This record no longer exists please refresh your screen.  If the problem persists please contact your administrator.''
Goto Finalise
End

-- If a unit was specified make sure it exists
--=========================================================
If (@unitID Is Not Null)
Begin
If Not Exists(Select * From tblUnit Where UnitID = @unitID)
Begin
Set @intErrorNumber = 11
Set @strErrorMessage = ''The specified unit could be found or may not be active.''
Goto Finalise
End
End

-- Integrity Constraint
--=========================================================
Select
@dteCurrentDateUpdated = DateUpdated
from
tblUser
Where
UserID = @userID


/*If (DateDiff(s, @dteCurrentDateUpdated, @dateUpdated) <> 0)
Begin
Set @intErrorNumber = 7
Set @strErrorMessage = ''This record has already been updated by another user, please refresh your screen. If the problem persists please contact your administrator.''
Goto Finalise
End */


-- Validate Passwords
--=======================

-- get Updating User, UserTypeID
Select
@UpdatedByUserTypeID = UserTypeID
from
tblUser
Where
UserID = @updatedByUserID

if(@UpdatedByUserTypeID = 4)
Begin

-- SALT User
If (@password Is Not Null or @oldPassword Is Not Null)
Begin
If(@password Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @password in stored procedure prcUser_Update''
Goto Finalise
End

If(@oldPassword Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @oldPassword in stored procedure prcUser_Update''
Goto Finalise
End

-- Get the current password in the DB
Select
@strCurrentPassword = Password
From
tblUser
Where
UserID = @userID

-- Ensure old password match current password otherwise error
if(@oldPassword <> @strCurrentPassword)
Begin
Set @intErrorNumber = 4
Set @strErrorMessage = ''Your old password was entered incorrectly so the user details have not been saved. ''
Set @strErrorMessage = @strErrorMessage + ''Please try again and if the problem persists please contact your administrator.''
Goto Finalise
End

Set @blnChangePassword = 1
End
End
else
Begin
-- Administrator
-- if there is a value in @oldPassword then admin is attempting to update their own password
if(@oldPassword Is Not Null)
Begin
-- Get the current password in the DB
Select
@strCurrentPassword = Password
From
tblUser
Where
UserID = @userID

-- Ensure old password match current password otherwise error
if(@oldPassword <> @strCurrentPassword)
Begin
Set @intErrorNumber = 4
Set @strErrorMessage = ''Your old password was entered incorrectly so the user details have not been saved. ''
Set @strErrorMessage = @strErrorMessage + ''Please try again and if the problem persists please contact your administrator.''
Goto Finalise
End

Set @blnChangePassword = 1
End

If(@password Is Not Null)
Begin
Set @blnChangePassword = 1
End
End

-- Validate Permisions
--========================================
if(@UpdatedByUserTypeID = 4)
Begin
-- Salt User can only update themselves
if(@UpdatedByUserID <> @UserID)
Begin
Set @intErrorNumber = 41
Set @strErrorMessage = ''You do not have the permissions required to update this user.''
Goto Finalise
End
End


-- Validate Unique UserName
--========================================
Select
@strCurrentUserName = UserName
From
tblUser
Where
UserID = @userID

-- Check for uniqueness if the username is changing
if(@strCurrentUserName <> @userName)
Begin
If(@userTypeID <> 1)
begin
if Exists(Select * from tblUser where UserName = @userName and (organisationID=@organisationID or organisationID is null))
Begin
Set @intErrorNumber = 42
Set @strErrorMessage = @userName
Goto Finalise
End
end
else
begin
if Exists(Select * from tblUser where UserName = @userName)
Begin
Set @intErrorNumber = 42
Set @strErrorMessage = @userName
Goto Finalise
End
end
End


-- Validate Unique UserName
--========================================
Select
@strCurrentEmail = Email
From
tblUser
Where
UserID = @userID

-- Check for uniqueness if the email address is changing
if(@strCurrentEmail <> @email)
If Exists(Select * From tblUser Where Email = @email)
Begin
Set @intErrorNumber = 43
Set @strErrorMessage = @email
Goto Finalise
End


-- only update if the user is moved to a new unit (so new unit is diff from the current unit)
if (select unitid from tblUser where userid=@userid) <> @unitid
begin


-- update the profile access of the user
-- give the user access to profiles for the selected unit
update tbluserprofileperiodaccess set granted = 1
where	userid = @userid
and profileperiodid in (
select profileperiodid from tblunitprofileperiodaccess where
unitid = @unitID and granted = 1)

-- give the user access to the policies for the selected unit.
/*update tbluserpolicyaccess set granted = 1
where	userid = @userid
and policyid in (
select policyid from tblunitpolicyaccess where
unitid = @unitID and granted = 1)*/

update upa1
set upa1.granted = upa2.granted
from tbluserpolicyaccess upa1
inner join tblunitpolicyaccess upa2
on upa1.policyid=upa2.policyid
inner join tblPolicy p
on upa1.policyid=p.policyid
where
upa1.userid=@userid and upa2.unitid=@unitid
and p.deleted=0

end



-- Execute Update
--===============================================================
-- Update the record in tblUser
if(@blnChangePassword = 1)
Begin
-- Update with password change
Update
tblUser
Set
FirstName = @firstName,
LastName = @lastName,
UserName = @userName,
Password = @password,
Email = @email,
OrganisationID = @organisationID,
UnitID = @unitID,
UserTypeID = @userTypeID,
Active = @active,
UpdatedBy = @updatedByUserID,
DateUpdated = getutcDate(),
ExternalID = @externalID,
TimeZoneID = @TimeZoneID,
DelinquencyManagerEmail = @DelinquencyManagerEmail,
NotifyMgr = @NotifyMgr,
NotifyOrgAdmin = @NotifyOrgAdmin,
NotifyUnitAdmin =@NotifyUnitAdmin,
EbookNotification = @EbookNotification
Where
UserID = @userID
End
Else
Begin
Update
tblUser
Set
FirstName = @firstName,
LastName = @lastName,
UserName = @userName,
Email = @email,
UnitID = @unitID,
UserTypeID = @userTypeID,
Active = @active,
UpdatedBy = @updatedByUserID,
DateUpdated = getutcDate(),
ExternalID = @externalID,
TimeZoneID = @TimeZoneID,
DelinquencyManagerEmail = @DelinquencyManagerEmail,
NotifyMgr = @NotifyMgr,
NotifyOrgAdmin = @NotifyOrgAdmin,
NotifyUnitAdmin =@NotifyUnitAdmin,
EbookNotification = @EbookNotification
Where
UserID = @userID
End


update tblUser set DateArchived = getutcdate() where Active = 0 and DateArchived IS NULL AND UserID = @userID
update tblUser set DateArchived = null where Active = 1 and NOT(DateArchived IS NULL) AND UserID = @userID


-- update the user current status
declare courseIDCursor cursor
for
select
grantedcourseid
from
tblOrganisationCourseAccess oca
where
organisationid = (select organisationid from tblUser where userid=@userid)


/*-- update course status for users
declare @intOldCourseStatus int
declare @intNewCourseStatus int
declare @courseID int
declare @moduleID int


open courseIDCursor

fetch next from courseIDCursor into @courseid
while (@@FETCH_STATUS <> -1)
begin
if (@@FETCH_STATUS <> -2)
begin
exec @intOldCourseStatus = prcUserCourseStatus_GetStatus @courseID, @userID
exec @intNewCourseStatus = prcUserCourseStatus_Calculate @courseID, @userID

--select * from tbluser where userid=@userid

--select * from tblUsercoursestatus where userid=@userid and courseid=@courseid

print ''CourseID: '' + convert(varchar(10), @courseid)
print ''Old Course Status : '' + convert(varchar(10), @intOldCourseStatus)
print ''New Course Status : '' + convert(varchar(10), @intNewCourseStatus)

if (@intOldCourseStatus <> -1) and (@intOldCourseStatus <> @intNewCourseStatus)
begin
print ''Insert''

set @moduleID = (select top 1 m.moduleId from tblModule m where CourseID = @courseID and  and m.active = 1)  --prcUserCourseStatus_Insert will not update if module is inactive
--print ''ModuleID: '' + convert(varchar(10), @moduleid)  + ''\n''
exec prcUserCourseStatus_Insert @userID, @ModuleID, @intNewCourseStatus
end
end

fetch next from courseIDCursor into @courseid
end

close courseIDCursor deallocate courseIDCursor*/



-- Set the error message to successfull
Set @strErrorMessage = ''Successfully Updated''

-- Finalise the procedure
Goto Finalise


Finalise:
If(@intErrorNumber > 0)
Begin
Rollback Transaction
Select
@intErrorNumber As ''ErrorNumber'',
@strErrorMessage As ''ErrorMessage''
End
Else
Begin
Commit Transaction
Select
@intErrorNumber As ''ErrorNumber'',
@strErrorMessage As ''ErrorMessage''
End
END

' 
END
GO
/****** Object:  StoredProcedure [dbo].[prcUser_Create]    Script Date: 04/30/2013 10:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcUser_Create]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
Inserts a new user.

Parameters:
@organisationID		(Mandatory)
@unitID 			(Mandatory)
@firstName 			(Mandatory)
@lastName			(Mandatory)
@userName			(Mandatory)
@email				(Mandatory)
@active			(Mandatory)
@userTypeID			(Mandatory)
@actionUserID			(Mandatory)
@password			(Mandatory)

Returns:
@intErrorNumber As ''ErrorNumber'',
@strErrorMessage As ''ErrorMessage''

Called By:
User.cs.

Calls:
Nothing

Assumptions:
The majority of business logic related to password
lengths, confirmation passwords, valid emails etc.
are implemented through the UI.
Assumption is that the parameters when passed in
contain valid data.

Remarks:
Exception:
0. Succeed
1. RecordNotFound
2. FK constraint
3. PKViolationException
4. UniqueViolationException
5. MissingParameterException
7. IntegrityConstraintException
10. BusinessServiceException (General)


Author: Peter Vranich
Date Created: 20th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	Jack Liu	15/09/2005		User name is only unique per organisation

**/
CREATE  Procedure [dbo].[prcUser_Create]
(
@organisationID Integer = Null,
@unitID Integer = Null,
@firstName nvarchar(50) = Null,
@lastName nvarchar(50) = Null,
@userName nvarchar(100) = Null,
@email nvarchar(100) = null,
@active bit = null,
@userTypeID Integer = Null,
@actionUserID Integer = Null,
@password nvarchar(50) = Null,
@externalID nvarchar(50) = Null,
@TimeZoneID Integer = Null,
@DelinquencyManagerEmail nvarchar(100) = Null,
@NotifyMgr bit = 0,
@NotifyUnitAdmin bit = 0, 
@NotifyOrgAdmin bit = 0, 
@EbookNotification bit = 0
)

As

Set NoCount On
Set Xact_Abort On

Begin Transaction

-- Declarations
Declare @strErrorMessage Varchar(200) -- Holds the error message
Declare @intErrorNumber Integer -- Holds the error number
Declare @UserID integer -- Holds the UserID once created

-- Initialise variables
Set @strErrorMessage = ''''
Set @intErrorNumber = 0

-- PARAMETER VALIDATION
--==============================================================

-- If user type is not SALT Administrator, check that a OrgID and UnitID has been supplied
If(@userTypeID <>1)
Begin
If(@organisationID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @organisationID in stored procedure prcUser_Create''
Goto Finalise
End

--Validate Parameter @unitID
If(@unitID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @unitID in stored procedure prcUser_Create''
Goto Finalise
End
End

--Validate Parameter @firstName
If(@firstName Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @firstName in stored procedure prcUser_Create''
Goto Finalise
End

--Validate Parameter @lastName
If(@lastName Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @lastName in stored procedure prcUser_Create''
Goto Finalise
End

--Validate Parameter @userName
If(@userName Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @userName in stored procedure prcUser_Create''
Goto Finalise
End

--Validate Parameter @email
If(@email Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @email in stored procedure prcUser_Create''
Goto Finalise
End

--Validate Parameter @active
If(@active Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @active in stored procedure prcUser_Create''
Goto Finalise
End

--Validate Parameter @userTypeID
If(@userTypeID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @userTypeID in stored procedure prcUser_Create''
Goto Finalise
End

--Validate Parameter @createdByUserID
If(@actionUserID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @updatedByUserID in stored procedure prcUser_Create''
Goto Finalise
End

-- If a unit was specified make sure it exists
--=========================================================
If (@unitID Is Not Null)
Begin
If Not Exists(Select * From tblUnit Where UnitID = @unitID)
Begin
Set @intErrorNumber = 1
Set @strErrorMessage = ''The specified unit could be found or may not be active.''
Goto Finalise
End
End

If(@userTypeID <>1)
begin
-- User name is unique per organisation
If Exists(Select * From tblUser Where Username = @userName and (organisationID=@organisationID or organisationID is null))
Begin
Set @intErrorNumber = 4
Set @strErrorMessage = @userName
Goto Finalise
End
end
else
begin
If Exists(Select * From tblUser Where Username = @userName)
Begin
Set @intErrorNumber = 4
Set @strErrorMessage = @userName
Goto Finalise
End
end


If Exists(Select * From tblUser Where Email = @email)
Begin
Set @intErrorNumber = 41
Set @strErrorMessage = ''The email address '' + @email + '' already exists.  <BR>Please choose another email address.''
Goto Finalise
End

Insert Into tblUser
(
OrganisationID,
FirstName,
LastName,
UserName,
Password,
Email,
UnitID,
UserTypeID,
Active,
CreatedBy,
DateCreated,
ExternalID,
NewStarter,
TimeZoneID,
DelinquencyManagerEmail,
NotifyMgr,
NotifyUnitAdmin,
NotifyOrgAdmin,
EbookNotification
)
Values
(
@organisationID,
@firstName,
@lastName,
@userName,
@password,
@email,
@unitID,
@userTypeID,
@active,
@actionUserID,
GETUTCDATE(),
@externalID, -- http://bugs.salt.devbdw.com/edit_bug.aspx?id=274
1,
@TimeZoneID,
@DelinquencyManagerEmail,
@NotifyMgr,
@NotifyUnitAdmin, 
@NotifyOrgAdmin, 
@EbookNotification
)

update tblUser set DateArchived = getutcdate() where Active = 0 and DateArchived IS NULL AND UserID = @@Identity
update tblUser set DateArchived = null where Active = 1 and NOT(DateArchived IS NULL) AND UserID = @@Identity

-- Set the error message to successfull
Set @strErrorMessage = @@Identity
Set @UserID = @@Identity


-- Get ProfilePeriodID''s for Organisation
create table #ProfilePeriod
(
ProfilePeriodID int
)

insert into #ProfilePeriod
select ProfilePeriodID
from tblProfilePeriod  pp
join tblprofile p
on pp.profileid = p.profileid
where p.organisationid = @OrganisationID


-- insert user into profileperiodaccess against all profileperiodid''s
-- for the organisation
insert into tblUserProfilePeriodAccess
select
pp.ProfilePeriodID,
@UserID,
uppa.granted
from #ProfilePeriod pp
join tblUnitProfilePeriodAccess uppa
on uppa.ProfilePeriodID = pp.ProfilePeriodID
where uppa.UnitID = @UnitID

drop table #ProfilePeriod

-- Get Policies for Organisation
create table #Policy
(
PolicyID int,
Granted bit
)

insert into #Policy
select p.PolicyID,
case when (select distinct granted from tblUnitPolicyAccess where unitID = @unitID and policyid = p.policyid) is null then 0
else (select distinct granted from tblUnitPolicyAccess where unitID = @unitID and policyid = p.policyid) end
from tblPolicy p where
OrganisationID = @OrganisationID
and deleted = 0


-- insert user into policy for all policy''s associated with organisation
insert into tblUserPolicyAccepted (PolicyID, UserID, Accepted)
select PolicyID, @UserID, 0 from #Policy

-- insert user into policyaccess for all policies
insert into tblUserPolicyAccess (PolicyID, UserID, Granted)
select PolicyID, @UserID, Granted  from #Policy

drop table #Policy

-- Finalise the procedure
Goto Finalise


Finalise:
If(@intErrorNumber > 0)
Begin
Rollback Transaction
Select
@intErrorNumber As ''ErrorNumber'',
@strErrorMessage As ''ErrorMessage''
End
Else
Begin
Commit Transaction
Select
@intErrorNumber As ''ErrorNumber'',
@strErrorMessage As ''ErrorMessage''
End


' 
END
GO
/****** Object:  StoredProcedure [dbo].[prcOrganisationConfig_Update]    Script Date: 04/30/2013 10:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisationConfig_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



/*Summary:
Updates a Client Config Entry if it exists.
Creates a Client Config Entry if it doesnt.


Parameters:
@OrganisationID
@Name
@Description
@Value

Returns:
@intErrorNumber As ''ErrorNumber'',
@strErrorMessage As ''ErrorMessage''

Called By:
Link.cs.

Calls:
Nothing

Remarks:
Exception:
0. Succeed
2. FK constraint
5. MissingParameterException



Author: Peter Kneale
Date Created: 16 August 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

**/
CREATE    Procedure [dbo].[prcOrganisationConfig_Update]
(
@OrganisationID	Integer=null,
@Name		    nVarchar(255)=null,
@Description	nVarchar(255)=null,
@Value		    nVarchar(4000)=null
)

As

Set NoCount On
Set Xact_Abort On

Begin Transaction

-- Declarations
Declare @strErrorMessage Varchar(200) -- Holds the error message
Declare @intErrorNumber Integer -- Holds the error number

-- Initialise variables
Set @strErrorMessage = ''''
Set @intErrorNumber = 0

--Validate Parameter @OrganisationID
If(@OrganisationID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @OrganisationID in stored procedure prcOrganisationConfig_Update''
Goto Finalise
End
--Validate Parameter @Name
If(@Name Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @Name in stored procedure prcOrganisationConfig_Update''
Goto Finalise
End
--Validate Parameter @Description
If(@Description Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @Description in stored procedure prcOrganisationConfig_Update''
Goto Finalise
End
-- Validate that the Organsiation exists exist.
If(@organisationID > 0)
begin
	if Not Exists(Select * From tblOrganisation Where [OrganisationID] = @OrganisationID)
	Begin
	Set @intErrorNumber = 2
	Set @strErrorMessage = ''The Organisation '' + cast(@OrganisationID as varchar) + '' doesnt exist.''
	Goto Finalise
	End
end
-- Validate that the Name exists exist.
If Not Exists(Select * From tblOrganisationConfig Where [Name] = @Name)
Begin
Set @intErrorNumber = 21
Set @strErrorMessage = ''The Name '' + @Name + '' doesnt exist.''
Goto Finalise
End

if(@organisationID > 0)
begin
Begin
INSERT INTO [tblOrganisationConfig]
([OrganisationID], 	[Name], [Description],	[Value])
VALUES
(@OrganisationID,	@Name, @Description,	@Value)
End
end if(@organisationID = 0)
begin
update [tblOrganisationConfig]
set [Value] = @value
where
organisationid is null and
description = @description

end

-- Finalise the procedure
Goto Finalise



Finalise:
If(@intErrorNumber > 0)
Begin
Rollback Transaction
Select
@intErrorNumber As ''ErrorNumber'',
@strErrorMessage As ''ErrorMessage''
End
Else
Begin
Commit Transaction
Select
@intErrorNumber As ''ErrorNumber'',
@strErrorMessage As ''ErrorMessage''
End





' 
END
GO
/****** Object:  StoredProcedure [dbo].[prcOrganisationConfig_GetList]    Script Date: 04/30/2013 10:59:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisationConfig_GetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



/*
Summary: Get a list of client configuration values
Parameters:
Returns:

Called By:
Calls:

Remarks:

Author: Peter Kneale
Date Created: 16 August 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE   Procedure [dbo].[prcOrganisationConfig_GetList]
@organisationID 	Int = 0
As

Set Nocount On


if(@organisationID > 0)
begin
-- This returns the specific org values
Select
0 as ''Default'',
[Name],
[Description],
[Value]
From
tblOrganisationConfig
Where
OrganisationID = @organisationID
UNION
-- And unions it with the default ones.
Select
-1 as ''Default'',
[Name],
[Description],
[Value]
From tblOrganisationConfig

Where Name not in
(
select [Name] from tblOrganisationConfig where organisationID = @organisationID
)
And
OrganisationID is Null
-- do the filter to not show some of the config
and [Name] not in
(
''Ebook_NewUpdate_Subject'',
''Ebook_NewUpdate_Body''
)
Order By
[Name]
end
else if(@organisationID = 0)
begin

Select
[Name],
[Description],
[Value]
From
tblOrganisationConfig
Where
organisationID is null
and name not in
(
''ShowDetailedHelp'',
''css'',
''Number_Of_Quiz_Questions''
)
Order By
[Name]

end



' 
END
GO
/****** Object:  StoredProcedure [dbo].[prcOrganisation_GetOne]    Script Date: 04/30/2013 10:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_GetOne]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary: Gets othe details of one Organisation
Parameters: @orgID integer
Returns: OrganisationID, OrganisationName,  Logo, Notes, DefaultLessonFrequency, DefaultQuizFrequency, DefaultQuizPassMark, CreatedBy, DateCreated,  UpdatedBy, DateUpdated

Called By: Organisation.cs
Calls: None

Remarks: Raises an error if the parameter is null

Author: Peter Vranich
Date Created: 4th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	aaronc		May 2008		Added retrieval of CPDReportName
#2	aaronc		June2008		Added retrieval of AllocatedDiskSpace
*/

CREATE procedure [dbo].[prcOrganisation_GetOne]
(
@LangCode nvarchar(10),
@orgID Integer = null -- OrganisationID
)

As
BEGIN

If @orgID Is Null
Begin
Raiserror(''''''''''The Parameter @orgID was null.  @orgID does not accept Null values.'''''''''', 16, 1)
Return
End

Select
o.OrganisationID,
o.OrganisationName,
o.Logo,
orgN.Notes,
o.DefaultLessonFrequency,
o.DefaultQuizFrequency,
o.DefaultQuizPassMark,
dbo.udfUTCtoDaylightSavingTime(o.DefaultLessonCompletionDate, o.OrganisationID) as DefaultLessonCompletionDate,
dbo.udfUTCtoDaylightSavingTime(o.DefaultQuizCompletionDate, o.OrganisationID) as DefaultQuizCompletionDate,
o.AdvancedReporting,
o.CreatedBy,
dbo.udfUTCtoDaylightSavingTime(o.DateCreated, o.OrganisationID) as DateCreated,
o.UpdatedBy,
dbo.udfUTCtoDaylightSavingTime(o.DateUpdated, o.OrganisationID)as DateUpdated,
o.CPDReportName,
o.AllocatedDiskSpace,
o.IncludeCertificateLogo,
o.PasswordLockout,
o.TimeZoneID,
o.IncludeLogoOnCorrespondence,
o.QuizDueDate,
o.ShowLastPassed,
o.DisablePasswordField,
o.DefaultEbookEmailNotification
From
tblOrganisation o
left join tblOrganisationNotes orgN	on o.OrganisationID = orgN.OrganisationID
left join tblLang l	on orgN.LanguageID = l.LangID
Where
o.OrganisationID = @orgID
and l.LangCode = @LangCode

END

' 
END
GO



/****** Object:  StoredProcedure [dbo].[prcSCORMgetSession]    Script Date: 05/01/2013 13:34:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcSCORMgetSession]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcSCORMgetSession]
GO
/****** Object:  StoredProcedure [dbo].[prcSCORMgetSession]    Script Date: 05/01/2013 13:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcSCORMgetSession]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[prcSCORMgetSession] (
@StudentID int,
@LessonID int,
@isLesson int
)
AS
BEGIN
SET NOCOUNT ON;
DECLARE @RC int
DECLARE @OrganisationID int
DECLARE @NumQuestions int
DECLARE @quizpassmark int
DECLARE @Name nvarchar(255)
SET @Name = N''Number_Of_Quiz_Questions''
SELECT @OrganisationID = OrganisationID FROM tblUser WHERE UserID = @StudentID
SELECT @quizpassmark = DefaultQuizPassMark FROM tblOrganisation WHERE OrganisationID = @organisationID
--EXECUTE @NumQuestions = prcOrganisationConfig_GetOne  @organisationID = @OrganisationID, @name = @Name



If Exists (Select OrganisationID From tblOrganisationConfig Where OrganisationID = @organisationID And [Name]	= @Name)
Begin
Select @NumQuestions = value from tblOrganisationConfig Where OrganisationID	= @OrganisationID And [Name]		= @Name
End
Else
Begin
Select @NumQuestions = Value From tblOrganisationConfig Where OrganisationID	is null And  [Name]		= @Name
End



-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
DECLARE @initialized INT

SELECT @initialized = Count(*) from tblScormDME
WHERE UserID = @StudentID
AND LessonID = @LessonID
AND DME = ''cmi.core.student_id''
IF (@initialized = 0)
BEGIN
INSERT INTO  tblScormDME (UserID,LessonID,DME,[value]) VALUES(@StudentID,@LessonID,''cmi.core.student_id'' ,''Salt™''+CAST(@StudentID AS varchar(20)))
INSERT INTO  tblScormDME (UserID,LessonID,DME,[value]) VALUES(@StudentID,@LessonID,''cmi.core.student_name'' ,(SELECT FirstName FROM tblUser WHERE UserID = @StudentID))
INSERT INTO  tblScormDME (UserID,LessonID,DME,[value]) VALUES(@StudentID,@LessonID,''cmi.core.version'' ,''3.4'')
INSERT INTO  tblScormDME (UserID,LessonID,DME,[value]) VALUES(@StudentID,@LessonID,''cmi.core.numrandom'' ,@NumQuestions )
INSERT INTO  tblScormDME (UserID,LessonID,DME,[value]) VALUES(@StudentID,@LessonID,''cmi.core.quizpassmark'' ,@quizpassmark)
END
SELECT DME,value FROM  tblScormDME
WHERE UserID = @StudentID
and LessonID = @LessonID


END

' 
END
GO


 /****** Object:  StoredProcedure [dbo].[prcPolicy_GetUserLastAccepted]    Script Date: 05/10/2013 12:42:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcPolicy_GetUserLastAccepted]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcPolicy_GetUserLastAccepted]
GO
/****** Object:  StoredProcedure [dbo].[prcReport_UserEbookDownload]    Script Date: 05/10/2013 12:42:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_UserEbookDownload]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcReport_UserEbookDownload]
GO
/****** Object:  StoredProcedure [dbo].[prcOrganisation_Add]    Script Date: 05/10/2013 12:42:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_Add]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcOrganisation_Add]
GO
/****** Object:  StoredProcedure [dbo].[prcEmail_LogSentEmail]    Script Date: 05/10/2013 12:42:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcEmail_LogSentEmail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcEmail_LogSentEmail]
GO
/****** Object:  StoredProcedure [dbo].[prcEmail_LogSentEmail]    Script Date: 05/10/2013 12:42:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcEmail_LogSentEmail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[prcEmail_LogSentEmail]
@toEmail	nvarchar(1000),
@toName	nvarchar(128),
@fromEmail	nvarchar(128),
@fromName	nvarchar(128),
@CC		nvarchar(1000) = '''',
@BCC 		nvarchar(1000) = '''',
@subject	nvarchar (256),
@body		ntext,
@organisationID	int,
@userID int = 0
As

-- attempt to check if the user exist and find the userid
-- else we just insert 0
-- this is because the service log the email as well and i am unable to find where it can retrieve
-- the userid in a short time
-- hence the workaround
if(@userID=0)
begin

set @userid=coalesce((select top 1 userid from tblUser where organisationid=@organisationid and email=@toemail), 0)

end


Insert Into
tblEmail
(
ToEmail,
ToName,
FromEmail,
FromName,
CC,
BCC,
Subject,
Body,
DateCreated,
OrganisationID,
userID
)

Values
(
@toEmail,
@toName,
@fromEmail,
@fromName,
@CC,
@BCC,
@subject,
@body,
GetUTCDate(),
@organisationID,
@userid
)
' 
END
GO
/****** Object:  StoredProcedure [dbo].[prcOrganisation_Add]    Script Date: 05/10/2013 12:42:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
Add a new Organisation.

Parameters:
@intOrganisationID Integer OutPut
@organisationID Integer
@organisationName VarChar(50)
@notes VarChar(1000)
@logo VarChar(100)
@lessonFrequency Integer
@quizFrequency Integer
@quizPassMark Integer
@CPDReportName nvarchar(255)
@AllocatedDiskSpace Integer = Null
@InclLogo bit = 0,
@PasswordLockout bit = 0
@TimeZoneID int = Null


Returns:
Nothing

Called By:
Organisation.cs.

Calls:
Nothing

Remarks:
Exception:
0. Succeed
4. UniqueViolationException
5. MissingParameterException
6. PermissionDeniedException
10. BusinessServiceException (General)

Author: Peter Vranich
Date Created: 18th February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	mikev		30/4/2007		Added @lessonCompletionDate and @quizCompletionDate
#2  aaronc		May 2008		Added @CPDReportName
#3	aaronc		June 2008		Added @AllocatedDiskSpace
#4  aaronc		June2008		Addition of organisation record to tblOrganisationCPDPolicyAccess
#5  vdl			08 June 2011	Time zone

**/
CREATE    Procedure [dbo].[prcOrganisation_Add]
(
@intOrganisationID Integer OutPut, -- The ID of the newly created organisation.
@organisationName nVarChar(50) = Null, -- The name of the organisation.
@notes nVarChar(4000) = Null, -- The notes for the organisation.
@logo VarChar(100) = Null, -- The name of the organisation logo image.
@lessonFrequency Integer = Null, -- Default Lesson frequency for the organisation.
@quizFrequency Integer = Null, -- Default Quiz frequency for the organisation.
@quizPassMark Integer = Null, -- Default Quiz pass mark for the organisation.
@lessonCompletionDate DateTime = Null, -- Default Lesson completion date
@quizCompletionDate DateTime = Null, -- Default Quiz completion date
@advancedReporting bit = 0,
@actionUserID Integer = Null, -- ID of the User that is making the changes.
@CPDReportName nvarchar(255) = Null, -- CPD Report Name
@AllocatedDiskSpace Integer = Null, -- Allocated Disk Space
@InclLogo bit = 0, -- include Certificate Logo
@PasswordLockout bit = 0,
@TimeZoneID int = Null,
@ShowLastPassed bit = 1,
@DisablePasswordField bit = 0,
@DefaultEbookEmailNotification bit = 0
)

As

Set NoCount On
Set Xact_Abort On

Begin Transaction

-- Declarations
Declare @strErrorMessage Varchar(200) -- Holds the error message
Declare @intErrorNumber Integer -- Holds the error number
Declare @intUserTypeOrgAdmin Integer -- Holds the value for the OrgAdmin UserTypeID from the tblUserType table.

-- Initialise variables
Set @strErrorMessage = ''''
Set @intErrorNumber = 0
Select @intUserTypeOrgAdmin = UserTypeID From tblUserType Where Type = ''Organisation Administrator''

-- Validation Routines
If(@actionUserID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @userID in stored procedure prcOrganisation_Add''
Goto Finalise
End

If Not Exists(Select * From tblUser Where UserID = @actionUserID And UserTypeID <= @intUserTypeOrgAdmin)
Begin
Set @intErrorNumber = 6
Set @strErrorMessage = ''You do not have access to modify this Organisation.''
Goto Finalise
End

If(@organisationName Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @organisationName in stored procedure prcOrganisation_Add''
Goto Finalise
End

If Exists(Select * From tblOrganisation Where OrganisationName = @organisationName)
Begin
Set @intErrorNumber = 4
Set @strErrorMessage = ''The Organisation Name '' + @organisationName + '' already exists please choose another name for your Organisation.''
Goto Finalise
End

If(@notes Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @notes in stored procedure prcOrganisation_Add''
Goto Finalise
End

If(@logo Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @logo in stored procedure prcOrganisation_Add''
Goto Finalise
End

If(@lessonFrequency Is Null and @lessonCompletionDate Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @lessonFrequency, @lessonCompletionDate in stored procedure prcOrganisation_Add''
Goto Finalise
End

If(@quizFrequency Is Null and @quizCompletionDate Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @quizFrequency, @quizCompletionDate in stored procedure prcOrganisation_Add''
Goto Finalise
End

If(@quizPassMark Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @quizPassMark in stored procedure prcOrganisation_Add''
Goto Finalise
End

Insert Into tblOrganisation
(
OrganisationName,
Logo,
DefaultLessonFrequency,
DefaultQuizFrequency,
DefaultQuizPassMark,
--	DefaultLessonCompletionDate,
--	DefaultQuizCompletionDate,
advancedReporting,
CreatedBy,
CPDReportName,
AllocatedDiskSpace,
IncludeCertificateLogo,
PasswordLockout,
TimeZoneID,
ShowLastPassed,
DisablePasswordField,
DefaultEbookEmailNotification
)
Values
(
@organisationName,
@logo,
@lessonFrequency,
@quizFrequency,
@quizPassMark,
--	@lessonCompletionDate,
--	@quizCompletionDate,
@advancedReporting,
@actionUserID,
@CPDReportName,
@AllocatedDiskSpace,
@InclLogo,
@PasswordLockout,
@TimeZoneID,
@ShowLastPassed,
@DisablePasswordField,
@DefaultEbookEmailNotification
)


Select @intOrganisationID = @@Identity

-- lesson completion datetime to utc
set @lessonCompletionDate = dbo.udfDaylightSavingTimeToUtc (@lessonCompletionDate, @intOrganisationID)

-- quiz completion time to utc
set @quizCompletionDate = dbo.udfDaylightSavingTimeToUtc (@quizCompletionDate, @intOrganisationID)


--update the org with these utc dates
update
tblOrganisation
set
DefaultLessonCompletionDate = @lessonCompletionDate,
DefaultQuizCompletionDate = @quizCompletionDate
where
OrganisationID =  @intOrganisationID



/* Remove this as the tables below no longer exist
insert into tblOrganisationCPDAccess
(
OrganisationID,
GrantCPDAccess
)
values
(
@intOrganisationID,
0 -- no access initially
)

insert into tblOrganisationPolicyAccess
(
OrganisationID,
GrantPolicyAccess
)
values
(
@intOrganisationID,
0 -- no access initially
)
*/

-- Add values to tblOrganisationNotes
Declare LangIDLOOP CURSOR
for
select LangID from tblLang

open LangIDLOOP

declare @LangID int

FETCH NEXT from LangIDLOOP into @LangID
while @@FETCH_STATUS = 0
BEGIN

insert into tblOrganisationNotes
(
OrganisationID,
LanguageID,
Notes
)
values
(
@intOrganisationID,
@LangID,
@notes
)
FETCH NEXT from LangIDLOOP into @LangID
END
close LangIDLOOP
deallocate LangIDLOOP

Finalise:
If(@intErrorNumber > 0)
Begin
Rollback Transaction
Select
@intErrorNumber As ''ErrorNumber'',
@strErrorMessage As ''ErrorMessage''
End
Else
Begin
Commit Transaction
Select
@intErrorNumber As ''ErrorNumber'',
''Successfully Added'' As ''ErrorMessage''
End
' 
END
GO
/****** Object:  StoredProcedure [dbo].[prcReport_UserEbookDownload]    Script Date: 05/10/2013 12:42:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_UserEbookDownload]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE  PROCEDURE [dbo].[prcReport_UserEbookDownload]
(
@OrganisationID int,
@IncludeInactiveUsers int,
@UnitIDs varchar(max),
@courseIDs varchar(max)
)
AS
SET NOCOUNT ON

begin

DECLARE @Units TABLE
(
UnitID INT PRIMARY KEY(UnitID)
)

DECLARE @Courses TABLE
(
CourseID INT PRIMARY KEY(CourseID)
)

INSERT INTO @Courses SELECT * FROM dbo.udfCsvToInt(@courseIDs)

INSERT INTO @Units SELECT * FROM  dbo.udfCsvToInt(@unitIDs)


select
uh.HierarchyName as UnitPathway,
u.UserID,
u.FirstName,
u.LastName,
u.UnitID,
u.Email,
u.UserName,
u.ExternalID,
ct.Name as GroupBy,
c.Value as Value,
dbo.udfUTCtoDaylightSavingTime(ue.DateDownloaded ,@organisationID) AS ''DateDownloaded''
from
tblUserEbook ue
inner join tblUser u
	on ue.userid=u.userid
inner join tblEbook e
	on ue.UserBookID=e.ebookid
inner join tblUnitHierarchy uh
	on u.unitid=uh.unitid
left join tblUserClassification uc 
	on u.UserID = uc.UserID
left join tblClassification c 
	on uc.ClassificationID = c.ClassificationID
left join tblClassificationType ct 
	on c.ClassificationTypeID = ct.ClassificationTypeID
where
ue.result=''success''
and u.Active = CASE @IncludeInactiveUsers WHEN 0 THEN 1 ELSE u.Active END

END

' 
END
GO
/****** Object:  StoredProcedure [dbo].[prcPolicy_GetUserLastAccepted]    Script Date: 05/10/2013 12:42:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcPolicy_GetUserLastAccepted]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[prcPolicy_GetUserLastAccepted]
	@userID int,
	@organisationid int,
	@policyID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select 
	convert(varchar(10), dbo.udfUTCtoDaylightSavingTime(dateAccepted,@organisationid), 103) ''dateaccepted''
	from tblUserPolicyAccepted where userid=@userID and policyID = @policyID
END
' 
END
GO



/****** Object:  StoredProcedure [dbo].[prcAutomatedEmails_UsersToNotify]    Script Date: 05/10/2013 14:39:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcAutomatedEmails_UsersToNotify]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcAutomatedEmails_UsersToNotify]
GO
/****** Object:  StoredProcedure [dbo].[prcAutomatedEmails_UsersToNotify]    Script Date: 05/10/2013 14:39:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcAutomatedEmails_UsersToNotify]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[prcAutomatedEmails_UsersToNotify]
(
@OrganisationID int
)


AS

BEGIN

declare @OrgMidnight datetime

set @OrgMidnight =  DATEADD(d,-1,dbo.udfGetSaltOrgMidnight(@OrganisationID))



--                    H O U S E K E E P I N G
--tblUserCourseDetails contains information on notifications about courses that have ''at risk'' quizes
--add any new courses
INSERT INTO tblUserCourseDetails (UserID,CourseID,UserCourseStatusID,NumberOfDelinquencyNotifications, NewStarterFlag, AtRiskQuizList, NotifiedModuleList, LastDelinquencyNotification)

select U.UserID,CourseID,UserCourseStatusID,0,null,'''','''',null
FROM  tblUser U inner join tblUserCourseStatus tUCS ON U.UserID = tUCS.UserID and U.OrganisationID = @organisationID  INNER JOIN
(SELECT MAX(UserCourseStatusID) AS MaxUserCourseStatusID
FROM   dbo.tblUserCourseStatus
GROUP BY UserID, CourseID) AS currentStatus ON tUCS.UserCourseStatusID = currentStatus.MaxUserCourseStatusID

where  CourseStatusID in (1,2) and UserCourseStatusID NOT IN (SELECT UserCourseStatusID FROM tblUserCourseDetails)






--remove data on courses that are now unassigned
DELETE FROM tblUserCourseDetails WHERE UserCourseStatusID IN
(SELECT UserCourseStatusID
FROM  tblUser U inner join tblUserCourseStatus tUCS ON U.UserID = tUCS.UserID and U.OrganisationID = @organisationID  INNER JOIN
(SELECT MAX(UserCourseStatusID) AS MaxUserCourseStatusID
FROM   dbo.tblUserCourseStatus
GROUP BY UserID, CourseID) AS currentStatus ON tUCS.UserCourseStatusID = currentStatus.MaxUserCourseStatusID

where  CourseStatusID = 0
)








--                    S E L E C T    T H E    R E S U L T S

--declare @OrganisationID int
--set @OrganisationID = 68

create table #UsersToNotify
(userid int not null
,NewContent nvarchar(max) null
,PassedCourses nvarchar(max) null
,PassedModules nvarchar(max) null
,AtRiskContent nvarchar(max) null
,AtRiskOfdelinquency nvarchar(max) null)



insert into #UsersToNotify
SELECT distinct UsersToNotify.userid , UsersToNotify.NewContent , PassedCourses, PassedModules ,AtRiskContent,AtRiskOfdelinquency FROM
(

SELECT '''' as UserCourseStatusID, tblExpiredNewContent.UserID , tblCourse.Name + '' - ''+ tblModule.Name as NewContent , '''' as PassedCourses ,'''' as PassedModules , '''' as AtRiskContent, '''' as AtRiskOfdelinquency
FROM  tblExpiredNewContent INNER JOIN
tblModule ON tblExpiredNewContent.ModuleID = tblModule.ModuleID INNER JOIN
tblCourse ON tblModule.CourseID = tblCourse.CourseID
WHERE tblExpiredNewContent.organisationID = @OrganisationID



-- users with passed courses
UNION all SELECT '''' as UserCourseStatusID, CS.userid , '''' as NewContent,''   ''+ C.Name as PassedCourses,'''' as PassedModules, '''' as AtRiskContent, '''' as AtRiskOfdelinquency
FROM tblUserCourseStatus CS
inner join tblUser U ON U.UserID = CS.UserID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
where U.OrganisationID = @OrganisationID and CS.CourseStatusID=2 and DATEDIFF(d,CS.DateCreated,@OrgMidnight) < 0 and u.Active=1


-- users with passed modules
UNION all SELECT '''' as UserCourseStatusID, QuizStatus.userid ,
'''' as NewContent, '''' as PassedCourses,
''   ''+c.name  + '' - '' + m.name as PassedModules, '''' as AtRiskContent,
'''' as AtRiskOfdelinquency
from
tblUserQuizStatus QuizStatus
join tblUser  u on u.UserID = QuizStatus.UserID and u.OrganisationID = @OrganisationID
inner join tblModule m on m.ModuleID = QuizStatus.ModuleID
join tblCourse c on c.CourseID = m.CourseID
inner join
(
select
max(UserQuizStatusID) UserQuizStatusID, uqs.UserID, uqs.ModuleID --UserQuizStatusID is identity
from
tblUserQuizStatus uqs
join tblUser  u on u.UserID = uqs.UserID
WHERE DATEDIFF(d,uqs.DateCreated,@OrgMidnight) < 0
and u.OrganisationID = @OrganisationID
group by
uqs.UserID,moduleID
) currentStatus
on QuizStatus.UserQuizStatusID = currentStatus.UserQuizStatusID
where m.active = 1
and QuizStatusID =2

and u.Active=1



-- users with quizes at risk ( N O R M A L    R U L E S )
UNION all SELECT DISTINCT '''' as UserCourseStatusID, AR.userID,  '''' as NewContent , '''' as PassedCourses,'''' as PassedModules,''   ''+ C.Name as AtRiskContent, '''' as AtRiskOfdelinquency
from tblQuizExpiryAtRisk AR
INNER JOIN tblUser U On U.UserID = AR.UserID
inner join tblModule M on m.ModuleID = AR.ModuleID and m.Active = 1 and AR.OrganisationID = @OrganisationID
INNER JOIN tblCourse C ON C.CourseID = M.CourseID
where U.Active = 1 AND daysToExpiry >= 0 and Notified = 0

-- users with quizes at risk ( N O R M A L    R U L E S )
UNION all SELECT DISTINCT '''' as UserCourseStatusID, AR.userID,  '''' as NewContent , '''' as PassedCourses,'''' as PassedModules,''   ''+ C.Name +'' ( ''+M.name +'') ''                       + convert(varchar (11),DATEADD(d,daysToExpiry, dbo.udfGetSaltOrgDate(@OrganisationID) ) ,113)  as AtRiskContent, '''' as AtRiskOfdelinquency
from tblQuizExpiryAtRisk AR
INNER JOIN tblUser U On U.UserID = AR.UserID
inner join tblModule M on m.ModuleID = AR.ModuleID and m.Active = 1 and AR.OrganisationID = @OrganisationID
INNER JOIN tblCourse C ON C.CourseID = M.CourseID
where U.Active = 1 AND daysToExpiry > 0 and Notified = 0




-- users with courses at risk of delinquency (1ST WARNING)

UNION all SELECT DISTINCT UserCourseStatusID  , userID ,  '''' as NewContent , '''' as PassedCourses,'''' as PassedModules, '''' as AtRiskContent,''   ''+ Name +'' '' + convert(varchar (11),DATEADD(d,DaysToCompleteCourse, dbo.udfUTCtoDaylightSavingTime(DateCreated,@OrganisationID)),113)  as AtRiskOfdelinquency
FROM (SELECT MAX(CD.UserCourseStatusID) as UserCourseStatusID, CS.userID ,  RemEsc.DaysToCompleteCourse, MIN(CS.DateCreated) as DateCreated,C.Name,CS.CourseID
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID) AND (RemindUsers=1)
where U.Active = 1
AND ((o.DefaultQuizCompletionDate is not null AND CS.DateCreated >  dateadd(year,-1,o.DefaultQuizCompletionDate))
OR     (o.DefaultQuizCompletionDate is  null AND CS.DateCreated >= (select ISNULL((SELECT MAX(DateCreated) FROM tblUserCourseStatus Expired where expired.CourseStatusID in (0,2) and Expired.CourseID = CS.CourseID and Expired.UserID =CS.UserID) ,''1 jan 1990'')) ))
AND CD.LastDelinquencyNotification IS NULL
AND coursestatusid=1
AND o.OrganisationID = @OrganisationID
AND (GETUTCDATE() > DATEADD(d,RemEsc.DaysToCompleteCourse-RemEsc.NumOfRemNotfy*RemEsc.RepeatRem, CS.DateCreated))
AND (RemEsc.NumOfRemNotfy > cd.NumberOfDelinquencyNotifications)
AND (GETUTCDATE() < DATEADD(m,RemEsc.DaysToCompleteCourse+6, CS.DateCreated))
GROUP BY  CS.CourseID, CS.userID ,  RemEsc.DaysToCompleteCourse, C.Name) ThisCycle




---- users with courses at risk of delinquency (SUBSEQUENT WARNINGS)

UNION all SELECT DISTINCT UserCourseStatusID  , userID ,  '''' as NewContent , '''' as PassedCourses,'''' as PassedModules, '''' as AtRiskContent,''   ''+ Name +'' '' + convert(varchar (11),DATEADD(d,DaysToCompleteCourse, dbo.udfUTCtoDaylightSavingTime(DateCreated,@OrganisationID)),113)  as AtRiskOfdelinquency
FROM (SELECT MAX(CD.UserCourseStatusID) as UserCourseStatusID, CS.userID ,  RemEsc.DaysToCompleteCourse, MIN(CS.DateCreated) as DateCreated,C.Name,CS.CourseID
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID) AND (RemindUsers=1)
where U.Active = 1 AND coursestatusid=1 AND o.OrganisationID = @OrganisationID
AND CD.LastDelinquencyNotification IS NOT NULL
AND ((o.DefaultQuizCompletionDate is not null AND CS.DateCreated >  dateadd(year,-1,o.DefaultQuizCompletionDate))
OR     (o.DefaultQuizCompletionDate is  null AND CS.DateCreated >= (select ISNULL((SELECT MAX(DateCreated) FROM tblUserCourseStatus Expired where expired.CourseStatusID in (0,2) and Expired.CourseID = CS.CourseID and Expired.UserID =CS.UserID) ,''1 jan 1990'')) ))
AND coursestatusid=1
AND o.OrganisationID = @OrganisationID
AND (GETUTCDATE() > DATEADD(d,RemEsc.DaysToCompleteCourse-RemEsc.NumOfRemNotfy*RemEsc.RepeatRem, CS.DateCreated))
AND (RemEsc.NumOfRemNotfy > cd.NumberOfDelinquencyNotifications)
AND (GETUTCDATE() > DATEADD(d,RemEsc.RepeatRem, CD.LastDelinquencyNotification))
AND (GETUTCDATE() < DATEADD(m,RemEsc.DaysToCompleteCourse+6, CS.DateCreated))

GROUP BY  CS.CourseID, CS.userID ,  RemEsc.DaysToCompleteCourse, C.Name) ThisQuizCycle




) UsersToNotify


create index in_1 on #UsersToNotify(userid)



create table #UsersToNotifyList
(userid int not null
,NewContent nvarchar(max) null
,PassedCourses nvarchar(max) null
,PassedModules nvarchar(max) null
,AtRiskContent nvarchar(max) null
,AtRiskOfdelinquency nvarchar(max) null)

create index in_2 on #UsersToNotifyList(userid)

declare @userid int
,@NewContent nvarchar(max)
,@PassedCourses nvarchar(max)
,@PassedModules nvarchar(max)
,@AtRiskContent nvarchar(max)
,@AtRiskOfdelinquency nvarchar(max)

while exists (select 1 from #UsersToNotify)
begin
set rowcount 1
select @userid = userid
,@NewContent = NewContent
, @PassedCourses = PassedCourses
,@PassedModules = PassedModules
,@AtRiskContent = AtRiskContent
,@AtRiskOfdelinquency = AtRiskOfdelinquency

from #UsersToNotify
if exists (select * from #UsersToNotifyList where userid = @userid)
begin
update #UsersToNotifyList set
NewContent = rtrim(CAST(#UsersToNotifyList.NewContent + (case when #UsersToNotifyList.NewContent = '''' or @NewContent = '''' then '''' else ''<BR>'' end ) + (case when @NewContent ='''' then '''' else ''&nbsp;&nbsp;'' end) +@NewContent AS NVARCHAR(max)))
, PassedCourses = rtrim(CAST(#UsersToNotifyList.PassedCourses + (case when #UsersToNotifyList.PassedCourses = '''' or @PassedCourses = '''' then '''' else ''<BR>'' end)+ (case when @PassedCourses ='''' then '''' else ''&nbsp;&nbsp;'' end) + @PassedCourses AS NVARCHAR(max)))
,PassedModules = rtrim(CAST(#UsersToNotifyList.PassedModules + (case when #UsersToNotifyList.PassedModules = '''' or @PassedModules = '''' then '''' else ''<BR>'' end)+ (case when @PassedModules ='''' then '''' else ''&nbsp;&nbsp;'' end) + @PassedModules AS NVARCHAR(max)))
,AtRiskContent = rtrim(CAST(#UsersToNotifyList.AtRiskContent + (case when #UsersToNotifyList.AtRiskContent = '''' or @AtRiskContent = '''' then '''' else ''<BR>'' end)+ (case when @AtRiskContent ='''' then '''' else ''&nbsp;&nbsp;'' end) + @AtRiskContent AS NVARCHAR(max)))
,AtRiskOfdelinquency = rtrim(CAST(#UsersToNotifyList.AtRiskOfdelinquency + (case when #UsersToNotifyList.AtRiskOfdelinquency = '''' or @AtRiskOfdelinquency = '''' then '''' else ''<BR>'' end)+ (case when @AtRiskOfdelinquency ='''' then '''' else ''&nbsp;&nbsp;'' end) + @AtRiskOfdelinquency AS NVARCHAR(max)))
from #UsersToNotifyList
where #UsersToNotifyList.userid = @userid
end
else
begin
insert #UsersToNotifyList(userid,NewContent,PassedCourses,PassedModules,AtRiskContent,AtRiskOfdelinquency)
values (@userid,@NewContent,@PassedCourses,@PassedModules,@AtRiskContent,@AtRiskOfdelinquency)

end
delete #UsersToNotify where
@userid = userid
and @NewContent = NewContent
and  @PassedCourses = PassedCourses
and  @PassedModules = PassedModules
and @AtRiskContent = AtRiskContent
and  @AtRiskOfdelinquency = AtRiskOfdelinquency
set rowcount 0
end



SELECT l.UserID,
-- Recipient Email Address
(SELECT Email FROM tblUser WHERE UserID = l.UserID) as RecipientEmail,

-- Sender Email Address
(SELECT dbo.udfUser_GetAdministratorsEmailAddress (l.UserID)) as SenderEmail,

-- Subject
(select REPLACE(
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_Subject'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_Subject''))),''%APP_NAME%'',(SELECT Value FROM tblAppConfig where Name = ''AppName''))) as Subject,



-- Header
(select coalesce((select REPLACE(
(select REPLACE(
(select REPLACE(
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_Header'')
,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_Header'')))
,''%APP_NAME%'',(SELECT Value FROM tblAppConfig where Name = ''AppName'')))
,''%FirstName%'',(SELECT COALESCE(FirstName,'''') FROM tblUser WHERE UserID = l.UserID)))
,''%LastName%'',(SELECT COALESCE(LastName,'''') FROM tblUser WHERE UserID = l.UserID))),''header error''))


--New Content
+ (select coalesce(case when NewContent = '''' then '''' else
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_ExpiredContent'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_ExpiredContent'')))+''&nbsp;&nbsp;''+NewContent+ ''<BR>'' end,''error reading Student_Summary_ExpiredContent''))

--Passed Courses
+ (select coalesce(case when PassedCourses = '''' then '''' else
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_PassedCourses'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_PassedCourses'')))+''&nbsp;&nbsp;''+PassedCourses+ ''<BR>'' end,''error reading Student_Summary_PassedCourses''))

--Passed Modules
+ (select coalesce(case when PassedModules = '''' then '''' else
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_PassedModules'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_PassedModules'')))+''&nbsp;&nbsp;''+PassedModules+ ''<BR>'' end,''error reading Student_Summary_PassedModules''))

--AtRiskContent
+ (select coalesce(case when AtRiskContent = '''' then '''' else
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_AtRiskOfExpiry'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_AtRiskOfExpiry'')))+''&nbsp;&nbsp;''+AtRiskContent+ ''<BR>'' end,''error reading Student_Summary_AtRiskOfExpiry''))

--AtRiskOfdelinquency
+ (select coalesce(case when AtRiskOfdelinquency = '''' then '''' else
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_AtRiskOfBeingOverdue'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_AtRiskOfBeingOverdue'')))+''&nbsp;&nbsp;''+AtRiskOfdelinquency+ ''<BR>'' end,''error reading Student_Summary_AtRiskOfBeingOverdue''))

--Email Sig
+     (select REPLACE(
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_Sig'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_Sig'')))+ ''<BR>''  ,''%APP_NAME%'',(SELECT Value FROM tblAppConfig where Name = ''AppName''))) as Body
, -- Sender"On Behalf Of" Email Address
(SELECT dbo.udfUser_GetAdministratorsOnBehalfOfEmailAddress (l.UserID))  as OnBehalfOfEmail,


*

FROM
#UsersToNotifyList l




--                    H O U S E K E E P I N G  (tidy up for tomorrow)

-- Update record of "at risk of Delinquency" notifications
-- Update tblUserCourseDetails.LastDelinquencyNotification
UPDATE tblUserCourseDetails  SET LastDelinquencyNotification = GETUTCDATE()
WHERE  UserCourseStatusID in (-- users with courses at risk of delinquency (1ST WARNING)

SELECT DISTINCT UserCourseStatusID
FROM (SELECT MAX(CD.UserCourseStatusID) as UserCourseStatusID, CS.userID ,  RemEsc.DaysToCompleteCourse, MIN(CS.DateCreated) as DateCreated,C.Name,CS.CourseID
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID) AND (RemindUsers=1)
where U.Active = 1
AND ((o.DefaultQuizCompletionDate is not null AND CS.DateCreated >  dateadd(year,-1,o.DefaultQuizCompletionDate))
OR     (o.DefaultQuizCompletionDate is  null AND CS.DateCreated >= (select ISNULL((SELECT MAX(DateCreated) FROM tblUserCourseStatus Expired where expired.CourseStatusID in (0,2) and Expired.CourseID = CS.CourseID and Expired.UserID =CS.UserID) ,''1 jan 1990'')) ))
AND CD.LastDelinquencyNotification IS NULL
AND coursestatusid=1
AND o.OrganisationID = @OrganisationID
AND (GETUTCDATE() > DATEADD(d,RemEsc.DaysToCompleteCourse-RemEsc.NumOfRemNotfy*RemEsc.RepeatRem, CS.DateCreated))
AND (RemEsc.NumOfRemNotfy > cd.NumberOfDelinquencyNotifications)
AND (GETUTCDATE() < DATEADD(m,RemEsc.DaysToCompleteCourse+6, CS.DateCreated))
GROUP BY  CS.CourseID, CS.userID ,  RemEsc.DaysToCompleteCourse, C.Name) ThisCycle
)




UPDATE tblUserCourseDetails  SET LastDelinquencyNotification = GETUTCDATE(), NumberOfDelinquencyNotifications = NumberOfDelinquencyNotifications + 1
WHERE  UserCourseStatusID in (-- users with courses at risk of delinquency (SUBSEQUENT WARNINGS)
SELECT DISTINCT UserCourseStatusID
FROM (SELECT MAX(CD.UserCourseStatusID) as UserCourseStatusID, CS.userID ,  RemEsc.DaysToCompleteCourse, MIN(CS.DateCreated) as DateCreated,C.Name,CS.CourseID
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID) AND (RemindUsers=1)
where U.Active = 1 AND coursestatusid=1 AND o.OrganisationID = @OrganisationID
AND CD.LastDelinquencyNotification IS NOT NULL
AND ((o.DefaultQuizCompletionDate is not null AND CS.DateCreated >  dateadd(year,-1,o.DefaultQuizCompletionDate))
OR     (o.DefaultQuizCompletionDate is  null AND CS.DateCreated >= (select ISNULL((SELECT MAX(DateCreated) FROM tblUserCourseStatus Expired where expired.CourseStatusID in (0,2) and Expired.CourseID = CS.CourseID and Expired.UserID =CS.UserID) ,''1 jan 1990'')) ))
AND coursestatusid=1
AND o.OrganisationID = @OrganisationID
AND (GETUTCDATE() > DATEADD(d,RemEsc.DaysToCompleteCourse-RemEsc.NumOfRemNotfy*RemEsc.RepeatRem, CS.DateCreated))
AND (RemEsc.NumOfRemNotfy > cd.NumberOfDelinquencyNotifications)
AND (GETUTCDATE() > DATEADD(d,RemEsc.RepeatRem, CD.LastDelinquencyNotification))
AND (GETUTCDATE() < DATEADD(m,RemEsc.DaysToCompleteCourse+6, CS.DateCreated))

GROUP BY  CS.CourseID, CS.userID ,  RemEsc.DaysToCompleteCourse, C.Name) ThisQuizCycle
)

/*-- Update Record of notified NEW Modules
UPDATE tblUserCourseDetails  SET NotifiedModuleList =  ModulesAssigned  from
(SELECT UserCourseStatusID, ModulesAssigned
FROM (select tUCS.ModulesAssigned, tUCS.CourseID,tUCS.CourseStatusID,tUCS.UserCourseStatusID as UCSUserCourseStatusID
FROM  tblUser U inner join tblUserCourseStatus tUCS ON U.UserID = tUCS.UserID and U.OrganisationID = 9   INNER JOIN

(SELECT MAX(UserCourseStatusID) AS MaxUserCourseStatusID
FROM   dbo.tblUserCourseStatus
GROUP BY UserID, CourseID) AS currentStatus ON tUCS.UserCourseStatusID = currentStatus.MaxUserCourseStatusID) CS
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
Inner join tblUserCourseDetails CD on  CD.UserCourseStatusID = CS.UCSUserCourseStatusID
and  CS.CourseStatusID=1
) temp
where tblUserCourseDetails.UserCourseStatusID = temp.UserCourseStatusID*/


DELETE FROM tblExpiredNewContent WHERE organisationID = @OrganisationID



-- Update record of notified "At Risk Quizes"
-- users with quizes at risk ( N O R M A L    R U L E S )
update tblQuizExpiryAtRisk SET Notified = 1 WHERE organisationID = @OrganisationID and Notified = 0


if OBJECT_ID(''#UsersToNotifyList'') is not null
begin
drop table #UsersToNotifyList
end

if  OBJECT_ID(''#UsersToNotify'')is not null
begin
drop table #UsersToNotify
END
end








' 
END
GO


/****** Object:  StoredProcedure [dbo].[prcOrganisation_GetPolicyList]    Script Date: 05/13/2013 13:48:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_GetPolicyList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcOrganisation_GetPolicyList]
GO
/****** Object:  StoredProcedure [dbo].[prcOrganisation_GetPolicyList]    Script Date: 05/13/2013 13:48:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_GetPolicyList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Gets a List of Policies for a particular organisation.

Parameters:
@organisationID

Returns:
Nothing

Called By:
Organisation.cs.

Calls:
Nothing

Remarks:
None

Author: Aaron Cripps
Date Created: June 2008

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

**/

CREATE   Procedure [dbo].[prcOrganisation_GetPolicyList]
(
@organisationID Integer = Null -- ID of the Organisation that you wish to get the Policies for
)

As


select
PolicyID,
PolicyName,
PolicyFileName,
Active
from tblPolicy
where
OrganisationID = @OrganisationID
and deleted = 0
order by PolicyName


' 
END
GO



/****** Object:  StoredProcedure [dbo].[prcReport_Warning]    Script Date: 05/24/2013 11:18:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_Warning]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcReport_Warning]
GO
/****** Object:  StoredProcedure [dbo].[prcReport_Warning]    Script Date: 05/24/2013 11:18:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_Warning]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/******************************************************************************
**		Name: prcReport_Warning
**
**		Called by:
**
**		Auth: Mark Donald
**		Date: 7 Dec 2009
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**
*******************************************************************************/


CREATE PROCEDURE [dbo].[prcReport_Warning]
(
@organisationID int,
@unitIDs varchar(max),
@courseIDs varchar(8000),
@classificationID int,
@warningPeriod int,
@warningUnit varchar(2),
@IncludeInactive int
)
AS
SET NOCOUNT ON;

DECLARE @Units TABLE (UnitID INT PRIMARY KEY(UnitID))
DECLARE @Courses TABLE(CourseID INT PRIMARY KEY(CourseID))
DECLARE @CoursesWithAccess 	TABLE (CourseID INT PRIMARY KEY(CourseID))
DECLARE @Users TABLE(UserID INT , UnitID INT PRIMARY KEY(UserID, UnitID))
DECLARE @tblCurrentAssignedModules TABLE (
CourseID int,
UserID int,
UnitID int,
ModuleID int,
QuizFrequency int,
QuizCompletionDate datetime
)
DECLARE @tblStartedModules TABLE (
UserID int,
ModuleID int,
DateTimeCompleted datetime
)

INSERT INTO
@Courses
SELECT
*
FROM
dbo.udfCsvToInt(@courseIDs)

INSERT INTO
@Units
SELECT
*
FROM
dbo.udfCsvToInt(@unitIDs)

-- Get users for specfied units, matching Custom Classification option (if provided)
INSERT INTO @Users
SELECT
DISTINCT A.UserID, A.UnitiD
FROM
tblUser A
JOIN @Units B on A.UnitID = B.UnitID
JOIN tblUnit C on B.UnitID = C.UnitID AND C.Active = 1
LEFT JOIN tblUserClassification uc ON uc.UserID  = A.UserID
WHERE
A.Active = (case when @includeinactive = 0 then 1 else A.active end )
AND ((@classificationID =0) OR (classificationID = @classificationID))
--If classification is Any (0), This will find users of any Custom Classification

-- Get compliance rules for in-scope modules
INSERT INTO @tblCurrentAssignedModules
SELECT
CourseID, UserID, um.UnitID, um.ModuleID, QuizFrequency, QuizCompletionDate
FROM
(SELECT
tU.UserID, tU.UnitID, tM.ModuleID
FROM
dbo.tblUser tU
INNER JOIN dbo.tblOrganisationCourseAccess tOCA ON tOCA.OrganisationID = tU.OrganisationID
INNER JOIN dbo.tblCourse tC ON tC.CourseID = tOCA.GrantedCourseID
INNER JOIN dbo.tblModule tM ON tM.CourseID = tC.CourseID AND tM.Active = 1
LEFT OUTER JOIN dbo.tblUserModuleAccess tUsrMA ON tUsrMA.UserID = tU.UserID
AND tUsrMA.ModuleID = tM.ModuleID
LEFT OUTER JOIN dbo.tblUnitModuleAccess tUnitMA ON tUnitMA.UnitID = tU.UnitID
AND tUnitMA.DeniedModuleID = tM.ModuleID
WHERE
tU.OrganisationID = @organisationID
AND	tU.Active = (case when @includeinactive = 0 then 1 else tU.Active end )
AND tu.UnitID IS NOT NULL
AND dbo.udfUserCourseComplete(tu.userid, tm.courseid) = 1
AND ((tUnitMA.DeniedModuleID IS NULL AND tUsrMA.ModuleID IS NULL)
OR tUsrMA.Granted=1)
) um
INNER JOIN (
SELECT
u.UnitID, m.CourseID, m.ModuleID,
CASE
WHEN (
ur.QuizFrequency IS NULL
AND ur.QuizCompletionDate IS NULL
AND o.DefaultQuizCompletionDate IS NULL
) THEN
o.DefaultQuizFrequency
ELSE
ur.QuizFrequency
END AS QuizFrequency,
CASE
WHEN (
ur.QuizFrequency IS NULL
AND ur.QuizCompletionDate IS NULL
AND o.DefaultQuizCompletionDate IS NOT NULL
) THEN
o.DefaultQuizCompletionDate
ELSE
ur.QuizCompletionDate
END AS QuizCompletionDate
FROM
tblOrganisationCourseAccess c
INNER JOIN tblModule m ON m.CourseID = c.GrantedCourseID
INNER JOIN tblOrganisation o ON o.OrganisationID = c.OrganisationID -- default compliance rules
INNER JOIN tblUnit u ON u.OrganisationID = c.OrganisationID
LEFT JOIN tblUnitRule ur ON ur.ModuleID = m.ModuleID AND ur.UnitID = u.unitID -- unit specific rules
WHERE o.OrganisationID = @organisationID
) umr ON umr.ModuleID  = um.ModuleID
AND umr.UnitID = um.UnitID
AND um.UnitID IN (SELECT DISTINCT UnitID FROM @users)
AND um.UserID IN (SELECT DISTINCT UserID FROM @users)
AND umr.CourseID IN (SELECT CourseID FROM @courses)

-- Get module completion details
INSERT INTO @tblStartedModules
SELECT
um.userID, um.moduleID, qs.DateTimeCompleted
FROM
@tblCurrentAssignedModules um
INNER JOIN (
SELECT
um.userID, um.moduleID, max(DateTimeCompleted) AS DateTimeCompleted
FROM
@tblCurrentAssignedModules um
INNER JOIN tblQuiz q ON q.ModuleID = um.ModuleID
INNER JOIN tblQuizSession qs ON qs.QuizID= q.quizID
AND qs.userID = um.userID
AND qs.DateTimeCompleted IS NOT NULL
GROUP BY
um.userID, um.moduleID
) AS LastQuizDate ON
LastQuizDate.userID = um.userID
AND LastQuizDate.ModuleID = um.ModuleID
INNER JOIN tblQuiz q ON q.ModuleID = um.ModuleID
INNER JOIN tblQuizSession qs ON
qs.QuizID= q.quizID
AND qs.userID = um.userID
AND qs.DateTimeCompleted = LastQuizDate.DateTimeCompleted

-- User/course combos where the courses are about to be marked incomplete due to module expiry
BEGIN
SELECT
c.[name] as CourseName,
HierarchyName AS UnitPathway,
LastName,
FirstName,
case when u.Active = 1 then ''''  else ''(i)'' end as Flag,
ExternalID,
Email,
UserName,
dbo.udfUTCtoDaylightSavingTime(max(DateTimeCompleted), @organisationID) AS CompletionDate,
dbo.udfUTCtoDaylightSavingTime(min(isnull(QuizCompletionDate, dateadd(month, QuizFrequency, DateTimeCompleted))), @organisationID) AS ExpiryDate
FROM
@tblCurrentAssignedModules cam
INNER JOIN @tblStartedModules sm ON sm.UserID = cam.UserID AND sm.ModuleID = cam.ModuleID,
tblCourse c,
tblUser u,
tblUnitHierarchy h
WHERE
c.CourseID = cam.CourseID
AND u.UserID = cam.UserID
AND h.UnitID = cam.UnitID
GROUP BY
c.[name], HierarchyName,  LastName, FirstName, ExternalID, Email, Username, u.Active
HAVING
min(isnull(
QuizCompletionDate,
dateadd(month, QuizFrequency, DateTimeCompleted)
)) < CASE @warningUnit
WHEN ''mm'' THEN
dateadd(mm, @warningPeriod, getutcdate())
ELSE
dateadd(dd, @warningPeriod, getutcdate())
END
ORDER BY
CourseName, UnitPathway, LastName, FirstName
END
' 
END
GO






