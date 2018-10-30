SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPolicy_GetAcceptedUsers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:
Stored procedure to obtain the number of users who have accepted the policy
i.e. been allocated points for policy in current profile period

Parameters:
@OrganisationID int
@PolicyID int

Called By:

Author: Aaron Cripps
Date Created: June 2008

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

*/
create procedure [prcPolicy_GetAcceptedUsers]
(
@OrganisationID int,
@PolicyID int
)
as

select count(*) from
tblPolicy pol
join tblUserPolicyAccepted upa
on pol.PolicyID = upa.PolicyID
join tblUser u
on u.UserID = upa.UserID
where pol.PolicyID = @PolicyID
and pol.OrganisationID = @OrganisationID
and upa.Accepted = 1
and u.Active = 1

' 
END
GO
