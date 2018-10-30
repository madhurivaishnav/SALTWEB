SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUserQuizStatus_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*

CALLS prcUserQuizStatus_Update_Quick

**/
ALTER   Procedure [prcUserQuizStatus_Update]
AS
Set Nocount On
declare @intHistoryID int

insert into tblModuleStatusUpdateHistory(startTime) values(getutcdate());
set @intHistoryID = @@identity


declare @cursor_OrgID	    int

DECLARE OrgList CURSOR
FOR
SELECT OrganisationID
from tblOrganisation
WHERE DATEDIFF (d,CourseStatusLastUpdated,dbo.udfUTCtoDaylightSavingTime(getutcdate(),OrganisationID)) > 0
order by OrganisationID desc

Open OrgList

FETCH NEXT FROM OrgList
Into
@cursor_OrgID

WHILE @@FETCH_STATUS = 0
BEGIN

exec prcUserQuizStatus_Update_Quick @cursor_OrgID
exec prcUserLessonStatus_Update_Quick @cursor_OrgID
print ''Completed Organisation: '' + Cast(@cursor_OrgID as varchar)

FETCH NEXT FROM OrgList Into @cursor_OrgID
END

CLOSE OrgList
DEALLOCATE OrgList



update tblModuleStatusUpdateHistory
set FinishTime = getutcdate()
where ModuleStatusUpdateHistoryID = @intHistoryID
' 
END
GO 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcAutomatedEmails_ManagersToNotifyIndividually]') AND type in (N'P', N'PC'))
DROP PROCEDURE [prcAutomatedEmails_ManagersToNotifyIndividually]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcAutomatedEmails_ManagersToNotifyIndividually]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [prcAutomatedEmails_ManagersToNotifyIndividually]
(
@OrganisationID int
)


AS

BEGIN


--                    S E L E C T    T H E    R E S U L T S

--declare @OrganisationID int
--set @OrganisationID = 68

;with UsersToNotify (userid,DelinquentCourse,username,uFirstname,uLastname) as (
SELECT distinct UsersToNotify.userid , UsersToNotify.DelinquentCourse,username,uFirstname,uLastname FROM
(


-- delinquent users
SELECT DISTINCT CD.UserCourseStatusID as UserCourseStatusID, CS.userID , u.username, C.Name     as DelinquentCourse, u.FirstName as uFirstname, u.LastName as uLastname
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblUserCourseDetails UCD ON (UCD.UserID = u.UserID AND UCD.CourseID = C.CourseID)
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID)  AND (RemEsc.IndividualNotification=1) AND (RemEsc.NotifyMgr = 1) AND (RemEsc.DaysToCompleteCourse>0)
where (coursestatusid = 1) 
AND (o.OrganisationID = @OrganisationID) 
AND (GETUTCDATE() > DATEADD(d,RemEsc.DaysToCompleteCourse+1, CS.DateCreated)) -- Is Overdue
AND (U.active = 1) 
AND (UCD.LastDelNoteToMgr = 0)
AND (GETUTCDATE() < DATEADD(m,6,DATEADD(d,RemEsc.DaysToCompleteCourse, CS.DateCreated))) -- Business Rule = If Course is more than 6 months overdue stop notifying managers



)  UsersToNotify
)

, UsersToNotifyList(numb, userid,DelinquentCourse,username,uFirstname,uLastname) as
(
select 1,null,CAST('''' AS NVARCHAR(max)),CAST('''' AS NVARCHAR(max)),CAST('''' AS NVARCHAR(max)),CAST('''' AS NVARCHAR(max))
UNION ALL

--SELECT cte.numb + 1,pl.userid,CAST(cte.DelinquentCourse + (case when cte.DelinquentCourse = '''' or pl.DelinquentCourse = '''' then '''' else ''<BR>'' end ) + pl.DelinquentCourse AS NVARCHAR(max))
SELECT cte.numb + 1,pl.userid,CAST(    cte.DelinquentCourse +  ''<BR>&nbsp;&nbsp;'' + pl.DelinquentCourse AS NVARCHAR(max)),CAST(pl.username AS NVARCHAR(max)),CAST(pl.uFirstname AS NVARCHAR(max)),CAST(pl.uLastname AS NVARCHAR(max))

from (  SELECT

RowNum = Row_Number() OVER (partition BY userid order by userid)
,userid,DelinquentCourse,username,uFirstname,uLastname

FROM UsersToNotify
) AS pl
join UsersToNotifyList cte on pl.RowNum = cte.numb and (cte.userid is null or pl.userid = cte.userid)
)




, ManagersToNotifyList(numb, ManagerEmail, DelinquentCourse, FirstName, LastName,username,ManagerName,uFirstname,uLastname) as
(
select numb,  CAST(UsersManagers.Email AS NVARCHAR(max)),DelinquentCourse,FirstName,LastName,UL.username,UsersManagers.UserName,uFirstname,uLastname
FROM UsersToNotifyList UL
inner join (select max(numb) AS maxnumb,Userid  from UsersToNotifyList  group by userid) max on max.maxnumb = UL.numb and max.userid = UL.userid

--INNER JOIN
--	(
--		SELECT U.username, U.UserID, tblUnitAdmins.Email ,tblUnitAdmins.FirstName, tblUnitAdmins.LastName
--		FROM  tblUser U  
--					INNER JOIN  tblUnitAdministrator ON U.UnitID = tblUnitAdministrator.UnitID
--					INNER JOIN   dbo.tblUser AS tblUnitAdmins ON dbo.tblUnitAdministrator.UserID = tblUnitAdmins.UserID AND tblUnitAdmins.UserTypeID = 3
--					WHERE  U.NotifyUnitAdmin = 1
--		UNION ALL 
--		SELECT U.username, U.UserID, tblOrgAdmins.Email ,tblOrgAdmins.FirstName, tblOrgAdmins.LastName
--		FROM  tblUser U  
--					INNER JOIN  dbo.tblUser AS tblOrgAdmins ON U.OrganisationID = tblOrgAdmins.OrganisationID
--					WHERE  U.NotifyOrgAdmin = 1 AND tblOrgAdmins.UserTypeID = 2
--		UNION ALL
--		SELECT username, tblUserDelinquencyManager.UserID, tblUserDelinquencyManager.DelinquencyManagerEmail,'' '' AS FirstName, '' '' AS LastName
--		FROM  dbo.tblUser AS tblUserDelinquencyManager WHERE  NotifyMgr = 1 and tblUserDelinquencyManager.Email IS NOT NULL AND (tblUserDelinquencyManager.Email != '''')
--	) UsersManagers ON UsersManagers.UserID = UL.UserID
--)

INNER JOIN
	(
		SELECT tblUnitAdmins.username, U.UserID, tblUnitAdmins.Email ,tblUnitAdmins.FirstName, tblUnitAdmins.LastName
		FROM  tblUser U  
					INNER JOIN  tblUnitAdministrator ON U.UnitID = tblUnitAdministrator.UnitID
					INNER JOIN   dbo.tblUser AS tblUnitAdmins ON dbo.tblUnitAdministrator.UserID = tblUnitAdmins.UserID AND tblUnitAdmins.UserTypeID = 3
					WHERE  U.NotifyUnitAdmin = 1
		UNION ALL 
		SELECT tblOrgAdmins.username, U.UserID, tblOrgAdmins.Email ,tblOrgAdmins.FirstName, tblOrgAdmins.LastName
		FROM  tblUser U  
					INNER JOIN  dbo.tblUser AS tblOrgAdmins ON U.OrganisationID = tblOrgAdmins.OrganisationID
					WHERE  U.NotifyOrgAdmin = 1 AND tblOrgAdmins.UserTypeID = 2
		UNION ALL
		SELECT ''DelinquencyManager'' as username, tblUserDelinquencyManager.UserID, tblUserDelinquencyManager.DelinquencyManagerEmail,'' '' AS FirstName, '' '' AS LastName
		FROM  dbo.tblUser AS tblUserDelinquencyManager WHERE  NotifyMgr = 1 and tblUserDelinquencyManager.Email IS NOT NULL AND (tblUserDelinquencyManager.Email != '''')
	) UsersManagers ON UsersManagers.UserID = UL.UserID

)


--select * from ManagersToNotify
--select * from ManagersToNotifyList




SELECT l.ManagerEmail,
-- Recipient Email Address
l.ManagerEmail as RecipientEmail,

-- Sender Email Address
l.ManagerEmail as SenderEmail,

-- Subject
(select   REPLACE(
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Overdue_Summary_Subject'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Overdue_Summary_Subject''))),''%APP_NAME%'',(SELECT Value FROM tblAppConfig where Name = ''AppName''))) as Subject,



-- Header
(
select REPLACE(
(
select REPLACE(
(
select REPLACE(
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Overdue_Summary_Header'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Overdue_Summary_Header_Individual'')))
,''%APP_NAME%'',
(SELECT Value FROM tblAppConfig where Name = ''AppName'')
)
)
,''%FirstName%'', COALESCE(FirstName,'''') 
)
)
,''%LastName%'', COALESCE(LastName,'''') 
)
)


--delinquent
+ ''<BR>'' +''<B>''+ uFirstname +'' ''+uLastname+''</B>''+''&nbsp;&nbsp;''   + DelinquentCourse+ ''<BR>''

--Email Sig
+     (select REPLACE(
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Overdue_Summary_Sig'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Overdue_Summary_Sig'')))+ ''<BR>''  ,''%APP_NAME%'',(SELECT Value FROM tblAppConfig where Name = ''AppName''))) as Body
, -- Sender"On Behalf Of" Email Address
(SELECT dbo.udfGetEmailOnBehalfOf (@OrganisationID))  as OnBehalfOfEmail,



*

FROM
ManagersToNotifyList l

join (select max(s.numb) numb ,ManagerEmail,ManagerName,UserName from ManagersToNotifyList s group by ManagerEmail,ManagerName,UserName)m on m.ManagerEmail = l.ManagerEmail and m.numb = l.numb and m.UserName = l.UserName and m.ManagerName = l.ManagerName
ORDER BY l.numb DESC


--set flag to indicate delinquency note has been sent
UPDATE tblUserCourseDetails SET LastDelNoteToMgr  = 1
from tblUserCourseDetails
join (
SELECT U.userID , C.CourseID
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblUserCourseDetails UCD ON (UCD.UserID = u.UserID AND UCD.CourseID = C.CourseID)
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID)  AND (RemEsc.IndividualNotification=1) AND (RemEsc.NotifyMgr = 1)
where (coursestatusid = 1) 
AND (o.OrganisationID = @OrganisationID) 
AND (GETUTCDATE() > DATEADD(d,RemEsc.DaysToCompleteCourse+1, CS.DateCreated)) -- Is Overdue
AND (U.active = 1) 
AND (UCD.LastDelNoteToMgr = 0)
AND (GETUTCDATE() < DATEADD(m,6,DATEADD(d,RemEsc.DaysToCompleteCourse, CS.DateCreated))) -- Business Rule = If Course is more than 6 months overdue stop notifying managers
) a on a.userid = tblUserCourseDetails.UserID and a.CourseID = tblUserCourseDetails.CourseID


-- ReminderEscalations are logically grouped by the number of days that the reminders are sent
-- update the "Date last notified" field on the Reminder Escalation for all records that were notified this time.
UPDATE tblReminderEscalation SET LastNotified  = dbo.udfGetSaltOrgMidnight(OrgId)
from tblReminderEscalation
join (
SELECT o.OrganisationID , C.CourseID
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblUserCourseDetails UCD ON (UCD.UserID = u.UserID AND UCD.CourseID = C.CourseID)
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID)  AND (RemEsc.IndividualNotification=1) AND (RemEsc.NotifyMgr = 1)
where (coursestatusid = 1) 
AND (o.OrganisationID = @OrganisationID) 
AND (GETUTCDATE() > DATEADD(d,RemEsc.DaysToCompleteCourse+1, CS.DateCreated)) -- Is Overdue
AND (U.active = 1) 
AND (UCD.LastDelNoteToMgr = 0)
AND (GETUTCDATE() < DATEADD(m,6,DATEADD(d,RemEsc.DaysToCompleteCourse, CS.DateCreated))) -- Business Rule = If Course is more than 6 months overdue stop notifying managers
) a on a.OrganisationID = tblReminderEscalation.OrgId and a.CourseID = tblReminderEscalation.CourseID

END
' 
END
GO






IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcAutomatedEmails_UsersToNotify]') AND type in (N'P', N'PC'))
DROP PROCEDURE [prcAutomatedEmails_UsersToNotify]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcAutomatedEmails_UsersToNotify]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcAutomatedEmails_UsersToNotify]
(
@OrganisationID int
)


AS

BEGIN

declare @OrgMidnight datetime

set @OrgMidnight =  DATEADD(d,-1,dbo.udfGetSaltOrgMidnight(@OrganisationID))



--                    H O U S E K E E P I N G
--tblUserCourseDetails contains information on notifications about courses that have ''at risk'' quizes
--add any new courses
INSERT INTO tblUserCourseDetails (UserID,CourseID,UserCourseStatusID,NumberOfDelinquencyNotifications, NewStarterFlag, AtRiskQuizList, NotifiedModuleList, LastDelinquencyNotification)

select U.UserID,CS.CourseID,MaxUserCourseStatusID,0,null,'''','''',null
FROM  tblUser U inner join  tblUserCourseStatus CS on U.UserID = CS.UserID  INNER JOIN
(SELECT MAX(UserCourseStatusID) AS MaxUserCourseStatusID, UserID, CourseID
FROM   dbo.tblUserCourseStatus
GROUP BY UserID, CourseID) tUCS ON CS.UserCourseStatusID = tUCS.MaxUserCourseStatusID
LEFT JOIN tblUserCourseDetails currentStatus ON tUCS.UserID = currentStatus.UserID and tUCS.CourseID = currentStatus.CourseID
where CS.CourseStatusID in (1,2) and currentStatus.UserID is null and currentStatus.CourseID is null and U.OrganisationID = @OrganisationID





--remove data on courses that are now unassigned
DELETE FROM tblUserCourseDetails WHERE UserCourseStatusID IN
(

SELECT tCCS.UserCourseStatusID FROM  
   (SELECT MAX(UserCourseStatusID) AS MaxUserCourseStatusID, UserID, CourseID
   FROM   dbo.tblUserCourseStatus
   GROUP BY UserID, CourseID) currentStatus 
INNER JOIN tblUserCourseStatus tCCS on tCCS.UserCourseStatusID = currentstatus.MaxUserCourseStatusID and tCCS.CourseStatusID = 0 
INNER JOIN tblUser U on U.UserID = tCCS.UserID and  U.OrganisationID = @OrganisationID



)








--                    S E L E C T    T H E    R E S U L T S

--declare @OrganisationID int
--set @OrganisationID = 68

create table #UsersToNotify
(userid int not null
,NewContent nvarchar(max) null
,PassedCourses nvarchar(max) null
,PassedModules nvarchar(max) null
,AtRiskContent nvarchar(max) null
,AtRiskOfdelinquency nvarchar(max) null)



insert into #UsersToNotify
SELECT distinct UsersToNotify.userid , UsersToNotify.NewContent , PassedCourses, PassedModules ,AtRiskContent,AtRiskOfdelinquency FROM
(

SELECT '''' as UserCourseStatusID, tblExpiredNewContent.UserID , tblCourse.Name + '' - ''+ tblModule.Name as NewContent , '''' as PassedCourses ,'''' as PassedModules , '''' as AtRiskContent, '''' as AtRiskOfdelinquency
FROM  tblExpiredNewContent INNER JOIN
tblModule ON tblExpiredNewContent.ModuleID = tblModule.ModuleID INNER JOIN
tblCourse ON tblModule.CourseID = tblCourse.CourseID
WHERE tblExpiredNewContent.organisationID = @OrganisationID



-- users with passed courses
UNION all SELECT '''' as UserCourseStatusID, CS.userid , '''' as NewContent,''   ''+ C.Name as PassedCourses,'''' as PassedModules, '''' as AtRiskContent, '''' as AtRiskOfdelinquency
FROM tblUserCourseStatus CS
inner join tblUser U ON U.UserID = CS.UserID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
where U.OrganisationID = @OrganisationID and CS.CourseStatusID=2 and DATEDIFF(d,CS.DateCreated,@OrgMidnight) < 1


-- users with passed modules
UNION all SELECT '''' as UserCourseStatusID, QuizStatus.userid ,
'''' as NewContent, '''' as PassedCourses,
''   ''+c.name  + '' - '' + m.name as PassedModules, '''' as AtRiskContent,
'''' as AtRiskOfdelinquency
from
tblUserQuizStatus QuizStatus
join tblUser  u on u.UserID = QuizStatus.UserID and u.OrganisationID = @OrganisationID
inner join tblModule m on m.ModuleID = QuizStatus.ModuleID
join tblCourse c on c.CourseID = m.CourseID
inner join
(
select
max(UserQuizStatusID) UserQuizStatusID, uqs.UserID, uqs.ModuleID --UserQuizStatusID is identity
from
tblUserQuizStatus uqs
join tblUser  u on u.UserID = uqs.UserID
WHERE DATEDIFF(d,uqs.DateCreated,@OrgMidnight) < 1
and u.OrganisationID = @OrganisationID
group by
uqs.UserID,moduleID
) currentStatus
on QuizStatus.UserQuizStatusID = currentStatus.UserQuizStatusID
where m.active = 1
and QuizStatusID =2




-- users with quizes at risk ( N O R M A L    R U L E S )
UNION all SELECT DISTINCT '''' as UserCourseStatusID, AR.userID,  '''' as NewContent , '''' as PassedCourses,'''' as PassedModules,''   ''+ C.Name as AtRiskContent, '''' as AtRiskOfdelinquency
from tblQuizExpiryAtRisk AR
INNER JOIN tblUser U On U.UserID = AR.UserID
inner join tblModule M on m.ModuleID = AR.ModuleID and m.Active = 1 and AR.OrganisationID = @OrganisationID
INNER JOIN tblCourse C ON C.CourseID = M.CourseID
where U.Active = 1 AND daysToExpiry >= 0 and Notified = 0

-- users with quizes at risk ( N O R M A L    R U L E S )
UNION all SELECT DISTINCT '''' as UserCourseStatusID, AR.userID,  '''' as NewContent , '''' as PassedCourses,'''' as PassedModules,''   ''+ C.Name +'' ( ''+M.name +'') ''                       + convert(varchar (11),DATEADD(d,daysToExpiry, dbo.udfGetSaltOrgDate(@OrganisationID) ) ,113)  as AtRiskContent, '''' as AtRiskOfdelinquency
from tblQuizExpiryAtRisk AR
INNER JOIN tblUser U On U.UserID = AR.UserID
inner join tblModule M on m.ModuleID = AR.ModuleID and m.Active = 1 and AR.OrganisationID = @OrganisationID
INNER JOIN tblCourse C ON C.CourseID = M.CourseID
where U.Active = 1 AND daysToExpiry > 0 and Notified = 0




-- users with courses at risk of delinquency (1ST WARNING)
UNION all SELECT DISTINCT CD.UserCourseStatusID as UserCourseStatusID, CS.userID ,  '''' as NewContent , '''' as PassedCourses,'''' as PassedModules, '''' as AtRiskContent,''   ''+ C.Name +'' '' + convert(varchar (11),DATEADD(d,RemEsc.DaysToCompleteCourse, dbo.udfUTCtoDaylightSavingTime(CS.DateCreated,@OrganisationID)),113)  as AtRiskOfdelinquency
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID) AND (RemindUsers=1) 
where U.Active = 1 
AND CD.LastDelinquencyNotification IS NULL 
AND coursestatusid=1 
AND o.OrganisationID = @OrganisationID 
AND (GETUTCDATE() > DATEADD(d,RemEsc.DaysToCompleteCourse-RemEsc.NumOfRemNotfy*RemEsc.RepeatRem, CS.DateCreated))
AND (RemEsc.NumOfRemNotfy > cd.NumberOfDelinquencyNotifications)
AND (GETUTCDATE() < DATEADD(m,RemEsc.DaysToCompleteCourse+6, CS.DateCreated))  -- force a hard cutoff of three days after the course expired (not in business rules but required for upgraded 4.2.1 installs so users do not get notified of courses that expired years ago)


-- users with courses at risk of delinquency (SUBSEQUENT WARNINGS)
UNION all SELECT DISTINCT CD.UserCourseStatusID as UserCourseStatusID, CS.userID ,  '''' as NewContent , '''' as PassedCourses,'''' as PassedModules, '''' as AtRiskContent,''   ''+C.Name +'' '' + convert(varchar (11),DATEADD(d,RemEsc.DaysToCompleteCourse, dbo.udfUTCtoDaylightSavingTime(CS.DateCreated,@OrganisationID)),113)  as AtRiskOfdelinquency
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID) AND (RemindUsers=1) 
where  U.Active = 1 AND coursestatusid=1 AND o.OrganisationID = @OrganisationID AND CD.LastDelinquencyNotification IS NOT NULL 
AND (RemEsc.NumOfRemNotfy > cd.NumberOfDelinquencyNotifications) 
AND (GETUTCDATE() > DATEADD(d,RemEsc.RepeatRem, CD.LastDelinquencyNotification))
AND (GETUTCDATE() < DATEADD(m,RemEsc.DaysToCompleteCourse+6, CS.DateCreated))  -- force a hard cutoff of three days after the course expired (not in business rules but required for upgraded 4.2.1 installs so users do not get notified of courses that expired years ago)
) UsersToNotify


