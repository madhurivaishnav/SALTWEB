SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prcUser_Update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prcUser_Update]
GO







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
@intErrorNumber As 'ErrorNumber',
@strErrorMessage As 'ErrorMessage'

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
CREATE     Procedure prcUser_Update
(
@userID Integer = Null,
@unitID Integer = Null,
@firstName varchar(50) = Null,
@lastName varchar(50) = Null,
@userName varchar(100) = Null,
@email varchar(100) = null,
@active bit = null,
@userTypeID Integer = Null,
@updatedByUserID Integer = Null,
@dateUpdated datetime = Null,
@password varchar(50) = Null,
@oldPassword varchar(50) = Null,
@externalID varchar(50) = Null
)

As

Set NoCount On
Set Xact_Abort On

Begin Transaction

Update tblDeadLockPartB Set Text = 'Updated by UserUpdate'

-- Declarations
Declare @strErrorMessage Varchar(200) -- Holds the error message
Declare @intErrorNumber Integer -- Holds the error number
Declare @UpdatedByUserTypeID Integer -- Holds the UserTypeID for the Updating user.
Declare @blnChangePassword bit			-- Boolean value to indentify update of the password
Declare @strCurrentPassword varchar(50) -- Holds the current password in the DB for this user
Declare @strCurrentUserName varchar(100) -- Holds the current username in the DB for this user
Declare @strCurrentEmail varchar(100) -- Holds the current email in the DB for this user
Declare @organisationID Integer -- Used to set the OrgID to null when updating a SALT Administrator
Declare @dteCurrentDateUpdated datetime -- Holds the current dateupdated in the DB for this user

-- Initialise variables
Set @strErrorMessage = ''
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

--Validate Parameter @userID
If(@userID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = 'Missing or Null parameter @userID in stored procedure prcUser_Update'
Goto Finalise
End

-- If user type is not SALT Administrator, validate parameter @UnitID
If(@userTypeID <> 1)
Begin
If(@unitID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = 'Missing or Null parameter @unitID in stored procedure prcUser_Update'
Goto Finalise
End
End

--Validate Parameter @firstName
If(@firstName Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = 'Missing or Null parameter @firstName in stored procedure prcUser_Update'
Goto Finalise
End

--Validate Parameter @lastName
If(@lastName Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = 'Missing or Null parameter @lastName in stored procedure prcUser_Update'
Goto Finalise

End

--Validate Parameter @userName
If(@userName Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = 'Missing or Null parameter @userName in stored procedure prcUser_Update'
Goto Finalise
End

--Validate Parameter @email
If(@email Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = 'Missing or Null parameter @email in stored procedure prcUser_Update'
Goto Finalise
End

--Validate Parameter @active
If(@active Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = 'Missing or Null parameter @active in stored procedure prcUser_Update'
Goto Finalise
End

--Validate Parameter @userTypeID
If(@userTypeID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = 'Missing or Null parameter @userTypeID in stored procedure prcUser_Update'
Goto Finalise
End

--Validate Parameter @updatedByUserID
If(@updatedByUserID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = 'Missing or Null parameter @updatedByUserID in stored procedure prcUser_Update'
Goto Finalise
End

--Validate Parameter @dateUpdated
If(@dateUpdated Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = 'Missing or Null parameter @dateUpdated in stored procedure prcUser_Update'
Goto Finalise
End

-- Validate User Exists
--=========================================================
If Not Exists(Select * From tblUser Where UserID = @userID)
Begin
Set @intErrorNumber = 1
Set @strErrorMessage = 'This record no longer exists please refresh your screen.  If the problem persists please contact your administrator.'
Goto Finalise
End

-- If a unit was specified make sure it exists
--=========================================================
If (@unitID Is Not Null)
Begin
If Not Exists(Select * From tblUnit Where UnitID = @unitID)
Begin
Set @intErrorNumber = 1
Set @strErrorMessage = 'The specified unit could be found or may not be active.'
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


If (DateDiff(s, @dteCurrentDateUpdated, @dateUpdated) <> 0)
Begin
Set @intErrorNumber = 7
Set @strErrorMessage = 'This record has already been updated by another user, please refresh your screen. If the problem persists please contact your administrator.'
Goto Finalise
End


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
Set @strErrorMessage = 'Missing or Null parameter @password in stored procedure prcUser_Update'
Goto Finalise
End

If(@oldPassword Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = 'Missing or Null parameter @oldPassword in stored procedure prcUser_Update'
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
Set @strErrorMessage = 'Your old password was entered incorrectly so the user details have not been saved. '
Set @strErrorMessage = @strErrorMessage + 'Please try again and if the problem persists please contact your administrator.'
Goto Finalise
End

Set @blnChangePassword = 1
End
End
else
Begin
-- Administrator
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
Set @intErrorNumber = 4
Set @strErrorMessage = 'You do not have the permissions required to update this user.'
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
Set @intErrorNumber = 4
Set @strErrorMessage = 'The username ' + @userName + ' already exists.  Please choose another username for this user.'
Goto Finalise
End
end
else
begin
if Exists(Select * from tblUser where UserName = @userName)
Begin
Set @intErrorNumber = 4
Set @strErrorMessage = 'The username ' + @userName + ' already exists.  Please choose another username for this user.'
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
Set @intErrorNumber = 4
Set @strErrorMessage = 'The email address ' + @email + ' already exists.  Please choose another email address for this user.'
Goto Finalise
End

--TODO: Remove following wait line for testing deadlocks only
WAITFOR DELAY '00:00:10';



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
ExternalID = @externalID
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
ExternalID = @externalID
Where
UserID = @userID
End

-- Set the error message to successfull
Set @strErrorMessage = 'Successfully Updated'

-- Finalise the procedure
Goto Finalise


Finalise:
If(@intErrorNumber > 0)
Begin
Rollback Transaction
Select
@intErrorNumber As 'ErrorNumber',
@strErrorMessage As 'ErrorMessage'
End
Else
Begin
Commit Transaction
Select
@intErrorNumber As 'ErrorNumber',
@strErrorMessage As 'ErrorMessage'
End

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

