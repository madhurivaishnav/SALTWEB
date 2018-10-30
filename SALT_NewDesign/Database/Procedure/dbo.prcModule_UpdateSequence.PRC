SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcModule_UpdateSequence]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
Updates a Module''s sequence value.

Parameters:
@moduleID
@sequence
@userID

Returns:
@intErrorNumber As ''ErrorNumber'',
@strErrorMessage As ''ErrorMessage''

Called By:
Course.cs.

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
10. BusinessServiceException (General)


Author: Gavin Buddis
Date Created: 16 February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

**/
CREATE Procedure [prcModule_UpdateSequence]
(
@moduleID Integer = Null,
@sequence Varchar(100) = Null,
@updatedByUserID Integer = Null
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

--Validate Parameter @moduleID
If(@moduleID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @moduleID in stored procedure prcModule_UpdateSequence''
Goto Finalise
End

--Validate Parameter @name
If(@sequence Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @sequence in stored procedure prcModule_UpdateSequence''
Goto Finalise
End

--Validate Parameter @userID
If(@updatedByUserID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @updatedByUserID in stored procedure prcModule_UpdateSequence''
Goto Finalise
End

If Exists(Select * From tblModule Where ModuleID = @moduleID)
Begin
-- Update the record in tblModule
Update tblModule
Set
[Sequence] = @sequence,
UpdatedBy = @updatedByUserID,
DateUpdated = GetUTCDate()
Where
ModuleID = @moduleID

-- Set the error message to successfull
Set @strErrorMessage = ''Successfully Updated''

-- Finalise the procedure
Goto Finalise
End
Else
Begin
Set @intErrorNumber = 1
Set @strErrorMessage = ''This record no longer exists please refresh your screen.  If the problem persists please contact your administrator.''

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