create index in_1 on #UsersToNotify(userid)



create table #UsersToNotifyList
(userid int not null
,NewContent nvarchar(max) null
,PassedCourses nvarchar(max) null
,PassedModules nvarchar(max) null
,AtRiskContent nvarchar(max) null
,AtRiskOfdelinquency nvarchar(max) null)

create index in_2 on #UsersToNotifyList(userid)

declare @userid int
,@NewContent nvarchar(max)
,@PassedCourses nvarchar(max)
,@PassedModules nvarchar(max)
,@AtRiskContent nvarchar(max)
,@AtRiskOfdelinquency nvarchar(max)

while exists (select 1 from #UsersToNotify)
begin
set rowcount 1
select @userid = userid
,@NewContent = NewContent
, @PassedCourses = PassedCourses
,@PassedModules = PassedModules
,@AtRiskContent = AtRiskContent
,@AtRiskOfdelinquency = AtRiskOfdelinquency

from #UsersToNotify
if exists (select * from #UsersToNotifyList where userid = @userid)
begin
update #UsersToNotifyList set
NewContent = rtrim(CAST(#UsersToNotifyList.NewContent + (case when #UsersToNotifyList.NewContent = '''' or @NewContent = '''' then '''' else ''<BR>'' end ) + (case when @NewContent ='''' then '''' else ''&nbsp;&nbsp;'' end) +@NewContent AS NVARCHAR(max)))
, PassedCourses = rtrim(CAST(#UsersToNotifyList.PassedCourses + (case when #UsersToNotifyList.PassedCourses = '''' or @PassedCourses = '''' then '''' else ''<BR>'' end)+ (case when @PassedCourses ='''' then '''' else ''&nbsp;&nbsp;'' end) + @PassedCourses AS NVARCHAR(max)))
,PassedModules = rtrim(CAST(#UsersToNotifyList.PassedModules + (case when #UsersToNotifyList.PassedModules = '''' or @PassedModules = '''' then '''' else ''<BR>'' end)+ (case when @PassedModules ='''' then '''' else ''&nbsp;&nbsp;'' end) + @PassedModules AS NVARCHAR(max)))
,AtRiskContent = rtrim(CAST(#UsersToNotifyList.AtRiskContent + (case when #UsersToNotifyList.AtRiskContent = '''' or @AtRiskContent = '''' then '''' else ''<BR>'' end)+ (case when @AtRiskContent ='''' then '''' else ''&nbsp;&nbsp;'' end) + @AtRiskContent AS NVARCHAR(max)))
,AtRiskOfdelinquency = rtrim(CAST(#UsersToNotifyList.AtRiskOfdelinquency + (case when #UsersToNotifyList.AtRiskOfdelinquency = '''' or @AtRiskOfdelinquency = '''' then '''' else ''<BR>'' end)+ (case when @AtRiskOfdelinquency ='''' then '''' else ''&nbsp;&nbsp;'' end) + @AtRiskOfdelinquency AS NVARCHAR(max)))
from #UsersToNotifyList
where #UsersToNotifyList.userid = @userid
end
else
begin
insert #UsersToNotifyList(userid,NewContent,PassedCourses,PassedModules,AtRiskContent,AtRiskOfdelinquency)
values (@userid,@NewContent,@PassedCourses,@PassedModules,@AtRiskContent,@AtRiskOfdelinquency)

end
delete #UsersToNotify where
@userid = userid
and @NewContent = NewContent
and  @PassedCourses = PassedCourses
and  @PassedModules = PassedModules
and @AtRiskContent = AtRiskContent
and  @AtRiskOfdelinquency = AtRiskOfdelinquency
set rowcount 0
end



SELECT l.UserID,
-- Recipient Email Address
(SELECT Email FROM tblUser WHERE UserID = l.UserID) as RecipientEmail,

-- Sender Email Address
(SELECT dbo.udfUser_GetAdministratorsEmailAddress (l.UserID)) as SenderEmail,

-- Subject
(select REPLACE(
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_Subject'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_Subject''))),''%APP_NAME%'',(SELECT Value FROM tblAppConfig where Name = ''AppName''))) as Subject,



-- Header
(select coalesce((select REPLACE(
	(select REPLACE(
		(select REPLACE(
			(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_Header'')
			,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_Header'')))
		,''%APP_NAME%'',(SELECT Value FROM tblAppConfig where Name = ''AppName'')))
	,''%FirstName%'',(SELECT COALESCE(FirstName,'''') FROM tblUser WHERE UserID = l.UserID)))
,''%LastName%'',(SELECT COALESCE(LastName,'''') FROM tblUser WHERE UserID = l.UserID))),''header error''))


--New Content
+ (select coalesce(case when NewContent = '''' then '''' else
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_ExpiredContent'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_ExpiredContent'')))+''&nbsp;&nbsp;''+NewContent+ ''<BR>'' end,''error reading Student_Summary_ExpiredContent''))

--Passed Courses
+ (select coalesce(case when PassedCourses = '''' then '''' else
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_PassedCourses'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_PassedCourses'')))+''&nbsp;&nbsp;''+PassedCourses+ ''<BR>'' end,''error reading Student_Summary_PassedCourses''))

--Passed Modules
+ (select coalesce(case when PassedModules = '''' then '''' else
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_PassedModules'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_PassedModules'')))+''&nbsp;&nbsp;''+PassedModules+ ''<BR>'' end,''error reading Student_Summary_PassedModules''))

--AtRiskContent
+ (select coalesce(case when AtRiskContent = '''' then '''' else
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_AtRiskOfExpiry'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_AtRiskOfExpiry'')))+''&nbsp;&nbsp;''+AtRiskContent+ ''<BR>'' end,''error reading Student_Summary_AtRiskOfExpiry''))

--AtRiskOfdelinquency
+ (select coalesce(case when AtRiskOfdelinquency = '''' then '''' else
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_AtRiskOfBeingOverdue'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_AtRiskOfBeingOverdue'')))+''&nbsp;&nbsp;''+AtRiskOfdelinquency+ ''<BR>'' end,''error reading Student_Summary_AtRiskOfBeingOverdue''))

--Email Sig
+     (select REPLACE(
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_Sig'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_Sig'')))+ ''<BR>''  ,''%APP_NAME%'',(SELECT Value FROM tblAppConfig where Name = ''AppName''))) as Body
, -- Sender"On Behalf Of" Email Address
(SELECT dbo.udfUser_GetAdministratorsOnBehalfOfEmailAddress (l.UserID))  as OnBehalfOfEmail,


*

FROM
#UsersToNotifyList l




--                    H O U S E K E E P I N G  (tidy up for tomorrow)

-- Update record of "at risk of Delinquency" notifications
-- Update tblUserCourseDetails.LastDelinquencyNotification
UPDATE tblUserCourseDetails  SET LastDelinquencyNotification = GETUTCDATE()
WHERE  UserCourseStatusID in (-- users with courses at risk of delinquency (1ST WARNING)
SELECT DISTINCT CD.UserCourseStatusID
--FROM tblUserCourseStatus CS
--INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
--INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
--INNER JOIN tblUser U On U.UserID = CS.UserID
--INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID where  CD.LastDelinquencyNotification IS NULL AND coursestatusid=1 AND o.OrganisationID = @OrganisationID AND (DATEADD(d,o.DelinquencyPeriod, CS.DateCreated) > GETUTCDATE()) AND (O.NumberOfReminders > cd.NumberOfDelinquencyNotifications)
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID) AND (RemindUsers=1) 
where U.Active = 1 
AND CD.LastDelinquencyNotification IS NULL 
AND coursestatusid=1 
AND o.OrganisationID = @OrganisationID 
AND (GETUTCDATE() > DATEADD(d,RemEsc.DaysToCompleteCourse-RemEsc.NumOfRemNotfy*RemEsc.RepeatRem, CS.DateCreated))
AND (RemEsc.NumOfRemNotfy > cd.NumberOfDelinquencyNotifications)

)

UPDATE tblUserCourseDetails  SET LastDelinquencyNotification = GETUTCDATE(), NumberOfDelinquencyNotifications = NumberOfDelinquencyNotifications + 1
WHERE  UserCourseStatusID in (-- users with courses at risk of delinquency (SUBSEQUENT WARNINGS)
SELECT DISTINCT CD.UserCourseStatusID
--FROM tblUserCourseStatus CS
--INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
--INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
--INNER JOIN tblUser U On U.UserID = CS.UserID
--INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID where  coursestatusid=1 AND o.OrganisationID = @OrganisationID AND CD.LastDelinquencyNotification IS NOT NULL AND (O.NumberOfReminders > cd.NumberOfDelinquencyNotifications) AND ( DATEADD(D,O.DelinquencyReminderPeriod, CD.LastDelinquencyNotification) > GETUTCDATE())
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID) AND (RemindUsers=1) 
where  U.Active = 1 AND coursestatusid=1 AND o.OrganisationID = @OrganisationID AND CD.LastDelinquencyNotification IS NOT NULL 
AND (RemEsc.NumOfRemNotfy > cd.NumberOfDelinquencyNotifications) 
AND (GETUTCDATE() > DATEADD(d,RemEsc.RepeatRem, CD.LastDelinquencyNotification))

)

/*-- Update Record of notified NEW Modules
UPDATE tblUserCourseDetails  SET NotifiedModuleList =  ModulesAssigned  from
(SELECT UserCourseStatusID, ModulesAssigned
FROM (select tUCS.ModulesAssigned, tUCS.CourseID,tUCS.CourseStatusID,tUCS.UserCourseStatusID as UCSUserCourseStatusID
FROM  tblUser U inner join tblUserCourseStatus tUCS ON U.UserID = tUCS.UserID and U.OrganisationID = 9   INNER JOIN

(SELECT MAX(UserCourseStatusID) AS MaxUserCourseStatusID
FROM   dbo.tblUserCourseStatus
GROUP BY UserID, CourseID) AS currentStatus ON tUCS.UserCourseStatusID = currentStatus.MaxUserCourseStatusID) CS
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
Inner join tblUserCourseDetails CD on  CD.UserCourseStatusID = CS.UCSUserCourseStatusID
and  CS.CourseStatusID=1
) temp
where tblUserCourseDetails.UserCourseStatusID = temp.UserCourseStatusID*/


DELETE FROM tblExpiredNewContent WHERE organisationID = @OrganisationID



-- Update record of notified "At Risk Quizes"
-- users with quizes at risk ( N O R M A L    R U L E S )
update tblQuizExpiryAtRisk SET Notified = 1 WHERE organisationID = @OrganisationID and Notified = 0


if OBJECT_ID(''#UsersToNotifyList'') is not null
begin
drop table #UsersToNotifyList
end

if  OBJECT_ID(''#UsersToNotify'')is not null
begin
drop table #UsersToNotify
END

END
' 
END
GO




IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcGetReminderEscalations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcGetReminderEscalations]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcGetReminderEscalations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[prcGetReminderEscalations]
(
	@orgID int
)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON

	select 
		re.RemEscId,
		re.CourseId,
		c.Name as CourseName,
		case when re.RemindUsers= 1 then ''Yes'' else ''No'' end as RemindUsers,
		re.NumOfRemNotfy,
		re.RepeatRem,
		case when re.NotifyMgr = 1 then ''Yes'' else ''No'' end as NotifyMgr,
		case when re.IsCumulative = 1 then ''Yes'' else ''No'' end as  IsCumulative,
		re.NotifyMgrDays,
		case when re.QuizExpiryWarn =1 then ''Yes'' else ''No'' end as QuizExpiryWarn,
		re.DaysQuizExpiry
	from
		tblReminderEscalation re
			join tblCourse c on c.CourseID = re.CourseId and c.Active = 1
			inner Join tblOrganisationCourseAccess oca	on oca.GrantedCourseID = c.CourseID
				and oca.organisationID = @orgID
	where 
		OrgId = @orgID
    
END
' 
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcEscalationConfigForCourse_Update]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcEscalationConfigForCourse_Update]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcEscalationConfigForCourse_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[prcEscalationConfigForCourse_Update]
(
	@remEscID int = -1,
	@orgID int ,
	@courseID int  = -1,
	@updateOption int =-1,
	@DaysToCompleteCourse int,
	@RemindUsers bit=0,
	@NumOfRemNotfy int =-1,
	@RepeatRem int =-1,
	@NotifyMgr bit =0,
	@IndividualNotification bit =0,
	@IsCumulative bit =0,
	@NotifyMgrDays int=-1,
	@QuizExpiryWarn bit =0,
	@DaysQuizExpiry int =-1	
)
AS
BEGIN
	
	if @updateOption =0 and @remEscID >0
	begin
		--update for one course 
		update 
			tblReminderEscalation
		set 
			DaysToCompleteCourse = @DaysToCompleteCourse,
			RemindUsers = @RemindUsers,
			NumOfRemNotfy = @NumOfRemNotfy,
			RepeatRem = @RepeatRem,
			NotifyMgr = @NotifyMgr,
			IndividualNotification = @IndividualNotification,
			IsCumulative = @IsCumulative,
			NotifyMgrDays = @NotifyMgrDays,
			QuizExpiryWarn = @QuizExpiryWarn,
			DaysQuizExpiry = @DaysQuizExpiry			
		where
			OrgId =@orgID
			and CourseId = @courseID
	end	
	else if @updateOption =0 and @remEscID =-1
	begin 
		
		if not exists (select * from tblReminderEscalation where OrgId = @orgID and CourseId = @courseID)
		begin
			
			insert into tblReminderEscalation (
				OrgId,
				CourseId,
				DaysToCompleteCourse,
				RemindUsers,
				NumOfRemNotfy,
				RepeatRem,
				NotifyMgr,
				IndividualNotification,
				IsCumulative,
				NotifyMgrDays,
				QuizExpiryWarn,
				DaysQuizExpiry )
			values(
				@orgID,
				@courseID,
				@DaysToCompleteCourse,
				@RemindUsers,
				@NumOfRemNotfy,
				@RepeatRem,
				@NotifyMgr,
				@IndividualNotification,
				@IsCumulative,
				@NotifyMgrDays,
				@QuizExpiryWarn,
				@DaysQuizExpiry
				)
		end
			
	end
	else if @updateOption =1 begin
		--update configured 
		update 
			tblReminderEscalation
		set
			DaysToCompleteCourse = @DaysToCompleteCourse,
			RemindUsers = @RemindUsers,
			NumOfRemNotfy = @NumOfRemNotfy,
			RepeatRem = @RepeatRem,
			NotifyMgr = @NotifyMgr,
			IndividualNotification = @IndividualNotification,
			IsCumulative = @IsCumulative,
			NotifyMgrDays = @NotifyMgrDays,
			QuizExpiryWarn = @QuizExpiryWarn,
			DaysQuizExpiry = @DaysQuizExpiry
		where 
			OrgId =@orgID
	END
	
	-- this will get done for both options 1 and 2
	if @updateOption >0
	begin
		-- all unconfigured
		insert into tblReminderEscalation (
			OrgId,
			CourseId,
			DaysToCompleteCourse,
			RemindUsers,
			NumOfRemNotfy,
			RepeatRem,
			NotifyMgr,
			IndividualNotification,
			IsCumulative,
			NotifyMgrDays,
			QuizExpiryWarn,
			DaysQuizExpiry )
		select				
			oca.OrganisationID,
			oca.GrantedCourseID,
			@DaysToCompleteCourse,
			@RemindUsers,
			@NumOfRemNotfy,
			@RepeatRem,
			@NotifyMgr,
			@IndividualNotification,
			@IsCumulative,
			@NotifyMgrDays,
			@QuizExpiryWarn,
			@DaysQuizExpiry			
		from 
			tblOrganisationCourseAccess oca
			left join tblReminderEscalation re on re.OrgId = oca.OrganisationID and oca.GrantedCourseID = re.CourseId
		where 		
			OrganisationID= @orgID
			and re.RemEscId is null
	end
	
	
	
END'
END
GO





 
if not exists (select * from tblAppConfig where Name ='Email_OnBehalfOf') begin
	insert into tblAppConfig (Name, Value) values('Email_OnBehalfOf','ENTER_ON_BEHALF_OF_EMAIL@ADDRESS.HERE')
end
GO


if not exists (select * from tblAppConfig where Name ='FromEmail ') begin
	insert into tblAppConfig (Name, Value) values('FromEmail','ENTER_FROM_EMAIL@ADDRESS.HERE')
end
GO


if not exists (select * from tblAppConfig where Name ='FromName ') begin
	insert into tblAppConfig (Name, Value) values('FromName','ENTER_FROM_NAME_HERE')
end
GO


if not exists (select * from tblAppConfig where Name ='SEND_AUTO_EMAILS') begin
	insert into tblAppConfig (Name, Value) values('SEND_AUTO_EMAILS','Yes')
end
GO


if not exists (select * from tblAppConfig where Name ='MailService_QueueMail') begin
	insert into tblAppConfig (Name, Value) values('MailService_QueueMail','Auto populated by service')
end
GO

if not exists (select * from tblAppConfig where Name ='MailService_QueueReports ') begin
	insert into tblAppConfig (Name, Value) values('MailService_QueueReports','Auto populated by service')
end
GO

if not exists (select * from tblAppConfig where Name ='MailService_SendMail ') begin
	insert into tblAppConfig (Name, Value) values('MailService_SendMail','Auto populated by service')
end
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfReport_IndividualDetailsExtended]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [udfReport_IndividualDetailsExtended]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfReport_IndividualDetailsExtended]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
/****** Object:  User Defined Function dbo.udfReport_IndividualDetails    Script Date: 20/04/2004 8:25:58 AM ******/



/*Summary:
Given a users ID this udfReport_IndividualDetails Gets Details for home page and individual report
Returns:
ordered table of distinct PageID''s

Called By:
dbo.prcModule_GetDetailsForHomePage
Calls:

dbo.udfGetLessonStatus
dbo.vwUserModuleAccess
Remarks:
1. This udf required that the schema of the underlying views does not change

Author:
Stephen Kennedy-Clark
Date Created: 17 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#3.0.25 Aaron Cripps	08/05/2007		Replace vwUserCourseStatus with a select statement that filters on UserID parameter passed into the function to reduce the number of rows returned (and the time taken to retrieve rows)


--------------------


**/
CREATE function [udfReport_IndividualDetailsExtended]
(
@userID  int = null,     -- ID of this User
@CurrentCultureName NVarChar(40) = ''en-AU''
)
------------------------------------------
Returns table
as
	




Return
select
vUMA.UserID		as ''UserID''
, vUMA.CourseID		as ''CourseID''
, vUMA.CourseName 	as ''CourseName''
, vUMA.ModuleID		as ''ModuleID''
, vUMA.[Name] 		as ''ModuleName''
, tL.LessonID	  	as ''LessonID''
, isNull(dbo.udfGetLessonStatus(vUMA.ModuleID,vUMA.UserID), 1) as ''LessonStatus''  -- n^2 complexety :-(
, isNull(vUQS.QuizStatusID, 1)   as ''QuizStatus''
, vUQS.QuizScore	as ''QuizScore''
, vUQS.QuizPassMark	as ''QuizPassMark''
, replace(replace( tL.ToolbookLocation,''ie4/index.html'',''qfs.html''),''default.aspx'',''QFS.html'') as ''QFSPath''
--, SUBSTRING(  tL.ToolbookLocation,0,(len(tL.ToolbookLocation)-12)  ) + ''/'' + ''QFS.html'' as ''QFSPath''
, vUMA.Sequence		as ''Sequence''


,case when vUQS.DateCreated is null and (RemEsc.DaysToCompleteCourse is null OR ((RemEsc.NotifyMgr = 0) AND (RemEsc.RemindUsers = 0))) then '' --- ''																																																	-- course just added , overdue not defined
when vUQS.DateCreated is null and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and CS.DateCreated is null then CAST(RemEsc.DaysToCompleteCourse AS VARCHAR(5)	)																-- course just added , overnight job has not caught up yet
when QuizStatusID = 1 and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and vUQS.DateCreated is not null	 AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate())) >= 0
							then CAST(RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate()) AS VARCHAR(5))							 																											-- not started , overdue is defined, not overdue
							+ (SELECT  '' ''+LangEntryValue  FROM tblLangValue
								where LangInterfaceID = (SELECT  LangInterfaceID   FROM tblLangInterface WHERE LangInterfaceName = ''GLOBAL.MISC'')
								and LangID =(SELECT LangID FROM tblLang where tblLang.LangCode=  @CurrentCultureName)
								and LangResourceID = (SELECT LangResourceID  FROM tblLangResource where   LangResourceName = ''days'' ))  
when QuizStatusID = 1 and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1))  and vUQS.DateCreated is not null	 AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate())) < 0
																	then convert(varchar (11),DATEADD(day,RemEsc.DaysToCompleteCourse,dbo.udfUTCtoDaylightSavingTime(vUQS.DateCreated,o.organisationID)),113)							-- not started , overdue is defined, overdue
when QuizStatusID = 4 and vUQS.DateCreated is not null	 
																	then convert(varchar (11),dbo.udfUTCtoDaylightSavingTime(vUQS.DateCreated,o.organisationID),113)																											-- Expired (Time Elapsed )
when QuizStatusID = 5 and vUQS.DateCreated is not null	 
																	then convert(varchar (11),dbo.udfUTCtoDaylightSavingTime(vUQS.DateCreated,o.organisationID),113)																																																		-- Expired (New Content)
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is  null   and o.DefaultQuizCompletionDate is not null 
																	then convert(varchar (11),dbo.udfUserUTCtoDaylightSavingTime(o.DefaultQuizCompletionDate,o.organisationID),113)																																													--Passed  organisation Default  Quiz Completion Date specified
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is not null 
																	then convert(varchar (11),dbo.udfUserUTCtoDaylightSavingTime(ur.QuizCompletionDate,o.organisationID),113)																																																--Passed  unit Default  Quiz Completion Date specified
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizFrequency is not null 
																	then CAST((  DATEDIFF(day,getUTCdate(),DATEADD(month,o.DefaultQuizFrequency,vUQS.DateCreated))) AS varchar(6))							 																					--Passed  organisation Default  Quiz frequency specified
																	+ (SELECT  '' ''+ LangEntryValue  FROM tblLangValue
																		where LangInterfaceID = (SELECT  LangInterfaceID   FROM tblLangInterface WHERE LangInterfaceName = ''GLOBAL.MISC'')
																		and LangID =(SELECT LangID FROM tblLang where tblLang.LangCode=  @CurrentCultureName)
																		and LangResourceID = (SELECT LangResourceID  FROM tblLangResource where   LangResourceName = ''days'' ))
																	
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is not null and o.DefaultQuizCompletionDate is null 
																	then CAST((ur.QuizFrequency - DATEDIFF(day,vUQS.DateCreated,getUTCdate())) AS varchar(6))																															--Passed - unit Default  Quiz frequency specified
																   + (SELECT  '' ''+LangEntryValue  FROM tblLangValue
																	where LangInterfaceID = (SELECT  LangInterfaceID   FROM tblLangInterface WHERE LangInterfaceName = ''GLOBAL.MISC'')
																	and LangID =(SELECT LangID FROM tblLang where tblLang.LangCode=  @CurrentCultureName)
																	and LangResourceID = (SELECT LangResourceID  FROM tblLangResource where   LangResourceName = ''days'' ))
																	
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizCompletionDate is not null 
																	then convert(varchar (11),dbo.udfUserUTCtoDaylightSavingTime(o.DefaultQuizCompletionDate,o.organisationID),113)																																													--Failed - previously passed - organisation Default  Quiz Completion Date specified
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is not null 
																	then convert(varchar (11),dbo.udfUserUTCtoDaylightSavingTime(ur.QuizCompletionDate,o.organisationID),113)																							--Failed - previously passed - unit Default  Quiz Completion Date specified
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizFrequency is not null 
																	then CAST(( DATEDIFF(day,getUTCdate(),DATEADD(month,o.DefaultQuizFrequency,vUQS.DateCreated))) AS varchar(6))																												--Failed - previously passed -organisation Default  Quiz frequency specified
																	+ (SELECT  '' ''+LangEntryValue  FROM tblLangValue
																		where LangInterfaceID = (SELECT  LangInterfaceID   FROM tblLangInterface WHERE LangInterfaceName = ''GLOBAL.MISC'')
																		and LangID =(SELECT LangID FROM tblLang where tblLang.LangCode=  @CurrentCultureName)
																		and LangResourceID = (SELECT LangResourceID  FROM tblLangResource where   LangResourceName = ''days'' ))
																	
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is not null 
																	then CAST((ur.QuizFrequency - DATEDIFF(day,vUQS.DateCreated,getUTCdate())) AS varchar(6))																															--Failed - previously passed -unit Default  Quiz frequency specified
																	+ (SELECT  '' ''+LangEntryValue  FROM tblLangValue
																		where LangInterfaceID = (SELECT  LangInterfaceID   FROM tblLangInterface WHERE LangInterfaceName = ''GLOBAL.MISC'')
																		and LangID =(SELECT LangID FROM tblLang where tblLang.LangCode=  @CurrentCultureName)
																		and LangResourceID = (SELECT LangResourceID  FROM tblLangResource where   LangResourceName = ''days'' ))
																	
when QuizStatusID = 3 and LC.DateCreated is null and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and vUQS.DateCreated is not null	 AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate())) >= 0
																	then CAST(RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate()) AS VARCHAR(5))																								--Failed - not previously passed , overdue is defined, not overdue
																	+ (SELECT  '' ''+LangEntryValue  FROM tblLangValue
																		where LangInterfaceID = (SELECT  LangInterfaceID   FROM tblLangInterface WHERE LangInterfaceName = ''GLOBAL.MISC'')
																		and LangID =(SELECT LangID FROM tblLang where tblLang.LangCode=  @CurrentCultureName)
																		and LangResourceID = (SELECT LangResourceID  FROM tblLangResource where   LangResourceName = ''days'' ))
																	
when QuizStatusID = 3 and LC.DateCreated is null and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and vUQS.DateCreated is not null	 AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate())) < 0
																	then convert(varchar (11),DATEADD(day,RemEsc.DaysToCompleteCourse,dbo.udfUTCtoDaylightSavingTime(vUQS.DateCreated,o.organisationID)),113)							--Failed - not previously passed , overdue is defined, overdue



end
as QuizExpiryDate
,case
when LC.DateCreated is null then '' ''
else convert(varchar (11),dbo.udfUTCtoDaylightSavingTime(LC.DateCreated,o.organisationID),113) 
end as LastComp

,case when vUQS.DateCreated is null and (RemEsc.DaysToCompleteCourse is null OR ((RemEsc.NotifyMgr = 0) AND (RemEsc.RemindUsers = 0))) then ''0''																																																					-- course just added , overdue not defined
when vUQS.DateCreated is null and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and CS.DateCreated is null then ''0''																																										-- course just added , overnight job has not caught up yet
when QuizStatusID = 1 and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and vUQS.DateCreated is not null	 AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate())) >= 0 then ''0''		-- not started , overdue is defined, not overdue
when QuizStatusID = 1 and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and vUQS.DateCreated is not null	 AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate())) < 0 then ''1''		-- not started , overdue is defined, overdue
when QuizStatusID = 4 and vUQS.DateCreated is not null then ''1''																																																															-- Expired (Time Elapsed )
when QuizStatusID = 5 and vUQS.DateCreated is not null then ''1''																																																															-- Expired (New Content)					
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizCompletionDate is not null 
																	and DATEDIFF(day,o.DefaultQuizCompletionDate,getUTCdate()) < 0 then ''0''																																										--Passed - organisation Default  Quiz Completion Date specified , expired
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is not null 
																	and DATEDIFF(day,ur.QuizCompletionDate,getUTCdate()) < 0 then ''0''																																												--Passed - unit Default  Quiz Completion Date specified , expired
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizCompletionDate is not null 
																	and DATEDIFF(day,o.DefaultQuizCompletionDate,getUTCdate()) >= 0 then ''1''																																									--Passed - organisation Default  Quiz Completion Date specified , not expired
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is not null  
																	and DATEDIFF(day,ur.QuizCompletionDate,getUTCdate()) >= 0 then ''1''																																												--Passed - unit Default  Quiz Completion Date specified , not expired
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizFrequency is not null 
																	and DATEDIFF(day,DATEADD(month,o.DefaultQuizFrequency,vUQS.DateCreated),getUTCdate()) >= 0 then "1"																																				--Passed - organisation Default  Quiz frequency specified
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is not null 
																	and DATEDIFF(day,vUQS.DateCreated,getUTCdate()) >= ur.QuizFrequency then "1"																																							--Passed - unit Default  Quiz frequency specified
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizFrequency is not null 
																	and DATEDIFF(day,DATEADD(month,o.DefaultQuizFrequency,vUQS.DateCreated),getUTCdate()) < 0 then "0"																																					--Passed - organisation Default  Quiz frequency specified , not expired
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is not null 
																	and DATEDIFF(day,vUQS.DateCreated,getUTCdate()) < ur.QuizFrequency  then "0"																																							--Passed - unit Default  Quiz frequency specified , not expired


when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizCompletionDate is not null 
																	and DATEDIFF(day,o.DefaultQuizCompletionDate,getUTCdate()) < 0 then ''0''																																										--failed - previously passed - organisation Default  Quiz Completion Date specified , expired
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is not null 
																	and DATEDIFF(day,ur.QuizCompletionDate,getUTCdate()) < 0 then ''0''																																												--failed - previously passed - unit Default  Quiz Completion Date specified , expired
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizCompletionDate is not null 
																	and DATEDIFF(day,o.DefaultQuizCompletionDate,getUTCdate()) >= 0 then ''1''																																									--failed - previously passed - organisation Default  Quiz Completion Date specified , not expired
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is not null 
																	and DATEDIFF(day,ur.QuizCompletionDate,getUTCdate()) >= 0 then ''1''																																												--failed - previously passed - unit Default  Quiz Completion Date specified , not expired
when QuizStatusID = 3 and LC.DateCreated is not null  and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizFrequency is not null 
																	and DATEDIFF(day,DATEADD(month,o.DefaultQuizFrequency,vUQS.DateCreated),getUTCdate()) >= 0 then "1"																																				--failed - previously passed - organisation Default  Quiz frequency specified
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is not null  
																	and DATEDIFF(day,vUQS.DateCreated,getUTCdate()) >= ur.QuizFrequency then "1"																																							--failed - previously passed - unit Default  Quiz frequency specified
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizFrequency is not null 
																	and DATEDIFF(day,DATEADD(month,o.DefaultQuizFrequency,vUQS.DateCreated),getUTCdate()) < 0 then "0"																																					--failed - previously passed - organisation Default  Quiz frequency specified
when QuizStatusID = 3 and LC.DateCreated is not null  and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is not null
																	and DATEDIFF(day,vUQS.DateCreated,getUTCdate()) < ur.QuizFrequency 	 then "0"																																							--failed - previously passed - unit Default  Quiz frequency specified
when QuizStatusID  = 3 and LC.DateCreated is null and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and vUQS.DateCreated is not null	 AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate())) >= 0 then ''0''		-- not started , overdue is defined, not overdue
when QuizStatusID  = 3 and LC.DateCreated is null and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and vUQS.DateCreated is not null	 AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate())) < 0 then ''1''		-- not started , overdue is defined, overdue




end AS Red
from
--< get the module access details for this user >--
vwUserModuleAccess vUMA
inner join tblOrganisation o
ON o.organisationID = vUMA.OrganisationID
--< get the module access details for this user >--
left outer join tblLesson tL
on tL.ModuleID = vUMA.ModuleID
and tL.Active = 1
--< get the details of the latest quiz  >--
left outer join

(
SELECT      QuizStatus.UserID, QuizStatus.ModuleID, m.CourseID, QuizStatus.QuizStatusID, QuizStatus.QuizPassMark, QuizStatus.QuizScore,QuizStatus.DateCreated
FROM         dbo.tblUserQuizStatus AS QuizStatus INNER JOIN
dbo.tblModule AS m ON m.ModuleID = QuizStatus.ModuleID INNER JOIN
(SELECT     MAX(UserQuizStatusID) AS UserQuizStatusID,ModuleID
FROM          dbo.tblUserQuizStatus where UserID = @UserID
GROUP BY ModuleID ) AS currentStatus ON QuizStatus.UserQuizStatusID = currentStatus.UserQuizStatusID and currentStatus.ModuleID = m.ModuleID
WHERE     (m.Active = 1) 
)

vUQS -- n^2 complexety :-(
on vUQS.UserID = vUMA.UserID
and vUQS.ModuleID = vUMA.ModuleID
left outer join tblUnitRule ur --Get the unit specific rules
on ur.ModuleID = vUQS.ModuleID
and ur.ModuleID = vUMA.ModuleID
and ur.UnitID=vUMA.unitID
left outer join tblReminderEscalation RemEsc on RemEsc.CourseId = vUMA.CourseID
and RemEsc.orgID = o.organisationID
left outer join (SELECT MIN(UserCourseStatusID) as UserCourseStatusID,[UserID] ,[CourseID] FROM tblUserCourseStatus LastAttempt where LastAttempt.UserID = @UserID and not exists (SELECT * FROM tblUserCourseStatus PreviousAttempt where PreviousAttempt.UserID = @UserID and PreviousAttempt.CourseStatusID = 0 and PreviousAttempt.UserCourseStatusID < LastAttempt.UserCourseStatusID and PreviousAttempt.CourseID = LastAttempt.CourseID and PreviousAttempt.UserID = LastAttempt.UserID) group by [UserID] ,[CourseID]
) CSID ON CSID.UserID = @UserID and CSID.courseID = vUMA.courseID
left outer join tblUserCourseStatus CS ON CS.UserID = @UserID and CS.courseID = vUMA.courseID and CS.UserCourseStatusID = CSID.UserCourseStatusID
left outer join
( -- Last Passed Module Quiz record
SELECT      QuizStatus.UserID, QuizStatus.ModuleID,QuizStatus.DateCreated
FROM         dbo.tblUserQuizStatus AS QuizStatus INNER JOIN
dbo.tblModule AS m ON m.ModuleID = QuizStatus.ModuleID INNER JOIN
(SELECT     MAX(UserQuizStatusID) AS UserQuizStatusID,ModuleID
FROM          dbo.tblUserQuizStatus where UserID = @UserID
and QuizStatusID = 2 -- passed
GROUP BY  ModuleID ) AS currentStatus ON QuizStatus.UserQuizStatusID = currentStatus.UserQuizStatusID and currentStatus.ModuleID = m.ModuleID
WHERE     (m.Active = 1)
)
LC
on LC.UserID = vUMA.UserID
and LC.ModuleID = vUMA.ModuleID
Where
-- vUMA.CourseID = isnull(@courseID, vUMA.CourseID ) and
vUMA.UserID = isnull(@userID, vUMA.UserID)

' 
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcAutomatedEmails_ManagersToNotifyList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [prcAutomatedEmails_ManagersToNotifyList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcAutomatedEmails_ManagersToNotifyList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [prcAutomatedEmails_ManagersToNotifyList]
(
@OrganisationID int
)

AS

BEGIN
--                    S E L E C T    T H E    R E S U L T S

--declare @OrganisationID int
--set @OrganisationID = 68

create table #UsersToNotify
(userid int not null
,DelinquentCourse nvarchar(max) null)

insert into #UsersToNotify
SELECT distinct UsersToNotify.userid , UsersToNotify.DelinquentCourse FROM
(

-- delinquent users
SELECT DISTINCT CD.UserCourseStatusID as UserCourseStatusID, CS.userID , u.username, C.Name     as DelinquentCourse
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblUserCourseDetails UCD ON (UCD.UserID = u.UserID AND UCD.CourseID = C.CourseID)
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID)  AND (RemEsc.IndividualNotification=0)  AND (RemEsc.NotifyMgr = 1) AND (RemEsc.DaysToCompleteCourse>0)
INNER JOIN (select OrgID,NotifyMgrDays, max(lastnotified) as lastnotified  from tblReminderEscalation where tblReminderEscalation.NotifyMgr = 1   group by OrgID,NotifyMgrDays  ) LastNotified 
ON LastNotified.OrgID = o.OrganisationID  and LastNotified.NotifyMgrDays = RemEsc.NotifyMgrDays
INNER JOIN 
(
Select 
DISTINCT
tU.UserID
--, tU.UnitID
--, tU.OrganisationID
--, tM.ModuleID
,tC.CourseID

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
--< get the details on which modules a user is configured to access >--
Left Outer join dbo.tblUserModuleAccess tUsrMA
On  tUsrMA.UserID = tU.UserID
And tUsrMA.ModuleID = tM.ModuleID
--< get the details on which modules a user''s Unit is excluded from  >--
Left Outer Join dbo.tblUnitModuleAccess tUnitMA
On  tUnitMA.UnitID = tU.UnitID
And tUnitMA.DeniedModuleID = tM.ModuleID
Where
tU.OrganisationID = @OrganisationID AND
tU.Active = 1
--< Active users only >--
and tu.UnitID is not null
--< Get the modules that the user''s Unit is not denied >--
and (tUnitMA.DeniedModuleID  is null
--<  and the user does not have special access to  it>--
And tUsrMA.ModuleID is null)
--< or Get modules that the user has been specially  granted
or tUsrMA.Granted=1
) um on um.UserID = U.UserID and um.CourseID = C.CourseID
where (coursestatusid = 1) 
AND (o.OrganisationID = @OrganisationID) 
AND (GETUTCDATE() > DATEADD(d,RemEsc.DaysToCompleteCourse+1, CS.DateCreated)) -- Is Overdue
AND ((UCD.LastDelNoteToMgr = 0) OR (RemEsc.IsCumulative=1)) and  (U.active = 1)  -- and manager not notified OR CUMULATIVE notifications
AND (GETUTCDATE() > DATEADD(d,RemEsc.NotifyMgrDays,LastNotified.LastNotified )) -- Notify manager every N days
AND (GETUTCDATE() < DATEADD(m,6,DATEADD(d,RemEsc.DaysToCompleteCourse, CS.DateCreated))) -- Business Rule = If Course is more than 6 months overdue stop notifying managers

)  UsersToNotify

create index inx_1 on #UsersToNotify(userid)

create table #UsersToNotifyList
(userid int not null
,DelinquentCourse nvarchar(max) null)

create index inx_2 on #UsersToNotifyList(userid)


declare @userid int
,@DelinquentCourse nvarchar(max)
while exists (select 1 from #UsersToNotify)
begin
set rowcount 1
select @userid = userid
,@DelinquentCourse = DelinquentCourse

from #UsersToNotify
if exists (select * from #UsersToNotifyList where userid = @userid)
begin
update #UsersToNotifyList set
DelinquentCourse = rtrim(#UsersToNotifyList.DelinquentCourse + +  ''<BR>&nbsp;&nbsp;'' + @DelinquentCourse )
from #UsersToNotifyList
where #UsersToNotifyList.userid = @userid
end
else
begin
insert #UsersToNotifyList(userid,DelinquentCourse)
values (@userid,@DelinquentCourse)

end
delete #UsersToNotify where
@userid = userid
and @DelinquentCourse = DelinquentCourse
set rowcount 0
end


create table #ManagersToNotify
(ManagerName nvarchar(200) null
,ManagerEmail nvarchar(200) null
,DelinquentCourse nvarchar(max) null
,FirstName nvarchar(200) null
,LastName nvarchar(200) null
,username nvarchar(200) null)

create index inx_3 on #ManagersToNotify(ManagerName)

INSERT into #ManagersToNotify( ManagerName, ManagerEmail ,DelinquentCourse,FirstName,LastName,username) 

select  UsersManagers.username as managername,  UsersManagers.Email ,''<BR><B>''+U.Firstname+'' ''+U.Lastname+''</B><BR>&nbsp;&nbsp;''+DelinquentCourse,UsersManagers.FirstName as FirstName,UsersManagers.LastName, U.username
FROM #UsersToNotifyList UL
inner join tblUser U on U.userid=UL.userid


INNER JOIN
	(
		SELECT tblUnitAdmins.username, U.UserID, tblUnitAdmins.Email ,tblUnitAdmins.FirstName, tblUnitAdmins.LastName
		FROM  tblUser U  
					INNER JOIN  tblUnitAdministrator ON U.UnitID = tblUnitAdministrator.UnitID
					INNER JOIN   dbo.tblUser AS tblUnitAdmins ON dbo.tblUnitAdministrator.UserID = tblUnitAdmins.UserID AND tblUnitAdmins.UserTypeID = 3
					WHERE  U.NotifyUnitAdmin = 1
		UNION ALL 
		SELECT tblOrgAdmins.username, U.UserID, tblOrgAdmins.Email ,tblOrgAdmins.FirstName, tblOrgAdmins.LastName
		FROM  tblUser U  
					INNER JOIN  dbo.tblUser AS tblOrgAdmins ON U.OrganisationID = tblOrgAdmins.OrganisationID
					WHERE  U.NotifyOrgAdmin = 1 AND tblOrgAdmins.UserTypeID = 2
		UNION ALL
		SELECT ''DelinquencyManager'' as username, tblUserDelinquencyManager.UserID, tblUserDelinquencyManager.DelinquencyManagerEmail,'' '' AS FirstName, '' '' AS LastName
		FROM  dbo.tblUser AS tblUserDelinquencyManager WHERE  NotifyMgr = 1 and tblUserDelinquencyManager.Email IS NOT NULL AND (tblUserDelinquencyManager.Email != '''')
	) UsersManagers ON UsersManagers.UserID = UL.UserID



create table #ManagersToNotifyList
(ManagerName nvarchar(200) null
,ManagerEmail nvarchar(200) null
,DelinquentCourse nvarchar(max) null
,FirstName nvarchar(200) null
,LastName nvarchar(200) null
,username nvarchar(200) null)

create index inx_4 on #ManagersToNotifyList(ManagerName)




declare 
@ManagerName nvarchar(200)
,@ManagerEmail nvarchar(200)
,@FirstName nvarchar(200)
,@LastName nvarchar(200)
,@username nvarchar(200)

while exists (select 1 from #ManagersToNotify)
begin
set rowcount 1
select @ManagerName = ManagerName
,@DelinquentCourse = DelinquentCourse
,@ManagerEmail = ManagerEmail
,@username = username
,@FirstName = FirstName
,@LastName = LastName

from #ManagersToNotify
if exists (select * from #ManagersToNotifyList where ManagerName = @ManagerName)
begin
update #ManagersToNotifyList set
DelinquentCourse = rtrim(#ManagersToNotifyList.DelinquentCourse + +  ''<BR>&nbsp;&nbsp;'' + @DelinquentCourse )
from #ManagersToNotifyList
where #ManagersToNotifyList.ManagerName = @ManagerName
end
else
begin
insert #ManagersToNotifyList(ManagerName,DelinquentCourse,ManagerEmail ,username ,FirstName ,LastName )
values (@ManagerName,@DelinquentCourse,@ManagerEmail,@username ,@FirstName ,@LastName )

end
delete #ManagersToNotify where
@ManagerName = ManagerName
and @DelinquentCourse = DelinquentCourse
and @ManagerEmail = ManagerEmail
and @username = username
and @FirstName = FirstName
and @LastName = LastName
set rowcount 0
end




SELECT l.ManagerEmail,
-- Recipient Email Address
l.ManagerEmail as RecipientEmail,

-- Sender Email Address
l.ManagerEmail as SenderEmail,

-- Subject
(select  REPLACE(
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Overdue_Summary_Subject'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Overdue_Summary_Subject''))),''%APP_NAME%'',(SELECT Value FROM tblAppConfig where Name = ''AppName''))) as Subject,



-- Header
(
select REPLACE(
(
select REPLACE(
(
select REPLACE(
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Overdue_Summary_Header'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Overdue_Summary_Header'')))
,''%APP_NAME%'',
(SELECT Value FROM tblAppConfig where Name = ''AppName'')
)
)
,''%FirstName%'', COALESCE(FirstName,'''') 
)
)
,''%LastName%'', COALESCE(LastName,'''') 
)
)


--delinquent
+ ''<BR>'' + DelinquentCourse + ''<BR>''

--Email Sig
+     (select REPLACE(
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Overdue_Summary_Sig'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Overdue_Summary_Sig'')))+ ''<BR>''  ,''%APP_NAME%'',(SELECT Value FROM tblAppConfig where Name = ''AppName''))) as Body
, -- Sender"On Behalf Of" Email Address
(SELECT dbo.udfGetEmailOnBehalfOf (@OrganisationID))  as OnBehalfOfEmail,


*

FROM
#ManagersToNotifyList l




--set flag to indicate delinquency note has been sent
UPDATE tblUserCourseDetails SET LastDelNoteToMgr  = 1
from tblUserCourseDetails
join (
SELECT U.userID , C.CourseID
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblUserCourseDetails UCD ON (UCD.UserID = u.UserID AND UCD.CourseID = C.CourseID)
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID)  AND (RemEsc.IndividualNotification=0) AND (RemEsc.NotifyMgr = 1)
INNER JOIN (select OrgID,CourseId,NotifyMgrDays, max(lastnotified) as lastnotified  from tblReminderEscalation where tblReminderEscalation.NotifyMgr = 1   group by OrgID,CourseId,NotifyMgrDays  ) LastNotified 
ON LastNotified.OrgID = o.OrganisationID and LastNotified.CourseId =  C.CourseID and LastNotified.NotifyMgrDays = RemEsc.NotifyMgrDays
where (coursestatusid = 1) AND (o.OrganisationID = @OrganisationID) AND (GETUTCDATE() > DATEADD(d,RemEsc.NotifyMgrDays+1, CS.DateCreated))
AND ((UCD.LastDelNoteToMgr = 0) OR (RemEsc.IsCumulative=1)) and  (U.active = 1)
AND (GETUTCDATE() > DATEADD(d,RemEsc.NotifyMgrDays,LastNotified.LastNotified ))
) a on a.userid = tblUserCourseDetails.UserID and a.CourseID = tblUserCourseDetails.CourseID


-- ReminderEscalations are logically grouped by the number of days that the reminders are sent
-- update the "Date last notified" field on the Reminder Escalation for all records that were notified this time.
UPDATE tblReminderEscalation SET LastNotified  = dbo.udfGetSaltOrgMidnight(OrgId)
from tblReminderEscalation
join (
SELECT o.OrganisationID , C.CourseID
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblUserCourseDetails UCD ON (UCD.UserID = u.UserID AND UCD.CourseID = C.CourseID)
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID)  AND (RemEsc.IndividualNotification=0) AND (RemEsc.NotifyMgr = 1)
INNER JOIN (select OrgID,CourseId,NotifyMgrDays, max(lastnotified) as lastnotified  from tblReminderEscalation where tblReminderEscalation.NotifyMgr = 1   group by OrgID,CourseId,NotifyMgrDays  ) LastNotified 
ON LastNotified.OrgID = o.OrganisationID and LastNotified.CourseId =  C.CourseID and LastNotified.NotifyMgrDays = RemEsc.NotifyMgrDays
where (coursestatusid = 1) AND (o.OrganisationID = @OrganisationID) AND (GETUTCDATE() > DATEADD(d,RemEsc.NotifyMgrDays+1, CS.DateCreated))
AND ((UCD.LastDelNoteToMgr = 0) OR (RemEsc.IsCumulative=1)) and  (U.active = 1)
AND (GETUTCDATE() > DATEADD(d,RemEsc.NotifyMgrDays,LastNotified.LastNotified ))
) a on a.OrganisationID = tblReminderEscalation.OrgId and a.CourseID = tblReminderEscalation.CourseID

END
' 
END
GO




IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcAutomatedEmails_ManagersToNotifyIndividually]') AND type in (N'P', N'PC'))
DROP PROCEDURE [prcAutomatedEmails_ManagersToNotifyIndividually]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcAutomatedEmails_ManagersToNotifyIndividually]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [prcAutomatedEmails_ManagersToNotifyIndividually]
(
@OrganisationID int
)


AS

BEGIN


--                    S E L E C T    T H E    R E S U L T S

--declare @OrganisationID int
--set @OrganisationID = 68

;with UsersToNotify (userid,DelinquentCourse,username,uFirstname,uLastname) as (
SELECT distinct UsersToNotify.userid , UsersToNotify.DelinquentCourse,username,uFirstname,uLastname FROM
(


-- delinquent users
SELECT DISTINCT CD.UserCourseStatusID as UserCourseStatusID, CS.userID , u.username, C.Name     as DelinquentCourse, u.FirstName as uFirstname, u.LastName as uLastname
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblUserCourseDetails UCD ON (UCD.UserID = u.UserID AND UCD.CourseID = C.CourseID)
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID)  AND (RemEsc.IndividualNotification=1) AND (RemEsc.NotifyMgr = 1) AND (RemEsc.DaysToCompleteCourse>0)
INNER JOIN 
(
Select 
DISTINCT
tU.UserID
--, tU.UnitID
--, tU.OrganisationID
--, tM.ModuleID
,tC.CourseID

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
--< get the details on which modules a user is configured to access >--
Left Outer join dbo.tblUserModuleAccess tUsrMA
On  tUsrMA.UserID = tU.UserID
And tUsrMA.ModuleID = tM.ModuleID
--< get the details on which modules a user''s Unit is excluded from  >--
Left Outer Join dbo.tblUnitModuleAccess tUnitMA
On  tUnitMA.UnitID = tU.UnitID
And tUnitMA.DeniedModuleID = tM.ModuleID
Where
tU.OrganisationID = @OrganisationID AND
tU.Active = 1
--< Active users only >--
and tu.UnitID is not null
--< Get the modules that the user''s Unit is not denied >--
and (tUnitMA.DeniedModuleID  is null
--<  and the user does not have special access to  it>--
And tUsrMA.ModuleID is null)
--< or Get modules that the user has been specially  granted
or tUsrMA.Granted=1
) um on um.UserID = U.UserID and um.CourseID = C.CourseID
where (coursestatusid = 1) 
AND (o.OrganisationID = @OrganisationID) 
AND (GETUTCDATE() > DATEADD(d,RemEsc.DaysToCompleteCourse+1, CS.DateCreated)) -- Is Overdue
AND (U.active = 1) 
AND (UCD.LastDelNoteToMgr = 0)
AND (GETUTCDATE() < DATEADD(m,6,DATEADD(d,RemEsc.DaysToCompleteCourse, CS.DateCreated))) -- Business Rule = If Course is more than 6 months overdue stop notifying managers



)  UsersToNotify
)

, UsersToNotifyList(numb, userid,DelinquentCourse,username,uFirstname,uLastname) as
(
select 1,null,CAST('''' AS NVARCHAR(max)),CAST('''' AS NVARCHAR(max)),CAST('''' AS NVARCHAR(max)),CAST('''' AS NVARCHAR(max))
UNION ALL

--SELECT cte.numb + 1,pl.userid,CAST(cte.DelinquentCourse + (case when cte.DelinquentCourse = '''' or pl.DelinquentCourse = '''' then '''' else ''<BR>'' end ) + pl.DelinquentCourse AS NVARCHAR(max))
SELECT cte.numb + 1,pl.userid,CAST(    cte.DelinquentCourse +  ''<BR>&nbsp;&nbsp;'' + pl.DelinquentCourse AS NVARCHAR(max)),CAST(pl.username AS NVARCHAR(max)),CAST(pl.uFirstname AS NVARCHAR(max)),CAST(pl.uLastname AS NVARCHAR(max))

from (  SELECT

RowNum = Row_Number() OVER (partition BY userid order by userid)
,userid,DelinquentCourse,username,uFirstname,uLastname

FROM UsersToNotify
) AS pl
join UsersToNotifyList cte on pl.RowNum = cte.numb and (cte.userid is null or pl.userid = cte.userid)
)




, ManagersToNotifyList(numb, ManagerEmail, DelinquentCourse, FirstName, LastName,username,ManagerName,uFirstname,uLastname) as
(
select numb,  CAST(UsersManagers.Email AS NVARCHAR(max)),DelinquentCourse,FirstName,LastName,UL.username,UsersManagers.UserName,uFirstname,uLastname
FROM UsersToNotifyList UL
inner join (select max(numb) AS maxnumb,Userid  from UsersToNotifyList  group by userid) max on max.maxnumb = UL.numb and max.userid = UL.userid

--INNER JOIN
--	(
--		SELECT U.username, U.UserID, tblUnitAdmins.Email ,tblUnitAdmins.FirstName, tblUnitAdmins.LastName
--		FROM  tblUser U  
--					INNER JOIN  tblUnitAdministrator ON U.UnitID = tblUnitAdministrator.UnitID
--					INNER JOIN   dbo.tblUser AS tblUnitAdmins ON dbo.tblUnitAdministrator.UserID = tblUnitAdmins.UserID AND tblUnitAdmins.UserTypeID = 3
--					WHERE  U.NotifyUnitAdmin = 1
--		UNION ALL 
--		SELECT U.username, U.UserID, tblOrgAdmins.Email ,tblOrgAdmins.FirstName, tblOrgAdmins.LastName
--		FROM  tblUser U  
--					INNER JOIN  dbo.tblUser AS tblOrgAdmins ON U.OrganisationID = tblOrgAdmins.OrganisationID
--					WHERE  U.NotifyOrgAdmin = 1 AND tblOrgAdmins.UserTypeID = 2
--		UNION ALL
--		SELECT username, tblUserDelinquencyManager.UserID, tblUserDelinquencyManager.DelinquencyManagerEmail,'' '' AS FirstName, '' '' AS LastName
--		FROM  dbo.tblUser AS tblUserDelinquencyManager WHERE  NotifyMgr = 1 and tblUserDelinquencyManager.Email IS NOT NULL AND (tblUserDelinquencyManager.Email != '''')
--	) UsersManagers ON UsersManagers.UserID = UL.UserID
--)

INNER JOIN
	(
		SELECT tblUnitAdmins.username, U.UserID, tblUnitAdmins.Email ,tblUnitAdmins.FirstName, tblUnitAdmins.LastName
		FROM  tblUser U  
					INNER JOIN  tblUnitAdministrator ON U.UnitID = tblUnitAdministrator.UnitID
					INNER JOIN   dbo.tblUser AS tblUnitAdmins ON dbo.tblUnitAdministrator.UserID = tblUnitAdmins.UserID AND tblUnitAdmins.UserTypeID = 3
					WHERE  U.NotifyUnitAdmin = 1
		UNION ALL 
		SELECT tblOrgAdmins.username, U.UserID, tblOrgAdmins.Email ,tblOrgAdmins.FirstName, tblOrgAdmins.LastName
		FROM  tblUser U  
					INNER JOIN  dbo.tblUser AS tblOrgAdmins ON U.OrganisationID = tblOrgAdmins.OrganisationID
					WHERE  U.NotifyOrgAdmin = 1 AND tblOrgAdmins.UserTypeID = 2
		UNION ALL
		SELECT ''DelinquencyManager'' as username, tblUserDelinquencyManager.UserID, tblUserDelinquencyManager.DelinquencyManagerEmail,'' '' AS FirstName, '' '' AS LastName
		FROM  dbo.tblUser AS tblUserDelinquencyManager WHERE  NotifyMgr = 1 and tblUserDelinquencyManager.Email IS NOT NULL AND (tblUserDelinquencyManager.Email != '''')
	) UsersManagers ON UsersManagers.UserID = UL.UserID

)


--select * from ManagersToNotify
--select * from ManagersToNotifyList




SELECT l.ManagerEmail,
-- Recipient Email Address
l.ManagerEmail as RecipientEmail,

-- Sender Email Address
l.ManagerEmail as SenderEmail,

-- Subject
(select   REPLACE(
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Overdue_Summary_Subject'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Overdue_Summary_Subject''))),''%APP_NAME%'',(SELECT Value FROM tblAppConfig where Name = ''AppName''))) as Subject,



-- Header
(
select REPLACE(
(
select REPLACE(
(
select REPLACE(
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Overdue_Summary_Header'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Overdue_Summary_Header_Individual'')))
,''%APP_NAME%'',
(SELECT Value FROM tblAppConfig where Name = ''AppName'')
)
)
,''%FirstName%'', COALESCE(FirstName,'''') 
)
)
,''%LastName%'', COALESCE(LastName,'''') 
)
)


--delinquent
+ ''<BR>'' +''<B>''+ uFirstname +'' ''+uLastname+''</B>''+''&nbsp;&nbsp;''   + DelinquentCourse+ ''<BR>''

--Email Sig
+     (select REPLACE(
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Overdue_Summary_Sig'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Overdue_Summary_Sig'')))+ ''<BR>''  ,''%APP_NAME%'',(SELECT Value FROM tblAppConfig where Name = ''AppName''))) as Body
, -- Sender"On Behalf Of" Email Address
(SELECT dbo.udfGetEmailOnBehalfOf (@OrganisationID))  as OnBehalfOfEmail,



*

FROM
ManagersToNotifyList l

join (select max(s.numb) numb ,ManagerEmail,ManagerName,UserName from ManagersToNotifyList s group by ManagerEmail,ManagerName,UserName)m on m.ManagerEmail = l.ManagerEmail and m.numb = l.numb and m.UserName = l.UserName and m.ManagerName = l.ManagerName
ORDER BY l.numb DESC


--set flag to indicate delinquency note has been sent
UPDATE tblUserCourseDetails SET LastDelNoteToMgr  = 1
from tblUserCourseDetails
join (
SELECT U.userID , C.CourseID
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblUserCourseDetails UCD ON (UCD.UserID = u.UserID AND UCD.CourseID = C.CourseID)
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID)  AND (RemEsc.IndividualNotification=1) AND (RemEsc.NotifyMgr = 1)
where (coursestatusid = 1) 
AND (o.OrganisationID = @OrganisationID) 
AND (GETUTCDATE() > DATEADD(d,RemEsc.DaysToCompleteCourse+1, CS.DateCreated)) -- Is Overdue
AND (U.active = 1) 
AND (UCD.LastDelNoteToMgr = 0)
AND (GETUTCDATE() < DATEADD(m,6,DATEADD(d,RemEsc.DaysToCompleteCourse, CS.DateCreated))) -- Business Rule = If Course is more than 6 months overdue stop notifying managers
) a on a.userid = tblUserCourseDetails.UserID and a.CourseID = tblUserCourseDetails.CourseID


-- ReminderEscalations are logically grouped by the number of days that the reminders are sent
-- update the "Date last notified" field on the Reminder Escalation for all records that were notified this time.
UPDATE tblReminderEscalation SET LastNotified  = dbo.udfGetSaltOrgMidnight(OrgId)
from tblReminderEscalation
join (
SELECT o.OrganisationID , C.CourseID
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblUserCourseDetails UCD ON (UCD.UserID = u.UserID AND UCD.CourseID = C.CourseID)
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID)  AND (RemEsc.IndividualNotification=1) AND (RemEsc.NotifyMgr = 1)
where (coursestatusid = 1) 
AND (o.OrganisationID = @OrganisationID) 
AND (GETUTCDATE() > DATEADD(d,RemEsc.DaysToCompleteCourse+1, CS.DateCreated)) -- Is Overdue
AND (U.active = 1) 
AND (UCD.LastDelNoteToMgr = 0)
AND (GETUTCDATE() < DATEADD(m,6,DATEADD(d,RemEsc.DaysToCompleteCourse, CS.DateCreated))) -- Business Rule = If Course is more than 6 months overdue stop notifying managers
) a on a.OrganisationID = tblReminderEscalation.OrgId and a.CourseID = tblReminderEscalation.CourseID

END
' 
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_GetNextUrgentReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcReport_GetNextUrgentReport]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_GetNextUrgentReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prcReport_GetNextUrgentReport]

AS
BEGIN
-- Only returns NOW schedules - Send these first to give a greater sense of response by the application
-- NEXTRUN is always saved in UTC to reduce conversion times
-- NextRun is never null
SET NOCOUNT ON

	DECLARE @ScheduleID int,
	@RunDate datetime, 
	@ReportStartDate datetime, 
	@ReportFrequencyPeriod char(1), 
	@ReportFrequency int, 
	@OrgID int	,
	@ReportFromDate datetime,
	@NumberDelivered int,
	@NumberOfReports int,
	@ReportEndDate datetime,
	@ReportPeriodType int,
	@ReportID int,
	@DateFrom DateTime
	
	UPDATE tblReportSchedule -- remove schedules for inactive users
	SET NumberDelivered = 0,
	TerminatedNormally = 1,
	LastRun = getUTCdate(),
	NextRun = null
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		INNER JOIN tblUser ON tblReportSchedule.UserID = tblUser.UserID
		WHERE (TerminatedNormally = 0)
		AND (IsPeriodic = ''N'')
		AND (tblUser.Active = 0)
	)

SELECT @ScheduleID = ScheduleID
FROM tblReportSchedule
INNER JOIN tblReportInterface ON tblReportSchedule.ReportID = tblReportInterface.ReportID
INNER JOIN tblUser ON tblReportSchedule.UserID = tblUser.UserID
INNER JOIN tblOrganisation ON tblOrganisation.OrganisationID = tblReportSchedule.ParamOrganisationID
WHERE  CourseStatusLastUpdated > dbo.udfGetSaltOrgMidnight(tblUser.OrganisationID)
AND (TerminatedNormally = 0)
AND (IsPeriodic = ''N'')
AND (tblUser.Active = 1)

DECLARE @OnBehalfOf nvarchar(255)
DECLARE @ReplyTo nvarchar(255)
DECLARE @FromDate DateTime = CAST(''1 Jan 2002'' as datetime)

	IF (@ScheduleID IS NOT NULL)
	BEGIN
		DECLARE @NextRun datetime
		SELECT @NextRun = NextRun,
		@ReportStartDate = ReportStartDate,
		@ReportFrequencyPeriod = ReportFrequencyPeriod,
		@ReportFrequency = ReportFrequency,
		@OrgID = ParamOrganisationID,
		@ReportFromDate = ReportFromDate,
		@NumberDelivered = NumberDelivered, 
		@NumberOfReports = NumberOfReports, 
		@ReportEndDate = ReportEndDate ,
		@ReportPeriodType = coalesce(ReportPeriodType ,3),
		@ReportID = ReportID,
		@DateFrom = ParamDateFrom
		FROM tblReportSchedule WHERE ScheduleID = @ScheduleID
	
	-- update the Report Schedule
	UPDATE tblReportSchedule 
	SET NumberDelivered = NumberDelivered + 1,
	TerminatedNormally = 1,
	LastRun = getUTCdate(),
	NextRun = cast(''1 jan 2050'' as datetime),
	LastUpdatedBy=0,
	Lastupdated=getUTCdate()
	WHERE ScheduleID = @ScheduleID



	-- we know the ''to'' date - just need to read the ''from'' date
    SET @FromDate = @ReportStartDate



END -- IF ScheduleID is not null


-- return the results
SET NOCOUNT OFF
SELECT TOP (1) [ScheduleID]
,RS.UserID
,RS.ReportID
,[LastRun]
,[ReportStartDate]
,[ReportFrequency]
,[ReportFrequencyPeriod]
,[DocumentType]
,[ParamOrganisationID]
,[ParamCompleted]
,[ParamStatus]
,[ParamFailCount]
,[ParamCourseIDs]
,[ParamHistoricCourseIDs]
,[ParamAllUnits]
,[ParamTimeExpired]
,[ParamTimeExpiredPeriod]
,[ParamQuizStatus]
,[ParamGroupBy]
,[ParamGroupingOption]
,[ParamFirstName]
,[ParamLastName]
,[ParamUserName]
,[ParamEmail]
,[ParamIncludeInactive]
,[ParamSubject]
,[ParamBody]
,[ParamProfileID]
,[ParamProfilePeriodID]
,[ParamOnlyUsersWithShortfall]
,[ParamEffectiveDate]
,[ParamSortBy]
,[ParamClassificationID]
,ParamLangInterfaceName
, case
when tblReportinterface.ReportID = 26 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.2''))
when tblReportinterface.ReportID = 27 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.2''))
when tblReportinterface.ReportID = 3 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.1''))
when tblReportinterface.ReportID = 6 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.1''))
else coalesce(tblLangValue.LangEntryValue,''Missing Localisation'')
end as ReportName
,tblReportInterface.RDLname
,tblUser.FirstName
,tblUser.LastName
,tblUser.Email
,ParamUnitIDs
,paramOrganisationID
,RS.ParamLangCode
,ParamLangCode
,ParamLicensingPeriod
,RS.ReportEndDate
,RS.ReportTitle
,RS.NumberOfReports
,RS.ReportFromDate
,(dbo.udfGetCCList(RS.ScheduleID)) as CCList
,RS.ReportPeriodType
,dbo.udfGetEmailOnBehalfOf (ParamOrganisationID) as OnBehalfOf
,RS.NextRun
,RS.ReportFromDate
,@FromDate as FromDate
,dbo.udfGetEmailReplyTo (ParamOrganisationID,tblUser.FirstName + '' '' + tblUser.LastName + '' <'' + tblUser.Email + ''>'') as ReplyTo
,CASE when exists (SELECT Value FROM  tblAppConfig WHERE (Name = ''SEND_AUTO_EMAILS'') AND (UPPER(Value) = ''YES'')) then O.StopEmails ELSE 1 END as StopEmails
,CAST(convert( varchar(11), dbo.udfUTCtoDaylightSavingTime(DATEADD(d,1,GETUTCDATE()),@OrgID),113) AS DateTime) as Tomorrow
,CASE when tblUser.usertypeid=4 then dbo.udfUser_GetAdministratorsEmailAddress (tblUser.UserID) else tblUser.Email end as SenderEmail
,IsPeriodic
FROM
tblReportinterface
inner join tblReportSchedule RS  on tblReportinterface.ReportID = RS.ReportID
INNER JOIN tblOrganisation O on O.OrganisationID = RS.ParamOrganisationID
INNER JOIN tblUser ON RS.UserID = tblUser.UserID
LEFT OUTER JOIN tblLang ON tblLang.LangCode = RS.ParamLangCode
LEFT OUTER JOIN tblLangInterface ON  paramlanginterfacename = tblLangInterface.langinterfacename
LEFT OUTER JOIN tblLangResource ON  tblLangResource.langresourcename = ''rptreporttitle''
LEFT OUTER JOIN tblLangValue ON tblLang.LangID = tblLangValue.LangID   AND (tblLangValue.Active = 1) and tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID and tblLangValue.LangResourceID = tblLangResource.LangResourceID

WHERE ScheduleID = @ScheduleID


	-- remove spent "NOW" Schedule to reduce size of table
	DELETE FROM tblReportSchedule 
	WHERE ScheduleID = @ScheduleID
	
END
'
end
GO





IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_GetNextOnceOnlyReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcReport_GetNextOnceOnlyReport]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_GetNextOnceOnlyReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prcReport_GetNextOnceOnlyReport]

AS
BEGIN
	-- NextRun is saved in the ORGs timezone so that when an ORG goes into daylight saving the Report is run at the correct time.
	-- ALL other times are saved in the ORGs timezone to reduce load on the GUI when the ORGs timezone is changed
	-- NextRun is never null
	SET NOCOUNT ON
	DECLARE @ScheduleID int,
	@RunDate datetime, 
	@ReportStartDate datetime, 
	@ReportFrequencyPeriod char(1), 
	@ReportFrequency int, 
	@OrgID int	,
	@ReportFromDate datetime,
	@ReportPeriodType int,
	@NumberDelivered int,
	@ReportID int,
	@DateFrom DateTime
	SELECT @ScheduleID = ScheduleID
	FROM tblReportSchedule
	INNER JOIN tblReportInterface ON tblReportSchedule.ReportID = tblReportInterface.ReportID
	INNER JOIN tblUser ON tblReportSchedule.UserID = tblUser.UserID  AND tblUser.Active = 1
	INNER JOIN tblOrganisation ON tblOrganisation.OrganisationID = tblReportSchedule.ParamOrganisationID
	WHERE  CourseStatusLastUpdated > dbo.udfGetSaltOrgMidnight(tblUser.OrganisationID)
	AND (NextRun <= dbo.udfUTCtoDaylightSavingTime(GETUTCDATE(),tblReportSchedule.ParamOrganisationID))
	AND (TerminatedNormally = 0)
	AND (IsPeriodic = ''O'')


	DECLARE @OnBehalfOf nvarchar(255)
	DECLARE @ReplyTo nvarchar(255)
	DECLARE @FromDate DateTime = CAST(''1 Jan 2002'' as datetime)

	IF (@ScheduleID IS NOT NULL)
	BEGIN
		DECLARE @NextRun datetime
		SELECT @NextRun = NextRun,
		@ReportStartDate = ReportStartDate,
		@ReportFrequencyPeriod = ReportFrequencyPeriod,
		@ReportFrequency = ReportFrequency,
		@OrgID = ParamOrganisationID,
		@ReportFromDate = ReportFromDate,
		@NumberDelivered = NumberDelivered,
		@ReportPeriodType = coalesce(ReportPeriodType ,3),
		@ReportID = ReportID,
		@DateFrom = ParamDateFrom
		FROM tblReportSchedule WHERE ScheduleID = @ScheduleID

		SET @RunDate = @NextRun


		SET @NextRun = dbo.udfReportSchedule_IncrementNextRunDate -- get the new NexrRun value
		(
			@RunDate , 
			@ReportStartDate , 
			@ReportFrequencyPeriod , 
			@ReportFrequency , 
			@OrgID 	
		)


		
		-- update the Report Schedule
		UPDATE tblReportSchedule -- Move NextRun,Lastrun forward by one period
		SET NumberDelivered = NumberDelivered + 1,
		TerminatedNormally = 1,
		NextRun = cast(''1 jan 2050'' as datetime),
		LastRun = @RunDate,
		LastUpdatedBy=0,
		Lastupdated=getUTCdate()
		
		WHERE ScheduleID = @ScheduleID

		-- get the Report period (we know the ''to'' date - just need to calculate the ''from'' date)
		IF ((@ReportPeriodType <> 2) AND (@ReportPeriodType <> 3))
		BEGIN
			SET @FromDate = CAST(''1 Jan 2002'' as datetime)
		END
		
		IF (@ReportPeriodType = 3) 
		BEGIN
			SET @FromDate = @ReportFromDate 
		END
		
		IF (@ReportPeriodType = 2) 
		BEGIN
			SET @FromDate =
		CASE 
			WHEN (@ReportFrequencyPeriod=''Y'') THEN DATEADD(YEAR,-@ReportFrequency,@RunDate)
			WHEN (@ReportFrequencyPeriod=''M'') THEN DATEADD(MONTH,-@ReportFrequency,@RunDate)
			WHEN (@ReportFrequencyPeriod=''W'') THEN DATEADD(WEEK,-@ReportFrequency,@RunDate)
			WHEN (@ReportFrequencyPeriod=''D'') THEN DATEADD(DAY,-@ReportFrequency,@RunDate)
			WHEN (@ReportFrequencyPeriod=''H'') THEN DATEADD(HOUR,-@ReportFrequency,@RunDate)
		END	

		END
		
		IF (@ReportID=10) OR (@ReportID=22) OR (@ReportID=23) OR (@ReportID=24)
		BEGIN
			SET @FromDate = @DateFrom
		END
				
		SELECT @OnBehalfOf = dbo.udfGetEmailOnBehalfOf (0)	
	END -- IF ScheduleID is not null


	-- return the results
	SET NOCOUNT OFF
	SELECT TOP (1) [ScheduleID]
	,RS.UserID
	,RS.ReportID
	,[LastRun]
	,[ReportStartDate]
	,[ReportFrequency]
	,[ReportFrequencyPeriod]
	,[DocumentType]
	,[ParamOrganisationID]
	,[ParamCompleted]
	,[ParamStatus]
	,[ParamFailCount]
	,[ParamCourseIDs]
	,[ParamHistoricCourseIDs]
	,[ParamAllUnits]
	,[ParamTimeExpired]
	,[ParamTimeExpiredPeriod]
	,[ParamQuizStatus]
	,[ParamGroupBy]
	,[ParamGroupingOption]
	,[ParamFirstName]
	,[ParamLastName]
	,[ParamUserName]
	,[ParamEmail]
	,[ParamIncludeInactive]
	,[ParamSubject]
	,[ParamBody]
	,[ParamProfileID]
	,[ParamProfilePeriodID]
	,[ParamOnlyUsersWithShortfall]
	,[ParamEffectiveDate]
	,[ParamSortBy]
	,[ParamClassificationID]
	,ParamLangInterfaceName
	, case
	when tblReportinterface.ReportID = 26 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.2''))
	when tblReportinterface.ReportID = 27 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.2''))
	when tblReportinterface.ReportID = 3 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.1''))
	when tblReportinterface.ReportID = 6 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.1''))
	else coalesce(tblLangValue.LangEntryValue,''Missing Localisation'')
	end as ReportName
	,tblReportInterface.RDLname
	,tblUser.FirstName
	,tblUser.LastName
	,tblUser.Email
	,ParamUnitIDs
	,paramOrganisationID
	,RS.ParamLangCode
	,ParamLangCode
	,ParamLicensingPeriod
	,RS.ReportEndDate
	,RS.ReportTitle
	,RS.NumberOfReports
	,RS.ReportFromDate
