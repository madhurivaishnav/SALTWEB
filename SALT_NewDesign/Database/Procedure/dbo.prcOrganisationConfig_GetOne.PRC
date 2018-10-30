SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisationConfig_GetOne]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


/*
Summary: Get a single client configuration values
Parameters:
Returns:

Called By:
Calls:

Remarks:

Author: Peter Kneale
Date Created: 16 August 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE Procedure [prcOrganisationConfig_GetOne]
@organisationID 	Int,
@name			nVarchar(255)
As

Set Nocount On

If Exists (Select OrganisationID From tblOrganisationConfig Where OrganisationID = @organisationID And [Name]	= @Name)
Begin
Select
[Value]
From
tblOrganisationConfig
Where
OrganisationID	= @organisationID
And
[Name]		= @Name
Order by
[Name]
End
Else
Begin
Select
[Value]
From
tblOrganisationConfig
Where
OrganisationID	= null
And
[Name]		= @Name
Order by
[Name]
End


' 
END
GO
