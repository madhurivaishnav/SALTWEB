SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcSCORMsetValue]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcSCORMsetValue] (
             @StudentID int,
             @LessonID int,
             @DME  varchar(50),
             @value  varchar(4000)
           )  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    DELETE FROM tblScormDME where UserID = @StudentID and LessonID = @LessonID and DME = @DME
    DECLARE @quizAnswer varchar(100)
    SET @quizAnswer = @DME 

    IF LEN(@quizAnswer) >= 14  set @quizAnswer =	SUBSTRING(@quizAnswer,1,15)

    if (@quizAnswer <> ''cmi.interaction'')
    BEGIN  
	INSERT INTO tblScormDME
           (UserID
           ,LessonID
           ,DME
           ,[value])
     VALUES (
           @StudentID,
           @LessonID, 
           @DME, 
           @value)
      END     
END

' 
END
GO
