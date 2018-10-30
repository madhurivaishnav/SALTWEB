SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUserCourse_GetCompletionDate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
summary: get completion date for the last required component in a course is completed
parameters: userID int, courseID int
returns: datetimecompleted datetime

called by:
Author: Li Zhang
Date Created:

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/
CREATE Procedure [prcUserCourse_GetCompletionDate]
(@userID int,
@courseID int,
@OrgID int,
@courseCompletionDate datetime=null output
)
AS

Set Nocount On

/*
select
um.UserID,
um.ModuleID
into #tblCurrentAssignedModules
from vwUserModuleAccess um
inner join
vwUnitModuleRule umr
on umr.moduleID = um.moduleID
and umr.unitID = um.unitId
inner join
tblmodule m
on um.moduleId= m.moduleID
where
um.userID = @userID
and m.courseID = @courseID

--select * from #tblCurrentAssignedModules

select
um.userID,
um.moduleID,
qs.DateTimeCompleted
into
#tblStartedModules
from
#tblCurrentAssignedModules um
inner join
(
select
um.userID,
um.moduleID,
max(DateTimeCompleted) as DateTimeCompleted
from
#tblCurrentAssignedModules um
inner join tblQuiz q
on q.moduleID = um.ModuleID
inner join tblQuizSession qs
on qs.QuizID = q.quizID
and qs.userID = um.userId
and qs.datetimecompleted is not null
group by um.userID, um.moduleID
)as lastQuizDate
on lastquizdate.userID = um.userID
and lastquizdate.moduleID = um.moduleID
inner join tblQuiz q
on
q.moduleID = um.moduleID
inner join tblQuizSession qs
on qs.quizid = q.quizid
and qs.userid = um.userid
and qs.datetimecompleted = lastquizdate.datetimecompleted

select @courseCompletionDate = max(DateTimeCompleted) from #tblstartedmodules

*/


select top 1 @courseCompletionDate = dbo.udfUTCtoDaylightSavingTime(DateCreated, @OrgID) from tblUserCourseStatus where CourseID = @courseID and UserID = @userID and CourseStatusID = 2 order by DateCreated desc
' 
END
GO
