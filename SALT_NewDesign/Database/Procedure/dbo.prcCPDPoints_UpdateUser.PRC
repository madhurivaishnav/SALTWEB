SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcCPDPoints_UpdateUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure [prcCPDPoints_UpdateUser]
(
@profileid int,
@userid int,
@OrgID int
)
as begin
set nocount on
declare @userquizstatusid int
declare @userlessonstatusid int
declare @quizstatusid int
declare @lessonstatusid int
declare @datecreated datetime
declare @pointsgiven bit
declare @applytoquiz bit
declare @applytolesson bit
declare @profilepointsid int
declare @points numeric(10,1)
declare @quizpassed bit
declare @lessonpassed bit
declare @userstatusid int
declare @statusid int
declare @type char
declare @moduleid int
declare @newmoduleid int

set @applytoquiz = (select applytoquiz from tblProfilePeriod pp join tblProfile p
on pp.profileid = p.profileid where p.profileid = @profileid and pp.profileperiodactive = 1)

set @applytolesson = (select applytolesson from tblProfilePeriod pp join tblProfile p
on pp.profileid = p.profileid where p.profileid = @profileid and pp.profileperiodactive = 1)

-- delete points (if requirements re: lesson and quiz have changed)
-- find User CPD points within the period
declare @lessonquizstatus int
declare @profileperiodid int

-- lessonquizstatus
-- 0 Lesson Only
-- 1 Quiz Only
-- 2 Lesson and Quiz

select @lessonquizstatus =
(case when (applytoquiz = 1 and applytolesson = 1) then	2
when (applytoquiz = 0 and applytolesson = 1) then	0
when (applytoquiz = 1 and applytolesson = 0) then	1
end), @profileperiodid = pp.profileperiodid
from tblProfile p
join tblProfilePeriod pp on p.ProfileID = pp.ProfileID
where p.profileid = @profileid and pp.profileperiodactive=1 and GETUTCDATE() between pp.datestart and dateadd(d,1,pp.dateend)


delete from tblusercpdpoints
where profilepointsid in
(select profilepointsid from tblprofilepoints where profileperiodid = @profileperiodid and active=1 and profilepointstype=''M'')
and userid = @userid

-- add points for user

-- Apply to Quiz only
if (@applytoquiz = 1 and @applytolesson = 0)
begin
-- Get and iterate through the user quiz status records for the user
declare userquizcursor cursor for
select m.moduleid, ppts.profilepointsid, ppts.points, UserQuizStatusID, QuizStatusID, dbo.udfUTCtoDaylightSavingTime(uqs.datecreated, @OrgID) from tblProfile p
join tblProfilePeriod pp on p.ProfileID = pp.ProfileID
join tblUserProfilePeriodAccess uppa on pp.ProfilePeriodID = uppa.ProfilePeriodID
join tblUserQuizStatus uqs on uppa.UserID = uqs.UserID
join tblQuizSession qs on uqs.quizsessionid = qs.quizsessionid
join tblQuiz q on q.quizid = qs.quizid
join tblModule m on m.moduleid = q.moduleid
join tblProfilePoints ppts on ppts.typeid = m.moduleid and ppts.profilepointstype = ''M'' and ppts.profileperiodid = pp.profileperiodid
where p.ProfileID = @profileid
and uppa.Granted = 1
and uppa.UserID = @userID
and uqs.datecreated between pp.datestart and dateadd(d,1,pp.dateend)
order by m.moduleid, uqs.datecreated

-- initialise
set @pointsgiven = 0
set @moduleid = 0
set @newmoduleid = 0

open userquizcursor

fetch next from userquizcursor
into @newmoduleid, @profilepointsid, @points, @userquizstatusid, @quizstatusid, @datecreated

while @@FETCH_STATUS = 0
begin
if @newmoduleid <> @moduleid
begin
set @pointsgiven = 0
end
if @pointsgiven = 0
begin
if @quizstatusid = 2
begin
insert into tblUserCPDPoints (ProfilePointsID, UserID, Points, DateAssigned, LessonQuizStatus)
values (@profilepointsid, @userID, @points, @datecreated, 1)
set @pointsgiven = 1
end
end
if @pointsgiven = 1
begin
if @quizstatusid = 5
begin
set @pointsgiven = 0
end
end

set @moduleid = @newmoduleid
fetch next from userquizcursor
into @newmoduleid, @profilepointsid, @points, @userquizstatusid, @quizstatusid, @datecreated
end

close userquizcursor
deallocate userquizcursor
end

-- Apply to Lesson Only
if (@applytoquiz = 0 and @applytolesson = 1)
begin
-- Get and iterate through the user lesson status records for the user
declare userlessoncursor cursor for
select m.moduleid, ppts.profilepointsid, ppts.points, UserLessonStatusID, LessonStatusID, dbo.udfUTCtoDaylightSavingTime(uls.datecreated, @OrgID) from tblProfile p
join tblProfilePeriod pp on p.ProfileID = pp.ProfileID
join tblUserProfilePeriodAccess uppa on pp.ProfilePeriodID = uppa.ProfilePeriodID
join tblUserLessonStatus uls on uppa.UserID = uls.UserID
join tblModule m on m.moduleid = uls.moduleid
join tblProfilePoints ppts on ppts.typeid = m.moduleid and ppts.profilepointstype = ''M'' and ppts.profileperiodid = pp.profileperiodid
where p.ProfileID = @profileid
and uppa.Granted = 1
and uppa.UserID = @userID
and uls.datecreated between pp.datestart and dateadd(d,1,pp.dateend)
order by m.moduleid, uls.datecreated

