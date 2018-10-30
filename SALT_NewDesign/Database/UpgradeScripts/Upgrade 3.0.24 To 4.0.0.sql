--- TABLE CHANGES START


	-- ORGANISATION - START - Default date completion lession/quiz
		ALTER TABLE dbo.tblOrganisation ADD 
			DefaultLessonCompletionDate datetime NULL, 
			DefaultQuizCompleteDate datetime NULL
	-- ORGANISATION - END

	--- UNITRULE - START - date lesson / quiz completion
		ALTER TABLE dbo.tblUnitRule ADD 
			LessonCompletionDate datetime NULL, 
			QuizCompletionDate datetime NULL
	-- UNIT RULE - END
	
	-- USER QUIZ STATUS - START
		ALTER TABLE dbo.tblUserQuizStatus ADD 
			QuizCompletionDate datetime NULL
	-- USER QUIZ STATUS - END
	
	-- QUIZ - START
		ALTER TABLE dbo.tblQuiz ADD 
			WorksiteID varchar(50) NULL
	-- QUIZ - END
	
	-- LESSON - START
		ALTER TABLE dbo.tblLesson ADD 
			LWorkSiteID varchar(50) NULL, 
			QFWorkSiteID varchar(50) NULL
	-- LESSON - END
	

--- TABLE CHANGES END