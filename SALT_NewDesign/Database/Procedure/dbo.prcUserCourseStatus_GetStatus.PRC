SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUserCourseStatus_GetStatus]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/****** Object:  Stored Procedure dbo.prcUserCourseStatus_GetStatus    Script Date: 31/03/2004 2:11:11 PM ******/


/*Summary:
gets the latest status for a user for a course

Returns:
table - single row, single column - integer or null

Called By:
trgUserQuizStatus
Calls:

Remarks:




Author: Stepehn Clark
Date Created: 24 March 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

exec prcUserCourseStatus @UserID = @intUserID, @ModuleID = @intModuleID, @StatusID = @intNewCourseStatus

prcUserCourseStatus_GetStatus @CourseID = 19, @UserID = 113
QuizStatusID Status
------------ --------------------------------------------------
0            Unassigned
1            Not Started
2            Passed
3            Failed
4            Expired (Time Elapsed)
5            Expired (New Content)
**/
CREATE    procedure [prcUserCourseStatus_GetStatus]
(
@CourseID int -- the Course ID
, @UserID   int -- The User ID

)
As
------------------------
declare @intCourseStatus int -- the course status id to be returned
set @intCourseStatus =
(
select top 1
CourseStatusID -- could be null?
from
tblUserCourseStatus
where
CourseID = @CourseID
and UserID = @UserID

order by DateCreated desc
)
if @intCourseStatus is null
begin
set @intCourseStatus = -1
end
return  @intCourseStatus




' 
END
GO
