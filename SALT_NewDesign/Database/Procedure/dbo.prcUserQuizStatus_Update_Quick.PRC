SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUserQuizStatus_Update_Quick]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/* Summary:
Update quiz status for each user

Returns:

Called By:

Calls:
Nothing

Remarks:
This is a schedule job running every night to check there are any changes in the user quiz status based on current compliance rules.
If they are the same as the current status, ignore it, otherwise a new status will be created.

If a module is assigned to a user, and there is no activity for this module, the status will be  ''Not started''.
If a module is unassigned from a user, the status will be ''unassinged"(There are records in status table, but the module is not assigned to this user now)
If a module is set to inactive, the status will be ''unassinged''

All user-module pair need to be re-evaluated, as compliance rules may be changed since the user''s last toolbook activity.

------------ Decision Processes -------------

1. Get Current User Quiz status
-----------------------------------
1.1  Get all modules that are currently assigned to each users (CurrentAssignedModules)
and compliance rules

1.2. Get the last quiz activity for each user and module pair (StartedModules)

1.3. Unassigned Modules (0) (PreviousAssignedModules - CurrentAssignedModules)
a) Get a list of modules that is in the quiz status table that the last statuses are not Unassigned (0)(PreviousAssignedModules)
b) Get rid off all modules that are currently assigned to the users (from step 1)
c)All modules left are Unassigned(0)

1.4. Not Started Modules (1) (CurrentAssignedModules- StartedModules)
All currently assigned modules that don''t have any activity is Not Started (1)

1.5. Started Modules
a)If the last quiz is inactive, the status is Expired (New Content)(5)
b)If the last quiz is past the current quiz date/frequency, the status is Expired (Time Expired)(4)
c)If the last quiz is during the current quiz frequency, get the current pass mark, and check the quiz status
If user Failed the quiz, the status is Failed (3)
If user Passed the quiz, the status is Passed (2)

2. Update User Quiz status
----------------------------
If the last quiz status for each user is not the same as the current status, add the new status



------------ Data need to be recorded -------------

QuizFrequency	QuizPassMark	QuizScore
0  Unassigned:  		-		-		-
1  Not Started: 		Y		Y		-
2  Passed: 	 		Y		Y		Y
3  Failed: 	 		Y		Y		Y
4  Expired (Time Elapsed): 	Y		Y		-
5  Expired (New Content): 	Y		Y		-


Author: Jack Liu
Date Created: 20 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	mikev		1/5/2007		Added logic for new fields LessonCompletionStatus & QuizCompletionStatus
#2	mikev		9/5/2007		Added course completion logic. If a module is marked active or not active; to calculate if the course is complete.
#3	Mark Donald	21/9/2009		Added OrganisationName (control character) to License Warning emails
  Chris Plewright  21/11/2013   fixed for incorrect for No of Post Expiry notifications being sent.
   
prcUserQuizStatus_Update_Quick

**/
CREATE   Procedure [dbo].[prcUserQuizStatus_Update_Quick]
(
@OrgID int	-- comma separated organisationID
)
AS
Set Nocount On
declare @intHistoryID int

insert into tblModuleStatusUpdateHistory(startTime) values(getUTCdate());
set @intHistoryID = @@identity

--1. Get Current User Quiz status
--mikev : added QuizCompletionDate
/* UNITTEST: CurrentAssignedModules */
CREATE TABLE #tblCurrentUserQuizStatus
(
UserID int NOT NULL ,
ModuleID int NOT NULL ,
QuizStatusID int not NULL ,
QuizFrequency int NULL ,
QuizPassMark int NULL ,
QuizCompletionDate DateTime NULL,
QuizScore int NULL,
QuizSessionID uniqueidentifier NULL
)


/*
1.1  Get all modules that are currently assigned to each users (CurrentAssignedModules)
and current compliance rules
*/
-- mikev(1): added completion date

select
um.UserID,
um.ModuleID,
umr.QuizFrequency,
umr.QuizPassMark,
umr.QuizCompletionDate
into
#tblCurrentAssignedModules
from
(
Select
tU.UserID
, tU.UnitID
, tU.OrganisationID
, tM.ModuleID


From
dbo.tblUser tU
--< get the courses a user has access to >--
Inner Join dbo.tblOrganisationCourseAccess tOCA
On  tOCA.OrganisationID = tU.OrganisationID
--< get the course details >--
Inner join dbo.tblCourse tC
On tC.CourseID = tOCA.GrantedCourseID
--< get the Active modules in a course >--
inner join dbo.tblModule tM
On tM.CourseID = tC.CourseID
and tM.Active = 1
--< get the details on which moduels a user is configured to access >--
Left Outer join dbo.tblUserModuleAccess tUsrMA
On  tUsrMA.UserID = tU.UserID
And tUsrMA.ModuleID = tM.ModuleID
--< get the details on which moduels a user''s Unit is excluded from  >--
Left Outer Join dbo.tblUnitModuleAccess tUnitMA
On  tUnitMA.UnitID = tU.UnitID
And tUnitMA.DeniedModuleID = tM.ModuleID
Where
tU.OrganisationID = @OrgID AND
tU.Active = 1
--< Active users only >--
and tu.UnitID is not null
--< Get the modules that the user''s Unit is not denied >--
and (tUnitMA.DeniedModuleID  is null
--<  and the user does not have special access to  it>--
And tUsrMA.ModuleID is null)
--< or Get modules that the user has been specially  granted
or tUsrMA.Granted=1
) um
inner join
(
Select 	u.UnitID,
m.CourseID,
m.ModuleID,
case
when ur.unitID is null then cast(1 as bit)
else cast(0 as bit)
end as UsingDefault,
case
when (ur.LessonFrequency is null and ur.LessonCompletionDate is null and o.DefaultLessonCompletionDate is null) then
o.DefaultLessonFrequency
else
ur.LessonFrequency
end
as LessonFrequency,
case
when (ur.QuizFrequency is null and ur.QuizCompletionDate is null and o.DefaultQuizCompletionDate is null) then
o.DefaultQuizFrequency
else
ur.QuizFrequency
end
as QuizFrequency,
isNull(ur.QuizPassMark, o.DefaultQuizPassMark) as QuizPassMark,
case
when (ur.LessonFrequency is null and ur.LessonCompletionDate is null and not(o.DefaultLessonCompletionDate is null)) then
o.DefaultLessonCompletionDate
else
ur.LessonCompletionDate
end
as LessonCompletionDate,
case
when (ur.QuizFrequency is null and ur.QuizCompletionDate is null and not(o.DefaultQuizCompletionDate is null)) then
o.DefaultQuizCompletionDate
else
ur.QuizCompletionDate
end
as QuizCompletionDate
From tblOrganisationCourseAccess c
inner join tblModule m
on m.CourseID = c.GrantedCourseID
inner join tblOrganisation o  -- Get default compliance rules
on o.OrganisationID = c.OrganisationID
inner join tblUnit u
on u.OrganisationID = c.OrganisationID
left join tblUnitRule ur --Get the unit specific rules
on ur.ModuleID = m.ModuleID
and ur.UnitID=u.unitID
WHERE o.OrganisationID = @OrgID
) umr
on
umr.ModuleID  = um.ModuleID
and umr.UnitID = um.UnitID
and um.UnitID in (select UnitID from tblUnit where OrganisationID = @OrgID)
and um.UserID IN (select UserID from tblUser where OrganisationID = @OrgID)
/* /UNITTEST: CurrentAssignedModules */

