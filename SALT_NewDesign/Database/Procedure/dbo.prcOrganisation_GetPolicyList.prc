SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisation_GetPolicyList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Gets a List of Policies for a particular organisation.

Parameters:
@organisationID

Returns:
Nothing

Called By:
Organisation.cs.

Calls:
Nothing

Remarks:
None

Author: Aaron Cripps
Date Created: June 2008

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

**/

CREATE   Procedure [prcOrganisation_GetPolicyList]
(
@organisationID Integer = Null -- ID of the Organisation that you wish to get the Policies for
)

As


select
PolicyID,
PolicyName,
PolicyFileName,
Active
from
tblPolicy pol left join
tblOrganisationPolicyAccess opa on
pol.OrganisationID = opa.OrganisationID
where
pol.OrganisationID = @OrganisationID and	--OrganisationID passed into stored procedure
opa.GrantPolicyAccess = 1					--Organisation has access to policy
and pol.Deleted = 0
' 
END
GO
