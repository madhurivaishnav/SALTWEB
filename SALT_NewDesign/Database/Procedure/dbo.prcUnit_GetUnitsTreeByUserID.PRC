SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUnit_GetUnitsTreeByUserID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*Summary:
Get all units in the specified organisation and can be selected by the specified user

Returns:
Flat hierarchy table


Called By:
Calls:

Remarks:

@permission:
A: [A]dministrator
P: Administrator with [P]ropagating right
S: Administrator of the Unit and all of its [S]ub-units
Empty or null: All units, no permission needed

Author:
Jack Liu
Date Created: 6 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


prcUnit_GetUnitsTreeByUserID 3, 5,''S''


**/

CREATE   PROC [prcUnit_GetUnitsTreeByUserID]
(
@organisationID  int,
@userID int,
@permission char(1)=''A'',
@includingInactiveUnits bit = 0
)

AS

set nocount on

declare @intUserTypeID int
declare @strDisabledUnitIDs varchar(4000)

if @permission is null
set @permission=''''

select @intUserTypeID = UserTypeID
from tblUser
where userID = @userID

declare @EnableUnit table
(
UnitID int
)

--Salt Administrator, Organisation Administrator has permission to access all units
if (@intUserTypeID=1 or @intUserTypeID=2 or @permission='''')
begin
insert 	into @EnableUnit(UnitID)
select 	u.UnitID
from 	tblUnit as u
where 	(u.organisationID=@organisationID)
end
--A: Unit Administrator only has permission to those that he is administrator
else if @permission=''A''
begin
--Get a list of unit id that the user is  the administrator
insert into @EnableUnit(UnitID)
select 	u.UnitID
from 	tblUnit as u
inner join tblUnitAdministrator as ua
on (u.unitID=ua.unitID)
and (ua.userID = @userID)
where 	(u.organisationID=@organisationID)

end
--P: Administrator with [P]ropagating right
else if @permission=''P''
begin
--Get a list of unit id that the user has [P]ropagating right
insert into @EnableUnit(UnitID)
select 	u.UnitID
from 	tblUnit as u
inner join tblUnitAdministrator as ua
on (u.unitID=ua.unitID)
and (ua.userID = @userID)
and (ua.propagate=1)
where 	(u.organisationID=@organisationID)
end
--S: Administrator of the Unit and all of its [S]ub-units
else if @permission=''S''
begin

insert into @EnableUnit(UnitID)
select 	u.UnitID
from 	tblUnit as u
inner join tblUnitAdministrator as ua
on (u.unitID=ua.unitID)
and (ua.userID = @userID)
where 	(u.organisationID=@organisationID)
and not exists(
select su.unitid
from tblUnit su --sub-units
left join tblUnitAdministrator ua
on su.unitID=ua.unitID
and ua.userID = @userID
where su.hierarchy+'','' like u.hierarchy+'',%'' --Current Unit and all sub-units
and ua.unitID is null	--Not administrator
)--Administrator of all sub-units
end

--Get a list of unit id that the user dn''t have permission
select 	@strDisabledUnitIDs= isNull(@strDisabledUnitIDs + '','','''')+ cast(u.unitID as varchar)
from 	tblUnit as u
left join @EnableUnit as eu
on (u.unitID=eu.unitID)
where 	(u.organisationID=@organisationID)
and eu.UnitID is null

-- If @includingInactiveUnits = 1 then return all units even those that are inactive
-- By default only return those that are active
if @includingInactiveUnits = 1
select 
un.unitid ''UnitID'',
un.parentunitid ''ParentUnitID'',
un.name ''Name'',
case when eu.unitid is null then 1 else 0 end ''Disabled'',
0 ''Selected'',
0 ''Expanded''
from tblUnit un
left join @EnableUnit as eu
on (un.unitID=eu.unitID)
where 	(un.organisationID=@organisationID)
order by un.hierarchy

else

select 
un.unitid ''UnitID'',
un.parentunitid ''ParentUnitID'',
un.name ''Name'',
case when eu.unitid is null then 1 else 0 end ''Disabled'',
0 ''Selected'',
0 ''Expanded''
from tblUnit un
left join @EnableUnit as eu
on (un.unitID=eu.unitID)
where 	(un.organisationID=@organisationID)
and un.active=1
order by un.hierarchy









' 
END
GO
