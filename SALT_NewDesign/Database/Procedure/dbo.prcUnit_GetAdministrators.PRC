SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUnit_GetAdministrators]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Get a list of existing unit administrators for a unit.
Returns:
Nothing.

Called By:
Unit Class.

Calls:
Nothing
Remarks:
1. Permission Checking:

Exception:


Author: Jack Liu
Date Created: 12 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


prcUnit_GetAdministrators 1

**/
CREATE PROCEDURE [prcUnit_GetAdministrators]
(
@unitID	int
)

AS

set nocount on

Select 	u.UserID,
u.UserName,
u.FirstName,
u.LastName,
u.Email,
u.Active
from tblUnitAdministrator ua
inner join tblUser u on ua.userID = u.UserID
where ua.unitID=@unitID
and u.usertypeID=3 --Unit administrator(3)
order by u.LastName




' 
END
GO
