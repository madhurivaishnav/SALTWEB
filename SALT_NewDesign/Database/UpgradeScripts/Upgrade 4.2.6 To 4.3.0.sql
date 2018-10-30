IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tblOrganisation' 
		AND  COLUMN_NAME = 'DisablePasswordField')
BEGIN
alter table tblOrganisation
	add DisablePasswordField bit not null default 0
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_GetOne]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcOrganisation_GetOne]
GO
/****** Object:  StoredProcedure [dbo].[prcOrganisation_CheckDisabledPasswordField]    Script Date: 10/15/2012 12:26:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_CheckDisabledPasswordField]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcOrganisation_CheckDisabledPasswordField]
GO
/****** Object:  StoredProcedure [dbo].[prcOrganisation_Add]    Script Date: 10/15/2012 12:26:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_Add]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcOrganisation_Add]
GO
/****** Object:  StoredProcedure [dbo].[prcOrganisation_Update]    Script Date: 10/15/2012 12:26:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_Update]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcOrganisation_Update]
GO
/****** Object:  StoredProcedure [dbo].[prcOrganisation_Update]    Script Date: 10/15/2012 12:26:58 ******/
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
@DisablePasswordField bit = 0
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
DisablePasswordField=@DisablePasswordField
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
/****** Object:  StoredProcedure [dbo].[prcOrganisation_Add]    Script Date: 10/15/2012 12:26:57 ******/
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
@DisablePasswordField bit = 0
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
DisablePasswordField
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
@DisablePasswordField
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
/****** Object:  StoredProcedure [dbo].[prcOrganisation_CheckDisabledPasswordField]    Script Date: 10/15/2012 12:26:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_CheckDisabledPasswordField]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[prcOrganisation_CheckDisabledPasswordField]
(
@OrgID int
)
as
Select
DisablePasswordField
From
tblOrganisation
Where
OrganisationID = @OrgID
' 
END
GO
/****** Object:  StoredProcedure [dbo].[prcOrganisation_GetOne]    Script Date: 10/15/2012 12:26:57 ******/
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
o.DisablePasswordField
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



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcUser_Import]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcUser_Import]
GO
/****** Object:  StoredProcedure [dbo].[prcUser_Import]    Script Date: 11/26/2012 14:20:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcUser_Import]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
Summary: Insert/Update the details of tblUser table
Parameters:
@userXML text The XML document containing the User data.
@ID Integer ID of either the Organisation or Unit
@hierachy VarChar(12) hierachy where the call to upload useres was made from. can only be Organisation or Unit.
@userID Integer = null -- ID of user inporting the xmlData
Returns:


Called By:
User.cs
Calls:

Author: Li Zhang
Date Created: July 2008

Modification History
-----------------------------------------------------------
v#	Author		Date		Description

*/

CREATE    Procedure [dbo].[prcUser_Import]
(
@userName nvarchar(200),
@password nvarchar(100),
@firstName nvarchar(200),
@lastName nvarchar(200),
@email nvarchar(255),
@unitID int,
@classificationName nvarchar(100),
@classificationOption nvarchar(100),
@externalID	nvarchar(100),
@archival	int,
@isUpdate bit,
@uniqueField int,
@userID int,
@orgID int,
@NotifyUnitAdmin nvarchar(3),
@NotifyOrgAdmin nvarchar(3),
@ManagerNotification nvarchar(3),
@ManagerToNotify nvarchar(255)
)

As
begin

Set NoCount on

Set Xact_Abort On
Begin Transaction


--Declarations
Declare @uniqueField_Email int
Declare @uniuqeField_Username int

set @uniqueField_Email = 1
set @uniuqeField_Username = 2

declare @t int

--update
IF (@isUpdate = 1)
BEGIN

IF (@uniqueField = @uniqueField_Email)
BEGIN

--select ''debug update unique field email''
update tblUser
set UserName = case when @username =''''  then username else ISNULL(@userName,u.UserName)end,
FirstName = case when @firstname = '''' then FirstName else ISNULL(@firstName, u.FirstName)end,
LastName = case when @lastName =''''  then  lastname else ISNULL(@lastName, u.LastName)end,
Password = case when @password ='''' then Password else ISNULL(@password, u.password)end,
ExternalID = case when @externalid ='''' then externalid when @externalid =''^'' then null else ISNULL(@externalID, u.externalID)end,
UnitID = ISNULL(@unitID, u.UnitID),
Active = Case @archival when 1 then 0 -- archive user = true
when 0 then 1 -- archive user = false
else u.Active end,--remain unchanged
DateArchived = Case @archival when 1 then getutcdate()
when 0 then null
else u.DateArchived end,
NotifyUnitAdmin = case when @NotifyUnitAdmin is null then NotifyUnitAdmin when @NotifyUnitAdmin=''Yes'' then 1 when @NotifyUnitAdmin=''No'' then 0  else NotifyUnitAdmin end,
NotifyOrgAdmin = case when @NotifyOrgAdmin is null then notifyorgadmin  when @NotifyOrgAdmin = ''Yes'' then 1 when @NotifyOrgAdmin = ''No''then 0 else NotifyOrgAdmin end,
NotifyMgr = case when @ManagerNotification is null then NotifyMgr when @ManagerNotification = ''Yes'' then 1 when @ManagerNotification = ''No'' then 0 else NotifyMgr end,
DelinquencyManagerEmail = case when @ManagerToNotify='''' then DelinquencyManagerEmail when @ManagerToNotify = ''^'' then null else @ManagerToNotify end,
DateUpdated = getutcdate(),
UpdatedBy = @userID
FROM tblUser u
WHERE
u.Email = @email
and
u.OrganisationID = @orgID

-- get the userid from the email since it is the unique field
select @t = UserID from tblUser where Email = @email


--select ''debug update complete unique field email''
END

else IF (@uniqueField = @uniuqeField_Username)
BEGIN
--select ''debug update unique field username'' + @userName

update tblUser
set FirstName = case when @firstname = '''' then FirstName else ISNULL(@firstName, u.FirstName)end,
LastName = case when @lastName =''''  then  lastname else ISNULL(@lastName, u.LastName)end,
Password = case when @password ='''' then Password else ISNULL(@password, u.password)end,
ExternalID = case when @externalid ='''' then externalid when @externalid =''^'' then null else ISNULL(@externalID, u.externalID)end,
Email = case when @email ='''' then email else ISNULL(@Email, u.Email)end,
UnitID = ISNULL(@unitID, u.UnitID),
Active = Case @archival when 1 then 0
when 0 then 1
else u.Active end,
DateArchived = Case @archival when 1 then getutcdate()
when 0 then null
else u.DateArchived end,
DateUpdated = getutcdate(),
UpdatedBy = @userID,
NotifyUnitAdmin = case when @NotifyUnitAdmin is null then NotifyUnitAdmin when @NotifyUnitAdmin=''Yes'' then 1 when @NotifyUnitAdmin=''No'' then 0  else NotifyUnitAdmin end,
NotifyOrgAdmin = case when @NotifyOrgAdmin is null then notifyorgadmin  when @NotifyOrgAdmin = ''Yes'' then 1 when @NotifyOrgAdmin = ''No''then 0 else NotifyOrgAdmin end,
NotifyMgr = case when @ManagerNotification is null then NotifyMgr when @ManagerNotification = ''Yes'' then 1 when @ManagerNotification = ''No'' then 0 else NotifyMgr end,
DelinquencyManagerEmail = case when @ManagerToNotify='''' then DelinquencyManagerEmail when @ManagerToNotify = ''^'' then null else @ManagerToNotify end
FROM tblUser u
WHERE
u.Username = @username
and
u.OrganisationID = @orgID

-- get the user id from the user name since it is the key field
select @t = UserID from tblUser where Username = @username

--select ''debug update complete unique field username'' + @userName
END

--select @classificationName as a , @classificationOption as b