-- select * from #tblCurrentAssignedModules
/*
1.2. Get the last quiz activity for each user and module pair (StartedModules)
*/
/* UNITTEST: StartedModules */
select
um.userID,
um.moduleID,
q.active,
qs.QuizScore,
qs.QuizSessionID,
qs.DateTimeCompleted
into
#tblStartedModules
from
#tblCurrentAssignedModules um
inner join
(
select
um.userID, um.moduleID, max(DateTimeCompleted)  as DateTimeCompleted
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
/* /UNITTEST: StartedModules */


-- select * from #tblStartedModules

/*
1.3. Unassigned Modules (0) (PreviousAssignedModules - CurrentAssignedModules)
a) Get a list of modules that is in the quiz status table that the last statuses are not Unassigned (0)(PreviousAssignedModules)
b) Get rid off all modules that are currently assigned to the users (from step 1)
c)All modules left are Unassigned(0)
*/

/* UNITTEST: Status_Unassigned */
insert into #tblCurrentUserQuizStatus
(
UserID,
ModuleID,
QuizStatusID
)
select
uqs.UserID,
uqs.ModuleID,
0  as QuizStatusID --Unassigned (0)
from
(
select
QuizStatus.UserQuizStatusID
, QuizStatus.UserID
, QuizStatus.ModuleID
, m.CourseID
, QuizStatus.QuizStatusID
, QuizStatus.QuizFrequency
, QuizStatus.QuizPassMark
, QuizStatus.QuizSessionID
, QuizStatus.QuizScore
, QuizStatus.DateCreated

from
tblUserQuizStatus QuizStatus
inner join tblModule m on m.ModuleID = QuizStatus.ModuleID
inner join
(
select
max(UserQuizStatusID) UserQuizStatusID --UserQuizStatusID is identity
from
tblUserQuizStatus
WHERE
tblUserQuizStatus.UserID in (select UserID from tblUser where OrganisationID = @OrgID)
group by
UserID,moduleID
) currentStatus
on QuizStatus.UserQuizStatusID = currentStatus.UserQuizStatusID
where m.active = 1
) uqs
left join
#tblCurrentAssignedModules cam
on
cam.UserID = uqs.UserID
and cam.ModuleID = uqs.ModuleID
where
uqs.QuizStatusID<>0 --not Unassigned (0)
and cam.moduleID is null
and cam.UserID in (select UserID from tblUser where OrganisationID = @OrgID)
/* /UNITTEST: Status_Unassigned */

/*
1.4. Not Started Modules (1) (CurrentAssignedModules- StartedModules)
All currently assigned modules that don''t have any activity is Not Started (1)
*/
-- mikev(1): added QuizCompletionDate
/* UNITTEST: Status_NotStarted */
insert into
#tblCurrentUserQuizStatus
(
UserID,
ModuleID,
QuizStatusID,
QuizFrequency,
QuizPassMark,
QuizCompletionDate
)
select
cam.UserID,
cam.ModuleID,
1  as QuizStatusID, --Not Started (1)
cam.QuizFrequency,
cam.QuizPassMark,
cam.QuizCompletionDate
from
#tblCurrentAssignedModules cam
left join
#tblStartedModules sm
on
sm.UserID = cam.UserID
and sm.ModuleID = cam.ModuleID
where
sm.moduleID is null
and cam.UserID in (select UserID from tblUser where OrganisationID = @OrgID)
/* /UNITTEST: Status_NotStarted */
/*
EXPIRED NEW CONTENT IS NOW A MANUAL PROCESS
1.5. Started Modules
a)If the last quiz is inactive, the status is Expired (New Content)(5)
b)If the last quiz is past the current quiz frequency, the status is Expired (Time Expired)(4)
c)If the last quiz is during the current quiz frequency, get the current pass mark, and check the quiz status
If user Failed the quiz, the status is Failed (3)
If user Passed the quiz, the status is Passed (2)
*/

--	  	a)If the last quiz is inactive, the status is Expired (New Content)(5)


--		b)If the last quiz is past the current quiz frequency, the status is Expired (Time Expired)(4)
-- mikev(1): added QuizCompletionDate. Added criteria
/* UNITTEST: Status_TimeExpired */
insert into #tblCurrentUserQuizStatus
(
UserID,
ModuleID,
QuizStatusID,
QuizFrequency,
QuizPassMark,
QuizCompletionDate
)
select cam.UserID,
cam.ModuleID,
4  as QuizStatusID, --  Expired (Time Expired)(4)
cam.QuizFrequency,
cam.QuizPassMark,
cam.QuizCompletionDate
from #tblCurrentAssignedModules cam
inner join #tblStartedModules sm
on sm.UserID = cam.UserID
and sm.ModuleID = cam.ModuleID
where
(
(
cam.QuizCompletionDate is null
and DateDiff(day,dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID), dateadd(month, cam.QuizFrequency, dbo.udfUTCtoDaylightSavingTime(sm.DateTimeCompleted,@OrgID))) <= 0
)
or
(
isnull(DateDiff(day, getutcdate(), cam.QuizCompletionDate), 1) <= 0
)
)
and cam.UserID in (select UserID from tblUser where OrganisationID = @OrgID)
/* /UNITTEST: Status_TimeExpired */