,(dbo.udfGetCCList(RS.ScheduleID)) as CCList
	,RS.ReportPeriodType
	,dbo.udfGetEmailOnBehalfOf (ParamOrganisationID) as OnBehalfOf
	,RS.NextRun
	,RS.ReportFromDate
	,@FromDate as FromDate
	,dbo.udfGetEmailReplyTo (ParamOrganisationID,tblUser.FirstName + '' '' + tblUser.LastName + '' <'' + tblUser.Email + ''>'') as ReplyTo
	,CASE when exists (SELECT Value FROM  tblAppConfig WHERE (Name = ''SEND_AUTO_EMAILS'') AND (UPPER(Value) = ''YES'')) then O.StopEmails ELSE 1 END as StopEmails
	,CAST(convert( varchar(11), dbo.udfUTCtoDaylightSavingTime(DATEADD(d,1,GETUTCDATE()),@OrgID),113) AS DateTime) as Tomorrow
	,CASE when tblUser.usertypeid=4 then dbo.udfUser_GetAdministratorsEmailAddress (tblUser.UserID) else tblUser.Email end as SenderEmail
	,IsPeriodic
	FROM
	tblReportinterface
	inner join tblReportSchedule RS  on tblReportinterface.ReportID = RS.ReportID
	INNER JOIN tblOrganisation O on O.OrganisationID = RS.ParamOrganisationID
	INNER JOIN tblUser ON RS.UserID = tblUser.UserID
	LEFT OUTER JOIN tblLang ON tblLang.LangCode = RS.ParamLangCode
	LEFT OUTER JOIN tblLangInterface ON  paramlanginterfacename = tblLangInterface.langinterfacename
	LEFT OUTER JOIN tblLangResource ON  tblLangResource.langresourcename = ''rptreporttitle''
	LEFT OUTER JOIN tblLangValue ON tblLang.LangID = tblLangValue.LangID   AND (tblLangValue.Active = 1) and tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID and tblLangValue.LangResourceID = tblLangResource.LangResourceID

	WHERE ScheduleID = @ScheduleID


