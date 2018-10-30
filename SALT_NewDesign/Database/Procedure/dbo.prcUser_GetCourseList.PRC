SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_GetCourseList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Gets course List for User My Training page

Parameters:


Returns:


Called By:
User.cs.

Calls:


Assumptions:


Remarks:



Author: Aaron Cripps
Date Created: August 2008

Modification History
-----------------------------------------------------------
v#	Author		Date			Description


**/

CREATE  Procedure [dbo].[prcUser_GetCourseList]
(
@UserID int,
@ProfileID int,
@CurrentCultureName NVarChar(40) = ''en-AU''
)

As

DECLARE @OrgID int

Select @OrgID = OrganisationID FROM tblUser where UserID = @UserID
create table #UserCourse
(
CourseID int,
[Name] nvarchar(100),
Notes nvarchar(1000),
Active bit,
CreatedBy int,
DateCreated datetime,
UpdatedBy int,
DateUpdated datetime
)

insert into #UserCourse
exec prcCourse_GetListByUser @UserID

Create table #CourseName
(
CourseID int,
[Name] nvarchar(100),
DateCreated datetime
)

Create Table #CourseStatus
(
CourseID int,
CourseStatusID int,
DateCreated datetime
)

insert into #CourseStatus
select
ucs.CourseID,
ucs.CourseStatusID,
max(ucs.DateCreated) as DateCreated
from
tblUserCourseStatus ucs
join #UserCourse uc	on  ucs.CourseID = uc.CourseID
where
ucs.UserID = @UserID
and not exists (select * from tblusercoursestatus ucs2
where ucs.courseid = ucs2.courseid
and ucs.userid = ucs2.userid
and ucs.datecreated <ucs2.datecreated )
group by
ucs.CourseID, ucs.CourseStatusID
order by
DateCreated desc

Create Table #CourseStatusTemp
(
CourseID int,
DateCreated datetime
)

insert into #CourseStatusTemp
select
CourseID,
max(DateCreated)
from
#CourseStatus
group by CourseID

Create Table #CourseList
(
CourseID int,
[Name] nvarchar(100),
CourseStatusID int,
Due varchar(11),
LastComp varchar(11),
Red char(1)
)

Declare @DefaultLessonCompletionDate Datetime
Declare @DefaultQuizCompletionDate Datetime
DECLARE @DefaultQuizFrequency integer

SELECT @DefaultQuizCompletionDate = DefaultQuizCompletionDate
,@DefaultLessonCompletionDate = DefaultLessonCompletionDate
,@DefaultQuizFrequency = DefaultQuizFrequency
FROM tblOrganisation where OrganisationID = (SELECT OrganisationID FROM tblUser WHERE UserID = @UserID)

declare @OrganisationID integer

select @OrganisationID = OrganisationID FROM tblUser WHERE UserID = @UserID







insert into #CourseList
select
uc.CourseID,
uc.[Name],
cs.CourseStatusID,
case

when cs.CourseStatusID = 2 and @DefaultQuizCompletionDate is  null  then '' ''
when cs.CourseStatusID = 2 and   @DefaultQuizCompletionDate is not null
then convert(varchar (11),dbo.udfUserUTCtoDaylightSavingTime(@DefaultQuizCompletionDate,@OrganisationID),113)
when cs.CourseStatusID <> 2 and (RemEsc.DaysToCompleteCourse is null OR ((RemEsc.NotifyMgr = 0) AND (RemEsc.RemindUsers = 0))) then ''-- ''
when cs.CourseStatusID <> 2 and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and CStart.DateCreated is null
then CAST(RemEsc.DaysToCompleteCourse AS VARCHAR(5))																																															-- course just added , overnight job has not caught up yet
+ (SELECT  '' ''+LangEntryValue  FROM tblLangValue
where LangInterfaceID = (SELECT  LangInterfaceID   FROM tblLangInterface WHERE LangInterfaceName = ''GLOBAL.MISC'')
and LangID =(SELECT LangID FROM tblLang where tblLang.LangCode=  @CurrentCultureName)
and LangResourceID = (SELECT LangResourceID  FROM tblLangResource where   LangResourceName = ''days'' ))

