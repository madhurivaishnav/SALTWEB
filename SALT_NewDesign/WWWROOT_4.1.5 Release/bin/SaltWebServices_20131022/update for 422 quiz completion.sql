IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcSCORMtrainQandA]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcSCORMtrainQandA]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[prcSCORMtrainQandA] 
(
	@StudentID int,
    @intModuleID Int,
    @intAskedQuestion Int,
    @intWeighting Int,
    @strLatency NVarChar(100),
    @strTime NVarChar(100),
    @strText NVarChar(1000), 
    @strCorrectResponse NVarChar(1000), 
    @strStudentResponse NVarChar(1000), 
    @strType NVarChar(100), 
    @strID NVarChar(100), 
    @isCorrect Bit,
    @strQuizSessionID nvarchar(200)
)
as
begin
		
		IF (@strQuizSessionID IS NOT NULL)
		BEGIN
			declare @intQuizID int;

			set @intQuizID = (
					select top 1 QuizID
					from tblQuiz
					where moduleID = @intModuleID
						and Active = 1
					)

			declare @QuizQuestionID int

			select @QuizQuestionID = (
					select top 1 QuizQuestionID
					from tblQuizQuestion
					where QuizID = @intQuizID
						and ToolbookPageID = @strID
						and Question = @strText
					)

			if (@QuizQuestionID is null)
			begin
				delete
				from tblQuizQuestion
				where QuizID = @intQuizID
					and ToolbookPageID = @strID

				insert tblQuizQuestion (
					QuizID
					,ToolbookPageID
					,Question
					)
				values (
					@intQuizID
					,@strID
					,@strText
					)
				select @QuizQuestionID = @@IDENTITY
			end

			declare @QuizAnswerID int
			--
			select @QuizAnswerID = (
					select top 1 QuizAnswerID
					from tblQuizAnswer
					where QuizQuestionID = @QuizQuestionID
						and ToolbookAnswerID = SUBSTRING(@strStudentResponse,0,49)
						and Answer = @strStudentResponse
					)

			if (@QuizAnswerID is null)
			begin
				delete
				from tblQuizAnswer
				where QuizQuestionID = @QuizQuestionID
					and ToolbookAnswerID = SUBSTRING(@strStudentResponse,0,49)

				insert tblQuizAnswer (
					QuizQuestionID
					,ToolbookAnswerID
					,Answer
					,correct
					)
				values (
					@QuizQuestionID
					,SUBSTRING(@strStudentResponse,0,49)
					,@strStudentResponse
					,@isCorrect
					)
				select @QuizAnswerID = @@IDENTITY
			end
			
			declare @QuizCorrectAnswerID int
			select @QuizCorrectAnswerID = (
					select top 1 QuizAnswerID
					from tblQuizAnswer
					where QuizQuestionID = @QuizQuestionID
						and ToolbookAnswerID = SUBSTRING(@strCorrectResponse,0,49)
						and Answer = @strCorrectResponse
					)

			if (@QuizCorrectAnswerID is null)
			begin
				delete
				from tblQuizAnswer
				where QuizQuestionID = @QuizQuestionID
					and ToolbookAnswerID = SUBSTRING(@strCorrectResponse,0,49)

				insert tblQuizAnswer (
					QuizQuestionID
					,ToolbookAnswerID
					,Answer
					,correct
					)
				values (
					@QuizQuestionID
					,SUBSTRING(@strCorrectResponse,0,49)
					,@strCorrectResponse
					,1
					)
				select @QuizCorrectAnswerID = @@IDENTITY
					
			end
			
			IF NOT EXISTS (SELECT * FROM tblQuizQuestionAudit WHERE QuizSessionID = @strQuizSessionID AND QuizQuestionID = @QuizQuestionID)
			BEGIN
				INSERT INTO tblQuizQuestionAudit( QuizSessionID,QuizQuestionID,Duration,DateAccessed)
				VALUES  (@strQuizSessionID, @QuizQuestionID, 46664, getUTCdate())
			END
			if not exists (SELECT * FROM tblQuizAnswerAudit WHERE QuizSessionID = @strQuizSessionID AND QuizQuestionID = @QuizQuestionID AND QuizAnswerID = @QuizAnswerID)
			BEGIN
				INSERT INTO tblQuizAnswerAudit (QuizSessionID,QuizQuestionID,QuizAnswerID)
				values (@strQuizSessionID,@QuizQuestionID,@QuizAnswerID) 
			END
		END

 end

