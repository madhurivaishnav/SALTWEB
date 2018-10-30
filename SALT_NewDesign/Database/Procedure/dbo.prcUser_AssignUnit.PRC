SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_AssignUnit]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
Updates a Users Unit, if no user is specified then it updates all unassigned users
to be members of the specified unit. This function does not ever update Salt Admin Type users

Parameters:
@userID		(Optional)
@unitID 		(Mandatory)
@updatedByUserID	(Mandatory)
@organisationID		(Mandatory)

Returns:
@intErrorNumber As ''ErrorNumber'',
@strErrorMessage As ''ErrorMessage''

Called By:
User.cs.

Calls:
Nothing

Assumptions:
None

Logic:
Updates the user and includes them in the appropriate unit


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


Author: Peter Kneale
Date Created: 23 February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	Peter Kneale	27/2			Added Organisation ID parameter

**/
CREATE  Procedure [prcUser_AssignUnit]
(
@userID 		Integer = Null,		-- User ID that should be assigned to the unit
@unitID 		Integer = Null,		-- Unit ID that the user should be assigned to
@updatedByUserID 	Integer = Null,		-- UserID of the user performing the update
@organisationID		Integer = Null		-- Organisation ID that the user is to be assigned to.
)

As

Set NoCount On
Set Xact_Abort On

Begin Transaction

-- Declarations
Declare @strErrorMessage Varchar(200) 		-- Holds the error message
Declare @intErrorNumber Integer 		-- Holds the error number

-- Initialise variables
Set @strErrorMessage = ''''
Set @intErrorNumber = 0


-- PARAMETER VALIDATION
--==============================================================

--Validate Parameter @unitID
If(@unitID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @unitID in stored procedure prcUser_UpdateUnit''
Goto Finalise
End

--Validate Parameter @updatedByUserID
If(@updatedByUserID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @updatedByUserID in stored procedure prcUser_UpdateUnit''
Goto Finalise
End

--Validate Parameter @organisationID
If(@organisationID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @organisationID in stored procedure prcUser_UpdateUnit''
Goto Finalise
End

-- Validate User Exists
--=========================================================
If Not (@userID is null)
Begin
If Not Exists(Select * From tblUser Where UserID = @userID)
Begin
Set @intErrorNumber = 1
Set @strErrorMessage = ''This user record no longer exists please refresh your screen.  If the problem persists please contact your administrator.''
Goto Finalise
End
End
-- Validate Updated By User ID Exists
--=========================================================
If Not Exists(Select * From tblUser Where UserID = @updatedByUserID)
Begin
Set @intErrorNumber = 1
Set @strErrorMessage = ''This user record no longer exists please refresh your screen.  If the problem persists please contact your administrator.''
Goto Finalise
End

-- Validate Organisation ID Exists
--=========================================================
If Not Exists(Select * From tblOrganisation Where OrganisationID = @organisationID)
Begin
Set @intErrorNumber = 1
Set @strErrorMessage = ''This user record no longer exists please refresh your screen.  If the problem persists please contact your administrator.''
Goto Finalise
End

-- Validate Unit Exists
--=========================================================
If Not Exists(Select * From tblUnit Where UnitID = @unitID and Active=1)
Begin
Set @intErrorNumber = 1
Set @strErrorMessage = ''This unit record no longer exists please refresh your screen.  If the problem persists please contact your administrator.''
Goto Finalise
End

If (@userID is null)
Begin
-- Update All Unassigned Active Users
--=======================
Update
tblUser
Set
UnitID = @unitID,
DateUpdated=getutcDate(),
UpdatedBy=@updatedByUserID
Where
UnitID = null
And Active = 1
And UserTypeID <> 1
And OrganisationID = @organisationID
End
Else
Begin
-- Update  a Single User
--=======================
Update
tblUser
Set
UnitID = @unitID,
DateUpdated=getutcDate(),
UpdatedBy=@updatedByUserID
Where
UserID = @userID
And OrganisationID = @organisationID
End




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
