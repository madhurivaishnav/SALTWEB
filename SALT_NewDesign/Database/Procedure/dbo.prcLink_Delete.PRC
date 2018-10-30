SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcLink_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Deletes a Link.

Parameters:
@linkID

Returns:
@intErrorNumber As ''ErrorNumber'',
@strErrorMessage As ''ErrorMessage''

Called By:
Link.cs.

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

Author: Peter Vranich
Date Created: 12 February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

**/
CREATE Procedure [prcLink_Delete]
(
@linkID Integer = Null -- The LinkID of the record to delete.
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

--Validate Parameter @linkID
If(@linkID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @linkID in stored procedure prcLink_Update''
Goto Finalise
End

-- If the record exists delete it from the tblLink table.
If Exists(Select * From tblLink Where LinkID = @linkID)
Begin
Delete tblLink
Where
LinkID = @linkID
End
Else
Begin
Set @intErrorNumber = 1
Set @strErrorMessage = ''This record you tried to delete no longer exists.''

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
