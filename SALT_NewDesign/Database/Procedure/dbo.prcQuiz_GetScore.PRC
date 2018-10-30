SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcQuiz_GetScore]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary: Returns the score for a given quiz session
Parameters: quiz session id
Returns: integer

Called By: Quiz.aspx
Calls:nothing

Remarks: Raises an error if the parameter is null

Author: Peter Kneale
Date Created: 9th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description

-- prcQuiz_GetPassMark 1,1
*/

CREATE  Procedure [prcQuiz_GetScore]
(
@QuizSessionID varchar(50)
)

As

If (@QuizSessionID is NULL or datalength(@QuizSessionID) = 0)
Begin
Raiserror (''Procedure prcQuiz_GetScore requires a quiz session id'', 16, 1)
Return
End

select
cast(round(sum(cast(tblQuizAnswer.correct as int)*100.00)/count(tblQuizAnswer.QuizAnswerID),0) as int)
from
tblQuizQuestionAudit
inner join
tblQuizAnswerAudit
on
tblQuizAnswerAudit.QuizQuestionID = tblQuizQuestionAudit.QuizQuestionID
and
tblQuizQuestionAudit.QuizSessionID = @QuizSessionID
and
tblQuizAnswerAudit.QuizSessionID = @QuizSessionID
inner join
tblQuizAnswer
on
tblQuizAnswerAudit.QuizAnswerID = tblQuizAnswer.QuizAnswerID
group by tblQuizAnswerAudit.QuizSessionID

' 
END
GO