END
'
end

GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_GetNextReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcReport_GetNextReport]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_GetNextOnceOnlyReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prcReport_GetNextOnceOnlyReport]

AS
BEGIN
	-- NextRun is saved in the ORGs timezone so that when an ORG goes into daylight saving the Report is run at the correct time.
	-- ALL other times are saved in the ORGs timezone to reduce load on the GUI when the ORGs timezone is changed
	
	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET TerminatedNormally = 1
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		WHERE (TerminatedNormally = 0)
		AND (IsPeriodic = ''M'')
		AND ReportEndDate IS NULL -- flag to indicate that NumberOfReports is being used
		AND NumberOfReports IS NOT NULL
		AND NumberDelivered >= NumberOfReports 
	)
	
	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET TerminatedNormally = 0
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		WHERE (TerminatedNormally = 1)
		AND (IsPeriodic = ''M'')
		AND ReportEndDate IS NULL -- flag to indicate that NumberOfReports is being used
		AND NumberOfReports IS NOT NULL
		AND NumberDelivered < NumberOfReports 
	)
	


	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET 
	LastRun = ''1 Jan 2002'',
	NextRun = dbo.udfReportSchedule_CalcNextRunDate 
	(
		ReportStartDate, 
		ReportStartDate , 
		ReportFrequencyPeriod , 
		ReportFrequency , 
		ParamOrganisationID 	
	)
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		INNER JOIN tblUser ON tblReportSchedule.UserID = tblUser.UserID
		WHERE (TerminatedNormally = 0)
		AND (IsPeriodic != ''N'')
		AND (tblUser.Active = 1)
		AND LASTRUN IS NULL
		AND NEXTRUN IS NULL
	)

	
	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET LastRun = ''1 Jan 2001''
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		INNER JOIN tblUser ON tblReportSchedule.UserID = tblUser.UserID
		WHERE (TerminatedNormally = 0)
		AND (IsPeriodic != ''N'')
		AND (tblUser.Active = 1)
		AND LASTRUN IS NULL
	)
	
		
	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET NextRun = dbo.udfReportSchedule_CalcNextRunDate 
	(
		LastRun , 
		ReportStartDate , 
		ReportFrequencyPeriod , 
		ReportFrequency , 
		ParamOrganisationID 	
	)
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		INNER JOIN tblUser ON tblReportSchedule.UserID = tblUser.UserID
		--WHERE (TerminatedNormally = 0)
		AND (IsPeriodic != ''N'')
		AND (tblUser.Active = 1)
		AND NEXTRUN IS NULL
	)
	
	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET TerminatedNormally = 1
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		WHERE (TerminatedNormally = 0)
		AND (IsPeriodic = ''M'')
		AND ReportEndDate IS NOT NULL
		AND NextRun > ReportEndDate
		AND NumberOfReports IS NULL
	)
	
	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET TerminatedNormally = 0
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		WHERE (TerminatedNormally = 1)
		AND (IsPeriodic = ''M'')
		AND ReportEndDate IS NOT NULL
		AND NextRun <= ReportEndDate
		AND NumberOfReports IS NULL
	)	
		
	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET TerminatedNormally = 0
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		WHERE (TerminatedNormally = 1)
		AND (IsPeriodic = ''M'')
		AND ReportEndDate IS NULL 
		AND NumberOfReports IS  NULL
	)
	
	
	-- NextRun is never null
	SET NOCOUNT ON
	DECLARE @ScheduleID int,
	@RunDate datetime, 
	@ReportStartDate datetime, 
	@ReportFrequencyPeriod char(1), 
	@ReportFrequency int, 
	@OrgID int	,
	@ReportFromDate datetime,
	@NumberDelivered int,
	@NumberOfReports int,
	@ReportEndDate datetime,
	@ReportPeriodType int,
	@ReportID int

	SELECT @ScheduleID =  ScheduleID
	FROM tblReportSchedule
	INNER JOIN tblReportInterface ON tblReportSchedule.ReportID = tblReportInterface.ReportID
	INNER JOIN tblUser ON tblReportSchedule.UserID = tblUser.UserID AND tblUser.Active = 1
	INNER JOIN tblOrganisation ON tblOrganisation.OrganisationID = tblReportSchedule.ParamOrganisationID
	WHERE  CourseStatusLastUpdated > dbo.udfGetSaltOrgMidnight(tblUser.OrganisationID)
	AND (NextRun <= dbo.udfUTCtoDaylightSavingTime(GETUTCDATE(),tblReportSchedule.ParamOrganisationID))
	AND (TerminatedNormally = 0)
	AND (IsPeriodic = ''M'')


	DECLARE @OnBehalfOf nvarchar(255)
	DECLARE @ReplyTo nvarchar(255)
	DECLARE @FromDate DateTime = CAST(''1 Jan 2002'' as datetime)
	DECLARE @DateFrom DateTime

	IF (@ScheduleID IS NOT NULL)
	BEGIN
		DECLARE @NextRun datetime
		SELECT @NextRun = NextRun,
		@ReportStartDate = ReportStartDate,
		@ReportFrequencyPeriod = ReportFrequencyPeriod,
		@ReportFrequency = ReportFrequency,
		@OrgID = ParamOrganisationID,
		@ReportFromDate = ReportFromDate,
		@NumberDelivered = NumberDelivered, 
		@NumberOfReports = NumberOfReports, 
		@ReportEndDate = ReportEndDate ,
		@ReportPeriodType = coalesce(ReportPeriodType ,3),
		@ReportID = ReportID,
		@DateFrom = ParamDateFrom
		FROM tblReportSchedule WHERE ScheduleID = @ScheduleID

		SET @RunDate = dbo.udfReportSchedule_CalcNextRunDate -- may have missed a couple of reports if the server was down so just verify that NEXTRUN makes sense
		(
			@NextRun,  
			@ReportStartDate , 
			@ReportFrequencyPeriod,  
			@ReportFrequency, 
			@OrgID
		)

		SET @NextRun = dbo.udfReportSchedule_IncrementNextRunDate -- get the new NexrRun value
		(
			@RunDate , 
			@ReportStartDate , 
			@ReportFrequencyPeriod , 
			@ReportFrequency , 
			@OrgID 	
		)
		-- now look for termination conditions
		DECLARE @TerminatedNormally bit = 0

		IF  @ReportEndDate IS NOT NULL AND (@ReportEndDate < @NextRun) BEGIN SET @TerminatedNormally = 1  END
		IF @NumberOfReports IS NOT NULL AND (@NumberOfReports < (@NumberDelivered + 1)) BEGIN SET @TerminatedNormally = 1  END
		
		-- update the Report Schedule
		UPDATE tblReportSchedule -- Move NextRun,Lastrun forward by one period
		SET NumberDelivered = NumberDelivered + 1,
		TerminatedNormally = @TerminatedNormally,
		LastRun = @RunDate,
		NextRun = @NextRun,
		LastUpdatedBy=0,
		Lastupdated=getUTCdate()
		WHERE ScheduleID = @ScheduleID

		-- get the Report period (we know the ''to'' date - just need to calculate the ''from'' date)

		IF ((@ReportPeriodType <> 2) AND (@ReportPeriodType <> 3))
		BEGIN
			SET @FromDate = CAST(''1 Jan 2002'' as datetime)
		END
		
		IF (@ReportPeriodType = 3) 
		BEGIN
			SELECT @FromDate = @ReportFromDate 
		END
		
		IF (@ReportPeriodType = 2) 
		BEGIN
			SET @FromDate =
			CASE 
				WHEN (@ReportFrequencyPeriod=''Y'') THEN DATEADD(YEAR,-@ReportFrequency,@RunDate)
				WHEN (@ReportFrequencyPeriod=''M'') THEN DATEADD(MONTH,-@ReportFrequency,@RunDate)
				WHEN (@ReportFrequencyPeriod=''W'') THEN DATEADD(WEEK,-@ReportFrequency,@RunDate)
				WHEN (@ReportFrequencyPeriod=''D'') THEN DATEADD(DAY,-@ReportFrequency,@RunDate)
				WHEN (@ReportFrequencyPeriod=''H'') THEN DATEADD(HOUR,-@ReportFrequency,@RunDate)
			END	
	    END
		IF (@ReportID=10) OR (@ReportID=22) OR (@ReportID=23) OR (@ReportID=24)
		BEGIN
			SET @FromDate = @DateFrom
		END
		
	SELECT @OnBehalfOf = dbo.udfGetEmailOnBehalfOf (@OrgID)	
	END -- IF ScheduleID is not null


	-- return the results
	SET NOCOUNT OFF
	SELECT TOP (1) [ScheduleID]
	,RS.UserID
	,RS.ReportID
	,[LastRun]
	,[ReportStartDate]
	,[ReportFrequency]
	,[ReportFrequencyPeriod]
	,[DocumentType]
	,[ParamOrganisationID]
	,[ParamCompleted]
	,[ParamStatus]
	,[ParamFailCount]
	,[ParamCourseIDs]
	,[ParamHistoricCourseIDs]
	,[ParamAllUnits]
	,[ParamTimeExpired]
	,[ParamTimeExpiredPeriod]
	,[ParamQuizStatus]
	,[ParamGroupBy]
	,[ParamGroupingOption]
	,[ParamFirstName]
	,[ParamLastName]
	,[ParamUserName]
	,[ParamEmail]
	,[ParamIncludeInactive]
	,[ParamSubject]
	,[ParamBody]
	,[ParamProfileID]
	,[ParamProfilePeriodID]
	,[ParamOnlyUsersWithShortfall]
	,[ParamEffectiveDate]
	,[ParamSortBy]
	,[ParamClassificationID]
	,ParamLangInterfaceName
	, case
	when tblReportinterface.ReportID = 26 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.2''))
	when tblReportinterface.ReportID = 27 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.2''))
	when tblReportinterface.ReportID = 3 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.1''))
	when tblReportinterface.ReportID = 6 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.1''))
	else coalesce(tblLangValue.LangEntryValue,''Missing Localisation'')
	end as ReportName
	,tblReportInterface.RDLname
	,tblUser.FirstName
	,tblUser.LastName
	,tblUser.Email
	,ParamUnitIDs
	,paramOrganisationID
	,RS.ParamLangCode
	,ParamLangCode
	,ParamLicensingPeriod
	,RS.ReportEndDate
	,RS.ReportTitle
	,RS.NumberOfReports
	,RS.ReportFromDate
