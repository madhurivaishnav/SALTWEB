SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcLessonSession_BeforeStartLesson]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


/*Summary:
Given a UserID and LessonID starts a Lesson and returns a LessonSessionID
Returns:
LessonSessionID guid

Called By:
Businessservices.Toolbook.BeforeLessonStart
Calls:

Remarks:
starts a lesson and returns the details of the lesson so that it can be opened by salt
Author:
Stephen Kennedy-Clark
Date Created: 2 Feb 2004


Modification History
-----------------------------------------------------------
v# Author  Date   Description
#1 Peter Kneale Update to return active lesson location not first lesson location found.
? pending change added module id to where clause in select
#2 Removed unnecessary transactions

prcLessonSession_StartLesson @UserID=11, @LessonID=3
prcLessonSession_BeforeStartLesson @userID = 11, @moduleID = 3
select * from tblLessonSession
-- truncate tblLessonSession
**/

CREATE       Proc [prcLessonSession_BeforeStartLesson]
(
@userID int,  -- Users ID
@moduleID int  -- the Lesson ID
)

As
Set NoCount On
Set Xact_Abort On




------------------------------------------
-- Declerations
------------------------------------------
declare @strLessonSessionID varchar(50)
, @intLessonID int
set @strLessonSessionID = newid()
set @intLessonID = (select top 1 LessonID from tblLesson where ModuleID = @moduleID and Active=1)

------------------------------------------
-- Insert
------------------------------------------


Insert Into
tblLessonSession
(
[LessonSessionID],
[UserID],
[LessonID]
)
Values
(
@strLessonSessionID,
@userID,
@intLessonID
)


------------------------------------------
-- select Session Details: SessionID, ModuleName,
------------------------------------------

Select
tM.[Name]   As ''ModuleName''
, tC.[Name]   As ''CourseName''
, @strLessonSessionID  As ''SessionID''
, tL.ToolbookLocation  As ''Location''
,Scorm1_2
From
tblModule tM
Inner Join tblLesson tL
On tL.ModuleID = tM.ModuleID
Inner Join tblCourse tC
On tC.CourseID = tM.CourseID
where
tM.ModuleID = @moduleID
And
tL.Active = 1




' 
END
GO