-- initialise
set @pointsgiven = 0
set @moduleid = 0
set @newmoduleid = 0

open userlessoncursor

fetch next from userlessoncursor
into @newmoduleid, @profilepointsid, @points,@userlessonstatusid, @lessonstatusid, @datecreated

while @@FETCH_STATUS = 0
begin
if @newmoduleid <> @moduleid
begin
set @pointsgiven = 0
end
if @pointsgiven = 0
begin
if @lessonstatusid = 3
begin
insert into tblUserCPDPoints (ProfilePointsID, UserID, Points, DateAssigned, LessonQuizStatus)
values (@profilepointsid, @userID, @points, @datecreated, 0)
set @pointsgiven = 1
end
end
if @pointsgiven = 1
begin
if @lessonstatusid = 5
begin
set @pointsgiven = 0
end
end
set @moduleid = @newmoduleid
fetch next from userlessoncursor
into @newmoduleid, @profilepointsid, @points,@userlessonstatusid, @lessonstatusid, @datecreated
end

close userlessoncursor
deallocate userlessoncursor
end

-- Apply to Quiz and Lesson
if (@applytoquiz = 1 and @applytolesson = 1)
begin
create table #tempUserStatus
(
moduleid int,
profilepointsid int,
points numeric(10,1),
userstatusid int,
statusid int,
datecreated datetime,
type char
)
-- insert quiz status values into temp status table
insert into #tempUserStatus (moduleid, profilepointsid, points, userstatusid, statusid, datecreated, type)
select m.moduleid, ppts.profilepointsid, ppts.points, UserQuizStatusID, QuizStatusID, uqs.datecreated, ''Q'' from tblProfile p
join tblProfilePeriod pp on p.ProfileID = pp.ProfileID
join tblUserProfilePeriodAccess uppa on pp.ProfilePeriodID = uppa.ProfilePeriodID
join tblUserQuizStatus uqs on uppa.UserID = uqs.UserID
join tblQuizSession qs on uqs.quizsessionid = qs.quizsessionid
join tblQuiz q on q.quizid = qs.quizid
join tblModule m on m.moduleid = q.moduleid
join tblProfilePoints ppts on ppts.typeid = m.moduleid and ppts.profilepointstype = ''M'' and ppts.profileperiodid = pp.profileperiodid
where p.ProfileID = @profileid
and uppa.Granted = 1
and uppa.UserID = @userID
and uqs.datecreated between pp.datestart and dateadd(d,1,pp.dateend)

-- insert lesson status values into temp status table
insert into #tempUserStatus (moduleid, profilepointsid, points, userstatusid, statusid, datecreated, type)
select m.moduleid, ppts.profilepointsid, ppts.points, UserLessonStatusID, LessonStatusID, dbo.udfUTCtoDaylightSavingTime(uls.datecreated, @OrgID), ''L'' from tblProfile p
join tblProfilePeriod pp on p.ProfileID = pp.ProfileID
join tblUserProfilePeriodAccess uppa on pp.ProfilePeriodID = uppa.ProfilePeriodID
join tblUserLessonStatus uls on uppa.UserID = uls.UserID
join tblModule m on m.moduleid = uls.moduleid
join tblProfilePoints ppts on ppts.typeid = m.moduleid and ppts.profilepointstype = ''M'' and ppts.profileperiodid = pp.profileperiodid
where p.ProfileID = @profileid
and uppa.Granted = 1
and uppa.UserID = @userID
and uls.datecreated between pp.datestart and dateadd(d,1,pp.dateend)

set @pointsgiven = 0
set @quizpassed = 0
set @lessonpassed = 0
set @moduleid = 0
set @newmoduleid = 0

declare userquizlessoncursor cursor for
select * from #tempUserStatus order by moduleid, datecreated

open userquizlessoncursor

fetch next from userquizlessoncursor
into @newmoduleid, @profilepointsid, @points,@userstatusid, @statusid, @datecreated, @type
while @@FETCH_STATUS = 0
begin
if @newmoduleid <> @moduleid
begin
set @pointsgiven = 0
set @lessonpassed = 0
set @quizpassed = 0
end
if @pointsgiven = 0
begin
if (@statusid = 2 and @type = ''Q'' and @quizpassed = 0)
begin
-- passed quiz
set @quizpassed = 1
end
if (@statusid = 3 and @type = ''L'' and @lessonpassed = 0)
begin
-- lesson passed
set @lessonpassed = 1
end
if (@quizpassed = 1 and @lessonpassed = 1)
begin
-- give points
insert into tblUserCPDPoints (ProfilePointsID, UserID, Points, DateAssigned, LessonQuizStatus)
values (@profilepointsid, @userID, @points, @datecreated, 2)
set @pointsgiven = 1
end
end
if (@pointsgiven = 1)
begin
if (@statusid = 5 and @type = ''Q'')
begin
set @quizpassed = 0
set @pointsgiven = 0
end
if (@statusid = 5 and @type = ''L'')
begin
set @lessonpassed = 0
set @pointsgiven = 0
end
end
set @moduleid = @newmoduleid
fetch next from userquizlessoncursor
into @newmoduleid, @profilepointsid, @points,@userstatusid, @statusid, @datecreated, @type
end

drop table #tempUserStatus
close userquizlessoncursor
deallocate userquizlessoncursor
end
set nocount off
end

SET QUOTED_IDENTIFIER ON
' 
END
GO