,(dbo.udfGetCCList(RS.ScheduleID)) as CCList
	,RS.ReportPeriodType
	,dbo.udfGetEmailOnBehalfOf (ParamOrganisationID) as OnBehalfOf
	,RS.NextRun
	,@FromDate as FromDate
	,dbo.udfGetEmailReplyTo (ParamOrganisationID,tblUser.FirstName + '' '' + tblUser.LastName + '' <'' + tblUser.Email + ''>'') as ReplyTo
	,CASE when exists (SELECT Value FROM  tblAppConfig WHERE (Name = ''SEND_AUTO_EMAILS'') AND (UPPER(Value) = ''YES'')) then O.StopEmails ELSE 1 END as StopEmails
	,CAST(convert( varchar(11), dbo.udfUTCtoDaylightSavingTime(DATEADD(d,1,GETUTCDATE()),@OrgID),113) AS DateTime) as Tomorrow
,CASE when tblUser.usertypeid=4 then dbo.udfUser_GetAdministratorsEmailAddress (tblUser.UserID) else tblUser.Email end as SenderEmail
    ,IsPeriodic
	FROM
	tblReportinterface
	inner join tblReportSchedule RS  on tblReportinterface.ReportID = RS.ReportID
	INNER JOIN tblOrganisation O on O.OrganisationID = RS.ParamOrganisationID
	INNER JOIN tblUser ON RS.UserID = tblUser.UserID
	LEFT OUTER JOIN tblLang ON tblLang.LangCode = RS.ParamLangCode
	LEFT OUTER JOIN tblLangInterface ON  paramlanginterfacename = tblLangInterface.langinterfacename
	LEFT OUTER JOIN tblLangResource ON  tblLangResource.langresourcename = ''rptreporttitle''
	LEFT OUTER JOIN tblLangValue ON tblLang.LangID = tblLangValue.LangID   AND (tblLangValue.Active = 1) and tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID and tblLangValue.LangResourceID = tblLangResource.LangResourceID

	WHERE ScheduleID = @ScheduleID


