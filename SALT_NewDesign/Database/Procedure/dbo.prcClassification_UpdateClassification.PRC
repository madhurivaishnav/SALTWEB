SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcClassification_UpdateClassification]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*
Summary:
Updates a Classification.

Parameters:
@name nVarChar(50)
@active Bit
@classificationID Integer

Returns:
None

Called By:
Classification.cs

Calls:
None

Remarks:
Exception:
0. Succeed
1. RecordNotFoundException
4. UniqueViolationException
5. MissingParameterException
10. BusinessServiceException (General)

Author: Peter Vranich
Date Created: 19th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/
CREATE  Procedure [prcClassification_UpdateClassification]
(
@name nVarChar(50) = Null, -- Name of the Classification
@active Bit = 1, -- Status of the classification
@classificationID Integer = Null, -- The ID of the classification that you wish to update.
@classificationTypeID Integer = Null -- The ID of the classification type that this classification belongs to.
)

As

Set NoCount On
Set Xact_Abort On

Begin Transaction

-- Declarations
Declare @strErrorMessage VarChar(200) -- Holds the error message
Declare @intErrorNumber Integer -- Holds the error number

-- Initialise variables
Set @intErrorNumber = 0
Set @strErrorMessage = ''''

-- Validation Routines
If(@classificationID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @classificationID in stored procedure  prcClassification_UpdateClassification''
Goto Finalise
End

If(@classificationTypeID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @classificationTypeID in stored procedure  prcClassification_UpdateClassification''
Goto Finalise
End

If(@name Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @name in stored procedure  prcClassification_UpdateClassification''
Goto Finalise
End

If Exists(Select * From tblClassification Where Value = @name And ClassificationID != @classificationID And ClassificationTypeID = @classificationTypeID)
Begin
Set @intErrorNumber = 4
Set @strErrorMessage = ''The Classification Value '' + @name + '' already exists for this ClassificationType please choose another value for your ClassificationType.''
Goto Finalise
End

If(@active Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @active in stored procedure  prcClassification_UpdateClassification''
Goto Finalise
End

If Exists(Select * From tblClassification Where ClassificationID = @classificationID)
Begin

Update tblClassification
Set
Value = @name,
Active = @active
Where
ClassificationID = @classificationID
DELETE FROM
tblUserClassification
WHERE
ClassificationID = @classificationID
End
Else
Begin
Set @intErrorNumber = 1
Set @strErrorMessage = ''This record no longer exists please refresh your screen.''
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
