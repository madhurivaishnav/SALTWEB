SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUnit_GetPermission]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Get unit administering permission
Returns:
Nothing.

Called By:
Unit Class.

Calls:
Nothing
Remarks:



Author: Jack Liu
Date Created: 18 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

**/
CREATE PROCEDURE [prcUnit_GetPermission]
(
@unitID		int,
@adminUserID 	int,
@permission  	char(1)=null output
)

AS

set nocount on

Declare @intUnitOrganisationID int
declare @intUserTypeID int, @intUserOrganisationID int


select @intUnitOrganisationID = OrganisationID
from tblUnit
where UnitID=@unitID

select @intUserTypeID = UserTypeID,
@intUserOrganisationID = OrganisationID
from tblUser
where userID = @adminUserID


if (@intUnitOrganisationID is not null)
begin
--1. Salt Admin
if (@intUserTypeID=1)
begin
select @permission = ''F''
end
--2. Org admin
else if (@intUserTypeID=2)
begin
--If the admin user is in the same organisation as the unit, it has Full permission
--otherwise no permission
if (@intUnitOrganisationID = @intUserOrganisationID)
select @permission = ''F''
else
select @permission = ''''
end
--3. Unit admin, User must be administrator of that unit
else if (@intUserTypeID=3)
begin
select @permission =
case
when Propagate = 0 then ''A''
when Propagate =1 then ''P''
else ''''
end
from tblUnitAdministrator
where UnitID =@unitID
and UserID =@adminUserID
end
end

if (@permission is null)
select @permission = ''''
' 
END
GO
