SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUnit_Create]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
Add a unit.
Returns:
Nothing.

Called By:
Unit Class.

Calls:
Nothing
Remarks:
--Create a unit
--Propagate all unit admininstrators from parent (with propagate flag)

Validation:
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

**/
CREATE PROCEDURE [prcUnit_Create]
(
@organisationID	int,
@parentUnitID	int,
@name 	nvarchar(100),
@active	bit,
@createdByUserID int
)

AS

set nocount on

set xact_abort on
Begin Tran
--Validation
declare @strErrorMessage varchar(500)

declare @blnParentStatus bit
declare @strParentHierarchy varchar(500)
declare @intParentLevel int

declare @intUnitID int

set @strErrorMessage=''''

if (@parentUnitID<=0)
set @parentUnitID=null

--Create sub-unit
if (@parentUnitID>0)
begin
select @blnParentStatus = active,
@strParentHierarchy=  Hierarchy,
@intParentLevel = [level]
from tblUnit
where UnitID = @parentUnitID

--If parent unit is inactive, the new unit must be inactive
if (@blnParentStatus=0 and @active=1)
Begin
if exists(select UnitID from tblUnit where unitID=@parentUnitID  and active=0)
BEGIN
set @strErrorMessage = ''You cannot create an active unit whose parent unit is inactive.''
end
end
end
--Create top level unit
else
begin
set @strParentHierarchy= null
set @intParentLevel = 0

end

if (@strErrorMessage='''')
begin
--1. Create a unit
Insert into tblUnit(OrganisationID, ParentUnitID, Name, [Level], active,  createdBy, dateCreated, DateUpdated)
values	(@organisationID, @parentUnitID, @name, @intParentLevel+1,@active, @createdByUserID, getutcdate(), getutcdate())

set @intUnitID=@@identity
update tblUnit
set Hierarchy = IsNull(@strParentHierarchy + '','','''') + cast(@intUnitID as varchar)
where UnitID=@intUnitID
--2. Propagate all unit admininstrators from parent (with propagate flag)
insert into tblUnitAdministrator(UnitID, UserID, Propagate, createdBy, DateCreated)
select @intUnitID, UserID, 1 , @createdByUserID, getutcdate()
from tblUnitAdministrator
where unitID = @parentUnitID
and Propagate=1

select 0 as Error, cast(@intUnitID as varchar) as ErrorMessage
end
else
begin
select 10 as Error,  @strErrorMessage as ErrorMessage
end

commit TRAN

-- Get ProfilePeriodID''s for Organisation
create table #ProfilePeriod
(
ProfilePeriodID int
)

insert into #ProfilePeriod
select ProfilePeriodID
from tblProfilePeriod  pp
join tblprofile p
on pp.profileid = p.profileid
where p.organisationid = @OrganisationID

-- insert unit into profileperiodaccess against all profileperiodid''s
-- for the organisation
insert into tblUnitProfilePeriodAccess
select ProfilePeriodID, @intUnitID, 0 from #ProfilePeriod

drop table #ProfilePeriod

-- is a child unit
if (@parentUnitID <> 0)
begin
--	 get list of profile periods the parent unit has access to
create table #ProfilePeriodTemp
(
ProfilePeriodID int
)

insert into #ProfilePeriodTemp
select ProfilePeriodID from tblUnitProfilePeriodAccess
where UnitID = @parentUnitID
and Granted = 1

--	 set profile period access for these units
update tblUnitProfilePeriodAccess set granted = 1
where UnitID = @intUnitID
and ProfilePeriodID in (select ProfilePeriodID from #ProfilePeriodTemp)

drop table #ProfilePeriodTemp
end
' 
END
GO
