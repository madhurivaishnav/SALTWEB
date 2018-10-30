SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUserQuizStatus_FIX]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE   Procedure [prcUserQuizStatus_FIX]
(
@orgID int
)
AS
Set Nocount On

/*
1.1  Get all modules that are currently assigned to each users (CurrentAssignedModules)
and current compliance rules
*/

select
um.UserID,
um.ModuleID,
umr.QuizFrequency,
umr.QuizPassMark
into
#tblCurrentAssignedModules
from
vwUserModuleAccess um
inner join
vwUnitModuleRule umr
on
umr.ModuleID  = um.ModuleID
and umr.UnitID = um.UnitID
where
um.OrganisationID = @orgID

/*
1.2. Get the last quiz activity for each user and module pair (StartedModules)
*/

select
um.userID,
um.moduleID,
q.active,
qs.QuizScore,
qs.QuizSessionID,
dbo.udfUTCtoDaylightSavingTime(qs.DateTimeCompleted, @orgID)
into
#tblStartedModules
from
#tblCurrentAssignedModules um
inner join
(
select
um.userID, um.moduleID, max(dbo.udfUTCtoDaylightSavingTime(DateTimeCompleted, @orgID))  as DateTimeCompleted
from
#tblCurrentAssignedModules um
inner join tblQuiz q
on q.ModuleID = um.ModuleID
inner join tblQuizSession qs
on
qs.QuizID=	q.quizID
and qs.userID = um.userID
and qs.DateTimeCompleted is not null
group by um.userID, um.moduleID
)
as LastQuizDate

on
LastQuizDate.userID = um.userID
and LastQuizDate.ModuleID = um.ModuleID

inner join tblQuiz q
on
q.ModuleID = um.ModuleID
inner join tblQuizSession qs
on
qs.QuizID=	q.quizID
and qs.userID = um.userID
and qs.DateTimeCompleted  = LastQuizDate.DateTimeCompleted

/*
1.3. Unassigned Modules (0) (PreviousAssignedModules - CurrentAssignedModules)
a) Get a list of modules that is in the quiz status table that the last statuses are not Unassigned (0)(PreviousAssignedModules)
b) Get rid off all modules that are currently assigned to the users (from step 1)
c)All modules left are Unassigned(0)
*/
--1. Get Current User Quiz status
CREATE TABLE #tblCurrentUserQuizStatus
(
UserID int NOT NULL ,
ModuleID int NOT NULL ,
QuizStatusID int not NULL ,
QuizFrequency int NULL ,
QuizPassMark int NULL ,
QuizScore int NULL,
QuizSessionID uniqueidentifier NULL
)

/*
1.5. Started Modules
a)If the last quiz is inactive, the status is Expired (New Content)(5)
b)If the last quiz is past the current quiz frequency, the status is Expired (Time Expired)(4)
c)If the last quiz is during the current quiz frequency, get the current pass mark, and check the quiz status
If user Failed the quiz, the status is Failed (3)
If user Passed the quiz, the status is Passed (2)
*/

-- a)If the last quiz is inactive, the status is Expired (New Content)(5)


insert into #tblCurrentUserQuizStatus
(
UserID,
ModuleID,
QuizStatusID,
QuizFrequency,
QuizPassMark
)
select
cam.UserID,
cam.ModuleID,
5  as QuizStatusID, --  Expired (New Content)(5)
cam.QuizFrequency,
cam.QuizPassMark
from
#tblCurrentAssignedModules cam
inner join
#tblStartedModules sm
on
sm.UserID = cam.UserID
and sm.ModuleID = cam.ModuleID
where
sm.active=0 --Inactive

-- select * from #tblCurrentUserQuizStatus order by userID

/*
2. Update User Quiz status
----------------------------
If the last quiz status for each user is not the same as the current status, add the new status
*/




declare @cursor_UserID 	        int
declare @cursor_ModuleID 	    int
declare @cursor_QuizStatusID 	int
declare @cursor_QuizFrequency 	int
declare @cursor_QuizPassMark	int
declare @cursor_QuizScore	    int
declare @cursor_QuizSessionID   varchar(50)
declare @cursor_UserQuizStatusID int
declare @int_rc int

DECLARE CurrentUserQuizStatus CURSOR
FOR


select
cs.UserID,
cs.ModuleID,
cs.QuizStatusID,
cs.QuizFrequency,
cs.QuizPassMark,
cs.QuizScore,
cs.QuizSessionID,
s.UserQuizStatusID
from
#tblCurrentUserQuizStatus cs
left join vwUserQuizStatus s
on cs.userID = s.UserID
and cs.ModuleID = s.ModuleID
and cs.QuizStatusID = s.QuizStatusID

Open CurrentUserQuizStatus

-- First Read testreportCursor
FETCH NEXT FROM CurrentUserQuizStatus
Into
@cursor_UserID,@cursor_ModuleID,@cursor_QuizStatusID,@cursor_QuizFrequency,
@cursor_QuizPassMark,@cursor_QuizScore,@cursor_QuizSessionID, @cursor_UserQuizStatusID

WHILE @@FETCH_STATUS = 0
BEGIN

--new user quiz status records

-- Eisting user quiz status records
EXEC prcUserQuizStatus_UpdateCourseStatus @cursor_UserID, @cursor_ModuleID

FETCH NEXT FROM CurrentUserQuizStatus
Into
@cursor_UserID,@cursor_ModuleID,@cursor_QuizStatusID,@cursor_QuizFrequency,
@cursor_QuizPassMark,@cursor_QuizScore,@cursor_QuizSessionID,@cursor_UserQuizStatusID
END
-- Finished CurrentUserQuizStatus
CLOSE CurrentUserQuizStatus
DEALLOCATE CurrentUserQuizStatus

drop table  #tblCurrentUserQuizStatus

drop table #tblCurrentAssignedModules

drop table #tblStartedModules

' 
END
GO
