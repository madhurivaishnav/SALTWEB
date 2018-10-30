SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisation_CheckUserRole]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Check user role for one organisation,


Returns:
none


Called By:
Calls:

Remarks:
The user role may be changed due to permission changes, it may be inconsistent with the other data

This procedure will check the permission and guarantee the roles are correct.


Author: Jack Liu
Date Created: 12 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


prcOrganisation_CheckUserRole 3



**/

CREATE  PROCEDURE [prcOrganisation_CheckUserRole]
(
@organisationID  int=null
)
as
set nocount on

--1. Salt Admin(1) or Org Admin (2)
-- Remove Unit Administrator permission because these two roles have full permission to all units
delete tblUnitAdministrator
from tblUnitAdministrator ua
inner join tblUser u on ua.userID=u.UserID
where ((u.organisationID = @organisationID)
or (@organisationID is null))
and u.UserTypeID in (1,2) --Salt Admin or Org Admin

--2. Unit Administrator(3)
--Change User role to Unit Administrator(3) if a Salt User(4) manage some units
Update tblUser
set UserTypeID=3
from tblUser u
inner join tblUnitAdministrator ua on ua.userID=u.UserID
where ((u.organisationID = @organisationID)
or (@organisationID is null))
and u.UserTypeID=4 --Salt user


--3. Salt User (4)
--Change User role to Salt User(4) if a Unit Administrator(3) no longer manages any units
Update tblUser
set UserTypeID=4
from tblUser u
left join tblUnitAdministrator ua on ua.userID=u.UserID
where ((u.organisationID = @organisationID)
or (@organisationID is null))
and u.UserTypeID=3 --Unit Administrator
and ua.unitID is null



' 
END
GO
