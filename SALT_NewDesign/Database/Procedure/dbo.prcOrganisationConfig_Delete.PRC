SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisationConfig_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'




/*Summary:
Deletes a Client Config Entry.

Parameters:
@OrganisationID
@Name

Returns:
@intErrorNumber As ''ErrorNumber'',
@strErrorMessage As ''ErrorMessage''

Called By:
OrganisationConfiguration.aspx

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


Author: Peter Kneale
Date Created: 16 August 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

**/
CREATE     Procedure [prcOrganisationConfig_Delete]
(
@OrganisationID	Integer=null,
@Name		nVarchar(255)=null
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

--Validate Parameter @OrganisationID
If(@OrganisationID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @OrganisationID in stored procedure prcOrganisationConfig_Delete''
Goto Finalise
End
--Validate Parameter @Name
If(@Name Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @Name in stored procedure prcOrganisationConfig_Delete''
Goto Finalise
End
-- Validate that the Organsiation exists exist.
If Not Exists(Select * From tblOrganisation Where [OrganisationID] = @OrganisationID)
Begin
Set @intErrorNumber = 2
Set @strErrorMessage = ''The Organisation '' + cast(@OrganisationID as varchar) + '' doesnt exist.''
Goto Finalise
End
-- Validate that the Name exists exist.
If Not Exists(Select * From tblOrganisationConfig Where [Name] = @Name)
Begin
Set @intErrorNumber = 21
Set @strErrorMessage = ''The Name '' + @Name + '' doesnt exist.''
Goto Finalise
End

DELETE FROM
[tblOrganisationConfig]
WHERE
[OrganisationID] 	= @OrganisationID
and
[Name]			= @Name

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
