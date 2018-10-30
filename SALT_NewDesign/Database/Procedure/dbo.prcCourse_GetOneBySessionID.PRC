SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcCourse_GetOneBySessionID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



/*Summary:
Gets the course id for a session.
This proc is called by the home page

Parameters:
@sessionID


Returns:
table

Called By:
Course.cs.

Calls:
udfGetLessonIDBySessionID

Remarks:
no exceptions thrown

Author: Stephen Kennedy - Clark
Date Created: 4 March 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


-- prcCourse_GetOneBySessionID @sessionID=''329E7586-81D3-45B2-A981-E7760435DDE4''

**/
CREATE   Procedure [prcCourse_GetOneBySessionID]
(
@sessionID varchar(50) = Null
)

As
-----------------------------------------------------------
-- Declarations
Declare @strErrorMessage Varchar(200) -- Holds the error message
Declare @intErrorNumber Integer -- Holds the error number

-- Simple error check, if the session ID is not a valid guid then dont try and
-- get the course ID
if (dbo.udfIsGUID(@sessionID) = 0)
begin
select -1 as CourseID
return
end
if dbo.udfGetLessonIDBySessionID(@sessionID) is null and dbo.udfGetQuizIDBySessionID(@sessionID) is null
begin
select -1 as CourseID
return
end


--  The GUID is valid and exists
--  so get the details required form the underlying udfs
Select
tM.CourseID
From
tblModule tM
inner join tblLesson tL
on tL.ModuleID = tM.ModuleID
and tL.LessonID = dbo.udfGetLessonIDBySessionID(@sessionID)
union
Select
tM.CourseID
From
tblModule tM
inner join tblQuiz tQ
on tQ.ModuleID = tM.ModuleID
and tQ.QuizID = dbo.udfGetQuizIDBySessionID(@sessionID)




' 
END
GO
