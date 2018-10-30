IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcSCORMimport]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [prcSCORMimport]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcSCORMimport]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
Create PROCEDURE [dbo].[prcSCORMimport]
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

SELECT @intLessonID
END
' 
END
GO