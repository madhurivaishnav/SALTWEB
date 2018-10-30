--alter tblOrganisationConfig, tblVersion, tblLogDaily, tblLogHourly

ALTER TABLE tblOrganisationConfig ADD ID NUMERIC IDENTITY(1,1) PRIMARY KEY
ALTER TABLE tblVersion ADD ID NUMERIC IDENTITY(1,1) PRIMARY KEY
ALTER TABLE tblLogDaily ADD ID NUMERIC IDENTITY(1,1) PRIMARY KEY
ALTER TABLE tblLogHourly ADD ID NUMERIC IDENTITY(1,1) PRIMARY KEY

---change the text type to ntext in the stored procedures to fixed the content upload issue 


SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prcToolbook_Import]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prcToolbook_Import]
GO


/*
Summary: Uploads the details from an XML document to the tblLesson,tblLessonPage,tblQuiz, tblQuizQuestion, tblQuizAnswer table
Parameters: 
		@strXMLData Text = null, 	        	-- XML document
		@intUserID Integer = null,          		-- ID of user inporting the xmlData
		@intModuleID Integer = null,        		 -- Module Id that this quiz or lesson is associated with.
		@intCourseID Integer = null,         	-- Course Id that this quiz or lesson is associated with.
		@strToolLocation Varchar(500) = Null	-- Relative path to the toolbook content
Returns: 
		two Result sets

		-- Return Results
		One: The first result set has the totals for the Upload
			The Upload Type - Lesson or Quiz
			The time the upload took place.
			The LessonID or the Quiz ID
		
		Two: The second result set holds the detail of the records that were inserted
			
		
Called By: 
		Toolbook.cs
Calls: 
		sp_xml_preparedocument -- system stored procedure to ALTER  an internal representation of the XML document.
		udfGetQuizIDByToolbookIDAndModuleID
		udfGetLessonIDByToolbookIDAndModuleID

Remarks: The XML document must be well formed otherwise the process will fail.

Author: Peter Kneale
Date Created: 23rd of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	Jack Liu	12/09/2005		Comment out the update answer correct status if the quiz is CORRECTION
						For Quiz CORRECTION, the correct answer can't be changed, this is validated in the prcToolbook_preview	
						 	
*/
CREATE  Procedure prcToolbook_Import
	(
		@strXMLData NText = null, 	        	-- XML document
		@intUserID Integer = null,          		-- ID of user inporting the xmlData
		@intModuleID Integer = null,        		 -- Module Id that this quiz or lesson is associated with.
		@intCourseID Integer = null,         	-- Course Id that this quiz or lesson is associated with.
		@strToolLocation Varchar(500) = Null	-- Relative path to the toolbook content
	)

As
	Set NoCount On
	Set Xact_Abort On
		
	-- Check if the XML document was passed.
	If(@strXMLData Is Null)
	Begin
		Raiserror('The @strXMLData parameter was Null.  You must supply a valid XML document.', 16, 1)
		Return
	End
	
	-- Check if the ID was passed.
	If(@intUserID Is Null)
	Begin
		Raiserror('The @intUserID parameter was Null.  You must supply a value.', 16, 1)
		Return
	End
	
	-- Check if the Module ID was passed.
	If(@intModuleID Is Null)
	Begin
		Raiserror('The @intModuleID parameter was Null.  You must supply a value.', 16, 1)
		Return
	End
	
	-- Check if the Course ID was passed.
	If(@intCourseID Is Null)
	Begin
		Raiserror('The @intCourseID parameter was Null.  You must supply a value.', 16, 1)
		Return
	End
	
	-- Check if the Toolbook Location was passed.
	If(@strToolLocation Is Null)
	Begin
		Raiserror('The @strToolLocation parameter was Null.  You must supply a value.', 16, 1)
		Return
	End




	Declare @intDocHeader			 	Integer
	Declare @strRowPattern 				Varchar(50)
	Declare @strToolbookType 			Varchar(50)
	Declare	@strUploadType				Varchar(50)
	Declare @strToolbookID				Varchar(50)
	Declare @DatePublished				DateTime
	Declare @intXMLUpdates				Integer
	
	-- Quiz Specific
	Declare @intQuizID				Integer
	Declare @intDocQuizQuestions			Integer
	Declare @intDocQuizAnswers			Integer
	Declare @intQuestions				Integer
	Declare @intAnswers				Integer
	
	-- Lesson
	Declare @intLessonID				Integer
	Declare @intDocLessons				Integer
	Declare @intLessons				Integer
	
	-------------------------------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------------------------
	----------- Create Necessary Temporary Tables
	-------------------------------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------------------------



	----------------------------------------------------------------------------
	-------- Create Imaginary Table for Quiz Answers
	----------------------------------------------------------------------------
	Create Table #xmlUploadQuizAnswers
		(
		ToolbookQuestionID	Varchar(50),	-- The toolbook Question ID of from the new content
		ToolbookAnswerID	Varchar(50),	-- The toolbook Answer ID of from the new content
		Correct 		Varchar(255),	-- 'True' or 'False' indicating if the answer is correct
		bCorrect 		bit,		-- 0 or 1 indicating if the answer is correct, this is derived from the Correct Column
		AnswerText		Varchar(1000),	-- The textual answer
		QuizQuestionID		Integer		-- The QuizQuestion ID from the Salt Database.
		)
		
	----------------------------------------------------------------------------
	-------- Create Temporary Table for Quiz Questions
	----------------------------------------------------------------------------
	Create Table #xmlUploadQuizQuestions
		(
		ToolbookPageID	Varchar(50),
		PageTitle 		Varchar(1000),
		)
		
	----------------------------------------------------------------------------
	-------- Create Imaginary Table for Quiz Answers
	----------------------------------------------------------------------------
	Create Table #xmlUploadLessons
		(
		ToolbookPageID	Varchar(50),
		PageTitle 		Varchar(1000),
		)
		
	----------------------------------------------------------------------------
	-------- Create Imaginary Table for Upload Information
	----------------------------------------------------------------------------
	Create Table #xmlUploadHeader
		(
		ToolBookID		Varchar(50),
		ToolBookType 		Varchar(50),
		NumberOfPages 		Integer,
		DatePublished		DateTime,
		UploadType		Varchar(50)
		)


