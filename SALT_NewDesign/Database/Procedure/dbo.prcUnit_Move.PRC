SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUnit_Move]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
Move a  unit to a new parent
Returns:
Nothing.

Called By:
Unit Class.

Calls:
Nothing
Remarks:
1. Permission Checking:
1.1. "From" unit permision: Administrator of this unit and all sub-units
1.2. "To" unit permision: "Propagate" administrator of this unit

2. Validation:
2.1. "From" unit is not the same as "To" unit
2.2. "From" and "To" unit are in the same organisation
2.3. "From" unit is not the parent of "To" unit
2.4  "To" unit is the direct parent of "From" unit


Moving permissions:
When a Unit is moved into to another Unit, all of its current administrators will be removed,
and it will inherit its new administrators from its new place in the hierarchy,
according to the "Administer Sub-units" rights of the existing administrators.



Exception:
0. Succeed
1. RecordNotFound
2. FK constraint
3. PKViolationException
4. UniqueViolationException
10.BusinessServiceException (General)


Author: Jack Liu
Date Created: 11 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

**/
CREATE PROCEDURE [prcUnit_Move]
(
@fromUnitID	int,
@toUnitID	int,
@adminUserID 	int
)

AS

set nocount on

set xact_abort on
Begin Tran
declare @strErrorMessage varchar(500)
declare @intErrorNumber int

declare @intUserTypeID int

declare @intFromOrganisationID int, @intToOrganisationID int
declare @strFromHierarchy nvarchar(500),@strToHierarchy nvarchar(500)
declare @intFromParentUnitID int

select @intUserTypeID = UserTypeID
from tblUser
where userID = @adminUserID

select @intFromOrganisationID = OrganisationID,
@strFromHierarchy = Hierarchy,
@intFromParentUnitID = parentUnitID
from tblUnit
where unitID=@fromUnitID

select @intToOrganisationID = OrganisationID,
@strToHierarchy = Hierarchy
from tblUnit
where unitID=@toUnitID


set @strErrorMessage=''''

-------------- 1. Permission Checking ----------------

--Salt Administrator (1), Organisation Administrator (2): full permission to access all units
--Salt User (4): No permission
if (@intUserTypeID=4)
begin
set @strErrorMessage = ''You are not the administrator of the system''
set @intErrorNumber = 1
end
--Unit Administrator (3): limited permission
else if (@intUserTypeID=3)
begin
--	1.1. "From" unit permision: Administrator of this unit and all sub-units
if 	exists(select su.unitid
from tblUnit su --sub-units
left join tblUnitAdministrator ua
on su.unitID=ua.unitID
and ua.userID = @adminUserID
where su.hierarchy+'','' like @strFromHierarchy+'',%'' --"From" Unit and all its sub-units
and ua.unitID is null)	--Not administrator
begin
set @strErrorMessage = ''You are not administrator of the "From" unit and all its sub-units''
set @intErrorNumber = 11
end
--	1.2. "To" unit permision: "Propagate" administrator of this unit
else 	if not exists(select unitid from tblUnitAdministrator where unitID=@toUnitID and userID = @adminUserID and propagate=1)
begin
set @strErrorMessage = ''You don''''t have permission to administer sub-units of the "To" unit''
set @intErrorNumber = 12
end
end

-----------------2. Validation -----------------------------
if (@strErrorMessage='''')
begin
--	2.1. "From" unit is not the same as "To" unit
if (@fromUnitID=@toUnitID)
begin
set @strErrorMessage = ''The "From" unit can''''t be the same as the "To" unit''
set @intErrorNumber = 13
end
--	2.2. "From" and "To" unit are in the same organisation
else if (@intFromOrganisationID<>@intToOrganisationID)
begin
set @strErrorMessage = ''The "From" and the "To" unit should be in the same organisation''
set @intErrorNumber = 14
end
--	2.3. "From" unit is not the parent of "To" unit
else if (charindex( @strFromHierarchy+'','', @strToHierarchy)=1)
begin
set @strErrorMessage = ''The "From" unit can''''t be the parent of the "To" unit''
set @intErrorNumber = 15
end
--	2.4  "To" unit is the direct parent of "From" unit
else if (@intFromParentUnitID=@toUnitID)
begin
set @strErrorMessage = ''The "To" unit can''''t be the direct parent of the "From" unit''
set @intErrorNumber = 16
end
end

if (@strErrorMessage='''')
begin
--1. Update hierarchy and rebuild the unit tree
Update tblUnit
set parentUnitID=@toUnitID,
UpdatedBy = @adminUserID,
DateUpdated = getutcdate()
where unitID=@fromUnitID

exec prcOrganisation_CheckUnitTree @intToOrganisationID

--2. Moving permissions
--2.1 Get the new hierarchy
select 	@strFromHierarchy = Hierarchy
from tblUnit
where unitID=@fromUnitID
--2.2 Remove all current administrators from the unit and  its sub-units
Delete
from tblUnitAdministrator
where unitID in (select unitID
from tblUnit
where hierarchy+'','' like @strFromHierarchy+'',%'') --Current Unit and its sub-units


--2.3 Propagate all unit admininstrators from parent (with propagate flag)
insert into tblUnitAdministrator(UnitID, UserID, Propagate, createdBy)
select 	u.UnitID, ua.UserID, 1 , @adminUserID
from 	tblUnitAdministrator ua
cross join  tblUnit u
where 	ua.unitID = @toUnitID
and ua.Propagate=1
and u.hierarchy+'','' like @strFromHierarchy+'',%''

--2.4 Check and Update user role
exec prcOrganisation_CheckUserRole @intToOrganisationID

select 0 as Error, '''' as ErrorMessage
end
else
begin
select @intErrorNumber as Error,  @strErrorMessage as ErrorMessage
end

commit TRAN
' 
END
GO