GO





IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcQuizSession_GetEndQuizInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcQuizSession_GetEndQuizInfo]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



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

CREATE PROCEDURE [dbo].[prcQuizSession_GetEndQuizInfo]
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
,		@intUnitID	int	-- user's unit id
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
, sendcert bit

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


declare @csdate datetime

select @csdate = DateCreated from tblUserCourseStatus where UserID = @intUserID 
and CourseID =@intCourseID
order by DateCreated desc


declare @modss  table (moduleid int, dt datetime )


insert into   @modss
select m.moduleid, max(uqs.DateCreated) as dt
 from tblUserQuizStatus uqs
join tblModule m on m.ModuleID = uqs.ModuleID
where m.CourseID =@intCourseID and uqs.UserID = @intUserID and QuizStatusID =2
group by m.ModuleID

declare @sendcert as bit

select @sendcert = case when MIN(dt)<@csdate then 0 else 1 end
from @modss


INSERT INTO @tblUserEndQuizInfo ( UserID, QuizID, PassMark, UnitID, ModuleID, QuizFrequency, QuizCompletionDate, NewQuizStatus, OldCourseStatus, NewCourseStatus, CourseID,sendcert)
VALUES (@intUserID, @intQuizID, @intPassMark, @intUnitID, @intModuleID, @intQuizFrequency,@dtmQuizCompletionDate,@intNewQuizStatus, @intOldCourseStatus, @intNewCourseStatus, @intCourseID,@sendcert)

SELECT * FROM @tblUserEndQuizInfo
END


GO






IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcQuizSession_GetEndQuizInfo2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcQuizSession_GetEndQuizInfo2]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


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

CREATE PROCEDURE [dbo].[prcQuizSession_GetEndQuizInfo2]
(
@intUserID int -- student must only sit one quiz at a time for a module
,@intModuleID int
, @duration int -- time used to complete the quiz
, @score int -- user quiz score
)
AS
SET nocount on
BEGIN
DECLARE 
		@intQuizID	int -- quiz id
,		@intPassMark	int	-- quiz pass mark
,		@intUnitID	int	-- user's unit id
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
, SessionID varchar(50)
, sendcert bit

)

--< read required data >--
DECLARE @quizSessionID varchar(100)
SELECT @quizSessionID =  (SELECT top 1 quizSessionID
  FROM tblQuiz Q
inner join tblQuizSession QS on  Q.QuizID = QS.QuizID 
WHERE Q.Active = 1 AND QS.DateTimeStarted IS NOT NULL
AND QS.DateTimeCompleted IS NULL
AND Q.ModuleID = @intModuleID
AND QS.UserID = @intUserID
order by DateTimeStarted desc)


							
--SET @intUserID = dbo.udfGetUserIDBySessionID(@quizSessionID)
SET @intQuizID = dbo.udfGetQuizIDBySessionID(@quizSessionID)
SELECT @intUnitID = (SELECT TOP 1 UnitID FROM tblUser WHERE UserID = @intUserID)
--SELECT @intModuleID = (SELECT TOP 1 ModuleID FROM tblQuiz WHERE QuizID = @intQuizID)
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





declare @csdate datetime

select @csdate = DateCreated from tblUserCourseStatus where UserID = @intUserID 
and CourseID =@intCourseID
order by DateCreated desc


declare @modss  table (moduleid int, dt datetime )


insert into   @modss
select m.moduleid, max(uqs.DateCreated) as dt
 from tblUserQuizStatus uqs
join tblModule m on m.ModuleID = uqs.ModuleID
where m.CourseID =@intCourseID and uqs.UserID = @intUserID and QuizStatusID =2
group by m.ModuleID

declare @sendcert as bit

select @sendcert = case when MIN(dt)<@csdate then 0 else 1 end
from @modss



INSERT INTO @tblUserEndQuizInfo ( UserID, QuizID, PassMark, UnitID, ModuleID, QuizFrequency, QuizCompletionDate, NewQuizStatus, OldCourseStatus, NewCourseStatus, CourseID, SessionID,sendcert)
VALUES (@intUserID, @intQuizID, @intPassMark, @intUnitID, @intModuleID, @intQuizFrequency,@dtmQuizCompletionDate,@intNewQuizStatus, @intOldCourseStatus, @intNewCourseStatus, @intCourseID,@quizSessionID,@sendcert)

SELECT * FROM @tblUserEndQuizInfo
END


GO