Begin Transaction

	----------------------------------------------------------------------------
	-------- Insert Upload Information Into Imaginary Table
	----------------------------------------------------------------------------
	Set @strRowPattern = '/BDWToolBookUpload'
	Exec sp_xml_preparedocument @intDocHeader Output, @strXMLData

	Insert into #xmlUploadHeader
		(
		ToolBookID,
		ToolBookType,
		NumberOfPages,
		DatePublished,
		UploadType
		)

	Select 
		ToolBookID,
		ToolBookType,
		NumberOfPages,
		DatePublished,
		UploadType
	From
	
		OpenXml 
			(@intDocHeader, @strRowPattern)
		With
		(
		ToolBookID		Varchar(50) 	'ToolBookID',
		ToolBookType		Varchar(50)	'ToolBookType',
		NumberOfPages		Integer		'NumberOfPages',
		DatePublished		DateTime	'DatePublished',
		UploadType		Varchar(50)	'UploadType'
		)

	----------------------------------------------------------------------------
	-------- Insert Lessons Into Imaginary Table
	----------------------------------------------------------------------------	
	Set @strRowPattern = '/BDWToolBookUpload/Pages/Page'
	Exec sp_xml_preparedocument @intDocLessons Output, @strXMLData

	Insert into #xmlUploadLessons
		(
		ToolbookPageID,
		PageTitle
		)

	Select 
		ToolbookPageID,
		PageTitle
	From

		OpenXml 
			(@intDocLessons, @strRowPattern)
		With
		(
		ToolbookPageID	Varchar(50) 	'@ID',
		PageTitle	Varchar(1000)	'PageTitle'
		)


	----------------------------------------------------------------------------
	-------- Insert Quiz Questions Into Imaginary Table
	----------------------------------------------------------------------------	
	Set @strRowPattern = '/BDWToolBookUpload/Pages/Page'
	Exec sp_xml_preparedocument @intDocQuizQuestions Output, @strXMLData

	Insert into #xmlUploadQuizQuestions
		(
		ToolbookPageID,
		PageTitle

		)

	Select 
		ToolbookPageID,
		PageTitle
	From

		OpenXml 
			(@intDocQuizQuestions, @strRowPattern)
		With
		(
		ToolbookPageID	Varchar(50) 	'@ID',
		PageTitle	Varchar(1000)	'PageTitle'
		)
		
		
		
	----------------------------------------------------------------------------
	-------- Insert Quiz Answers Into Imaginary Table
	----------------------------------------------------------------------------	
	Set @strRowPattern = '/BDWToolBookUpload/Pages/Page/Answers/Answer'
	Exec sp_xml_preparedocument @intDocQuizAnswers Output, @strXMLData

	Insert into #xmlUploadQuizAnswers
		(
		ToolbookQuestionID,
		ToolbookAnswerID,
		AnswerText,
		Correct
		)
	Select 
		ToolbookQuestionID,
		ToolbookAnswerID,
		AnswerText,
		Correct
	From

		OpenXml 
			(@intDocQuizAnswers, @strRowPattern)
		With
		(
		ToolbookQuestionID	Varchar(50) 	'../../@ID',	-- Navigate back up to the question Id from this grandchild node
		ToolbookAnswerID	Varchar(50) 	'@ID',
		AnswerText		Varchar(1000)	'AnswerText',
		Correct			Varchar(255)	'@correct'
		)	

	----------------------------------------------------------------------------------------------------
	-------- Determine if we are uploading a Quiz or a Lesson and whether its an update or a correction
	----------------------------------------------------------------------------------------------------

	Select 
		@strToolbookType 	= ToolBookType, 	-- 'Quiz or Lesson'
		@strUploadType 	= UploadType		-- 'Upload' or 'Correction'
	From
		#xmlUploadHeader

	-- Get Toolbook ID
	Select 	
		@strToolbookID = ToolBookID 
	From 
		#xmlUploadHeader

	-- Get Date Published
	Select 	
		@DatePublished = DatePublished 
	From 
		#xmlUploadHeader
		
		
	-------------------------------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------------------------
	----------- Process Upload from Imaginary Tables
	-------------------------------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------------------------
		
		
		
	If (ltrim(rtrim(@strToolbookType)) = 'QUIZ')
	Begin
		-- Get the quiz ID if it exists
		Set 	@intQuizID 		= dbo.udfGetQuizIDByToolbookIDAndModuleID (@strToolbookID,@intModuleID)

			
			
		-------------------------------------------------------------------------------------------------------------------------------------
		----------- Perform a quiz correction 
		-------------------------------------------------------------------------------------------------------------------------------------
		If (ltrim(rtrim(@strUploadType)) = 'CORRECTION')
		Begin
			
			-- A correction must have an exsisting quiz to correct..
			If (@intQuizID = null)
			Begin
				Select 'Could not find the original Quiz to mark as inactive.' as 'Error'
				Goto ErrorHandler
			End	

			-- Update the Quiz Itself 
			Update
				tblQuiz
			Set
				DatePublished		=	@DatePublished,
				LoadedBy		=	@intUserID,
				DateLoaded		=	getDate(),
				ToolbookLocation=   @strToolLocation
			Where
				QuizID			=	@intQuizID
			
			-- Update the questions.
			Update
				PhysicalTable
			Set
				PhysicalTable.Question = LogicalTable.PageTitle 
			From
				tblQuizQuestion PhysicalTable
			Inner Join
				#xmlUploadQuizQuestions LogicalTable
			On	
				PhysicalTable.QuizID = @intQuizID
			And
				ltrim(rtrim(PhysicalTable.ToolbookPageID)) = ltrim(rtrim(LogicalTable.ToolbookPageID))
				
			-------------------------------------------------------------------------------------------------------------------------------------
			----------- Update this temporary table with the appropriate quiz question ids to simplify the update
			-------------------------------------------------------------------------------------------------------------------------------------
			Update
				LogicalTable
			Set
				LogicalTable.QuizQuestionID = PhysicalTable.QuizQuestionID
			From

				tblQuizQuestion PhysicalTable
			Inner Join
				#xmlUploadQuizAnswers LogicalTable
			On	
				PhysicalTable.QuizID = @intQuizID
			And
				PhysicalTable.ToolbookPageID = LogicalTable.ToolbookQuestionID
			
			-- Update the table with boolean 0 and 1 instead of the string 'True' and 'False'
			Update 
				#xmlUploadQuizAnswers
			set
				bCorrect = 1
			Where
				Correct like '%true%'
			
			-- Update the table with boolean 0 and 1 instead of the string 'True' and 'False'
			Update 
				#xmlUploadQuizAnswers
			set
				bCorrect = 0
			Where
				Correct like '%false%'
			
			-- Update the answers
			Update
				PhysicalTable
			Set
				PhysicalTable.Answer = LogicalTable.AnswerText
				--PhysicalTable.Correct = LogicalTable.bCorrect 		-- The boolean version
			From
				tblQuizAnswer PhysicalTable
			Inner Join
				#xmlUploadQuizAnswers LogicalTable
			On	
				PhysicalTable.QuizQuestionID = LogicalTable.QuizQuestionID
			And
				ltrim(rtrim(PhysicalTable.ToolbookAnswerID)) = ltrim(rtrim(LogicalTable.ToolbookAnswerID))
			
			
		End -- End Quiz Correction

		-------------------------------------------------------------------------------------------------------------------------------------
		----------- Perform an update 
		-------------------------------------------------------------------------------------------------------------------------------------
		If (ltrim(rtrim(@strUploadType)) = 'UPDATE')
		Begin		
			---- Deactivate the existing quiz if it exists
			Update
				tblQuiz
			Set
				Active = 0 
			Where
				ModuleID = @intModuleID
				
			
			INSERT INTO 
				tblQuiz
				(
					ModuleID, 
					ToolbookID, 
					ToolbookLocation, 
					DatePublished, 
					LoadedBy, 
					DateLoaded, 
					Active
				)
			VALUES
				(
					@intModuleID, 
					@strToolbookID, 
					@strToolLocation, 
					@DatePublished, 
					@intUserID,     -- Loaded By
					getDate(),      -- Date Loaded 
					1              -- Active
				)

			-- With the new values

			
			-- Get the new quiz ID for the active quiz
			Set 	@intQuizID 		= dbo.udfGetQuizIDByToolbookIDAndModuleID (@strToolbookID,@intModuleID)		
			-- Verify that the new quiz was inserted
			If (@intQuizID = null)
			Begin
				Select 'Could not find the new Quiz to provide questions and answers for.' as 'Error'
				Goto ErrorHandler
			End	
			
			-- Insert the new questions
			Insert Into tblQuizQuestion
				(
				QuizID,
				ToolbookPageID,
				Question
				)
	
				Select
					@intQuizID,
					ToolbookPageID,
					PageTitle
				From 
					#xmlUploadQuizQuestions
			
			
			-------------------------------------------------------------------------------------------------------------------------------------
			----------- Update this temporary table with the appropriate quiz question ids to simplify the update
			-------------------------------------------------------------------------------------------------------------------------------------
			Update
				LogicalTable
			Set
				LogicalTable.QuizQuestionID = PhysicalTable.QuizQuestionID
			From
				tblQuizQuestion PhysicalTable
			Inner Join
				#xmlUploadQuizAnswers LogicalTable
			On	
				PhysicalTable.QuizID = @intQuizID
			And
				PhysicalTable.ToolbookPageID = LogicalTable.ToolbookQuestionID
			
			-- Update the table with boolean 0 and 1 instead of the string 'True' and 'False'
			Update 
				#xmlUploadQuizAnswers
			set
				bCorrect = 1
			Where
				Correct like '%true%'
			
			-- Update the table with boolean 0 and 1 instead of the string 'True' and 'False'
			Update 
				#xmlUploadQuizAnswers
			set
				bCorrect = 0
			Where
				Correct like '%false%'
			
			
			-- Insert new answers
			Insert Into tblQuizAnswer
				(
				QuizQuestionID,
				ToolbookAnswerID,
				Answer,
				Correct
				)
			 Select 
				QuizQuestionID,
				ToolbookAnswerID,
				AnswerText,
				bCorrect
			From
				#xmlUploadQuizAnswers
				
			
		End  -- End Quiz Update

		
		-- Return message
		Select @strUploadType as 'Message', getDate() as 'Time now', @intQuizID
		
		-- Return Results
		Select 
			#xmlUploadQuizQuestions.PageTitle as 'Corrected Question',
			#xmlUploadQuizAnswers.AnswerText  as 'Corrected Answer'
		From
			#xmlUploadQuizQuestions,#xmlUploadQuizAnswers 
		Where 
			#xmlUploadQuizAnswers.ToolbookQuestionID = #xmlUploadQuizQuestions.ToolbookPageID
		
	End   -- End Quiz
	
	-- Lesson
	If (ltrim(rtrim(@strToolbookType)) = 'LESSON')
	Begin
		-------------------------------------------------------------------------------------------------------------------------------------
		-------------------------------------------------------------------------------------------------------------------------------------
		----------- Process Upload from Imaginary Tables
		-------------------------------------------------------------------------------------------------------------------------------------
		-------------------------------------------------------------------------------------------------------------------------------------

		-- Get the new lesson ID for the active lesson
		Set @intLessonID 	= dbo.udfGetLessonIDByToolbookIDAndModuleID (@strToolbookID,@intModuleID)

		-------------------------------------------------------------------------------------------------------------------------------------
		----------- Perform a Correction
		-------------------------------------------------------------------------------------------------------------------------------------
		If (ltrim(rtrim(@strUploadType)) = 'CORRECTION')
		Begin
			-- Correcting a lesson will require an existing lesson
			If (@intLessonID is null)
			Begin
				Select 'Could not find the LessonID of the lesson to correct..' as 'Error'
				Goto ErrorHandler
			End	

			----------------------------------------------------------------------------------------------------
			--------- Find out how many updates are in the data so that we can check if the current lesson
			--------- has the right number of rows.
			----------------------------------------------------------------------------------------------------

			-- Check number of rows in the new content
			Select @intXMLUpdates = Count(1) from #xmlUploadLessons
			
			-- Check number of rows in the existing content
			Select @intLessons = Count(1) From tblLessonPage Where LessonID = @intLessonID

			-- Compare
			If (@intXMLUpdates <> @intLessons)
			Begin
				Select 'The number of lesson pages in the table is different from the number of lesson pages in the XML File.' as 'Error'
				Goto ErrorHandler
			End	
			
			-- This actually updates the physical tables in salt
			Update
				PhysicalTable
			Set
				PhysicalTable.Title = LogicalTable.PageTitle
			From
				tblLessonPage PhysicalTable
			Inner Join
				#xmlUploadLessons LogicalTable
			On	
				PhysicalTable.LessonID = @intLessonID
			And
				ltrim(rtrim(PhysicalTable.ToolbookPageID)) = ltrim(rtrim(LogicalTable.ToolbookPageID))				
			
			/* 
				The following section was inserted during Salt 3.0.15. It renames the toolbook page IDs
				to page1, page2, ... ,page 15. Etc. 
			*/

			declare @intLessonPageID int
			declare @strToolbookPageID varchar(50)
			declare @index int

			Set @index=0

			DECLARE ToolbookPage CURSOR
			FOR 
			select LessonPageID, ToolbookPageID from tblLessonPage where lessonid = @intLessonID
			Open ToolbookPage

			-- First Read CourseCursor
			FETCH NEXT FROM ToolbookPage Into @intLessonPageID, @strToolbookPageID

			-- Scroll CourseCursor
			WHILE @@FETCH_STATUS = 0	
			BEGIN
				Set @index = @index + 1
				
				UPDATE [tblLessonPage]
				SET [ToolbookPageID]='Page' + cast (@index as varchar)
				WHERE LessonPageID = @intLessonPageID
				
				FETCH NEXT FROM ToolbookPage Into @intLessonPageID, @strToolbookPageID
			END

			-- Finished ToolbookPage
			CLOSE ToolbookPage
			DEALLOCATE ToolbookPage

			
			-- Update the lesson to indicate the new content
			Update
				tblLesson
			Set
				DatePublished	=	@DatePublished,
				LoadedBy		=	@intUserID,
				DateLoaded		=	getDate(),
				ToolbookLocation= 	@strToolLocation
			Where
				LessonID		=	@intLessonID
				
				
				
		End		-- End Lesson Correction
		
		
		
		
		
		
		
		-------------------------------------------------------------------------------------------------------------------------------------
		----------- Perform an update 
		-------------------------------------------------------------------------------------------------------------------------------------
		If (ltrim(rtrim(@strUploadType)) = 'UPDATE')
		Begin
			
			---- Deactive the existing lesson if it exists
			Begin
				Update
					tblLesson
				Set
					Active = 0 
				Where
					ModuleID = @intModuleID
			End

			-- Create the new lesson
			Insert Into tblLesson
			(
			ModuleID,
			ToolbookID, 
			ToolbookLocation,
			DatePublished,
			LoadedBy, 
			DateLoaded, 
			Active
			)
			-- With the values from the old lesson
			VALUES
			(
				@intModuleID,
				@strToolbookID,
				@strToolLocation,
				@DatePublished,
				@intUserID,		-- Loaded By
				getDate(),		-- Date Loaded
				1				-- Active
			)
			-- Get the new lesson id
			Set 	@intLessonID 		= dbo.udfGetLessonIDByToolbookIDAndModuleID (@strToolbookID,@intModuleID)		

			-- Verify that the new lesson was created
			If (@intLessonID = null)
			Begin
				Select 'Could not find the new Lesson to provide pages for.' as 'Error'
				Goto ErrorHandler
			End	
		
			-- Insert the new lesson pages
			Insert Into tblLessonPage
				(
				LessonID,
				ToolbookPageID,
				Title
				)
	
				Select
					@intLessonID,
					ToolbookPageID,
					PageTitle
				From 
					#xmlUploadLessons
				
		End		-- End Lesson Update
		
		-- Return message
		Select @strUploadType as 'Message', getDate() as 'Time now',@intLessonID as 'Lesson ID'
		
		-- Return Results
		Select 
			#xmlUploadLessons.PageTitle as 'Corrected Lesson'
		From
			#xmlUploadLessons
		
	End



	Commit

	Return


