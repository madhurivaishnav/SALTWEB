SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcToolbook_Import]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
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
For Quiz CORRECTION, the correct answer can''t be changed, this is validated in the prcToolbook_preview
#2	mikev		4/5/2007		Added worksiteIDs for Quiz and Lesson and that the value is copied from the old quiz/lesson to the new one.
#3	mike		4/5/2007		There is no longer a concept of corrections. All uploads are now considered updates. I have removed the updatetype variable, update statement logic and the insert logic remains.

*/
CREATE  Procedure [prcToolbook_Import]
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
Raiserror(''The @strXMLData parameter was Null.  You must supply a valid XML document.'', 16, 1)
Return
End

-- Check if the ID was passed.
If(@intUserID Is Null)
Begin
Raiserror(''The @intUserID parameter was Null.  You must supply a value.'', 16, 1)
Return
End

-- Check if the Module ID was passed.
If(@intModuleID Is Null)
Begin
Raiserror(''The @intModuleID parameter was Null.  You must supply a value.'', 16, 1)
Return
End

-- Check if the Course ID was passed.
If(@intCourseID Is Null)
Begin
Raiserror(''The @intCourseID parameter was Null.  You must supply a value.'', 16, 1)
Return
End

-- Check if the Toolbook Location was passed.
If(@strToolLocation Is Null)
Begin
Raiserror(''The @strToolLocation parameter was Null.  You must supply a value.'', 16, 1)
Return
End




Declare @intDocHeader			 	Integer
Declare @strRowPattern 				nVarchar(50)
Declare @strToolbookType 			nVarchar(50)
Declare	@strUploadType				nVarchar(50)
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
Correct 		Varchar(255),	-- ''True'' or ''False'' indicating if the answer is correct
bCorrect 		bit,		-- 0 or 1 indicating if the answer is correct, this is derived from the Correct Column
AnswerText		nVarchar(1000),	-- The textual answer
QuizQuestionID		Integer		-- The QuizQuestion ID from the Salt Database.
)

----------------------------------------------------------------------------
-------- Create Temporary Table for Quiz Questions
----------------------------------------------------------------------------
Create Table #xmlUploadQuizQuestions
(
ToolbookPageID	Varchar(50),
PageTitle 		nVarchar(1000),
)

----------------------------------------------------------------------------
-------- Create Imaginary Table for Quiz Answers
----------------------------------------------------------------------------
Create Table #xmlUploadLessons
(
ToolbookPageID	Varchar(50),
PageTitle 		nVarchar(1000),
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
ToolBookType		Varchar(50)	''ToolBookType'',
NumberOfPages		Integer		''NumberOfPages'',
DatePublished		DateTime	''DatePublished'',
UploadType		Varchar(50)	''UploadType''
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
PageTitle	nVarchar(1000)	''PageTitle''
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
PageTitle	nVarchar(1000)	''PageTitle''
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
ToolbookQuestionID	Varchar(50) 	''../../@ID'',	-- Navigate back up to the question Id from this grandchild node
ToolbookAnswerID	Varchar(50) 	''@ID'',
AnswerText		nVarchar(1000)	''AnswerText'',
Correct			Varchar(255)	''@correct''
)

----------------------------------------------------------------------------------------------------
-------- Determine if we are uploading a Quiz or a Lesson and whether its an update or a correction
----------------------------------------------------------------------------------------------------

Select
@strToolbookType 	= ToolBookType 	-- ''Quiz or Lesson''
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



If (ltrim(rtrim(@strToolbookType)) = ''QUIZ'')
Begin
-- Get the quiz ID if it exists
Set 	@intQuizID 		= dbo.udfGetQuizIDByToolbookIDAndModuleID (@strToolbookID,@intModuleID)


-------------------------------------------------------------------------------------------------------------------------------------
----------- Perform an update
-------------------------------------------------------------------------------------------------------------------------------------

Declare @WorksiteID nvarchar(50)

Select @WorksiteID = WorksiteID From tblQuiz Where QuizID = @intQuizID

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
Active,
WorkSiteID
)
VALUES
(
@intModuleID,
@strToolbookID,
@strToolLocation,
@DatePublished,
@intUserID,     -- Loaded By
GETDATE(),      -- Date Loaded
1,              -- Active
@WorksiteID
)

-- With the new values


-- Get the new quiz ID for the active quiz
Set 	@intQuizID 		= dbo.udfGetQuizIDByToolbookIDAndModuleID (@strToolbookID,@intModuleID)
-- Verify that the new quiz was inserted
If (@intQuizID = null)
Begin
Select ''Could not find the new Quiz to provide questions and answers for.'' as ''Error''
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

-- Update the table with boolean 0 and 1 instead of the string ''True'' and ''False''
Update
#xmlUploadQuizAnswers
set
bCorrect = 1
Where
Correct like ''%true%''

-- Update the table with boolean 0 and 1 instead of the string ''True'' and ''False''
Update
#xmlUploadQuizAnswers
set
bCorrect = 0
Where
Correct like ''%false%''


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



-- Return message
Select @strUploadType as ''Message'', GETDATE() as ''Time now'', @intQuizID


-- Return Results
Select
#xmlUploadQuizQuestions.PageTitle as ''Corrected Question'',
#xmlUploadQuizAnswers.AnswerText  as ''Corrected Answer''
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

-- Get the new lesson ID for the active lesson
Set @intLessonID 	= dbo.udfGetLessonIDByToolbookIDAndModuleID (@strToolbookID,@intModuleID)

-------------------------------------------------------------------------------------------------------------------------------------
----------- Perform an update
-------------------------------------------------------------------------------------------------------------------------------------

-- mikev(2)
Declare @LWorkSiteID nvarchar(50)
Declare @QFWorkSiteID nvarchar(50)

Select @LWorkSiteID = LWorkSiteID, @QFWorkSiteID = QFWorkSiteID From tblLesson Where LessonID = @intLessonID

---- Deactive the existing lesson if it exists
Begin
Update
tblLesson
Set
Active = 0
Where
ModuleID = @intModuleID
End

-- mikev(2)
-- Create the new lesson
Insert Into tblLesson
(
ModuleID,
ToolbookID,
ToolbookLocation,
DatePublished,
LoadedBy,
DateLoaded,
Active,
LWorkSiteID,
QFWorkSiteID
)
-- With the values from the old lesson
VALUES
(
@intModuleID,
@strToolbookID,
@strToolLocation,
@DatePublished,
@intUserID,		-- Loaded By
GETDATE(),		-- Date Loaded
1,				-- Active
@LWorkSiteID,
@QFWorkSiteID
)
-- Get the new lesson id
Set 	@intLessonID 		= dbo.udfGetLessonIDByToolbookIDAndModuleID (@strToolbookID,@intModuleID)

-- Verify that the new lesson was created
If (@intLessonID = null)
Begin
Select ''Could not find the new Lesson to provide pages for.'' as ''Error''
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


-- Return message
Select @strUploadType as ''Message'', GETDATE() as ''Time now'',@intLessonID as ''Lesson ID''

-- Return Results
Select
#xmlUploadLessons.PageTitle as ''Corrected Lesson''
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
' 
END
GO
