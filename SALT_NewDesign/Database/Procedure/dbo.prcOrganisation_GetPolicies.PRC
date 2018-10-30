SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisation_GetPolicies]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Get''s a list of policies for an organisation

Parameters:
@OrganisationID int,

Returns:
Nothing

Called By:
Policy.cs.

Calls:
Nothing

Remarks:
None

Author: Aaron Cripps
Date Created: June 2008

Modification History
-----------------------------------------------------------
v#	Author		Date			Description

**/

create procedure [prcOrganisation_GetPolicies]
(
@OrganisationID int
)
as

select
PolicyID,
PolicyName,
Active,
PolicyFileName,
PolicyFileSize
from tblPolicy
where
OrganisationID = @OrganisationID
and deleted = 0
order by PolicyName

' 
END
GO