--------------------------------------------------------------------
-----------------
--------------------------------------------------------------------

ErrorHandler:

	Rollback
	Return

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prcToolbook_Preview]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prcToolbook_Preview]
GO


/*
Summary: Displays a preview of the data from an XML document before inserting it into the tblLesson,tblLessonPage,tblQuiz, tblQuizQuestion, tblQuizAnswer table
Parameters: 
		@strXMLData Text = null, 	-- XML document
		@intModuleID	Integer		-- Module Id of the module
Returns: 
		two Result sets

		-- Return Results
		One: The first result set has the totals for the Upload
			The Upload Type - Correction or Update
			The Toolbook Type - Lesson or Quiz
		
		Two: The second result set holds the detail of the records that will be inserted if spImportToolbook is called.

		
Called By: 
		Toolbook.cs
Calls: 
		sp_xml_preparedocument -- system stored procedure to ALTER  an internal representation of the XML document.
		udfGetQuizIDByToolbookIDAndModuleID
		udfGetLessonIDByToolbookIDAndModuleID
		
Remarks: The XML document must be well formed otherwise the process will fail.

Author: Peter Kneale
Date Created: 23rd of February 2004

Modification History
-----------------------------------------------------------
v#	Author			Date			Description
#1	Jack Liu		12/09/2005		Add extra validation for Quiz CORRECTION
									For Quiz CORRECTION, the correct answer can't be changed.
v#	Author			Date			Description
#2	Liz Dionisio	28/09/2005		Modified Quiz Correction validation
*/
CREATE Procedure prcToolbook_Preview
	(
		@strXMLData     NText = null, 	-- XML document
		@intModuleID	Integer       = null		-- Module Id of the module
	)

