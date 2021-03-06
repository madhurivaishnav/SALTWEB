SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcSCORMimport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcSCORMimport]
@intModuleID integer,
@strToolLocation varchar(100),
@strQFSLocation varchar(100),
@DatePublished datetime,
@intUserID integer,
@SCORMsource varchar(100)
AS
BEGIN
--Set @intLessonID 	= dbo.udfGetLessonIDByToolbookIDAndModuleID (@strToolbookID,@intModuleID)


Declare @LWorkSiteID nvarchar(50)
Declare @QFWorkSiteID nvarchar(50)
Declare @intLessonID integer
Declare @intquizID integer

Select @LWorkSiteID = LWorkSiteID, @QFWorkSiteID = QFWorkSiteID From tblLesson Where LessonID = @intLessonID

---- Deactivate the existing lesson if it exists
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
QFSlocation,
DatePublished,
LoadedBy,
DateLoaded,
Active,
LWorkSiteID,
QFWorkSiteID,
Scorm1_2
)
-- With the values from the old lesson
VALUES
(
@intModuleID,
''SCOnew'',
@strToolLocation,
@strQFSLocation,
@DatePublished,
@intUserID,		-- Loaded By
GETDATE(),		-- Date Loaded
1,				-- Active
@LWorkSiteID,
@QFWorkSiteID,
1
)
-- Get the new lesson id
SELECT 	@intLessonID =  LessonID FROM tblLesson where Active = 1 AND ModuleID = @intModuleID

UPDATE tblLesson set ToolbookID = ''SCO'' + CAST(LessonID as varchar(9)) WHERE LessonID = @intLessonID

-- Insert the new lesson pages
Insert Into tblLessonPage
(
LessonID,
ToolbookPageID,
Title
)

Select
@intLessonID,
''SCORM 1.2 lesson'',
''IFRAME 1.2''

--delete bookmarks to old content
DELETE FROM tblScormDME where lessonID = @intModuleID

Declare @QuizLaunchPoint nvarchar(100)
SELECT @QuizLaunchPoint =   COALESCE(QuizLaunchPoint,'' '') FROM tblSCORMcontent WHERE LessonLaunchPoint = @SCORMsource 
IF @QuizLaunchPoint <> '' ''
BEGIN

    Declare @strToolLocationReverse varchar(100)
    Declare  @strToolDirectory varchar(100)
    SELECT @strToolLocationReverse = reverse (@strToolLocation)
    SELECT @strToolDirectory = substring(@strToolLocation,1, LEN(@strToolLocation)-CHARINDEX ( ''/'' ,@strToolLocationReverse)  ) 
	Update tblQuiz Set Active = 0 Where ModuleID = @intModuleID
	INSERT INTO tblQuiz
           ([ModuleID]
           ,[ToolbookID]
           ,[ToolbookLocation]
           ,[DatePublished]
           ,[LoadedBy]
           ,[DateLoaded]
           ,[Active]
           ,[WorksiteID]
           ,Scorm1_2
           ,LectoraBookmark    )
     VALUES
           (@intModuleID
           ,''SCO''
           ,@strToolLocation 
           -- ,@strToolDirectory +''/''+@QuizLaunchPoint
           ,@DatePublished
           ,1
           ,getUTCdate()
           ,1
           ,null,1
           ,@QuizLaunchPoint  )
         SELECT 	@intquizID =  quizID FROM tblQuiz where Active = 1 AND ModuleID = @intModuleID

UPDATE tblQuiz set ToolbookID = ''SCO'' + CAST(quizID as varchar(9)) WHERE quizID = @intquizID  
END

SELECT @intLessonID
END
' 
END
GO
