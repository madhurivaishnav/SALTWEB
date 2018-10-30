SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUnit_GetAdministratorsEmailAddress]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'




CREATE PROCEDURE [prcUnit_GetAdministratorsEmailAddress]
(
@unitID	int
)

AS

select coalesce(
-- try to get the closest unit admin then search further afield
(Select top 1	u.Email
from tblUnitAdministrator ua
inner join tblUser u on ua.userID = u.UserID
where ua.unitID=@unitID
and u.usertypeID=3 --Unit administrator(3)
and u.unitID=@unitID
and u.Email is not null),


(Select top 1	u.Email
from tblUnitAdministrator ua
inner join tblUser u on ua.userID = u.UserID
where ua.unitID=@unitID
and u.usertypeID=3 --Unit administrator(3)
and u.Email is not null),

(Select top 1	u.Email
from tblUser u inner join tblUnit un on un.OrganisationID = u.OrganisationID
where un.unitID=@unitID
and UserTypeID = 2
and Email is not null),


(Select top 1	u.Email
from tblUser u inner join tblUnit un on un.OrganisationID = u.OrganisationID
where un.unitID=@unitID
and UserTypeID = 1
and Email is not null),

--all else failed so get the salt admin
(Select top 1	u.Email
from tblUser u
where UserTypeID = 1
and Email is not null))




' 
END
GO
