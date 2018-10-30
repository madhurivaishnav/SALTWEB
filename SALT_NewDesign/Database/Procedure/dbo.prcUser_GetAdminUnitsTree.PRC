SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_GetAdminUnitsTree]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
This is a hierarchical list of the Units that this user has Unit Administrator rights to.
It is for display-only.


Returns:
Flat hierarchy table


Called By:
Calls:

Remarks:

Author:
Jack Liu
Date Created: 17 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


prcUser_GetAdminUnitsTree 143


**/

CREATE PROC [prcUser_GetAdminUnitsTree]
(
@userID int
)

AS

set nocount on

declare @intOrganisationID int
/*
declare @strSelectedUnitIDs varchar(4000)
declare @strExpandedUnitIDs varchar(4000)
declare @strDisabledUnitIDs varchar(4000)
*/
select 	@intOrganisationID = OrganisationID
from tblUser
where userID = @userID


/*
--1. Get a list of unit id that the user has permission
select 	@strSelectedUnitIDs= isNull(@strSelectedUnitIDs + '','','''')+ cast(u.unitID as varchar)
from 	tblUnit as u
inner join tblUnitAdministrator as ua
on (u.unitID=ua.unitID)
and (ua.userID = @userID)
where 	(u.organisationID=@intOrganisationID)


--2. Expand the unit branch to the unitID that has admin permission
select 	@strExpandedUnitIDs= isNull(@strExpandedUnitIDs + '','','''')+  cast(tblUnit.unitID as varchar)
from 	tblUnit
where 	(tblUnit.organisationID=@intOrganisationID)
and exists (select U.UnitID
from 	tblUnit as u
inner join tblUnitAdministrator as ua
on (u.unitID=ua.unitID)
and (ua.userID = @userID)
where 	(u.organisationID=@intOrganisationID)
and charindex(tblUnit.hierarchy +'','', u.hierarchy)=1
) --Get units whose child units can be administered

--select @strExpandedUnitIDs

--3. Disable the whole tree
select 	@strDisabledUnitIDs= isNull(@strDisabledUnitIDs + '','','''')+  cast(u.unitID as varchar)
from 	tblUnit as u
where 	(u.organisationID=@intOrganisationID)


exec prcUnit_GetUnitsByOrganisation @intOrganisationID, @strDisabledUnitIDs, @strSelectedUnitIDs,@strExpandedUnitIDs
*/

select
un.unitid ''UnitID'',
un.parentunitid ''ParentUnitID'',
un.name ''Name'',
case when ua.unitid is null then 1 else 0 end ''Disabled'',
case when ua.unitid is null then 0 else 1 end ''Selected'',
case when un2.unitid is null then 0 else 1 end ''Expanded''
from tblUnit un
left join tblUnitAdministrator ua
on un.unitid=ua.unitid and ua.userid=@userid
left join
(
select un.* from tblUnit un
inner join tblUnitAdministrator ua
on un.unitid=ua.unitid
where
ua.userid=@userid
) un2
on charindex(un2.hierarchy +'','', un.hierarchy)=1
where un.organisationid=@intOrganisationID
and un.active=1
order by un.hierarchy' 
END
GO
