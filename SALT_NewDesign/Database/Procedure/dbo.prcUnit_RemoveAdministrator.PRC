SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUnit_RemoveAdministrator]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Remove a unit administrator from a unit.

They will also be removed from any sub-units that they had administrator rights to
by virtue of any Administer sub-units functions.

Returns:
Nothing.

Called By:
Unit Class.

Calls:
Nothing
Remarks:
1. Permission Checking:
1.1. "From" unit permision: Administrator of this unit and all sub-units


Their user role will also change back to that of SALT User, if they no longer manage any Units.

Exception:
0: Succeed
1.RecordNotFound
2.FK constraint
3.PKViolationException
4.UniqueViolationException
10.BusinessServiceException (General)


Author: Jack Liu
Date Created: 11 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

prcUnit_RemoveAdministrator 14, 46, 46
**/
CREATE PROCEDURE [prcUnit_RemoveAdministrator]
(
@unitID	int,
@removedUserID	int,
@adminUserID 	int
)

AS

set nocount on

set xact_abort on
Begin Tran
declare @strErrorMessage varchar(500)

declare @intUserTypeID int

select @intUserTypeID = UserTypeID
from tblUser
where userID = @adminUserID

set @strErrorMessage=''''

-------------- 1. Permission Checking ----------------
--Salt Administrator (1), Organisation Administrator (2): full permission to access all units
--Salt User (4): No permission
if (@intUserTypeID=4)
begin
set @strErrorMessage = ''You are not the administrator of the system''
end
--Unit Administrator (3): limited permission
--else if (@intUserTypeID=3)
--begin
--	 --Unit Administrator (3): limited permission
--
--end

if @strErrorMessage=''''
begin

declare @blnPropagate bit, @strHierarchy varchar(100), @intLevel int, @intOrganisationID int

select @blnPropagate =ua.propagate,
@strHierarchy =u.Hierarchy,
@intLevel = u.[Level],
@intOrganisationID = u.OrganisationID
from tblUnit u
inner join tblUnitAdministrator ua
on u.UnitID=ua.UnitID and ua.userID=@removedUserID
where u.unitID = @unitID
--1. Remove this administrator from the specified Unit
--1.1 Can''t administer sub-units, just remove from this unit
if (@blnPropagate=0)
begin
Delete
from tblUnitAdministrator
where unitID = 	@unitID
and	UserID = @removedUserID
end
--1.2 Can administer sub-units, remove from all sub-units
else if (@blnPropagate=1)
begin
/*
They will also be removed from any sub-units that they had administrator rights to
by virtue of any "Administer sub-units" functions.
*/
delete tblUnitAdministrator
from tblUnitAdministrator cua --child unit administrator
inner join tblUnit cu --child unit
on cu.UnitID=cua.UnitID and cua.userID=@removedUserID and cua.propagate=1
where 	charindex(@strHierarchy+'','', cu.hierarchy+'','')=1
--Administrator(propagate flag) of all parent units(up to current unit) of a child unit
and not exists(
select pua.*
from tblUnit pu --parent unit
left join tblUnitAdministrator pua --Parent Unit Administrator
on pu.UnitID=pua.UnitID and pua.userID=@removedUserID and pua.propagate=1
where charindex(pu.hierarchy+'','',  cu.hierarchy+'','')=1 --parent unit of a child unit
and pu.level>=@intLevel --Up to the current unit
and pua.UnitID is null) -- Administrator
end


/*
Their user role will also change back to that of SALT User, if they no longer manage any Units.
*/

--2. Check and Update user role
exec prcOrganisation_CheckUserRole @intOrganisationID

select 0 as Error,  '''' as ErrorMessage
end
else
begin
select 10 as Error,  @strErrorMessage as ErrorMessage
end

commit TRAN
' 
END
GO
