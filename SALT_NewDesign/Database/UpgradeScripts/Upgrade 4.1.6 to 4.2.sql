BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
if not exists (select * from INFORMATION_SCHEMA.COLUMNS 
			where TABLE_NAME='tblEmail' 
			and COLUMN_NAME='Status')
			exec(
				'BEGIN TRANSACTION
				
				ALTER TABLE tblEmail ADD
					Status tinyint NOT NULL CONSTRAINT DF_tblEmail_Status DEFAULT 0,
					MessageID char(10) NULL
				
				ALTER TABLE tblEmail SET (LOCK_ESCALATION = TABLE)
				
				COMMIT')
			










BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
if not exists (select * from INFORMATION_SCHEMA.COLUMNS 
			where TABLE_NAME='tblOrganisation' 
			and COLUMN_NAME='MailServerURL')
			exec(
				'BEGIN TRANSACTION
				
				ALTER TABLE tblOrganisation ADD
					MailServerURL nvarchar(200) NULL,
					MailSendAccount nvarchar(200) NULL,
					MailSendPassword nvarchar(200) NULL,
					MailSendSSL bit NOT NULL CONSTRAINT DF_tblOrganisation_MailSendSSL DEFAULT 0,
					MailSendClientCert nvarchar(255) NULL,
					NotifySuccess bit NOT NULL CONSTRAINT DF_tblOrganisation_NotifySuccess DEFAULT 0,
					NotifyFailure bit NOT NULL CONSTRAINT DF_tblOrganisation_NotifyFailure DEFAULT 0,
					MailServerPort char(10) NULL,
					DelinquencyManagerID int NULL,
					DelinquencyPeriod int NOT NULL CONSTRAINT DF_tblOrganisation_DelinquencyPeriod DEFAULT 90,
					DelinquencyReminderPeriod int NOT NULL CONSTRAINT DF_tblOrganisation_DelinquencyReminderPeriod DEFAULT 30,
					NumberOfReminders int NOT NULL CONSTRAINT DF_tblOrganisation_NumberOfReminders DEFAULT 0,
					TimeZone int NULL,
					

				ALTER TABLE tblOrganisation SET (LOCK_ESCALATION = TABLE)
				
				COMMIT')
			



if not exists (select * from INFORMATION_SCHEMA.COLUMNS 
			where TABLE_NAME='tblUser' 
			and COLUMN_NAME='LastExpiredNoticeSent')
			exec('
								BEGIN TRANSACTION
								SET QUOTED_IDENTIFIER ON
								SET ARITHABORT ON
								SET NUMERIC_ROUNDABORT OFF
								
								SET ANSI_NULLS ON
								SET ANSI_PADDING ON
								SET ANSI_WARNINGS ON
								COMMIT
								BEGIN TRANSACTION
								

								
								ALTER TABLE tblUser ADD
									AcceptsDelinquencyEmails char(1) NULL,
									TimeZone int NULL,
									NewStarterFlag bit NULL,
									LastDelinquencyReminderSent datetime NULL,
									LastExpiryWarningSent datetime NULL,
									LastExpiredNoticeSent datetime NULL

									  
									COMMIT')
			




GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[tblEmailQueue]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
exec('
CREATE TABLE [tblEmailQueue](
	[organisationID] [int] NULL,
	[Subject] [nvarchar](255) NULL,
	[body] [nvarchar](255) NULL,
	[recipient] [nvarchar](255) NULL,
	[attachment] [nvarchar](255) NULL,
	[QueuedTime] [datetime] NOT NULL,
	[SendStarted] [datetime] NULL,
	[NewMessageID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL
) ON [PRIMARY]')

GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblEmailQueue_QueuedTime]') AND type = 'D')
BEGIN
ALTER TABLE [tblEmailQueue] ADD  CONSTRAINT [DF_tblEmailQueue_QueuedTime]  DEFAULT (getdate()) FOR [QueuedTime]
END

GO




SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[tblPOP3MessageID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
exec('
CREATE TABLE [tblPOP3MessageID](
	[MailServerURL] [nvarchar](200) NOT NULL,
	[MailSendAccount] [nvarchar](200) NOT NULL,
	[MessageID] [varchar](70) NOT NULL,
	[LastSeen] [datetime] NOT NULL,
 CONSTRAINT [PK_tblPOP3MessageID] PRIMARY KEY CLUSTERED 
(
	[MailServerURL] ASC,
	[MailSendAccount] ASC,
	[MessageID] ASC
) ON [PRIMARY]
) ON [PRIMARY]')

GO

SET ANSI_PADDING OFF
GO


IF NOT EXISTS (SELECT * FROM dbo.sysindexes WHERE id = OBJECT_ID(N'[tblPOP3MessageID]') AND name = N'IX_tblPOP3MessageID')
CREATE NONCLUSTERED INDEX [IX_tblPOP3MessageID] ON [tblPOP3MessageID] 
(
	[MessageID] ASC
) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblPOP3MessageID_LastSeen]') AND type = 'D')
BEGIN
ALTER TABLE [tblPOP3MessageID] ADD  CONSTRAINT [DF_tblPOP3MessageID_LastSeen]  DEFAULT (getdate()) FOR [LastSeen]
END

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcOrganisation_GetOne]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
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

ALTER  Procedure [prcOrganisation_GetOne]
(
@LangCode nvarchar(10),
@orgID Integer = null -- OrganisationID
)

As

If @orgID Is Null
Begin
Raiserror(''The Parameter @orgID was null.  @orgID does not accept Null values.'', 16, 1)
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
o.DefaultLessonCompletionDate, 
o.DefaultQuizCompletionDate, 
o.AdvancedReporting,
o.CreatedBy,
o.DateCreated,
o.UpdatedBy,
o.DateUpdated,
o.CPDReportName,
o.AllocatedDiskSpace,
o.IncludeCertificateLogo,
o.PasswordLockout,
o.MailServerURL,
o.MailSendAccount,
o.MailSendPassword,
o.MailSendSSL,
o.MailSendClientCert,
o.NotifySuccess,
o.NotifyFailure,
o.MailServerPort,
o.DelinquencyManagerID,
o.DelinquencyPeriod,
o.DelinquencyReminderPeriod,
o.NumberOfReminders,
o.TimeZone
From
tblOrganisation o
left join tblOrganisationNotes orgN
on o.OrganisationID = orgN.OrganisationID
left join tblLang l
on orgN.LanguageID = l.LangID
Where
o.OrganisationID = @orgID
and l.LangCode = @LangCode
' 
END




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcOrganisation_Update]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'





/*Summary:
Updates the specified Organisation.

Parameters:
Declare @organisationID Integer
Declare @organisationName VarChar(50)
Declare @notes VarChar(1000)
Declare @logo VarChar(100)
Declare @lessonFrequency Integer
Declare @quizFrequency Integer
Declare @quizPassMark Integer
Declare @CPDReportName nvarchar(255)

Returns:
Nothing

Called By:
Organisation.cs.

Calls:
Nothing

Remarks:
Exception:
0. Succeed
1. RecordNotFound
4. UniqueViolationException
5. MissingParameterException
6. PermissionDeniedException
7. IntegrityViolationException
10. BusinessServiceException (General)

Author: Peter Vranich
Date Created: 18th February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	mikev		30/4/2007		Added @lessonCompletionDate and @quizCompletionDate
#2	aaronc		May 2008		Added @CPDReportName
#3	aaronc		June 2008		Added @AllocatedDiskSpace

**/
ALTER   Procedure [prcOrganisation_Update]
(
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
@TimeZone int = Null
)

As

Set NoCount On
Set Xact_Abort On

Begin Transaction

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
DateUpdated = GetDate(),
CPDReportName = @CPDReportName,
AllocatedDiskSpace = @AllocatedDiskSpace,
IncludeCertificateLogo = @inclLogo,
PasswordLockout = @PasswordLockout,
TimeZone = @TimeZone
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




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcUser_GetOne]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
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

ALTER Procedure [prcUser_GetOne]
(
	@userID Integer = null -- User ID
)

As
Set NoCount On

If @userID Is Null
Begin
	Raiserror(''The Parameter @userID was null.  @userID does not accept Null values.'', 16, 1)
	Return
End

Select
	USR.UserID,
	USR.FirstName,
	USR.LastName,
	USR.UserName,
	USR.Password,
	USR.Email,
	USR.ExternalID,
	USR.OrganisationID,
	USR.UnitID,
	USR.UserTypeID,
	USR.Active,
	USR.CreatedBy,
	USR.DateCreated,
	USR.UpdatedBy,
	USR.DateUpdated,
	USR.LastLogin,
	coalesce(USR.TimeZone,ORG.TimeZone) as TimeZone
From
	tblUser USR left outer join tblOrganisation ORG on  ORG.OrganisationID = USR.OrganisationID
Where
	USR.UserID = @userID
' 
END








SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcUser_Update]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
	Updates a Users Details

Parameters:
	@userID				(Mandatory)
	@unitID 			(Mandatory)
	@firstName 			(Mandatory)
	@lastName			(Mandatory)
	@userName			(Mandatory)
	@email				(Mandatory)
	@active				(Mandatory)
	@userTypeID			(Mandatory)
	@updatedByUserID	(Mandatory)
	@password			(Optional)
	@oldPassword		(Optional)

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
	contain valid data (apart from logic below).

Logic:
	Specific Logic checked for here is the following:
	1. If salt user and password is being changed;
		1.1 old password and password are mandatory
		1.2	old password must match password currently in DB
	2. If Administrator and password is being changed;
		2.1 old password not required.
	3. If changing username, new username must be unique in the specified organisation
		

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


Author: John Crawford
Date Created: 18 February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	John C		26-Feb-2004		Convert 0 Unit ID to Null for update
#2	Jack Liu	15/09/2005		User name is only unique per organisation

**/
ALTER Procedure [prcUser_Update]
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
	@TimeZone Integer = Null

)