--		c)If the last quiz is during the current quiz frequency, get the current pass mark, and check the quiz status
--			If user Failed the quiz, the status is Failed (3)
--			If user Passed the quiz, the status is Passed (2)

-- mikev(1): added QuizCompletionDate and changed logic of criteria to use the date before the frequency
/* UNITTEST: Status_PassFail */
insert into #tblCurrentUserQuizStatus
(
UserID,
ModuleID,
QuizStatusID,
QuizFrequency,
QuizPassMark,
QuizCompletionDate,
QuizScore,
QuizSessionID
)
select cam.UserID,
cam.ModuleID,
case
when sm.QuizScore>=cam.QuizPassMark then 2 -- Passed (2)
else	3  --Failed (3)
end  as QuizStatusID,
cam.QuizFrequency,
cam.QuizPassMark,
cam.QuizCompletionDate,
sm.QuizScore,
sm.QuizSessionID
from #tblCurrentAssignedModules cam
inner join #tblStartedModules sm
on sm.UserID = cam.UserID
and sm.ModuleID = cam.ModuleID
where
not (
cam.QuizCompletionDate is null
and DateDiff(day,dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID), dateadd(month, cam.QuizFrequency, dbo.udfUTCtoDaylightSavingTime(sm.DateTimeCompleted,@OrgID))) <= 0
)
and cam.QuizCompletionDate is null
and cam.UserID in (select UserID from tblUser where OrganisationID = @OrgID)
and (select top 1 QuizStatusID from tblUserQuizStatus where ModuleID = cam.ModuleID and UserID = cam.UserID order by UserQuizStatusID Desc) NOT IN (5)

/* /UNITTEST: Status_PassFail */
/*
2. Update User Quiz status
----------------------------
If the last quiz status for each user is not the same as the current status, add the new status
*/


/* UNITTEST: CourseStatus */
-- mikev(1): added cursor for quizcompletiondate
declare @cursor_UserID 	        int
declare @cursor_ModuleID 	    int
declare @cursor_QuizStatusID 	int
declare @cursor_QuizFrequency 	int
declare @cursor_QuizPassMark	int
declare @cursor_QuizCompletionDate	DateTime
declare @cursor_QuizScore	    int
declare @cursor_QuizSessionID   varchar(50)
declare @cursor_UserQuizStatusID int

-- mikev(1): added quizcompletiondate
declare @LastUser int
declare @LastModuleID int
declare @LastCourse int
declare @LastQuizStatusID int
declare @cursor_CourseID int
set @LastUser = -1
set @LastCourse = -1
set @LastQuizStatusID = -1
set  @LastModuleID = 0
DECLARE CurrentUserQuizStatus CURSOR
FOR


select
cs.UserID,
cs.ModuleID,
cs.QuizStatusID,
cs.QuizFrequency,
cs.QuizPassMark,
cs.QuizCompletionDate,
cs.QuizScore,
cs.QuizSessionID,
s.UserQuizStatusID,
Module.CourseID
from -- Any UserModules with current access but no tblUserQuizStatus record
#tblCurrentUserQuizStatus cs
inner join tblModule Module on module.moduleID = cs.ModuleID
left join
(  -- The UserModule quiz status for the latest quiz attempt
select
QuizStatus.UserQuizStatusID
, QuizStatus.UserID
, QuizStatus.ModuleID
, m.CourseID
, QuizStatus.QuizStatusID
, QuizStatus.QuizFrequency
, QuizStatus.QuizPassMark
, QuizStatus.QuizSessionID
, QuizStatus.QuizScore
, QuizStatus.DateCreated

from
tblUserQuizStatus QuizStatus
inner join tblModule m on m.ModuleID = QuizStatus.ModuleID
inner join
(
select
max(UserQuizStatusID) UserQuizStatusID --UserQuizStatusID is identity
from
tblUserQuizStatus
WHERE
tblUserQuizStatus.UserID in (select UserID from tblUser where OrganisationID = @OrgID)
group by
UserID,moduleID
) currentStatus
on QuizStatus.UserQuizStatusID = currentStatus.UserQuizStatusID
where m.active = 1
) s
on cs.userID = s.UserID
and cs.ModuleID = s.ModuleID
and cs.QuizStatusID = s.QuizStatusID
where
s.UserQuizStatusID is null
order by cs.UserID,
case when (cs.QuizStatusID = 0) then 6 else cs.QuizStatusID end,
Module.CourseID
-- ordered so we can update course status on the last module in the course rather than for every module in the course

Open CurrentUserQuizStatus

FETCH NEXT FROM CurrentUserQuizStatus
Into
@cursor_UserID,@cursor_ModuleID,@cursor_QuizStatusID,@cursor_QuizFrequency,
@cursor_QuizPassMark,@cursor_QuizCompletionDate,@cursor_QuizScore,@cursor_QuizSessionID, @cursor_UserQuizStatusID, @cursor_CourseID
set @LastCourse = @cursor_CourseID
set @LastUser = @cursor_UserID
set @LastQuizStatusID = @cursor_QuizStatusID
set @LastModuleID = @cursor_ModuleID

DECLARE @Err integer
WHILE @@FETCH_STATUS = 0
BEGIN

insert into tblUserQuizStatus
(
UserID,
ModuleID,
QuizStatusID,
QuizFrequency,
QuizPassMark,
QuizCompletionDate,
QuizScore,
QuizSessionID
)
values
(
@cursor_UserID,
@cursor_ModuleID,
@cursor_QuizStatusID,
@cursor_QuizFrequency,
@cursor_QuizPassMark,
@cursor_QuizCompletionDate,
@cursor_QuizScore,
@cursor_QuizSessionID
)
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_Update_Quick'',''insert into tblUserQuizStatus'',''UserID=''+CAST(@cursor_UserID AS varchar(10)),CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_Update_Quick'',1,1,null,getutcdate(),getutcdate()) END

