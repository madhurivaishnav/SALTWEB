SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_GetPermission]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Get user administering permission
Returns:
Nothing.

Called By:
User Class.

Calls:
Nothing
Remarks:



Author: Jack Liu
Date Created: 09 Mar 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

**/
CREATE PROCEDURE [prcUser_GetPermission]
(
@userID		int,
@adminUserID 	int,
@permission  	char(1)=null output
)

AS

set nocount on

Declare @intUserOrganisationID int, @intUserUnitID int
declare @intAdminUserTypeID int, @intAdminUserOrganisationID int


select @intUserOrganisationID = OrganisationID,
@intUserUnitID = UnitID
from tblUser
where UserID=@userID

select @intAdminUserTypeID = UserTypeID,
@intAdminUserOrganisationID = OrganisationID
from tblUser
where userID = @adminUserID


set @permission=''''
--1. Salt Admin
if (@intAdminUserTypeID=1)
begin
select @permission = ''S''
end
--2. Org admin
else if (@intAdminUserTypeID=2)
begin
--If the admin user is in the same organisation as the user, it has Full permission
--otherwise no permission
if (@intUserOrganisationID = @intAdminUserOrganisationID)
select @permission = ''F''
else
select @permission = ''''
end
--3. Unit admin, User must be administrator of that unit
else if (@intAdminUserTypeID=3)
begin
if exists(
select 1
from tblUnitAdministrator
where UnitID =@intUserUnitID
and UserID =@adminUserID)
select @permission = ''F''
else
select @permission = ''''
end

if (@permission is null)
select @permission = ''''


' 
END
GO
