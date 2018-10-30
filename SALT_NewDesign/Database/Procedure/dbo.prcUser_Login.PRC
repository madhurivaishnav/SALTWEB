SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_Login]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*Summary:
Authenticate user
Password and user status will be checked in the application
Returns:
UserID, User Password, status, UserType, OrgID

Called By: Login.ascx
Calls:

Remarks:
User Password and status are used to authenticate used in the application
UserID, UserType, OrgID, OrgLogo are used as user context. these values will be saved in the form authentication ticket

Author:
Jack Liu
Date Created: 27 Jan 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	Jack Liu	14/09/2005		Add domain Name to the organisation
The domain Name is unique to each organisation
if the user name can''t be found in that organisation, search if that user is a salt administrator
prcUser_Login ''Jack'', ''Organisation1.salt.devbdw.com''

prcUser_Login ''SaltAdmin'', ''Organisation1.salt.devbdw.com''


**/

CREATE  PROC [prcUser_Login]
(
@userName  nVARCHAR(50),
@domainName nvarchar(100)
)

AS

set nocount on
if exists (select 1
from tblUser u
inner join tblOrganisation o on u.OrganisationID = o.OrganisationID and o.domainName = @domainName
where (u.username=@userName)
)
begin
select top 1
u.UserID,
u.UserTypeID,
u.Password,
u.Active,
u.OrganisationID,
u.LoginFailCount,
o.Logo,
o.AdvancedReporting,
o.PasswordLockout
from tblUser u
inner join tblOrganisation o on u.OrganisationID = o.OrganisationID and o.domainName = @domainName
where (u.username=@userName)
end
else
begin
select top 1
u.UserID,
u.UserTypeID,
u.Password,
u.Active,
u.OrganisationID,
u.LoginFailCount,
o.Logo,
o.AdvancedReporting,
o.PasswordLockout
from tblUser u
left join tblOrganisation o on u.OrganisationID = o.OrganisationID
where (u.username=@userName) and (u.UserTypeID=1)
end

' 
END
GO
