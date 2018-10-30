SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisationConfig_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



/*Summary:
Updates a Client Config Entry if it exists.
Creates a Client Config Entry if it doesnt.


Parameters:
@OrganisationID
@Name
@Description
@Value

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
2. FK constraint
5. MissingParameterException



Author: Peter Kneale
Date Created: 16 August 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

**/
CREATE    Procedure [prcOrganisationConfig_Update]
(
@OrganisationID	Integer=null,
@Name		    nVarchar(255)=null,
@Description	nVarchar(255)=null,
@Value		    nVarchar(4000)=null
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
Set @strErrorMessage = ''Missing or Null parameter @OrganisationID in stored procedure prcOrganisationConfig_Update''
Goto Finalise
End
--Validate Parameter @Name
If(@Name Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @Name in stored procedure prcOrganisationConfig_Update''
Goto Finalise
End
--Validate Parameter @Description
If(@Description Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @Description in stored procedure prcOrganisationConfig_Update''
Goto Finalise
End
-- Validate that the Organsiation exists exist.
If(@organisationID > 0)
begin
If Not Exists(Select * From tblOrganisation Where [OrganisationID] = @OrganisationID)
Begin
Set @intErrorNumber = 2
Set @strErrorMessage = ''The Organisation '' + cast(@OrganisationID as varchar) + '' doesnt exist.''
Goto Finalise
End
end
-- Validate that the Name exists exist.
If Not Exists(Select * From tblOrganisationConfig Where [Name] = @Name)
Begin
Set @intErrorNumber = 21
Set @strErrorMessage = ''The Name '' + @Name + '' doesnt exist.''
Goto Finalise
End

if(@organisationID > 0)
begin
Begin
INSERT INTO [tblOrganisationConfig]
([OrganisationID], 	[Name], [Description],	[Value])
VALUES
(@OrganisationID,	@Name, @Description,	@Value)
End
end if(@organisationID = 0)
begin
update [tblOrganisationConfig]
set [Value] = @value
where
organisationid is null and
description = @description

end

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