if (@classificationName!='''' and @classificationOption !='''')
begin
-- Delete existing userclassifications
--====================================

--select @uniqueField , @uniuqeField_Username

IF (@uniqueField = @uniuqeField_Username)
BEGIN

Delete
From
tblUserClassification
from tblUserClassification uc
join tblUser u on u.UserID = uc.UserID
Where
u.UserName = @userName

--select ''debug deleted classifications username''

-- only insert if its not delete ie is not ''^''
if (@classificationName != ''^'' and @classificationOption != ''^'')
begin
--select ''debug inserting classifications username''
-- insert the updated ones into the database
--===================================================
insert into tblUserClassification
(
UserID,
ClassificationID
)
select UserID, cl.ClassificationID
from
tblClassificationType ct
join tblClassification cl on cl.ClassificationTypeID = ct.ClassificationTypeID and ct.OrganisationID=@orgID
join tblUser on UserName = @userName
where
Value= @classificationOption
and ct.OrganisationID = @orgid
--select ''debug completed inserting classifications username''
end
END

IF (@uniqueField = @uniqueField_Email)
BEGIN
Delete
From
tblUserClassification
from tblUserClassification uc
join tblUser u on u.UserID = uc.UserID
Where
u.Email = @email

--select ''debug deleted classifications email ''

-- only insert if its not delete ie is not ''^''
if (@classificationName != ''^'' and @classificationOption != ''^'')
begin
--select ''debug inserting classifications email''
-- insert the updated ones into the database
--===================================================
insert into tblUserClassification
(
UserID,
ClassificationID
)
select userid, cl.ClassificationID
from
tblClassificationType ct
join tblClassification cl on cl.ClassificationTypeID = ct.ClassificationTypeID and ct.OrganisationID=@orgID
join tblUser on Email = @email
where
Value= @classificationOption
and ct.OrganisationID = @orgid
--select ''debug completed inserting classifications email''
end
END

END


--if @archival = 1 begin
--select ''insert into tblBulkInactiveUsers''
--insert into tblBulkInactiveUsers (UserID)values(@t)
--end
END

-- insert
IF @isUpdate = 0
BEGIN
insert into tblUser
(
Username,
Password,
Firstname,
Lastname,
Email,
ExternalID,
OrganisationID,
UnitID,
CreatedBy,
Active,
DateArchived,
NewStarter,
NotifyUnitAdmin,
NotifyOrgAdmin,
NotifyMgr,
DelinquencyManagerEmail

) values
(
@username,
@password,
@firstname,
@lastname,
@email,
@externalID,
@orgID,
@unitID,
@userID,
case @archival when 1 then 0 else 1 end,
case @archival when 1 then getutcdate() else null end,
1,
case when @NotifyUnitAdmin=''Yes'' then 1 else 0 end ,
case when @NotifyOrgAdmin = ''Yes'' then 1 else 0 end,
case when @ManagerNotification = ''Yes'' then 1 else 0 end,
case when @ManagerToNotify='''' then null else @ManagerToNotify end
)
select @t = UserID from tblUser where Username = @username and Email = @email

--Insert the classification data into the tblUserCalssification table.
Insert Into tblUserClassification
(
UserID,
ClassificationID
)
select
@t,
cls.ClassificationID
From
tblClassificationType As c, tblClassification As cls
where c.Name = @classificationName
And (c.OrganisationID = @orgID)
and cls.ClassificationTypeID = c.ClassificationTypeID
AND cls.Value = @classificationOption
And (cls.Active = 1)


--insert course licencing for the imported user
INSERT INTO tblCourseLicensingUser(CourseLicensingID, UserID)
SELECT 		DISTINCT
tblCourseLicensing.CourseLicensingID,
vwUserModuleAccess.UserID

FROM
tblCourseLicensing
INNER JOIN vwUserModuleAccess ON tblCourseLicensing.CourseID = vwUserModuleAccess.CourseID
AND tblCourseLicensing.OrganisationID = vwUserModuleAccess.OrganisationID
INNER JOIN tblUser ON vwUserModuleAccess.UserID = tblUser.UserID
LEFT OUTER JOIN	tblCourseLicensingUser ON tblUser.UserID = tblCourseLicensingUser.UserID
AND tblCourseLicensing.CourseLicensingID = tblCourseLicensingUser.CourseLicensingID
WHERE
tblCourseLicensing.DateStart <= GETUTCDATE()
AND tblCourseLicensing.DateEnd >= GETUTCDATE()
AND tblCourseLicensingUser.CourseLicensingID IS NULL
AND tblUser.userid = @t


-- Get ProfilePeriodIDs for Organisation
create table #ProfilePeriod
(
ProfilePeriodID int
)

insert into #ProfilePeriod
select ProfilePeriodID
from tblProfilePeriod  pp
join tblprofile p
on pp.profileid = p.profileid
where p.organisationid = @orgID


-- insert user into profileperiodaccess against all profileperiodids
-- for the organisation
insert into tblUserProfilePeriodAccess
select ProfilePeriodID, @t, 0 from #ProfilePeriod

drop table #ProfilePeriod

-- Get Policies for Organisation
create table #Policy
(
PolicyID int
)

insert into #Policy
select PolicyID
from tblPolicy
where OrganisationID = @orgID
and deleted = 0

-- insert user  policy access for all policies associated with organisation
insert into tbluserpolicyaccess (PolicyID, UserID,Granted)
select PolicyID, @t, 0 from #Policy

-- insert user policy acceptance for all policies for this org
insert into tblUserPolicyAccepted (PolicyID, UserID, Accepted)
select PolicyID, @t, 0 from #Policy

drop table #Policy

select @archival as archive

END

commit

END
' 
END
GO



/*Summary:
Check lesson status for the Lesson session started and completed

Returns:

Called By:

Calls:
Nothing

Remarks:

select * from tblLessonSession

1. Get the module Lesson current status and the current status date

2. Starting a lesson session (update DateTimeStarted), check whether need to start a new frequency (In Progress)
a)If new frequency has already been started, ignore this session
(The current status is In Progress(2) or Completed (3))
b)If new frequency has not been started, start it.
(The current status is  Unassigned (0), Not Started (1), Expired (Time Elapsed) (4),Expired (New Content) (5),  or no status,
insert the new status In Progress (2) <------)

3. Completing a lesson session  (update DateTimeCompleted), check whether the lesson status is Completed
a)The current status is Completed(3), ignore this session
b)New frequency started(the current status is In Progress(2)):
If  all pages have been accessed from new frequency starting date(current status date),
set the lesson Completed (insert the new status Completed (3) <------)
c)Other Status (Unassigned (0), Not Started (1), Expired (Time Elapsed) (4),Expired (New Content) (5),  or no status
Ignore it. The current status should be Completed, or In Progress, If it is other status, some errors occur.

Author: Jack Liu
Date Created: 20 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	Peter Kneale 23 Nov	2005	Removed Transactions



**/

ALTER TRIGGER [dbo].[trgLessonSession] ON [dbo].[tblLessonSession]
FOR Update
AS
set nocount on

--Only fire the trigger if there is only one record updated
if ((select count(LessonID) from inserted)=1)
begin

declare @intUserID int,  @intLessonID int, @dteDateTimeStarted datetime, @dteDateTimeCompleted datetime
declare @intLessonStatusID int,  @intNewLessonStatusID int
declare @dteStatusDate datetime

/*
1. Get the module Lesson current status and the current status date
*/

select  @intUserID = ls.UserID,
@intLessonID = ls.LessonID,
@dteDateTimeStarted = ls.DateTimeStarted,
@dteDateTimeCompleted = ls.DateTimeCompleted,
@intLessonStatusID = uls.LessonStatusID,
@dteStatusDate = uls.DateCreated
from inserted ls
inner join tblLesson l
on l.LessonID = ls.LessonID
left join vwUserLessonStatus uls
on uls.UserID = ls.UserID
and uls.ModuleID = l.ModuleID


/*

2. Starting a lesson session (update DateTimeStarted), check whether need to start a new frequency (In Progress)
a)If new frequency has already been started, ignore this session
(The current status is In Progress(2) or Completed (3))
b)If new frequency has not been started, start it.
(The current status is  Unassigned (0), Not Started (1), Expired (Time Elapsed) (4),Expired (New Content) (5),  or no status,
insert the new status In Progress (2) <------)
*/
set @intNewLessonStatusID = -1 --<----- Ignore it

if (Update(DateTimeStarted) and @dteDateTimeStarted is not null)
begin
If (@intLessonStatusID = 2) or (@intLessonStatusID = 3)
begin
set @intNewLessonStatusID = -1  --<----- Ignore it
end
else
begin
set @intNewLessonStatusID = 2 --<----- Add new status  In Progress (2)
end
end
/*
3. Completing a lesson session  (update DateTimeCompleted), check whether the lesson status is Completed
a)The current status is Completed(3), ignore this session
b)New frequency started(the current status is In Progress(2)):
If  all pages have been accessed from new frequency starting date(current status date),
set the lesson Completed (insert the new status Completed (3) <------)
c)Other Status (Unassigned (0), Not Started (1), Expired (Time Elapsed) (4),Expired (New Content) (5),  or no status
Ignore it. The current status should be Completed, or In Progress, If it is other status, some errors occur.

*/
else 	if (Update(DateTimeCompleted) and @dteDateTimeCompleted is not null)
begin
If (@intLessonStatusID = 3)
begin
set @intNewLessonStatusID = -1
end
else if (@intLessonStatusID = 2)
begin
--Check whether all pages have been accessed from current status date (new frequency starting date)
if not exists (select lp.LessonPageID
from tblLesson l
inner join tblLessonPage lp
on lp.LessonID = l.LessonID
left join (
select distinct lpaHistory.LessonPageID
from tblLessonSession lsHistory
inner join tblLessonPageAudit lpaHistory
on lpaHistory.LessonSessionID = lsHistory.LessonSessionID
and lpaHistory.DateAccessed>=@dteStatusDate
where 	lsHistory.UserID = @intUserID
and lsHistory.LessonID = @intLessonID
) PageAccessed -- Get all pages accessed since new frequency starting date
on PageAccessed.LessonPageID = lp.LessonPageID
where l.LessonID = @intLessonID
and  PageAccessed.LessonPageID is null)
begin
set @intNewLessonStatusID = 3  --<----- Add new status Completed (3)
end
end
end
--select @intNewLessonStatusID
if (@intNewLessonStatusID>-1)
begin
insert into tblUserLessonStatus
(
UserID,
ModuleID,
LessonStatusID,
LessonFrequency
)
Select 	@intUserID,
l.ModuleID,
@intNewLessonStatusID as LessonStatusID,
umr.LessonFrequency
From  tblUser us
inner join tblLesson l -- Get Module
on l.LessonID = @intLessonID
inner join vwUnitModuleRule umr --Get Rules
on umr.ModuleID  = l.ModuleID
and umr.UnitID = us.UnitID
where us.UserID = @intUserID
end

end
GO

/* Summary:
Update quiz status for each user

Returns:

Called By:

Calls:
Nothing

Remarks:
This is a schedule job running every night to check there are any changes in the user quiz status based on current compliance rules.
If they are the same as the current status, ignore it, otherwise a new status will be created.

If a module is assigned to a user, and there is no activity for this module, the status will be  'Not started'.
If a module is unassigned from a user, the status will be 'unassinged"(There are records in status table, but the module is not assigned to this user now)
If a module is set to inactive, the status will be 'unassinged'

All user-module pair need to be re-evaluated, as compliance rules may be changed since the user's last toolbook activity.

------------ Decision Processes -------------

1. Get Current User Quiz status
-----------------------------------
1.1  Get all modules that are currently assigned to each users (CurrentAssignedModules)
and compliance rules

1.2. Get the last quiz activity for each user and module pair (StartedModules)

1.3. Unassigned Modules (0) (PreviousAssignedModules - CurrentAssignedModules)
a) Get a list of modules that is in the quiz status table that the last statuses are not Unassigned (0)(PreviousAssignedModules)
b) Get rid off all modules that are currently assigned to the users (from step 1)
c)All modules left are Unassigned(0)

1.4. Not Started Modules (1) (CurrentAssignedModules- StartedModules)
All currently assigned modules that don't have any activity is Not Started (1)

1.5. Started Modules
a)If the last quiz is inactive, the status is Expired (New Content)(5)
b)If the last quiz is past the current quiz date/frequency, the status is Expired (Time Expired)(4)
c)If the last quiz is during the current quiz frequency, get the current pass mark, and check the quiz status
If user Failed the quiz, the status is Failed (3)
If user Passed the quiz, the status is Passed (2)

2. Update User Quiz status
----------------------------
If the last quiz status for each user is not the same as the current status, add the new status



------------ Data need to be recorded -------------

QuizFrequency	QuizPassMark	QuizScore
0  Unassigned:  		-		-		-
1  Not Started: 		Y		Y		-
2  Passed: 	 		Y		Y		Y
3  Failed: 	 		Y		Y		Y
4  Expired (Time Elapsed): 	Y		Y		-
5  Expired (New Content): 	Y		Y		-


Author: Jack Liu
Date Created: 20 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	mikev		1/5/2007		Added logic for new fields LessonCompletionStatus & QuizCompletionStatus
#2	mikev		9/5/2007		Added course completion logic. If a module is marked active or not active; to calculate if the course is complete.
#3	Mark Donald	21/9/2009		Added OrganisationName (control character) to License Warning emails

prcUserQuizStatus_Update_Quick

**/
ALTER   Procedure [dbo].[prcUserQuizStatus_Update_Quick]
(
@OrgID int	-- comma separated organisationID
)
AS
Set Nocount On
declare @intHistoryID int

insert into tblModuleStatusUpdateHistory(startTime) values(getUTCdate());
set @intHistoryID = @@identity

--1. Get Current User Quiz status
--mikev : added QuizCompletionDate
/* UNITTEST: CurrentAssignedModules */
CREATE TABLE #tblCurrentUserQuizStatus
(
UserID int NOT NULL ,
ModuleID int NOT NULL ,
QuizStatusID int not NULL ,
QuizFrequency int NULL ,
QuizPassMark int NULL ,
QuizCompletionDate DateTime NULL,
QuizScore int NULL,
QuizSessionID uniqueidentifier NULL
)


/*
1.1  Get all modules that are currently assigned to each users (CurrentAssignedModules)
and current compliance rules
*/
-- mikev(1): added completion date

select
um.UserID,
um.ModuleID,
umr.QuizFrequency,
umr.QuizPassMark,
umr.QuizCompletionDate
into
#tblCurrentAssignedModules
from
(
Select
tU.UserID
, tU.UnitID
, tU.OrganisationID
, tM.ModuleID


From
dbo.tblUser tU
--< get the courses a user has access to >--
Inner Join dbo.tblOrganisationCourseAccess tOCA
On  tOCA.OrganisationID = tU.OrganisationID
--< get the course details >--
Inner join dbo.tblCourse tC
On tC.CourseID = tOCA.GrantedCourseID
--< get the Active modules in a course >--
inner join dbo.tblModule tM
On tM.CourseID = tC.CourseID
and tM.Active = 1
--< get the details on which moduels a user is configured to access >--
Left Outer join dbo.tblUserModuleAccess tUsrMA
On  tUsrMA.UserID = tU.UserID
And tUsrMA.ModuleID = tM.ModuleID
--< get the details on which moduels a user's Unit is excluded from  >--
Left Outer Join dbo.tblUnitModuleAccess tUnitMA
On  tUnitMA.UnitID = tU.UnitID
And tUnitMA.DeniedModuleID = tM.ModuleID
Where
tU.OrganisationID = @OrgID AND
tU.Active = 1
--< Active users only >--
and tu.UnitID is not null
--< Get the modules that the user's Unit is not denied >--
and (tUnitMA.DeniedModuleID  is null
--<  and the user does not have special access to  it>--
And tUsrMA.ModuleID is null)
--< or Get modules that the user has been specially  granted
or tUsrMA.Granted=1
) um
inner join
(
Select 	u.UnitID,
m.CourseID,
m.ModuleID,
case
when ur.unitID is null then cast(1 as bit)
else cast(0 as bit)
end as UsingDefault,
case
when (ur.LessonFrequency is null and ur.LessonCompletionDate is null and o.DefaultLessonCompletionDate is null) then
o.DefaultLessonFrequency
else
ur.LessonFrequency
end
as LessonFrequency,
case
when (ur.QuizFrequency is null and ur.QuizCompletionDate is null and o.DefaultQuizCompletionDate is null) then
o.DefaultQuizFrequency
else
ur.QuizFrequency
end
as QuizFrequency,
isNull(ur.QuizPassMark, o.DefaultQuizPassMark) as QuizPassMark,
case
when (ur.LessonFrequency is null and ur.LessonCompletionDate is null and not(o.DefaultLessonCompletionDate is null)) then
o.DefaultLessonCompletionDate
else
ur.LessonCompletionDate
end
as LessonCompletionDate,
case
when (ur.QuizFrequency is null and ur.QuizCompletionDate is null and not(o.DefaultQuizCompletionDate is null)) then
o.DefaultQuizCompletionDate
else
ur.QuizCompletionDate
end
as QuizCompletionDate
From tblOrganisationCourseAccess c
inner join tblModule m
on m.CourseID = c.GrantedCourseID
inner join tblOrganisation o  -- Get default compliance rules
on o.OrganisationID = c.OrganisationID
inner join tblUnit u
on u.OrganisationID = c.OrganisationID
left join tblUnitRule ur --Get the unit specific rules
on ur.ModuleID = m.ModuleID
and ur.UnitID=u.unitID
WHERE o.OrganisationID = @OrgID
) umr
on
umr.ModuleID  = um.ModuleID
and umr.UnitID = um.UnitID
and um.UnitID in (select UnitID from tblUnit where OrganisationID = @OrgID)
and um.UserID IN (select UserID from tblUser where OrganisationID = @OrgID)
/* /UNITTEST: CurrentAssignedModules */

-- select * from #tblCurrentAssignedModules
/*
1.2. Get the last quiz activity for each user and module pair (StartedModules)
*/
/* UNITTEST: StartedModules */
select
um.userID,
um.moduleID,
q.active,
qs.QuizScore,
qs.QuizSessionID,
qs.DateTimeCompleted
into
#tblStartedModules
from
#tblCurrentAssignedModules um
inner join
(
select
um.userID, um.moduleID, max(DateTimeCompleted)  as DateTimeCompleted
from
#tblCurrentAssignedModules um
inner join tblQuiz q
on q.ModuleID = um.ModuleID
inner join tblQuizSession qs
on
qs.QuizID=	q.quizID
and qs.userID = um.userID
and qs.DateTimeCompleted is not null
group by um.userID, um.moduleID
)
as LastQuizDate

on
LastQuizDate.userID = um.userID
and LastQuizDate.ModuleID = um.ModuleID

inner join tblQuiz q
on
q.ModuleID = um.ModuleID
inner join tblQuizSession qs
on
qs.QuizID=	q.quizID
and qs.userID = um.userID
and qs.DateTimeCompleted  = LastQuizDate.DateTimeCompleted
/* /UNITTEST: StartedModules */


-- select * from #tblStartedModules

/*
1.3. Unassigned Modules (0) (PreviousAssignedModules - CurrentAssignedModules)
a) Get a list of modules that is in the quiz status table that the last statuses are not Unassigned (0)(PreviousAssignedModules)
b) Get rid off all modules that are currently assigned to the users (from step 1)
c)All modules left are Unassigned(0)
*/

/* UNITTEST: Status_Unassigned */
insert into #tblCurrentUserQuizStatus
(
UserID,
ModuleID,
QuizStatusID
)
select
uqs.UserID,
uqs.ModuleID,
0  as QuizStatusID --Unassigned (0)
from
(
select
QuizStatus.UserQuizStatusID
, QuizStatus.UserID
, QuizStatus.ModuleID
, m.CourseID
, QuizStatus.QuizStatusID
, QuizStatus.QuizFrequency
, QuizStatus.QuizPassMark
, QuizStatus.QuizSessionID
, QuizStatus.QuizScore
, QuizStatus.DateCreated

from
tblUserQuizStatus QuizStatus
inner join tblModule m on m.ModuleID = QuizStatus.ModuleID
inner join
(
select
max(UserQuizStatusID) UserQuizStatusID --UserQuizStatusID is identity
from
tblUserQuizStatus
WHERE
tblUserQuizStatus.UserID in (select UserID from tblUser where OrganisationID = @OrgID)
group by
UserID,moduleID
) currentStatus
on QuizStatus.UserQuizStatusID = currentStatus.UserQuizStatusID
where m.active = 1
) uqs
left join
#tblCurrentAssignedModules cam
on
cam.UserID = uqs.UserID
and cam.ModuleID = uqs.ModuleID
where
uqs.QuizStatusID<>0 --not Unassigned (0)
and cam.moduleID is null
and cam.UserID in (select UserID from tblUser where OrganisationID = @OrgID)
/* /UNITTEST: Status_Unassigned */

/*
1.4. Not Started Modules (1) (CurrentAssignedModules- StartedModules)
All currently assigned modules that don't have any activity is Not Started (1)
*/
-- mikev(1): added QuizCompletionDate
/* UNITTEST: Status_NotStarted */
insert into
#tblCurrentUserQuizStatus
(
UserID,
ModuleID,
QuizStatusID,
QuizFrequency,
QuizPassMark,
QuizCompletionDate
)
select
cam.UserID,
cam.ModuleID,
1  as QuizStatusID, --Not Started (1)
cam.QuizFrequency,
cam.QuizPassMark,
cam.QuizCompletionDate
from
#tblCurrentAssignedModules cam
left join
#tblStartedModules sm
on
sm.UserID = cam.UserID
and sm.ModuleID = cam.ModuleID
where
sm.moduleID is null
and cam.UserID in (select UserID from tblUser where OrganisationID = @OrgID)
/* /UNITTEST: Status_NotStarted */
/*
EXPIRED NEW CONTENT IS NOW A MANUAL PROCESS
1.5. Started Modules
a)If the last quiz is inactive, the status is Expired (New Content)(5)
b)If the last quiz is past the current quiz frequency, the status is Expired (Time Expired)(4)
c)If the last quiz is during the current quiz frequency, get the current pass mark, and check the quiz status
If user Failed the quiz, the status is Failed (3)
If user Passed the quiz, the status is Passed (2)
*/

--	  	a)If the last quiz is inactive, the status is Expired (New Content)(5)


--		b)If the last quiz is past the current quiz frequency, the status is Expired (Time Expired)(4)
-- mikev(1): added QuizCompletionDate. Added criteria
/* UNITTEST: Status_TimeExpired */
insert into #tblCurrentUserQuizStatus
(
UserID,
ModuleID,
QuizStatusID,
QuizFrequency,
QuizPassMark,
QuizCompletionDate
)
select cam.UserID,
cam.ModuleID,
4  as QuizStatusID, --  Expired (Time Expired)(4)
cam.QuizFrequency,
cam.QuizPassMark,
cam.QuizCompletionDate
from #tblCurrentAssignedModules cam
inner join #tblStartedModules sm
on sm.UserID = cam.UserID
and sm.ModuleID = cam.ModuleID
where
(
(
cam.QuizCompletionDate is null
and DateDiff(day,dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID), dateadd(month, cam.QuizFrequency, dbo.udfUTCtoDaylightSavingTime(sm.DateTimeCompleted,@OrgID))) <= 0
)
or
(
isnull(DateDiff(day, getutcdate(), cam.QuizCompletionDate), 1) <= 0
)
)
and cam.UserID in (select UserID from tblUser where OrganisationID = @OrgID)
/* /UNITTEST: Status_TimeExpired */

--		c)If the last quiz is during the current quiz frequency, get the current pass mark, and check the quiz status
--			If user Failed the quiz, the status is Failed (3)
--			If user Passed the quiz, the status is Passed (2)

-- mikev(1): added QuizCompletionDate and changed logic of criteria to use the date before the frequency
/* UNITTEST: Status_PassFail */
insert into #tblCurrentUserQuizStatus
(
UserID,
ModuleID,
QuizStatusID,
QuizFrequency,
QuizPassMark,
QuizCompletionDate,
QuizScore,
QuizSessionID
)
select cam.UserID,
cam.ModuleID,
case
when sm.QuizScore>=cam.QuizPassMark then 2 -- Passed (2)
else	3  --Failed (3)
end  as QuizStatusID,
cam.QuizFrequency,
cam.QuizPassMark,
cam.QuizCompletionDate,
sm.QuizScore,
sm.QuizSessionID
from #tblCurrentAssignedModules cam
inner join #tblStartedModules sm
on sm.UserID = cam.UserID
and sm.ModuleID = cam.ModuleID
where
not (
cam.QuizCompletionDate is null
and DateDiff(day,dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID), dateadd(month, cam.QuizFrequency, dbo.udfUTCtoDaylightSavingTime(sm.DateTimeCompleted,@OrgID))) <= 0
)
and cam.QuizCompletionDate is null
and cam.UserID in (select UserID from tblUser where OrganisationID = @OrgID)
and (select top 1 QuizStatusID from tblUserQuizStatus where ModuleID = cam.ModuleID and UserID = cam.UserID order by UserQuizStatusID Desc) NOT IN (5)

/* /UNITTEST: Status_PassFail */
/*
2. Update User Quiz status
----------------------------
If the last quiz status for each user is not the same as the current status, add the new status
*/


/* UNITTEST: CourseStatus */
-- mikev(1): added cursor for quizcompletiondate
declare @cursor_UserID 	        int
declare @cursor_ModuleID 	    int
declare @cursor_QuizStatusID 	int
declare @cursor_QuizFrequency 	int
declare @cursor_QuizPassMark	int
declare @cursor_QuizCompletionDate	DateTime
declare @cursor_QuizScore	    int
declare @cursor_QuizSessionID   varchar(50)
declare @cursor_UserQuizStatusID int

-- mikev(1): added quizcompletiondate
declare @LastUser int
declare @LastModuleID int
declare @LastCourse int
declare @LastQuizStatusID int
declare @cursor_CourseID int
set @LastUser = -1
set @LastCourse = -1
set @LastQuizStatusID = -1
set  @LastModuleID = 0
DECLARE CurrentUserQuizStatus CURSOR
FOR


select
cs.UserID,
cs.ModuleID,
cs.QuizStatusID,
cs.QuizFrequency,
cs.QuizPassMark,
cs.QuizCompletionDate,
cs.QuizScore,
cs.QuizSessionID,
s.UserQuizStatusID,
Module.CourseID
from -- Any UserModules with current access but no tblUserQuizStatus record
#tblCurrentUserQuizStatus cs
inner join tblModule Module on module.moduleID = cs.ModuleID
left join
(  -- The UserModule quiz status for the latest quiz attempt
select
QuizStatus.UserQuizStatusID
, QuizStatus.UserID
, QuizStatus.ModuleID
, m.CourseID
, QuizStatus.QuizStatusID
, QuizStatus.QuizFrequency
, QuizStatus.QuizPassMark
, QuizStatus.QuizSessionID
, QuizStatus.QuizScore
, QuizStatus.DateCreated

from
tblUserQuizStatus QuizStatus
inner join tblModule m on m.ModuleID = QuizStatus.ModuleID
inner join
(
select
max(UserQuizStatusID) UserQuizStatusID --UserQuizStatusID is identity
from
tblUserQuizStatus
WHERE
tblUserQuizStatus.UserID in (select UserID from tblUser where OrganisationID = @OrgID)
group by
UserID,moduleID
) currentStatus
on QuizStatus.UserQuizStatusID = currentStatus.UserQuizStatusID
where m.active = 1
) s
on cs.userID = s.UserID
and cs.ModuleID = s.ModuleID
and cs.QuizStatusID = s.QuizStatusID
where
s.UserQuizStatusID is null
order by cs.UserID,
case when (cs.QuizStatusID = 0) then 6 else cs.QuizStatusID end,
Module.CourseID
-- ordered so we can update course status on the last module in the course rather than for every module in the course

Open CurrentUserQuizStatus

FETCH NEXT FROM CurrentUserQuizStatus
Into
@cursor_UserID,@cursor_ModuleID,@cursor_QuizStatusID,@cursor_QuizFrequency,
@cursor_QuizPassMark,@cursor_QuizCompletionDate,@cursor_QuizScore,@cursor_QuizSessionID, @cursor_UserQuizStatusID, @cursor_CourseID
set @LastCourse = @cursor_CourseID
set @LastUser = @cursor_UserID
set @LastQuizStatusID = @cursor_QuizStatusID
set @LastModuleID = @cursor_ModuleID

DECLARE @Err integer
WHILE @@FETCH_STATUS = 0
BEGIN

insert into tblUserQuizStatus
(
UserID,
ModuleID,
QuizStatusID,
QuizFrequency,
QuizPassMark,
QuizCompletionDate,
QuizScore,
QuizSessionID
)
values
(
@cursor_UserID,
@cursor_ModuleID,
@cursor_QuizStatusID,
@cursor_QuizFrequency,
@cursor_QuizPassMark,
@cursor_QuizCompletionDate,
@cursor_QuizScore,
@cursor_QuizSessionID
)
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES('prcUserQuizStatus_Update_Quick','insert into tblUserQuizStatus','UserID='+CAST(@cursor_UserID AS varchar(10)),CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),'prcUserQuizStatus_Update_Quick',1,1,null,getutcdate(),getutcdate()) END

-- don't update the course status for every module in the course - once per course is enough
-- do update the course status on every change in QuizStatus
if (@LastCourse != @cursor_CourseID) or (@LastUser != @cursor_UserID) or (@LastQuizStatusID != @cursor_QuizStatusID) EXEC prcUserQuizStatus_UpdateCourseStatus @LastUser, @LastModuleID

set @LastCourse = @cursor_CourseID
set @LastUser = @cursor_UserID
set @LastQuizStatusID = @cursor_QuizStatusID
set @LastModuleID = @cursor_ModuleID


FETCH NEXT FROM CurrentUserQuizStatus
Into
@cursor_UserID,@cursor_ModuleID,@cursor_QuizStatusID,@cursor_QuizFrequency,
@cursor_QuizPassMark,@cursor_QuizCompletionDate,@cursor_QuizScore,@cursor_QuizSessionID, @cursor_UserQuizStatusID, @cursor_CourseID


END
-- final course may not be done so update just to be safe
if (@LastUser != -1 ) EXEC prcUserQuizStatus_UpdateCourseStatus @cursor_UserID, @cursor_ModuleID
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES('prcUserQuizStatus_Update_Quick','prcUserQuizStatus_UpdateCourseStatus','prcUserQuizStatus_UpdateCourseStatus',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),'prcUserQuizStatus_Update_Quick',1,1,null,getutcdate(),getutcdate()) END

-- Finished CurrentUserQuizStatus
CLOSE CurrentUserQuizStatus
DEALLOCATE CurrentUserQuizStatus




--              AT RISK OF EXPIRY


--DECLARE @DaysWarningBeforeExpiry int
--SELECT @DaysWarningBeforeExpiry = DaysWarningBeforeExpiry FROM tblOrganisation where OrganisationID = @OrgID
--IF (@DaysWarningBeforeExpiry IS NULL)
--BEGIN -- Default value of 30 days before quiz -- no longer use 30 days default
--	DECLARE @QuizExpiryDate DateTime
--	SELECT @QuizExpiryDate = dateadd(d,-30,QuizDueDate) FROM tblOrganisation where OrganisationID = @OrgID

--	delete from tblQuizExpiryAtRisk where OrganisationID = @OrgID
--	and not exists (select @OrgID,cam.UserID,
--	cam.ModuleID, DateDiff(day,dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID), dateadd(month, cam.QuizFrequency, dbo.udfUTCtoDaylightSavingTime(sm.DateTimeCompleted,@OrgID)))
--	from #tblCurrentAssignedModules cam
--	inner join #tblStartedModules sm
--	on sm.UserID = cam.UserID
--	and sm.ModuleID = cam.ModuleID
--	where
--	(
--		cam.QuizCompletionDate is null
--		and dbo.udfGetSaltOrgDate(@OrgID) < @QuizExpiryDate
--		and tblQuizExpiryAtRisk.UserID = cam.UserID
--		and tblQuizExpiryAtRisk.ModuleID = cam.ModuleID
--		and tblQuizExpiryAtRisk.OrganisationID = @OrgID
--	))
--	SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES('prcUserQuizStatus_Update_Quick','delete from tblQuizExpiryAtRisk','delete from tblQuizExpiryAtRisk',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),'prcUserQuizStatus_Update_Quick',1,1,null,getutcdate(),getutcdate()) END



--	insert into tblQuizExpiryAtRisk -- add new users who meet the 30 days default rule
--	(
--	OrganisationID,
--	UserID,
--	ModuleID,
--	DaysToExpiry
--	)
--	select @OrgID,cam.UserID,
--	cam.ModuleID, 30
--	from #tblCurrentAssignedModules cam
--	inner join #tblStartedModules sm
--	on sm.UserID = cam.UserID
--	and sm.ModuleID = cam.ModuleID
--	where
--	(
--		cam.QuizCompletionDate is null
--		and dbo.udfGetSaltOrgDate(@OrgID) < @QuizExpiryDate
--	)
--	and not exists
--		(SELECT * FROM tblQuizExpiryAtRisk
--		where 	tblQuizExpiryAtRisk.UserID = cam.UserID
--		and tblQuizExpiryAtRisk.ModuleID = cam.ModuleID
--		and tblQuizExpiryAtRisk.OrganisationID = @OrgID)
--	SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES('prcUserQuizStatus_Update_Quick','insert into tblQuizExpiryAtRisk','insert into tblQuizExpiryAtRisk',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),'prcUserQuizStatus_Update_Quick',1,1,null,getutcdate(),getutcdate()) END

--END





delete from tblQuizExpiryAtRisk where OrganisationID = @OrgID   -- delete from ExpiryAtRisk those users who somehow are no longer at risk
and not exists (
--select @OrgID,cam.UserID,
--cam.ModuleID, DateDiff(day,dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID), dateadd(month, cam.QuizFrequency, dbo.udfUTCtoDaylightSavingTime(sm.DateTimeCompleted,@OrgID)))
--from #tblCurrentAssignedModules cam
--inner join #tblStartedModules sm
--on sm.UserID = cam.UserID
--and sm.ModuleID = cam.ModuleID
--where
--(
--	cam.QuizCompletionDate is null
--	and DateDiff(day, dateadd(month, cam.QuizFrequency, dbo.udfUTCtoDaylightSavingTime(sm.DateTimeCompleted,@OrgID)),dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID)) <= @DaysWarningBeforeExpiry
--	and tblQuizExpiryAtRisk.UserID = cam.UserID
--	and tblQuizExpiryAtRisk.ModuleID = cam.ModuleID
--	and tblQuizExpiryAtRisk.OrganisationID = @OrgID
--)
select @OrgID,cam.UserID,
cam.ModuleID,
DateDiff(day,dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID),
dateadd(month, cam.QuizFrequency,
dbo.udfUTCtoDaylightSavingTime(sm.DateTimeCompleted,@OrgID)))
FROM #tblCurrentAssignedModules cam
INNER JOIN #tblStartedModules sm	ON sm.UserID = cam.UserID	AND sm.ModuleID = cam.ModuleID
INNER JOIN tblModule M ON M.moduleID = sm.moduleID
INNER JOIN tblReminderEscalation RemEsc ON  RemEsc.CourseID = M.CourseID
WHERE RemEsc.OrgID = @OrgID AND RemEsc.RemindUsers = 1 AND
(
(
cam.QuizCompletionDate IS NULL
and (dbo.udfUTCtoDaylightSavingTime(	getutcdate(),@OrgID)
>
DateAdd(                -- Expiry date minus days before expiry to warn user
day
,-RemEsc.DaysQuizExpiry
,dateadd( -- Expiry date
month
, cam.QuizFrequency
, dbo.udfUTCtoDaylightSavingTime(sm.DateTimeCompleted,@OrgID)))
)
)
OR

(
cam.QuizCompletionDate IS NOT NULL
and DateDiff(day, dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID), cam.QuizCompletionDate) <= RemEsc.DaysQuizExpiry
)
)
)
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES('prcUserQuizStatus_Update_Quick','delete from tblQuizExpiryAtRisk','delete from tblQuizExpiryAtRisk',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),'prcUserQuizStatus_Update_Quick',1,1,null,getutcdate(),getutcdate()) END



insert into tblQuizExpiryAtRisk -- add users that are now AtRisk that were not already flagged as AtRisk
(
OrganisationID,
UserID,
ModuleID,
DaysToExpiry
)

select @OrgID,cam.UserID,
cam.ModuleID,
CASE WHEN ( cam.QuizFrequency IS NULL )
then DateDiff(day,dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID),
QuizCompletionDate)

ELSE
DateDiff(day,dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID),
dateadd(month, cam.QuizFrequency,
dbo.udfUTCtoDaylightSavingTime(sm.DateTimeCompleted,@OrgID)))
END

FROM #tblCurrentAssignedModules cam
INNER JOIN #tblStartedModules sm	ON sm.UserID = cam.UserID	AND sm.ModuleID = cam.ModuleID
INNER JOIN tblModule M ON M.moduleID = sm.moduleID
INNER JOIN tblReminderEscalation RemEsc ON  RemEsc.CourseID = M.CourseID
WHERE RemEsc.OrgID = @OrgID AND RemEsc.RemindUsers = 1 AND
(
(
cam.QuizCompletionDate IS NULL
and (dbo.udfUTCtoDaylightSavingTime(	getutcdate(),@OrgID)
>
DateAdd(                -- Expiry date minus days before expiry to warn user
day
,-RemEsc.DaysQuizExpiry
,dateadd( -- Expiry date
month
, cam.QuizFrequency
, dbo.udfUTCtoDaylightSavingTime(sm.DateTimeCompleted,@OrgID)))
)
)
OR

(
cam.QuizCompletionDate IS NOT NULL
and DateDiff(day, dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID), cam.QuizCompletionDate) <= RemEsc.DaysQuizExpiry
)
)
and not exists
(SELECT * FROM tblQuizExpiryAtRisk
where 	tblQuizExpiryAtRisk.UserID = cam.UserID
and tblQuizExpiryAtRisk.ModuleID = cam.ModuleID
and tblQuizExpiryAtRisk.OrganisationID = @OrgID)
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES('prcUserQuizStatus_Update_Quick','insert into tblQuizExpiryAtRisk','insert into tblQuizExpiryAtRisk',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),'prcUserQuizStatus_Update_Quick',1,1,null,getutcdate(),getutcdate()) END








drop table  #tblCurrentUserQuizStatus

drop table #tblCurrentAssignedModules

drop table #tblStartedModules
/* /UNITTEST: CourseStatus */


/* UNITTEST: Licensing */
EXEC prcDatabaseMail_SetupProfile -- incase email address etc has changed, re-setup.

-- Check who is missing license for current period, includes period turn over
declare @lic_CourseLicensingID int, @lic_UserID int
DECLARE LicensingLoop CURSOR
FOR
SELECT DISTINCT tblCourseLicensing.CourseLicensingID, vwUserModuleAccess.UserID
FROM tblCourseLicensing
INNER JOIN vwUserModuleAccess ON tblCourseLicensing.CourseID = vwUserModuleAccess.CourseID
AND tblCourseLicensing.OrganisationID = vwUserModuleAccess.OrganisationID
INNER JOIN tblUser ON vwUserModuleAccess.UserID = tblUser.UserID
LEFT OUTER JOIN	tblCourseLicensingUser ON tblCourseLicensing.CourseLicensingID = tblCourseLicensingUser.CourseLicensingID
WHERE tblCourseLicensing.DateStart <= GETUTCDATE()
AND tblCourseLicensing.DateEnd >= GETUTCDATE()
AND tblCourseLicensingUser.CourseLicensingID IS NULL
AND tblUser.Active = 1
AND vwUserModuleAccess.OrganisationID = @OrgID
Open LicensingLoop
FETCH NEXT FROM LicensingLoop
Into
@lic_CourseLicensingID, @lic_UserID
WHILE @@FETCH_STATUS = 0
BEGIN
IF NOT EXISTS(SELECT CourseLicensingID FROM tblCourseLicensingUser WHERE CourseLicensingID = @lic_CourseLicensingID and UserID = @lic_UserID)
BEGIN
INSERT INTO tblCourseLicensingUser(CourseLicensingID, UserID) VALUES (@lic_CourseLicensingID, @lic_UserID)
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES('prcUserQuizStatus_Update_Quick','INSERT INTO tblCourseLicensingUser','INSERT INTO tblCourseLicensingUser',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),'prcUserQuizStatus_Update_Quick',1,1,null,getutcdate(),getutcdate()) END
END
FETCH NEXT FROM LicensingLoop
Into
@lic_CourseLicensingID, @lic_UserID
END

CLOSE LicensingLoop
DEALLOCATE LicensingLoop



-- WARNING EMAILS
-- License Warning
declare @licenseWarnEmail nvarchar(4000)
declare @licenseWarnEmail_Subject nvarchar(4000)
declare @emailLicenseWarnLicRecipients nvarchar(512)
declare @warn_lic_CourseName nvarchar(200),
@warn_lic_CourseLicensingID int,
@warn_lic_LicenseNumber int,
@warn_lic_LicenseWarnNumber int,
@warn_lic_RepNameSalt nvarchar(200),
@warn_lic_RepEmailSalt nvarchar(200),
@warn_lic_RepNameOrg nvarchar(200),
@warn_lic_RepEmailOrg nvarchar(200),
@warn_lic_LangCode nvarchar(10),
@warn_lic_LicensesUsed int,
@warn_lic_LicenseWarnEmail bit,
@warn_lic_OrganisationName nvarchar(50)

DECLARE LicenceNumberLoop CURSOR
FOR
SELECT
c.Name, l.CourseLicensingID, l.LicenseNumber, l.LicenseWarnNumber, l.RepNameSalt, l.RepEmailSalt,
l.RepNameOrg, l.RepEmailOrg, l.LangCode, COUNT(u.CourseLicensingUserID) AS LicensesUsed,
l.LicenseWarnEmail, OrganisationName
FROM
tblCourseLicensing l
INNER JOIN tblCourseLicensingUser u ON l.CourseLicensingID = u.CourseLicensingID
INNER JOIN tblCourse c ON l.CourseID = c.CourseID
LEFT JOIN tblOrganisation o ON l.OrganisationID = o.OrganisationID
WHERE
l.OrganisationID = @OrgID
GROUP BY
OrganisationName, l.CourseLicensingID, l.RepNameSalt, l.RepEmailSalt, l.RepNameOrg, l.RepEmailOrg, c.Name, l.LicenseNumber,
l.LicenseWarnNumber, l.LicenseWarnEmail, l.LangCode
HAVING
COUNT(u.CourseLicensingUserID) >= l.LicenseWarnNumber
AND l.LicenseWarnEmail = 1

Open LicenceNumberLoop
FETCH NEXT FROM LicenceNumberLoop
Into @warn_lic_CourseName,
@warn_lic_CourseLicensingID,
@warn_lic_LicenseNumber,
@warn_lic_LicenseWarnNumber,
@warn_lic_RepNameSalt,
@warn_lic_RepEmailSalt,
@warn_lic_RepNameOrg,
@warn_lic_RepEmailOrg,
@warn_lic_LangCode,
@warn_lic_LicensesUsed,
@warn_lic_LicenseWarnEmail,
@warn_lic_OrganisationName

WHILE @@FETCH_STATUS = 0
BEGIN
-- Get License Warning text in desired language.
SELECT     @licenseWarnEmail = tblLangValue.LangEntryValue
FROM         tblLang INNER JOIN
tblLangValue ON tblLang.LangID = tblLangValue.LangID INNER JOIN
tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID INNER JOIN
tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID
WHERE     (tblLang.LangCode = @warn_lic_LangCode) AND (tblLangInterface.LangInterfaceName = '/ContentAdministration/Licensing/Default.aspx') AND
(tblLangResource.LangResourceName = 'Email_LicenseWarn') AND (tblLangValue.Active = 1)

SELECT     @licenseWarnEmail_Subject = tblLangValue.LangEntryValue
FROM         tblLang INNER JOIN
tblLangValue ON tblLang.LangID = tblLangValue.LangID INNER JOIN
tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID INNER JOIN
tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID
WHERE     (tblLang.LangCode = @warn_lic_LangCode) AND (tblLangInterface.LangInterfaceName = '/ContentAdministration/Licensing/Default.aspx') AND
(tblLangResource.LangResourceName = 'Email_LicenseWarn_Subject') AND (tblLangValue.Active = 1)

-- {0} is receipient name, {1} is the license warning amount, {2} course name, {3} license limit, {4} name of contact person
-- {5} is organisation name
set @licenseWarnEmail = REPLACE(@licenseWarnEmail, '{0}', @warn_lic_RepNameOrg)
set @licenseWarnEmail = REPLACE(@licenseWarnEmail, '{1}', @warn_lic_LicenseWarnNumber)
set @licenseWarnEmail = REPLACE(@licenseWarnEmail, '{2}', @warn_lic_CourseName)
set @licenseWarnEmail = REPLACE(@licenseWarnEmail, '{3}', @warn_lic_LicenseNumber)
set @licenseWarnEmail = REPLACE(@licenseWarnEmail, '{4}', @warn_lic_RepNameSalt)
set @licenseWarnEmail = REPLACE(@licenseWarnEmail, '{5}', @warn_lic_OrganisationName)

set @licenseWarnEmail_Subject = REPLACE(@licenseWarnEmail_Subject, '{0}', @warn_lic_CourseName)
set @licenseWarnEmail_Subject = REPLACE(@licenseWarnEmail_Subject, '{1}', @warn_lic_OrganisationName)

select @emailLicenseWarnLicRecipients = @warn_lic_RepEmailOrg +';'+@warn_lic_RepEmailSalt

EXEC msdb.dbo.sp_send_dbmail
@recipients = @emailLicenseWarnLicRecipients,
@body = @licenseWarnEmail,
@subject = @licenseWarnEmail_Subject,
@profile_name = 'Salt_MailAccount'

 --Log emails sent
exec prcEMail_LogSentEmail @toEmail = @warn_lic_RepEmailOrg, @toName = null, @fromEmail = 'support@blakedawson.com', @fromName = 'Blake Dawson', @subject = @licenseWarnEmail_Subject, @body = @licenseWarnEmail, @organisationID = @OrgID
exec prcEMail_LogSentEmail @toEmail = @warn_lic_RepEmailSalt, @toName = null, @fromEmail = 'support@blakedawson.com', @fromName = 'Blake Dawson', @subject = @licenseWarnEmail_Subject, @body = @licenseWarnEmail, @organisationID = @OrgID

print 'queued numLics warning mail to : ' + @emailLicenseWarnLicRecipients

-- Unset flag and record date email sent
UPDATE tblCourseLicensing SET DateLicenseWarnEmailSent = getutcdate(), LicenseWarnEmail = 0 WHERE CourseLicensingID = @warn_lic_CourseLicensingID
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES('prcUserQuizStatus_Update_Quick','UPDATE tblCourseLicensing','UPDATE tblCourseLicensing',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),'prcUserQuizStatus_Update_Quick',1,1,null,getutcdate(),getutcdate()) END

FETCH NEXT FROM LicenceNumberLoop
Into @warn_lic_CourseName,
@warn_lic_CourseLicensingID,
@warn_lic_LicenseNumber,
@warn_lic_LicenseWarnNumber,
@warn_lic_RepNameSalt,
@warn_lic_RepEmailSalt,
@warn_lic_RepNameOrg,
@warn_lic_RepEmailOrg,
@warn_lic_LangCode,
@warn_lic_LicensesUsed,
@warn_lic_LicenseWarnEmail,
@warn_lic_OrganisationName
END

CLOSE LicenceNumberLoop
DEALLOCATE LicenceNumberLoop
-- /License Warning


-- Expiry Warning
declare @expiryWarnEmail nvarchar(4000)
declare @expiryWarnEmail_Subject nvarchar(4000)
declare @emailLicenseWarnExpRecipients nvarchar(512)
DECLARE @warn_exp_CourseLicensingID int,
@warn_exp_CourseName nvarchar(200),
@warn_exp_DateWarn datetime,
@warn_exp_ExpiryWarnEmail bit,
@warn_exp_DateEnd datetime,
@warn_exp_RepNameSalt nvarchar(200),
@warn_exp_RepEmailSalt nvarchar(200),
@warn_exp_RepNameOrg nvarchar(200),
@warn_exp_RepEmailOrg nvarchar(200),
@warn_exp_LangCode nvarchar(10),
@warn_exp_OrganisationName nvarchar(50)

DECLARE LicenceExpiryLoop CURSOR
FOR
SELECT
l.CourseLicensingID, c.Name, l.DateWarn, l.ExpiryWarnEmail, l.DateEnd, l.RepNameSalt,
l.RepEmailSalt, l.RepNameOrg, l.RepEmailOrg, l.LangCode, OrganisationName
FROM
tblCourseLicensing l
INNER JOIN tblCourse c ON l.CourseID = c.CourseID
LEFT JOIN tblOrganisation o ON l.OrganisationID = o.OrganisationID
WHERE
l.DateWarn < GETUTCDATE()
AND l.ExpiryWarnEmail = 1
AND l.OrganisationID = @OrgID

Open LicenceExpiryLoop
FETCH NEXT FROM LicenceExpiryLoop
Into @warn_exp_CourseLicensingID,
@warn_exp_CourseName,
@warn_exp_DateWarn,
@warn_exp_ExpiryWarnEmail,
@warn_exp_DateEnd,
@warn_exp_RepNameSalt,
@warn_exp_RepEmailSalt,
@warn_exp_RepNameOrg,
@warn_exp_RepEmailOrg,
@warn_exp_LangCode,
@warn_exp_OrganisationName

WHILE @@FETCH_STATUS = 0
BEGIN
-- Get Expiry Warning text in desired language.
SELECT     @expiryWarnEmail = tblLangValue.LangEntryValue
FROM         tblLang INNER JOIN
tblLangValue ON tblLang.LangID = tblLangValue.LangID INNER JOIN
tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID INNER JOIN
tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID
WHERE     (tblLang.LangCode = @warn_exp_LangCode) AND (tblLangInterface.LangInterfaceName = '/ContentAdministration/Licensing/Default.aspx') AND
(tblLangResource.LangResourceName = 'Email_ExpiryWarn') AND (tblLangValue.Active = 1)

SELECT     @expiryWarnEmail_Subject = tblLangValue.LangEntryValue
FROM         tblLang INNER JOIN
tblLangValue ON tblLang.LangID = tblLangValue.LangID INNER JOIN
tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID INNER JOIN
tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID
WHERE     (tblLang.LangCode = @warn_exp_LangCode) AND (tblLangInterface.LangInterfaceName = '/ContentAdministration/Licensing/Default.aspx') AND
(tblLangResource.LangResourceName = 'Email_ExpiryWarn_Subject') AND (tblLangValue.Active = 1)

-- {0} Receipient Name, {1} number days till expiry, {2} course name, {3} expiry date, {4} Salt rep name
-- {5} Organisation Name
set @expiryWarnEmail = REPLACE(@expiryWarnEmail, '{0}', @warn_exp_RepNameOrg)
set @expiryWarnEmail = REPLACE(@expiryWarnEmail, '{1}', DATEDIFF(dd,dbo.udfUTCtoDaylightSavingTime(getUTCdate(),@OrgID),dbo.udfUTCtoDaylightSavingTime(@warn_exp_DateEnd,@OrgID)))
set @expiryWarnEmail = REPLACE(@expiryWarnEmail, '{2}', @warn_exp_CourseName)
set @expiryWarnEmail = REPLACE(@expiryWarnEmail, '{3}', CONVERT(CHAR(10), dbo.udfUTCtoDaylightSavingTime(@warn_exp_DateEnd,@OrgID), 103))
set @expiryWarnEmail = REPLACE(@expiryWarnEmail, '{4}', @warn_exp_RepNameSalt)
set @expiryWarnEmail = REPLACE(@expiryWarnEmail, '{5}', @warn_exp_OrganisationName)

set @expiryWarnEmail_Subject = REPLACE(@expiryWarnEmail_Subject, '{0}', @warn_exp_CourseName)
set @expiryWarnEmail_Subject = REPLACE(@expiryWarnEmail_Subject, '{1}', @warn_exp_OrganisationName)

select @emailLicenseWarnExpRecipients = @warn_exp_RepEmailOrg +';'+@warn_exp_RepEmailSalt

EXEC msdb.dbo.sp_send_dbmail
@recipients = @emailLicenseWarnExpRecipients,
@body = @expiryWarnEmail,
@subject = @expiryWarnEmail_Subject,
@profile_name = 'Salt_MailAccount'

 --Log emails sent
exec prcEMail_LogSentEmail @toEmail = @warn_exp_RepEmailOrg, @toName = null, @fromEmail = 'support@blakedawson.com', @fromName = 'Blake Dawson', @subject = @expiryWarnEmail_Subject, @body = @expiryWarnEmail, @organisationID = @OrgID
exec prcEMail_LogSentEmail @toEmail = @warn_exp_RepEmailSalt, @toName = null, @fromEmail = 'support@blakedawson.com', @fromName = 'Blake Dawson', @subject = @expiryWarnEmail_Subject, @body = @expiryWarnEmail, @organisationID = @OrgID

print 'queued expiry mail to : ' + @emailLicenseWarnExpRecipients
-- Unset flag and record date email sent
UPDATE tblCourseLicensing SET DateExpiryWarnEmailSent = getutcdate(), ExpiryWarnEmail = 0 WHERE CourseLicensingID = @warn_exp_CourseLicensingID
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES('prcUserQuizStatus_Update_Quick','UPDATE tblCourseLicensing','UPDATE tblCourseLicensing',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),'prcUserQuizStatus_Update_Quick',1,1,null,getutcdate(),getutcdate()) END


FETCH NEXT FROM LicenceExpiryLoop
Into @warn_exp_CourseLicensingID,
@warn_exp_CourseName,
@warn_exp_DateWarn,
@warn_exp_ExpiryWarnEmail,
@warn_exp_DateEnd,
@warn_exp_RepNameSalt,
@warn_exp_RepEmailSalt,
@warn_exp_RepNameOrg,
@warn_exp_RepEmailOrg,
@warn_exp_LangCode,
@warn_exp_OrganisationName
END

CLOSE LicenceExpiryLoop
DEALLOCATE LicenceExpiryLoop
-- /Expiry Warning
/* /UNITTEST: Licensing */


/* UNITTEST: ModuleNightly */
-- START Course status reconcile. If a module has been made active or inactive to run through all user and ensure that their course status is correct.
-- AS PER BUSINESS requirement
-- Get all changed modules
declare @c_CourseID int, @c_ModuleID int
DECLARE UpdatedModuleLOOP CURSOR
FOR
SELECT CourseID, ModuleID FROM tblModule WHERE(DateUpdated > GETUTCDATE() - 2)
Open UpdatedModuleLOOP

FETCH NEXT FROM UpdatedModuleLOOP
Into
@c_CourseID, @c_ModuleID

WHILE @@FETCH_STATUS = 0
BEGIN
-- Get all users related to this module
declare @c_UserID int
DECLARE UserLOOP CURSOR
FOR
SELECT UserID FROM tblUserModuleAccess WHERE ModuleID = @c_ModuleID
Open UserLOOP


FETCH NEXT FROM UserLOOP
Into
@c_UserID

WHILE @@FETCH_STATUS = 0
BEGIN
EXEC prcUserQuizStatus_UpdateCourseStatus @c_UserID, @c_ModuleID
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES('prcUserQuizStatus_Update_Quick','prcUserQuizStatus_UpdateCourseStatus','prcUserQuizStatus_UpdateCourseStatus',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),'prcUserQuizStatus_Update_Quick',1,1,null,getutcdate(),getutcdate()) END

FETCH NEXT FROM UserLOOP
Into
@c_UserID
END

CLOSE UserLOOP
DEALLOCATE UserLOOP

FETCH NEXT FROM UpdatedModuleLOOP
Into
@c_CourseID, @c_ModuleID
END

CLOSE UpdatedModuleLOOP
DEALLOCATE UpdatedModuleLOOP
/* /UNITTEST: ModuleNightly */




/* UNITTEST: ExtendComplianceDate */
update tblOrganisation
set DefaultQuizCompletionDate = dateadd(year, 1, [DefaultQuizCompletionDate])
where DefaultQuizCompletionDate < getutcdate() and OrganisationID = @OrgID

update tblUnitRule
set QuizCompletionDate = dateadd(year, 1, [QuizCompletionDate])
where QuizCompletionDate < getutcdate() and UnitID IN (select UnitID from tblUnit where OrganisationID = @OrgID)
/* /UNITTEST: ExtendComplianceDate */


-- END Course status reconcile.


update tblOrganisation set CourseStatusLastUpdated = dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID) where OrganisationID = @OrgID

update tblModuleStatusUpdateHistory
set FinishTime = getutcdate()
where ModuleStatusUpdateHistoryID = @intHistoryID

GO


/*Summary:
Update record in tblQuizSession
Insert record into tblUserQuizStatus
Insert record into tblUserCourseStatus

Returns:
data table

Called By:
ToolBook.cs: UpdateEndQuizInfo

Author: Li Zhang
Date Created: 13-10-2006
Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	mikev		1/5/2007		Added QuizCompletionDate
**/

ALTER PROCEDURE [dbo].[prcQuizSession_UpdateEndQuizInfo]
(
@QuizSessionID	varchar(50) -- unique GUID that identifies this toolbook quiz session
, @Duration	int -- the duration in seconds of the quiz as mesured by toolbook
, @Score 	int -- the score as mesured by toolbook
, @UserID	int	-- user id
, @QuizID	int -- quiz id
, @PassMark	int	-- quiz pass mark
, @UnitID	int	-- user's unit id
, @ModuleID	int -- quiz module id
, @CourseID	int -- module course id
, @OldCourseStatus	int -- course status before update
, @NewQuizStatus int -- the quiz status
, @NewCourseStatus	int	-- course status after update
, @QuizFrequency	int -- quiz frequency
, @QuizCompletionDate	datetime -- quiz completiondate
)
AS
SET nocount on
SET xact_abort on
BEGIN TRANSACTION

declare @OrgID int
select @OrgID = organisationID from tblUnit where tblUnit.UnitID=@UnitID

set @QuizCompletionDate = dbo.udfDaylightSavingTimeToUTC(@QuizCompletionDate, @OrgID)

DECLARE @dateCreated datetime
SET @dateCreated = GETUTCDATE()

IF EXISTS
(
SELECT QuizSessionID
FROM tblQuizSession
WHERE QuizSessionID = @QuizSessionID
AND	DateTimeStarted IS NOT NULL
AND DateTimeCompleted IS NULL
)
BEGIN
-- < update tblQuizSession >--
UPDATE tblQuizSession
SET DateTimeCompleted = @dateCreated
, Duration = @Duration
, QuizScore = @Score
, QuizPassMark = @PassMark
WHERE
QuizSessionID = @QuizSessionID

--< insert into tblUserQuizStatus >--
INSERT INTO
tblUserQuizStatus
(
UserID,
ModuleID,
QuizStatusID,
QuizFrequency,
QuizPassMark,
QuizCompletionDate,
QuizScore,
QuizSessionID,
DateCreated
)
VALUES
(
@UserID,
@ModuleID,
@NewQuizStatus,
@QuizFrequency,
@PassMark,
@QuizCompletionDate,
@Score,
@QuizSessionID,
@dateCreated
)

--< insert into tblUserCourseStatus >--

-- if the user redo the quiz when they are still having a completed user course status
-- check if the last 2 course status is a completed status
-- if it is then we update the date of the last course status id to avoid new rows being inserted
-- if not we just add a new row
IF (@OldCourseStatus=2 and @OldCourseStatus = @NewCourseStatus)
BEGIN
declare @total int, @usercoursestatusid int

-- check if the last 2 courses is completed
select *
into #tblUserCompleted
from tblUserCourseStatus
where
UserCourseStatusID in
(
	-- we get the last 2 course status here
	select top 2 usercoursestatusid from tblUserCourseStatus
	where UserID=@userid and CourseID=@CourseID
	order by DateCreated desc
)
and CourseStatusID=2

select @total = COUNT(*) from #tblUserCompleted

-- if the last 2 course status is complete then we update the date of the last course status
if(@total = 2)
begin

select @usercoursestatusid = max(usercoursestatusid) from #tblUserCompleted
update tblUserCourseStatus set DateCreated=GETUTCDATE() where UserCourseStatusID=@usercoursestatusid

end
else
begin

EXEC prcUserCourseStatus_Insert @UserID, @ModuleID, @NewCourseStatus

end

drop table #tblUserCompleted

END
ELSE
IF (@OldCourseStatus = -1) or (@OldCourseStatus <> @NewCourseStatus)
BEGIN
EXEC prcUserCourseStatus_Insert @UserID, @ModuleID, @NewCourseStatus
END
ELSE
BEGIN
IF NOT EXISTS (SELECT UserID FROM vwUserModuleAccess where UserID = @UserID AND CourseID = @CourseID) AND
EXISTS (SELECT UserCourseStatusID FROM tblUserCourseStatus WHERE UserID = @UserID AND CourseID = @CourseID AND CourseStatusID <> 0)
BEGIN
EXEC prcUserCourseStatus_Insert @UserID, @ModuleID, @NewCourseStatus = 0
END
END

END

GO



-- code from bd is above here....

IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tblQuiz' 
		AND  COLUMN_NAME = 'Scorm1_2')
BEGIN
ALTER TABLE dbo.tblLesson ADD
	Scorm1_2 bit NOT NULL CONSTRAINT DF_tblLesson_Scorm1_2 DEFAULT 0,
	QFSlocation [varchar](100) NULL
end 
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcLessonSession_BeforeStartLesson]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [prcLessonSession_BeforeStartLesson]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcLessonSession_BeforeStartLesson]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


/*Summary:
Given a UserID and LessonID starts a Lesson and returns a LessonSessionID
Returns:
LessonSessionID guid

Called By:
Businessservices.Toolbook.BeforeLessonStart
Calls:

Remarks:
starts a lesson and returns the details of the lesson so that it can be opened by salt
Author:
Stephen Kennedy-Clark
Date Created: 2 Feb 2004


Modification History
-----------------------------------------------------------
v# Author  Date   Description
#1 Peter Kneale Update to return active lesson location not first lesson location found.
? pending change added module id to where clause in select
#2 Removed unnecessary transactions

prcLessonSession_StartLesson @UserID=11, @LessonID=3
prcLessonSession_BeforeStartLesson @userID = 11, @moduleID = 3
select * from tblLessonSession
-- truncate tblLessonSession
**/

CREATE       Proc [prcLessonSession_BeforeStartLesson]
(
@userID int,  -- Users ID
@moduleID int  -- the Lesson ID
)

As
Set NoCount On
Set Xact_Abort On




------------------------------------------
-- Declerations
------------------------------------------
declare @strLessonSessionID varchar(50)
, @intLessonID int
set @strLessonSessionID = newid()
set @intLessonID = (select top 1 LessonID from tblLesson where ModuleID = @moduleID and Active=1)

------------------------------------------
-- Insert
------------------------------------------


Insert Into
tblLessonSession
(
[LessonSessionID],
[UserID],
[LessonID]
)
Values
(
@strLessonSessionID,
@userID,
@intLessonID
)


-- For Debug purposes --
/*insert into tblDebugLessonSession
(lessonsession_id, date_created, return_value)
values
(@strLessonSessionID, GETDATE(), null)*/
-- End of Debug --

------------------------------------------
-- select Session Details: SessionID, ModuleName,
------------------------------------------

Select
tM.[Name]   As ''ModuleName''
, tC.[Name]   As ''CourseName''
, @strLessonSessionID  As ''SessionID''
, tL.ToolbookLocation  As ''Location''
,Scorm1_2
From
tblModule tM
Inner Join tblLesson tL
On tL.ModuleID = tM.ModuleID
Inner Join tblCourse tC
On tC.CourseID = tM.CourseID
where
tM.ModuleID = @moduleID
And
tL.Active = 1




' 
END
GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[tblScormDME]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [tblScormDME]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[tblScormDME]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [tblScormDME](
	[UserID] [int] NOT NULL,
	[LessonID] [int] NOT NULL,
	[DME] [varchar](50) NOT NULL,
	[value] [varchar](4000) NOT NULL
) ON [PRIMARY]
END
GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcSCORMdeleteDME]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [prcSCORMdeleteDME]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcSCORMdeleteDME]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create proc [prcSCORMdeleteDME](@StudentID int,@LessonID int)
as begin

	delete from tblScormDME where UserID =@StudentID and LessonID = @LessonID

End
' 
END
GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcSCORMgetValue]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [prcSCORMgetValue]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcSCORMgetValue]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcSCORMgetValue] (
             @StudentID int,
             @LessonID int,
             @DME  varchar(50)
           )  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT [value] FROM  tblScormDME
           WHERE UserID = @StudentID
           and LessonID = @LessonID
           and DME = @DME

END

' 
END
GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcSCORMsetValue]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [prcSCORMsetValue]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcSCORMsetValue]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcSCORMsetValue] (
             @StudentID int,
             @LessonID int,
             @DME  varchar(50),
             @value  varchar(4000)
           )  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    DELETE FROM tblScormDME where UserID = @StudentID and LessonID = @LessonID and DME = @DME
	INSERT INTO tblScormDME
           (UserID
           ,LessonID
           ,DME
           ,[value])
     VALUES (
           @StudentID,
           @LessonID, 
           @DME, 
           @value)
END

' 
END
GO




if not exists (select * from tblLangResource where LangResourceName = N'lblWhichSCO') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'lblWhichSCO', 'label', '', 1, null, null, getdate(), null, null, newid()) 

If not exists (select * from tblLangValue where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/ContentAdministration/InfoPath/PublishInfoPathContent.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'lblWhichSCO')) begin insert into tblLangValue (LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)  select 2, (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/ContentAdministration/InfoPath/PublishInfoPathContent.aspx'),  (select LangResourceID from tblLangResource where LangResourceName = 'lblWhichSCO'), N'Select a module to upload', 1, 1, getdate(), newid()end 


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcSCORMimport]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [prcSCORMimport]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcSCORMimport]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcSCORMimport]
@intModuleID integer,
@strToolLocation varchar(100),
@strQFSLocation varchar(100),
@DatePublished datetime,
@intUserID integer
AS
BEGIN
--Set @intLessonID 	= dbo.udfGetLessonIDByToolbookIDAndModuleID (@strToolbookID,@intModuleID)


Declare @LWorkSiteID nvarchar(50)
Declare @QFWorkSiteID nvarchar(50)
Declare @intLessonID integer

Select @LWorkSiteID = LWorkSiteID, @QFWorkSiteID = QFWorkSiteID From tblLesson Where LessonID = @intLessonID

---- Deactivate the existing lesson if it exists
Begin
Update
tblLesson
Set
Active = 0
Where
ModuleID = @intModuleID
End


-- Create the new lesson
Insert Into tblLesson
(
ModuleID,
ToolbookID,
ToolbookLocation,
QFSlocation,
DatePublished,
LoadedBy,
DateLoaded,
Active,
LWorkSiteID,
QFWorkSiteID,
Scorm1_2
)
-- With the values from the old lesson
VALUES
(
@intModuleID,
''SCOnew'',
@strToolLocation,
@strQFSLocation,
@DatePublished,
@intUserID,		-- Loaded By
GETDATE(),		-- Date Loaded
1,				-- Active
@LWorkSiteID,
@QFWorkSiteID,
1
)
-- Get the new lesson id
SELECT 	@intLessonID =  LessonID FROM tblLesson where Active = 1 AND ModuleID = @intModuleID

UPDATE tblLesson set ToolbookID = ''SCO'' + CAST(LessonID as varchar(9)) WHERE LessonID = @intLessonID

-- Insert the new lesson pages
Insert Into tblLessonPage
(
LessonID,
ToolbookPageID,
Title
)

Select
@intLessonID,
''SCORM 1.2 lesson'',
''IFRAME 1.2''

DELETE FROM tblScormDME where lessonID = @intModuleID

SELECT @intLessonID
END
' 
END
GO





if not exists (select * from tblAppConfig where Name ='SCORM_Debug') begin
	insert into tblAppConfig (Name, Value) values('SCORM_Debug','false')
end


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[udfReport_IndividualDetailsExtended]') AND xtype in (N'FN', N'IF', N'TF'))
BEGIN
execute dbo.sp_executesql @statement = N'
/****** Object:  User Defined Function dbo.udfReport_IndividualDetails    Script Date: 20/04/2004 8:25:58 AM ******/



/*Summary:
Given a users ID this udfReport_IndividualDetails Gets Details for home page and individual report
Returns:
ordered table of distinct PageID''s

Called By:
dbo.prcModule_GetDetailsForHomePage
Calls:

dbo.udfGetLessonStatus
dbo.vwUserModuleAccess
Remarks:
1. This udf required that the schema of the underlying views does not change

Author:
Stephen Kennedy-Clark
Date Created: 17 Feb 2004

Modification History
-----------------------------------------------------------
v#           Author                  Date                                     Description
#3.0.25 Aaron Cripps        08/05/2007                        Replace vwUserCourseStatus with a select statement that filters on UserID parameter passed into the function to reduce the number of rows returned (and the time taken to retrieve rows)


--------------------


**/
ALTER function [udfReport_IndividualDetailsExtended]
(
@userID  int = null,     -- ID of this User
@CurrentCultureName NVarChar(40) = ''en-AU''
)
------------------------------------------
Returns table
as
               




Return
select
vUMA.UserID                      as ''UserID''
, vUMA.CourseID                as ''CourseID''
, vUMA.CourseName         as ''CourseName''
, vUMA.ModuleID                             as ''ModuleID''
, vUMA.[Name]                  as ''ModuleName''
, tL.LessonID                        as ''LessonID''
, isNull(dbo.udfGetLessonStatus(vUMA.ModuleID,vUMA.UserID), 1) as ''LessonStatus''  -- n^2 complexety :-(
, isNull(vUQS.QuizStatusID, 1)   as ''QuizStatus''
, vUQS.QuizScore               as ''QuizScore''
, vUQS.QuizPassMark        as ''QuizPassMark''
--, replace(replace( tL.ToolbookLocation,''ie4/index.html'',''qfs.html''),''default.aspx'',''QFS.html'') as ''QFSPath''
, CASE WHEN (tL.Scorm1_2=1) THEN QFSlocation
ELSE replace(replace( tL.ToolbookLocation,''ie4/index.html'',''qfs.html''),''default.aspx'',''QFS.html'') END as ''QFSPath''

--, SUBSTRING(  tL.ToolbookLocation,0,(len(tL.ToolbookLocation)-12)  ) + ''/'' + ''QFS.html'' as ''QFSPath''
, vUMA.Sequence                              as ''Sequence''


,case when vUQS.DateCreated is null and (RemEsc.DaysToCompleteCourse is null OR ((RemEsc.NotifyMgr = 0) AND (RemEsc.RemindUsers = 0))) then '' --- ''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        -- course just added , overdue not defined
when vUQS.DateCreated is null and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and CS.DateCreated is null then CAST(RemEsc.DaysToCompleteCourse AS VARCHAR(5)        )                                                                                                                                                                                                                                               -- course just added , overnight job has not caught up yet
when QuizStatusID = 1 and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and vUQS.DateCreated is not null              AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate())) >= 0
                                                                                                         then CAST(RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate()) AS VARCHAR(5))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- not started , overdue is defined, not overdue
                                                                                                         + (SELECT  '' ''+LangEntryValue  FROM tblLangValue
                                                                                                                        where LangInterfaceID = (SELECT  LangInterfaceID   FROM tblLangInterface WHERE LangInterfaceName = ''GLOBAL.MISC'')
                                                                                                                        and LangID =(SELECT LangID FROM tblLang where tblLang.LangCode=  @CurrentCultureName)
                                                                                                                        and LangResourceID = (SELECT LangResourceID  FROM tblLangResource where   LangResourceName = ''days'' ))  
when QuizStatusID = 1 and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1))  and vUQS.DateCreated is not null             AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate())) < 0
                                                                                                                                                                                                                                                               then convert(varchar (11),DATEADD(day,RemEsc.DaysToCompleteCourse,dbo.udfUTCtoDaylightSavingTime(vUQS.DateCreated,o.organisationID)),113)                                                                                                         -- not started , overdue is defined, overdue
when QuizStatusID = 4 and vUQS.DateCreated is not null       
                                                                                                                                                                                                                                                               then convert(varchar (11),dbo.udfUTCtoDaylightSavingTime(vUQS.DateCreated,o.organisationID),113)                                                                                                                                                                                                                                                                                                                                                                                                                 -- Expired (Time Elapsed )
when QuizStatusID = 5 and vUQS.DateCreated is not null       
                                                                                                                                                                                                                                                               then convert(varchar (11),dbo.udfUTCtoDaylightSavingTime(vUQS.DateCreated,o.organisationID),113)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          -- Expired (New Content)
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is  null   and o.DefaultQuizCompletionDate is not null 
                                                                                                                                                                                                                                                               then convert(varchar (11),dbo.udfUserUTCtoDaylightSavingTime(o.DefaultQuizCompletionDate,o.organisationID),113)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 --Passed  organisation Default  Quiz Completion Date specified
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is not null 
                                                                                                                                                                                                                                                               then convert(varchar (11),dbo.udfUserUTCtoDaylightSavingTime(ur.QuizCompletionDate,o.organisationID),113)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          --Passed  unit Default  Quiz Completion Date specified
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizFrequency is not null 
                                                                                                                                                                                                                                                               then CAST((  DATEDIFF(day,getUTCdate(),DATEADD(month,o.DefaultQuizFrequency,vUQS.DateCreated))) AS varchar(6))                                                                                                                                                                                                                                                                                                                                                                                                                                   --Passed  organisation Default  Quiz frequency specified
                                                                                                                                                                                                                                                               + (SELECT  '' ''+ LangEntryValue  FROM tblLangValue
                                                                                                                                                                                                                                                                              where LangInterfaceID = (SELECT  LangInterfaceID   FROM tblLangInterface WHERE LangInterfaceName = ''GLOBAL.MISC'')
                                                                                                                                                                                                                                                                              and LangID =(SELECT LangID FROM tblLang where tblLang.LangCode=  @CurrentCultureName)
                                                                                                                                                                                                                                                                              and LangResourceID = (SELECT LangResourceID  FROM tblLangResource where   LangResourceName = ''days'' ))
                                                                                                                                                                                                                                                               
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is not null and o.DefaultQuizCompletionDate is null 
                                                                                                                                                                                                                                                               then CAST((  DATEDIFF(day,getUTCdate(),DATEADD(month,ur.QuizFrequency,vUQS.DateCreated))) AS varchar(6))                                                                                                                                                                                                                                                                                                                                                                                                                                                           --Passed - unit Default  Quiz frequency specified
                                                                                                                                                                                                                                                   + (SELECT  '' ''+LangEntryValue  FROM tblLangValue
                                                                                                                                                                                                                                                               where LangInterfaceID = (SELECT  LangInterfaceID   FROM tblLangInterface WHERE LangInterfaceName = ''GLOBAL.MISC'')
                                                                                                                                                                                                                                                               and LangID =(SELECT LangID FROM tblLang where tblLang.LangCode=  @CurrentCultureName)
                                                                                                                                                                                                                                                               and LangResourceID = (SELECT LangResourceID  FROM tblLangResource where   LangResourceName = ''days'' ))
                                                                                                                                                                                                                                                               
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizCompletionDate is not null 
                                                                                                                                                                                                                                                               then convert(varchar (11),dbo.udfUserUTCtoDaylightSavingTime(o.DefaultQuizCompletionDate,o.organisationID),113)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 --Failed - previously passed - organisation Default  Quiz Completion Date specified
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is not null 
                                                                                                                                                                                                                                                               then convert(varchar (11),dbo.udfUserUTCtoDaylightSavingTime(ur.QuizCompletionDate,o.organisationID),113)                                                                                                                                                                                                                                                                                                                                                   --Failed - previously passed - unit Default  Quiz Completion Date specified
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizFrequency is not null 
                                                                                                                                                                                                                                                               then CAST(( DATEDIFF(day,getUTCdate(),DATEADD(month,o.DefaultQuizFrequency,vUQS.DateCreated))) AS varchar(6))                                                                                                                                                                                                                                                                                                                                                                                                                                    --Failed - previously passed -organisation Default  Quiz frequency specified
                                                                                                                                                                                                                                                               + (SELECT  '' ''+LangEntryValue  FROM tblLangValue
                                                                                                                                                                                                                                                                              where LangInterfaceID = (SELECT  LangInterfaceID   FROM tblLangInterface WHERE LangInterfaceName = ''GLOBAL.MISC'')
                                                                                                                                                                                                                                                                              and LangID =(SELECT LangID FROM tblLang where tblLang.LangCode=  @CurrentCultureName)
                                                                                                                                                                                                                                                                              and LangResourceID = (SELECT LangResourceID  FROM tblLangResource where   LangResourceName = ''days'' ))
                                                                                                                                                                                                                                                               
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is not null 
                                                                                                                                                                                                                                                               then CAST((  DATEDIFF(day,getUTCdate(),DATEADD(month,ur.quizfrequency,vUQS.DateCreated))) AS varchar(6))                                                                                                                                                                                                                                                                                                                                                                                                                                                                           --Failed - previously passed -unit Default  Quiz frequency specified
                                                                                                                                                                                                                                                               + (SELECT  '' ''+LangEntryValue  FROM tblLangValue
                                                                                                                                                                                                                                                                              where LangInterfaceID = (SELECT  LangInterfaceID   FROM tblLangInterface WHERE LangInterfaceName = ''GLOBAL.MISC'')
                                                                                                                                                                                                                                                                              and LangID =(SELECT LangID FROM tblLang where tblLang.LangCode=  @CurrentCultureName)
                                                                                                                                                                                                                                                                              and LangResourceID = (SELECT LangResourceID  FROM tblLangResource where   LangResourceName = ''days'' ))
                                                                                                                                                                                                                                                               
when QuizStatusID = 3 and LC.DateCreated is null and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and vUQS.DateCreated is not null         AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate())) >= 0
                                                                                                                                                                                                                                                               then CAST(RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate()) AS VARCHAR(5))                                                                                                                                                                                                                                                                                                                                                                  --Failed - not previously passed , overdue is defined, not overdue
                                                                                                                                                                                                                                                               + (SELECT  '' ''+LangEntryValue  FROM tblLangValue
                                                                                                                                                                                                                                                                              where LangInterfaceID = (SELECT  LangInterfaceID   FROM tblLangInterface WHERE LangInterfaceName = ''GLOBAL.MISC'')
                                                                                                                                                                                                                                                                              and LangID =(SELECT LangID FROM tblLang where tblLang.LangCode=  @CurrentCultureName)
                                                                                                                                                                                                                                                                              and LangResourceID = (SELECT LangResourceID  FROM tblLangResource where   LangResourceName = ''days'' ))
                                                                                                                                                                                                                                                               
when QuizStatusID = 3 and LC.DateCreated is null and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and vUQS.DateCreated is not null         AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate())) < 0
                                                                                                                                                                                                                                                               then convert(varchar (11),DATEADD(day,RemEsc.DaysToCompleteCourse,dbo.udfUTCtoDaylightSavingTime(vUQS.DateCreated,o.organisationID)),113)                                                                                                         --Failed - not previously passed , overdue is defined, overdue



end
as QuizExpiryDate
,case
when LC.DateCreated is null then '' ''
else convert(varchar (11),dbo.udfUTCtoDaylightSavingTime(LC.DateCreated,o.organisationID),113) 
end as LastComp

,case when vUQS.DateCreated is null and (RemEsc.DaysToCompleteCourse is null OR ((RemEsc.NotifyMgr = 0) AND (RemEsc.RemindUsers = 0))) then ''0''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        -- course just added , overdue not defined
when vUQS.DateCreated is null and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and CS.DateCreated is null then ''0''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           -- course just added , overnight job has not caught up yet
when QuizStatusID = 1 and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and vUQS.DateCreated is not null              AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate())) >= 0 then ''0''                       -- not started , overdue is defined, not overdue
when QuizStatusID = 1 and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and vUQS.DateCreated is not null              AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate())) < 0 then ''1''                         -- not started , overdue is defined, overdue
when QuizStatusID = 4 and vUQS.DateCreated is not null then ''1''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        -- Expired (Time Elapsed )
when QuizStatusID = 5 and vUQS.DateCreated is not null then ''1''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        -- Expired (New Content)                                                                           
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizCompletionDate is not null 
                                                                                                                                                                                                                                                               and DATEDIFF(day,o.DefaultQuizCompletionDate,getUTCdate()) < 0 then ''0''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               --Passed - organisation Default  Quiz Completion Date specified , expired
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is not null 
                                                                                                                                                                                                                                                               and DATEDIFF(day,ur.QuizCompletionDate,getUTCdate()) < 0 then ''0''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    --Passed - unit Default  Quiz Completion Date specified , expired
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizCompletionDate is not null 
                                                                                                                                                                                                                                                               and DATEDIFF(day,o.DefaultQuizCompletionDate,getUTCdate()) >= 0 then ''1''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              --Passed - organisation Default  Quiz Completion Date specified , not expired
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is not null  
                                                                                                                                                                                                                                                               and DATEDIFF(day,ur.QuizCompletionDate,getUTCdate()) >= 0 then ''1''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    --Passed - unit Default  Quiz Completion Date specified , not expired
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizFrequency is not null 
                                                                                                                                                                                                                                                               and DATEDIFF(day,DATEADD(month,o.DefaultQuizFrequency,vUQS.DateCreated),getUTCdate()) >= 0 then "1"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            --Passed - organisation Default  Quiz frequency specified
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is not null 
                                                                                                                                                                                                                                                               and  DATEDIFF(day,DATEADD(month,ur.quizfrequency,vUQS.DateCreated),getUTCdate())  >= 0 then "1"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     --Passed - unit Default  Quiz frequency specified
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizFrequency is not null 
                                                                                                                                                                                                                                                               and DATEDIFF(day,DATEADD(month,o.DefaultQuizFrequency,vUQS.DateCreated),getUTCdate()) < 0 then "0"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              --Passed - organisation Default  Quiz frequency specified , not expired
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is not null 
                                                                                                                                                                                                                                                               and  DATEDIFF(day,DATEADD(month,ur.quizfrequency,vUQS.DateCreated),getUTCdate())  < 0  then "0"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      --Passed - unit Default  Quiz frequency specified , not expired


when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizCompletionDate is not null 
                                                                                                                                                                                                                                                               and DATEDIFF(day,o.DefaultQuizCompletionDate,getUTCdate()) < 0 then ''0''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               --failed - previously passed - organisation Default  Quiz Completion Date specified , expired
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is not null 
                                                                                                                                                                                                                                                               and DATEDIFF(day,ur.QuizCompletionDate,getUTCdate()) > 0 then ''0''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    --failed - previously passed - unit Default  Quiz Completion Date specified , expired
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizCompletionDate is not null 
                                                                                                                                                                                                                                                               and DATEDIFF(day,o.DefaultQuizCompletionDate,getUTCdate()) >= 0 then ''1''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              --failed - previously passed - organisation Default  Quiz Completion Date specified , not expired
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is not null 
                                                                                                                                                                                                                                                               and DATEDIFF(day,ur.QuizCompletionDate,getUTCdate()) <= 0 then ''1''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    --failed - previously passed - unit Default  Quiz Completion Date specified , not expired
when QuizStatusID = 3 and LC.DateCreated is not null  and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizFrequency is not null 
                                                                                                                                                                                                                                                               and DATEDIFF(day,DATEADD(month,o.DefaultQuizFrequency,vUQS.DateCreated),getUTCdate()) >= 0 then "1"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            --failed - previously passed - organisation Default  Quiz frequency specified
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is not null  
                                                                                                                                                                                                                                                               and  DATEDIFF(day,getUTCdate(),DATEADD(month,ur.quizfrequency,vUQS.DateCreated)) >= 0 then "1"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      --failed - previously passed - unit Default  Quiz frequency specified
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizFrequency is not null 
                                                                                                                                                                                                                                                               and DATEDIFF(day,DATEADD(month,o.DefaultQuizFrequency,vUQS.DateCreated),getUTCdate()) < 0 then "0"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              --failed - previously passed - organisation Default  Quiz frequency specified
when QuizStatusID = 3 and LC.DateCreated is not null  and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is not null
                                                                                                                                                                                                                                                               and   DATEDIFF(day,getUTCdate(),DATEADD(month,ur.quizfrequency,vUQS.DateCreated)) < 0               then "0"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         --failed - previously passed - unit Default  Quiz frequency specified
when QuizStatusID  = 3 and LC.DateCreated is null and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and vUQS.DateCreated is not null         AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate())) >= 0 then ''0''                         -- not started , overdue is defined, not overdue
when QuizStatusID  = 3 and LC.DateCreated is null and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and vUQS.DateCreated is not null         AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate())) < 0 then ''1''                           -- not started , overdue is defined, overdue




end AS Red
from
--< get the module access details for this user >--
vwUserModuleAccess vUMA
inner join tblOrganisation o
ON o.organisationID = vUMA.OrganisationID
--< get the module access details for this user >--
left outer join tblLesson tL
on tL.ModuleID = vUMA.ModuleID
and tL.Active = 1
--< get the details of the latest quiz  >--
left outer join

(
SELECT      QuizStatus.UserID, QuizStatus.ModuleID, m.CourseID, QuizStatus.QuizStatusID, QuizStatus.QuizPassMark, QuizStatus.QuizScore,QuizStatus.DateCreated
FROM         dbo.tblUserQuizStatus AS QuizStatus INNER JOIN
dbo.tblModule AS m ON m.ModuleID = QuizStatus.ModuleID INNER JOIN
(SELECT     MAX(UserQuizStatusID) AS UserQuizStatusID,ModuleID
FROM          dbo.tblUserQuizStatus where UserID = @UserID
GROUP BY ModuleID ) AS currentStatus ON QuizStatus.UserQuizStatusID = currentStatus.UserQuizStatusID and currentStatus.ModuleID = m.ModuleID
WHERE     (m.Active = 1) 
)

vUQS -- n^2 complexety :-(
on vUQS.UserID = vUMA.UserID
and vUQS.ModuleID = vUMA.ModuleID
left outer join tblUnitRule ur --Get the unit specific rules
on ur.ModuleID = vUQS.ModuleID
and ur.ModuleID = vUMA.ModuleID
and ur.UnitID=vUMA.unitID
left outer join tblReminderEscalation RemEsc on RemEsc.CourseId = vUMA.CourseID
and RemEsc.orgID = o.organisationID
left outer join (SELECT MIN(UserCourseStatusID) as UserCourseStatusID,[UserID] ,[CourseID] FROM tblUserCourseStatus LastAttempt where LastAttempt.UserID = @UserID and not exists (SELECT * FROM tblUserCourseStatus PreviousAttempt where PreviousAttempt.UserID = @UserID and PreviousAttempt.CourseStatusID = 0 and PreviousAttempt.UserCourseStatusID < LastAttempt.UserCourseStatusID and PreviousAttempt.CourseID = LastAttempt.CourseID and PreviousAttempt.UserID = LastAttempt.UserID) group by [UserID] ,[CourseID]
) CSID ON CSID.UserID = @UserID and CSID.courseID = vUMA.courseID
left outer join tblUserCourseStatus CS ON CS.UserID = @UserID and CS.courseID = vUMA.courseID and CS.UserCourseStatusID = CSID.UserCourseStatusID
left outer join
( -- Last Passed Module Quiz record
SELECT      QuizStatus.UserID, QuizStatus.ModuleID,QuizStatus.DateCreated
FROM         dbo.tblUserQuizStatus AS QuizStatus INNER JOIN
dbo.tblModule AS m ON m.ModuleID = QuizStatus.ModuleID INNER JOIN
(SELECT     MAX(UserQuizStatusID) AS UserQuizStatusID,ModuleID
FROM          dbo.tblUserQuizStatus where UserID = @UserID
and QuizStatusID = 2 -- passed
GROUP BY  ModuleID ) AS currentStatus ON QuizStatus.UserQuizStatusID = currentStatus.UserQuizStatusID and currentStatus.ModuleID = m.ModuleID
WHERE     (m.Active = 1)
)
LC
on LC.UserID = vUMA.UserID
and LC.ModuleID = vUMA.ModuleID
Where
-- vUMA.CourseID = isnull(@courseID, vUMA.CourseID ) and
vUMA.UserID = isnull(@userID, vUMA.UserID)

' 
END


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[tblSCORMcontent]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [tblSCORMcontent](
	[contentID] [int] IDENTITY(1,1) NOT NULL,
	[LessonLaunchPoint] [nvarchar](100) NOT NULL,
	[QFS] [nvarchar](100) NOT NULL,
	[QuizLaunchPoint] [nvarchar](100) NULL,
	[CourseName] [nvarchar](100) NULL,
	[ModuleName] [nvarchar](100) NOT NULL
) ON [PRIMARY]
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcSCORMpublishcontent]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [prcSCORMpublishcontent]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcSCORMpublishcontent]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcSCORMpublishcontent]
	@LessonLaunchPoint nvarchar(100) ,
	@QFS nvarchar(100) ,
	@QuizLaunchPoint [nvarchar](100) ,
	@CourseName [nvarchar](100) ,
	@ModuleName [nvarchar](100) 
AS
BEGIN

INSERT INTO tblSCORMcontent
           ([LessonLaunchPoint]
           ,[QFS]
           ,[QuizLaunchPoint]
           ,[CourseName]
           ,[ModuleName])
     VALUES
           (@LessonLaunchPoint
           ,@QFS
           ,@QuizLaunchPoint
           ,@CourseName
           ,@ModuleName)
END
' 
END
GO



IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcSCORMpublishedcontent]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [prcSCORMpublishedcontent]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcSCORMpublishedcontent]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE  [prcSCORMpublishedcontent]

AS
BEGIN
SELECT LessonLaunchPoint + ''?QFS='' + QFS as  launchpoint,''"''+CourseName + ''" - '' + ModuleName + '' ''+ CAST(contentID AS varchar(9)) AS title FROM tblSCORMcontent
END
' 
END
GO



IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcSCORMgetSession]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [prcSCORMgetSession]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcSCORMgetSession]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcSCORMgetSession] (
             @StudentID int,
             @LessonID int
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





