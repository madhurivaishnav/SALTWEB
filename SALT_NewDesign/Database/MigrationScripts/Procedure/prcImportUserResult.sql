SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prcImportUserResult]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prcImportUserResult]
GO


Create procedure prcImportUserResult
	@UserID int,
	@ModuleID int,
	@QuizMark int,
	@QuizDate datetime,
	@LessonComplete bit
as
	Print '----------------------'
	Print '-- @UserID:' + cast(@UserID as varchar(20))
	Print '-- @ModuleID:' + cast(@ModuleID as varchar(20))
	Print '-- @QuizMark:' + cast(@QuizMark as varchar(20))
	Print '-- @QuizDate:' + cast(@QuizDate as varchar(20))
	Print '-- @LessonComplete:' + cast(@LessonComplete as varchar(20))
	Print '----------------------'

	Declare @QuizID int
	Declare @LessonID int
	declare @LessonSessionID varchar(50)
	Declare @QuizSessionID varchar(50)
	Set @LessonSessionID = NEWID()
	Set @QuizSessionID = NEWID()
	
	Select @QuizID= QuizID from		[salt_new].[dbo].[tblQuiz] where ModuleID = @ModuleID and Active=1
	Select @LessonID= LessonID from [salt_new].[dbo].[tblLesson] where ModuleID = @ModuleID and Active=1
	
	if (@QuizID is null)
	Begin
		RaisError('Cannot find an active Quiz for module',16,1);
		return
	End
	if (@LessonID is null)
	Begin
		RaisError('Cannot find an active Lesson for module',16,1);
		return
	End
	
	
	-- Create a quiz if necessary
	IF (@QuizMark is Not Null)
	Begin
		-- Print 'Creating a quiz session'
		INSERT INTO 
			[salt_new].[dbo].[tblQuizSession] 
			([QuizSessionID], [UserID], [QuizID], [DateTimeStarted]) 
		VALUES
			(@QuizSessionID, @UserID, @QuizID, @QuizDate)

		-- Print 'Updating Quiz Session, Set DateTimeComplete, QuizScore'
		
		UPDATE 
			[salt_new].[dbo].[tblQuizSession] 
		Set
			[DateTimeCompleted] = DateAdd(minute,1,@QuizDate),
			[QuizScore] = @QuizMark,
			[Duration] = 1			
		WHERE 
			[QuizSessionID] = @QuizSessionID
	End

	-- Create a lesson if necessary
	if (@LessonComplete=1)
	Begin
		-- Print 'Creating Lesson session.'
		INSERT INTO 
			[salt_new].[dbo].[tblLessonSession]
			([LessonSessionID], [UserID], [LessonID]) 
			VALUES (@LessonSessionID, @UserID, @LessonID)
		
		-- Print 'Updating Lesson session, Set DateTimeStarted.'
		UPDATE [salt_new].[dbo].[tblLessonSession] 
			SET [DateTimeStarted] = GetDate()  		-- GetDate() instead of the true lesson date.
			WHERE [LessonSessionID] = @LessonSessionID
		
		-- Print 'Creating Lesson Page Audit.'
		Insert into [salt_new].[dbo].[tblLessonPageAudit]
			Select @LessonSessionID, LessonPageID, GetDate()-- GetDate() instead of the true lesson date.
			from [salt_new].[dbo].[tblLessonPage] where LessonID = @LessonID
		
		-- Print 'Update Lesson Session, Set DateTimeCompleted.'
		UPDATE [salt_new].[dbo].[tblLessonSession] 
			SET 
				[DateTimeCompleted] = GetDate(),	-- GetDate() instead of the true lesson date.
				[Duration]=1 
			WHERE [LessonSessionID] = @LessonSessionID
	End
	
	
	

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