-- don''t update the course status for every module in the course - once per course is enough
-- do update the course status on every change in QuizStatus
if (@LastCourse != @cursor_CourseID) or (@LastUser != @cursor_UserID) or (@LastQuizStatusID != @cursor_QuizStatusID) EXEC prcUserQuizStatus_UpdateCourseStatus @LastUser, @LastModuleID

set @LastCourse = @cursor_CourseID
set @LastUser = @cursor_UserID
set @LastQuizStatusID = @cursor_QuizStatusID
set @LastModuleID = @cursor_ModuleID


FETCH NEXT FROM CurrentUserQuizStatus
Into
@cursor_UserID,@cursor_ModuleID,@cursor_QuizStatusID,@cursor_QuizFrequency,
@cursor_QuizPassMark,@cursor_QuizCompletionDate,@cursor_QuizScore,@cursor_QuizSessionID, @cursor_UserQuizStatusID, @cursor_CourseID


END
-- final course may not be done so update just to be safe
if (@LastUser != -1 ) EXEC prcUserQuizStatus_UpdateCourseStatus @cursor_UserID, @cursor_ModuleID
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_Update_Quick'',''prcUserQuizStatus_UpdateCourseStatus'',''prcUserQuizStatus_UpdateCourseStatus'',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_Update_Quick'',1,1,null,getutcdate(),getutcdate()) END

-- Finished CurrentUserQuizStatus
CLOSE CurrentUserQuizStatus
DEALLOCATE CurrentUserQuizStatus




--              AT RISK OF EXPIRY



delete from tblQuizExpiryAtRisk
where OrganisationID = @OrgID   -- delete from ExpiryAtRisk those users who somehow are no longer at risk

and  not exists (
SELECT
@orgid,
QuizStatus.UserID,
QuizStatus.ModuleID ,
case when re.QuizExpiryWarn=0 then -1 else 0 end as preexpiry ,
0 as postexpiry,
case when quizstatus.QuizStatusID = 1 then
dateadd (d,re.daystocompletecourse,QuizStatus.DateCreated)
when QuizStatus.QuizStatusID>1 then
(
case when coalesce(ur.quizcompletiondate,o.DefaultQuizCompletionDate)  is not null then
coalesce(ur.quizcompletiondate,o.DefaultQuizCompletionDate)
else
DATEADD(M,coalesce(ur.quizfrequency,o.DefaultQuizFrequency),QuizStatus.DateCreated)
end
)
end
as expiry
FROM
tblUserQuizStatus AS QuizStatus
INNER JOIN dbo.tblModule AS m ON m.ModuleID = QuizStatus.ModuleID
INNER JOIN(SELECT     MAX(UserQuizStatusID) AS UserQuizStatusID,ModuleID,uqs.UserID
FROM          dbo.tblUserQuizStatus uqs
join tblUser u on u.UserID = uqs.UserID and u.OrganisationID = @orgid and u.Active = 1
GROUP BY ModuleID,uqs.UserID ) AS currentStatus ON QuizStatus.UserQuizStatusID = currentStatus.UserQuizStatusID and currentStatus.ModuleID = m.ModuleID
join tblUser u on u.UserID =QuizStatus.UserID
join tblOrganisation o on o.OrganisationID = u.OrganisationID and o.OrganisationID = @orgid
join tblReminderEscalation re on m.CourseID = re.CourseId and re.OrgId = o.OrganisationID and re.DateEnabled<GETUTCDATE()
join vwUserModuleAccess uma on uma.UserID = u.UserID and uma.ModuleID = m.ModuleID
left join tblUnit unit on unit.UnitID = u.UnitID
left join tblUnitRule ur on ur.UnitID = u.UnitID and ur.ModuleID = m.ModuleID
WHERE     (m.Active = 1)
and
(
-- pre expiry initial enrolment
(
quizexpirywarn = 1  and
(RemindUsers = 1 and re.PreExpInitEnrolment = 1 and quizstatus.QuizStatusID = 1 and DATEDIFF (D,getutcdate(),(dateadd (d,re.daystocompletecourse,QuizStatus.DateCreated)))<=re.DaysQuizExpiry
or
--enable				--resit period reminder
(PreExpResitPeriod = 1	and QuizStatus.QuizStatusID>1 and
-- pre expiry resit period
(dateadd(M,case when coalesce(ur.quizfrequency ,o.DefaultQuizFrequency) = 0 then 99 else coalesce(ur.quizfrequency ,o.DefaultQuizFrequency) end , dateadd(d,-re.DaysQuizExpiry,  QuizStatus.DateCreated))<=GETDATE())
or
-- pre expiry resit period date
(DATEADD(yy,1,quizstatus.DateCreated)<= coalesce(ur.quizcompletiondate,o.DefaultQuizCompletionDate) and DATEADD(D,-re.DaysQuizExpiry,coalesce(ur.quizcompletiondate,o.DefaultQuizCompletionDate))<= getutcdate())
)
)
)
or
(
re.PostExpReminder = 1 and
-- post expiry initial reminder
(
(
RemindUsers = 1 and re.PostExpInitEnrolment = 1 and QuizStatus.QuizStatusID = 1 and (dateadd (d,re.daystocompletecourse,QuizStatus.DateCreated))<=GETUTCDATE()
)
or
-- post expiry resit period
(
re.PostExpResitPeriod = 1  and QuizStatus.QuizStatusID >1 and
(
-- post expiry resit period
(dateadd(M,case when coalesce(ur.quizfrequency ,o.DefaultQuizFrequency)= 0 then 99 else coalesce(ur.quizfrequency ,o.DefaultQuizFrequency) end , QuizStatus.DateCreated)<=GETDATE())
or
-- post expiry resit date
(DATEADD(Y,1,quizstatus.DateCreated)<= coalesce(ur.quizcompletiondate,o.DefaultQuizCompletionDate) and (coalesce(ur.quizcompletiondate,o.DefaultQuizCompletionDate)<= getutcdate() or DATEDIFF(MONTH,coalesce(ur.quizcompletiondate,o.DefaultQuizCompletionDate),QuizStatus.DateCreated)>12)) -- need to double check this in testing
)
)
)
)
)
)

SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_Update_Quick'',''delete from tblQuizExpiryAtRisk'',''delete from tblQuizExpiryAtRisk'',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_Update_Quick'',1,1,null,getutcdate(),getutcdate()) END


