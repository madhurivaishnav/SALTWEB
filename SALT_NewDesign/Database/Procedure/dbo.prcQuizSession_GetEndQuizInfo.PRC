SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcQuizSession_GetEndQuizInfo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
read all information needed to end a quiz

Returns:
data table

Called By:
ToolBook.cs: GetEndQuizInfo

Remarks:

QuizStatusID Status
------------ --------------------------------------------------
0            Unassigned
1            Not Started
2            Passed
3            Failed
4            Expired (Time Elapsed)
5            Expired (New Content)

Author: Li Zhang
Date Created: 13-10-2006
Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	mikev		1/5/2007		Added LessonCompletionDate
**/

CREATE PROCEDURE [prcQuizSession_GetEndQuizInfo]
(
@quizSessionID varchar(50) -- unique that identifies this toolbook quiz session
, @duration int -- time used to complete the quiz
, @score int -- user quiz score
)
AS
SET nocount on
BEGIN
DECLARE @intUserID	int	-- user id
,		@intQuizID	int -- quiz id
,		@intPassMark	int	-- quiz pass mark
,		@intUnitID	int	-- user''s unit id
,		@intModuleID	int -- quiz module id
,		@intCourseID	int -- module course id
,		@intOldCourseStatus	int -- course status before update
,		@intNewQuizStatus int -- the quiz status
, 		@intNewCourseStatus	int	-- course status after update
,		@intQuizFrequency int
,		@dtmQuizCompletionDate datetime
DECLARE	@tblUserEndQuizInfo table	-- return table with all details needed to end a quiz
(
UserID	int
, QuizID int
, PassMark int
, UnitID int
, ModuleID int
, QuizFrequency int
, QuizCompletionDate datetime
, NewQuizStatus int
, OldCourseStatus int
, NewCourseStatus int
, CourseID int

)

--< read required data >--

SET @intUserID = dbo.udfGetUserIDBySessionID(@quizSessionID)
SET @intQuizID = dbo.udfGetQuizIDBySessionID(@quizSessionID)
SELECT @intUnitID = (SELECT TOP 1 UnitID FROM tblUser WHERE UserID = @intUserID)
SELECT @intModuleID = (SELECT TOP 1 ModuleID FROM tblQuiz WHERE QuizID = @intQuizID)
SET @intPassMark = dbo.udfQuiz_GetPassMark(@intUnitID, @intModuleID)
IF @score < @intPassMark
BEGIN
--< Quiz status: failed >--
SET @intNewQuizStatus = 3
END
IF @score > @intPassMark OR @score = @intPassMark
BEGIN
--< Quiz status: passed >--
SET @intNewQuizStatus = 2
END

SELECT @intCourseID = (SELECT TOP 1 CourseID FROM tblModule WHERE ModuleID = @intModuleID)
EXEC @intOldCourseStatus = prcUserCourseStatus_GetStatus @intCourseID, @intUserID
EXEC @intNewCourseStatus = prcUserCourseStatus_Calc @intCourseID, @intUserID,  @intNewQuizStatus,@intModuleID

--< get pre-defined quiz frequency from tblUnitRule >--
--< if the value is null then use the default quiz frequency in tblOrganisation >--

-- mikev(1): added QuizCompletionDate
SET @intQuizFrequency = (
SELECT  TOP 1   ISNULL(ur.QuizFrequency, o.DefaultQuizFrequency)
FROM   	tblUnitRule AS ur INNER JOIN tblUser AS u
ON ur.UnitID = u.UnitID
INNER JOIN tblOrganisation AS o ON u.OrganisationID = o.OrganisationID
WHERE	u.UserID = @intUserID
)

SET @dtmQuizCompletionDate = (
SELECT  TOP 1	ISNULL(ur.QuizCompletionDate, o.DefaultQuizCompletionDate)
FROM   	tblUnitRule AS ur INNER JOIN tblUser AS u
ON ur.UnitID = u.UnitID
INNER JOIN tblOrganisation AS o ON u.OrganisationID = o.OrganisationID
WHERE	u.UserID = @intUserID
)

INSERT INTO @tblUserEndQuizInfo ( UserID, QuizID, PassMark, UnitID, ModuleID, QuizFrequency, QuizCompletionDate, NewQuizStatus, OldCourseStatus, NewCourseStatus, CourseID)
VALUES (@intUserID, @intQuizID, @intPassMark, @intUnitID, @intModuleID, @intQuizFrequency,@dtmQuizCompletionDate,@intNewQuizStatus, @intOldCourseStatus, @intNewCourseStatus, @intCourseID)

SELECT * FROM @tblUserEndQuizInfo
END

' 
END
GO
