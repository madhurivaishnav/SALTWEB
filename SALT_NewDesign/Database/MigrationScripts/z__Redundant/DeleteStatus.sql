/*****************************
	** DELETE
******************************/
-- history
delete from tblLessonPageAudit
delete from tblLessonSession
delete from tblQuizAnswerAudit
delete from tblQuizQuestionAudit
delete from tblQuizSession
delete from tblUserClassification
-- result
delete from tblUserLessonStatus
delete from tblUSerQuizStatus
-- course
delete from tblUserCourseStatus
delete from tblBookmark
--delete from tblUser where UserID <> 1