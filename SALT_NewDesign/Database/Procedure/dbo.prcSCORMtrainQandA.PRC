 SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcSCORMtrainQandA]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE Procedure [prcSCORMtrainQandA] 
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

' 
END
GO
