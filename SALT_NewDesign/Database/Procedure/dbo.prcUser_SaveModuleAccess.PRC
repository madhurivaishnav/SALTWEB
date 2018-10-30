SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_SaveModuleAccess]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:
Saves User module access settings

If the Unit Module Access profile is changed however
then the User Module Access profiles will be over-written with the new Unit Module Access profile.

Called By: User.cs
Calls: None

Remarks: Raises an error if the parameter is null

Author: Jack Liu
Date Created: 17th of February 2004



Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

prcUser_SaveModuleAccess 2, 1, ''1,2''

select * from tblModule


*/

CREATE  Procedure [prcUser_SaveModuleAccess]
(
@userID Int,
@courseID int,
@grantedModuleIDs varchar(500)
)

As

set nocount on

set xact_abort on
Begin Tran

-- Remove existing settings
Delete tblUserModuleAccess
from  tblUserModuleAccess uma
inner join tblModule m
on uma.ModuleID=m.ModuleID
where 	uma.UserID=@userID
and m.courseID = @courseID

--Insert new settings
insert into tblUserModuleAccess
(UserID,
ModuleID,
Granted
)
select @userID,
m.ModuleID,
case
when g.IntValue is null then 0
else 1
end as Granted
From tblModule m
left join dbo.udfCsvToInt(@grantedModuleIDs) as  g
on g.IntValue=m.moduleID
where CourseId= @courseID

--Update course status
Declare @intOldCourseStatus int
Declare @intNewCourseStatus int
Declare @ModuleID int

exec @intOldCourseStatus = prcUserCourseStatus_GetStatus @courseId, @userID
exec @intNewCourseStatus = prcUserCourseStatus_Calculate @courseID, @userID

IF (@intOldCourseStatus = -1) or (@intOldCourseStatus <> @intNewCourseStatus)
BEGIN
--Just need to get one of the modules of the course to pass into prcUserCourseStatus_Insert
set @moduleID = (select top 1 m.moduleId
From tblModule m
left join dbo.udfCsvToInt(@grantedModuleIDs) as  g
on g.IntValue=m.moduleID
where CourseId= @courseID and m.active=1)
EXEC prcUserCourseStatus_Insert @UserID, @ModuleID, @intNewCourseStatus
END

Commit tran

' 
END
GO
