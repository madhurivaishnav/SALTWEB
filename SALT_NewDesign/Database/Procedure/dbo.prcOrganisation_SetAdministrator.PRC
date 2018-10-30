SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisation_SetAdministrator]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
Sets a new Organisation Administrator.

Parameters:
@updateUserID Integer
@actionUserID Integer
@organisationID Integer
@originalDateUpdated Integer

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
2. FK constraint
3. PKViolationException
4. UniqueViolationException
5. MissingParameterException
6. PermissionDeniedException
7. IntegrityViolationException
10. BusinessServiceException (General)

Author: Peter Vranich
Date Created: 13th February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

**/
CREATE Procedure [prcOrganisation_SetAdministrator]
(
@updateUserID Integer, -- ID of the User that you wish to set Admin rights for.
@actionUserID Integer, -- ID of the User that is making the changes.
@organisationID Integer, -- ID of the Organisation that this user must belong to.
@originalDateUpdated DateTime -- original Date of the record.
)

As

Set NoCount On
Set Xact_Abort On

Begin Transaction

set @originalDateUpdated = dbo.udfDaylightSavingTimeToUTC(@originalDateUpdated, @organisationID)

-- Declarations
Declare @strErrorMessage Varchar(200) -- Holds the error message
Declare @intErrorNumber Integer -- Holds the error number

declare @intActionUserTypeID integer
Declare @dtCurrentDateUpdated DateTime -- Holds the current date updated date.

-- Initialise variables
Set @strErrorMessage = ''''
Set @intErrorNumber = 0

--Select @dtCurrentDateUpdated = dbo.udfUTCtoDaylightSavingTime(DateUpdated, @organisationID) From tblUser Where UserID = @updateUserID
Select @dtCurrentDateUpdated = DateUpdated From tblUser Where UserID = @updateUserID

-- Validation Routines
If(@updateUserID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @userID in stored procedure prcOrganisation_SetAdministrator''
Goto Finalise
End

If(@actionUserID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @userID in stored procedure prcOrganisation_SetAdministrator''
Goto Finalise
End

select @intActionUserTypeID =UserTypeID
from tblUser
where UserID = @actionUserID

--if action user is not  Salt Administrator(1) or Org Administrator
If (@intActionUserTypeID>2)
Begin
Set @intErrorNumber = 6
Set @strErrorMessage = ''You do not have access to modify this User.  Click here to return to the login page.''
Goto Finalise
End

If(@organisationID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @userID in stored procedure prcOrganisation_SetAdministrator''
Goto Finalise
End

If(@originalDateUpdated != @dtCurrentDateUpdated)
Begin
Set @intErrorNumber = 7
Set @strErrorMessage = ''The user''''s details have been updated by another user, you will need to refresh the users details and re-enter your changes.  Click here to refresh.''
Goto Finalise
End

If Exists(Select * From tblUser Where UserID = @updateUserID)
Begin
Update tblUser
Set
UserTypeID = 2, -- Org admin
DateUpdated = GETUTCDATE()
Where
UserID = @updateUserID

delete
from tblUnitAdministrator
where userID = @updateUserID
End
Else
Begin
Set @intErrorNumber = 1
Set @strErrorMessage = ''Record not found @userID in stored procedure prcOrganisation_SetAdmin''
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
@strErrorMessage As ''ErrorMessage''
End
' 
END
GO
