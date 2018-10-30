SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_GetUnassigned]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
Summary: Returns the users that are not currently assigned to a unit.
This function never returns users who are salt administrators

Parameters: @OrganisationID 	Integer
Returns:
UserID,
First Name,
Last Name,
DateUpdated
@intErrorNumber As ''ErrorNumber'',
@strErrorMessage As ''ErrorMessage''

Called By: User.cs
Calls: Nothing

Remarks: Raises an error if the parameter is null

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
Date Created: 9th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description

-- prcUser_GetUnassigned 1
*/
CREATE Procedure [prcUser_GetUnassigned]
@OrganisationID 	Integer
AS

Set NoCount On

-- Declarations
Declare @strErrorMessage Varchar(200) 		-- Holds the error message
Declare @intErrorNumber Integer			-- Holds the error number

-- Initialise variables
Set @strErrorMessage = ''''
Set @intErrorNumber = 0

-- Validation
If(@organisationID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @organisationID in stored procedure prcUser_GetUnassigned''
Goto Finalise
End

-- Logic
Select
UserID,
LastName,
FirstName,
UserName,
dbo.udfUTCtoDaylightSavingTime(DateUpdated, @OrganisationID) as DateUpdated
From
tblUser
Where
OrganisationID=@OrganisationID
And
UnitID is null
And
UserTypeID <> 1
order by
LastName,
FirstName
-- Set the error message to successfull
Set @strErrorMessage = ''User successfully selected.''

-- Finalise the procedure
Goto Finalise

Finalise:
If(@intErrorNumber > 0)
Begin
Select
@intErrorNumber 	As ''ErrorNumber'',
@strErrorMessage 	As ''ErrorMessage''
End
' 
END
GO
