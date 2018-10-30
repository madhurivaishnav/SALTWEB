SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prcImportUserResults]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prcImportUserResults]
GO

Create Procedure prcImportUserResults
 as
 
	
	
	Declare @NewUserID int
	Declare @NewModuleID int
	Declare @QuizMark int
	Declare @QuizDate DateTime
	Declare @LessonComplete bit
		Declare @intErrorNumber Integer -- Holds the error number
		
	Begin transaction
	
	DECLARE UserResult CURSOR
	FOR 
	SELECT [NewUserID], [NewModuleID], [QuizMark], [QuizDate], [LessonComplete] FROM [tblLoad]
	Open UserResult

	-- First Read UserResult
	FETCH NEXT FROM UserResult Into @NewUserID, @NewModuleID, @QuizMark, @QuizDate, @LessonComplete
	Print ''
	Print '--------------------------------'
	Print '- Begin importing user results -'
	Print '--------------------------------'
	Print ''
	-- Scroll UserResult
	WHILE @@FETCH_STATUS = 0
		BEGIN
			
			-- Print ''
			-- Print 'User ' + cast(@NewUserID as varchar(100)) + ' imported at ' + cast(GetDate() as varchar(20))
			Exec prcImportUserResult @NewUserID, @NewModuleID, @QuizMark, @QuizDate, @LessonComplete
			Set @intErrorNumber = @@ERROR
			if (@intErrorNumber<>0)
			Begin
				BREAK
			End
			
			FETCH NEXT FROM UserResult Into @NewUserID, @NewModuleID, @QuizMark, @QuizDate, @LessonComplete
		END
	
	
	
	
	If(@intErrorNumber <> 0)
	Begin
		Rollback Transaction
		Print 'Rolled back.'
		Print 'Error:' + cast(@intErrorNumber as varchar)
	End
	Else
	Begin
		Commit Transaction
		Print 'Commited.'
	End
	
	Print ''
	Print '------------------------------------'
	Print '- Finished importing user results. -'
	Print '------------------------------------'
	Print ''
	
	-- Finished UserResult
	CLOSE UserResult
	DEALLOCATE UserResult