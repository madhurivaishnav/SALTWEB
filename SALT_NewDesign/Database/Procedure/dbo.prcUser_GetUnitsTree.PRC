SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_GetUnitsTree]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Get all units in the specified organisation
1. Preselect the unitID that the user belongs to
2. Expand the unit branch to the unitID that the user belongs to
3. Disable units that the admin user don''t have permission to admin


Returns:
Flat hierarchy table


Called By:
Calls:

Remarks:

Author:
Jack Liu
Date Created: 6 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


prcUser_GetUnitsTree 46, 5


**/

CREATE  PROC [prcUser_GetUnitsTree]
(
@userID int,
@adminUserID int
)

AS

set nocount on

declare @intOrganisationID int, @intUnitID int, @strHierarchy varchar(100)
declare @intAdminUserTypeID int

declare @strSelectedUnitIDs varchar(4000)
declare @strExpandedUnitIDs varchar(4000)
declare @strDisabledUnitIDs varchar(4000)

select 	@intOrganisationID = OrganisationID,
@intUnitID = UnitID
from tblUser
where userID = @userID


--1. Preselect the unitID that the user belongs to
set @strSelectedUnitIDs = cast(@intUnitID as varchar)

--2. Expand the unit branch to the unitID that the user belongs to
select @strHierarchy = Hierarchy
from tblUnit
where UnitID = @intUnitID

select 	@strExpandedUnitIDs= isNull(@strExpandedUnitIDs + '','','''')+  cast(tblUnit.unitID as varchar)
from 	tblUnit
where 	(tblUnit.organisationID=@intOrganisationID)
and charindex(tblUnit.hierarchy +'','', @strHierarchy)=1


--3. Disable units that the admin user don''t have permission to admin
select @intAdminUserTypeID = UserTypeID
from tblUser
where userID = @adminUserID

declare  @EnableUnit  table
(
UnitID int
)

--Salt Administrator, Organisation Administrator has permission to access all units
if (@intAdminUserTypeID=1 or @intAdminUserTypeID=2)
begin
insert 	into @EnableUnit(UnitID)
select 	u.UnitID
from 	tblUnit as u
where 	(u.organisationID=@intOrganisationID)
end
--A: Unit Administrator only has permission to those that he is administrator
else
begin
--Get a list of unit id that the user is  the administrator
insert into @EnableUnit(UnitID)
select 	u.UnitID
from 	tblUnit as u
inner join tblUnitAdministrator as ua
on (u.unitID=ua.unitID)
and (ua.userID = @adminUserID)
where 	(u.organisationID=@intOrganisationID)

end

--Get a list of unit id that the user don''t have permission
select 	@strDisabledUnitIDs= isNull(@strDisabledUnitIDs + '','','''')+ cast(u.unitID as varchar)
from 	tblUnit as u
left join @EnableUnit as eu
on (u.unitID=eu.unitID)
where 	(u.organisationID=@intOrganisationID)
and eu.UnitID is null



exec prcUnit_GetUnitsByOrganisation @intOrganisationID, @strDisabledUnitIDs, @strSelectedUnitIDs,@strExpandedUnitIDs






' 
END
GO
