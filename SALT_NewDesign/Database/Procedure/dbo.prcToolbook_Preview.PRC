SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcToolbook_Preview]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
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
For Quiz CORRECTION, the correct answer can''t be changed.
#2	Liz Dionisio	28/09/2005		Modified Quiz Correction validation
#3	mikev			4/5/2007		Removed correction logic
*/
CREATE Procedure [prcToolbook_Preview]
(
@strXMLData     NText = null, 	-- XML document
@intModuleID	Integer       = null,		-- Module Id of the module
@intUserID int
)

As
Set NoCount On
Set Xact_Abort On

-- Check if the XML document was passed.
If(@strXMLData Is Null)
Begin
Raiserror(''The @strXMLData parameter was Null.  You must supply a valid XML document.'', 16, 1)
Return
End
If(@intModuleID Is Null)
Begin
Raiserror(''The @intModuleID parameter was Null.  You must supply a valid XML document.'', 16, 1)
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
Correct 		Varchar(255),		-- ''True'' or ''False'' indicating whether this answer is correct or not
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
UploadType		Varchar(50)		        -- New Content type, ''Correction'' , ''Update''
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
Set @strRowPattern = ''/BDWToolBookUpload''
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
ToolBookID		Varchar(50) 	''ToolBookID'',
ToolBookType		Varchar(50)		''ToolBookType'',
NumberOfPages		Integer			''NumberOfPages'',
DatePublished		DateTime		''DatePublished'',
UploadType		Varchar(50)		''UploadType''
)


----------------------------------------------------------------------------
-------- Insert Lessons Into Imaginary Table
----------------------------------------------------------------------------
Set @strRowPattern = ''/BDWToolBookUpload/Pages/Page''
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
ToolbookPageID	Varchar(50) 	''@ID'',
PageTitle		Varchar(255)	''PageTitle''
)

----------------------------------------------------------------------------
-------- Insert Quiz Questions Into Imaginary Table
----------------------------------------------------------------------------
Set @strRowPattern = ''/BDWToolBookUpload/Pages/Page''
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
ToolbookPageID	Varchar(50) 	''@ID'',
PageTitle		Varchar(255)	''PageTitle''
)

----------------------------------------------------------------------------
-------- Insert Quiz Answers Into Imaginary Table
----------------------------------------------------------------------------
Set @strRowPattern = ''/BDWToolBookUpload/Pages/Page/Answers/Answer''
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
ToolbookQuestionID	Varchar(50) 	''../../@ID'',  -- navigate back up to the question
ToolbookAnswerID	Varchar(50) 	''@ID'',
AnswerText			Varchar(255)	''AnswerText'',
Correct				Varchar(255)	''@correct''
)



----------------------------------------------------------------------------------------------------
-------- Determine if we are uploading a Quiz or a Lesson and whether its an update or a correction
----------------------------------------------------------------------------------------------------
Select
@strToolbookType = ToolBookType, @strUploadType = UploadType
From
#xmlUploadHeader



If (ltrim(rtrim(@strToolbookType)) = ''quiz'')
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
----------- Perform an update
-------------------------------------------------------------------------------------------------------------------------------------
-- Return message
Select @strUploadType as ''Message'', @strToolbookType as ''ToolbookType''

-- Return Results
Select
#xmlUploadQuizQuestions.PageTitle as ''Updated Questions'',
#xmlUploadQuizAnswers.AnswerText  as ''Updated Answers''
From
#xmlUploadQuizQuestions,#xmlUploadQuizAnswers
Where
#xmlUploadQuizAnswers.ToolbookQuestionID = #xmlUploadQuizQuestions.ToolbookPageID

End   -- End Quiz




-- Lesson
If (ltrim(rtrim(@strToolbookType)) = ''LESSON'')
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
----------- Perform an update
-------------------------------------------------------------------------------------------------------------------------------------
-- Return message
Select
@strUploadType 	as ''Message'',
@strToolbookType 	as ''ToolbookType'',
GETDATE() 		as ''Time now'',
@intLessonID

-- Return Results
Select
#xmlUploadLessons.PageTitle as ''Updated Lesson''
From
#xmlUploadLessons


End



Commit
Return

ErrorHandler:
rollback
Return
' 
END
GO
