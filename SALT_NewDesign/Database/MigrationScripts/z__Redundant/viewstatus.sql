select tblCourseStatus.status, tblUserCourseStatus.* from tblUserCourseStatus
inner join tblCourseStatus on tblUserCourseStatus.CourseStatusID = tblCourseStatus.CourseStatusID
	
select tblQuizStatus.status, tblUserQuizStatus.* from tblUserQuizStatus
inner join tblQuizStatus on tblUserQuizStatus.QuizStatusID = tblQuizStatus.QuizStatusID
	
select tblLessonStatus.status, tblUserLessonStatus.* from tblUserLessonStatus
inner join tblLessonStatus on tblUserLessonStatus.LessonStatusID = tblLessonStatus.LessonStatusID
	
select * from tblQuizSession order by quizID
select * from tblLessonSession order by lessonID

select * from tblLessonPAgeAudit