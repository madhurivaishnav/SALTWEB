SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisation_InitialiseProfilePeriodAccess]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Set''s Granted value in tblUnitProfilePeriod and tblUserProfilePeriod when
the Profile is intitially created

Parameters:
@organisationID Integer

Returns:
Nothing

Called By:
Profile.cs.

Calls:
Nothing

Remarks:

Author: Aaron Cripps
Date Created: July 2008

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

**/
CREATE    Procedure [prcOrganisation_InitialiseProfilePeriodAccess]
(
@organisationID Integer,
@ProfileID Integer,
@ProfilePeriodID Integer
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

Insert into tblUnitProfilePeriodAccess
select @ProfilePeriodID, UnitID, 0 from #OrgUnits


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
--	And UnitID Is Not Null
--	And Active = 1

-- Insert all userid''s into tblUserProfilePeriodAccess with
-- initial granted value of 0 (not granted)
Insert into tblUserProfilePeriodAccess
select @ProfilePeriodID, UserID, 0 from #OrgUsers

drop table #OrgUsers

' 
END
GO
