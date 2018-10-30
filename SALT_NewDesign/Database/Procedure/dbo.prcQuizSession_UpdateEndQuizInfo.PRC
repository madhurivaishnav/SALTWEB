SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcQuizSession_UpdateEndQuizInfo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Update record in tblQuizSession
Insert record into tblUserQuizStatus
Insert record into tblUserCourseStatus

Returns:
data table

Called By:
ToolBook.cs: UpdateEndQuizInfo

Author: Li Zhang
Date Created: 13-10-2006
Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	mikev		1/5/2007		Added QuizCompletionDate
**/

CREATE PROCEDURE [dbo].[prcQuizSession_UpdateEndQuizInfo]
(
@QuizSessionID	varchar(50) -- unique GUID that identifies this toolbook quiz session
, @Duration	int -- the duration in seconds of the quiz as mesured by toolbook
, @Score 	int -- the score as mesured by toolbook
, @UserID	int	-- user id
, @QuizID	int -- quiz id
, @PassMark	int	-- quiz pass mark
, @UnitID	int	-- user''s unit id
, @ModuleID	int -- quiz module id
, @CourseID	int -- module course id
, @OldCourseStatus	int -- course status before update
, @NewQuizStatus int -- the quiz status
, @NewCourseStatus	int	-- course status after update
, @QuizFrequency	int -- quiz frequency
, @QuizCompletionDate	datetime -- quiz completiondate
)
AS
SET nocount on
SET xact_abort on
BEGIN TRANSACTION

declare @createrec as bit
set @createrec = 0


declare @OrgID int
select @OrgID = organisationID from tblUnit where tblUnit.UnitID=@UnitID

set @QuizCompletionDate = dbo.udfDaylightSavingTimeToUTC(@QuizCompletionDate, @OrgID)

DECLARE @dateCreated datetime
SET @dateCreated = GETUTCDATE()

IF EXISTS
(
SELECT QuizSessionID
FROM tblQuizSession
WHERE QuizSessionID = @QuizSessionID
AND	DateTimeStarted IS NOT NULL
AND DateTimeCompleted IS NULL
)
BEGIN
	-- < update tblQuizSession >--
	UPDATE tblQuizSession
	SET DateTimeCompleted = @dateCreated
	, Duration = DATEDIFF(second,DateTimeStarted,@dateCreated)
	, QuizScore = @Score
	, QuizPassMark = @PassMark
	WHERE
	QuizSessionID = @QuizSessionID

	--< insert into tblUserQuizStatus >--
	INSERT INTO
	tblUserQuizStatus
	(
	UserID,
	ModuleID,
	QuizStatusID,
	QuizFrequency,
	QuizPassMark,
	QuizCompletionDate,
	QuizScore,
	QuizSessionID,
	DateCreated
	)
	VALUES
	(
	@UserID,
	@ModuleID,
	@NewQuizStatus,
	@QuizFrequency,
	@PassMark,
	@QuizCompletionDate,
	@Score,
	@QuizSessionID,
	@dateCreated
	)

	--< insert into tblUserCourseStatus >--

	-- if the user redo the quiz when they are still having a completed user course status
	-- check if the last 2 course status is a completed status
	-- if it is then we update the date of the last course status id to avoid new rows being inserted
	-- if not we just add a new row
	IF (@OldCourseStatus=2 and @OldCourseStatus = @NewCourseStatus)
	BEGIN
		
		declare @csdate datetime
		
		
		select top 1 @csdate = DateCreated 
		from tblUserCourseStatus 
		where UserID = @UserID 	and CourseID =@CourseID
		order by DateCreated desc

		declare @modss  table (moduleid int, dt datetime )

		insert into   @modss
		select m.moduleid, max(uqs.DateCreated) as dt
		 from tblUserQuizStatus uqs
		 -- join tblUserModuleAccess uma on uma.UserID = uqs.UserID and uma.ModuleID = uqs.ModuleID and uma.Granted = 1
		 join vwUserModuleAccess uma on uma.UserID = uqs.UserID and uma.ModuleID = uqs.ModuleID
		join tblModule m on m.ModuleID = uqs.ModuleID
		where m.CourseID =@CourseID and uqs.UserID = @UserID and QuizStatusID =2
		group by m.ModuleID

		select @createrec = case when MIN(dt)>@csdate then 1 else 0 end
		from @modss

		if(@createrec =1)
		begin
			EXEC prcUserCourseStatus_Insert @UserID, @ModuleID, @NewCourseStatus
		end

	END
	ELSE IF (@OldCourseStatus = -1) or (@OldCourseStatus <> @NewCourseStatus)	
	BEGIN
	
		if(@NewCourseStatus=2) begin
			set @createrec =1
		end
		
		EXEC prcUserCourseStatus_Insert @UserID, @ModuleID, @NewCourseStatus
	END
	ELSE BEGIN
		IF NOT EXISTS (SELECT UserID FROM vwUserModuleAccess where UserID = @UserID AND CourseID = @CourseID) AND
		EXISTS (SELECT UserCourseStatusID FROM tblUserCourseStatus WHERE UserID = @UserID AND CourseID = @CourseID AND CourseStatusID <> 0)
		BEGIN
			EXEC prcUserCourseStatus_Insert @UserID, @ModuleID,  0
		END
	END

END


COMMIT TRANSACTION

select @createrec as sendcert 
' 
END
GO
