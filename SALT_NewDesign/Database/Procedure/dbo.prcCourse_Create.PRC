SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcCourse_Create]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
Created a new Course.

Parameters:
@intCourseID
@name
@notes
@active
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
0. Succeeded
4. UniqueViolationException
5. ParameterException
10. BusinessServiceException (General)


Author: Gavin Buddis
Date Created: 17th February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

**/
CREATE   Procedure [prcCourse_Create]
(
@intCourseID Integer OutPut, -- The ID of the newly created course.
@name nVarchar(100) = Null,
@notes nVarchar(1000) = Null,
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

--Validate Parameter @name
If(@name Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @name in stored procedure prcCourse_Create''
Goto Finalise
End

--Validate Parameter @showDisclaimer
If(@active Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @active in stored procedure prcCourse_Create''
Goto Finalise
End

--Validate Parameter @userID
If(@userID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @userID in stored procedure prcCourse_Create''
Goto Finalise
End

If Not Exists(Select * From tblCourse Where Name = @name)
Begin
-- Insert the new record
Insert Into tblCourse
(
[Name],
Notes,
Active,
CreatedBy,
DateCreated,
UpdatedBy,
DateUpdated
)
Values
(
@name,
@notes,
@active,
@userID,
GetUTCDate(),
@userID,
GetUTCDate()
)

-- Set the error message to successfull
Set @intErrorNumber = 0
Select @intCourseID = @@Identity

-- Finalise the procedure
Goto Finalise
End
Else
Begin
Set @intErrorNumber = 4
Set @strErrorMessage = ''The Course Name '' + @name + '' already exists please choose another Course Name.''

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
