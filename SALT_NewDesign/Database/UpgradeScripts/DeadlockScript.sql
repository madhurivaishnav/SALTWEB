SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prcUserCourseStatus_Calc]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prcUserCourseStatus_Calc]
GO

/*Summary:
Calculate the latest course status for a user - course
 
Returns:
int CourseID

Called By:
prcQuizSession_GetEndQuizInfo
Calls:
Stored procedure

Remarks:

QuizStatusID Status
------------ --------------------------------------------------
0            Unassigned
1            Not Started
2            Passed
3            Failed
4            Expired (Time Elapsed)
5            Expired (New Content)


CourseStatusID Status                                             
-------------- -------------------------------------------------- 
0              Unassigned
1              InComplete
2              Complete

Author: Li Zhang
Date Created: 13-10-2006
Modification History
-----------------------------------------------------------
v#	Author		Date			Description

**/



CREATE PROCEDURE prcUserCourseStatus_Calc
(
	@CourseID int	-- The course ID
	, @UserID int 	-- The user ID
	, @NewQuizStatus int	-- New quiz status for calculating latest course status
	, @ModuleID int -- quiz module ID
)
AS
------------------------------------
SET Nocount On

BEGIN
--< if all the users results for this quiz are passed then the course is completed >--

DECLARE @intStatus int, -- Return Value
		@intRowCount int,
		@intQuizFrequency int

DECLARE	@tblUserQuizStatus TABLE
		(
			ModuleID    int
			, QuizStatusID int
		)


--< select all user quiz status details before update >--

	INSERT INTO
	@tblUserQuizStatus
	(
		ModuleID
		, QuizStatusID
	)
	SELECT
		vUQS.ModuleID
		, vUQS.QuizStatusID 
	FROM vwUserQuizStatus vUQS
	INNER JOIN vwUserModuleAccess vUMA
	ON		
			vUQS.ModuleID = vUMA.ModuleID
		AND vUMA.Userid = @UserID
		AND vUMA.CourseID = @CourseID
		AND vUQS.CourseID = @CourseID
		AND vUQS.UserID = @UserID


	--< get the rowcount >--

	SET @intRowCount = @@RowCount

	--< update the @tblUserQuizStatus with the latest user quiz details >--
	 
	IF @intRowCount = 0
	BEGIN
		
		INSERT  INTO @tblUserQuizStatus 
					(	ModuleID
						, QuizStatusID
					)
				VALUES
					(
						@ModuleID
						, @NewQuizStatus
					)
	END

	IF @intRowCount <> 0
	BEGIN
		IF EXISTS (SELECT QuizStatusID FROM @tblUserQuizStatus WHERE ModuleID = @ModuleID)
		BEGIN
			--< quiz record exists, update quiz status >--
			UPDATE @tblUserQuizStatus SET QuizStatusID = @NewQuizStatus WHERE ModuleID = @ModuleID
		END
		ELSE
		BEGIN
				INSERT  INTO @tblUserQuizStatus 
					(	ModuleID
						, QuizStatusID
					)
				VALUES
					(
						@ModuleID
						, @NewQuizStatus
					)
		END

	END

	--< star to calculate the latest course status >--
	--< if there are any results for anything other than passed then the course is incomplete >--

	IF EXISTS (SELECT ModuleID FROM @tblUserQuizStatus WHERE QuizStatusID <> 2)
	BEGIN
	--< Course status: Incomplete >--
		RETURN  1	
	END
	--<  all the quizes are passed then the course is complete >--

	IF  (SELECT COUNT(ModuleID) FROM @tblUserQuizStatus WHERE QuizStatusID = 2) = @intRowCount
	BEGIN 
	--< Course status: Complete >--
		RETURN 2 
	END 

	--< otherwise course incomplete >--
	RETURN 1 

	END
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prcQuizSession_GetEndQuizInfo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prcQuizSession_GetEndQuizInfo]
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

**/

CREATE PROCEDURE prcQuizSession_GetEndQuizInfo
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
	DECLARE	@tblUserEndQuizInfo table	-- return table with all details needed to end a quiz
			( 
				UserID	int
				, QuizID int
				, PassMark int
				, UnitID int
				, ModuleID int 
				, QuizFrequency int
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
	
	SET @intQuizFrequency = (
								SELECT  TOP 1   ISNULL(ur.QuizFrequency, o.DefaultQuizFrequency) 
								FROM   	tblUnitRule AS ur INNER JOIN tblUser AS u 
								ON ur.UnitID = u.UnitID 
								INNER JOIN tblOrganisation AS o ON u.OrganisationID = o.OrganisationID
								WHERE	u.UserID = @intUserID
							)

	INSERT INTO @tblUserEndQuizInfo ( UserID, QuizID, PassMark, UnitID, ModuleID, QuizFrequency, NewQuizStatus, OldCourseStatus, NewCourseStatus, CourseID)
	VALUES (@intUserID, @intQuizID, @intPassMark, @intUnitID, @intModuleID, @intQuizFrequency,@intNewQuizStatus, @intOldCourseStatus, @intNewCourseStatus, @intCourseID)
	 
	SELECT * FROM @tblUserEndQuizInfo
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prcQuizSession_UpdateEndQuizInfo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prcQuizSession_UpdateEndQuizInfo]
GO

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

