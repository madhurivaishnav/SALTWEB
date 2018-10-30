SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcModule_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
Updates a Module''s details (except its sequence value).

Parameters:
@moduleID
@name
@description
@active
@updatedByUserID

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
CREATE Procedure [prcModule_Update]
(
@moduleID Integer = Null,
@name nVarchar(100) = Null,
@description nVarchar(1000) = Null,
@active Bit = Null,
@updatedByUserID Integer = Null
)

As
-- Used to hold the course id when checking for duplicate module names.
Declare @CourseID int

Set NoCount On
Set Xact_Abort On

Begin Transaction

-- Declarations
Declare @strErrorMessage Varchar(200) -- Holds the error message
Declare @intErrorNumber Integer -- Holds the error number

-- Initialise variables
Set @strErrorMessage = ''''
Set @intErrorNumber = 0

-- Validate Parameter @moduleID
If(@moduleID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @moduleID in stored procedure prcModule_Update''
Goto Finalise
End

-- Validate Parameter @name
If(@name Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @name in stored procedure prcModule_Update''
Goto Finalise
End

-- Validate Parameter @active
If(@name Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @active in stored procedure prcModule_Update''
Goto Finalise
End

-- Validate Parameter @userID
If(@updatedByUserID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @updatedByUserID in stored procedure prcModule_Update''
Goto Finalise
End

--Check that there are no other modules of this name within this course
Select @CourseID = CourseID From tblModule Where ModuleID=@ModuleID
If Exists(Select CourseID from tblModule Where CourseID=@courseID and [Name]=@name and ModuleID <> @moduleID)
Begin
Set @intErrorNumber = 4
Set @strErrorMessage = ''There is already a module of that name within this course''
Goto Finalise
End

If Exists(Select * From tblModule Where ModuleID = @moduleID)
Begin
-- Update the record in tblModule
Update tblModule
Set
[Name] = @name,
[Description] = @description,
Active = @active,
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