insert into tblQuizExpiryAtRisk -- add users that are now AtRisk that were not already flagged as AtRisk
(
OrganisationID,
UserID,
ModuleID,
PreExpiryNotified,
ExpiryNotifications,
expirydate
)

SELECT
@orgid,
QuizStatus.UserID,
QuizStatus.ModuleID ,
case when re.QuizExpiryWarn=0 then -1 else 0 end as preexpiry ,
0 as postexpiry,
case when quizstatus.QuizStatusID = 1 then
dateadd (d,re.daystocompletecourse,QuizStatus.DateCreated)
when QuizStatus.QuizStatusID>1 then
(
case when coalesce(ur.quizcompletiondate,o.DefaultQuizCompletionDate)  is not null then
coalesce(ur.quizcompletiondate,o.DefaultQuizCompletionDate)
else
DATEADD(M,coalesce(ur.quizfrequency,o.DefaultQuizFrequency),QuizStatus.DateCreated)
end
)
end
as expiry
FROM
tblUserQuizStatus AS QuizStatus
INNER JOIN dbo.tblModule AS m ON m.ModuleID = QuizStatus.ModuleID
INNER JOIN(SELECT     MAX(UserQuizStatusID) AS UserQuizStatusID,ModuleID,uqs.UserID
FROM          dbo.tblUserQuizStatus uqs
join tblUser u on u.UserID = uqs.UserID and u.OrganisationID = @orgid and u.Active = 1
GROUP BY ModuleID,uqs.UserID ) AS currentStatus ON QuizStatus.UserQuizStatusID = currentStatus.UserQuizStatusID and currentStatus.ModuleID = m.ModuleID
join tblUser u on u.UserID =QuizStatus.UserID
join tblOrganisation o on o.OrganisationID = u.OrganisationID and o.OrganisationID = @orgid
join tblReminderEscalation re on m.CourseID = re.CourseId and re.OrgId = o.OrganisationID and re.DateEnabled<GETUTCDATE()
join vwUserModuleAccess uma on uma.UserID = u.UserID and uma.ModuleID = m.ModuleID
left join tblUnit unit on unit.UnitID = u.UnitID
left join tblUnitRule ur on ur.UnitID = u.UnitID and ur.ModuleID = m.ModuleID
WHERE     (m.Active = 1)
--/*
and
(
-- pre expiry initial enrolment
(
quizexpirywarn = 1  and
(RemindUsers = 1 and re.PreExpInitEnrolment = 1 and quizstatus.QuizStatusID = 1 and DATEDIFF (D,getutcdate(),(dateadd (d,re.daystocompletecourse,QuizStatus.DateCreated)))<=re.DaysQuizExpiry
or
--enable				--resit period reminder
(PreExpResitPeriod = 1	and QuizStatus.QuizStatusID>1 and
-- pre expiry resit period
(dateadd(M,case when coalesce(ur.quizfrequency ,o.DefaultQuizFrequency) = 0 then 99 else coalesce(ur.quizfrequency,o.DefaultQuizFrequency) end , dateadd(d,-re.DaysQuizExpiry,  QuizStatus.DateCreated))<=GETUTCDATE())
or
-- pre expiry resit period date
(DATEADD(yy,1,quizstatus.DateCreated)<= coalesce(ur.quizcompletiondate,o.DefaultQuizCompletionDate) and DATEADD(D,-re.DaysQuizExpiry,coalesce(ur.quizcompletiondate,o.DefaultQuizCompletionDate))<= getutcdate())
)
)
)
or
(
re.PostExpReminder = 1 and
-- post expiry initial reminder
(
(
RemindUsers = 1 and re.PostExpInitEnrolment = 1 and QuizStatus.QuizStatusID = 1 and (dateadd (d,re.daystocompletecourse,QuizStatus.DateCreated))<=GETUTCDATE()
)
or
-- post expiry resit period
(
re.PostExpResitPeriod = 1  and QuizStatus.QuizStatusID >1 and
(
-- post expiry resit period
(dateadd(M,case when coalesce(ur.quizfrequency, o.DefaultQuizFrequency) = 0 then 99 else coalesce(ur.quizfrequency,o.DefaultQuizFrequency) end , QuizStatus.DateCreated)<=GETDATE())
or
-- post expiry resit date
(DATEADD(Y,1,quizstatus.DateCreated)<= coalesce(ur.quizcompletiondate,o.DefaultQuizCompletionDate) and coalesce(ur.quizcompletiondate,o.DefaultQuizCompletionDate)<= getutcdate())
)
)
)
)
)

and not exists
(SELECT * FROM tblQuizExpiryAtRisk
where 	tblQuizExpiryAtRisk.UserID = QuizStatus.UserID
and tblQuizExpiryAtRisk.ModuleID = QuizStatus.ModuleID
and tblQuizExpiryAtRisk.OrganisationID = @OrgID)



delete from tblQuizExpiryAtRisk
from tblOrganisation o
join tblQuizExpiryAtRisk ar on ar.OrganisationID = o.OrganisationID
join tblModule m on m.ModuleID = ar.ModuleID
join tblReminderEscalation re on re.CourseId = m.CourseID and ar.OrganisationID = re.OrgId
where re.DateEnabled>ar.ExpiryDate and o.OrganisationID = @OrgID


SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_Update_Quick'',''insert into tblQuizExpiryAtRisk'',''insert into tblQuizExpiryAtRisk'',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_Update_Quick'',1,1,null,getutcdate(),getutcdate()) END



if OBJECT_ID(''tempdb..#tblCurrentUserQuizStatus'') is not null
begin
	drop table #tblCurrentUserQuizStatus
end


if OBJECT_ID(''tempdb..#tblCurrentAssignedModules'') is not null
begin
	drop table #tblCurrentAssignedModules
end


if OBJECT_ID(''tempdb..#tblStartedModules'') is not null
begin
	drop table #tblStartedModules
end




/* /UNITTEST: CourseStatus */


/* UNITTEST: Licensing */
EXEC prcDatabaseMail_SetupProfile -- incase email address etc has changed, re-setup.

