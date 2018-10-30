SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUnit_GetAdministrableUnitsByUserID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*Summary:
Get all units administrable by any administrator by the userID

Returns:
Table of unitID''s


Called By:
Calls:

Remarks:

UserTypeID  Type
----------- --------------------------------------------------
1           Salt Administrator
2           Organisation Administrator
3           Unit Administrator
4           User

Author:
Stephen Kennedy-Clark
Date Created: 26 Aug 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


-- prcUnit_GetAdministrableUnitsByUserID 14, 3
-- prcUnit_GetAdministrableUnitsByUserID 1, 3

select * from tblUser

-- select * from tblUnitAdministrator
**/


Create procedure [prcUnit_GetAdministrableUnitsByUserID]
(
@userID int,                      -- Users ID
@organisationID int = null    -- Organisation ID
)

as
set nocount on

Declare @intUserTypeID int -- Users (Administrator) Type




-- Get the Users (Administrator) Type
select
@intUserTypeID = UserTypeID
From
tblUser
where
UserID = @userID

-------------------------------------------------------------------------
-- If the user is a normal user then they dont have access to anythign
-------------------------------------------------------------------------
if @intUserTypeID = 4 -- user
begin
declare @NullTable table
(
UnitID int
)
select UnitID from @NullTable

return 0 -- exit proceadure with sucess
end


-------------------------------------------------------------------------
-- If the user is a salt administrator then they have access to everything
-------------------------------------------------------------------------
if @intUserTypeID = 1 -- Salt Administrator
begin
select UnitID from tblUnit where Organisationid = isnull(@organisationID, organisationid)

return 0  -- exit proceadure with sucess
end


-------------------------------------------------------------------------
-- If the user is an organisation administrator then they have access to
-- all units in their org
-------------------------------------------------------------------------
if @intUserTypeID = 2 -- Organisation Administrator
begin
select
tblUnit.UnitID
from
tblUnit
--< as an xtra security check ensure that the Org admin is in the organisation >--
inner join tblUser
on tblUnit.OrganisationID = tblUser.OrganisationID
and tblUser.UserID = @userID
and tblUser.OrganisationID = @organisationID

return 0  -- exit proceadure with sucess
end

-------------------------------------------------------------------------
-- If the user is an Unit administrator then they have access to units
-- defined in tblUnitAdministrator
-------------------------------------------------------------------------
if @intUserTypeID = 3 -- Unit Administrator
begin
select
u.UnitID
from
tblUnit as u
inner join tblUnitAdministrator as ua
on (u.unitID=ua.unitID)
and (ua.userID = @userID)
--< as an xtra security check ensure that the administrator is in the organisation >--
inner join tblUser usr
on u.OrganisationID = usr.OrganisationID
and usr.UserID = @userID
and usr.OrganisationID = @organisationID

return 0  -- exit proceadure with sucess
end


-- code should never get here
declare @strErrorMessage varchar(200)
set @strErrorMessage = ''Procedure prcUnit_GetAdministrableUnitsByUserID encountered the userType ('' + cast(@intUserTypeID as varchar(5)) + '') that should not exist''
RAISERROR (@strErrorMessage, 16, 1)
return 1 -- exit proceadure with error

--<end>--




SET QUOTED_IDENTIFIER ON
' 
END
GO
