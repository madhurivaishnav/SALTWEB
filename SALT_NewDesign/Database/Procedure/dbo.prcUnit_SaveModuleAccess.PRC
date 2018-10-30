SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUnit_SaveModuleAccess]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:
Saves unit module access settings
This will overwrite the module access settings of users (Remove individual settings)

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

prcUnit_SaveModuleAccess 2, 1, ''1,2''


select * from tblModule


*/

CREATE  Procedure [prcUnit_SaveModuleAccess]
(
@unitID Int,
@courseID int,
@grantedModuleIDs varchar(500)
)

As

set nocount on

set xact_abort on
Begin Tran

-- Remove existing settings
Delete tblUnitModuleAccess
from  tblUnitModuleAccess uma
inner join tblModule m
on uma.DeniedModuleID=m.ModuleID
where 	uma.UnitID=@unitID
and m.courseID = @courseID

-- Overwrite the module access settings of users (Remove individual settings)
Delete tblUserModuleAccess
from  tblUserModuleAccess uma
inner join tblUser u
on uma.UserID = u.UserID
inner join tblModule m
on uma.ModuleID=m.ModuleID
where 	u.UnitID=@unitID
and m.courseID = @courseID

--Insert new settings
insert into tblUnitModuleAccess
(UnitID,
DeniedModuleID
)
select @unitID,
m.ModuleID
From tblModule m
left join dbo.udfCsvToInt(@grantedModuleIDs) as  g
on g.IntValue=m.moduleID
where CourseId= @courseID
and g.IntValue is null



-- update course status for users
declare @intOldCourseStatus int
declare @intNewCourseStatus int
declare @ModuleID int
declare @userID int

declare userIDCursor cursor
for SELECT DISTINCT u.UserID
FROM tblUser AS u
INNER JOIN tblUserCourseStatus AS ucs
ON u.UserID = ucs.UserID
WHERE (ucs.CourseID = @CourseID) AND (u.UnitID = @UnitID)

open userIDCursor

fetch next from userIDCursor into @userID while (@@FETCH_STATUS <> -1) begin if (@@FETCH_STATUS <> -2) begin exec @intOldCourseStatus = prcUserCourseStatus_GetStatus @courseID, @userID exec @intNewCourseStatus = prcUserCourseStatus_Calculate @courseID, @userID

if (@intOldCourseStatus = -1) or (@intOldCourseStatus <> @intNewCourseStatus) begin set @moduleID = (select top 1 m.moduleId from tblModule m left join dbo.udfCsvToInt(@grantedModuleIDs) as g on g.IntValue=m.moduleID where CourseID = @courseID) exec prcUserCourseStatus_Insert @userID, @ModuleID, @intNewCourseStatus end end fetch next from userIDCursor into @userID end close userIDCursor deallocate userIDCursor



Commit tran


' 
END
GO
