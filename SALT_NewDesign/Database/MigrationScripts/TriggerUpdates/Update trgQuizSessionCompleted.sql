
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgQuizSessionCompleted]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgQuizSessionCompleted]
GO

/*Summary:
	Add new  Quiz status each time when user completes a quiz

Returns:
		
Called By: 

Calls:
	Nothing

Remarks:

Author: Jack Liu
Date Created: 21 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	



**/


CREATE TRIGGER trgQuizSessionCompleted ON [dbo].[tblQuizSession] 
FOR UPDATE,INSERT
AS
set nocount on
--Only fire the trigger if  there is only  one record affected
if ((select count(QuizID) from inserted)=1)
begin
	declare @dteDateTimeCompleted datetime, @intQuizScore int
	select @dteDateTimeCompleted = DateTimeCompleted,
		@intQuizScore = QuizScore
	from  inserted
	--Only if both the completed date and score have updated and have value (completed quiz)
	if (Update(DateTimeCompleted) and Update(QuizScore) and @dteDateTimeCompleted is not null and @intQuizScore is not null)
	begin
		insert into tblUserQuizStatus(
			UserID,
		      	ModuleID,    
			QuizStatusID, 
			QuizFrequency, 
			QuizPassMark,
			QuizScore,
			QuizSessionID,
			DateCreated -- This column has been added for the migration. 
			)
		Select 	us.userID,
			q.ModuleID,
			case
				when qs.QuizScore>=umr.QuizPassMark then 2
				else 3
			end as QuizStatusID,
			umr.QuizFrequency,
			umr.QuizPassMark,
			qs.QuizScore,
			qs.QuizSessionID,
			qs.DateTimeCompleted -- Take the date from the tblQuizSession
		From  inserted qs --Testing details
			inner join tblUser us   -- Get Unit
				on  us.UserID = qs.userID
			inner join tblQuiz q -- Get Module
				on q.quizID = qs.quizID
			inner join vwUnitModuleRule umr
				on umr.ModuleID  = q.ModuleID
					and umr.UnitID = us.UnitID
	end
end














GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

