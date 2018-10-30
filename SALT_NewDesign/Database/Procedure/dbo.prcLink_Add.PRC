SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcLink_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


/*Summary:
Adds a new Link.

Parameters:
@organisationID
@caption
@url
@showDisclaimer
@userID

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
Date Created: 12th February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

**/
CREATE   Procedure [prcLink_Add]
(
@organisationID Integer = Null,
@caption nVarchar(100) = Null,
@url nVarchar(200) = Null,
@showDisclaimer Bit = 1,
@userID Integer = Null,
@LinkOrder Integer = 999
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

-- Validate that the Caption for this link doesn''t exist.
If Exists(Select * From tblLink Where Caption = @caption And OrganisationID = @organisationID)
Begin
Set @intErrorNumber = 4
Set @strErrorMessage = ''The Caption '' + @caption + '' already exists please choose another Caption.''
Goto Finalise
End

--Validate Parameter @organisationID
If(@organisationID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @organisationID in stored procedure prcLink_Add''
Goto Finalise
End

--Validate Parameter @caption
If(@caption Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @caption in stored procedure prcLink_Add''
Goto Finalise
End


--Validate Parameter @showDisclaimer
If(@showDisclaimer Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @showDisclaimer in stored procedure prcLink_Add''
Goto Finalise
End

--Validate Parameter @userID
If(@userID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @userID in stored procedure prcLink_Add''
Goto Finalise
End

-- Insert the new record into tblLink
Insert Into tblLink
(
OrganisationID,
Caption,
Url,
ShowDisclaimer,
CreatedBy,
LinkOrder
)
Values
(
@organisationID,
@caption,
@url,
@showDisclaimer,
@userID,
@LinkOrder
)

-- Set the error message to successfull
Set @strErrorMessage = ''Successfully Added''

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
