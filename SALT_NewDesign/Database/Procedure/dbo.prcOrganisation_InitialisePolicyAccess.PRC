SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisation_InitialisePolicyAccess]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Set''s Granted value in tblUnitPolicyAccess and tblUserPolicyAccess when
the Policy is intitially created

Parameters:
@organisationID Integer	,
@PolicyID Integer

Returns:
Nothing

Called By:
Policy.cs.

Calls:
Nothing

Remarks:

Author: Aaron Cripps
Date Created: Feb 2009

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

**/
CREATE    Procedure [prcOrganisation_InitialisePolicyAccess]
(
@organisationID Integer,
@PolicyID Integer,
@granted bit
)

As

Set NoCount On

-- Get all units for this organisation
create table #OrgUnits
(
UnitID int
)

insert into #OrgUnits
select
unitid
from
tblUnit
where
OrganisationID = @OrganisationID
and active = 1
-- Insert all unitid''s into tblUnitProfilePeriodAccess with
-- initial granted value of 0 (not granted)

Insert into tblUnitPolicyAccess
select @PolicyID, UnitID, @granted from #OrgUnits
where unitid not in
(select unitid from tblUnitPolicyAccess where Unitid in
(select unitid from tblUnit where organisationid = @organisationid)
and policyid = @policyid)


drop table #OrgUnits

-- Get all users for this organisation
create table #OrgUsers
(
UserID int
)

insert into #OrgUsers
Select
UserID
From
tblUser
Where
OrganisationID = @organisationID



-- Insert all userid''s not already added into tblUserProfilePeriodAccess
Insert into tblUserPolicyAccess
select @PolicyID, UserID, @granted from #OrgUsers
where userid not in
(select userid from tblUserPolicyAccess where userid in
(select userid from tblUser where organisationid = @organisationid)
and policyid = @policyid)


-- update any users that were already existing
update tblUserPolicyAccess
set granted = @granted
where policyid = @policyid
and userid in (select userid from tbluser where organisationid = @organisationid)

drop table #OrgUsers

' 
END
GO
