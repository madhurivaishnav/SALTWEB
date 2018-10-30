SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPolicy_CheckPolicyName]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:
Stored procedure to check if a Policy with the same name
as that being created already exists

Parameters:
@OrganisationID int
@PolicyName nvarchar(255)

Called By:
policydetails.aspx

Author: Aaron Cripps
Date Created: June 2008

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

*/
create procedure [prcPolicy_CheckPolicyName]
(
@OrganisationID int,
@PolicyName nvarchar(255)
)
as

select PolicyName
from tblPolicy
where OrganisationID = @OrganisationID
and PolicyName = @PolicyName
and deleted = 0

' 
END
GO
