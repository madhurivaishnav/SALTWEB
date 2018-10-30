SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_GetQuizSummary]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*
Summary: Returns the quiz history for a given user for a given module
Parameters: @QuizSessionID 	Varchar(50)
Returns:
QuizScore,
QuizPassMark,
DateTimeStarted,
DateTimeCompleted

Called By: User.cs
Calls: Nothing

Remarks: Raises an error if the parameter is null

Author: Peter Kneale
Date Created: 9th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description

-- prcUser_GetQuizSummary ''923F3547-94D2-4631-8DD4-FA8F8C8AC95A''
*/
CREATE    Procedure [prcUser_GetQuizSummary]
@QuizSessionID 	Varchar(50)	-- GUID Session ID of the quiz session that we want a summary
AS

Set NoCount On

--------------------------------
---- Validation
--------------------------------
If (@QuizSessionID is NULL or datalength(@QuizSessionID) = 0)
Begin
Raiserror (''Procedure prcUser_GetQuizSummary requires the Quiz Session ID'', 16, 1)
Return
End

--------------------------------
---- Logic
--------------------------------

Declare @Results table
(
Question 		nvarchar(4000),
CorrectAnswer	 	nvarchar(4000),
GivenAnswer		nvarchar(4000),
Correct			bit,
QuizQuestionID 		integer,
QuizAnswerID   		integer
)
Insert into
@Results

Select
tblQuizQuestion.Question,
tblQuizAnswer.Answer as ''CorrectAnswer'',
null,
null,
tblQuizQuestion.QuizQuestionID,
tblQuizAnswer.QuizAnswerID

From
tblQuizAnswer
INNER JOIN tblQuizQuestion
ON tblQuizQuestion.QuizQuestionID = tblQuizAnswer.QuizQuestionID
Inner Join tblQuizQuestionAudit
On tblQuizQuestionAudit.QuizQuestionID = tblQuizQuestion.QuizQuestionID
INNER JOIN tblQuizSession
ON tblQuizSession.QuizID = tblQuizQuestion.QuizID
INNER Join tblQuizAnswerAudit
on
tblQuizQuestion.QuizQuestionID  = tblQuizAnswerAudit.QuizQuestionID
and
tblQuizAnswerAudit.QuizSessionID = @QuizSessionID


Where
tblQuizSession.QuizSessionID = @QuizSessionID
and
tblQuizAnswer.Correct = 1
order by
tblQuizQuestion.QuizQuestionID,
tblQuizAnswer.QuizAnswerID

Insert into @Results

Select
null,null,answer as ''GivenAnswer'',correct,tblQuizAnswerAudit.QuizQuestionID,tblQuizAnswerAudit.QuizAnswerID
From
tblQuizAnswerAudit, tblQuizAnswer
Where
QuizSessionID = @QuizSessionID
And
tblQuizAnswerAudit.QuizAnswerID = tblQuizAnswer.QuizAnswerID
order by
tblQuizAnswerAudit.QuizQuestionID, tblQuizAnswerAudit.QuizAnswerID


SELECT
tblModule.Name as ''Module'',
tblUser.FirstName + '' '' +tblUser.LastName as ''FullName'',
tblQuizSession.QuizScore as ''QuizScore'',
tblQuizSession.QuizPassmark as ''QuizPassmark''
FROM
tblModule
Inner Join
tblQuiz on tblQuiz.ModuleID = tblModule.ModuleID
Inner Join
tblQuizSession on tblQuizSession.QuizID = tblQuiz.QuizID
Inner Join
tblUser on tblUser.UserID = tblQuizSession.UserID
where
tblQuizSession.QuizSessionID = @QuizSessionID

Select
distinct *
from
@Results

order by
QuizQuestionID,
Question desc,
CorrectAnswer,
GivenAnswer
' 
END
GO
