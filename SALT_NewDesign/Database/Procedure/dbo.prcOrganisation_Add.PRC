SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisation_Add]') AND type in (N'P', N'PC'))
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
CREATE    Procedure [prcOrganisation_Add]
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
