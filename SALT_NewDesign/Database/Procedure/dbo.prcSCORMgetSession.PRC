SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcSCORMgetSession]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [prcSCORMgetSession] (
             @StudentID int,
             @LessonID int,
            @isLesson bit  
           )  
AS
BEGIN
	SET NOCOUNT ON;
DECLARE @RC int
DECLARE @OrganisationID int
DECLARE @NumQuestions int
DECLARE @quizpassmark int
DECLARE @Name nvarchar(255)
SET @Name = N''Number_Of_Quiz_Questions''
SELECT @OrganisationID = OrganisationID FROM tblUser WHERE UserID = @StudentID
SELECT @quizpassmark = DefaultQuizPassMark FROM tblOrganisation WHERE OrganisationID = @organisationID 
--EXECUTE @NumQuestions = prcOrganisationConfig_GetOne  @organisationID = @OrganisationID, @name = @Name



If Exists (Select OrganisationID From tblOrganisationConfig Where OrganisationID = @organisationID And [Name]	= @Name)
Begin
	Select @NumQuestions = value from tblOrganisationConfig Where OrganisationID	= @OrganisationID And [Name]		= @Name 
End
Else
Begin
	Select @NumQuestions = Value From tblOrganisationConfig Where OrganisationID	is null And  [Name]		= @Name 
End


	-- delete then insert these as we dont want duplicates
	delete from tblScormDME 
	where UserID  =@StudentID and LessonID =@LessonID
	and DME in (''cmi.core.student_id'',''cmi.core.student_name'',''cmi.core.version'',''cmi.core.numrandom'',''cmi.core.quizpassmark'',''salt.lessonorquiz'',''salt.training.QuizURL2'')
	and DME NOT LIKE ''cmi.interactions%''
		

	INSERT INTO  tblScormDME (UserID,LessonID,DME,[value]) VALUES(@StudentID,@LessonID,''cmi.core.student_id'' ,''Salt™''+CAST(@StudentID AS varchar(20)))
	INSERT INTO  tblScormDME (UserID,LessonID,DME,[value]) VALUES(@StudentID,@LessonID,''cmi.core.student_name'' ,(SELECT FirstName FROM tblUser WHERE UserID = @StudentID))
	INSERT INTO  tblScormDME (UserID,LessonID,DME,[value]) VALUES(@StudentID,@LessonID,''cmi.core.version'' ,''3.4'')
	INSERT INTO  tblScormDME (UserID,LessonID,DME,[value]) VALUES(@StudentID,@LessonID,''cmi.core.numrandom'' ,@NumQuestions ) 
	INSERT INTO  tblScormDME (UserID,LessonID,DME,[value]) VALUES(@StudentID,@LessonID,''cmi.core.quizpassmark'' ,@quizpassmark)

   if @isLesson = 1
   begin   
		-- quiz bookmark
		
		DECLARE @VarRunningPageCount nvarchar(255)		
		DECLARE @LessonLocation nvarchar(255)
		DECLARE @VarPageInChapter nvarchar(255)
		DECLARE @VarPagesInChapter nvarchar(255)
		DECLARE @CurrentPage nvarchar(255)
        DECLARE @LectoraBookmark nvarchar(100) 

        SELECT @LectoraBookmark = ''''
		SELECT @VarRunningPageCount = ''''
		SELECT @LessonLocation = ''''
		SELECT @VarPageInChapter = ''''
		SELECT @VarPagesInChapter = ''''
		SELECT @CurrentPage = ''''
		SELECT @LectoraBookmark = ''''        
        
        SELECT @VarRunningPageCount = value 
		     FROM  tblScormDME
			   WHERE UserID = @StudentID
				and LessonID = @LessonID
				and DME = ''salt.variables.VarRunningPageCount''
		
        if @VarRunningPageCount like ''Quiz%'' or @VarRunningPageCount like ''Page 1 %''
        BEGIN
            SELECT @VarRunningPageCount = ''''
        END
        ELSE
        BEGIN
			SELECT @LessonLocation = value 
				 FROM  tblScormDME
				 WHERE UserID = @StudentID
					and LessonID = @LessonID
					and DME = ''cmi.core.lesson_location''
			SELECT @VarPageInChapter = value 
				 FROM  tblScormDME
				 WHERE UserID = @StudentID
					and LessonID = @LessonID
					and DME = ''salt.variables.VarPageInChapter''
			SELECT @VarPagesInChapter = value 
				 FROM  tblScormDME
				 WHERE UserID = @StudentID
					and LessonID = @LessonID
					and DME = ''salt.variables.VarPagesInChapter''

			SELECT @CurrentPage = value 
				 FROM  tblScormDME
				 WHERE UserID = @StudentID
					and LessonID = @LessonID
					and DME = ''salt.currentpage''
					
            SELECT @LectoraBookmark = Q.lectoraBookmark 
                FROM tblLesson L 
				inner join tblQuiz Q on L.ModuleID =  Q.ModuleID 
				WHERE L.Active = 1 and Q.Active = 1 and L.moduleID = @lessonID   
		END		
		SELECT DME,value FROM  tblScormDME
			   WHERE UserID = @StudentID
				and LessonID = @LessonID
				and DME not in (''salt.variables.VarRunningPageCount''
								, ''cmi.core.lesson_location''
								,''salt.variables.VarPageInChapter''
								,''salt.variables.VarPagesInChapter''
								,''salt.currentpage'')
				
		UNION SELECT ''salt.lessonorquiz'' as DME, ''lesson'' as [value]		
		UNION SELECT ''salt.training.QuizURL2'' as DME, @LectoraBookmark as [value]
		UNION SELECT ''salt.variables.VarRunningPageCount'' as DME, @VarRunningPageCount as [value]
		UNION SELECT ''cmi.core.lesson_location'' as DME, @LessonLocation as [value]
		UNION SELECT ''salt.variables.VarPageInChapter'' as DME, @VarPageInChapter as [value]
		UNION SELECT ''salt.variables.VarPagesInChapter'' as DME, @VarPagesInChapter as [value]
		UNION SELECT ''salt.currentpage'' as DME, @CurrentPage as [value]
		
	end
	else
	begin
		
		-- delete the existing quiz dmes
		delete from tblScormDME 
		where UserID  =@StudentID and LessonID =@LessonID
		and DME in (''cmi.suspend_data'',''cmi.core.lesson_location'')
						
		
	    Declare @QuizBookmark varchar(1000)
		SELECT @QuizBookmark =   Q.lectoraBookmark from tblLesson L 
				inner join tblQuiz Q on L.ModuleID =  Q.ModuleID where L.Active = 1 and Q.Active = 1 and L.moduleID = @lessonID  		
		SELECT DME,value FROM  tblScormDME
				 WHERE UserID = @StudentID
					and LessonID = @LessonID				
		UNION SELECT ''cmi.core.lesson_location'' AS DME, @QuizBookmark as [value]
		UNION SELECT ''salt.lessonorquiz'' as DME, ''quiz'' as [value]	
	end

END

' 
END
GO
