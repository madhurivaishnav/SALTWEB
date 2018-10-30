SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcModule_Create]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
Creates a new Module.

Parameters:
@courseID
@name
@description
@active
@userID

Returns:
@intErrorNumber As ''ErrorNumber'',
@strErrorMessage As ''ErrorMessage''

Called By:
Module.cs.

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
Date Created: 18th February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

**/
CREATE   Procedure [prcModule_Create]
(
@courseID Integer = Null,
@name nVarchar(100) = Null,
@description nVarchar(1000) = Null,
@active Bit = 1,
@userID Integer = Null
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

--Validate Parameter @courseID
If(@courseID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @courseID in stored procedure prcModule_Create''
Goto Finalise
End

--Validate Parameter @name
If(@name Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @name in stored procedure prcModule_Create''
Goto Finalise
End

--Validate Parameter @active
If(@active Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @active in stored procedure prcModule_Create''
Goto Finalise
End

--Validate Parameter @userID
If(@userID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @userID in stored procedure prcModule_Create''
Goto Finalise
End

--Check that there are no other modules of this name within this course
If Exists(Select CourseID from tblModule Where CourseID=@courseID and [Name]=@name)
Begin
Set @intErrorNumber = 4
Set @strErrorMessage = ''There is already a module of that name within this course''
Goto Finalise
End


-- Insert the new record
Insert Into tblModule
(
CourseID,
[Name],
[Description],
Active,
CreatedBy,
DateCreated,
UpdatedBy,
DateUpdated
)
Values
(
@courseID,
@name,
@description,
@active,
@userID,
GetUTCDate(),
@userID,
GetUTCDate()
)

-- Set the error message to successfull
Set @intErrorNumber = 0
Set @strErrorMessage = @@identity

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
