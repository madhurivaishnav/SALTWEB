SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcSCORMgetValue]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[prcSCORMgetValue] (
             @StudentID int,
             @LessonID int,
             @DME  varchar(50)
           )  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
if @DME=''cmi.core.lesson_location''
begin
		SELECT  Q.lectoraBookmark from tblLesson L 
		inner join tblQuiz Q on L.ModuleID =  Q.ModuleID where L.Active = 1 and Q.Active = 1 and L.lessonID = @lessonID
end
else
begin
	if not exists(	SELECT [value] FROM  tblScormDME WHERE UserID = @StudentID and LessonID = @LessonID and DME = @DME)
	begin 
		select ''''
	end
	else
	begin 
		SELECT [value] FROM  tblScormDME
		WHERE UserID = @StudentID
		and LessonID = @LessonID
		and DME = @DME
	end
end
END
' 
END
GO
