/****** Object:  StoredProcedure [dbo].[prcSCORMpublishcontent]    Script Date: 12/19/2012 15:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcSCORMpublishcontent]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcSCORMpublishcontent]
	@LessonLaunchPoint nvarchar(100) ,
	@QFS nvarchar(100) ,
	@QuizLaunchPoint [nvarchar](100) ,
	@CourseName [nvarchar](100) ,
	@ModuleName [nvarchar](100) 
AS
BEGIN

INSERT INTO tblSCORMcontent
           ([LessonLaunchPoint]
           ,[QFS]
           ,[QuizLaunchPoint]
           ,[CourseName]
           ,[ModuleName])
     VALUES
           (@LessonLaunchPoint
           ,@QFS
           ,@QuizLaunchPoint
           ,@CourseName
           ,@ModuleName)
END
' 
END
GO