**/

CREATE PROCEDURE prcQuizSession_UpdateEndQuizInfo
(
	@QuizSessionID	varchar(50) -- unique GUID that identifies this toolbook quiz session
	, @Duration	int -- the duration in seconds of the quiz as mesured by toolbook
	, @Score 	int -- the score as mesured by toolbook
	, @UserID	int	-- user id
	, @QuizID	int -- quiz id
	, @PassMark	int	-- quiz pass mark
	, @UnitID	int	-- user's unit id
	, @ModuleID	int -- quiz module id
	, @CourseID	int -- module course id
	, @OldCourseStatus	int -- course status before update
	, @NewQuizStatus int -- the quiz status
	, @NewCourseStatus	int	-- course status after update
	, @QuizFrequency	int -- quiz frequency
)
AS
	SET nocount on
	SET xact_abort on 
BEGIN TRANSACTION
	DECLARE @dateCreated datetime
	SET @dateCreated = GETDATE()
	
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
			, Duration = @Duration
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
					@Score,
					@QuizSessionID,
					@dateCreated
				)
				
		--< insert into tblUserCourseStatus >--
		IF (@OldCourseStatus = -1) or (@OldCourseStatus <> @NewCourseStatus)
		BEGIN
			EXEC prcUserCourseStatus_Insert @UserID, @ModuleID, @NewCourseStatus
		END
		ELSE
		BEGIN
			IF NOT EXISTS (SELECT UserID FROM vwUserModuleAccess where UserID = @UserID AND CourseID = @CourseID) AND
			EXISTS (SELECT UserCourseStatusID FROM tblUserCourseStatus WHERE UserID = @UserID AND CourseID = @CourseID AND CourseStatusID <> 0)
			BEGIN
				EXEC prcUserCourseStatus_Insert @UserID, @ModuleID, @NewCourseStatus = 0
			END
		END
		
	END
	
	COMMIT TRANSACTION


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

-- delete all triggers related to deadlock issue
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgQuizSessionCompleted]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgQuizSessionCompleted]
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgUserQuizStatus]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgUserQuizStatus]
GO

 SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prcUserQuizStatus_UpdateCourseStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prcUserQuizStatus_UpdateCourseStatus]
GO

/*Summary:
for the record just inserted into the tblUserQuizStatus:
-- get the old course status in tblUserCourseStatus
-- calculate the new course status
-- insert new course status into tblUserCourseStatus if old and new course status are different

called by:
prcUserQuizStatus_Update

Author: Li Zhang
Date Created: 24-10-2006
*/

CREATE PROCEDURE prcUserQuizStatus_UpdateCourseStatus
(
	@UserID int
	, @ModuleID int
	, @StatusID int
)
AS
	SET nocount ON
	SET xact_abort ON
	
	DECLARE @intOldCourseStatus int
	DECLARE @intNewCourseStatus int
	DECLARE @intCourseID int
	
	SET @intCourseID = (SELECT CourseID FROM tblModule WHERE ModuleID = @ModuleID)
	
	EXEC @intOldCourseStatus = prcUserCourseStatus_GetStatus @intCourseID, @UserID
	
	EXEC @intNewCourseStatus = prcUserCourseStatus_Calculate @intCourseID, @UserID
	
	IF (@intOldCourseStatus = -1) OR (@intOldCourseStatus <> @intNewCourseStatus)
	BEGIN
		EXEC prcUserCourseStatus_Insert @UserID, @ModuleID, @intNewCourseStatus
	END
	ELSE
	BEGIN
		IF NOT EXISTS (SELECT UserID FROM vmUserModuleAccess WHERE UserID = @UserID AND CourseID = @intCourseID)
			AND EXISTS (SELECT UserCourseStatusID FROM tblUserCourseStatus 
							WHERE UserID = @UserID 
							AND CourseID = @intCourseID
							AND CourseStatusID <> 0)
		BEGIN
			EXEC prcUserCourseStatus_Insert @UserID, @ModuleID, @StatusID = 0
		END
	END
	
	GO
	SET QUOTED_IDENTIFIER OFF
	GO
	SET ANSI_NULLS ON
	GO
	
	