As

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
		@OrgTimeZone = TimeZone
	From 
		tblOrganisation
	Where
		OrganisationID = @OrganisationID
	
	if (@OrgTimeZone = @TimeZone)
	begin
		Set @TimeZone = null
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
		Update tblUser
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
			DateUpdated = getDate(),
			ExternalID = @externalID,
			TimeZone = @TimeZone
		Where
			UserID = @userID
	End			
	Else
	Begin
		Update tblUser
		Set 
			FirstName = @firstName,
			LastName = @lastName,
			UserName = @userName,
			Email = @email,
			UnitID = @unitID,
			UserTypeID = @userTypeID,
			Active = @active,
			UpdatedBy = @updatedByUserID,
			DateUpdated = getDate(),
			ExternalID = @externalID,
			TimeZone = @TimeZone
		Where
			UserID = @userID
	End
	

	update tblUser set DateArchived = getdate() where Active = 0 and DateArchived IS NULL AND UserID = @userID
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

			set @moduleID = (select top 1 m.moduleId from tblModule m where CourseID = @courseID)
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
' 
END








SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcOrganisation_GetTimeZone]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE Procedure [prcOrganisation_GetTimeZone]
(
	@OrganisationID int
)

As

select TimeZone from tblOrganisation where organisationID = @OrganisationID

