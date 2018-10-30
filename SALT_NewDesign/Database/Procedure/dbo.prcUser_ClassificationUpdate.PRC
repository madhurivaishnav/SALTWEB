SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_ClassificationUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'




/*Summary:
Updates a Users Classification details

Parameters:
@userID				(Mandatory)
@values				(Mandatory)

Returns:
@intErrorNumber As ''ErrorNumber'',
@strErrorMessage As ''ErrorMessage''

Called By:
User.cs.

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
7. IntegrityConstraintException
10. BusinessServiceException (General)

Assumptions:
Requires function udfCsvToInt

Author: John Crawford
Date Created: 18 February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	John C		26-Feb-2004		Converted to user udfCsvToInt

**/
CREATE   Procedure [prcUser_ClassificationUpdate]
(
@userID Integer = Null,
@values nvarchar(4000) = Null
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

-- PARAMETER VALIDATION
--==============================================================

--Validate Parameter @userID
If(@userID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @userID in stored procedure prcUser_Update''
Goto Finalise
End

-- Validate User Exists
--=========================================================
If Not Exists(Select * From tblUser Where UserID = @userID)
Begin
Set @intErrorNumber = 1
Set @strErrorMessage = ''This record no longer exists please refresh your screen.  If the problem persists please contact your administrator.''
Goto Finalise
End


-- Delete existing userclassifications
--====================================
Delete
From
tblUserClassification
Where
UserID = @userID


-- insert into the database
--===================================================
insert into tblUserClassification
(UserID,
ClassificationID
)
select @UserID,
c.ClassificationID
From tblClassification c
left join dbo.udfCsvToInt(@values) as  csv
on csv.IntValue=c.ClassificationID
where c.ClassificationID = csv.IntValue
and c.Active = 1


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
