SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcCourse_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
Updates a Course.

Parameters:
@courseID
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
0. Succeed
1. RecordNotFound
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
CREATE  Procedure [prcCourse_Update]
(
@courseID Integer = Null,
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

--Validate Parameter @courseID
If(@courseID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @courseID in stored procedure prcCourse_Update''
Goto Finalise
End

-- Validate that the Caption for this link doesn''t exist.
If Exists(Select * From tblCourse Where [Name] = @name And courseID != @courseID)
Begin
Set @intErrorNumber = 4
Set @strErrorMessage = ''The Name '' + @name + '' already exists please choose another Name.''
Goto Finalise
End

--Validate Parameter @name
If(@name Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @name in stored procedure prcCourse_Update''
Goto Finalise
End

--Validate Parameter @notes
If(@notes Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @notes in stored procedure prcCourse_Update''
Goto Finalise
End

--Validate Parameter @active
If(@active Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @active in stored procedure prcCourse_Update''
Goto Finalise
End

--Validate Parameter @userID
If(@userID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @userID in stored procedure prcCourse_Update''
Goto Finalise
End

If Exists(Select * From tblCourse Where CourseID = @courseID)
Begin
-- Update the record in tblCourse
Update tblCourse
Set
[Name] = @name,
Notes = @notes,
Active = @active,
UpdatedBy = @userID,
DateUpdated = GetUTCDate()
Where
CourseID = @courseID

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