' 
END
GO







SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcOrganisation_GetTimeZone]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE Procedure [prcOrganisation_GetTimeZone]
(
	@OrganisationID int
)

As

select TimeZone from tblOrganisation where organisationID = @OrganisationID

' 
END
GO





SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[tblTimeZone]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [tblTimeZone](
	[TimeZone] [int] IDENTITY(1,1) NOT NULL,
	[StandardName] [nvarchar](60) NOT NULL,
	[OffsetUTC] [int] NOT NULL,
 CONSTRAINT [PK_tblTimeZone] PRIMARY KEY CLUSTERED 
(
	[TimeZone] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO








SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcTimeZone_GetTimeZoneID]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
DROP Procedure [prcTimeZone_GetTimeZoneID]
END 
GO

BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE Procedure [prcTimeZone_GetTimeZoneID]
(
	@WittenName varchar(60)
)

As


select @TimeZoneID = coalesce(TimeZoneID,1) from tblTimeZone where upper(WrittenName) = upper(@WrittenName)
select @TimeZoneID

' 
END
GO









SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcTimeZone_add]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

create procedure [prcTimeZone_add]
(
	@WrittenName nvarchar(60),
	@OffsetUTC int
)
as

INSERT INTO tblTimeZone
           (WrittenName
           ,OffsetUTC)
     VALUES
           (@WrittenName
           ,@OffsetUTC)
' 
END
GO





SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcTimeZone_GetList]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE Procedure [prcTimeZone_GetList]

As

SELECT TimeZone
      ,StandardName
      ,OffsetUTC
  FROM tblTimeZone


' 
END
GO









IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcUser_Update]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [prcUser_Update]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcUser_Update]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [prcUser_Update] (
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
	@TimeZoneID Integer = Null

)

As

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
		Update tblUser
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
			DateUpdated = getDate(),
			ExternalID = @externalID,
			TimeZoneID = @TimeZoneID
		Where
			UserID = @userID
	End			
	Else
	Begin
		Update tblUser
		Set 
			FirstName = @firstName,
			LastName = @lastName,
			UserName = @userName,
			Email = @email,
			UnitID = @unitID,
			UserTypeID = @userTypeID,
			Active = @active,
			UpdatedBy = @updatedByUserID,
			DateUpdated = getDate(),
			ExternalID = @externalID,
			TimeZoneID = @TimeZoneID
		Where
			UserID = @userID
	End
	

	update tblUser set DateArchived = getdate() where Active = 0 and DateArchived IS NULL AND UserID = @userID
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

			set @moduleID = (select top 1 m.moduleId from tblModule m where CourseID = @courseID)
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
' 
END
GO


