SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcClassification_AddType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


/*
Summary:
Adds a Classification Type for an Organisation

Parameters:
@name nVarChar(50)
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

CREATE Procedure [prcClassification_AddType]
(
@name nVarChar(50) = Null, -- The name of the ClassificationType
@organisationID Integer = Null -- The ID of the Organisation that you wish to get the Classifications For.
)

As

Set NoCount On
Set Xact_Abort On

Begin Transaction

-- Declarations
Declare @strErrorMessage VarChar(200) -- Holds the error message
Declare @intErrorNumber Integer -- Holds the error number

-- Initialise variables
Set @strErrorMessage = ''''
Set @intErrorNumber = 0

-- Validation Routines
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

If Exists(Select * From tblClassificationType Where Name = @name And OrganisationID = @organisationID)
Begin
Set @intErrorNumber = 4
Set @strErrorMessage = ''The ClassificationType Name '' + @name + '' already exists for this organisation please choose another name for your ClassificationType.''
Goto Finalise
End

Insert Into tblClassificationType
(
Name,
OrganisationID
)
Values
(
@name,
@organisationID
)

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