As
	Set NoCount On
	Set Xact_Abort On
	
	-- Check if the XML document was passed.
	If(@strXMLData Is Null)
	Begin
		Raiserror('The @strXMLData parameter was Null.  You must supply a valid XML document.', 16, 1)
		Return
	End
	If(@intModuleID Is Null)
	Begin
		Raiserror('The @intModuleID parameter was Null.  You must supply a valid XML document.', 16, 1)
		Return
	End



Begin Transaction

	Declare @intDocHeader			 	Integer		-- 
	Declare @strRowPattern 				Varchar(50)	-- Pattern to match on when calling OpenXML
	Declare @strToolbookType 			Varchar(50)	-- Lesson or Quiz
	Declare @strUploadType				Varchar(50)	-- Correction or Update
	Declare @strToolbookID				Varchar(50)	-- Toolbook ID
	Declare @DatePublished				DateTime	-- Date new content was published
	Declare @intXMLUpdates				Integer		-- Number of updates contained in the XML file.
	
	-- Quiz specific
	Declare @intQuizID				Integer		-- Salt QuizID
	Declare @intQuestions				Integer		-- Number of Questions
	Declare @intAnswers				Integer		-- Number of Answers
	Declare @intDocQuizQuestions			Integer		-- Number of Questions in new content
	Declare @intDocQuizAnswers			Integer		-- Number of Answer in new content
	
	-- Lesson specific
	Declare @intLessonID				Integer		-- Salt Lesson ID
	Declare @intLessons				Integer		-- Number of Lesson pages 
	Declare @intDocLessons				Integer		-- Number of Lesson pages in new content
	
	-------------------------------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------------------------
	----------- Create Necessary Temporary Tables
	-------------------------------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------------------------
	
	----------------------------------------------------------------------------
	-------- Create Temporary Table for Quiz Questions
	----------------------------------------------------------------------------
	Create Table #xmlUploadQuizQuestions
		(
		ToolbookPageID	Varchar(50),		-- Toolbook Page ID for new Quiz Question
		PageTitle 		Varchar(255)		-- Toolbook Question for new Quiz Question
		)
		
	----------------------------------------------------------------------------
	-------- Create Imaginary Table for Quiz Answers
	----------------------------------------------------------------------------
	Create Table #xmlUploadQuizAnswers
		(
		ToolbookQuestionID	Varchar(50),		-- Toolbook Question ID for new Quiz Answer
		ToolbookAnswerID	Varchar(50),		-- Toolbook Answer ID for new Quiz Answer
		Correct 		Varchar(255),		-- 'True' or 'False' indicating whether this answer is correct or not
		bCorrect 		bit,			-- 0 or 1 indicating if the answer is correct, this is derived from the Correct Column
		AnswerText		Varchar(255),		-- The answer
		QuizQuestionID		Integer			-- Salt Quiz Question ID column is a placeholder but is later populated to assist in the upload
		)
	
	----------------------------------------------------------------------------
	-------- Create Imaginary Table for Lessons
	----------------------------------------------------------------------------
	Create Table #xmlUploadLessons
		(
		ToolbookPageID	Varchar(50),		    -- Toolbook Page ID for new Lesson
		PageTitle 	Varchar(255)		    -- Toolbook Page Title for new Lesson
		)
	----------------------------------------------------------------------------
	-------- Create Imaginary Table for Upload Information
	----------------------------------------------------------------------------
	Create Table #xmlUploadHeader
		(
		ToolBookID		Varchar(50),		    	-- Toolbook ID for new Content
		ToolBookType 		Varchar(50),		    	-- Toolbook type, Quiz or Lesson
		NumberOfPages 	   	Integer,			-- Number of Pages in new content
		DatePublished		DateTime,		        -- Date new content was published
		UploadType		Varchar(50)		        -- New Content type, 'Correction' , 'Update'
		)

	-- Temporary Tables used for validating the number of questions and answers in the
	-- new content compared to the old content
	Declare @xmlExisting Table
		(
		QuizQuestionID	Varchar(50),		-- Toolbook Page ID for new Quiz Question
		Answers 	Varchar(255)		-- Toolbook Question for new Quiz Question
		) 
	Declare @xmlNew Table
		(
		QuizQuestionID	Varchar(50),		-- Toolbook Page ID for new Quiz Question
		Answers 	Varchar(255)		-- Toolbook Question for new Quiz Question
		) 
				

	----------------------------------------------------------------------------
	-------- Insert Upload Information Into Imaginary Table

	----------------------------------------------------------------------------
	Set @strRowPattern = '/BDWToolBookUpload'
	Exec sp_xml_preparedocument @intDocHeader Output, @strXMLData

	Insert into #xmlUploadHeader
		(
		ToolBookID,
		ToolBookType,
		NumberOfPages,
		DatePublished,
		UploadType
		)

	Select 
		ToolBookID,
		ToolBookType,
		NumberOfPages,
		DatePublished,
		UploadType
	From

		OpenXml 
			(@intDocHeader, @strRowPattern)
		With
			(
			ToolBookID		Varchar(50) 	'ToolBookID',
			ToolBookType		Varchar(50)		'ToolBookType',
			NumberOfPages		Integer			'NumberOfPages',
			DatePublished		DateTime		'DatePublished',
			UploadType		Varchar(50)		'UploadType'
			)

	
	----------------------------------------------------------------------------
	-------- Insert Lessons Into Imaginary Table
	----------------------------------------------------------------------------	
	Set @strRowPattern = '/BDWToolBookUpload/Pages/Page'
	Exec sp_xml_preparedocument @intDocLessons Output, @strXMLData

	Insert into #xmlUploadLessons
		(
		ToolbookPageID,
		PageTitle
		)


	Select 
		ToolbookPageID,
		PageTitle
	From

		OpenXml 
			(@intDocLessons, @strRowPattern)
		With
			(
			ToolbookPageID	Varchar(50) 	'@ID',
			PageTitle		Varchar(255)	'PageTitle'
			)
		
	----------------------------------------------------------------------------
	-------- Insert Quiz Questions Into Imaginary Table
	----------------------------------------------------------------------------	
	Set @strRowPattern = '/BDWToolBookUpload/Pages/Page'
	Exec sp_xml_preparedocument @intDocQuizQuestions Output, @strXMLData

	Insert into #xmlUploadQuizQuestions
		(
		ToolbookPageID,
		PageTitle
		)

	Select 

		ToolbookPageID,
		PageTitle
	From

		OpenXml 
			(@intDocQuizQuestions, @strRowPattern)
		With
		(
		ToolbookPageID	Varchar(50) 	'@ID',
		PageTitle		Varchar(255)	'PageTitle'
		)
		
	----------------------------------------------------------------------------
	-------- Insert Quiz Answers Into Imaginary Table
	----------------------------------------------------------------------------	
	Set @strRowPattern = '/BDWToolBookUpload/Pages/Page/Answers/Answer'
	Exec sp_xml_preparedocument @intDocQuizAnswers Output, @strXMLData

	Insert into #xmlUploadQuizAnswers
		(
		ToolbookQuestionID,
		ToolbookAnswerID,
		AnswerText,
		Correct
		)
	Select 
		ToolbookQuestionID,
		ToolbookAnswerID,
		AnswerText,
		Correct
	From

		OpenXml 
			(@intDocQuizAnswers, @strRowPattern)
			With
			(
			ToolbookQuestionID	Varchar(50) 	'../../@ID',  -- navigate back up to the question 
			ToolbookAnswerID	Varchar(50) 	'@ID',
			AnswerText			Varchar(255)	'AnswerText',
			Correct				Varchar(255)	'@correct'
			)
			


	----------------------------------------------------------------------------------------------------
	-------- Determine if we are uploading a Quiz or a Lesson and whether its an update or a correction
	----------------------------------------------------------------------------------------------------
	Select 
		@strToolbookType = ToolBookType, @strUploadType = UploadType
	From
		#xmlUploadHeader

		
		
	If (ltrim(rtrim(@strToolbookType)) = 'quiz')
	Begin
		-------------------------------------------------------------------------------------------------------------------------------------
		-------------------------------------------------------------------------------------------------------------------------------------
		----------- Process Upload from Imaginary Tables
		-------------------------------------------------------------------------------------------------------------------------------------
		-------------------------------------------------------------------------------------------------------------------------------------
		Select 	@strToolbookID 	= ToolBookID From #xmlUploadHeader
		Select 	@DatePublished 	= DatePublished From #xmlUploadHeader
		Set 	@intQuizID 		= dbo.udfGetQuizIDByToolbookIDAndModuleID (@strToolbookID,@intModuleID)
	
		
		-------------------------------------------------------------------------------------------------------------------------------------
		----------- Perform a correction 
		-------------------------------------------------------------------------------------------------------------------------------------
		If (ltrim(rtrim(@strUploadType)) = 'correction')
		Begin
			
			--Validation
			----------------------------------------------------------------------------------------------------
			---------1.  An current quiz must exist in order to perform a correction
			----------------------------------------------------------------------------------------------------
			if (@intQuizID is null)
			Begin
				select '[Quiz Correction] No existing active quiz for this module or new Toolbook name does not match existing quiz' as 'Error'
				Goto ErrorHandler
			End
			
			--2. The number of answers in each question are the same
			-------------------------------------------------------------------------------------------------------------------------------------
			----------- Update this temporary table with the appropriate quiz question ids to simplify the update
			-------------------------------------------------------------------------------------------------------------------------------------
			Update
				LogicalTable
			Set
				LogicalTable.QuizQuestionID = PhysicalTable.QuizQuestionID
			From
				tblQuizQuestion PhysicalTable
			Inner Join
				#xmlUploadQuizAnswers LogicalTable
			On	
				PhysicalTable.QuizID = @intQuizID
			And
				PhysicalTable.ToolbookPageID = LogicalTable.ToolbookQuestionID
			
			----------------------------------------------------------------------------------------------------
			--------- Find out how many updates are in the data so that we can check if the current quiz
			--------- has the right number of questions.
			----------------------------------------------------------------------------------------------------
			
			-- Insert Existing Questions
			Insert Into
				@xmlExisting
				select 
					tblQuizQuestion.QuizQuestionID as 'QuizQuestionID',
					count(answer) as 'Answers'
				from 
					tblQuizQuestion 
				inner join 
					tblQuizAnswer 
					on 
						tblQuizQuestion.QuizQuestionID = tblQuizAnswer.QuizQuestionID
				Where 
					tblQuizQuestion.QuizID = @intQuizID
				Group by 
					tblQuizQuestion.QuizQuestionID,ToolbookPageID


			Insert Into
				@xmlNew 
				select 
					tA.QuizQuestionID as 'QuizQuestionID',
					count(tA.AnswerText) as 'Answers'
				from 
					#xmlUploadQuizQuestions tQ
				inner join
					#xmlUploadQuizAnswers tA
				on 
					tQ.ToolbookPageID = tA.ToolbookQuestionID
				group by 
					tA.QuizQuestionID,ToolbookPageID

			if Exists 
				(
				Select 
					* 
				from 	@xmlNew tN
					left join @xmlExisting tE on 	tN.QuizQuestionId = tE.QuizQuestionID
							and tN.Answers = tE.Answers
				Where
					tE.QuizQuestionID is null
				)
				Begin
					select '[Quiz Correction] There is a different number of Questions/Answers in the Content and the Database' as 'Error'
					Goto ErrorHandler
				End
				
			--3. The correct answer no# are the same
			--For example: For question 1, the Answers for A, C, D  are wrong, B is right, when correct, A,C,D shoul be still wrong, and B is Right.
			-- 		If A is right, and B,C,D are wrong, this is update rather than correct
			-- Update the table with boolean 0 and 1 instead of the string 'True' and 'False'
			Update 
				#xmlUploadQuizAnswers
			set
				bCorrect = 1
			Where
				Correct like '%true%'
			
			-- Update the table with boolean 0 and 1 instead of the string 'True' and 'False'
			Update 
				#xmlUploadQuizAnswers
			set
				bCorrect = 0
			Where
				Correct like '%false%'
			
			if exists (
				select *
				From
					#xmlUploadQuizAnswers LogicalTable
					left join tblQuizAnswer PhysicalTable
						On	PhysicalTable.QuizQuestionID = LogicalTable.QuizQuestionID
						And	ltrim(rtrim(PhysicalTable.ToolbookAnswerID)) = ltrim(rtrim(LogicalTable.ToolbookAnswerID))
						And	PhysicalTable.Correct=LogicalTable.bCorrect
				where PhysicalTable.ToolbookAnswerID is null
			)
			begin
						select '[Quiz Correction] The correct answers are different between the Content and the Database' as 'Error'
						Goto ErrorHandler
			end
			
			-- Return message
			Select @strUploadType as 'UploadType', @strToolbookType as 'ToolbookType'
			
			-- Return Results
			Select 
				#xmlUploadQuizQuestions.PageTitle as 'Corrected Questions',
				#xmlUploadQuizAnswers.AnswerText  as 'Corrected Answers'
			From
				#xmlUploadQuizQuestions,#xmlUploadQuizAnswers 
			Where 
				#xmlUploadQuizAnswers.ToolbookQuestionID = #xmlUploadQuizQuestions.ToolbookPageID
		End -- End Quiz Correction

		-------------------------------------------------------------------------------------------------------------------------------------
		----------- Perform an update 
		-------------------------------------------------------------------------------------------------------------------------------------
		If (ltrim(rtrim(@strUploadType)) = 'UPDATE')
		Begin		
			-- Return message
			Select @strUploadType as 'Message', @strToolbookType as 'ToolbookType'
			
			-- Return Results
			Select 
				#xmlUploadQuizQuestions.PageTitle as 'Updated Questions',
				#xmlUploadQuizAnswers.AnswerText  as 'Updated Answers'
			From
				#xmlUploadQuizQuestions,#xmlUploadQuizAnswers 
			Where 
				#xmlUploadQuizAnswers.ToolbookQuestionID = #xmlUploadQuizQuestions.ToolbookPageID
		End  -- End Quiz Update
		

	End   -- End Quiz
		
		
		
		
	-- Lesson
	If (ltrim(rtrim(@strToolbookType)) = 'LESSON')
	Begin
		-------------------------------------------------------------------------------------------------------------------------------------
		-------------------------------------------------------------------------------------------------------------------------------------
		----------- Process Upload from Imaginary Tables
		-------------------------------------------------------------------------------------------------------------------------------------
		-------------------------------------------------------------------------------------------------------------------------------------
		Select 	
			@strToolbookID = ToolBookID 
		From 
			#xmlUploadHeader
		Select 	
			@DatePublished = DatePublished 
		From 	
			#xmlUploadHeader

		-- Get the lesson ID
		Set 	@intLessonID 		= dbo.udfGetLessonIDByToolbookIDAndModuleID (@strToolbookID,@intModuleID)
		
		-------------------------------------------------------------------------------------------------------------------------------------
		----------- Perform a Correction
		-------------------------------------------------------------------------------------------------------------------------------------
		If (ltrim(rtrim(@strUploadType)) = 'CORRECTION')
		Begin
			-- Corrections require an existing lesson
			If (@intLessonID is null)
			Begin
				select '[Lesson Correction] No existing active lesson for this module or new Toolbook name does not match existing lesson' as 'Error'
				Goto ErrorHandler
			End	

			----------------------------------------------------------------------------------------------------
			--------- Find out how many updates are in the data so that we can check if the current lesson
			--------- has the right number of rows.
			----------------------------------------------------------------------------------------------------

			-- Get number of lessons from new content
			Select 
				@intXMLUpdates = Count(1) 
			From 
				#xmlUploadLessons
			
			-- Get number of lessons from salt
			Select 
				@intLessons = Count(1) 
			From 
				tblLessonPage 
			Where 
				LessonID = @intLessonID
			
			-- Compare
			If (@intXMLUpdates <> @intLessons)
			Begin
				select '[Lesson Correction] Different number of pages to existing lesson' as 'Error'
				Goto ErrorHandler
			End	

			-- Return message
			Select 
				@strUploadType 	as 'Message', 
				@strToolbookType 	as 'ToolbookType', 
				getDate() 		as 'Time now',
				@intLessonID
			
			-- Return Results
			Select 
				#xmlUploadLessons.PageTitle as 'Corrected Lesson'
			From
				#xmlUploadLessons

		End-- End Lesson Correction
		
		
		-------------------------------------------------------------------------------------------------------------------------------------
		----------- Perform an update 
		-------------------------------------------------------------------------------------------------------------------------------------
		If (ltrim(rtrim(@strUploadType)) = 'UPDATE')
		Begin
			
			-- Return message
			Select 
				@strUploadType 	as 'Message', 
				@strToolbookType 	as 'ToolbookType', 
				getDate() 		as 'Time now',
				@intLessonID
			
			-- Return Results
			Select 
				#xmlUploadLessons.PageTitle as 'Updated Lesson'
			From
				#xmlUploadLessons
				
		End-- End Lesson Update
		
	End



Commit
Return

ErrorHandler:
rollback
Return

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



  