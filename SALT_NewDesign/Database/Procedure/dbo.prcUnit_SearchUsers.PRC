SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUnit_SearchUsers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:
Gets a list of users from a specific Unit which conform to the criteria
and who have a User Role which is lower than or equal to the specified user type id or the logged-in administrator''s user role.

Called By: Unit.cs
Calls: None

Remarks: Raises an error if the parameter is null

Author: Jack Liu
Date Created: 10th of February 2004

prcUnit_GetOne 5

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE  Procedure [prcUnit_SearchUsers]
(
@unitID Int,
@firstName nvarchar(50),
@lastName nvarchar(50),
@userTypeID int =null,
@adminUserID int,
@includeInactiveUsers bit = 0
)

As

set nocount off

--Check data
if (@userTypeID is null or @userTypeID<=0)
begin
select @userTypeID = UserTypeID
from tblUser
where userID = @adminUserID
end

if @firstName is null
set @firstName=''''
if @lastName is null
set @lastName=''''

if (@includeInactiveUsers=0)
Begin
Select 	UserID,
UserName,
FirstName,
LastName,
Email,
Active
From tblUser
Where UnitID = @unitID
and firstName like ''%''+ @firstName +''%''
and lastName like ''%'' + @lastName +''%''
and UserTypeID >=@userTypeID
and Active = 1
order by LastName
End
Else
Begin
Select 	UserID,
UserName,
FirstName,
LastName,
Email,
Active
From tblUser
Where UnitID = @unitID
and firstName like ''%''+ @firstName +''%''
and lastName like ''%'' + @lastName +''%''
and UserTypeID >=@userTypeID
order by LastName
End
' 
END
GO