-- Check who is missing license for current period, includes period turn over
declare @lic_CourseLicensingID int, @lic_UserID int
DECLARE LicensingLoop CURSOR
FOR
SELECT DISTINCT tblCourseLicensing.CourseLicensingID, vwUserModuleAccess.UserID
FROM tblCourseLicensing
INNER JOIN vwUserModuleAccess ON tblCourseLicensing.CourseID = vwUserModuleAccess.CourseID
AND tblCourseLicensing.OrganisationID = vwUserModuleAccess.OrganisationID
INNER JOIN tblUser ON vwUserModuleAccess.UserID = tblUser.UserID
LEFT OUTER JOIN	tblCourseLicensingUser ON tblCourseLicensing.CourseLicensingID = tblCourseLicensingUser.CourseLicensingID
WHERE tblCourseLicensing.DateStart <= GETUTCDATE()
AND tblCourseLicensing.DateEnd >= GETUTCDATE()
AND tblCourseLicensingUser.CourseLicensingID IS NULL
AND tblUser.Active = 1
AND vwUserModuleAccess.OrganisationID = @OrgID
Open LicensingLoop
FETCH NEXT FROM LicensingLoop
Into
@lic_CourseLicensingID, @lic_UserID
WHILE @@FETCH_STATUS = 0
BEGIN
IF NOT EXISTS(SELECT CourseLicensingID FROM tblCourseLicensingUser WHERE CourseLicensingID = @lic_CourseLicensingID and UserID = @lic_UserID)
BEGIN
INSERT INTO tblCourseLicensingUser(CourseLicensingID, UserID) VALUES (@lic_CourseLicensingID, @lic_UserID)
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_Update_Quick'',''INSERT INTO tblCourseLicensingUser'',''INSERT INTO tblCourseLicensingUser'',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_Update_Quick'',1,1,null,getutcdate(),getutcdate()) END
END
FETCH NEXT FROM LicensingLoop
Into
@lic_CourseLicensingID, @lic_UserID
END

CLOSE LicensingLoop
DEALLOCATE LicensingLoop



-- WARNING EMAILS
-- License Warning
declare @licenseWarnEmail nvarchar(4000)
declare @licenseWarnEmail_Subject nvarchar(4000)
declare @emailLicenseWarnLicRecipients nvarchar(512)
declare @warn_lic_CourseName nvarchar(200),
@warn_lic_CourseLicensingID int,
@warn_lic_LicenseNumber int,
@warn_lic_LicenseWarnNumber int,
@warn_lic_RepNameSalt nvarchar(200),
@warn_lic_RepEmailSalt nvarchar(200),
@warn_lic_RepNameOrg nvarchar(200),
@warn_lic_RepEmailOrg nvarchar(200),
@warn_lic_LangCode nvarchar(10),
@warn_lic_LicensesUsed int,
@warn_lic_LicenseWarnEmail bit,
@warn_lic_OrganisationName nvarchar(50)

DECLARE LicenceNumberLoop CURSOR
FOR
SELECT
c.Name, l.CourseLicensingID, l.LicenseNumber, l.LicenseWarnNumber, l.RepNameSalt, l.RepEmailSalt,
l.RepNameOrg, l.RepEmailOrg, l.LangCode, COUNT(u.CourseLicensingUserID) AS LicensesUsed,
l.LicenseWarnEmail, OrganisationName
FROM
tblCourseLicensing l
INNER JOIN tblCourseLicensingUser u ON l.CourseLicensingID = u.CourseLicensingID
INNER JOIN tblCourse c ON l.CourseID = c.CourseID
LEFT JOIN tblOrganisation o ON l.OrganisationID = o.OrganisationID
WHERE
l.OrganisationID = @OrgID
GROUP BY
OrganisationName, l.CourseLicensingID, l.RepNameSalt, l.RepEmailSalt, l.RepNameOrg, l.RepEmailOrg, c.Name, l.LicenseNumber,
l.LicenseWarnNumber, l.LicenseWarnEmail, l.LangCode
HAVING
COUNT(u.CourseLicensingUserID) >= l.LicenseWarnNumber
AND l.LicenseWarnEmail = 1

Open LicenceNumberLoop
FETCH NEXT FROM LicenceNumberLoop
Into @warn_lic_CourseName,
@warn_lic_CourseLicensingID,
@warn_lic_LicenseNumber,
@warn_lic_LicenseWarnNumber,
@warn_lic_RepNameSalt,
@warn_lic_RepEmailSalt,
@warn_lic_RepNameOrg,
@warn_lic_RepEmailOrg,
@warn_lic_LangCode,
@warn_lic_LicensesUsed,
@warn_lic_LicenseWarnEmail,
@warn_lic_OrganisationName

WHILE @@FETCH_STATUS = 0
BEGIN
-- Get License Warning text in desired language.
SELECT     @licenseWarnEmail = tblLangValue.LangEntryValue
FROM         tblLang INNER JOIN
tblLangValue ON tblLang.LangID = tblLangValue.LangID INNER JOIN
tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID INNER JOIN
tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID
WHERE     (tblLang.LangCode = @warn_lic_LangCode) AND (tblLangInterface.LangInterfaceName = ''/ContentAdministration/Licensing/Default.aspx'') AND
(tblLangResource.LangResourceName = ''Email_LicenseWarn'') AND (tblLangValue.Active = 1)

SELECT     @licenseWarnEmail_Subject = tblLangValue.LangEntryValue
FROM         tblLang INNER JOIN
tblLangValue ON tblLang.LangID = tblLangValue.LangID INNER JOIN
tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID INNER JOIN
tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID
WHERE     (tblLang.LangCode = @warn_lic_LangCode) AND (tblLangInterface.LangInterfaceName = ''/ContentAdministration/Licensing/Default.aspx'') AND
(tblLangResource.LangResourceName = ''Email_LicenseWarn_Subject'') AND (tblLangValue.Active = 1)

