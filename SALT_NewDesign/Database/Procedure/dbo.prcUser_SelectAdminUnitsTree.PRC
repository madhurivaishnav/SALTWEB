SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_SelectAdminUnitsTree]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROC [prcUser_SelectAdminUnitsTree]
(
@userID Integer
)

AS

set nocount on

declare @intOrganisationID int

declare @strSelectedUnitIDs varchar(4000)
declare @strExpandedUnitIDs varchar(4000)
declare @strDisabledUnitIDs varchar(4000)

select 	@intOrganisationID = OrganisationID
from tblUser
where userID = @userID



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


exec prcUnit_GetUnitsByOrganisation @intOrganisationID, '''', @strSelectedUnitIDs,@strExpandedUnitIDs
' 
END
GO
