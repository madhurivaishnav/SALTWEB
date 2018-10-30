SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [prcUser_Update] 
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
	/*declare courseIDCursor cursor
	for
	select
	grantedcourseid
	from
	tblOrganisationCourseAccess oca
	where
	organisationid = (select organisationid from tblUser where userid=@userid)


	-- update course status for users
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
