SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisation_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [prcOrganisation_Update] (
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
