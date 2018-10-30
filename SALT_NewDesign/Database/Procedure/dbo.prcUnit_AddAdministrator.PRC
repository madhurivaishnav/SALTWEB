SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUnit_AddAdministrator]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:
Add a user as administrator of a unit
and all sub units (if the "administer sub-units" is flaged)

Called By: Unit.cs
Calls: None

Remarks:
"Administer Sub-units" checkbox
When this is flagged for a Unit Administrator, it means they will automatically also become a Unit Administrator privileges to all Sub-Units (and sub-sub-units etc) within this Unit.

Changing User Statuses
When a SALT User is selected as an Administrator of a Unit, their User Role is updated to Unit Administrator.



Author: Jack Liu
Date Created: 10th of February 2004

prcUnit_GetOne 5

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

prcUnit_AddAdministrator 1, 46,1,46

*/

CREATE  Procedure [prcUnit_AddAdministrator]
(
@unitID Int,
@userID int,
@adminSubUnit bit,
@adminUserID int
)

As

set nocount on


set xact_abort on
Begin Tran

declare @strHierarchy varchar(100), @intLevel int, @intOrganisationID int

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


if @strErrorMessage=''''
begin
select 	@strHierarchy =u.Hierarchy,
@intLevel = u.[Level],
@intOrganisationID = u.OrganisationID
from tblUnit u
where u.unitID = @unitID


--Remove existing permissions for this user
--1. If the new permission is administer sub-units, remove existing permissions from all sub-units
if (@adminSubUnit=1)
begin
delete tblUnitAdministrator
from tblUnitAdministrator ua
inner join tblUnit u
on ua.UnitID=u.UnitID
where ua.UserID=@userID
and charindex(@strHierarchy+'','', u.hierarchy+'','')=1

insert into tblUnitAdministrator(UnitID, UserID,propagate, CreatedBy)
select unitID, @userID, 1, @adminUserID
from tblUnit u
where charindex(@strHierarchy+'','', u.hierarchy+'','')=1
end
--2. If the new permission is only applied to this units(Not administer sub-units), remove existing permissions from all sub-units only it is flaged to "Propagate"
else
begin
exec prcUnit_RemoveAdministrator @unitID, @userID, @adminUserID
insert into tblUnitAdministrator(UnitID, UserID,propagate, CreatedBy)
values( @unitID, @userID,0, @adminUserID)
end

--Changing User Statuses
--When a SALT User is selected as an Administrator of a Unit, their User Role is updated to "Unit Administrator".
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