-- {0} is receipient name, {1} is the license warning amount, {2} course name, {3} license limit, {4} name of contact person
-- {5} is organisation name
set @licenseWarnEmail = REPLACE(@licenseWarnEmail, ''{0}'', @warn_lic_RepNameOrg)
set @licenseWarnEmail = REPLACE(@licenseWarnEmail, ''{1}'', @warn_lic_LicenseWarnNumber)
set @licenseWarnEmail = REPLACE(@licenseWarnEmail, ''{2}'', @warn_lic_CourseName)
set @licenseWarnEmail = REPLACE(@licenseWarnEmail, ''{3}'', @warn_lic_LicenseNumber)
set @licenseWarnEmail = REPLACE(@licenseWarnEmail, ''{4}'', @warn_lic_RepNameSalt)
set @licenseWarnEmail = REPLACE(@licenseWarnEmail, ''{5}'', @warn_lic_OrganisationName)

set @licenseWarnEmail_Subject = REPLACE(@licenseWarnEmail_Subject, ''{0}'', @warn_lic_CourseName)
set @licenseWarnEmail_Subject = REPLACE(@licenseWarnEmail_Subject, ''{1}'', @warn_lic_OrganisationName)

select @emailLicenseWarnLicRecipients = @warn_lic_RepEmailOrg +'';''+@warn_lic_RepEmailSalt

EXEC msdb.dbo.sp_send_dbmail
@recipients = @emailLicenseWarnLicRecipients,
@body = @licenseWarnEmail,
@subject = @licenseWarnEmail_Subject,
@profile_name = ''Salt_MailAccount''

--Log emails sent
exec prcEMail_LogSentEmail @toEmail = @warn_lic_RepEmailOrg, @toName = null, @fromEmail = ''support@blakedawson.com'', @fromName = ''Blake Dawson'', @subject = @licenseWarnEmail_Subject, @body = @licenseWarnEmail, @organisationID = @OrgID
exec prcEMail_LogSentEmail @toEmail = @warn_lic_RepEmailSalt, @toName = null, @fromEmail = ''support@blakedawson.com'', @fromName = ''Blake Dawson'', @subject = @licenseWarnEmail_Subject, @body = @licenseWarnEmail, @organisationID = @OrgID

print ''queued numLics warning mail to : '' + @emailLicenseWarnLicRecipients

-- Unset flag and record date email sent
UPDATE tblCourseLicensing SET DateLicenseWarnEmailSent = getutcdate(), LicenseWarnEmail = 0 WHERE CourseLicensingID = @warn_lic_CourseLicensingID
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_Update_Quick'',''UPDATE tblCourseLicensing'',''UPDATE tblCourseLicensing'',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_Update_Quick'',1,1,null,getutcdate(),getutcdate()) END

FETCH NEXT FROM LicenceNumberLoop
Into @warn_lic_CourseName,
@warn_lic_CourseLicensingID,
@warn_lic_LicenseNumber,
@warn_lic_LicenseWarnNumber,
@warn_lic_RepNameSalt,
@warn_lic_RepEmailSalt,
@warn_lic_RepNameOrg,
@warn_lic_RepEmailOrg,
@warn_lic_LangCode,
@warn_lic_LicensesUsed,
@warn_lic_LicenseWarnEmail,
@warn_lic_OrganisationName
END

CLOSE LicenceNumberLoop
DEALLOCATE LicenceNumberLoop
-- /License Warning


-- Expiry Warning
declare @expiryWarnEmail nvarchar(4000)
declare @expiryWarnEmail_Subject nvarchar(4000)
declare @emailLicenseWarnExpRecipients nvarchar(512)
DECLARE @warn_exp_CourseLicensingID int,
@warn_exp_CourseName nvarchar(200),
@warn_exp_DateWarn datetime,
@warn_exp_ExpiryWarnEmail bit,
@warn_exp_DateEnd datetime,
@warn_exp_RepNameSalt nvarchar(200),
@warn_exp_RepEmailSalt nvarchar(200),
@warn_exp_RepNameOrg nvarchar(200),
@warn_exp_RepEmailOrg nvarchar(200),
@warn_exp_LangCode nvarchar(10),
@warn_exp_OrganisationName nvarchar(50)

DECLARE LicenceExpiryLoop CURSOR
FOR
SELECT
l.CourseLicensingID, c.Name, l.DateWarn, l.ExpiryWarnEmail, l.DateEnd, l.RepNameSalt,
l.RepEmailSalt, l.RepNameOrg, l.RepEmailOrg, l.LangCode, OrganisationName
FROM
tblCourseLicensing l
INNER JOIN tblCourse c ON l.CourseID = c.CourseID
LEFT JOIN tblOrganisation o ON l.OrganisationID = o.OrganisationID
WHERE
l.DateWarn < GETUTCDATE()
AND l.ExpiryWarnEmail = 1
AND l.OrganisationID = @OrgID

Open LicenceExpiryLoop
FETCH NEXT FROM LicenceExpiryLoop
Into @warn_exp_CourseLicensingID,
@warn_exp_CourseName,
@warn_exp_DateWarn,
@warn_exp_ExpiryWarnEmail,
@warn_exp_DateEnd,
@warn_exp_RepNameSalt,
@warn_exp_RepEmailSalt,
@warn_exp_RepNameOrg,
@warn_exp_RepEmailOrg,
@warn_exp_LangCode,
@warn_exp_OrganisationName

WHILE @@FETCH_STATUS = 0
BEGIN
-- Get Expiry Warning text in desired language.
SELECT     @expiryWarnEmail = tblLangValue.LangEntryValue
FROM         tblLang INNER JOIN
tblLangValue ON tblLang.LangID = tblLangValue.LangID INNER JOIN
tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID INNER JOIN
tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID
WHERE     (tblLang.LangCode = @warn_exp_LangCode) AND (tblLangInterface.LangInterfaceName = ''/ContentAdministration/Licensing/Default.aspx'') AND
(tblLangResource.LangResourceName = ''Email_ExpiryWarn'') AND (tblLangValue.Active = 1)

SELECT     @expiryWarnEmail_Subject = tblLangValue.LangEntryValue
FROM         tblLang INNER JOIN
tblLangValue ON tblLang.LangID = tblLangValue.LangID INNER JOIN
tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID INNER JOIN
tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID
WHERE     (tblLang.LangCode = @warn_exp_LangCode) AND (tblLangInterface.LangInterfaceName = ''/ContentAdministration/Licensing/Default.aspx'') AND
(tblLangResource.LangResourceName = ''Email_ExpiryWarn_Subject'') AND (tblLangValue.Active = 1)