END
'
end
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_GetNextReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [prcReport_GetNextReport]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_GetNextReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [prcReport_GetNextReport]

AS
BEGIN
	-- NextRun is saved in the ORGs timezone so that when an ORG goes into daylight saving the Report is run at the correct time.
	-- ALL other times are saved in the ORGs timezone to reduce load on the GUI when the ORGs timezone is changed
	
	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET TerminatedNormally = 1
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		WHERE (TerminatedNormally = 0)
		AND (IsPeriodic = ''M'')
		AND ReportEndDate IS NULL -- flag to indicate that NumberOfReports is being used
		AND NumberOfReports IS NOT NULL
		AND NumberDelivered >= NumberOfReports 
	)
	
	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET TerminatedNormally = 0
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		WHERE (TerminatedNormally = 1)
		AND (IsPeriodic = ''M'')
		AND ReportEndDate IS NULL -- flag to indicate that NumberOfReports is being used
		AND NumberOfReports IS NOT NULL
		AND NumberDelivered < NumberOfReports 
	)
	


	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET 
	LastRun = ''1 Jan 1997'',
	NextRun = dbo.udfReportSchedule_CalcNextRunDate 
	(
		ReportStartDate, 
		ReportStartDate , 
		ReportFrequencyPeriod , 
		ReportFrequency , 
		ParamOrganisationID 	
	)
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		INNER JOIN tblUser ON tblReportSchedule.UserID = tblUser.UserID
		WHERE (TerminatedNormally = 0)
		AND (IsPeriodic != ''N'')
		AND (tblUser.Active = 1)
		AND LASTRUN IS NULL
		AND NEXTRUN IS NULL
	)

	
	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET LastRun = ''1 Jan 2001''
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		INNER JOIN tblUser ON tblReportSchedule.UserID = tblUser.UserID
		WHERE (TerminatedNormally = 0)
		AND (IsPeriodic != ''N'')
		AND (tblUser.Active = 1)
		AND LASTRUN IS NULL
	)
	
		
	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET NextRun = dbo.udfReportSchedule_CalcNextRunDate 
	(
		LastRun , 
		ReportStartDate , 
		ReportFrequencyPeriod , 
		ReportFrequency , 
		ParamOrganisationID 	
	)
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		INNER JOIN tblUser ON tblReportSchedule.UserID = tblUser.UserID
		--WHERE (TerminatedNormally = 0)
		AND (IsPeriodic != ''N'')
		AND (tblUser.Active = 1)
		AND NEXTRUN IS NULL
	)
	
	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET TerminatedNormally = 1
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		WHERE (TerminatedNormally = 0)
		AND (IsPeriodic = ''M'')
		AND ReportEndDate IS NOT NULL
		AND NextRun > ReportEndDate
		AND NumberOfReports IS NULL
	)
	
	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET TerminatedNormally = 0
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		WHERE (TerminatedNormally = 1)
		AND (IsPeriodic = ''M'')
		AND ReportEndDate IS NOT NULL
		AND NextRun <= ReportEndDate
		AND NumberOfReports IS NULL
	)	
		
	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET TerminatedNormally = 0
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		WHERE (TerminatedNormally = 1)
		AND (IsPeriodic = ''M'')
		AND ReportEndDate IS NULL 
		AND NumberOfReports IS  NULL
	)
	
	
	-- NextRun is never null
	SET NOCOUNT ON
	DECLARE @ScheduleID int,
	@RunDate datetime, 
	@ReportStartDate datetime, 
	@ReportFrequencyPeriod char(1), 
	@ReportFrequency int, 
	@OrgID int	,
	@ReportFromDate datetime,
	@NumberDelivered int,
	@NumberOfReports int,
	@ReportEndDate datetime,
	@ReportPeriodType int,
	@ReportID int

	SELECT @ScheduleID =  ScheduleID
	FROM tblReportSchedule
	INNER JOIN tblReportInterface ON tblReportSchedule.ReportID = tblReportInterface.ReportID
	INNER JOIN tblUser ON tblReportSchedule.UserID = tblUser.UserID AND tblUser.Active = 1
	INNER JOIN tblOrganisation ON tblOrganisation.OrganisationID = tblReportSchedule.ParamOrganisationID
	WHERE  CourseStatusLastUpdated > dbo.udfGetSaltOrgMidnight(tblUser.OrganisationID)
	AND (NextRun <= dbo.udfUTCtoDaylightSavingTime(GETUTCDATE(),tblReportSchedule.ParamOrganisationID))
	AND (TerminatedNormally = 0)
	AND (IsPeriodic = ''M'')


	DECLARE @OnBehalfOf nvarchar(255)
	DECLARE @ReplyTo nvarchar(255)
	DECLARE @FromDate DateTime = CAST(''1 Jan 1997'' as datetime)
	DECLARE @DateFrom DateTime

	IF (@ScheduleID IS NOT NULL)
	BEGIN
		DECLARE @NextRun datetime
		SELECT @NextRun = NextRun,
		@ReportStartDate = ReportStartDate,
		@ReportFrequencyPeriod = ReportFrequencyPeriod,
		@ReportFrequency = ReportFrequency,
		@OrgID = ParamOrganisationID,
		@ReportFromDate = ReportFromDate,
		@NumberDelivered = NumberDelivered, 
		@NumberOfReports = NumberOfReports, 
		@ReportEndDate = ReportEndDate ,
		@ReportPeriodType = coalesce(ReportPeriodType ,3),
		@ReportID = ReportID,
		@DateFrom = ParamDateFrom
		FROM tblReportSchedule WHERE ScheduleID = @ScheduleID

		SET @RunDate = dbo.udfReportSchedule_CalcNextRunDate -- may have missed a couple of reports if the server was down so just verify that NEXTRUN makes sense
		(
			@NextRun,  
			@ReportStartDate , 
			@ReportFrequencyPeriod,  
			@ReportFrequency, 
			@OrgID
		)

		SET @NextRun = dbo.udfReportSchedule_IncrementNextRunDate -- get the new NexrRun value
		(
			@RunDate , 
			@ReportStartDate , 
			@ReportFrequencyPeriod , 
			@ReportFrequency , 
			@OrgID 	
		)
		-- now look for termination conditions
		DECLARE @TerminatedNormally bit = 0

		IF  @ReportEndDate IS NOT NULL AND (@ReportEndDate < @NextRun) BEGIN SET @TerminatedNormally = 1  END
		IF @NumberOfReports IS NOT NULL AND (@NumberOfReports < (@NumberDelivered + 1)) BEGIN SET @TerminatedNormally = 1  END
		
		-- update the Report Schedule
		UPDATE tblReportSchedule -- Move NextRun,Lastrun forward by one period
		SET NumberDelivered = NumberDelivered + 1,
		TerminatedNormally = @TerminatedNormally,
		LastRun = @RunDate,
		NextRun = @NextRun,
		LastUpdatedBy=0,
		Lastupdated=getUTCdate()
		WHERE ScheduleID = @ScheduleID

		-- get the Report period (we know the ''to'' date - just need to calculate the ''from'' date)

		IF ((@ReportPeriodType <> 2) AND (@ReportPeriodType <> 3))
		BEGIN
			SET @FromDate = CAST(''1 Jan 1997'' as datetime)
		END
		
		IF (@ReportPeriodType = 3) 
		BEGIN
			SELECT @FromDate = @ReportFromDate 
		END
		
		IF (@ReportPeriodType = 2) 
		BEGIN
			SET @FromDate =
			CASE 
				WHEN (@ReportFrequencyPeriod=''Y'') THEN DATEADD(YEAR,-@ReportFrequency,@RunDate)
				WHEN (@ReportFrequencyPeriod=''M'') THEN DATEADD(MONTH,-@ReportFrequency,@RunDate)
				WHEN (@ReportFrequencyPeriod=''W'') THEN DATEADD(WEEK,-@ReportFrequency,@RunDate)
				WHEN (@ReportFrequencyPeriod=''D'') THEN DATEADD(DAY,-@ReportFrequency,@RunDate)
				WHEN (@ReportFrequencyPeriod=''H'') THEN DATEADD(HOUR,-@ReportFrequency,@RunDate)
			END	
	    END
		IF (@ReportID=10) OR (@ReportID=22) OR (@ReportID=23) OR (@ReportID=24)
		BEGIN
			SET @FromDate = @DateFrom
		END
		
	SELECT @OnBehalfOf = dbo.udfGetEmailOnBehalfOf (@OrgID)	
	END -- IF ScheduleID is not null


	-- return the results
	SET NOCOUNT OFF
	SELECT TOP (1) [ScheduleID]
	,RS.UserID
	,RS.ReportID
	,[LastRun]
	,[ReportStartDate]
	,[ReportFrequency]
	,[ReportFrequencyPeriod]
	,[DocumentType]
	,[ParamOrganisationID]
	,[ParamCompleted]
	,[ParamStatus]
	,[ParamFailCount]
	,[ParamCourseIDs]
	,[ParamHistoricCourseIDs]
	,[ParamAllUnits]
	,[ParamTimeExpired]
	,[ParamTimeExpiredPeriod]
	,[ParamQuizStatus]
	,[ParamGroupBy]
	,[ParamGroupingOption]
	,[ParamFirstName]
	,[ParamLastName]
	,[ParamUserName]
	,[ParamEmail]
	,[ParamIncludeInactive]
	,[ParamSubject]
	,[ParamBody]
	,[ParamProfileID]
	,[ParamProfilePeriodID]
	,[ParamOnlyUsersWithShortfall]
	,[ParamEffectiveDate]
	,[ParamSortBy]
	,[ParamClassificationID]
	,ParamLangInterfaceName
	, case
	when tblReportinterface.ReportID = 26 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.2''))
	when tblReportinterface.ReportID = 27 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.2''))
	when tblReportinterface.ReportID = 3 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.1''))
	when tblReportinterface.ReportID = 6 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.1''))
	else coalesce(tblLangValue.LangEntryValue,''Missing Localisation'')
	end as ReportName
	,tblReportInterface.RDLname
	,tblUser.FirstName
	,tblUser.LastName
	,tblUser.Email
	,ParamUnitIDs
	,paramOrganisationID
	,RS.ParamLangCode
	,ParamLangCode
	,ParamLicensingPeriod
	,RS.ReportEndDate
	,RS.ReportTitle
	,RS.NumberOfReports
	,RS.ReportFromDate
