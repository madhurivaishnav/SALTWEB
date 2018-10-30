SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisationConfig_GetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



/*
Summary: Get a list of client configuration values
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

CREATE   Procedure [prcOrganisationConfig_GetList]
@organisationID 	Int = 0
As

Set Nocount On


if(@organisationID > 0)
begin
-- This returns the specific org values
Select
0 as ''Default'',
[Name],
[Description],
[Value]
From
tblOrganisationConfig
Where
OrganisationID = @organisationID
UNION
-- And unions it with the default ones.
Select
-1 as ''Default'',
[Name],
[Description],
[Value]
From tblOrganisationConfig

Where Name not in
(
select [Name] from tblOrganisationConfig where organisationID = @organisationID
)
And
OrganisationID is Null
-- do the filter to not show some of the config
and [Name] not in
(
''Ebook_NewUpdate_Subject'',
''Ebook_NewUpdate_Body''
)
Order By
[Name]
end
else if(@organisationID = 0)
begin

Select
[Name],
[Description],
[Value]
From
tblOrganisationConfig
Where
organisationID is null
and name not in
(
''ShowDetailedHelp'',
''css'',
''Number_Of_Quiz_Questions''
)
Order By
[Name]

end



' 
END
GO