-- {0} Receipient Name, {1} number days till expiry, {2} course name, {3} expiry date, {4} Salt rep name
-- {5} Organisation Name
set @expiryWarnEmail = REPLACE(@expiryWarnEmail, ''{0}'', @warn_exp_RepNameOrg)
set @expiryWarnEmail = REPLACE(@expiryWarnEmail, ''{1}'', DATEDIFF(dd,dbo.udfUTCtoDaylightSavingTime(getUTCdate(),@OrgID),dbo.udfUTCtoDaylightSavingTime(@warn_exp_DateEnd,@OrgID)))
set @expiryWarnEmail = REPLACE(@expiryWarnEmail, ''{2}'', @warn_exp_CourseName)
set @expiryWarnEmail = REPLACE(@expiryWarnEmail, ''{3}'', CONVERT(CHAR(10), dbo.udfUTCtoDaylightSavingTime(@warn_exp_DateEnd,@OrgID), 103))
set @expiryWarnEmail = REPLACE(@expiryWarnEmail, ''{4}'', @warn_exp_RepNameSalt)
set @expiryWarnEmail = REPLACE(@expiryWarnEmail, ''{5}'', @warn_exp_OrganisationName)

set @expiryWarnEmail_Subject = REPLACE(@expiryWarnEmail_Subject, ''{0}'', @warn_exp_CourseName)
set @expiryWarnEmail_Subject = REPLACE(@expiryWarnEmail_Subject, ''{1}'', @warn_exp_OrganisationName)

select @emailLicenseWarnExpRecipients = @warn_exp_RepEmailOrg +'';''+@warn_exp_RepEmailSalt

EXEC msdb.dbo.sp_send_dbmail
@recipients = @emailLicenseWarnExpRecipients,
@body = @expiryWarnEmail,
@subject = @expiryWarnEmail_Subject,
@profile_name = ''Salt_MailAccount''

--Log emails sent
exec prcEMail_LogSentEmail @toEmail = @warn_exp_RepEmailOrg, @toName = null, @fromEmail = ''support@blakedawson.com'', @fromName = ''Blake Dawson'', @subject = @expiryWarnEmail_Subject, @body = @expiryWarnEmail, @organisationID = @OrgID
exec prcEMail_LogSentEmail @toEmail = @warn_exp_RepEmailSalt, @toName = null, @fromEmail = ''support@blakedawson.com'', @fromName = ''Blake Dawson'', @subject = @expiryWarnEmail_Subject, @body = @expiryWarnEmail, @organisationID = @OrgID

print ''queued expiry mail to : '' + @emailLicenseWarnExpRecipients
-- Unset flag and record date email sent
UPDATE tblCourseLicensing SET DateExpiryWarnEmailSent = getutcdate(), ExpiryWarnEmail = 0 WHERE CourseLicensingID = @warn_exp_CourseLicensingID
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_Update_Quick'',''UPDATE tblCourseLicensing'',''UPDATE tblCourseLicensing'',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_Update_Quick'',1,1,null,getutcdate(),getutcdate()) END


FETCH NEXT FROM LicenceExpiryLoop
Into @warn_exp_CourseLicensingID,
@warn_exp_CourseName,
@warn_exp_DateWarn,
@warn_exp_ExpiryWarnEmail,
@warn_exp_DateEnd,
@warn_exp_RepNameSalt,
@warn_exp_RepEmailSalt,
@warn_exp_RepNameOrg,
@warn_exp_RepEmailOrg,
@warn_exp_LangCode,
@warn_exp_OrganisationName
END

CLOSE LicenceExpiryLoop
DEALLOCATE LicenceExpiryLoop
-- /Expiry Warning
/* /UNITTEST: Licensing */


/* UNITTEST: ModuleNightly */
-- START Course status reconcile. If a module has been made active or inactive to run through all user and ensure that their course status is correct.
-- AS PER BUSINESS requirement
-- Get all changed modules
declare @c_CourseID int, @c_ModuleID int
DECLARE UpdatedModuleLOOP CURSOR
FOR
SELECT CourseID, ModuleID FROM tblModule WHERE(DateUpdated > GETUTCDATE() - 2)
Open UpdatedModuleLOOP

FETCH NEXT FROM UpdatedModuleLOOP
Into
@c_CourseID, @c_ModuleID

WHILE @@FETCH_STATUS = 0
BEGIN
-- Get all users related to this module
declare @c_UserID int
DECLARE UserLOOP CURSOR
FOR
SELECT UserID FROM tblUserModuleAccess WHERE ModuleID = @c_ModuleID
Open UserLOOP


FETCH NEXT FROM UserLOOP
Into
@c_UserID

WHILE @@FETCH_STATUS = 0
BEGIN
EXEC prcUserQuizStatus_UpdateCourseStatus @c_UserID, @c_ModuleID
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_Update_Quick'',''prcUserQuizStatus_UpdateCourseStatus'',''prcUserQuizStatus_UpdateCourseStatus'',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_Update_Quick'',1,1,null,getutcdate(),getutcdate()) END

FETCH NEXT FROM UserLOOP
Into
@c_UserID
END

CLOSE UserLOOP
DEALLOCATE UserLOOP

FETCH NEXT FROM UpdatedModuleLOOP
Into
@c_CourseID, @c_ModuleID
END

CLOSE UpdatedModuleLOOP
DEALLOCATE UpdatedModuleLOOP
/* /UNITTEST: ModuleNightly */


/* UNITTEST: ExtendComplianceDate */
update tblOrganisation
set DefaultQuizCompletionDate = dateadd(year, 1, [DefaultQuizCompletionDate])
where DefaultQuizCompletionDate < getutcdate() and OrganisationID = @OrgID

update tblUnitRule
set QuizCompletionDate = dateadd(year, 1, [QuizCompletionDate])
where QuizCompletionDate < getutcdate() and UnitID IN (select UnitID from tblUnit where OrganisationID = @OrgID)
/* /UNITTEST: ExtendComplianceDate */


-- END Course status reconcile.


update tblOrganisation set CourseStatusLastUpdated = dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID) where OrganisationID = @OrgID

update tblModuleStatusUpdateHistory
set FinishTime = getutcdate()
where ModuleStatusUpdateHistoryID = @intHistoryID
' 
END
GO