,(dbo.udfGetCCList(RS.ScheduleID)) as CCList
	,RS.ReportPeriodType
	,dbo.udfGetEmailOnBehalfOf (ParamOrganisationID) as OnBehalfOf
	,RS.NextRun
	,@FromDate as FromDate
	,dbo.udfGetEmailReplyTo (ParamOrganisationID,tblUser.FirstName + '' '' + tblUser.LastName + '' <'' + tblUser.Email + ''>'') as ReplyTo
	,CASE when exists (SELECT Value FROM  tblAppConfig WHERE (Name = ''SEND_AUTO_EMAILS'') AND (UPPER(Value) = ''YES'')) then O.StopEmails ELSE 1 END as StopEmails
	,CAST(convert( varchar(11), dbo.udfUTCtoDaylightSavingTime(DATEADD(d,1,GETUTCDATE()),@OrgID),113) AS DateTime) as Tomorrow
,CASE when tblUser.usertypeid=4 then dbo.udfUser_GetAdministratorsEmailAddress (tblUser.UserID) else tblUser.Email end as SenderEmail
    ,IsPeriodic
	FROM
	tblReportinterface
	inner join tblReportSchedule RS  on tblReportinterface.ReportID = RS.ReportID
	INNER JOIN tblOrganisation O on O.OrganisationID = RS.ParamOrganisationID
	INNER JOIN tblUser ON RS.UserID = tblUser.UserID
	LEFT OUTER JOIN tblLang ON tblLang.LangCode = RS.ParamLangCode
	LEFT OUTER JOIN tblLangInterface ON  paramlanginterfacename = tblLangInterface.langinterfacename
	LEFT OUTER JOIN tblLangResource ON  tblLangResource.langresourcename = ''rptreporttitle''
	LEFT OUTER JOIN tblLangValue ON tblLang.LangID = tblLangValue.LangID   AND (tblLangValue.Active = 1) and tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID and tblLangValue.LangResourceID = tblLangResource.LangResourceID

	WHERE ScheduleID = @ScheduleID


END
' 
END
GO


