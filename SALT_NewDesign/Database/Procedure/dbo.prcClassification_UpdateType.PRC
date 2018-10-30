SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcClassification_UpdateType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



/*
Summary:
Updates a Classification Type for an Organisation

Parameters:
@name VarChar(50)
@classificationTypeID Integer
@organisationID Integer

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
Date Created: 18th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE  Procedure [prcClassification_UpdateType]
(
@name nVarChar(50) = Null, -- The name of the ClassificationType.
@classificationTypeID Integer = Null, -- The ID of the ClassificationType that you wish to update.
@organisationID Integer -- ID of the Organisation that you are updating the ClassificationType for.
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
If(@classificationTypeID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @classificationTypeID in stored procedure  prcClassification_AddType''
Goto Finalise
End

If(@organisationID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @organisationID in stored procedure  prcClassification_AddType''
Goto Finalise
End

If(@name Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @name in stored procedure  prcClassification_AddType''
Goto Finalise
End

If Exists(Select * From tblClassificationType Where ClassificationTypeID = @classificationTypeID)
Begin
Update tblClassificationType
Set
Name = @name
Where
ClassificationTypeID  = @classificationTypeID
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
