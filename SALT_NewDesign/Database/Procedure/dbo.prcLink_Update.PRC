SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcLink_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
Updates a Link.

Parameters:
@linkID
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
Date Created: 12 February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

**/
CREATE  Procedure [prcLink_Update]
(
@linkID Integer = Null,
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
if @url is null
begin
set @url = ''''
end

-- Declarations
Declare @organisationID Int -- Organisation ID for the link to be updated
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

-- Get the Organisation ID for the link to be updated
Set @organisationID = (Select organisationID From tblLink Where linkID = @linkID)

-- Validate that the Caption for this link doesn''t exist.
If Exists(Select * From tblLink Where Caption = @caption And LinkID != @linkID And OrganisationID = @organisationID)
Begin
Set @intErrorNumber = 4
Set @strErrorMessage = ''The Caption '' + @caption + '' already exists please choose another Caption.''
Goto Finalise
End

--Validate Parameter @caption
If(@caption Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @strErrorMessage in stored procedure prcLink_Update''
Goto Finalise
End

--Validate Parameter @showDisclaimer
If(@showDisclaimer Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @showDisclaimer in stored procedure prcLink_Update''
Goto Finalise
End

--Validate Parameter @userID
If(@userID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @userID in stored procedure prcLink_Update''
Goto Finalise
End

If Exists(Select * From tblLink Where LinkID = @linkID)
Begin
-- Update the record in tblLink
Update tblLink
Set
Caption = @caption,
Url = @url,
ShowDisclaimer = @showDisclaimer,
UpdatedBy = @userID,
DateUpdated = GetUTCDate(),
LinkOrder = @LinkOrder
Where
LinkID = @linkID

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