when cs.CourseStatusID <> 2 and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and CStart.DateCreated is not null	 AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,CS.DateCreated,getUTCdate())) >= 0
then CAST(RemEsc.DaysToCompleteCourse -   DATEDIFF(day,CS.DateCreated,getUTCdate()) AS VARCHAR(5))
+ (SELECT  '' ''+LangEntryValue  FROM tblLangValue
where LangInterfaceID = (SELECT  LangInterfaceID   FROM tblLangInterface WHERE LangInterfaceName = ''GLOBAL.MISC'')
and LangID =(SELECT LangID FROM tblLang where tblLang.LangCode=  @CurrentCultureName)
and LangResourceID = (SELECT LangResourceID  FROM tblLangResource where   LangResourceName = ''days'' ))
when cs.CourseStatusID <> 2 and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and CStart.DateCreated is not null	 AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,CS.DateCreated,getUTCdate())) < 0
then convert(varchar (11),DATEADD(day,RemEsc.DaysToCompleteCourse,dbo.udfUTCtoDaylightSavingTime(CS.DateCreated,@OrgID)),113)


end ,
case
when CPass.DateCreated is null then '' ''
when CPass.DateCreated is not null then convert(varchar (11),dbo.udfUTCtoDaylightSavingTime(CPass.DateCreated,@OrgID),113)
end ,

case when cs.CourseStatusID <> 2 and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and CStart.DateCreated is not null	 AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,CS.DateCreated,getUTCdate())) < 0		then 1 else 0 end

from
#UserCourse uc
left outer join #CourseStatus cs on uc.CourseID = cs.CourseID
left outer join (SELECT MIN(UserCourseStatusID) as UserCourseStatusID,[UserID] ,[CourseID] FROM tblUserCourseStatus LastAttempt where LastAttempt.UserID = @UserID and not exists (SELECT * FROM tblUserCourseStatus PreviousAttempt where PreviousAttempt.UserID = @UserID and PreviousAttempt.CourseStatusID = 0 and PreviousAttempt.UserCourseStatusID < LastAttempt.UserCourseStatusID and PreviousAttempt.CourseID = LastAttempt.CourseID and PreviousAttempt.UserID = LastAttempt.UserID) group by [UserID] ,[CourseID]
) CSID ON CSID.UserID = @UserID and CSID.courseID = cs.courseID
left outer join tblUserCourseStatus CStart ON CStart.UserID = @UserID and CStart.courseID = cs.courseID and CStart.UserCourseStatusID = CSID.UserCourseStatusID
left outer join tblReminderEscalation RemEsc on RemEsc.CourseId = cs.CourseID and RemEsc.orgID = @OrgID
--last passed course date
left outer join
(SELECT MAX(UserCourseStatusID) as UserCourseStatusID,[UserID] ,[CourseID] FROM tblUserCourseStatus PreviousAttempt where PreviousAttempt.userID = @UserID  and PreviousAttempt.CourseStatusID = 2 group by [UserID] ,[CourseID]
) CPSID ON CPSID.UserID = @UserID and CPSID.courseID = cs.courseID
left outer join tblUserCourseStatus CPass ON CPass.UserID = @UserID and CPass.courseID = cs.courseID and CPass.UserCourseStatusID = CPSID.UserCourseStatusID





--Now get points available for each course
Create Table #CoursePoints
(
CourseID int,
PointsAvailable numeric(10,1)
)

insert into #CoursePoints
select
cl.CourseID, sum(ppts.Points)
from
#CourseList cl
join tblModule m on m.CourseID = cl.CourseID
join tblProfilePoints ppts on m.ModuleID = ppts.TypeID
join tblProfilePeriod pp on ppts.ProfilePeriodID = pp.ProfilePeriodID
where
m.Active = 1 and ppts.Active = 1 and pp.ProfileID = @ProfileID
group by
cl.CourseID


select
@ProfileID as ProfileID,
cl.CourseID, cl.[Name],
coalesce(cl.CourseStatusID, 1) as CourseStatusID,
cp.PointsAvailable,
cl.Due ,
cl.LastComp,
cl.red
from
#CourseList cl
left join #CoursePoints cp on cl.CourseID = cp.CourseID
order by cl.[Name]


drop table #UserCourse
drop table #CourseName
drop table #CourseStatus
drop table #CourseStatusTemp
drop table #CourseList
drop table #CoursePoints


' 
END
GO
