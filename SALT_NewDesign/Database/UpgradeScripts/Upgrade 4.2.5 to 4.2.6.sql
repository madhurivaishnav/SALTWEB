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
AND (CS.DateCreated >= (SELECT MAX(DateCreated) FROM tblUserCourseStatus Expired where expired.CourseStatusID in (0,2) and Expired.CourseID = CS.CourseID and Expired.UserID =CS.UserID ) )
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
AND (CS.DateCreated >= (SELECT MAX(DateCreated) FROM tblUserCourseStatus Expired where expired.CourseStatusID in (0,2) and Expired.CourseID = CS.CourseID and Expired.UserID =CS.UserID ) )
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

select U.UserID,CourseID,UserCourseStatusID,0,null,'''','''',null
FROM  tblUser U inner join tblUserCourseStatus tUCS ON U.UserID = tUCS.UserID and U.OrganisationID = @organisationID  INNER JOIN
(SELECT MAX(UserCourseStatusID) AS MaxUserCourseStatusID
FROM   dbo.tblUserCourseStatus
GROUP BY UserID, CourseID) AS currentStatus ON tUCS.UserCourseStatusID = currentStatus.MaxUserCourseStatusID

where  CourseStatusID in (1,2) and UserCourseStatusID NOT IN (SELECT UserCourseStatusID FROM tblUserCourseDetails)






--remove data on courses that are now unassigned
DELETE FROM tblUserCourseDetails WHERE UserCourseStatusID IN
(SELECT UserCourseStatusID
FROM  tblUser U inner join tblUserCourseStatus tUCS ON U.UserID = tUCS.UserID and U.OrganisationID = @organisationID  INNER JOIN
(SELECT MAX(UserCourseStatusID) AS MaxUserCourseStatusID
FROM   dbo.tblUserCourseStatus
GROUP BY UserID, CourseID) AS currentStatus ON tUCS.UserCourseStatusID = currentStatus.MaxUserCourseStatusID

where  CourseStatusID = 0
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

UNION all SELECT DISTINCT UserCourseStatusID  , userID ,  '''' as NewContent , '''' as PassedCourses,'''' as PassedModules, '''' as AtRiskContent,''   ''+ Name +'' '' + convert(varchar (11),DATEADD(d,DaysToCompleteCourse, dbo.udfUTCtoDaylightSavingTime(DateCreated,@OrganisationID)),113)  as AtRiskOfdelinquency
FROM (SELECT MAX(CD.UserCourseStatusID) as UserCourseStatusID, CS.userID ,  RemEsc.DaysToCompleteCourse, MIN(CS.DateCreated) as DateCreated,C.Name,CS.CourseID
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID) AND (RemindUsers=1)
where U.Active = 1
AND ((o.DefaultQuizCompletionDate is not null AND CS.DateCreated >  dateadd(year,-1,o.DefaultQuizCompletionDate))
OR     (o.DefaultQuizCompletionDate is  null AND CS.DateCreated >= (select ISNULL((SELECT MAX(DateCreated) FROM tblUserCourseStatus Expired where expired.CourseStatusID in (0,2) and Expired.CourseID = CS.CourseID and Expired.UserID =CS.UserID) ,''1 jan 1990'')) ))
AND CD.LastDelinquencyNotification IS NULL
AND coursestatusid=1
AND o.OrganisationID = @OrganisationID
AND (GETUTCDATE() > DATEADD(d,RemEsc.DaysToCompleteCourse-RemEsc.NumOfRemNotfy*RemEsc.RepeatRem, CS.DateCreated))
AND (RemEsc.NumOfRemNotfy > cd.NumberOfDelinquencyNotifications)
AND (GETUTCDATE() < DATEADD(m,RemEsc.DaysToCompleteCourse+6, CS.DateCreated)) 
GROUP BY  CS.CourseID, CS.userID ,  RemEsc.DaysToCompleteCourse, C.Name) ThisCycle




---- users with courses at risk of delinquency (SUBSEQUENT WARNINGS)

UNION all SELECT DISTINCT UserCourseStatusID  , userID ,  '''' as NewContent , '''' as PassedCourses,'''' as PassedModules, '''' as AtRiskContent,''   ''+ Name +'' '' + convert(varchar (11),DATEADD(d,DaysToCompleteCourse, dbo.udfUTCtoDaylightSavingTime(DateCreated,@OrganisationID)),113)  as AtRiskOfdelinquency
FROM (SELECT MAX(CD.UserCourseStatusID) as UserCourseStatusID, CS.userID ,  RemEsc.DaysToCompleteCourse, MIN(CS.DateCreated) as DateCreated,C.Name,CS.CourseID
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID) AND (RemindUsers=1)
where U.Active = 1 AND coursestatusid=1 AND o.OrganisationID = @OrganisationID 
AND CD.LastDelinquencyNotification IS NOT NULL
AND ((o.DefaultQuizCompletionDate is not null AND CS.DateCreated >  dateadd(year,-1,o.DefaultQuizCompletionDate))
OR     (o.DefaultQuizCompletionDate is  null AND CS.DateCreated >= (select ISNULL((SELECT MAX(DateCreated) FROM tblUserCourseStatus Expired where expired.CourseStatusID in (0,2) and Expired.CourseID = CS.CourseID and Expired.UserID =CS.UserID) ,''1 jan 1990'')) ))
AND coursestatusid=1
AND o.OrganisationID = @OrganisationID
AND (GETUTCDATE() > DATEADD(d,RemEsc.DaysToCompleteCourse-RemEsc.NumOfRemNotfy*RemEsc.RepeatRem, CS.DateCreated))
AND (RemEsc.NumOfRemNotfy > cd.NumberOfDelinquencyNotifications)
AND (GETUTCDATE() > DATEADD(d,RemEsc.RepeatRem, CD.LastDelinquencyNotification))
AND (GETUTCDATE() < DATEADD(m,RemEsc.DaysToCompleteCourse+6, CS.DateCreated)) 

GROUP BY  CS.CourseID, CS.userID ,  RemEsc.DaysToCompleteCourse, C.Name) ThisQuizCycle




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

SELECT DISTINCT UserCourseStatusID  
FROM (SELECT MAX(CD.UserCourseStatusID) as UserCourseStatusID, CS.userID ,  RemEsc.DaysToCompleteCourse, MIN(CS.DateCreated) as DateCreated,C.Name,CS.CourseID
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID) AND (RemindUsers=1)
where U.Active = 1
AND ((o.DefaultQuizCompletionDate is not null AND CS.DateCreated >  dateadd(year,-1,o.DefaultQuizCompletionDate))
OR     (o.DefaultQuizCompletionDate is  null AND CS.DateCreated >= (select ISNULL((SELECT MAX(DateCreated) FROM tblUserCourseStatus Expired where expired.CourseStatusID in (0,2) and Expired.CourseID = CS.CourseID and Expired.UserID =CS.UserID) ,''1 jan 1990'')) ))
AND CD.LastDelinquencyNotification IS NULL
AND coursestatusid=1
AND o.OrganisationID = @OrganisationID
AND (GETUTCDATE() > DATEADD(d,RemEsc.DaysToCompleteCourse-RemEsc.NumOfRemNotfy*RemEsc.RepeatRem, CS.DateCreated))
AND (RemEsc.NumOfRemNotfy > cd.NumberOfDelinquencyNotifications)
AND (GETUTCDATE() < DATEADD(m,RemEsc.DaysToCompleteCourse+6, CS.DateCreated)) 
GROUP BY  CS.CourseID, CS.userID ,  RemEsc.DaysToCompleteCourse, C.Name) ThisCycle
)




UPDATE tblUserCourseDetails  SET LastDelinquencyNotification = GETUTCDATE(), NumberOfDelinquencyNotifications = NumberOfDelinquencyNotifications + 1
WHERE  UserCourseStatusID in (-- users with courses at risk of delinquency (SUBSEQUENT WARNINGS)
SELECT DISTINCT UserCourseStatusID
FROM (SELECT MAX(CD.UserCourseStatusID) as UserCourseStatusID, CS.userID ,  RemEsc.DaysToCompleteCourse, MIN(CS.DateCreated) as DateCreated,C.Name,CS.CourseID
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID) AND (RemindUsers=1)
where U.Active = 1 AND coursestatusid=1 AND o.OrganisationID = @OrganisationID 
AND CD.LastDelinquencyNotification IS NOT NULL
AND ((o.DefaultQuizCompletionDate is not null AND CS.DateCreated >  dateadd(year,-1,o.DefaultQuizCompletionDate))
OR     (o.DefaultQuizCompletionDate is  null AND CS.DateCreated >= (select ISNULL((SELECT MAX(DateCreated) FROM tblUserCourseStatus Expired where expired.CourseStatusID in (0,2) and Expired.CourseID = CS.CourseID and Expired.UserID =CS.UserID) ,''1 jan 1990'')) ))
AND coursestatusid=1
AND o.OrganisationID = @OrganisationID
AND (GETUTCDATE() > DATEADD(d,RemEsc.DaysToCompleteCourse-RemEsc.NumOfRemNotfy*RemEsc.RepeatRem, CS.DateCreated))
AND (RemEsc.NumOfRemNotfy > cd.NumberOfDelinquencyNotifications)
AND (GETUTCDATE() > DATEADD(d,RemEsc.RepeatRem, CD.LastDelinquencyNotification))
AND (GETUTCDATE() < DATEADD(m,RemEsc.DaysToCompleteCourse+6, CS.DateCreated)) 

GROUP BY  CS.CourseID, CS.userID ,  RemEsc.DaysToCompleteCourse, C.Name) ThisQuizCycle
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
end





' 
END
GO





IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUserQuizStatus_UpdateCourseStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [prcUserQuizStatus_UpdateCourseStatus]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUserQuizStatus_UpdateCourseStatus]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
for the record just in the tblUserQuizStatus:
-- get the old course status in tblUserCourseStatus
-- calculate the new course status
-- insert new course status into tblUserCourseStatus if old and new course status are different

called by:
prcUserQuizStatus_Update

Author: Li Zhang
Date Created: 24-10-2006
*/

CREATE PROCEDURE [prcUserQuizStatus_UpdateCourseStatus]
(
@UserID int
, @ModuleID int
)
AS
SET nocount ON
--SET xact_abort ON

DECLARE @intOldCourseStatus int
DECLARE @intNewCourseStatus int
DECLARE @intCourseID int

SET @intCourseID = (select CourseID from tblModule where ModuleID = @ModuleID)
DECLARE @Err integer
EXEC @intOldCourseStatus = prcUserCourseStatus_GetStatus @intCourseID, @UserID
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_UpdateCourseStatus'',''prcUserCourseStatus_GetStatus'',''UserID=''+CAST(@UserID AS varchar(10)),CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_UpdateCourseStatus'',1,1,null,getutcdate(),getutcdate()) END

IF @Err = 0
BEGIN
EXEC @intNewCourseStatus = prcUserCourseStatus_Calculate @intCourseID, @UserID
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_UpdateCourseStatus'',''prcUserCourseStatus_Calculate'',''UserID=''+CAST(@UserID AS varchar(10)),CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_UpdateCourseStatus'',1,1,null,getutcdate(),getutcdate()) END

IF @Err = 0
BEGIN
IF (@intOldCourseStatus = -1) or (@intOldCourseStatus <> @intNewCourseStatus)
BEGIN
EXEC prcUserCourseStatus_Insert @UserID, @ModuleID, @intNewCourseStatus
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_UpdateCourseStatus'',''prcUserCourseStatus_Insert'',''UserID=''+CAST(@UserID AS varchar(10)),CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_UpdateCourseStatus'',1,1,null,getutcdate(),getutcdate()) END

END
ELSE
BEGIN
IF NOT EXISTS (
Select
tU.UserID
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
tC.CourseID = @intCourseID AND tU.UserID = @UserID AND
tU.Active = 1
--< Active users only >--
and tu.UnitID is not null
--< Get the modules that the user''s Unit is not denied >--
and (tUnitMA.DeniedModuleID  is null
--<  and the user does not have special access to  it>--
And tUsrMA.ModuleID is null)
--< or Get modules that the user has been specially  granted
or tUsrMA.Granted=1
)
AND EXISTS (SELECT UserCourseStatusID FROM tblUserCourseStatus WHERE UserID = @UserID AND CourseID = @intCourseID AND CourseStatusID <> 0)
BEGIN
EXEC prcUserCourseStatus_Insert @UserID, @ModuleID, @StatusID = 0
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_UpdateCourseStatus'',''prcUserCourseStatus_Insert'',''UserID=''+CAST(@UserID AS varchar(10)),CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_UpdateCourseStatus'',1,1,null,getutcdate(),getutcdate()) END
IF (@intOldCourseStatus <> 1) and ( @intNewCourseStatus = 1)
BEGIN
UPDATE   tblUserCourseDetails
SET  LastDelinquencyNotification = null, LastDelNoteToMgr = 0, NumberOfDelinquencyNotifications = 0
WHERE UserID = @UserID AND CourseID = @intCourseID
END
END
END
END
END

' 
END
GO





IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUserQuizStatus_Update_Quick]') AND type in (N'P', N'PC'))
DROP PROCEDURE [prcUserQuizStatus_Update_Quick]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUserQuizStatus_Update_Quick]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/****** Object:  Stored Procedure dbo.prcUserQuizStatus_Update_Quick    Script Date: 3/05/2004 10:56:48 AM ******/

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

prcUserQuizStatus_Update_Quick

**/
CREATE   Procedure [prcUserQuizStatus_Update_Quick]
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


--DECLARE @DaysWarningBeforeExpiry int
--SELECT @DaysWarningBeforeExpiry = DaysWarningBeforeExpiry FROM tblOrganisation where OrganisationID = @OrgID
--IF (@DaysWarningBeforeExpiry IS NULL)
--BEGIN -- Default value of 30 days before quiz -- no longer use 30 days default
--	DECLARE @QuizExpiryDate DateTime
--	SELECT @QuizExpiryDate = dateadd(d,-30,QuizDueDate) FROM tblOrganisation where OrganisationID = @OrgID

--	delete from tblQuizExpiryAtRisk where OrganisationID = @OrgID
--	and not exists (select @OrgID,cam.UserID,
--	cam.ModuleID, DateDiff(day,dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID), dateadd(month, cam.QuizFrequency, dbo.udfUTCtoDaylightSavingTime(sm.DateTimeCompleted,@OrgID)))
--	from #tblCurrentAssignedModules cam
--	inner join #tblStartedModules sm
--	on sm.UserID = cam.UserID
--	and sm.ModuleID = cam.ModuleID
--	where
--	(
--		cam.QuizCompletionDate is null
--		and dbo.udfGetSaltOrgDate(@OrgID) < @QuizExpiryDate
--		and tblQuizExpiryAtRisk.UserID = cam.UserID
--		and tblQuizExpiryAtRisk.ModuleID = cam.ModuleID
--		and tblQuizExpiryAtRisk.OrganisationID = @OrgID
--	))
--	SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_Update_Quick'',''delete from tblQuizExpiryAtRisk'',''delete from tblQuizExpiryAtRisk'',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_Update_Quick'',1,1,null,getutcdate(),getutcdate()) END



--	insert into tblQuizExpiryAtRisk -- add new users who meet the 30 days default rule
--	(
--	OrganisationID,
--	UserID,
--	ModuleID,
--	DaysToExpiry
--	)
--	select @OrgID,cam.UserID,
--	cam.ModuleID, 30
--	from #tblCurrentAssignedModules cam
--	inner join #tblStartedModules sm
--	on sm.UserID = cam.UserID
--	and sm.ModuleID = cam.ModuleID
--	where
--	(
--		cam.QuizCompletionDate is null
--		and dbo.udfGetSaltOrgDate(@OrgID) < @QuizExpiryDate
--	)
--	and not exists
--		(SELECT * FROM tblQuizExpiryAtRisk
--		where 	tblQuizExpiryAtRisk.UserID = cam.UserID
--		and tblQuizExpiryAtRisk.ModuleID = cam.ModuleID
--		and tblQuizExpiryAtRisk.OrganisationID = @OrgID)
--	SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_Update_Quick'',''insert into tblQuizExpiryAtRisk'',''insert into tblQuizExpiryAtRisk'',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_Update_Quick'',1,1,null,getutcdate(),getutcdate()) END

--END





delete from tblQuizExpiryAtRisk where OrganisationID = @OrgID   -- delete from ExpiryAtRisk those users who somehow are no longer at risk
and not exists (
--select @OrgID,cam.UserID,
--cam.ModuleID, DateDiff(day,dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID), dateadd(month, cam.QuizFrequency, dbo.udfUTCtoDaylightSavingTime(sm.DateTimeCompleted,@OrgID)))
--from #tblCurrentAssignedModules cam
--inner join #tblStartedModules sm
--on sm.UserID = cam.UserID
--and sm.ModuleID = cam.ModuleID
--where
--(
--	cam.QuizCompletionDate is null
--	and DateDiff(day, dateadd(month, cam.QuizFrequency, dbo.udfUTCtoDaylightSavingTime(sm.DateTimeCompleted,@OrgID)),dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID)) <= @DaysWarningBeforeExpiry
--	and tblQuizExpiryAtRisk.UserID = cam.UserID
--	and tblQuizExpiryAtRisk.ModuleID = cam.ModuleID
--	and tblQuizExpiryAtRisk.OrganisationID = @OrgID
--)
select @OrgID,cam.UserID,
cam.ModuleID,
DateDiff(day,dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID),
dateadd(month, cam.QuizFrequency,
dbo.udfUTCtoDaylightSavingTime(sm.DateTimeCompleted,@OrgID)))
FROM #tblCurrentAssignedModules cam
INNER JOIN #tblStartedModules sm	ON sm.UserID = cam.UserID	AND sm.ModuleID = cam.ModuleID
INNER JOIN tblModule M ON M.moduleID = sm.moduleID
INNER JOIN tblReminderEscalation RemEsc ON  RemEsc.CourseID = M.CourseID
WHERE RemEsc.OrgID = @OrgID AND RemEsc.RemindUsers = 1 AND
(
(
cam.QuizCompletionDate IS NULL
and (dbo.udfUTCtoDaylightSavingTime(	getutcdate(),@OrgID)
>
DateAdd(                -- Expiry date minus days before expiry to warn user
day
,-RemEsc.DaysQuizExpiry
,dateadd( -- Expiry date
month
, cam.QuizFrequency
, dbo.udfUTCtoDaylightSavingTime(sm.DateTimeCompleted,@OrgID)))
)
)
OR

(
cam.QuizCompletionDate IS NOT NULL
and DateDiff(day, dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID), cam.QuizCompletionDate) <= RemEsc.DaysQuizExpiry
)
)
)
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_Update_Quick'',''delete from tblQuizExpiryAtRisk'',''delete from tblQuizExpiryAtRisk'',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_Update_Quick'',1,1,null,getutcdate(),getutcdate()) END



insert into tblQuizExpiryAtRisk -- add users that are now AtRisk that were not already flagged as AtRisk
(
OrganisationID,
UserID,
ModuleID,
DaysToExpiry
)

select @OrgID,cam.UserID,
cam.ModuleID,
CASE WHEN ( cam.QuizFrequency IS NULL )
then DateDiff(day,dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID),
QuizCompletionDate)

ELSE
DateDiff(day,dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID),
dateadd(month, cam.QuizFrequency,
dbo.udfUTCtoDaylightSavingTime(sm.DateTimeCompleted,@OrgID)))
END

FROM #tblCurrentAssignedModules cam
INNER JOIN #tblStartedModules sm	ON sm.UserID = cam.UserID	AND sm.ModuleID = cam.ModuleID
INNER JOIN tblModule M ON M.moduleID = sm.moduleID
INNER JOIN tblReminderEscalation RemEsc ON  RemEsc.CourseID = M.CourseID
WHERE RemEsc.OrgID = @OrgID AND RemEsc.RemindUsers = 1 AND
(
(
cam.QuizCompletionDate IS NULL
and (dbo.udfUTCtoDaylightSavingTime(	getutcdate(),@OrgID)
>
DateAdd(                -- Expiry date minus days before expiry to warn user
day
,-RemEsc.DaysQuizExpiry
,dateadd( -- Expiry date
month
, cam.QuizFrequency
, dbo.udfUTCtoDaylightSavingTime(sm.DateTimeCompleted,@OrgID)))
)
)
OR

(
cam.QuizCompletionDate IS NOT NULL
and DateDiff(day, dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID), cam.QuizCompletionDate) <= RemEsc.DaysQuizExpiry
)
)
and not exists
(SELECT * FROM tblQuizExpiryAtRisk
where 	tblQuizExpiryAtRisk.UserID = cam.UserID
and tblQuizExpiryAtRisk.ModuleID = cam.ModuleID
and tblQuizExpiryAtRisk.OrganisationID = @OrgID)
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_Update_Quick'',''insert into tblQuizExpiryAtRisk'',''insert into tblQuizExpiryAtRisk'',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_Update_Quick'',1,1,null,getutcdate(),getutcdate()) END








drop table  #tblCurrentUserQuizStatus

drop table #tblCurrentAssignedModules

drop table #tblStartedModules
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


SET QUOTED_IDENTIFIER OFF
' 
END
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
																	then CAST((  DATEDIFF(day,getUTCdate(),DATEADD(month,ur.QuizFrequency,vUQS.DateCreated))) AS varchar(6))																														--Passed - unit Default  Quiz frequency specified
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
																	then CAST((  DATEDIFF(day,getUTCdate(),DATEADD(month,ur.quizfrequency,vUQS.DateCreated))) AS varchar(6))																															--Failed - previously passed -unit Default  Quiz frequency specified
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
																	and  DATEDIFF(day,DATEADD(month,ur.quizfrequency,vUQS.DateCreated),getUTCdate())  >= 0 then "1"																																							--Passed - unit Default  Quiz frequency specified
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizFrequency is not null 
																	and DATEDIFF(day,DATEADD(month,o.DefaultQuizFrequency,vUQS.DateCreated),getUTCdate()) < 0 then "0"																																					--Passed - organisation Default  Quiz frequency specified , not expired
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is not null 
																	and  DATEDIFF(day,DATEADD(month,ur.quizfrequency,vUQS.DateCreated),getUTCdate())  < 0  then "0"																																							--Passed - unit Default  Quiz frequency specified , not expired


when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizCompletionDate is not null 
																	and DATEDIFF(day,o.DefaultQuizCompletionDate,getUTCdate()) < 0 then ''0''																																										--failed - previously passed - organisation Default  Quiz Completion Date specified , expired
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is not null 
																	and DATEDIFF(day,ur.QuizCompletionDate,getUTCdate()) > 0 then ''0''																																												--failed - previously passed - unit Default  Quiz Completion Date specified , expired
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizCompletionDate is not null 
																	and DATEDIFF(day,o.DefaultQuizCompletionDate,getUTCdate()) >= 0 then ''1''																																									--failed - previously passed - organisation Default  Quiz Completion Date specified , not expired
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is not null 
																	and DATEDIFF(day,ur.QuizCompletionDate,getUTCdate()) <= 0 then ''1''																																												--failed - previously passed - unit Default  Quiz Completion Date specified , not expired
when QuizStatusID = 3 and LC.DateCreated is not null  and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizFrequency is not null 
																	and DATEDIFF(day,DATEADD(month,o.DefaultQuizFrequency,vUQS.DateCreated),getUTCdate()) >= 0 then "1"																																				--failed - previously passed - organisation Default  Quiz frequency specified
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is not null  
																	and  DATEDIFF(day,getUTCdate(),DATEADD(month,ur.quizfrequency,vUQS.DateCreated)) >= 0 then "1"																																							--failed - previously passed - unit Default  Quiz frequency specified
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizFrequency is not null 
																	and DATEDIFF(day,DATEADD(month,o.DefaultQuizFrequency,vUQS.DateCreated),getUTCdate()) < 0 then "0"																																					--failed - previously passed - organisation Default  Quiz frequency specified
when QuizStatusID = 3 and LC.DateCreated is not null  and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is not null
																	and   DATEDIFF(day,getUTCdate(),DATEADD(month,ur.quizfrequency,vUQS.DateCreated)) < 0	 then "0"																																							--failed - previously passed - unit Default  Quiz frequency specified
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

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcCPD_Report]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcCPD_Report]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcCPD_Report]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure [dbo].[prcCPD_Report]
(
@profileid int = -1,
@profileperiodid int = -1,
@firstname varchar(200)='''',
@lastname varchar(200) ='''',
@username varchar(200)='''',
@shortfallusers smallint=0,
@UnitIDs varchar(max)='''',
@OrgID int
)
as begin


(select
hierarchyname as pathway
, u.lastname as lastname
, u.firstname as firstname
,u.username as username
,u.email as useremail
,c.name as coursee
,m.name collate database_default as module
,coalesce(upt.points,0) as points
,pf.profileid
,dbo.udfUTCtoDaylightSavingTime(upt.DateAssigned, @OrgID) as dateassigned
,m.sequence as modID
from tblProfile pf
join tblprofileperiod pp on pp.profileid = pf.profileid
join tbluserprofileperiodaccess upa on upa.profileperiodid = pp.profileperiodid
and granted = 1
join tbluser  u on u.userid = upa.userid
join tblunithierarchy uh on uh.unitid = u.unitid and u.unitid in (select IntValue from dbo.udfCsvToInt(@unitIDs))
left join tblProfilePoints ppt on ppt.profileperiodid =pp.profileperiodid
left join tblusercpdpoints upt on upt.userid = u.userid	 and upt.profilepointsid = ppt.profilepointsid
left join tblmodule m on m.moduleid = ppt.typeid and profilepointstype =''M''
left join tblcourse c on c.CourseID =  m.courseid
join vwusermoduleaccess uma on u.userid = uma.userid and m.moduleid = uma.moduleid
where
((@profileid= -1) or (pf.profileid = @profileid)) and
((@profileperiodid=-1) or (pp.profileperiodid  = @profileperiodid))and
((@firstname ='''') or (u.firstname=@firstname) ) and
((@lastname ='''') or (u.lastname =@lastname)) and
((@username ='''') or (u.username =@username)) and
((@shortfallusers =0)
or (
(select sum(u2.points) from tblusercpdpoints u2 where u2.userid = u.userid)<pp.points)
or (select sum(u2.points) from tblusercpdpoints u2 where u2.userid = u.userid) is null)
)

union

(select
hierarchyname as pathway
, u.lastname as lastname
, u.firstname as firstname
,u.username as username
,u.email as useremail
,case when policyname is null then '''' else ''Policy'' end as coursee
,coalesce(policyname,'''') collate database_default as module
,coalesce(upt.points,0) as points
,pf.profileid
,dbo.udfUTCtoDaylightSavingTime(upt.DateAssigned, @OrgID) as dateassigned
,null as modID
from tblProfile pf
join tblprofileperiod pp on pp.profileid = pf.profileid
join tbluserprofileperiodaccess upa on upa.profileperiodid = pp.profileperiodid
and granted = 1
join tbluser  u on u.userid = upa.userid
join tblunithierarchy uh on uh.unitid = u.unitid and u.unitid in (select IntValue from dbo.udfCsvToInt(@unitIDs))
left join tblProfilePoints ppt on ppt.profileperiodid =pp.profileperiodid
left join tblusercpdpoints upt on upt.userid = u.userid	 and upt.profilepointsid = ppt.profilepointsid
left join tblpolicy on tblPolicy.policyid = ppt.typeid and profilepointstype =''P''
join tblUserPolicyAccess upola on upola.userid = u.userid and upola.policyid = ppt.typeid and upola.granted = 1
where
(@profileid= -1 or pf.profileid = @profileid) and
(@profileperiodid=-1 or pp.profileperiodid  = @profileperiodid)and
(@firstname ='''' or u.firstname=@firstname ) and
(@lastname ='''' or u.lastname =@lastname) and
(@username ='''' or u.username =@username) and
(@shortfallusers =0
or (
(select sum(u2.points) from tblusercpdpoints u2 where u2.userid = u.userid)<pp.points)
or (select sum(u2.points) from tblusercpdpoints u2 where u2.userid = u.userid) is null)
)
Order by
coursee,
modID


end

SET QUOTED_IDENTIFIER OFF
' 
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcPolicy_GetAdminsInOrgPendingPolicy]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcPolicy_GetAdminsInOrgPendingPolicy]
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'prcPolicy_GetAdminsInOrgPendingPolicy') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
Summary:		Mainly just returns a list of unit admins that meet the flagged conditions

Parameters:		Comma separated list of userID:courseID
Returns:		table (lastname nvarchar(50), firstname nvarchar(50), userid int, email nvarchar(100), policy_name varchar(8000))

Called By:		BusinessServices.{Policy.GetAdminsInOrgPendingPolicy in Policy.cs
Calls:			None

Remarks:		None

Author:			John H
Date Created:	21 MAy 2010

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE PROCEDURE [dbo].[prcPolicy_GetAdminsInOrgPendingPolicy]
@policy_ids varchar(8000),
@unit_ids varchar(max),
@accepted varchar (20),
@acceptedDateFrom 		datetime,
@acceptedDateTo 		datetime
AS
BEGIN
SET NOCOUNT ON;

DECLARE @policies TABLE (policyid int)
DECLARE @selected_units TABLE (unitid int)
DECLARE @result TABLE (firstname nvarchar(50), lastname nvarchar(50), userid int, email nvarchar(100), new_policy_names varchar(8000), modified_policy_names varchar(8000), HierarchyName nvarchar(500))
DECLARE
@pos int,
@colon_pos int,
@temp varchar(50),
@userid int, @admid int,
@new_policy_names varchar(8000),
@users_with_policies varchar(8000),
@modified_policy_names varchar(8000),
@strAccepted varchar(5),
@aunit int,@orgID int

IF @accepted = ''0''
BEGIN
SELECT @strAccepted = ''True''
END
ELSE
BEGIN
SELECT @strAccepted = ''False''
END



-- rip the unit selection
INSERT INTO @selected_units
SELECT
*
FROM
dbo.udfCsvToInt(@unit_ids)

SELECT @policy_ids = replace(rtrim(ltrim(replace(replace(replace(@policy_ids,'' '',''''),'',,'','',''),'','','' ''))),'' '','','') + '',''
SELECT @aunit = (SELECT TOP (1) unitid FROM @selected_units)
SELECT @orgID = OrganisationID FROM tblUnit WHERE tblUnit.UnitID = @aunit


set @acceptedDateFrom = dbo.udfDaylightSavingTimeToUTC(@acceptedDateFrom, @orgID)
set @acceptedDateTo = dbo.udfDaylightSavingTimeToUTC(@acceptedDateTo, @orgID)

-- rip the policies into a table
INSERT INTO @policies
SELECT
*
FROM
dbo.udfCsvToInt(@policy_ids)



--	SELECT DISTINCT adm.UserID, hier.HierarchyName, adm.LastName, adm.FirstName,  adm.email, '''',''''
SELECT DISTINCT adm.UserID, unt.Name as HierarchyName, adm.LastName, adm.FirstName,  adm.email, '''',''''
FROM
@policies pols
INNER JOIN tblUserPolicyAccess polacs ON polacs.policyid = pols.policyid AND polacs.granted = ''True''
INNER JOIN tblUserPolicyAccepted polacd ON polacd.policyid = pols.policyid AND polacd.Accepted = @strAccepted
AND (
((COALESCE(polacd.DateAccepted,CAST(''1/1/1980'' AS DateTime)) >= @acceptedDateFrom) AND (COALESCE(polacd.DateAccepted,CAST(''1/1/2999'' AS DateTime)) < @acceptedDateTo))OR (@strAccepted = ''False''))
INNER JOIN tblUser usr ON usr.userid = polacs.userid AND usr.userid = polacd.userid AND usr.active = ''True''
INNER JOIN @selected_units su ON usr.unitid = su.unitid
INNER JOIN udf_GetAdminEmailsForORG(@orgID) uadm ON uadm.UnitID = su.unitid
INNER JOIN tblUnitHierarchy hier ON hier.UnitID = usr.UnitID
INNER JOIN tblUnit unt ON unt.UnitID = usr.UnitID
INNER JOIN tblUser adm ON adm.userid = uadm.userid
WHERE NOT EXISTS
(SELECT *
FROM
@policies Spols
INNER JOIN tblUserPolicyAccess Spolacs ON Spolacs.policyid = Spols.policyid AND Spolacs.granted = ''True''
INNER JOIN tblUserPolicyAccepted Spolacd ON Spolacd.policyid = Spols.policyid AND Spolacd.Accepted = @strAccepted
AND (
((COALESCE(polacd.DateAccepted,CAST(''1/1/1980'' AS DateTime)) >= @acceptedDateFrom) AND (COALESCE(polacd.DateAccepted,CAST(''1/1/2999'' AS DateTime)) < @acceptedDateTo))OR (@strAccepted = ''False''))
INNER JOIN tblUser Susr ON Susr.userid = Spolacs.userid AND Susr.userid = Spolacd.userid AND Susr.active = ''True''
INNER JOIN @selected_units Ssu ON Susr.unitid = Ssu.unitid
INNER JOIN udf_GetAdminEmailsForORG(@orgID) Suadm ON Suadm.UnitID = Ssu.unitid
INNER JOIN tblUnitHierarchy Shier ON Shier.UnitID = Susr.UnitID
INNER JOIN tblUnit Sunt ON Sunt.UnitID = Susr.UnitID
INNER JOIN tblUser Sadm ON Sadm.userid = Suadm.userid and Sadm.UserID = adm.UserID
WHERE (hier.hierarchy LIKE Shier.hierarchy+'',%'') )





END


SET ANSI_NULLS ON
'
END

GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcPolicy_GetPoliciesInUnit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcPolicy_GetPoliciesInUnit]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPolicy_GetPoliciesInUnit]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:		Compiles a %POLICY_NAMES% block and returns it with a bunch of user info for sending email to that user
(Mainly just returns a list of policies that are assigned to users that meet the flagged conditions)
Parameters:		Comma separated list of userID:courseID
Returns:		table (lastname nvarchar(50), firstname nvarchar(50), userid int, email nvarchar(100), policy_name varchar(8000))

Called By:		BusinessServices.{Policy.prcPolicy_GetUsersByPolicyAndUnit in Policy.cs
Calls:			None

Remarks:		None

Author:			Mark Donald (John R copied prcCourse_UserMashup - no optimising attempted as execution time expected to be small)
Date Created:	13 Nov 2009 (copied 18/05/2010)

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE PROCEDURE [dbo].[prcPolicy_GetPoliciesInUnit]
@policy_ids varchar(8000),
@unit_ids varchar(max),
@accepted varchar (20),
@acceptedDateFrom 		datetime,
@acceptedDateTo 		datetime,
@OrgID int
AS
BEGIN
SET NOCOUNT ON;

set @acceptedDateFrom = dbo.udfDaylightSavingTimeToUTC(@acceptedDateFrom, @OrgID)
set @acceptedDateTo = dbo.udfDaylightSavingTimeToUTC(@acceptedDateTo, @OrgID)

DECLARE @policies TABLE (policyid int)
DECLARE @selected_units TABLE (unitid int)
DECLARE @result TABLE (policy_names varchar(8000))
DECLARE
@pos int,
@colon_pos int,
@temp varchar(50),
@userid int,
@policy_names varchar(8000),
@modified_policy_names varchar(8000),
@strAccepted varchar(5)



IF @accepted = ''0''
BEGIN
SELECT @strAccepted = ''True''
END
ELSE
BEGIN
SELECT @strAccepted = ''False''
END



-- rip the user selection
INSERT INTO @selected_units
SELECT
*
FROM
dbo.udfCsvToInt(@unit_ids)

-- clean up the input so it resembles ''userid:policyid,userid:policyid,''
SELECT @policy_ids = replace(rtrim(ltrim(replace(replace(replace(@policy_ids,'' '',''''),'',,'','',''),'','','' ''))),'' '','','') + '',''

-- rip the policies into a table
INSERT INTO @policies
SELECT
*
FROM
dbo.udfCsvToInt(@policy_ids)
-- Note to self: String operations take hundreds of times longer than cursor operations so first think of a way to limit the number of string operations, then get rid of the cursors.


SELECT DISTINCT pol.PolicyName
FROM
@policies pols
INNER JOIN tblPolicy pol ON pol.PolicyID = pols.PolicyID
INNER JOIN tblUserPolicyAccess polacs ON polacs.policyid = pols.policyid AND polacs.granted = ''True''
INNER JOIN tblUserPolicyAccepted polacd ON polacd.policyid = pols.policyid AND polacd.Accepted = @strAccepted
AND (
((COALESCE(polacd.DateAccepted,CAST(''1/1/1980'' AS DateTime)) >= @acceptedDateFrom) AND (COALESCE(polacd.DateAccepted,CAST(''1/1/2999'' AS DateTime)) < @acceptedDateTo))OR (@strAccepted = ''False''))

INNER JOIN tblUser usr ON usr.userid = polacs.userid AND usr.userid = polacd.userid AND usr.active = ''True''
INNER JOIN @selected_units su ON usr.unitid = su.unitid
END
'
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcPolicy_GetUserAndPoliciesForAdmins]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcPolicy_GetUserAndPoliciesForAdmins]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPolicy_GetUserAndPoliciesForAdmins]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:		Compiles a %USER-POLICY_NAMES% block and returns it with a bunch of user info for sending email to that user


Parameters:		Comma separated list of adminuserID,policyID,unitID
Returns:		table (lastname nvarchar(50), firstname nvarchar(50), userid int, email nvarchar(100), policy_name varchar(8000))

Called By:		BusinessServices.{Policy.GetUserAndPoliciesForAdmins in Policy.cs
Calls:			None

Remarks:		None

Author:			John H
Date Created:	21 May 2010

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE PROCEDURE [dbo].[prcPolicy_GetUserAndPoliciesForAdmins]
@admin_ids varchar(8000),
@policy_ids varchar(8000),
@unit_ids varchar(max),
@accepted varchar (20),
@acceptedDateFrom 		datetime,
@acceptedDateTo 		datetime,
@OrgID int
AS
BEGIN
SET NOCOUNT ON;

set @acceptedDateFrom = dbo.udfDaylightSavingTimeToUTC(@acceptedDateFrom, @OrgID)
set @acceptedDateTo = dbo.udfDaylightSavingTimeToUTC(@acceptedDateTo, @OrgID)

DECLARE @policies TABLE (policyid int)
DECLARE @selected_units TABLE (unitid int)
DECLARE @selected_admins TABLE (userid int)
DECLARE @result TABLE (firstname nvarchar(50), policyname nvarchar(50), userid int, email nvarchar(100), user_list varchar(8000), PolicyID int, HierarchyName nvarchar(500))

DECLARE
@pos int,
@colon_pos int,
@temp varchar(50),
@admid int , @PolicyID int,
@PolicyName varchar(8000),
@user_list varchar(8000),
@users_with_policies varchar(8000),
@modified_policy_names varchar(8000),
@strAccepted varchar(5),
@aunit int


IF @accepted = ''0''
BEGIN
SELECT @strAccepted = ''True''
END
ELSE
BEGIN
SELECT @strAccepted = ''False''
END



-- rip the unit selection
INSERT INTO @selected_units
SELECT
*
FROM
dbo.udfCsvToInt(@unit_ids)

SELECT @aunit = (SELECT TOP (1) unitid FROM @selected_units)

-- rip the admin selection
INSERT INTO @selected_admins
SELECT
*
FROM
dbo.udfCsvToInt(@admin_ids)




SELECT @policy_ids = replace(rtrim(ltrim(replace(replace(replace(@policy_ids,'' '',''''),'',,'','',''),'','','' ''))),'' '','','') + '',''

-- rip the policies into a table
INSERT INTO @policies
SELECT
*
FROM
dbo.udfCsvToInt(@policy_ids)
-- Note to self: String operations take hundreds of times longer than cursor operations so first think of a way to limit the number of string operations, then get rid of the cursors.

SELECT @user_list = ''''
DECLARE concatenator CURSOR READ_ONLY FOR
SELECT DISTINCT
uadm.userid , pol.PolicyName, pol.policyid
FROM
tblpolicy pol
INNER JOIN @policies pols ON pol.policyid = pols.policyid
INNER JOIN tblUserPolicyAccess polacc ON polacc.policyid = pol.policyid AND polacc.granted = ''True''
INNER JOIN tblUserPolicyAccepted polacd ON polacd.policyid = pols.policyid AND polacd.Accepted = @strAccepted
AND (
((COALESCE(polacd.DateAccepted,CAST(''1/1/1980'' AS DateTime)) >= @acceptedDateFrom) AND (COALESCE(polacd.DateAccepted,CAST(''1/1/2999'' AS DateTime)) < @acceptedDateTo))OR (@strAccepted = ''False''))

INNER JOIN tblUser u ON u.userid = polacc.userid AND u.userid = polacd.userid AND u.active = ''True''
INNER JOIN udf_GetAdminEmailsForORG(@orgID) uadm ON u.UnitID = uadm.unitid
INNER JOIN tblUnitHierarchy hier ON hier.UnitID = u.UnitID
INNER JOIN @selected_units su ON su.unitID = u.unitid
INNER JOIN @selected_admins sa on sa.userid = uadm.userid
ORDER BY uadm.userid
OPEN concatenator
FETCH NEXT FROM concatenator INTO @admID , @policyName, @PolicyID
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @user_list = COALESCE(@user_list,'''') +  char(13) + char(10) + char(9)  + u.FirstName + '' '' + u.LastName
FROM
tblpolicy pol
INNER JOIN @policies pols ON pol.policyid = pols.policyid AND pol.policyid = @PolicyID
INNER JOIN tblUserPolicyAccess polacc ON polacc.policyid = pol.policyid AND polacc.granted = ''True''
INNER JOIN tblUserPolicyAccepted polacd ON polacd.policyid = pols.policyid AND polacd.Accepted = @strAccepted
AND (
((COALESCE(polacd.DateAccepted,CAST(''1/1/1980'' AS DateTime)) >= @acceptedDateFrom) AND (COALESCE(polacd.DateAccepted,CAST(''1/1/2999'' AS DateTime)) < @acceptedDateTo))OR (@strAccepted = ''False''))

INNER JOIN tblUser u ON u.userid = polacc.userid AND u.userid = polacd.userid AND u.active = ''True''
INNER JOIN udf_GetAdminEmailsForORG(@orgID) uadm ON u.UnitID = uadm.unitid AND uadm.userid = @admid
INNER JOIN tblUnitHierarchy hier ON hier.UnitID = u.UnitID
INNER JOIN @selected_units su ON su.unitID = u.unitid
ORDER BY u.LastName , u.FirstName

INSERT INTO
@result
SELECT
adm.firstName+'' ''+adm.lastname, @policyName, adm.userid, adm.email, @user_list, @PolicyID, unt.HierarchyName
FROM
tblUser adm
INNER JOIN tblUnitHierarchy unt ON unt.unitid = adm.unitid AND adm.userid = @admID AND adm.active = ''True''

SELECT @user_list = ''''

FETCH NEXT FROM concatenator INTO @admID , @policyName, @PolicyID
END
CLOSE concatenator
DEALLOCATE concatenator


--Get Data in report format
SELECT
DISTINCT UserID, HierarchyName, PolicyName, FirstName,  email, user_list, PolicyID
FROM @result
END
'
END

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcPolicy_GetUsersByPolicyAndUnit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcPolicy_GetUsersByPolicyAndUnit]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPolicy_GetUsersByPolicyAndUnit]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:		Compiles a %POLICY_NAMES% block and returns it with a bunch of user info for sending email to that user
(Mainly just returns a list of users and the policies that they are assigned to (that meet the flagged conditions))

Parameters:		Comma separated list of userID:courseID
Returns:		table (lastname nvarchar(50), firstname nvarchar(50), userid int, email nvarchar(100), policy_name varchar(8000))

Called By:		BusinessServices.{Policy.GetUsersByPolicyAndUnit in Policy.cs
Calls:			None

Remarks:		None

Author:			Mark Donald (John R copied prcCourse_UserMashup - no optimising attempted as execution time expected to be small)
Date Created:	13 Nov 2009 (copied 18/05/2010)

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE PROCEDURE [dbo].[prcPolicy_GetUsersByPolicyAndUnit]
@policy_ids varchar(8000),
@unit_ids varchar(max),
@accepted varchar (20),
@acceptedDateFrom 		datetime,
@acceptedDateTo 		datetime
AS
BEGIN
SET NOCOUNT ON;

DECLARE @policies TABLE (policyid int)
DECLARE @selected_units TABLE (unitid int)
DECLARE @result TABLE (firstname nvarchar(50), lastname nvarchar(50), userid int, email nvarchar(100), new_policy_names varchar(8000), modified_policy_names varchar(8000), HierarchyName nvarchar(500))
DECLARE
@pos int,
@colon_pos int,
@temp varchar(50),
@userid int,
@new_policy_names varchar(8000),
@modified_policy_names varchar(8000),
@strAccepted varchar(5)



IF @accepted = ''0''
BEGIN
SELECT @strAccepted = ''True''
END
ELSE
BEGIN
SELECT @strAccepted = ''False''
END



-- rip the user selection
INSERT INTO @selected_units
SELECT
*
FROM
dbo.udfCsvToInt(@unit_ids)

-- clean up the input so it resembles ''userid:policyid,userid:policyid,''
SELECT @policy_ids = replace(rtrim(ltrim(replace(replace(replace(@policy_ids,'' '',''''),'',,'','',''),'','','' ''))),'' '','','') + '',''

-- rip the policies into a table
INSERT INTO @policies
SELECT
*
FROM
dbo.udfCsvToInt(@policy_ids)
-- Note to self: String operations take hundreds of times longer than cursor operations so first think of a way to limit the number of string operations, then get rid of the cursors.
SELECT @new_policy_names = ''''
SELECT @modified_policy_names = ''''
DECLARE concatenator CURSOR READ_ONLY FOR
SELECT DISTINCT
usr.userid
FROM
@policies pols
INNER JOIN tblUserPolicyAccess polacs ON polacs.policyid = pols.policyid AND polacs.granted = ''True''
INNER JOIN tblUserPolicyAccepted polacd ON polacd.policyid = pols.policyid AND polacd.Accepted = @strAccepted
AND (
((COALESCE(polacd.DateAccepted,CAST(''1/1/1980'' AS DateTime)) >= @acceptedDateFrom) AND (COALESCE(polacd.DateAccepted,CAST(''1/1/2999'' AS DateTime)) < @acceptedDateTo))OR (@strAccepted = ''False''))

INNER JOIN tblUser usr ON usr.userid = polacs.userid AND usr.userid = polacd.userid AND usr.active = ''True''
INNER JOIN @selected_units su ON usr.unitid = su.unitid
OPEN concatenator
FETCH NEXT FROM concatenator INTO @userid
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT
@new_policy_names = @new_policy_names + [PolicyName] + char(13) + char(10) + char(9)
FROM
tblpolicy pol
INNER JOIN @policies pols ON	pol.policyid = pols.policyid
INNER JOIN tblUserPolicyAccess polacc ON polacc.policyid = pol.policyid AND polacc.granted = ''True''
INNER JOIN tblUserPolicyAccepted polacd ON polacd.policyid = pols.policyid AND polacd.Accepted = @strAccepted
AND (
((COALESCE(polacd.DateAccepted,CAST(''1/1/1980'' AS DateTime)) >= @acceptedDateFrom) AND (COALESCE(polacd.DateAccepted,CAST(''1/1/2999'' AS DateTime)) < @acceptedDateTo))OR (@strAccepted = ''False''))

INNER JOIN tblUser usr ON usr.userid = polacc.userid AND usr.active = ''True'' AND usr.userid = @userid

SELECT @new_policy_names = substring(@new_policy_names, 1, len(@new_policy_names) - 3)

INSERT INTO
@result
SELECT
usr.firstname, usr.lastname, usr.userid, usr.email, @new_policy_names, @modified_policy_names, hier.HierarchyName
FROM
tbluser usr
INNER JOIN tblUnitHierarchy hier ON hier.UnitID = usr.UnitID
WHERE
userid = @userid
SELECT @new_policy_names = ''''
SELECT @modified_policy_names = ''''
FETCH NEXT FROM concatenator INTO @userid
END
CLOSE concatenator
DEALLOCATE concatenator


--Get Data in report format
SELECT
DISTINCT UserID, HierarchyName, LastName, FirstName,  email, new_policy_names, modified_policy_names

FROM @result
END
'
END 

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcPolicy_UserSearch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcPolicy_UserSearch]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPolicy_UserSearch]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Returns results of search for users on Assign Users tab of CPDdetail.aspx

Returns:

Called By:

Calls:

Remarks:
The searching units will include all children and grandchildren
Only return users that logged on user has permission to see


Author: Aaron Cripps
Date Created: Feb 2009

Modification History
-----------------------------------------------------------
v#	Author		Date			Description

**/

CREATE  Procedure  [dbo].[prcPolicy_UserSearch]
(
@organisationID  Int,
@PolicyID int,
@parentUnitIDs  Varchar(max),
@firstName	nVarchar(50),
@lastName	nVarchar(50),
@userName	nVarChar(100),
@Email		nVarChar(100),
@ExternalID nVarChar(50),
@adminUserID		Int,
@Type nvarchar(50)
)
As
Set Nocount On

Declare @intUserTypeID Int

Select @intUserTypeID = UserTypeID
From tblUser
Where userID = @adminUserID



--Check Data
If @parentUnitIDs is null
set @parentUnitIDs =''''

If @firstName is null
Set @firstName = ''''

Set @firstName =rtrim(@firstName)

If @lastName is null
Set @lastName = ''''

Set @lastName =rtrim(@lastName)

If @userName is null
Set @userName = ''''

set @userName = rtrim(@userName)

if @Email is null
set @Email = ''''

set @Email = rtrim(@Email)

if @ExternalID is null
set @ExternalID = ''''

set @ExternalID = rtrim(@ExternalID)

if @Type = ''search''
Begin
Select
us.UserID,
us.UserName,
us.FirstName,
case
When us.Active = 0 then us.LastName + ''(I)''
Else us.LastName
end as LastName,
case
When us.LastLogin Is Null then ''Never''
Else cast(us.LastLogin as varchar)
end as LastLogin,
dbo.udfGetUnitPathway(us.UnitID) as Pathway,
us.Active,
upa.Granted

From tblUnit un, tblUser us, tblUserPolicyAccess upa

Where (un.OrganisationID = @organisationID)
and
(
us.Active=1
)
--0. Join Unit and User tables
and (
un.UnitID = us.UnitID
)
-- Join User and UserProfilePeriodAccess tables
and (
us.UserID = upa.UserID
)
and (
upa.PolicyID = @PolicyID
)
--1. Within the selected Parent Units (can select multiple units)
--The unit hierarchy contains the parent Unit ID
and (
un.UnitID in
(
Select IntValue from dbo.udfCsvToInt(@parentUnitIDs)
)
or (@parentUnitIDs='''')
)
--2. User firstname contains the entered text
and (
(firstname like ''%''+ @firstName + ''%'')
or (firstname ='''')
)
--3. User lastname contains the entered text
and (
(lastname like ''%''+ @lastName + ''%'')
or (lastname ='''')
)
-- User username contains the entered text
and (
(username like ''%'' + @userName + ''%'')
or (userName='''')
)
-- User email contains the entered text
and (
(email like ''%'' + @Email + ''%'')
or (email='''') or (email = null)
)
-- User externalid contains the entered text
and (
(externalID like ''%'' + @ExternalID + ''%'')
or (externalID = '''') or (externalid = null)
)
--4. Permission
--Salt Administrator(1), Organisation Administrator(2) has permission to access all units
--Unit Administrator(3) only has permission to those that he is administrator
and (
(@intUserTypeID<3)
or (un.UnitID in (select UnitID from tblUnitAdministrator where UserID=@adminUserID))
)
Order By Name
End
else if @Type = ''view''
Begin
Select
us.UserID,
us.UserName,
us.FirstName,
case
When us.Active = 0 then us.LastName + ''(I)''
Else us.LastName
end as LastName,
case
When us.LastLogin Is Null then ''Never''
Else cast(us.LastLogin as varchar)
end as LastLogin,
dbo.udfGetUnitPathway(us.UnitID) as Pathway,
us.Active,
upa.Granted

From tblUnit un, tblUser us, tblUserPolicyAccess upa

Where (un.OrganisationID = @organisationID)
and
(
us.Active=1
)
--0. Join Unit and User tables
and (
un.UnitID = us.UnitID
)
-- Join User and UserProfilePeriodAccess tables
and (
us.UserID = upa.UserID
)
and (
upa.PolicyID = @PolicyID
)
--1. Within the selected Parent Units (can select multiple units)
--The unit hierarchy contains the parent Unit ID
--and (
--un.UnitID in
--	(
--		Select IntValue from dbo.udfCsvToInt(@parentUnitIDs)
--	)
--	or (@parentUnitIDs='''')
--	)
--2. User firstname contains the entered text
--and (
--	(firstname like ''%''+ @firstName + ''%'')
--	or (firstname ='''')
--    )
--3. User lastname contains the entered text
--and (
--	(lastname like ''%''+ @lastName + ''%'')
--	or (lastname ='''')
--    )
-- User username contains the entered text
--and (
--	(username like ''%'' + @userName + ''%'')
--	or (userName='''')
--	)
-- User email contains the entered text
--and (
--	(email like ''%'' + @Email + ''%'')
--	or (email='''') or (email = null)
--	)
-- User externalid contains the entered text
--and (
--	(externalID like ''%'' + @ExternalID + ''%'' )
--	or (externalID = '''') or (externalid = null)
--	)
--4. Permission
--Salt Administrator(1), Organisation Administrator(2) has permission to access all units
--Unit Administrator(3) only has permission to those that he is administrator
and (
(@intUserTypeID<3)
or (un.UnitID in (select UnitID from tblUnitAdministrator where UserID=@adminUserID))
)
and upa.Granted=1
Order By Name
End
'
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_AtRisk]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcReport_AtRisk]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_AtRisk]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/******************************************************************************
**		File:
**		Name: prcReport_AtRisk
**		Desc: Returns a list of users who have failed a quiz the specified
**				of times.
**
**		Auth: Mark Donald
**		Date: 23 Dec 2009
**
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**      09/06/2011	j hedlefs			timezone
*******************************************************************************/


CREATE       Procedure [dbo].[prcReport_AtRisk]
(
@organisationID int,
@unitIDs varchar(max),
@courseIDs varchar(8000),
@failCounter int,
@dateFrom datetime,
@dateTo datetime,
@classificationID int
)
AS
SET NOCOUNT ON

DECLARE @Units TABLE (UnitID INT PRIMARY KEY(UnitID))
DECLARE @Courses TABLE (CourseID INT PRIMARY KEY(CourseID))
DECLARE @Users TABLE(UserID INT , UnitID INT PRIMARY KEY(UserID, UnitID))

INSERT INTO @Courses SELECT * FROM dbo.udfCsvToInt(@courseIDs)
INSERT INTO @Units SELECT * FROM  dbo.udfCsvToInt(@unitIDs)

--Get All the users for all specfied units, matching Custom Classification option (if provided)
INSERT INTO @Users
SELECT
DISTINCT A.UserID, A.UnitiD
FROM
tblUser A
JOIN @Units B ON A.UnitID = B.UnitID
JOIN tblUnit C ON B.UnitID = C.UnitID AND C.Active = 1
LEFT JOIN tblUserClassification uc ON uc.UserID  = A.UserID
WHERE
A.Active = 1
AND ((@classificationID =0) OR (classificationID = @classificationID))
--If classification is Any (0), This will find users of any Custom Classification

BEGIN
SELECT
s.userid, s.moduleid, hierarchyname as unitpathway, lastname, firstname, externalid, email, username, c.[name] as coursename, m.[name] as modulename, failnumber, [status] as currentstatus
FROM
(SELECT
q.userid, moduleid,
sum(CASE quizstatusid WHEN 3 THEN 1 ELSE 0 END) AS failnumber,
max(userquizstatusid) AS currentstatusid
FROM
tbluserquizstatus q, tbluser u
WHERE
q.userid = u.userid
AND organisationid = @organisationID
AND q.datecreated BETWEEN dbo.udfDaylightSavingTimeToUTC(@dateFrom,@OrganisationID) AND dateadd(dd, 1, dbo.udfDaylightSavingTimeToUTC(@dateTo,@OrganisationID))
GROUP BY
q.userid, moduleid
HAVING
sum(CASE quizstatusid WHEN 3 THEN 1 ELSE 0 END) >= @failCounter) s
LEFT JOIN tblusermoduleaccess a ON
a.userid = s.userid AND a.moduleid = s.moduleid
JOIN tbluser u ON
u.userid = s.userid
LEFT JOIN tblunitmoduleaccess n ON
n.unitid = u.unitid AND s.moduleid = deniedmoduleid,
tbluserquizstatus uq,
@Users x,
@Courses w,
tblmodule m,
tblcourse c,
tblquizstatus q,
tblunithierarchy h
WHERE
(
(deniedmoduleid IS NULL AND a.moduleid IS NULL)
OR a.granted = 1
)
AND uq.userquizstatusid = s.currentstatusid
AND x.userid = s.userid
AND m.moduleid = s.moduleid
AND c.courseid = m.courseid
AND w.courseid = m.courseid
AND q.quizstatusid = uq.quizstatusid
AND h.unitid = u.unitid
ORDER BY
unitpathway, lastname, firstname
END
'
End

GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_AtRiskGrandTotal]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcReport_AtRiskGrandTotal]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_AtRiskGrandTotal]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/******************************************************************************
**		File:
**		Name: prcReport_AtRisk
**		Desc: Returns a list of users who have failed a quiz the specified
**				of times.
**
**		Auth: Mark Donald
**		Date: 23 Dec 2009
**
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**    09/06/2011	j hedlefs			timezone
*******************************************************************************/


CREATE       Procedure [dbo].[prcReport_AtRiskGrandTotal]
(
@organisationID int,
@unitIDs varchar(max),
@courseIDs varchar(8000),
@failCounter int,
@dateFrom datetime,
@dateTo datetime,
@classificationID int
)
AS
SET NOCOUNT ON

DECLARE @Units TABLE (UnitID INT PRIMARY KEY(UnitID))
DECLARE @Courses TABLE (CourseID INT PRIMARY KEY(CourseID))
DECLARE @Users TABLE(UserID INT , UnitID INT PRIMARY KEY(UserID, UnitID))

INSERT INTO @Courses SELECT * FROM dbo.udfCsvToInt(@courseIDs)
INSERT INTO @Units SELECT * FROM  dbo.udfCsvToInt(@unitIDs)

--Get All the users for all specfied units, matching Custom Classification option (if provided)
INSERT INTO @Users
SELECT
DISTINCT A.UserID, A.UnitiD
FROM
tblUser A
JOIN @Units B ON A.UnitID = B.UnitID
JOIN tblUnit C ON B.UnitID = C.UnitID AND C.Active = 1
LEFT JOIN tblUserClassification uc ON uc.UserID  = A.UserID
WHERE
A.Active = 1
AND ((@classificationID =0) OR (classificationID = @classificationID))
--If classification is Any (0), This will find users of any Custom Classification

BEGIN
SELECT
count(DISTINCT s.userid) AS TotalDistinctUsers
FROM
(SELECT
q.userid, moduleid,
sum(CASE quizstatusid WHEN 3 THEN 1 ELSE 0 END) AS failnumber,
max(userquizstatusid) AS currentstatusid
FROM
tbluserquizstatus q, tbluser u
WHERE
q.userid = u.userid
AND organisationid = @organisationID
AND q.datecreated BETWEEN dbo.udfDaylightSavingTimeToUTC(@dateFrom,@OrganisationID) AND dateadd(dd, 1, dbo.udfDaylightSavingTimeToUTC(@dateTo,@OrganisationID))
GROUP BY
q.userid, moduleid
HAVING
sum(CASE quizstatusid WHEN 3 THEN 1 ELSE 0 END) >= @failCounter) s
LEFT JOIN tblusermoduleaccess a ON
a.userid = s.userid AND a.moduleid = s.moduleid
JOIN tbluser u ON
u.userid = s.userid
LEFT JOIN tblunitmoduleaccess n ON
n.unitid = u.unitid AND s.moduleid = deniedmoduleid,
tbluserquizstatus uq,
@Users x,
@Courses w,
tblmodule m,
tblcourse c,
tblquizstatus q,
tblunithierarchy h
WHERE
(
(deniedmoduleid IS NULL AND a.moduleid IS NULL)
OR a.granted = 1
)
AND uq.userquizstatusid = s.currentstatusid
AND x.userid = s.userid
AND m.moduleid = s.moduleid
AND c.courseid = m.courseid
AND w.courseid = m.courseid
AND q.quizstatusid = uq.quizstatusid
AND h.unitid = u.unitid

END
'
END


GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_CompletedUsersDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcReport_CompletedUsersDetails]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_CompletedUsersDetails]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:
Given an list of incomplete users, derive all of the module status explaining why the users
are incomplete

Returns:
Table of Incomplete Users with the module status details

Called By:
Reporting/Advanced/CompletedUsersReport.aspx

Calls:
udfReport_IncompletUsers_logic

Remarks:


Author:
Yoppy Suwanto

Date Created: 05 Mar 2008

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1  Mark Donald	24/07/2009		Add LastCompleted col to selects

prcReport_CompletedUsersDetails @unitIDs=''1,2,3,4'' , @courseID=1 , @completed = 0
prcReport_CompletedUsersDetails @organisationid=11, @unitIDs=null , @courseID=53, @effectivedate = null

--------------------

**/
CREATE            Proc [dbo].[prcReport_CompletedUsersDetails]
(
@organisationID Integer,	-- Organisation of the current user
@unitIDs varchar(max) = '''',	-- string of unit ids
@courseID int,					-- course ID to restrict search to
@effectiveDateOrg datetime = Null	-- Effective date as at when to run the report
--@completed bit = 0 			-- always run for incomplete status
)
AS
begin
/*
declare @orgid int
declare @courseid int
declare @unitids varchar(8000)
declare @effectivedate datetime

set @orgid = 11
set @courseid = 53
set @unitids = null
set @effectivedate = ''4 August 2007''
*/

DECLARE @effectiveDate DateTime
SET @effectiveDate = dbo.udfDaylightSavingTimeToUTC(@effectiveDateOrg,@OrganisationID)

if (@effectiveDateOrg is null)
/*
-- Report on current latest date
*/
Begin

select max(userquizstatusid) userquizstatusid
into #tmpUserQuizStatus
from tblUserQuizStatus
where userid in (select userid from tblUser where organisationid = @organisationID)
and moduleid in (select moduleid from tblModule where courseid = @courseid)
group by userid, moduleid

Select
IU.userID
, IU.unitID
, IU.FirstName
, IU.LastName
, IU.UnitPathway
, case when lastcompleted is null then ''Never'' else convert(varchar(10),dbo.udfUTCtoDaylightSavingTime(LastCompleted,@OrganisationID),103) end  as LastCompleted
, IU.Username
, IU.Email
, IU.ExternalID
, tM.[name] as ''Module''
, tQS.status
--,tM.moduleid
--,tUQS.quizstatusid
--,tUQS.userquizstatusid

From
dbo.udfReport_IncompleteUsersLogic(@organisationID, @unitIDs, @courseID,null) IU
inner join tblUserQuizStatus tUQS
on tUQS.userid = IU.userid
--inner join tmpUserQuizStatis UQS
--      on tUQS.userquizstatusid = UQS.userquizstatusid
inner join tblModule tM
on tUQS.moduleid = tM.moduleid
inner join tblQuizStatus tQS
on tQS.quizstatusid = tUQS.quizstatusid

Where
--tUQS.quizstatusid <> 2 --Every status except pass quiz status
tUQS.quizstatusid in (1,3,4,5)
and tUQS.moduleid in (select moduleid from tblModule where courseid = @courseid)
and tUQS.userquizstatusid in (select userquizstatusid from #tmpUserQuizStatus)

Order By
UnitPathway, LastName, FirstName,  tM.sequence

drop table #tmpUserQuizStatus

end

Else
-- Report results up to the effective date
Begin


select max(userquizstatusid) userquizstatusid
into #tmpUserQuizStatusDate
from tblUserQuizStatus
where userid in (select userid from tblUser where organisationid = @organisationID)
and moduleid in (select moduleid from tblModule where courseid = @courseid)
and Datecreated < @effectiveDate
group by userid, moduleid

Select
IU.userID
, IU.unitID
, IU.FirstName
, IU.LastName
, IU.UnitPathway
, case when lastcompleted is null then ''Never'' else convert(varchar(10),dbo.udfUTCtoDaylightSavingTime(LastCompleted,@OrganisationID),103) end  as LastCompleted
, IU.Username
, IU.Email
, IU.ExternalID
, tM.[name] as ''Module''
, tQS.status
--,tM.moduleid
--,tUQS.quizstatusid
--,tUQS.userquizstatusid

From
dbo.udfReport_IncompleteUsersLogic(@organisationID, @unitIDs, @courseID,@effectiveDate) IU
inner join tblUserQuizStatus tUQS
on tUQS.userid = IU.userid
--inner join tmpUserQuizStatis UQS
--      on tUQS.userquizstatusid = UQS.userquizstatusid
inner join tblModule tM
on tUQS.moduleid = tM.moduleid
inner join tblQuizStatus tQS
on tQS.quizstatusid = tUQS.quizstatusid

Where
--tUQS.quizstatusid <> 2 --Every status except pass quiz status
tUQS.quizstatusid in (1,3,4,5)
and tUQS.moduleid in (select moduleid from tblModule where courseid = @courseid)
and tUQS.userquizstatusid in (select userquizstatusid from #tmpUserQuizStatusDate)

Order By
UnitPathway, LastName, FirstName, tM.sequence

drop table #tmpUserQuizStatusDate

end
END
'
END

GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_CourseStatusGrandTotal]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcReport_CourseStatusGrandTotal]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_CourseStatusGrandTotal]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/******************************************************************************
**		Name: prcReport_CourseStatusGrandTotal
**		Desc: a copy of prcreport_CourseStatusSearch, but with select statements
**				altered to return a total, instead of a list of data.
**
**		Return values: Grand Total distinct users in Course Status report
**
**		Called by:
**
**		Parameters:
**		Input							Output
**     ----------							-----------
**
**		Auth: Mark Donald
**		Date: 27 Aug 2009
**
*******************************************************************************/

CREATE       Procedure [dbo].[prcReport_CourseStatusGrandTotal]
(
@organisationID		int,
@unitIDs 		varchar(max),
@courseIDs 		varchar(8000),
@courseModuleStatus	int,
@dateFromOrg 		datetime,
@dateToOrg 		datetime,
@IncludeInactive int,
@classificationID int
)
AS
------------------------------------------
Set Nocount On
DECLARE @dateFrom 		datetime
DECLARE @dateTo 		datetime
SET @dateFrom = dbo.udfDaylightSavingTimeToUTC(@dateFromOrg,@OrganisationID)
SET @dateTo = dbo.udfDaylightSavingTimeToUTC(@dateToOrg,@OrganisationID)
Declare
@CONST_INCOMPLETE     	int,
@CONST_COMPLETE     	int,
@CONST_FAILD            int,
@CONST_NOTSTARTED 	    int,
@CONST_EXPIRED_TIMELAPSED		int,
@CONST_EXPIRED_NEWCONTENT		int

set @CONST_INCOMPLETE	= 0
set @CONST_COMPLETE	= 1
set @CONST_FAILD	= 2
set @CONST_NOTSTARTED	= 3
set @CONST_EXPIRED_TIMELAPSED   = 4
set @CONST_EXPIRED_NEWCONTENT	= 5

DECLARE @Units TABLE
(
UnitID INT PRIMARY KEY(UnitID)
)

DECLARE @Courses TABLE
(
CourseID INT PRIMARY KEY(CourseID)
)

DECLARE @CoursesWithAccess 	TABLE (CourseID INT PRIMARY KEY(CourseID))
DECLARE @UserModuleWithAccess TABLE(UserID INT, ModuleID INT, UnitID INT PRIMARY KEY(UserID, ModuleID, UnitID))
DECLARE @AllModules TABLE(ModuleID INT PRIMARY KEY(ModuleID))
DECLARE @Users TABLE(UserID INT , UnitID INT PRIMARY KEY(UserID, UnitID))
DECLARE @UsersNQuizStatus
TABLE
(
UserID	INT,
ModuleID INT,
LatestQuizID INT,
QuizStatusID INT,
QuizScore INT
PRIMARY KEY(UserID, ModuleID, LatestQuizID, QuizStatusID)
)

DECLARE @UsersQuizStatusNOTSTARTED
TABLE
(
UserID	INT,
ModuleID INT,
LatestQuizID INT,
QuizStatusID INT,
QuizScore INT
PRIMARY KEY(UserID, ModuleID, LatestQuizID, QuizStatusID)
)

INSERT INTO @Courses SELECT * FROM dbo.udfCsvToInt(@courseIDs)

INSERT INTO @Units SELECT * FROM  dbo.udfCsvToInt(@unitIDs)

--Get Rid of courses which do not have access to specified org
INSERT INTO @CoursesWithAccess
SELECT A.CourseID FROM @Courses A, tblOrganisationCourseAccess B, tblCourse C
WHERE A.CourseID = B.GrantedCourseID AND B.OrganisationID = @organisationID AND
A.CourseID = C.CourseID AND C.Active = 1

--Get All the users for all specfied units, matching Custom Classification option (if provided)
INSERT INTO @Users
SELECT
DISTINCT A.UserID, A.UnitiD
FROM
tblUser A
join @Units B on A.UnitID = B.UnitID
join tblUnit C on B.UnitID = C.UnitID AND C.Active = 1
LEFT JOIN tblUserClassification uc ON uc.UserID  = A.UserID
WHERE
A.Active = CASE @IncludeInactive WHEN 0 THEN 1 ELSE A.Active END
AND ((@classificationID =0) OR (classificationID = @classificationID))
--If classification is Any (0), This will find users of any Custom Classification



if @courseModuleStatus = @CONST_COMPLETE or @courseModuleStatus = @CONST_INCOMPLETE
begin -- completed / -- InComplete
--------------------
-- Completed --
--------------------
-- A user is completed if they became complete and remained completed in the period of interest
-- the query only needs to check to see status at the max date in this period as a line item
-- as tblUserCourseStatus is only writen to when an event occours that would
-- change the status.
-- When "Course/Module Status" is set to "Complete"
-- This will find users that:
-- - Belong to any of the Units in @unitIDs
-- - AND are currently assigned Modules from the selected Course
-- - AND have (at the end of the time-period in question) got a status of Complete in tblUserCourseStatus
-- - AND the event that made them complete happened some time in the time-period in question
--------------------
-- InComplete
--------------------
-- A user is in-completed if for any reason they are not complete but do have access to the course
-- This will find users that:
-- - Belong to any of the Units in @unitIDs
-- - AND are currently assigned Modules from the selected Courses
-- - AND have (at the end of the time-period in question) got a status of Incomplete in tblUserCourseStatus
-- - AND the event that made them complete happened some time in the time-period in question

--Find the latest status of courses
SELECT
count(distinct A.UserID) AS TotalDistinctUsers
FROM
(
SELECT
A.UserID, A.CourseID, MAX(A.UserCourseStatusID) AS ''LatestCourseStatus''
FROM
tblUserCourseStatus A, @CoursesWithAccess B
WHERE
A.DateCreated < DATEADD(DD, 1, @dateTo)
and
A.CourseID = B.CourseID
GROUP BY
A.UserID, A.CourseID
) A, @Users B, tblUserCourseStatus C, tblUser D, tblCourse E, tblUnitHierarchy F
WHERE
A.UserID = B.UserID AND B.UserID = C.UserID AND
A.LatestCourseStatus = C.UserCourseStatusID AND
(C.DateCreated BETWEEN @dateFrom AND dateadd(d,1,@dateTo)) AND
C.CourseStatusID = case @courseModuleStatus
when @CONST_COMPLETE then 2   -- Complete
when @CONST_INCOMPLETE then 1 -- InComplete
end AND
A.UserID = D.UserID AND A.CourseID = E.CourseID AND
D.UnitID = F.UnitID

end -- completed / -- InComplete


if @courseModuleStatus = @CONST_FAILD or @courseModuleStatus = @CONST_EXPIRED_TIMELAPSED or @courseModuleStatus = @CONST_EXPIRED_NEWCONTENT
begin -- Failed
--------------------
-- Failed  --
--------------------
-- When "Course/Module Status" is set to "Failed"
-- This will find users that:
--  - Belong to any of the Units in @unitIDs
--  - AND are currently assigned Modules from the selected Courses
--  - AND took a quiz, for a Module within the selected Course, within the date range of DateCreated in UserQuizStatus and failed it
--  - AND who currently have a status other than "Passed" for that same quiz
--------------------

--Find All Modules for all units with access

INSERT INTO @UserModuleWithAccess
SELECT DISTINCT A.UserID, A.ModuleID, A.UnitID FROM
(
SELECT A.UserID, A.ModuleID, A.UnitID
FROM vwUserModuleAccess A where courseid in (SELECT courseid from @Courses) )A, @Users B
Where A.UserID = B.UserID

--Find the latest status of all quiz for all the modules
INSERT INTO @UsersNQuizStatus
SELECT DISTINCT
A.UserID, A.ModuleID, A.LatestQuizID, B.QuizStatusID, B.QuizScore
FROM
(
SELECT
A.UserID, A.ModuleID, MAX(B.UserQuizStatusID) AS ''LatestQuizID''
FROM
@UserModuleWithAccess A, tblUserQuizStatus B
WHERE
A.UserID = B.UserID AND A.ModuleID = B.ModuleID
GROUP BY
A.UserID, A.ModuleID) A, tblUserQuizStatus B
WHERE
A.UserID = B.UserID AND A.ModuleID = B.ModuleID AND
A.LatestQuizID = B.UserQuizStatusID AND
(B.DateCreated BETWEEN @dateFrom AND dateadd(d,1,@dateTo))

INSERT INTO @UsersQuizStatusNOTSTARTED
SELECT * FROM @UsersNQuizStatus WHERE QuizStatusID = case @courseModuleStatus
when @CONST_FAILD then 3   -- Failed
when @CONST_EXPIRED_TIMELAPSED then 4 -- Expired time lapsed
when @CONST_EXPIRED_NEWCONTENT then 5 -- Expired new content
end

--Get Data in report format
SELECT
count(distinct A.UserID) AS TotalDistinctUsers
FROM
(select distinct userid, moduleid from @UsersQuizStatusNOTSTARTED) A,
tblUser B, tblCourse C, tblModule D, tblUnitHierarchy E
WHERE
A.UserID = B.UserID AND B.Active = 1 AND
A.ModuleID = D.ModuleID AND
B.UnitID = E.UnitID AND
D.CourseID = C.CourseID AND C.Active = 1 AND D.Active = 1

end --/ Failed


-- Not started --

if @courseModuleStatus = @CONST_NOTSTARTED
begin -- Not started - Any
--------------------
-- Not started  --
--------------------
-- When "Course/Module Status" is set to "Not Started"
-- This will find users that:
--  - Belong to any of the Units in @unitIDs
--  - AND are currently assigned Modules from the selected Courses
--  - AND who have not started ANY of the quizes they have access to in this course within the selected date range(DateCreated in vwUserQuizStatus)
--------------------


--Find All Modules for all units with access

INSERT INTO @UserModuleWithAccess
SELECT DISTINCT A.UserID, A.ModuleID, A.UnitID FROM
(
SELECT A.UserID, A.ModuleID, A.UnitID
FROM vwUserModuleAccess A where courseid in (SELECT courseid from @Courses) )A, @Users B
Where A.UserID = B.UserID

--Find the latest status of all quiz for all the modules
INSERT INTO @UsersNQuizStatus
SELECT  DISTINCT
A.UserID, A.ModuleID, A.LatestQuizID, B.QuizStatusID, B.QuizScore
FROM
(
SELECT
A.UserID, A.ModuleID, MAX(B.UserQuizStatusID) AS ''LatestQuizID''
FROM
@UserModuleWithAccess A, tblUserQuizStatus B
WHERE
A.UserID = B.UserID AND A.ModuleID = B.ModuleID
GROUP BY
A.UserID, A.ModuleID) A, tblUserQuizStatus B
WHERE
A.UserID = B.UserID AND A.ModuleID = B.ModuleID AND
A.LatestQuizID = B.UserQuizStatusID AND
(B.DateCreated BETWEEN @dateFrom AND dateadd(d,1,@dateTo))


--Get User with Quiz NOT STARTED
INSERT INTO @UsersQuizStatusNOTSTARTED
SELECT * FROM @UsersNQuizStatus WHERE QuizStatusID NOT IN (2,3,4,5) AND
UserID NOT IN (SELECT UserID FROM @UsersNQuizStatus WHERE QuizStatusID IN (2,3,4,5))


--Get Data in report format
SELECT
count(distinct A.UserID) AS TotalDistinctUsers
FROM
(select distinct userid, moduleid from @UsersQuizStatusNOTSTARTED) A,
tblUser B, tblCourse C, tblModule D, tblUnitHierarchy E
WHERE
A.UserID = B.UserID AND B.Active = 1 AND
A.ModuleID = D.ModuleID AND B.UnitID = E.UnitID AND
D.CourseID = C.CourseID AND C.Active = 1 AND D.Active = 1

end --/ Not started - Any

'
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_CourseStatusSearch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcReport_CourseStatusSearch]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_CourseStatusSearch]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/******************************************************************************
**		File:
**		Name: prcReport_CourseStatusSearch
**		Desc: Given a list of unit IDs, course IDs,
**
**		This template can be customized:
**
**		Return values:
**
**		Called by:
**
**		Parameters:
**		Input							Output
**     ----------							-----------
**
**		Auth:
**		Date:
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		23/07/2009	Mark Donald			Add @classificationID parameter and use
**										it to filter the insert into @Users
**		17/08/2009	Mark Donald			Change column order of ''fail option''
**										select statement to match others
**
*******************************************************************************/

--exec prcReport_CourseStatusSearch 109, ''4463,4464,4465,4469,4478,4479'', ''92'', 3, ''1997-01-01'',''2011-07-01'', 0, 0
CREATE       Procedure [dbo].[prcReport_CourseStatusSearch]
(
@organisationID		int,
@unitIDs 		varchar(max),
@courseIDs 		varchar(8000),
@courseModuleStatus	int,
@dateFromOrg 		datetime,
@dateToOrg 		datetime,
@IncludeInactive int,
@classificationID int
)
AS

begin
------------------------------------------
DECLARE @dateFrom 		datetime
DECLARE @dateTo 		datetime
SET @dateFrom = dbo.udfDaylightSavingTimeToUTC(@dateFromOrg,@OrganisationID)
SET @dateTo = dbo.udfDaylightSavingTimeToUTC(@dateToOrg,@OrganisationID)

Set Nocount On

Declare
@CONST_INCOMPLETE     	int,
@CONST_COMPLETE     	int,
@CONST_FAILD            int,
@CONST_NOTSTARTED 	    int,
@CONST_EXPIRED_TIMELAPSED		int,
@CONST_EXPIRED_NEWCONTENT		int

set @CONST_INCOMPLETE	= 0
set @CONST_COMPLETE	= 1
set @CONST_FAILD	= 2
set @CONST_NOTSTARTED	= 3
set @CONST_EXPIRED_TIMELAPSED   = 4
set @CONST_EXPIRED_NEWCONTENT	= 5

DECLARE @Units TABLE
(
UnitID INT PRIMARY KEY(UnitID)
)

DECLARE @Courses TABLE
(
CourseID INT PRIMARY KEY(CourseID)
)

DECLARE @CoursesWithAccess 	TABLE (CourseID INT PRIMARY KEY(CourseID))
DECLARE @UserModuleWithAccess TABLE(UserID INT, ModuleID INT, UnitID INT PRIMARY KEY(UserID, ModuleID, UnitID))
DECLARE @AllModules TABLE(ModuleID INT PRIMARY KEY(ModuleID))
DECLARE @Users TABLE(UserID INT , UnitID INT PRIMARY KEY(UserID, UnitID))
DECLARE @UsersNQuizStatus
TABLE
(
UserID	INT,
ModuleID INT,
LatestQuizID INT,
QuizStatusID INT,
QuizScore INT
PRIMARY KEY(UserID, ModuleID, LatestQuizID, QuizStatusID)
)

DECLARE @UsersQuizStatusNOTSTARTED
TABLE
(
UserID	INT,
ModuleID INT,
LatestQuizID INT,
QuizStatusID INT,
QuizScore INT
PRIMARY KEY(UserID, ModuleID, LatestQuizID, QuizStatusID)
)

INSERT INTO @Courses SELECT * FROM dbo.udfCsvToInt(@courseIDs)

INSERT INTO @Units SELECT * FROM  dbo.udfCsvToInt(@unitIDs)

--Get Rid of courses which do not have access to specified org
INSERT INTO @CoursesWithAccess
SELECT A.CourseID FROM @Courses A, tblOrganisationCourseAccess B, tblCourse C
WHERE A.CourseID = B.GrantedCourseID AND B.OrganisationID = @organisationID AND
A.CourseID = C.CourseID AND C.Active = 1

--Get All the users for all specfied units, matching Custom Classification option (if provided)
INSERT INTO @Users
SELECT
DISTINCT A.UserID, A.UnitiD
FROM
tblUser A
join @Units B on A.UnitID = B.UnitID
join tblUnit C on B.UnitID = C.UnitID AND C.Active = 1
LEFT JOIN tblUserClassification uc ON uc.UserID  = A.UserID
WHERE
A.Active = CASE @IncludeInactive WHEN 0 THEN 1 ELSE A.Active END
AND ((@classificationID =0) OR (classificationID = @classificationID))
--If classification is Any (0), This will find users of any Custom Classification



if @courseModuleStatus = @CONST_COMPLETE or @courseModuleStatus = @CONST_INCOMPLETE
begin -- completed / -- InComplete
--------------------
-- Completed --
--------------------
-- A user is completed if they became complete and remained completed in the period of interest
-- the query only needs to check to see status at the max date in this period as a line item
-- as tblUserCourseStatus is only writen to when an event occours that would
-- change the status.
-- When "Course/Module Status" is set to "Complete"
-- This will find users that:
-- - Belong to any of the Units in @unitIDs
-- - AND are currently assigned Modules from the selected Course
-- - AND have (at the end of the time-period in question) got a status of Complete in tblUserCourseStatus
-- - AND the event that made them complete happened some time in the time-period in question
--------------------
-- InComplete
--------------------
-- A user is in-completed if for any reason they are not complete but do have access to the course
-- This will find users that:
-- - Belong to any of the Units in @unitIDs
-- - AND are currently assigned Modules from the selected Courses
-- - AND have (at the end of the time-period in question) got a status of Incomplete in tblUserCourseStatus
-- - AND the event that made them complete happened some time in the time-period in question

--Find the latest status of courses
SELECT
A.UserID, D.UnitID,
D.FirstName,
D.LastName,
case when D.Active = 1 then ''''  else ''(i)'' end as Flag,
F.HierarchyName AS ''UnitPathWay'',
dbo.udfUTCtoDaylightSavingTime( C.DateCreated , @organisationID)as ''Date'',
D.Username as ''UserName'',
D.Email as ''Email'',
D.ExternalID as ''ExternalID'',
E.[Name] as ''CourseName'',
dbo.udfUTCtoDaylightSavingTime(D.DateCreated, @organisationID)as ''DateCreated'',
case when D.Active =0 then coalesce(dbo.udfUTCtoDaylightSavingTime(D.DateArchived,@organisationid ),dbo.udfUTCtoDaylightSavingTime(D.DateUpdated,@organisationid)) end  as ''DateArchived''
FROM
(SELECT
A.UserID, A.CourseID, MAX(A.UserCourseStatusID) AS ''LatestCourseStatus''
FROM
tblUserCourseStatus A, @CoursesWithAccess B
WHERE
A.DateCreated < DATEADD(DD, 1, @dateTo)
and
A.CourseID = B.CourseID
GROUP BY
A.UserID, A.CourseID
) A,
@Users B, tblUserCourseStatus C, tblUser D, tblCourse E, tblUnitHierarchy F
WHERE
A.UserID = B.UserID AND B.UserID = C.UserID AND
A.LatestCourseStatus = C.UserCourseStatusID AND
(C.DateCreated BETWEEN @dateFrom AND dateadd(d,1,@dateTo)) AND
C.CourseStatusID = case @courseModuleStatus
when @CONST_COMPLETE then 2   -- Complete
when @CONST_INCOMPLETE then 1 -- InComplete
end AND
A.UserID = D.UserID AND A.CourseID = E.CourseID AND
D.UnitID = F.UnitID
ORDER BY
CourseName, UnitPathWay, LastName, FirstName

end -- completed / -- InComplete


if @courseModuleStatus = @CONST_FAILD or @courseModuleStatus = @CONST_EXPIRED_TIMELAPSED or @courseModuleStatus = @CONST_EXPIRED_NEWCONTENT
begin -- Failed
--------------------
-- Failed  --
--------------------
-- When "Course/Module Status" is set to "Failed"
-- This will find users that:
--  - Belong to any of the Units in @unitIDs
--  - AND are currently assigned Modules from the selected Courses
--  - AND took a quiz, for a Module within the selected Course, within the date range of DateCreated in UserQuizStatus and failed it
--  - AND who currently have a status other than "Passed" for that same quiz
--------------------

--Find All Modules for all units with access

INSERT INTO @UserModuleWithAccess
SELECT DISTINCT A.UserID, A.ModuleID, A.UnitID FROM
(
SELECT A.UserID, A.ModuleID, A.UnitID
FROM vwUserModuleAccess A where courseid in (SELECT courseid from @Courses) )A, @Users B
Where A.UserID = B.UserID

--Find the latest status of all quiz for all the modules
INSERT INTO @UsersNQuizStatus
SELECT DISTINCT
A.UserID, A.ModuleID, A.LatestQuizID, B.QuizStatusID, B.QuizScore
FROM
(
SELECT
A.UserID, A.ModuleID, MAX(B.UserQuizStatusID) AS ''LatestQuizID''
FROM
@UserModuleWithAccess A, tblUserQuizStatus B
WHERE
A.UserID = B.UserID AND A.ModuleID = B.ModuleID
GROUP BY
A.UserID, A.ModuleID) A,
tblUserQuizStatus B
WHERE
A.UserID = B.UserID AND A.ModuleID = B.ModuleID AND
A.LatestQuizID = B.UserQuizStatusID AND
(B.DateCreated BETWEEN @dateFrom AND dateadd(d,1,@dateTo))

INSERT INTO @UsersQuizStatusNOTSTARTED
SELECT * FROM @UsersNQuizStatus WHERE QuizStatusID = case @courseModuleStatus
when @CONST_FAILD then 3   -- Failed
when @CONST_EXPIRED_TIMELAPSED then 4 -- Expired time lapsed
when @CONST_EXPIRED_NEWCONTENT then 5 -- Expired new content
end

--Get Data in report format
SELECT DISTINCT
A.UserID,
B.UnitID AS ''Unit'' ,
B.FirstName,
B.LastName,
case when B.Active = 1 then ''''  else ''(i)'' end  as Flag,
E.HierarchyName AS ''UnitPathWay'',
dbo.udfUTCtoDaylightSavingTime( C.DateCreated,@organisationID) AS ''Date'',
B.UserName,
B.Email,
B.ExternalID,C.Name AS ''CourseName'',
dbo.udfUTCtoDaylightSavingTime(B.DateCreated,@organisationID) AS ''DateCreated'',
case when B.Active =0 then coalesce(dbo.udfUTCtoDaylightSavingTime(B.DateArchived, @OrganisationID), dbo.udfUTCtoDaylightSavingTime(B.DateUpdated, @OrganisationID)) end as ''DateArchived''
FROM
(
select distinct userid, moduleid from @UsersQuizStatusNOTSTARTED) A,
tblUser B, tblCourse C, tblModule D, tblUnitHierarchy E
WHERE
A.UserID = B.UserID AND B.Active = 1 AND
A.ModuleID = D.ModuleID AND
B.UnitID = E.UnitID AND
D.CourseID = C.CourseID AND C.Active = 1 AND D.Active = 1
ORDER BY
CourseName, UnitPathWay, LastName, FirstName

end --/ Failed


-- Not started --

if @courseModuleStatus = @CONST_NOTSTARTED
begin -- Not started - Any
--------------------
-- Not started  --
--------------------
-- When "Course/Module Status" is set to "Not Started"
-- This will find users that:
--  - Belong to any of the Units in @unitIDs
--  - AND are currently assigned Modules from the selected Courses
--  - AND who have not started ANY of the quizes they have access to in this course within the selected date range(DateCreated in vwUserQuizStatus)
--------------------


--Find All Modules for all units with access

INSERT INTO @UserModuleWithAccess
SELECT DISTINCT A.UserID, A.ModuleID, A.UnitID FROM
(
SELECT A.UserID, A.ModuleID, A.UnitID
FROM vwUserModuleAccess A where courseid in (SELECT courseid from @Courses) )A, @Users B
Where A.UserID = B.UserID

--Find the latest status of all quiz for all the modules
INSERT INTO @UsersNQuizStatus
SELECT  DISTINCT
A.UserID, A.ModuleID, A.LatestQuizID, B.QuizStatusID, B.QuizScore
FROM
(
SELECT
A.UserID, A.ModuleID, MAX(B.UserQuizStatusID) AS ''LatestQuizID''
FROM
@UserModuleWithAccess A, tblUserQuizStatus B
WHERE
A.UserID = B.UserID AND A.ModuleID = B.ModuleID
GROUP BY
A.UserID, A.ModuleID) A, tblUserQuizStatus B
WHERE
A.UserID = B.UserID AND A.ModuleID = B.ModuleID AND
A.LatestQuizID = B.UserQuizStatusID AND
(B.DateCreated BETWEEN @dateFrom AND dateadd(d,1,@dateTo))


--Get User with Quiz NOT STARTED
INSERT INTO @UsersQuizStatusNOTSTARTED
SELECT * FROM @UsersNQuizStatus WHERE QuizStatusID NOT IN (2,3,4,5) AND
UserID NOT IN (SELECT UserID FROM @UsersNQuizStatus WHERE QuizStatusID IN (2,3,4,5))


--Get Data in report format
SELECT DISTINCT
A.UserID,
B.UnitID ,
B.FirstName,
B.LastName,
case when B.Active = 1 then '''' else ''(i)'' end  as Flag,
dbo.udfGetUnitPathway(B.UnitID) AS ''UnitPathWay'',
dbo.udfUTCtoDaylightSavingTime(C.DateCreated,@organisationID) AS ''Date'',
B.UserName,
B.Email,
B.ExternalID,
C.Name AS ''CourseName'',
dbo.udfUTCtoDaylightSavingTime(B.DateCreated,@OrganisationID) as ''DateCreated'',
case when B.Active =0 then coalesce(dbo.udfUTCtoDaylightSavingTime(B.DateArchived,@OrganisationID),dbo.udfUTCtoDaylightSavingTime(B.DateUpdated,@OrganisationID)) end as ''DateArchived''
FROM
(select distinct userid, moduleid from @UsersQuizStatusNOTSTARTED) A,
tblUser B, tblCourse C, tblModule D, tblUnitHierarchy E
WHERE
A.UserID = B.UserID AND B.Active = 1 AND
A.ModuleID = D.ModuleID AND B.UnitID = E.UnitID AND
D.CourseID = C.CourseID AND C.Active = 1 AND D.Active = 1
ORDER BY
CourseName, UnitPathWay, LastName, FirstName

end --/ Not started - Any
END
'
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_Policies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcReport_Policies]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_Policies]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/******************************************************************************
**		File: dbo.prcReport_Policies.PRC
**		Name: prcReport_Policies
**		Desc: For reporting of Policy acceptance by users
**
**		Return values:
**			Policy
**			UnitPathway
**			Lastname
**			Firstname
**			Email
**			Accepted
**			DateAccepted
**
**		Called by:
**
**		Parameters:
**			@organisationID Integer = ''0''
**			@policyIDs varchar(8000) = ''0''
**			@unitIDs varchar(8000) = ''0''
**			@dateFrom datetime = Null
**			@dateTo datetime = Null
**			@acceptanceStatus varchar(20) = ''BOTH''
**			@includeInactiveUsers varchar(5) = ''false''
**
**		Input							Output
**     ----------							-----------
**
**		Auth: Chris Plewright
**		Date: 31 Jul 2008
**
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		--------		--------				-------------------------------------------
**		14/08/2009		Mark Donald				More detail in Order By clause
**												+ extra column (userid) in result set
**		09/06/2011		J hedlefs				tIMEZONE
*******************************************************************************/
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
CREATE Procedure [dbo].[prcReport_Policies]
@organisationID Integer = ''0'',
@policyIDs varchar(8000) = ''0'',
@unitIDs varchar(max) = ''0'',
@dateFromOrg datetime = Null,
@dateToOrg datetime = Null,
@acceptanceStatus varchar(20) = ''BOTH'',
@includeInactiveUsers varchar(5) = ''false''
AS

BEGIN

SET NOCOUNT ON;
DECLARE @dateFrom 		datetime
DECLARE @dateTo 		datetime
SET @dateFrom = dbo.udfDaylightSavingTimeToUTC(@dateFromOrg,@OrganisationID)
SET @dateTo = dbo.udfDaylightSavingTimeToUTC(@dateToOrg,@OrganisationID)

select
Policy = pol.PolicyName + '' ('' + pol.PolicyFileName + '')'',
UnitPathway = tblUnitHierarchy.HierarchyName,
--tblUser.Lastname,
CASE
WHEN tblUser.Active = 0 then LastName + '' (I)''
ELSE LastName
END AS LastName,
tblUser.Firstname,
tblUser.Email,
tblUser.userid,
Accepted = case when ua1.Accepted = 1  and (ua1.DateAccepted >= @dateFrom and ua1.DateAccepted <= @dateTo) then ''Yes'' else ''No'' end,
case when ua1.DateAccepted >= @dateFrom and ua1.DateAccepted <= @dateTo then  dbo.udfUTCtoDaylightSavingTime(ua1.DateAccepted,@OrganisationID)  else null end as DateAccepted
from tblPolicy pol
join tblOrganisation org on org.OrganisationID = pol.Organisationid and org.OrganisationID = @OrganisationID
join tblUser on tblUser.OrganisationID = org.OrganisationID and (@includeInactiveUsers=''true'' or tblUser.Active=1) and tblUser.UnitID in (select IntValue from dbo.udfCsvToInt(@unitIDs))
join tblUserPolicyAccepted ua1 on pol.PolicyID = ua1.PolicyID and tblUser.UserID = ua1.UserID
join tblUnitHierarchy on tblUser.UnitID = tblUnitHierarchy.UnitID
left join tblUserPolicyAccess upa on upa.PolicyID = pol.PolicyID and upa.UserID = tblUser.Userid
where upa.granted = 1 and pol.Active = 1 and pol.Deleted = 0 and pol.uploaddate between @dateFrom and @dateTo
and pol.PolicyID in ( select IntValue from dbo.udfCsvToInt(@policyIDs ) )
and (
--Condition A - ACCEPTED
( @acceptanceStatus=''ACCEPTED'' and exists(select * from tblUserPolicyAccepted where pol.PolicyID = tblUserPolicyAccepted.PolicyID and tblUser.UserID = tblUserPolicyAccepted.UserID and tblUserPolicyAccepted.DateAccepted >= @dateFrom and tblUserPolicyAccepted.DateAccepted <= @dateTo and tblUserPolicyAccepted.Accepted = 1 ) )
or
--Condition B - NOT_ACCEPTED
( @acceptanceStatus=''NOT_ACCEPTED'' and not exists(select * from tblUserPolicyAccepted where pol.PolicyID = tblUserPolicyAccepted.PolicyID and tblUser.UserID = tblUserPolicyAccepted.UserID and tblUserPolicyAccepted.DateAccepted >= @dateFrom and tblUserPolicyAccepted.DateAccepted <= @dateTo and tblUserPolicyAccepted.Accepted = 1) )
or
--Condition C - BOTH
@acceptanceStatus=''BOTH''
)
--and (@includeInactiveUsers=''true'' and exists )
ORDER BY policy, unitpathway, lastname, firstname

END
'
END

GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_PoliciesGrandTotal]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcReport_PoliciesGrandTotal]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_PoliciesGrandTotal]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/******************************************************************************
**		File: dbo.prcReport_PoliciesGrandTotal.PRC
**		Name: prcReport_PoliciesGrandTotal
**		Desc: counts total distinct users in policies report - basically, it''s a copy
**				of that report with the selects changed to return a total instead of data
**
**		Parameters:
**			@organisationID Integer = ''0''
**			@policyIDs varchar(8000) = ''0''
**			@unitIDs varchar(8000) = ''0''
**			@dateFrom datetime = Null
**			@dateTo datetime = Null
**			@acceptanceStatus varchar(20) = ''BOTH''
**			@includeInactiveUsers varchar(5) = ''false''
**
**		Input							Output
**     ----------							-----------
**
**		Auth: Mark Donald
**		Date: 27 Aug 2009
**
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		--------		--------				-------------------------------------------
**		09/06/2011	j hedlefs			timezone
*******************************************************************************/
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
CREATE Procedure [dbo].[prcReport_PoliciesGrandTotal]
@organisationID Integer = ''0'',
@policyIDs varchar(8000) = ''0'',
@unitIDs varchar(max) = ''0'',
@dateFromOrg datetime = Null,
@dateToOrg datetime = Null,
@acceptanceStatus varchar(20) = ''BOTH'',
@includeInactiveUsers varchar(5) = ''false''
AS
BEGIN
SET NOCOUNT ON;
DECLARE @dateFrom 		datetime
DECLARE @dateTo 		datetime
SET @dateFrom = dbo.udfDaylightSavingTimeToUTC(@dateFromOrg,@OrganisationID)
SET @dateTo = dbo.udfDaylightSavingTimeToUTC(@dateToOrg,@OrganisationID)

select
count(distinct tblUser.userid) as TotalDistinctUsers
from tblPolicy pol
join tblOrganisation org on org.OrganisationID = pol.Organisationid and org.OrganisationID = @OrganisationID
join tblUser on tblUser.OrganisationID = org.OrganisationID and (@includeInactiveUsers=''true'' or tblUser.Active=1) and tblUser.UnitID in (select IntValue from dbo.udfCsvToInt(@unitIDs))
join tblUserPolicyAccepted ua1 on pol.PolicyID = ua1.PolicyID and tblUser.UserID = ua1.UserID
join tblUnitHierarchy on tblUser.UnitID = tblUnitHierarchy.UnitID
left join tblUserPolicyAccess upa on upa.PolicyID = pol.PolicyID and upa.UserID = tblUser.Userid
where upa.granted = 1 and pol.Active = 1 and pol.Deleted = 0 and pol.uploaddate between @dateFrom and @dateTo
and pol.PolicyID in ( select IntValue from dbo.udfCsvToInt(@policyIDs ) )
and (
--Condition A - ACCEPTED
( @acceptanceStatus=''ACCEPTED'' and exists(select * from tblUserPolicyAccepted where pol.PolicyID = tblUserPolicyAccepted.PolicyID and tblUser.UserID = tblUserPolicyAccepted.UserID and tblUserPolicyAccepted.DateAccepted >= @dateFrom and tblUserPolicyAccepted.DateAccepted <= @dateTo and tblUserPolicyAccepted.Accepted = 1 ) )
or
--Condition B - NOT_ACCEPTED
( @acceptanceStatus=''NOT_ACCEPTED'' and not exists(select * from tblUserPolicyAccepted where pol.PolicyID = tblUserPolicyAccepted.PolicyID and tblUser.UserID = tblUserPolicyAccepted.UserID and tblUserPolicyAccepted.DateAccepted >= @dateFrom and tblUserPolicyAccepted.DateAccepted <= @dateTo and tblUserPolicyAccepted.Accepted = 1) )
or
--Condition C - BOTH
@acceptanceStatus=''BOTH''
)
--and (@includeInactiveUsers=''true'' and exists )

END
'
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_PoliciesTotals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcReport_PoliciesTotals]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_PoliciesTotals]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/******************************************************************************
**		File: dbo.prcReport_PoliciesTotals.PRC
**		Name: prcReport_PoliciesTotals
**		Desc: For counting user policy acceptance by policy
**
**		Return values:
**			Policy
**			UnitPathway
**			Lastname
**			Firstname
**			Email
**			UserID
**			Accepted
**			DateAccepted
**
**		Called by:
**
**		Parameters:
**			@organisationID Integer = ''0''
**			@policyIDs varchar(8000) = ''0''
**			@unitIDs varchar(8000) = ''0''
**			@dateFrom datetime = Null
**			@dateTo datetime = Null
**			@acceptanceStatus varchar(20) = ''BOTH''
**			@includeInactiveUsers varchar(5) = ''false''
**
**		Input							Output
**     ----------							-----------
**
**		Auth: Mark Donald
**		Date: 14 Aug 2009
**
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		--------		--------				-------------------------------------------
**
*******************************************************************************/

CREATE PROCEDURE [dbo].[prcReport_PoliciesTotals]
@organisationID Integer = 0,
@policyIDs varchar(8000) = ''0'',
@unitIDs varchar(max) = ''0'',
@dateFromOrg datetime = Null,
@dateToOrg datetime = Null,
@acceptanceStatus varchar(20) = ''BOTH'',
@includeInactiveUsers varchar(5) = ''false''
AS
BEGIN
DECLARE @dateFrom 		datetime
DECLARE @dateTo 		datetime
SET @dateFrom = dbo.udfDaylightSavingTimeToUTC(@dateFromOrg,@OrganisationID)
SET @dateTo = dbo.udfDaylightSavingTimeToUTC(@dateToOrg,@OrganisationID)


SET NOCOUNT ON;
select
pol.PolicyName AS policy,
count (*) as totalusers,
sum(CASE WHEN ua1.Accepted = 1  and (ua1.DateAccepted >= @dateFrom and ua1.DateAccepted <= @dateTo) THEN 1 ELSE 0 END) AS totalaccepted,
sum(CASE WHEN ua1.Accepted = 1  and (ua1.DateAccepted >= @dateFrom and ua1.DateAccepted <= @dateTo) THEN 0 ELSE 1 END) AS totalnotaccepted
from tblPolicy pol
join tblOrganisation org on org.OrganisationID = pol.Organisationid and org.OrganisationID = @OrganisationID
join tblUser on tblUser.OrganisationID = org.OrganisationID and (@includeInactiveUsers=''true'' or tblUser.Active=1) and tblUser.UnitID in (select IntValue from dbo.udfCsvToInt(@unitIDs))
join tblUserPolicyAccepted ua1 on pol.PolicyID = ua1.PolicyID and tblUser.UserID = ua1.UserID
join tblUnitHierarchy on tblUser.UnitID = tblUnitHierarchy.UnitID
left join tblUserPolicyAccess upa on upa.PolicyID = pol.PolicyID and upa.UserID = tblUser.Userid
where upa.granted = 1 and pol.Active = 1 and pol.Deleted = 0 and pol.uploaddate between @dateFrom and @dateTo
and pol.PolicyID in ( select IntValue from dbo.udfCsvToInt(@policyIDs ) )
and (
--Condition A - ACCEPTED
( @acceptanceStatus=''ACCEPTED'' and exists(select * from tblUserPolicyAccepted where pol.PolicyID = tblUserPolicyAccepted.PolicyID and tblUser.UserID = tblUserPolicyAccepted.UserID and tblUserPolicyAccepted.DateAccepted >= @dateFrom and tblUserPolicyAccepted.DateAccepted <= @dateTo and tblUserPolicyAccepted.Accepted = 1 ) )
or
--Condition B - NOT_ACCEPTED
( @acceptanceStatus=''NOT_ACCEPTED'' and not exists(select * from tblUserPolicyAccepted where pol.PolicyID = tblUserPolicyAccepted.PolicyID and tblUser.UserID = tblUserPolicyAccepted.UserID and tblUserPolicyAccepted.DateAccepted >= @dateFrom and tblUserPolicyAccepted.DateAccepted <= @dateTo and tblUserPolicyAccepted.Accepted = 1) )
or
--Condition C - BOTH
@acceptanceStatus=''BOTH''
)
--and (@includeInactiveUsers=''true'' and exists )
group by pol.PolicyName
--ORDER BY policy, unitpathway, lastname, firstname

END
'
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_Progress]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcReport_Progress]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_Progress]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/******************************************************************************
**		Name: prcReport_Progress
**
**		Called by:
**
**		Auth: Mark Donald
**		Date: 11 Jan 2010
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**
*******************************************************************************/


CREATE PROCEDURE [dbo].[prcReport_Progress]
(
@organisationID int,
@unitIDs varchar(max),
@courseIDs varchar(8000),
@includeInactive int,
@classificationID int
)
AS
SET NOCOUNT ON;
BEGIN
DECLARE @currentstatus TABLE (usercoursestatusid int)
INSERT INTO @currentstatus
SELECT
max(usercoursestatusid) usercoursestatusid
FROM
tblusercoursestatus
GROUP BY
userid, courseid

SELECT
hierarchyname ''unitpathway'', lastname, firstname, CASE u.active WHEN 1 THEN NULL ELSE ''(i)'' END flag,
c.name coursename, externalid, email, username, [status] currentstatus, previousstatus, (
SELECT
convert(varchar(10), dbo.udfUTCtoDaylightSavingTime(max(datecreated),@OrganisationID), 103)
FROM
tblusercoursestatus
WHERE
userid = s.userid
AND courseid = s.courseid
AND coursestatusid = 2
) AS lastcompletiondate
FROM
tblusercoursestatus s
INNER JOIN tblcourse c ON
c.courseid = s.courseid
AND c.courseid IN (SELECT IntValue FROM dbo.udfCsvToInt(@courseIDs))
INNER JOIN tbluser u ON
u.userid = s.userid
AND u.unitid IN (SELECT IntValue FROM dbo.udfCsvToInt(@unitIDs))
LEFT JOIN (
SELECT
userid, courseid, max(usercoursestatusid) usercoursestatusid -- 2nd most recent record
FROM
tblusercoursestatus
WHERE
usercoursestatusid NOT IN (SELECT usercoursestatusid FROM @currentstatus)
GROUP BY
userid, courseid
) AS p ON
s.userid = p.userid
AND s.courseid = p.courseid
LEFT JOIN (
SELECT
usercoursestatusid, v.coursestatusid, [status] previousstatus
FROM
tblusercoursestatus v
INNER JOIN tblcoursestatus z ON
v.coursestatusid = z.coursestatusid
WHERE
z.coursestatusid > 0
) AS def2 ON
def2.usercoursestatusid = p.usercoursestatusid
LEFT JOIN tbluserclassification g ON
g.userid = u.userid,
tblunithierarchy h,
tblcoursestatus def,
@currentstatus r
WHERE
h.unitid = u.unitid
AND def.coursestatusid = s.coursestatusid
AND s.usercoursestatusid = r.usercoursestatusid
AND u.organisationid = @organisationID
AND (@includeInactive = 1 OR u.active = 1)
AND (@classificationID = 0 OR classificationID = @classificationID)
ORDER BY
unitpathway, lastname, firstname, coursename
END
'
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_ProgressGrandTotal]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcReport_ProgressGrandTotal]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_ProgressGrandTotal]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/******************************************************************************
**		Name: prcReport_ProgressGrandTotal
**		Desc: a cut down copy of prcreport_Progress, with select statements
**				altered to return a total, instead of a list of data.
**
**		Return values: Grand Total distinct users in Progress report
**
**		Auth: Mark Donald
**		Date: 11 Jan 2010
**
*******************************************************************************/

CREATE       Procedure [dbo].[prcReport_ProgressGrandTotal]
(
@organisationID		int,
@unitIDs 		varchar(max),
@courseIDs 		varchar(8000),
@includeInactive int,
@classificationID int
)
AS
SET NOCOUNT ON;
BEGIN
SELECT
count(DISTINCT u.userid) TotalDistinctUsers
FROM
tblusercoursestatus s
INNER JOIN tblcourse c ON
c.courseid = s.courseid
AND c.courseid IN (SELECT IntValue FROM dbo.udfCsvToInt(@courseIDs))
INNER JOIN tbluser u ON
u.userid = s.userid
AND u.unitid IN (SELECT IntValue FROM dbo.udfCsvToInt(@unitIDs))
LEFT JOIN tbluserclassification g ON
g.userid = u.userid
WHERE
u.organisationid = @organisationID
AND (@includeInactive = 1 OR u.active = 1)
AND (@classificationID = 0 OR classificationID = @classificationID)
END

'
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_Summary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcReport_Summary]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_Summary]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
This Report provides a high level summary information.
It shows how many users in each unit are complete or incomplete in each course.
The results can be views as a bar graph

Called By:
SummaryReport in Reporting Services

Calls:
udfReport_CompletUsers_logic
udfReport_IncompletUsers_logic
Remarks:


Author:
Jack Liu
Date Created: 31 March 2005

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
Mark Donald	23/07/2009		Add @classificationID parameter and use it
to filter insert into #result table

prcReport_Summary 8, ''19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,84'' ,7, null

prcReport_Summary 8, ''19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,84'' ,7, ''20041130''

--------------------

**/

CREATE  Proc [dbo].[prcReport_Summary]
(
@organisationID Integer,	-- Organisation of the current user
@unitIDs varchar(max) = '''',	-- string of unit id''s
@courseID int,			-- course ID to restrict search to
@effectiveDateOrg datetime = Null,	-- Effective date as at when to run the report
@classificationID int
)

AS
------------------------------------------
Set Nocount On
DECLARE @effectiveDate 		datetime
SET @effectiveDate = dbo.udfDaylightSavingTimeToUTC(@effectiveDateOrg,@OrganisationID)
CREATE TABLE #result
(
UnitID		Int,
UnitPathway 	nVarchar(4000),
Complete	int,
Incomplete	int
)
declare @rowCount as integer

insert into #result
select
UnitID,
min(UnitPathway) as UnitPathway,
sum(Complete) as Complete,
sum(Incomplete) as Incomplete
from (Select
UnitID,
UnitPathWay,
1 as Complete,
0 as Incomplete,
UserID
From	dbo.udfReport_CompleteUsersLogic(@organisationID, @unitIDs, @courseID,@effectiveDate)
Union all
Select
UnitID,
UnitPathWay,
0 as Complete,
1 as Incomplete,
UserID
from  dbo.udfReport_IncompleteUsersLogic(@organisationID, @unitIDs, @courseID,@effectiveDate)
) as Users
LEFT JOIN tblUserClassification c ON c.UserID  = Users.UserID
WHERE
((@classificationID =0) OR (classificationID = @classificationID))
--If classification is Any (0), This will find users of any Custom Classification
group by UnitID
Order By UnitPathway

set @rowCount=@@rowcount

if (@rowCount>1)
begin
insert into #result
select 0,
''Total'',
Sum(Complete),
Sum(Incomplete)
from #result

set @rowCount = @rowCount+1
end

select *,
@rowCount  as Count
from #result

drop table #result
'
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_Trend]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcReport_Trend]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_Trend]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:
refer to section 16.5.5.2 of Func. Spec. returns avg. score
and num of user per module for a selected course and unit

Called By: Report.cs, TrendReport.aspx.cs
Calls: udfCsvToInt

Remarks: Raises an error if a parameter is null

Author: Claude Nehme
Date Created: 16th of February 2004

prcReport_Trend "1,2,3", 1,1

Modification History
-----------------------------------------------------------
v#	Author			Date			Description
#1	Peter Kneale 	03/03/04		Added ''Passed or Failed Users only''
#2	Jack Liu		05/03/04		Remove the hierarchy unit, change to flat file
#3	Jack Liu		14/09/05		Order the result by Module
and order by most recent(the last recorded status with specified passmark)
#4	Usman Tjiudri	11 Nov 2005		Include BoldMark indicator for the latest PassMark record.
#5	j hedlefs		09/06/2011		timezone

*/

CREATE     Procedure [dbo].[prcReport_Trend]
(
@organisationID integer = null,
@unitIDs varchar(max) = null,
@courseID integer = null,
@fromDateOrg datetime,
@toDateOrg datetime
)

as
DECLARE @fromDate 		datetime
DECLARE @toDate 		datetime
SET @fromDate = dbo.udfDaylightSavingTimeToUTC(@fromDateOrg,@OrganisationID)
SET @toDate = dbo.udfDaylightSavingTimeToUTC(@toDateOrg,@OrganisationID)

Set NoCount On

If @courseID Is Null
Begin
Raiserror(''The Parameter @courseID was null.  @courseID does not accept Null values.'', 16, 1)
Return
End

-- Temporary table to store the query for further data manipulation.
Declare @tblResult Table
(
Unit		nVarchar(200),
UnitID		Int,
Course		nVarchar(100),
CourseID	Int,
Module		nVarchar(100),
ModuleID	Int,
NumOfUsers	Int,
QuizCount int,
QuizPassMark	Int,
AvgScore	Int,
LastUserQuizStatusID Int,
BoldMark	Bit -- Indicator whether current record should be bold or not
)

If @unitIDs Is Null
Begin
Insert Into @tblResult
(
Unit,
UnitID,
Course,
CourseID,
Module,
ModuleID,
NumOfUsers,
QuizCount,
QuizPassMark,
AvgScore,
LastUserQuizStatusID
)
Select 	dbo.udfGetUnitPathway(un.UnitID) as Unit,
un.UnitID,
min(co.Name) as  Course,
co.CourseID,
min(mo.Name) as Module,
mo.ModuleID,
count(DISTINCT usr.UserID) as NumOfUsers,
count(usr.UserID) as QuizCount,
uqs.QuizPassMark,
avg(uqs.QuizScore) as AvgScore,
max(uqs.UserQuizStatusID) as LastUserQuizStatusID
From
tblUser usr
inner join tblUnit un on un.UnitID = usr.UnitID
inner join tblUserQuizStatus uqs on usr.UserID = uqs.UserID
and (uqs.QuizStatusID = 2 or uqs.QuizStatusID = 3) 	-- Passed or Failed Users only
and uqs.DateCreated between @fromDate and dateadd(dd,1,@toDate)
inner join tblModule mo on mo.ModuleID = uqs.ModuleID
inner join tblCourse co on mo.CourseID = co.CourseID and co.CourseID = @courseID
Where
usr.UnitID is not null
and 	usr.Active = 1
and 	un.OrganisationID = @organisationID
Group By
un.UnitID,
co.CourseID,
mo.ModuleID,
uqs.QuizPassMark
Order By
Unit,
Course,
Module,
LastUserQuizStatusID desc

End
Else
Begin
Insert Into @tblResult
(
Unit,
UnitID,
Course,
CourseID,
Module,
ModuleID,
NumOfUsers,
QuizCount,
QuizPassMark,
AvgScore,
LastUserQuizStatusID
)
Select	dbo.udfGetUnitPathway(un.UnitID) as Unit,
un.UnitID,
min(co.Name) as  Course,
co.CourseID,
min(mo.Name) as Module,
mo.ModuleID,
count(DISTINCT usr.UserID) as NumOfUsers,
count(usr.UserID) as QuizCount,
uqs.QuizPassMark,
avg(uqs.QuizScore) as AvgScore,
max(uqs.UserQuizStatusID) as LastUserQuizStatusID
From
tblUser usr
inner join tblUnit un on un.UnitID = usr.UnitID
inner join dbo.udfCsvToInt(@unitIDs) as selectedUnit on selectedUnit.IntValue= un.UnitID
inner join tblUserQuizStatus uqs on usr.UserID = uqs.UserID
and (uqs.QuizStatusID = 2 or uqs.QuizStatusID = 3) 	-- Passed or Failed Users only
and uqs.DateCreated between @fromDate and dateadd(dd,1,@toDate)
inner join tblModule mo on mo.ModuleID = uqs.ModuleID
inner join tblCourse co on mo.CourseID = co.CourseID and co.CourseID = @courseID
Where
usr.UnitID is not null
and 	usr.Active = 1
Group By
un.UnitID,
co.CourseID,
mo.ModuleID,
uqs.QuizPassMark
Order By
Unit,
Course,
Module,
LastUserQuizStatusID desc
End

-- Update BoldMark field for group of records (by Unit, Course and Module) with more than one version of pass mark.
Update @tblResult
Set BoldMark = 1
Where LastUserQuizStatusID In (
Select tb.QuizStatusID From
(Select UnitID, CourseID, ModuleID, Max(LastUserQuizStatusID) As QuizStatusID from @tblResult Group by UnitID, CourseID, ModuleID having count(*) > 1) As tb
)

-- Returning records to callers
Select * From @tblResult

'
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_UnitAdministrators]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcReport_UnitAdministrators]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_UnitAdministrators]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/**

Summary:		Get a list of existing unit administrators for an organisation, by unit.

Returns:		Result set

Called By:		UnitAdministratorReport.rdl

Example call:	execute prcReport_UnitAdministrators 109
(use this for testing inside SQL management studio)

Author:			Mark Donald

Date Created:	30/07/2009

Modification History
-----------------------------------------------------------
Author		Date			Description



**/
CREATE PROCEDURE [dbo].[prcReport_UnitAdministrators]
(
@organisationID	int,
@IncludeInactive int,
@UnitIDs varchar(max)
)

AS

set nocount on

SELECT
dbo.udfGetUnitPathway(t.unitid) AS unitpathway,
lastname,
firstname,
CASE WHEN u.active = 1 THEN '''' ELSE ''(i)'' END AS flag,
username,
email,
externalid,
groupby,
[value]
FROM
tblunitadministrator ua, tblunit t, tbluser u
LEFT JOIN (
SELECT userid, ct.[name] as groupby, c.[value]
FROM tbluserclassification uc, tblclassification c, tblclassificationtype ct
WHERE c.classificationid = uc.classificationid
AND c.classificationtypeid = ct.classificationtypeid
) AS i ON i.userid = u.userid
WHERE
ua.userid = u.userid AND t.unitid = ua.unitid
AND usertypeid=3 --Unit administrator(3)
AND t.organisationid = @organisationID
AND (@IncludeInactive = 1 OR u.active = 1)
AND t.unitid IN (SELECT * FROM dbo.udfCsvToInt(@UnitIDs))
ORDER BY
unitpathway, lastname, firstname

'
END

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_UnitCompliance]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcReport_UnitCompliance]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_UnitCompliance]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/**

Summary:		Get the compliance rules for all the modules attached to selected units.
Called by:		UnitComplianceReport.rdl
Example call:	exec prcreport_unitcompliance 109, 0, ''4463,4464,4465''

Author:			Mark Donald
Date created:	05/01/2010

Modification history
-----------------------------------------------------------
Author		Date			Description



**/
CREATE PROCEDURE [dbo].[prcReport_UnitCompliance]
(
@organisationID	int,
@IncludeInactive int,
@UnitIDs varchar(max)
)

AS

SET NOCOUNT ON

SELECT
hierarchyname as unitpathway, c.[name] as coursename, r.[name] AS modulename,
CASE lessonfrequency WHEN 0 THEN NULL ELSE lessonfrequency END AS lessonfrequency,
CASE quizfrequency WHEN 0 THEN NULL ELSE quizfrequency END AS quizfrequency,
lessoncompletiondate AS lessonexpirydate,
quizcompletiondate AS quizexpirydate,
quizpassmark AS passmark,
CASE usingdefault WHEN 1 THEN ''Yes'' ELSE ''No'' END AS ''default''
FROM
vwunitmodulerule r
LEFT JOIN tblunitmoduleaccess a ON a.unitid = r.unitid AND r.moduleid = deniedmoduleid,
tblunit u,
tblunithierarchy h,
tblcourse c,
tblModule m
WHERE
h.unitid = u.unitid
AND r.unitid = u.unitid
AND c.courseid = r.courseid
AND r.moduleid = m.moduleid
AND u.organisationid = @organisationid
AND (@includeinactive = 1 OR u.active = 1)
AND a.unitid IS NULL
AND u.unitid IN (SELECT * FROM dbo.udfcsvtoint(@unitids))
ORDER BY
unitpathway, coursename, [sequence], modulename

'
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_UnitPath]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcReport_UnitPath]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_UnitPath]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE Procedure [dbo].[prcReport_UnitPath]
(
@OrganisationID int,
@IncludeInactiveUnits int,
@UnitIDs varchar(max)
)
AS
begin
if @IncludeInactiveUnits = 1
BEGIN
select

UnitID ,
dbo.udfGetUnitPathway(tblUnit.UnitID) as ''UnitPathway'',
dbo.udfGetUnitIDPathway(tblUnit.UnitID) as ''UnitIDPathway'',

CASE
WHEN Active = 0  THEN [Name] + '' (I)''
ELSE [Name]
END as [Name]



from

tblUnit

where

tblUnit.OrganisationID = @OrganisationID
and tblUnit.UnitID in (SELECT * FROM dbo.udfCsvToInt(@unitIDs) tU)


order by

dbo.udfGetUnitPathway(tblUnit.UnitID)
END
else
BEGIN
select

UnitID,

dbo.udfGetUnitPathway(tblUnit.UnitID) as ''UnitPathway'',

dbo.udfGetUnitIDPathway(tblUnit.UnitID) as ''UnitIDPathway'',

Name



from

tblUnit

where

tblUnit.OrganisationID = @OrganisationID
and tblUnit.UnitID in (SELECT * FROM dbo.udfCsvToInt(@unitIDs) tU)
and tblUnit.Active = 1

order by

dbo.udfGetUnitPathway(tblUnit.UnitID)
END
end
'
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_UserDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcReport_UserDetails]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_UserDetails]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE  PROCEDURE [dbo].[prcReport_UserDetails]
(
@OrganisationID int,
@IncludeInactiveUsers int,
@UnitIDs varchar(max)
)
AS
SET NOCOUNT ON

IF (@IncludeInactiveUsers=0)
BEGIN

SELECT
uh.HierarchyName as UnitPathway,
u.UserID,
FirstName,
LastName,
u.UnitID,
Email,
UserName,
ExternalID,
ct.Name as GroupBy,
c.Value as Value
FROM
tblUser u
LEFT JOIN tblUserClassification uc on u.UserID = uc.UserID
LEFT JOIN tblClassification c on uc.ClassificationID = c.ClassificationID
LEFT JOIN tblClassificationType ct on c.ClassificationTypeID = ct.ClassificationTypeID
LEFT JOIN tblUnitHierarchy uh on u.UnitID = uh.UnitID
WHERE
u.Active = 1
AND
u.OrganisationID = @OrganisationID
AND
u.UnitID IN (SELECT * FROM dbo.udfCsvToInt(@UnitIDs) as tblUnitIDs)

ORDER BY
uh.HierarchyName, LastName

END

ELSE
BEGIN
SELECT
uh.HierarchyName as UnitPathway,
u.UserID,
FirstName,
CASE
WHEN u.Active = 0 then u.LastName + '' (I)''
ELSE u.LastName
END AS LastName,
u.UnitID,
Email,
UserName,
ExternalID,
ct.Name as GroupBy ,
c.Value as Value
FROM
tblUser u
LEFT JOIN tblUserClassification uc on u.UserID = uc.UserID
LEFT JOIN tblClassification c on uc.ClassificationID = c.ClassificationID
LEFT JOIN tblClassificationType ct on c.ClassificationTypeID = ct.ClassificationTypeID
LEFT JOIN tblUnitHierarchy uh on u.UnitID = uh.UnitID
WHERE

u.OrganisationID = @OrganisationID
AND
u.UnitID IN (SELECT * FROM dbo.udfCsvToInt(@UnitIDs) as tblUnitIDs)

--Active = (IsNull(@Active,1))

ORDER BY
uh.HierarchyName, LastName

END
'
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_Warning]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcReport_Warning]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_Warning]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/******************************************************************************
**		Name: prcReport_Warning
**
**		Called by:
**
**		Auth: Mark Donald
**		Date: 7 Dec 2009
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**
*******************************************************************************/


CREATE PROCEDURE [dbo].[prcReport_Warning]
(
@organisationID int,
@unitIDs varchar(max),
@courseIDs varchar(8000),
@classificationID int,
@warningPeriod int,
@warningUnit varchar(2)
)
AS
SET NOCOUNT ON;

DECLARE @Units TABLE (UnitID INT PRIMARY KEY(UnitID))
DECLARE @Courses TABLE(CourseID INT PRIMARY KEY(CourseID))
DECLARE @CoursesWithAccess 	TABLE (CourseID INT PRIMARY KEY(CourseID))
DECLARE @Users TABLE(UserID INT , UnitID INT PRIMARY KEY(UserID, UnitID))
DECLARE @tblCurrentAssignedModules TABLE (
CourseID int,
UserID int,
UnitID int,
ModuleID int,
QuizFrequency int,
QuizCompletionDate datetime
)
DECLARE @tblStartedModules TABLE (
UserID int,
ModuleID int,
DateTimeCompleted datetime
)

INSERT INTO
@Courses
SELECT
*
FROM
dbo.udfCsvToInt(@courseIDs)

INSERT INTO
@Units
SELECT
*
FROM
dbo.udfCsvToInt(@unitIDs)

-- Get users for specfied units, matching Custom Classification option (if provided)
INSERT INTO @Users
SELECT
DISTINCT A.UserID, A.UnitiD
FROM
tblUser A
JOIN @Units B on A.UnitID = B.UnitID
JOIN tblUnit C on B.UnitID = C.UnitID AND C.Active = 1
LEFT JOIN tblUserClassification uc ON uc.UserID  = A.UserID
WHERE
A.Active = 1
AND ((@classificationID =0) OR (classificationID = @classificationID))
--If classification is Any (0), This will find users of any Custom Classification

-- Get compliance rules for in-scope modules
INSERT INTO @tblCurrentAssignedModules
SELECT
CourseID, UserID, um.UnitID, um.ModuleID, QuizFrequency, QuizCompletionDate
FROM
(SELECT
tU.UserID, tU.UnitID, tM.ModuleID
FROM
dbo.tblUser tU
INNER JOIN dbo.tblOrganisationCourseAccess tOCA ON tOCA.OrganisationID = tU.OrganisationID
INNER JOIN dbo.tblCourse tC ON tC.CourseID = tOCA.GrantedCourseID
INNER JOIN dbo.tblModule tM ON tM.CourseID = tC.CourseID AND tM.Active = 1
LEFT OUTER JOIN dbo.tblUserModuleAccess tUsrMA ON tUsrMA.UserID = tU.UserID
AND tUsrMA.ModuleID = tM.ModuleID
LEFT OUTER JOIN dbo.tblUnitModuleAccess tUnitMA ON tUnitMA.UnitID = tU.UnitID
AND tUnitMA.DeniedModuleID = tM.ModuleID
WHERE
tU.OrganisationID = @organisationID
AND	tU.Active = 1
AND tu.UnitID IS NOT NULL
AND dbo.udfUserCourseComplete(tu.userid, tm.courseid) = 1
AND ((tUnitMA.DeniedModuleID IS NULL AND tUsrMA.ModuleID IS NULL)
OR tUsrMA.Granted=1)
) um
INNER JOIN (
SELECT
u.UnitID, m.CourseID, m.ModuleID,
CASE
WHEN (
ur.QuizFrequency IS NULL
AND ur.QuizCompletionDate IS NULL
AND o.DefaultQuizCompletionDate IS NULL
) THEN
o.DefaultQuizFrequency
ELSE
ur.QuizFrequency
END AS QuizFrequency,
CASE
WHEN (
ur.QuizFrequency IS NULL
AND ur.QuizCompletionDate IS NULL
AND o.DefaultQuizCompletionDate IS NOT NULL
) THEN
o.DefaultQuizCompletionDate
ELSE
ur.QuizCompletionDate
END AS QuizCompletionDate
FROM
tblOrganisationCourseAccess c
INNER JOIN tblModule m ON m.CourseID = c.GrantedCourseID
INNER JOIN tblOrganisation o ON o.OrganisationID = c.OrganisationID -- default compliance rules
INNER JOIN tblUnit u ON u.OrganisationID = c.OrganisationID
LEFT JOIN tblUnitRule ur ON ur.ModuleID = m.ModuleID AND ur.UnitID = u.unitID -- unit specific rules
WHERE o.OrganisationID = @organisationID
) umr ON umr.ModuleID  = um.ModuleID
AND umr.UnitID = um.UnitID
AND um.UnitID IN (SELECT DISTINCT UnitID FROM @users)
AND um.UserID IN (SELECT DISTINCT UserID FROM @users)
AND umr.CourseID IN (SELECT CourseID FROM @courses)

-- Get module completion details
INSERT INTO @tblStartedModules
SELECT
um.userID, um.moduleID, qs.DateTimeCompleted
FROM
@tblCurrentAssignedModules um
INNER JOIN (
SELECT
um.userID, um.moduleID, max(DateTimeCompleted) AS DateTimeCompleted
FROM
@tblCurrentAssignedModules um
INNER JOIN tblQuiz q ON q.ModuleID = um.ModuleID
INNER JOIN tblQuizSession qs ON qs.QuizID= q.quizID
AND qs.userID = um.userID
AND qs.DateTimeCompleted IS NOT NULL
GROUP BY
um.userID, um.moduleID
) AS LastQuizDate ON
LastQuizDate.userID = um.userID
AND LastQuizDate.ModuleID = um.ModuleID
INNER JOIN tblQuiz q ON q.ModuleID = um.ModuleID
INNER JOIN tblQuizSession qs ON
qs.QuizID= q.quizID
AND qs.userID = um.userID
AND qs.DateTimeCompleted = LastQuizDate.DateTimeCompleted

-- User/course combos where the courses are about to be marked incomplete due to module expiry
BEGIN
SELECT
c.[name] as CourseName,
HierarchyName AS UnitPathway,
LastName,
FirstName,
ExternalID,
Email,
UserName,
dbo.udfUTCtoDaylightSavingTime(max(DateTimeCompleted), @organisationID) AS CompletionDate,
dbo.udfUTCtoDaylightSavingTime(min(isnull(QuizCompletionDate, dateadd(month, QuizFrequency, DateTimeCompleted))), @organisationID) AS ExpiryDate
FROM
@tblCurrentAssignedModules cam
INNER JOIN @tblStartedModules sm ON sm.UserID = cam.UserID AND sm.ModuleID = cam.ModuleID,
tblCourse c,
tblUser u,
tblUnitHierarchy h
WHERE
c.CourseID = cam.CourseID
AND u.UserID = cam.UserID
AND h.UnitID = cam.UnitID
GROUP BY
c.[name], HierarchyName,  LastName, FirstName, ExternalID, Email, Username
HAVING
min(isnull(
QuizCompletionDate,
dateadd(month, QuizFrequency, DateTimeCompleted)
)) < CASE @warningUnit
WHEN ''mm'' THEN
dateadd(mm, @warningPeriod, getutcdate())
ELSE
dateadd(dd, @warningPeriod, getutcdate())
END
ORDER BY
CourseName, UnitPathway, LastName, FirstName
END
'
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_WarningGrandTotal]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcReport_WarningGrandTotal]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_WarningGrandTotal]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/******************************************************************************
**		Name: prcReport_WarningGrandTotal
**		Desc: a copy of prcreport_Warning, but with select statements
**				altered to return a total, instead of a list of data.
**
**		Return values: Grand Total distinct users in Warning report
**
**		Auth: Mark Donald
**		Date: 17 Nov 2009
**
*******************************************************************************/

CREATE       Procedure [dbo].[prcReport_WarningGrandTotal]
(
@organisationID		int,
@unitIDs 		varchar(max),
@courseIDs 		varchar(8000),
@classificationID int,
@warningPeriod int,
@warningUnit varchar(2)
)
AS
SET NOCOUNT ON;

DECLARE @Units TABLE (UnitID INT PRIMARY KEY(UnitID))
DECLARE @Courses TABLE(CourseID INT PRIMARY KEY(CourseID))
DECLARE @CoursesWithAccess 	TABLE (CourseID INT PRIMARY KEY(CourseID))
DECLARE @Users TABLE(UserID INT , UnitID INT PRIMARY KEY(UserID, UnitID))
DECLARE @tblCurrentAssignedModules TABLE (
CourseID int,
UserID int,
UnitID int,
ModuleID int,
QuizFrequency int,
QuizCompletionDate datetime
)
DECLARE @tblStartedModules TABLE (
UserID int,
ModuleID int,
DateTimeCompleted datetime
)

INSERT INTO
@Courses
SELECT
*
FROM
dbo.udfCsvToInt(@courseIDs)

INSERT INTO
@Units
SELECT
*
FROM
dbo.udfCsvToInt(@unitIDs)

-- Get users for specfied units, matching Custom Classification option (if provided)
INSERT INTO @Users
SELECT
DISTINCT A.UserID, A.UnitiD
FROM
tblUser A
JOIN @Units B on A.UnitID = B.UnitID
JOIN tblUnit C on B.UnitID = C.UnitID AND C.Active = 1
LEFT JOIN tblUserClassification uc ON uc.UserID  = A.UserID
WHERE
A.Active = 1
AND ((@classificationID =0) OR (classificationID = @classificationID))
--If classification is Any (0), This will find users of any Custom Classification

-- Get compliance rules for in-scope modules
INSERT INTO @tblCurrentAssignedModules
SELECT
CourseID, UserID, um.UnitID, um.ModuleID, QuizFrequency, QuizCompletionDate
FROM
(SELECT
tU.UserID, tU.UnitID, tM.ModuleID
FROM
dbo.tblUser tU
INNER JOIN dbo.tblOrganisationCourseAccess tOCA ON tOCA.OrganisationID = tU.OrganisationID
INNER JOIN dbo.tblCourse tC ON tC.CourseID = tOCA.GrantedCourseID
INNER JOIN dbo.tblModule tM ON tM.CourseID = tC.CourseID AND tM.Active = 1
LEFT OUTER JOIN dbo.tblUserModuleAccess tUsrMA ON tUsrMA.UserID = tU.UserID
AND tUsrMA.ModuleID = tM.ModuleID
LEFT OUTER JOIN dbo.tblUnitModuleAccess tUnitMA ON tUnitMA.UnitID = tU.UnitID
AND tUnitMA.DeniedModuleID = tM.ModuleID
WHERE
tU.OrganisationID = @organisationID
AND	tU.Active = 1
AND tu.UnitID IS NOT NULL
AND dbo.udfUserCourseComplete(tu.userid, tm.courseid) = 1
AND ((tUnitMA.DeniedModuleID IS NULL AND tUsrMA.ModuleID IS NULL)
OR tUsrMA.Granted=1)
) um
INNER JOIN (
SELECT
u.UnitID, m.CourseID, m.ModuleID,
CASE
WHEN (
ur.QuizFrequency IS NULL
AND ur.QuizCompletionDate IS NULL
AND o.DefaultQuizCompletionDate IS NULL
) THEN
o.DefaultQuizFrequency
ELSE
ur.QuizFrequency
END AS QuizFrequency,
CASE
WHEN (
ur.QuizFrequency IS NULL
AND ur.QuizCompletionDate IS NULL
AND o.DefaultQuizCompletionDate IS NOT NULL
) THEN
o.DefaultQuizCompletionDate
ELSE
ur.QuizCompletionDate
END AS QuizCompletionDate
FROM
tblOrganisationCourseAccess c
INNER JOIN tblModule m ON m.CourseID = c.GrantedCourseID
INNER JOIN tblOrganisation o ON o.OrganisationID = c.OrganisationID -- default compliance rules
INNER JOIN tblUnit u ON u.OrganisationID = c.OrganisationID
LEFT JOIN tblUnitRule ur ON ur.ModuleID = m.ModuleID AND ur.UnitID = u.unitID -- unit specific rules
WHERE o.OrganisationID = @organisationID
) umr ON umr.ModuleID  = um.ModuleID
AND umr.UnitID = um.UnitID
AND um.UnitID IN (SELECT DISTINCT UnitID FROM @users)
AND um.UserID IN (SELECT DISTINCT UserID FROM @users)
AND umr.CourseID IN (SELECT CourseID FROM @courses)

-- Get module completion details
INSERT INTO @tblStartedModules
SELECT
um.userID, um.moduleID, qs.DateTimeCompleted
FROM
@tblCurrentAssignedModules um
INNER JOIN (
SELECT
um.userID, um.moduleID, max(DateTimeCompleted) AS DateTimeCompleted
FROM
@tblCurrentAssignedModules um
INNER JOIN tblQuiz q ON q.ModuleID = um.ModuleID
INNER JOIN tblQuizSession qs ON qs.QuizID= q.quizID
AND qs.userID = um.userID
AND qs.DateTimeCompleted IS NOT NULL
GROUP BY
um.userID, um.moduleID
) AS LastQuizDate ON
LastQuizDate.userID = um.userID
AND LastQuizDate.ModuleID = um.ModuleID
INNER JOIN tblQuiz q ON q.ModuleID = um.ModuleID
INNER JOIN tblQuizSession qs ON
qs.QuizID= q.quizID
AND qs.userID = um.userID
AND qs.DateTimeCompleted = LastQuizDate.DateTimeCompleted

BEGIN
SELECT
count(DISTINCT UserID) AS TotalDistinctUsers
FROM
-- User/course combos where the courses are about to be marked incomplete due to module expiry
(SELECT
cam.UserID, max(DateTimeCompleted) AS CompletionDate,
min(isnull(QuizCompletionDate, dateadd(month, QuizFrequency, DateTimeCompleted))) AS ExpiryDate
FROM
@tblCurrentAssignedModules cam
INNER JOIN @tblStartedModules sm ON sm.UserID = cam.UserID AND sm.ModuleID = cam.ModuleID
GROUP BY
cam.UserID
HAVING
min(isnull(
QuizCompletionDate,
dateadd(month, QuizFrequency, DateTimeCompleted)
)) < CASE @warningUnit
WHEN ''mm'' THEN
dateadd(mm, @warningPeriod, getutcdate())
ELSE
dateadd(dd, @warningPeriod, getutcdate())
END) AS warning_report
END
'
END

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcUnit_Search]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcUnit_Search]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUnit_Search]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
The procedure will search within the selected Parent Units for those Units whose name contains the entered text.
(If not Parent Units have been selected, the system will search across the whole organisation.)

Returns:
Unit Name
Full pathway


Called By:
Calls:

Remarks:
The searching units will include all children and grandchildren
Only return units that user has permission to see


Author: Jack Liu
Date Created: 9 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	Aaron		27/03/2007		@parentUnitIDs type modified from Varchar(500)



prcUnit_Search 3,'''',''unit'''' '',4

**/

CREATE  PROCEDURE [dbo].[prcUnit_Search]
(

@organisationID  int,
@parentUnitIDs  varchar(max),
@unitName	nvarchar(100),
@userID		int,
@includingInactiveUnits bit = 0
)
as
set nocount on

declare @intUserTypeID int

select @intUserTypeID = UserTypeID
from tblUser
where userID = @userID

--Check Data
if @parentUnitIDs is null
set @parentUnitIDs =''''

if @unitName is null
set @unitName = ''''

set @unitName =rtrim(@unitName)

-- Return all units even those that are inactive
if (@includingInactiveUnits = 1)
Begin

select 	u.UnitID,
case
when u.Active=1 then u.Name
else u.Name + ''(I)''
end as Name,
dbo.udfGetUnitPathway(u.UnitID) as Pathway
from tblUnit u
left join dbo.udfCsvToInt(@parentUnitIDs) as pu on u.UnitID=pu.intValue
where (u.OrganisationID = @organisationID)
--1. Within the selected Parent Units (can select multiple units)
--The unit hierarchy contains the parent Unit ID
and (
pu.intValue is not null
or (@parentUnitIDs='''')
)
--2. Unit name contains the entered text
and (
(name like ''%''+ @unitName + ''%'')
or (name ='''')
)
--3. Permission
--Salt Administrator(1), Organisation Administrator(2) has permission to access all units
--Unit Administrator(3) only has permission to those that he is administrator
and (
(@intUserTypeID<3)
or (u.UnitID in (select UnitID from tblUnitAdministrator where UserID=@userID))
)
order by name
End
Else
Begin
-- Return only active units
select 	u.UnitID,
u.Name,
dbo.udfGetUnitPathway(u.UnitID) as Pathway
from tblUnit u
left join dbo.udfCsvToInt(@parentUnitIDs) as pu on u.UnitID=pu.intValue
where (u.OrganisationID = @organisationID)
-- Active Units Only
and
(u.Active = 1)
and (
pu.intValue is not null
or (@parentUnitIDs='''')
)
--2. Unit name contains the entered text
and (
(name like ''%''+ @unitName + ''%'')
or (name ='''')
)
--3. Permission
--Salt Administrator(1), Organisation Administrator(2) has permission to access all units
--Unit Administrator(3) only has permission to those that he is administrator
and (
(@intUserTypeID<3)
or (u.UnitID in (select UnitID from tblUnitAdministrator where UserID=@userID))
)
order by name
End


'
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcUser_Search]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcUser_Search]
GO



SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO




IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_Search]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
The procedure will search within the selected Parent Units for those Users whose name contains the entered first and last names.
(If no Parent Units have been selected, the system will search across the whole organisation.)

Returns:
Unit Name
Full pathway

Called By:
Calls:

Remarks:
The searching units will include all children and grandchildren
Only return users that logged on user has permission to see


Author: Gavin Buddis
Date Created: 2 Mar 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	Aaron		27/03/2007		@parentUnitIDs modified from Varchar(500)


**/

CREATE  Procedure  [dbo].[prcUser_Search]
(
@organisationID  Int,
@parentUnitIDs  Varchar(max),
@firstName	nVarchar(100),
@lastName	nVarchar(100),
@adminUserID		Int,
@includeInactiveUsers bit
)
As
Set Nocount On

Declare @intUserTypeID Int

Select @intUserTypeID = UserTypeID
From tblUser
Where userID = @adminUserID

--Check Data
If @parentUnitIDs is null
set @parentUnitIDs =''''

If @firstName is null
Set @firstName = ''''

Set @firstName =rtrim(@firstName)

If @lastName is null
Set @lastName = ''''

Set @lastName =rtrim(@lastName)



if (@includeInactiveUsers = 0)
Begin
Select
us.UserID,
us.UserName,
us.FirstName,
case
When us.Active = 0 then us.LastName + ''(I)''
Else us.LastName
end as LastName,
case
When us.LastLogin Is Null then ''Never''
Else cast(us.LastLogin as varchar)
end as LastLogin,
dbo.udfGetUnitPathway(us.UnitID) as Pathway,
us.Active

From tblUnit un, tblUser us

Where (un.OrganisationID = @organisationID)
and
(
us.Active=1
)
--0. Join Unit and User tables
and (
un.UnitID = us.UnitID
)
--1. Within the selected Parent Units (can select multiple units)
--The unit hierarchy contains the parent Unit ID
and (
un.UnitID in
(
Select IntValue from dbo.udfCsvToInt(@parentUnitIDs)
)
or (@parentUnitIDs='''')
)
--2. User firstname contains the entered text
and (
(firstname like ''%''+ @firstName + ''%'')
or (firstname ='''')
)
--3. User lastname contains the entered text
and (
(lastname like ''%''+ @lastName + ''%'')
or (lastname ='''')
)
--4. Permission
--Salt Administrator(1), Organisation Administrator(2) has permission to access all units
--Unit Administrator(3) only has permission to those that he is administrator
and (
(@intUserTypeID<3)
or (un.UnitID in (select UnitID from tblUnitAdministrator where UserID=@adminUserID))
)
Order By Name
End
Else
Begin
Select 	us.UserID,
us.UserName,
us.FirstName,
case
When us.Active = 0 then us.LastName + ''(I)''
Else us.LastName
end as LastName,
case
When us.LastLogin Is Null then ''Never''
Else cast(us.LastLogin as varchar)
end as LastLogin,
dbo.udfGetUnitPathway(us.UnitID) as Pathway,
us.Active

From tblUnit un, tblUser us

Where (un.OrganisationID = @organisationID)
--0. Join Unit and User tables
and (
un.UnitID = us.UnitID
)
--1. Within the selected Parent Units (can select multiple units)
--The unit hierarchy contains the parent Unit ID
and (
un.UnitID in
(
Select IntValue from dbo.udfCsvToInt(@parentUnitIDs)
)
or (@parentUnitIDs='''')
)
--2. User firstname contains the entered text
and (
(firstname like ''%''+ @firstName + ''%'')
or (firstname ='''')
)
--3. User lastname contains the entered text
and (
(lastname like ''%''+ @lastName + ''%'')
or (lastname ='''')
)
--4. Permission
--Salt Administrator(1), Organisation Administrator(2) has permission to access all units
--Unit Administrator(3) only has permission to those that he is administrator
and (
(@intUserTypeID<3)
or (un.UnitID in (select UnitID from tblUnitAdministrator where UserID=@adminUserID))
)
Order By Name
End
'
END

GO




IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udfReport_CompleteCourseLogic]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udfReport_CompleteCourseLogic]
GO


SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfReport_CompleteCourseLogic]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
/*Summary:
Selects User details for users that have Completed their training

Parameters:
@organisationID Integer,
@unitIDs	string		(Mandatory)
@courseIDs	string		(Mandatory)
@effectiveFromDate	datetime	(optional)
@effectiveToDate	datetime	(optional)
Returns:


Called By:
prcReport_CourseStatusReport

Calls:
fn dbo.udfGetUnitPathway( UnitID )
fn udfReport_completeUsers()
fn udfCsvToInt( csv )


Remarks:


Author:

Execution:


Modification History
-----------------------------------------------------------
v#	Author		Date			Description
**/
CREATE function [dbo].[udfReport_CompleteCourseLogic]
(
@organisationID Integer,	-- Organisation of the user running the report
@unitIDs Varchar(max),		-- string of unit id''s
@courseIDs varchar(8000), 			-- course IDs to restrict search to
@effectiveFromDateOrg datetime = null,	-- effective date of report From
@effectiveToDateOrg datetime = null	-- effective date of report To
)

-------------------------------------------------------------------
Returns @tblReturn Table
(
UserID		Int,
UnitID		Int,
FirstName		nVarchar(255),
LastName 	nVarchar(255),
UnitPathway 	nVarchar(3000),
[Date]		Datetime,
Username		nvarchar(100),
Email		nvarchar(100),
ExternalID		nvarchar(50),
CourseName	nvarchar(200)
)

as
Begin --1
DECLARE @effectiveFromDate 		datetime
DECLARE @effectiveToDate 		datetime
SET @effectiveFromDate = dbo.udfDaylightSavingTimeToUTC(@effectiveFromDateOrg,@OrganisationID)
SET @effectiveToDate = dbo.udfDaylightSavingTimeToUTC(@effectiveToDateOrg,@OrganisationID)

if (@unitIDs is null)
begin --2
----------------------------------------------------
--- Report on all units
----------------------------------------------------
if (@effectiveFromDate is null)
begin --4
----------------------------------------------------
--- Report on the current date
----------------------------------------------------
Insert into
@tblReturn
SELECT
tU1.userID
, tU1.UnitID
, tU1.FirstName
, tU1.LastName
, dbo.udfGetUnitPathway(tU1.UnitID) as ''UnitPathway''
, dbo.udfUTCtoDaylightSavingTime(vUCS.DateCreated,@OrganisationID) as ''Date''
, tU1.Username as ''Username''
, tU1.Email as ''Email''
, tU1.ExternalID as ''ExternalID''
, tC.Name as ''CourseName''
FROM
tblUser tU1
inner join tblUnit
on tU1.UnitID = tblUnit.UnitID
and tblUnit.organisationID = @organisationID
and tU1.Active = 1 --< only want active users >--
and tu1.userTypeID <> 1 --< not interested in saltadmins >--
inner join vwUserCourseStatus vUCS
on vUCS.UserID = tU1.userID
and vUCS.CourseStatusID = 2 --< only want completed users >--
--and vUCS.CourseID in (SELECT * FROM dbo.udfCsvToInt(@courseIDs))--
inner join dbo.udfCsvToInt(@courseIDs)tR
on tR.IntValue = vUCS.CourseID
inner join dbo.tblCourse tC
on tR.IntValue = tC.CourseID
end --/4
else
begin --5

----------------------------------------------------
--- Report on the historic date
----------------------------------------------------
Insert into
@tblReturn
SELECT
tU1.userID
, tU1.UnitID
, tU1.FirstName
, tU1.LastName
, dbo.udfGetUnitPathway(tU1.UnitID) as ''UnitPathway''
, dbo.udfUTCtoDaylightSavingTime(vUCS.DateCreated,@OrganisationID) as ''Date''
, tU1.Username as ''Username''
, tU1.Email as ''Email''
, tU1.ExternalID as ''ExternalID''
, tC.Name as ''CourseName''
FROM
tblUser tU1
inner join tblUnit
on tU1.UnitID = tblUnit.UnitID
and tblUnit.organisationID = @organisationID
and tU1.Active = 1 --< only want active users >--
and tu1.userTypeID <> 1 --< not interested in saltadmins >--
inner join  dbo.udfReport_HistoricUserCourseStatusWithinRange(@effectiveFromDate, @effectiveToDate) vUCS
on vUCS.UserID = tU1.userID
and vUCS.CourseStatusID = 2 --< only want completed users >--
--and vUCS.CourseID in (SELECT * FROM dbo.udfCsvToInt(@courseIDs))--
inner join dbo.udfCsvToInt(@courseIDs)tR
on tR.IntValue = vUCS.CourseID
inner join dbo.tblCourse tC
on tR.IntValue = tC.CourseID
end  --/5
end --/2
else
begin --3
----------------------------------------------------
--- Report on specified units
----------------------------------------------------
if (@effectiveFromDate is null)
Begin --6
----------------------------------------------------
--- Report on the current date
----------------------------------------------------
Insert into
@tblReturn
SELECT
tU1.userID
, tU1.UnitID
, tU1.FirstName
, tU1.LastName
, dbo.udfGetUnitPathway(tU1.UnitID) as ''UnitPathway''
, dbo.udfUTCtoDaylightSavingTime(vUCS.DateCreated,@OrganisationID) as ''Date''
, tU1.Username as ''Username''
, tU1.Email as ''Email''
, tU1.ExternalID as ''ExternalID''
, tC.Name as ''CourseName''
FROM
tblUser tU1
inner join tblUnit on
tU1.UnitID = tblUnit.UnitID
and tblUnit.organisationID = @organisationID
and tU1.Active = 1 --< only want active users >--
and tu1.userTypeID <> 1 --< not interested in saltadmins >--
inner join vwUserCourseStatus vUCS
on vUCS.UserID = tU1.userID
and vUCS.CourseStatusID = 2 --< only want completed users >--
--and vUCS.CourseID in (SELECT * FROM dbo.udfCsvToInt(@courseIDs))--
inner join dbo.udfCsvToInt(@courseIDs)tR
on tR.IntValue = vUCS.CourseID
inner join dbo.tblCourse as tC
on tR.IntValue = tC.CourseID
inner join dbo.udfCsvToInt(@unitIDs) tU
on tU.IntValue = tblUnit.UnitID --< restrict units to thoes in the list >--
end  --/6
else
Begin  --7
----------------------------------------------------
--- Report on the historic date
----------------------------------------------------
Insert into
@tblReturn
SELECT
tU1.userID
, tU1.UnitID
, tU1.FirstName
, tU1.LastName
, dbo.udfGetUnitPathway(tU1.UnitID) as ''UnitPathway''
, dbo.udfUTCtoDaylightSavingTime(vUCS.DateCreated,@OrganisationID) as ''Date''
, tU1.Username as ''Username''
, tU1.Email as ''Email''
, tU1.ExternalID as ''ExternalID''
, tC.Name as ''CourseName''
FROM
tblUser tU1
inner join tblUnit
on tU1.UnitID = tblUnit.UnitID
and tblUnit.organisationID = @organisationID
and tU1.Active = 1 --< only want active users >--
and tu1.userTypeID <> 1 --< not interested in saltadmins >--
inner join  dbo.udfReport_HistoricUserCourseStatusWithinRange(@effectiveFromDate, @effectiveToDate) vUCS
on vUCS.UserID = tU1.userID
and vUCS.CourseStatusID = 2 --< only want completed users >--
--and vUCS.CourseID = @courseID--
inner join dbo.udfCsvToInt(@courseIDs) tR
on tR.IntValue = vUCS.CourseID
inner join dbo.tblCourse as tC
on tR.IntValue = tC.CourseID
inner join dbo.udfCsvToInt(@unitIDs) tU
on tU.IntValue = tblUnit.UnitID --< restrict units to thoes in the list >--
End  --/7
end --/3
return
end -- /1
'
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udfReport_HistoricAdminSummary]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udfReport_HistoricAdminSummary]
GO


SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO




IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfReport_HistoricAdminSummary]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
/*Summary:
Get the Current or historic user module status  based on the search criteria

See the remarks below.

Returns: table

Called By: Current historic Admin Report
Calls:

Remarks:

1. Get User and course List based on search criteria
1.1 Get Unit List
1.1.1 If unit ids are passed in, convert the CSV format to a table
1.1.2 If no unit is selected, get a list of of all units that the admin user has permission to access
1.2 Get User list Based on the first name and last name in the search cirteria
1.3 Get Course list Based on the selected course in the search criteria and Used can select multiple Courses
2. Get the User Quiz and Lesson status up to the effective date
2.1 If there is no effective date is passed in, get the current module status
2.2 If there is effective date, get the module status up to the effective date
3.  Get a list of the user''s quiz and lesson historic status

Author: Jack Liu
Date Created: 1 Mar 2004

Modification History
-----------------------------------------------------------
v#	Author		Date				Description
#1.1	Usman Tjiudri	10/11/2005	Performance tuning:
- use temp-table to populate Unit Pathway
- join the temp-table to populate tblResult
instead of using udfGetUnitPathway function in the join.
#2.0	Serguei Chkaroupine 28/02/06 -New insert statement for histric admin report
- it will insert all lessons that match current quizmodule pair
- Current admin report performance fix. Added WHERE statement to
most of the insert statements.

select * from dbo.udfReport_HistoricAdminSummary(3, '''', ''1,2,3,4'','''','''',''20040222'',4)

--------------------

**/
--instead of using udfGetUnitPathway function in the join.

--select * from dbo.udfReport_HistoricAdminSummary(3, '''', ''1,2,3,4'','''','''',''20040222'',4)

--------------------



CREATE         Function [dbo].[udfReport_HistoricAdminSummary]
(
@organisationID 	Int,
@unitIDs			Varchar(max),
@courseIDs			Varchar(8000),
@userFirstName		nVarchar(50),
@userLastName		nVarchar(50),
@effectiveDate 		Datetime,
@adminUserID		Int,
@classificationID 	Int
)
Returns @tblResult Table
(
-- General
Unit			nVarchar(200),
[User]			nVarchar(100),
Course			nVarchar(100),
Module			nVarchar(100),
[Sequence]		Int,

-- Quiz Specific
QuizStatus		Varchar(50),
QuizScore		Int,
QuizStatusDate	Datetime,

-- Lesson Specific
LessonStatus	Varchar(50),

-- Hidden
UnitID			Int,
UserID			Int,
UserName		nVarchar(100),
ExternalID		nVarchar(50),
CourseID		Int,
ModuleID		Int
)
As Begin
Declare @userTypeID Int
Declare @tblUnit 	Table(UnitID Int)
Declare @tblUser 	Table(UserID Int)
Declare @tblCourse 	Table(CourseID Int, Name nVarchar(50))
Declare @tblUnitPathway Table(UnitID Int, Pathway nVarchar(200)) -- New table

Declare @tblUserQuizStatus Table
(
[UserQuizStatusID] [int] Not Null,
[UserID] [int] Not Null,
[ModuleID] [int] Not Null,
[QuizStatusID] [int] Not Null,
[QuizScore] [int] Null,
[DateCreated] [datetime] Not Null
)

Declare @tblUserLessonStatus Table
(
[UserLessonStatusID] [int] ,
[UserID] [int] ,
[ModuleID] [int] ,
[LessonStatusID] [int] ,
[DateCreated] [datetime]
)


/*
1. Get User and course List based on search criteria
1.1 Get Unit List
1.1.1 If unit ids are passed in, convert the CSV format to a table
1.1.2 If no unit is selected, get a list of of all units that the admin user has permission to access
1.2 Get User list
Based on the first name and last name in the search cirteria
1.3 Get Course list
Based on the selected course in the search criteria
Used can select multiple Courses
*/

If @unitIDs Is Null Set @unitIDs = ''''

If (@unitIDs !='''')
Begin
Insert Into @tblUnit (UnitID)
Select intValue
From dbo.udfCsvToInt(@unitIDs)
End
Else
Begin
Select @userTypeID = userTypeID
From tblUser
Where userID = @adminUserID

--Get all units in that organisation if user is Salt Admin(1) or Org admin (2)
If (@userTypeID=1 Or @userTypeID=2)
Begin
Insert Into @tblUnit (UnitID)
Select UnitID
From tblUnit
Where OrganisationID = @OrganisationID
End
--Get units that the user is admministrator if user is Unit Admin(3)
Else If (@userTypeID=3)
Begin
Insert Into @tblUnit (UnitID)
Select u.UnitID
From tblUnit u
Inner Join tblUnitAdministrator ua On ua.UnitID = u.UnitID And ua.userID = @AdminUserID
Where u.OrganisationID = @OrganisationID
End
End

--FirstName or Last Name specified in search criteria
If (@userFirstName Is Null) Set @userFirstName = ''''
If (@userLastName Is Null) Set @userLastName = ''''

Insert Into @tblUser (UserID)
Select	u.UserID
From tblUser u
Inner Join @tblUnit unit On u.UnitID = unit.UnitID
Left Join tblUserClassification uc On uc.UserID  = u.UserID
Where u.FirstName Like ''%'' + @userFirstName + ''%''
And LastName Like ''%'' + @userLastName + ''%''
And --AND have the Custom Classification option
--If classification is Any (0), This will find users of any Custom Classification
( (@classificationID =0) Or (uc.classificationID = @classificationID) )
And (u.Active=1)
AND (u.OrganisationID = @OrganisationID)

-- Search criteria contains course id''s
Insert Into @tblCourse (CourseID, Name)
Select c.CourseID, c.name
From dbo.udfCsvToInt(@courseIDs) ca
Inner Join tblCourse c On ca.intValue = c.CourseID

/*
2. Get the User Quiz and Lesson status up to the effective date
2.1 If there is no effective date is passed in, get the current module status
2.2 If there is effective date, get the module status up to the effective date
*/

If (@effectiveDate Is Null)
Begin
Insert Into @tblUserQuizStatus
(
[UserQuizStatusID],
[UserID],
[ModuleID],
[QuizStatusID],
[QuizScore],
[DateCreated]
)
Select
[UserQuizStatusID],
[UserID],
[ModuleID],
[QuizStatusID],
[QuizScore],
[DateCreated]
From vwUserQuizStatus
Where QuizStatusID <> 0
AND UserID in  (SELECT UserID FROM @tblUser)

Insert Into @tblUserLessonStatus
(
[UserLessonStatusID],
[UserID],
[ModuleID],
[LessonStatusID],
[DateCreated]
)
Select
[UserLessonStatusID],
[UserID],
[ModuleID],
[LessonStatusID],
[DateCreated]
From vwUserLessonStatus
Where LessonStatusID <> 0
AND UserID in  (SELECT UserID FROM @tblUser)
End

Else

Begin
Insert Into @tblUserQuizStatus
(
[UserQuizStatusID],
[UserID],
[ModuleID],
[QuizStatusID],
[QuizScore],
[DateCreated]
)
Select
[UserQuizStatusID],
[UserID],
[ModuleID],
[QuizStatusID],
[QuizScore],
[DateCreated]
From dbo.udfReport_HistoricUserQuizStatus(@effectiveDate)
Where QuizStatusID <> 0
AND UserID in  (SELECT UserID FROM @tblUser)

Insert Into @tblUserLessonStatus
(
[UserLessonStatusID],
[UserID],
[ModuleID],
[LessonStatusID],
[DateCreated]
)
Select
[UserLessonStatusID],
[UserID],
[ModuleID],
[LessonStatusID],
[DateCreated]
From dbo.udfReport_HistoricUserLessonStatus(@effectiveDate)
Where LessonStatusID <> 0
AND UserID in  (SELECT UserID FROM @tblUser)


-- This part fixes migration issue (note this will affect historic admin report only as it does supply effective date)
-- It will insert userid, moduleid and earliest lesson status for each quiz that does not have lesson record yet
-- into @tblUserLessonStatus
Insert Into @tblUserLessonStatus
(
[UserLessonStatusID],
[UserID],
[ModuleID],
[LessonStatusID],
[DateCreated]
)
Select
1,
uls.[UserID],
uls.[ModuleID],
uls.LessonStatusID,
uls.DateCreated
From  @tblUserQuizStatus uqs
INNER JOIN tblUserLessonStatus uls
ON uqs.UserID = uls.UserID AND uqs.ModuleID = uls.ModuleID
INNER JOIN
(
-- this derived table gets earliest lesson datecreated in a group
SELECT  UserID, ModuleID, min(DateCreated) as DateCreated
FROM tblUserLessonStatus
WHERE UserID in (SELECT UserID FROM @tblUser)
GROUP BY UserID, ModuleID --, DateCreated
) as els -- Earliest Lesson Status
ON els.UserID = uls.UserID AND els.ModuleID = uls.ModuleID AND els.DateCreated = uls.DateCreated
WHERE NOT EXISTS
(
SELECT 1 FROM @tblUserLessonStatus uls
WHERE uqs.UserID = uls.UserID and uqs.ModuleID = uls.ModuleID
)
AND uls.UserID in (SELECT UserID FROM @tblUser)



End

/* Populate Unit Pathway using temp-table */
Insert Into @tblUnitPathway
Select UnitID As [UnitID], dbo.udfGetUnitPathway(UnitID) As [Pathway]
From @tblUnit
--Order By tblUnit.UnitID
-- sp_help udfCsvToInt
/* 3.  Get the user''s quiz and lesson status details */
Insert Into @tblResult
(
Unit,
[User],
Course,
Module,
[Sequence],
QuizStatus,
QuizStatusDate,	-- These columns have been reordered
QuizScore,	    -- These columns have been reordered
LessonStatus,
UnitID,
UserID,
UserName,
ExternalID,
CourseID,
ModuleID
)
Select
-- General
up.Pathway 						As Unit, -- Unit Name
u.LastName + '' '' + u.FirstName  As ''User'', -- User Full Name
c.Name			  				As Course, -- Course Name
m.Name			  				As Module, -- Module Name
m.Sequence						As Sequence,

-- Quiz Specific
qs.Status						As QuizStatus,
uqs.DateCreated 			    as QuizStatusDate,	-- These columns have been reordered
uqs.QuizScore 				    as QuizScore,		-- These columns have been reordered

-- Lesson Specific
ls.status 						As LessonStatus,

-- Hidden
u.UnitID						As UnitID,
u.UserID						As UserID,
u.UserName						As UserName,
u.ExternalID						As ExternalID,
c.CourseID						As CourseID,
m.ModuleID						As ModuleID

From @tblUserQuizStatus uqs
Inner Join tblQuizStatus qs On qs.QuizStatusID = uqs.QuizStatusID
Inner Join @tblUser us 	On us.UserID = uqs.UserID
Inner Join tblUser u On u.UserID = us.UserID
INNER Join @tblUnitPathway up On up.UnitID = u.UnitID
INNER Join tblModule m On m.ModuleID = uqs.ModuleID
INNER Join @tblCourse c On c.CourseID = m.CourseID
INNER Join @tblUserLessonStatus uls On uls.UserID = u.UserID And uls.ModuleID = m.ModuleID
INNER Join tblLessonStatus ls On ls.LessonStatusID = uls.LessonStatusID


Return
End
'
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udfReport_HistoricAdminSummaryOptimised]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udfReport_HistoricAdminSummaryOptimised]
GO


SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfReport_HistoricAdminSummaryOptimised]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
/*Summary:
Get the Current or historic user module status  based on the search criteria
See the remarks below.
Returns: table
Called By: Current historic Admin Report
Calls:
Remarks:
1. Get User and course List based on search criteria
1.1 Get Unit List
1.1.1 If unit ids are passed in, convert the CSV format to a table
1.1.2 If no unit is selected, get a list of of all units that the admin user has permission to access
1.2 Get User list Based on the first name and last name in the search cirteria
1.3 Get Course list Based on the selected course in the search criteria and Used can select multiple Courses
2. Get the User Quiz and Lesson status up to the effective date
2.1 If there is no effective date is passed in, get the current module status
2.2 If there is effective date, get the module status up to the effective date
3.  Get a list of the users quiz and lesson historic status
Author: Jack Liu
Date Created: 1 Mar 2004
Modification History
-----------------------------------------------------------
v#	Author		Date				Description
#1.1	Usman Tjiudri	10/11/2005	Performance tuning:
- use temp-table to populate Unit Pathway
- join the temp-table to populate tblResult
instead of using udfGetUnitPathway function in the join.
#2.0	Serguei Chkaroupine 28/02/06 -New insert statement for histric admin report
- it will insert all lessons that match current quizmodule pair
- Current admin report performance fix. Added WHERE statement to
most of the insert statements.
#3	Mark Donald	27/07/2009			add userName and userEmail params
#4	William Tio	01/12/2009
- remove the wrong logic to exclude the user quiz/lesson status
- replace with ''not exists''

select * from dbo.udfReport_HistoricAdminSummary(3, '''', ''1,2,3,4'','''','''',NULL,NULL,''20040222'',4)
--------------------
**/

CREATE                Function [dbo].[udfReport_HistoricAdminSummaryOptimised]
(
@organisationID 	Int,
@unitIDs			Varchar(max),
@courseIDs			Varchar(8000),
@userFirstName		Varchar(50),
@userLastName		Varchar(50),
@userName			Varchar(100),
@userEmail			Varchar(100),
@effectiveDate 		Datetime,
@adminUserID		Int,
@classificationID 	Int,
@defaultDate		DateTime,
@inclInactive		int
)
Returns @tblResult Table
(
-- General
Unit			nVarchar(200),
[User]			nVarchar(100),
Course			nVarchar(100),
Module			nVarchar(100),
[Sequence]		Int,
-- Quiz Specific
QuizStatus		Varchar(50),
QuizScore		Int,
QuizStatusDate	Datetime,
-- Lesson Specific
LessonStatus	Varchar(50),
-- Hidden
UnitID			Int,
UserID			Int,
UserName		nVarchar(100),
ExternalID		nVarchar(50),
CourseID		Int,
ModuleID		Int,
Active	int
)
As Begin

--Variables declarations
DECLARE @UserTypeID 	INT
DECLARE @tblUnit 				Table(UnitID INT PRIMARY KEY(UnitID))
DECLARE @tblUser 				Table(UserID INT, UnitID INT, Active INT)
DECLARE @tblCourse 				Table(CourseID INT, [Name] NVARCHAR(100) PRIMARY KEY(CourseID))
DECLARE @CoursesWithAccess 		TABLE (CourseID INT PRIMARY KEY(CourseID))
DECLARE @UserModuleWithAccess 	TABLE(UserID INT, ModuleID INT, UnitID INT PRIMARY KEY(UserID, ModuleID, UnitID))
DECLARE @AllModules 			TABLE(ModuleID INT PRIMARY KEY(ModuleID))
DECLARE @tblUserQuizStatus 		Table
(
[UserQuizStatusID] [int] Not Null,
[UserID] [int] Not Null,
[ModuleID] [int] Not Null,
[QuizStatusID] [int] Not Null,
[QuizScore] [int] Null,
[DateCreated] [datetime] Not Null
)
DECLARE @tblUserLessonStatus 	Table
(
[UserLessonStatusID] [int] ,
[UserID] [int] ,
[ModuleID] [int] ,
[LessonStatusID] [int] ,
[DateCreated] [datetime]
)
DECLARE @vwUserModuleAccess table
(
UserID INT not null,
FirstName varchar(255),
LastName varchar(255),
UnitID INT,
OrganisationID INT,
ModuleID INT,
CourseID INT,
CourseName nvarchar(100),
[Name] nvarchar(100),
Sequence INT,
Description nvarchar(1000)
)

DECLARE @tblOrganisationCourseAccess table
(
OrganisationID int,
GrantedCourseID int
)
---------------------------------------------------------------------------------------------

--set the default date depending on effective date
set @defaultdate = coalesce (@effectivedate,@defaultdate)
---------------------------------------------------------------------------------------------

--Check If Unit ID is specified
IF @unitIDs IS NULL
BEGIN
--Check User Type
SELECT
@UserTypeID = UserTypeID
FROM
tblUser
WHERE UserID = @adminUserID

--Get all units in Organisation if user is Salt Admin(1) or Org admin (2)
IF (@UserTypeID = 1 Or @UserTypeID = 2)
BEGIN
INSERT INTO
@tblUnit (UnitID)
SELECT
UnitID
FROM
tblUnit
WHERE OrganisationID = @OrganisationID
END

--Get units that the user is admministrator if user is Unit Admin(3)
IF (@UserTypeID = 3)
BEGIN
INSERT INTO
@tblUnit (UnitID)
SELECT
U.UnitID
FROM
tblUnit U INNER JOIN tblUnitAdministrator UA ON
UA.UnitID = U.UnitID AND
UA.UserID = @adminUserID
WHERE
U.OrganisationID = @OrganisationID
END
END
ELSE
BEGIN
--Seperate comma seperated values as Table rows
INSERT INTO @tblUnit SELECT * FROM  dbo.udfCsvToInt(@unitIDs)
END
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
--FirstName, Last Name, etc specified in search criteria
IF (@userFirstName IS NULL) 	SET @userFirstName = ''''
IF (@userLastName IS NULL) 		SET @userLastName = ''''
IF (@userName IS NULL) 			SET @userName = ''''
IF (@userEmail IS NULL) 		SET @userEmail = ''''

INSERT INTO
@tblUser (UserID, UnitID, Active)
SELECT DISTINCT
U.UserID, U.UnitID, U.Active
FROM
tblUser U INNER JOIN @tblUnit UN ON	U.UnitID = UN.UnitID
and datediff(day,U.datecreated,@defaultdate)>=0-- created on or b4 specified date
LEFT JOIN tblUserClassification UC ON UC.UserID  = U.UserID
WHERE
U.FirstName Like ''%'' + @userFirstName + ''%'' AND
LastName Like ''%'' + @userLastName + ''%'' AND
UserName Like ''%'' + @userName + ''%'' AND
Email Like ''%'' + @userEmail + ''%'' AND
--AND have the Custom Classification option
--If classification is Any (0), This will find users of any Custom Classification
((@classificationID = 0) OR (UC.classificationID = @classificationID)) AND
--inclInactive = 0: do not include inactive user
--inclInactive = 1: include inactive user
(U.Active = CASE @inclInactive WHEN 0 THEN 1 ELSE U.Active END) AND
(U.OrganisationID = @OrganisationID)

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
-- Search criteria contains Course IDs
INSERT INTO
@tblCourse (CourseID, [Name])
SELECT
C.CourseID, C.[Name]
FROM
dbo.udfCsvToInt(@courseIDs) CA INNER JOIN tblCourse C ON
CA.intValue = C.CourseID AND C.Active = 1

-- added to deal with past courses - adds past course to intermediate @tblOrganisationCourseAccess table
-- to mimic it being a current course so results will be returned
insert into
@tblOrganisationCourseAccess (OrganisationID, GrantedCourseID)
select
@Organisationid, C.CourseID
from
dbo.udfCsvToInt(@courseIDs) CA inner join tblCourse C on
CA.intValue = C.CourseID and C.Active = 1

INSERT INTO @vwUserModuleAccess   SELECT   tU.UserID, tU.FirstName, tU.LastName, tU.UnitID, tU.OrganisationID, tM.ModuleID, tM.CourseID, tC.Name AS CourseName, tM.Name, tM.Sequence,
tM.Description
FROM         tblUser AS tU INNER JOIN
@tblUser tbU on tbU.UserID = tU.UserID
inner join
@tblOrganisationCourseAccess AS tOCA ON tOCA.OrganisationID = tU.OrganisationID INNER JOIN
tblCourse AS tC ON tC.CourseID = tOCA.GrantedCourseID INNER JOIN
tblModule AS tM ON tM.CourseID = tC.CourseID AND tM.Active = 1 LEFT OUTER JOIN
tblUserModuleAccess AS tUsrMA ON tUsrMA.UserID = tU.UserID AND tUsrMA.ModuleID = tM.ModuleID LEFT OUTER JOIN
tblUnitModuleAccess AS tUnitMA ON tUnitMA.UnitID = tU.UnitID AND tUnitMA.DeniedModuleID = tM.ModuleID
WHERE     tM.CourseID in (SELECT courseid from @tblCourse ) AND (tU.UnitID IS NOT NULL) AND (tUnitMA.DeniedModuleID IS NULL) AND (tUsrMA.ModuleID IS NULL) OR
(tUsrMA.Granted = 1)
--select * from @vwUserModuleAccess where UnitID is null

INSERT INTO @UserModuleWithAccess
SELECT DISTINCT UserID, ModuleID, UnitID FROM @vwUserModuleAccess where UnitID is not null

INSERT INTO @tblUserQuizStatus
(
[UserQuizStatusID],
[UserID],
[ModuleID],
[QuizStatusID],
[QuizScore],
[DateCreated]
)
SELECT
A.[UserQuizStatusID],
A.[UserID],
A.[ModuleID],
A.[QuizStatusID],
A.[QuizScore],
A.[DateCreated]
FROM
(
SELECT
A.UserID, A.ModuleID, MAX(B.UserQuizStatusID) AS ''LatestQuizID''
FROM
@UserModuleWithAccess A, tblUserQuizStatus B
WHERE
A.UserID = B.UserID AND A.ModuleID = B.ModuleID AND B.QuizStatusID <> 0
AND DateDiff(day, B.DateCreated, @effectiveDate)>=0
GROUP BY
A.UserID, A.ModuleID
) B, tblUserQuizStatus A, @tblUser C
WHERE
A.UserQuizStatusID = B.LatestQuizID AND B.UserID = C.UserID AND A.UserID = C.UserID
-- li June 2008:
-- User who has access to a module but doesnt have a record in tblUserQuizStatus is a new user
-- this logic will include new user in the current and historic admin report before user quiz status
-- is updated by overnight job

INSERT INTO @tblUserQuizStatus
(
[UserQuizStatusID],
[UserID],
[ModuleID],
[QuizStatusID],
[QuizScore],
[DateCreated]
)
SELECT
0, -- UserQuizStatusID
A.[UserID],
A.[ModuleID],
1, -- QuizStatus: Not Started
null, -- QuizScore
@defaultDate -- DateCreated (here set to @defaultdate which is passed in as getDate())
FROM @UserModuleWithAccess A
join  @tblUser B on A.UserID = B.UserID
-- User doesnt have quiz activities
/* WT: this part is replaced with not exists, the logic below will subtract userid with moduleid
where  A.UserID  + ''-'' + A.MODULEID NOT IN
(	Select D.UserID + ''-'' + D.Moduleid
from @tblUserQuizStatus D
where datediff(day, d.datecreated, @defaultdate)>=0)*/
where not exists
(	Select D.UserID, D.Moduleid
from @tblUserQuizStatus D
where datediff(day, d.datecreated, @defaultdate)>=0
and D.Userid=B.userid and D.moduleid=A.moduleid
)
-- end logic for including new users quiz status



Insert Into @tblUserLessonStatus
(
[UserLessonStatusID],
[UserID],
[ModuleID],
[LessonStatusID],
[DateCreated]
)
Select
A.[UserLessonStatusID],
A.[UserID],
A.[ModuleID],
A.[LessonStatusID],
A.[DateCreated]
FROM
(
SELECT
B.UserID, B.ModuleID, MAX(B.UserLessonStatusID) AS ''LatestLessonStatusID''
FROM
@UserModuleWithAccess A, tblUserLessonStatus B
WHERE
A.UserID = B.UserID AND A.ModuleID = B.ModuleID AND
DateDiff(day, B.DateCreated, @effectiveDate)>=0 AND
B.LessonStatusID <> 0 --Unassigned
GROUP BY
B.UserID, B.ModuleID
) B, tblUserLessonStatus A, @tblUser C
WHERE
A.UserLessonStatusID = B.LatestLessonStatusID AND B.UserID = C.UserID AND A.UserID = C.UserID

-- start logic for including new users lesson status
INSERT INTO @tblUserLessonStatus
(
[UserLessonStatusID],
[UserID],
[ModuleID],
[LessonStatusID],
[DateCreated]
)
SELECT
0, -- UserLessonStatusID
A.[UserID],
A.[ModuleID],
1, -- LessonStatus: Not Started
@defaultDate -- DateCreated (here set to @defaultdate which is passed in as getDate())
FROM @UserModuleWithAccess A
join  @tblUser B on A.UserID = B.UserID
where
-- User doesnt have lesson activities for the date entered
/* WT: this part is replaced with not exists, the logic below will subtract userid with moduleid
A.UserID + ''-'' + A.Moduleid NOT IN
(	Select D.UserID + ''-'' + D.Moduleid
from @tblUserLessonStatus D
where datediff(day, d.datecreated, @defaultdate)>=0 )*/
not exists
(	Select D.UserID, D.Moduleid
from @tblUserLessonStatus D
where datediff(day, d.datecreated, @defaultdate)>=0
and D.Userid=B.userid and D.moduleid=A.moduleid
)
-- end logic for including new users lesson status

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
-- This part fixes migration issue (note this will affect historic admin report only as it does supply effective date)
-- It will insert userid, moduleid and earliest lesson status for each quiz that does not have lesson record yet
-- into @tblUserLessonStatus
Insert Into @tblUserLessonStatus
(
[UserLessonStatusID],
[UserID],
[ModuleID],
[LessonStatusID],
[DateCreated]
)
SELECT 1,
A.[UserID],
A.[ModuleID],
B.LessonStatusID,
A.DateCreated
FROM (
SELECT
A.UserID, A.ModuleID, MIN(A.DateCreated) AS ''DateCreated''
FROM
tblUserLessonStatus A, @tblUser B
WHERE
A.UserID = B.UserID
GROUP BY
A.UserID, A.ModuleID
) A , tblUserLessonStatus B WHERE

A.UserID = B.UserID AND A.ModuleID = B.ModuleID AND A.DateCreated = B.DateCreated AND
(CAST(A.UserID AS VARCHAR(10)) + CAST(A.ModuleID AS VARCHAR(10)))
NOT IN (SELECT CAST(A.UserID AS VARCHAR(10)) + CAST(A.ModuleID AS VARCHAR(10)) FROM @tblUserLessonStatus)


---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
Insert Into @tblResult
(
Unit,
[User],
Course,
Module,
[Sequence],
QuizStatus,
QuizStatusDate,	-- These columns have been reordered
QuizScore,	    -- These columns have been reordered
LessonStatus,
UnitID,
UserID,
UserName,
ExternalID,
CourseID,
ModuleID
)
Select distinct
-- General
up.HierarchyName 				As Unit, -- Unit Name
[User] = CASE u.Active when 0 then u.LastName + '' '' + u.FirstName + ''(i)'' ELSE u.LastName + '' '' + u.FirstName End , -- User Full Name
c.Name			  				As Course, -- Course Name
m.Name			  				As Module, -- Module Name
m.Sequence						As Sequence,
-- Quiz Specific
qs.Status						As QuizStatus,
dbo.udfUTCtoDaylightSavingTime(uqs.DateCreated, @organisationID) as QuizStatusDate,	-- These columns have been reordered
uqs.QuizScore 				    as QuizScore,		-- These columns have been reordered
-- Lesson Specific
ls.status 						As LessonStatus,
-- Hidden
u.UnitID						As UnitID,
u.UserID						As UserID,
u.UserName						As UserName,
u.ExternalID						As ExternalID,
c.CourseID						As CourseID,
m.ModuleID						As ModuleID
--u.Active						As Active
From @tblUserQuizStatus uqs
Inner Join tblQuizStatus qs On qs.QuizStatusID = uqs.QuizStatusID
inner Join @tblUser us 	On us.UserID = uqs.UserID
Inner Join tblUser u On u.UserID = us.UserID
INNER Join tblUnitHierarchy up On up.UnitID = u.UnitID
INNER Join tblModule m On m.ModuleID = uqs.ModuleID
INNER Join @tblCourse c On c.CourseID = m.CourseID
INNER Join @tblUserLessonStatus uls On uls.UserID = u.UserID And uls.ModuleID = m.ModuleID
INNER Join tblLessonStatus ls On ls.LessonStatusID = uls.LessonStatusID
where @effectivedate is null or (datediff(day,uqs.datecreated,@effectivedate)>=0 and datediff(day, uls.datecreated, @effectivedate)>=0)
RETURN
END
'
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udfReport_IncompleteCourseLogic]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udfReport_IncompleteCourseLogic]
GO



SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfReport_IncompleteCourseLogic]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
/*Summary:
Selects Users that have not Completed their training

Parameters:
@organisationID	int		(optional)
@unitIDs	string		(optional)
@courseID	int		(Mandatory)
@effectiveFromDate	datetime	(optional)
@effectiveToDate	datetime	(optional)
Returns:
Table

Called By:
dbo.prcReport_CourseStatusReport

Calls:
fn dbo.udfGetUnitPathway( UnitID )
fn udfCsvToInt( csv )
fn udfReport_HistoricUserCourseStatusWithinRange
Remarks:


Author:
Date Created: 16 March 2006

Execution:


Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	j hedlefs		09/06/2011		Timezone
**/

CREATE                function [dbo].[udfReport_IncompleteCourseLogic]
(
@organisationID		Integer=null,		-- Organisation ID to search if the unit is empty
@unitIDs 		varchar(max) = null,	-- string of unit ids
@courseIDs		varchar(8000) = null,		-- course ID to restrict search to
@effectiveFromDateOrg 	datetime = null,	-- effective date of report From
@effectiveToDateOrg	datetime = null		-- effective date of report To
)

-------------------------------------------------------------------
Returns @tblReturn table
(
UserID		Int,
UnitID		Int,
FirstName		nvarchar(255),
LastName 	nvarchar(255),
UnitPathway 	nvarchar(4000),
Username		nvarchar(100),
Email		nvarchar(100),
ExternalID		nvarchar(50),
CourseName	nvarchar(200)
)

as
Begin --1
DECLARE @effectiveFromDate DateTime
SET @effectiveFromDate = dbo.udfDaylightSavingTimeToUTC(@effectiveFromDateOrg,@OrganisationID)
DECLARE @effectiveToDate DateTime
SET @effectiveToDate = dbo.udfDaylightSavingTimeToUTC(@effectiveToDateOrg,@OrganisationID)

if (@effectiveFromDate is null)
Begin
----------------------------------------------------
--- Report on the current date
----------------------------------------------------
if (@unitIDs is null)
begin --2
----------------------------------------------------
--- Report on the current date on all units
----------------------------------------------------
Insert into
@tblReturn
SELECT
tU1.userID
, tU1.UnitID
, tU1.FirstName
, tU1.LastName
, dbo.udfGetUnitPathway(tU1.UnitID) as ''UnitPathway''
, tU1.Username as ''Username''
, tU1.Email as ''Email''
, tU1.ExternalID as ''ExternalID''
, tC.Name as ''CourseName''
FROM
tblUser tU1
inner join tblUnit on
tU1.UnitID = tblUnit.UnitID
and tblUnit.organisationID = @organisationID
and tU1.Active = 1 --< only want active users >--
and tu1.userTypeID <> 1 --< not interested in saltadmins >--
inner join vwUserCourseStatus vUCS
on vUCS.UserID = tU1.userID
and vUCS.CourseStatusID = 1 --< want users that are incomplete >--
inner join dbo.udfCsvToInt(@courseIDs) tR
on tR.IntValue = vUCS.CourseID
inner join dbo.tblCourse as tC
on tR.IntValue = tC.CourseID
end --/2
else
begin --3
----------------------------------------------------
--- Report on the current date on a specific unit
----------------------------------------------------
Insert into
@tblReturn
SELECT
tU1.userID
, tU1.UnitID
, tU1.FirstName
, tU1.LastName
, dbo.udfGetUnitPathway(tU1.UnitID) as ''UnitPathway''
, tU1.Username as ''Username''
, tU1.Email as ''Email''
, tU1.ExternalID as ''ExternalID''
, tC.Name as ''CourseName''
FROM
tblUser tU1
inner join tblUnit on
tU1.UnitID = tblUnit.UnitID
and tblUnit.organisationID = @organisationID
and tU1.Active = 1 --< only want active users >--
and tu1.userTypeID <> 1 --< not interested in saltadmins >--
inner join vwUserCourseStatus vUCS
on vUCS.UserID = tU1.userID
and vUCS.CourseStatusID = 1 --< want users that are incomplete >--
--and vUCS.CourseID = @courseID--
inner join dbo.udfCsvToInt(@courseIDs) tR
on tR.IntValue = vUCS.CourseID
inner join dbo.udfCsvToInt(@unitIDs) tU
on tU.IntValue = tblUnit.UnitID
inner join dbo.tblCourse as tC
on tR.IntValue = tC.CourseID --< restrict units to thoes in the list >--

end --/3
End

Else

Begin
----------------------------------------------------
--- Report on the historic date range provided
----------------------------------------------------
if (@unitIDs is null)
begin --2
----------------------------------------------------
--- Report on the historic date range provided for all units
----------------------------------------------------
Insert into
@tblReturn
SELECT
tU1.userID
, tU1.UnitID
, tU1.FirstName
, tU1.LastName
, dbo.udfGetUnitPathway(tU1.UnitID) as ''UnitPathway''
, tU1.Username as ''Username''
, tU1.Email as ''Email''
, tU1.ExternalID as ''ExternalID''
, tC.Name as ''CourseName''
FROM
tblUser tU1
inner join tblUnit on
tU1.UnitID = tblUnit.UnitID
and tblUnit.organisationID = @organisationID
and tU1.Active = 1 --< only want active users >--
and tu1.userTypeID <> 1 --< not interested in saltadmins >--
inner join  dbo.udfReport_HistoricUserCourseStatusWithinRange(@effectiveFromDate, @effectiveToDate) vUCS
on vUCS.UserID = tU1.userID
and vUCS.CourseStatusID = 1 --< want users that are incomplete >--
--and vUCS.CourseID = @courseID--
inner join dbo.udfCsvToInt(@courseIDs) tR
on tR.IntValue = vUCS.CourseID
inner join dbo.tblCourse as tC
on tR.IntValue = tC.CourseID

end --/2
else
begin --3
----------------------------------------------------------------
--- Report on the historic date range provided for the specified units
----------------------------------------------------------------
Insert into
@tblReturn
SELECT
tU1.userID
, tU1.UnitID
, tU1.FirstName
, tU1.LastName
, dbo.udfGetUnitPathway(tU1.UnitID) as ''UnitPathway''
, tU1.Username as ''Username''
, tU1.Email as ''Email''
, tU1.ExternalID as ''ExternalID''
, tC.Name as ''CourseName''
FROM
tblUser tU1
inner join tblUnit on
tU1.UnitID = tblUnit.UnitID
and tblUnit.organisationID = @organisationID
and tU1.Active = 1 --< only want active users >--
and tu1.userTypeID <> 1 --< not interested in saltadmins >--
inner join  dbo.udfReport_HistoricUserCourseStatusWithRange(@effectiveFromDate, @effectiveToDate) vUCS
on vUCS.UserID = tU1.userID
and vUCS.CourseStatusID = 1 --< want users that are incomplete >--
--and vUCS.CourseID = @courseID--
inner join dbo.udfCsvToInt(@courseIDs) tR
on tR.IntValue = vUCS.CourseID
inner join dbo.tblCourse as tC
on tR.IntValue = tC.CourseID
inner join dbo.udfCsvToInt(@unitIDs) tU
on tU.IntValue = tblUnit.UnitID --< restrict units to thoes in the list >--

end --/3
End
return
end -- /1
'
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfReportSchedule_CalcNextRunDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [udfReportSchedule_CalcNextRunDate]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfReportSchedule_CalcNextRunDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [udfReportSchedule_CalcNextRunDate]
(
@MinimumRun datetime,
@ReportStartDate datetime,
@ReportFrequencyPeriod char(1),
@ReportFrequency int,
@OrgID int
)
RETURNS  datetime
AS
BEGIN
-- NextRun is saved in the ORGs timezone so that when an ORG goes into daylight saving the Report is run at the correct time.
-- ALL other times are saved in the ORGs timezone to reduce load on the GUI when the ORGs timezone is changed
DECLARE @NextRun DateTime
SET @NextRun = @MinimumRun
IF (@NextRun < @ReportStartDate )
BEGIN
     SET @NextRun = @ReportStartDate
END
DECLARE @NumReportPeriodsToNextRun bigint
if (@ReportFrequency = 0)
begin
set @ReportFrequency = 1
end
SELECT @NumReportPeriodsToNextRun =
1 + CASE
WHEN (@ReportFrequencyPeriod=''Y'') THEN DATEDIFF(YEAR,@ReportStartDate,@MinimumRun)/ @ReportFrequency
WHEN (@ReportFrequencyPeriod=''M'') THEN DATEDIFF(MONTH,@ReportStartDate,@MinimumRun)/ @ReportFrequency
WHEN (@ReportFrequencyPeriod=''W'') THEN DATEDIFF(WEEK,@ReportStartDate,@MinimumRun)/ @ReportFrequency
WHEN (@ReportFrequencyPeriod=''D'') THEN DATEDIFF(DAY,@ReportStartDate,@MinimumRun)/ @ReportFrequency
WHEN (@ReportFrequencyPeriod=''H'') THEN DATEDIFF(HOUR,@ReportStartDate,@MinimumRun)/ @ReportFrequency
END



DECLARE @NumReportPeriodsToNow bigint
SELECT @NumReportPeriodsToNow =
CASE
WHEN (@ReportFrequencyPeriod=''Y'') THEN DATEDIFF(YEAR,			@ReportStartDate,dbo.udfUTCtoDaylightSavingTime(getUTCdate(),@OrgID))/ @ReportFrequency
WHEN (@ReportFrequencyPeriod=''M'') THEN DATEDIFF(MONTH,	@ReportStartDate,dbo.udfUTCtoDaylightSavingTime(getUTCdate(),@OrgID))/ @ReportFrequency
WHEN (@ReportFrequencyPeriod=''W'') THEN DATEDIFF(WEEK,		@ReportStartDate,dbo.udfUTCtoDaylightSavingTime(getUTCdate(),@OrgID))/ @ReportFrequency
WHEN (@ReportFrequencyPeriod=''D'') THEN DATEDIFF(DAY,			@ReportStartDate,dbo.udfUTCtoDaylightSavingTime(getUTCdate(),@OrgID))/ @ReportFrequency
WHEN (@ReportFrequencyPeriod=''H'') THEN DATEDIFF(HOUR,		@ReportStartDate,dbo.udfUTCtoDaylightSavingTime(getUTCdate(),@OrgID))/ @ReportFrequency
END


IF ((@NumReportPeriodsToNextRun) < @NumReportPeriodsToNow) --We have missed an entire reporting period!!!
AND (DATEADD(DAY,2,@NextRun) < dbo.udfUTCtoDaylightSavingTime(getUTCdate(),@OrgID))  --- it is more than 2 days that we are behind for this report!!!
BEGIN --- need to skip some reports as the server has been down for a long time or the date has jumped by a big increment and we don''t want to thrash the servers
SELECT @NextRun = CASE -- Just Move NextRun forward so we have at most one report to deliver
WHEN (@ReportFrequencyPeriod=''Y'') THEN DATEADD(YEAR,@NumReportPeriodsToNow*@ReportFrequency,@ReportStartDate)
WHEN (@ReportFrequencyPeriod=''M'') THEN DATEADD(MONTH,@NumReportPeriodsToNow*@ReportFrequency,@ReportStartDate)
WHEN (@ReportFrequencyPeriod=''W'') THEN DATEADD(WEEK,@NumReportPeriodsToNow*@ReportFrequency,@ReportStartDate)
WHEN (@ReportFrequencyPeriod=''D'') THEN DATEADD(DAY,@NumReportPeriodsToNow*@ReportFrequency,@ReportStartDate)
WHEN (@ReportFrequencyPeriod=''H'') THEN DATEADD(HOUR,@NumReportPeriodsToNow*@ReportFrequency,@ReportStartDate)
END
END


-- Return the result of the function
RETURN  @NextRun

END
' 
END

GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcEmail_GetNext]') AND type in (N'P', N'PC'))
DROP PROCEDURE [prcEmail_GetNext]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcEmail_GetNext]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [prcEmail_GetNext]
AS
BEGIN

select
tblEmailQueue.EmailQueueID
into
#tblEmailsToPurge
FROM tblEmailQueue
inner join tblOrganisation on tblOrganisation.OrganisationID = tblEmailQueue.organisationID
join tblAppConfig on name  = ''SEND_AUTO_EMAILS''
where (tblOrganisation.StopEmails = 1 or upper(Value) = ''NO'')

INSERT INTO tblEmailPurged
([ToEmail]
,[ToName]
,[FromEmail]
,[FromName]
,[CC]
,[BCC]
,[Subject]
,[Body]
,[DateCreated]
,[OrganisationID])

SELECT  case when ((CHARINDEX (''>'',AddressTo) > 0) and (CHARINDEX (''<'',AddressTo) > 0)) then SUBSTRING(AddressTo,CHARINDEX (''<'',AddressTo)+1,CHARINDEX (''>'',AddressTo)-CHARINDEX (''<'',AddressTo)-1) else AddressTo end

,case when ((CHARINDEX (''>'',AddressTo) > 0) and (CHARINDEX (''<'',AddressTo) > 0)) then SUBSTRING(AddressTo,1,CHARINDEX (''<'',AddressTo)-1) else AddressTo end
,case when ((CHARINDEX (''>'',AddressFrom) > 0) and (CHARINDEX (''<'',AddressFrom) > 0)) then SUBSTRING(AddressFrom,CHARINDEX (''<'',AddressFrom)+1,CHARINDEX (''>'',AddressFrom)-CHARINDEX (''<'',AddressFrom)-1) else AddressFrom end
,case when ((CHARINDEX (''>'',AddressFrom) > 0) and (CHARINDEX (''<'',AddressFrom) > 0)) then SUBSTRING(AddressFrom,1,CHARINDEX (''<'',AddressFrom)-1) else AddressFrom end
,''''
,AddressBccs
,Subject
,Body
,QueuedTime
,tblEmailQueue.organisationID
FROM tblEmailQueue inner join
#tblEmailsToPurge ON tblEmailQueue.EmailQueueID = #tblEmailsToPurge.EmailQueueID
DELETE FROM tblEmailQueue WHERE EmailQueueID in (SELECT EmailQueueID FROM #tblEmailsToPurge)

DECLARE  @EmailQueueID INT
SELECT @EmailQueueID = MIN (EmailQueueID)
FROM tblEmailQueue
inner join tblOrganisation on tblOrganisation.OrganisationID = tblEmailQueue.organisationID
join tblAppConfig on name  = ''SEND_AUTO_EMAILS''
WHERE (tblOrganisation.StopEmails = 0 AND upper(Value) <> ''NO'')
AND ((SendStarted is NULL) OR (DATEADD(DAY,1,SendStarted) < GETUTCDATE()))


-- A single instance will be calling this procedure so there is no need to do multi-user code here
SELECT TOP (1) EmailQueueID,OrganisationID,AddressTo,AddressBCCs,[Subject],body,AddressSender,AddressFrom,IsHTML,CASE WHEN DATEDIFF(d,QueuedTime,GETUTCDATE()) > 1 THEN 1 ELSE 0 END AS Retry
FROM tblEmailQueue  WHERE @EmailQueueID =  EmailQueueID
UPDATE tblEmailQueue SET SendStarted = GETUTCDATE()  WHERE @EmailQueueID =  EmailQueueID

END
' 
END
GO




IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPreprocessOneOrgUnassignedCourses]') AND type in (N'P', N'PC'))
DROP PROCEDURE [prcPreprocessOneOrgUnassignedCourses]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPreprocessOneOrgUnassignedCourses]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcPreprocessOneOrgUnassignedCourses] @orgid INT
AS
BEGIN
	-- **********************************
	--< This procedure looks for Courses for which a user  >--
	--<   * has no access to any modules>--
	--<    * currently has a Course Status other than unAssigned>--
	--< All Couses in the Organisation that match these criteria are set to ''Unassigned''>--
	--< it is believed that the overnight job currently handles the reverse of this case correctly.>--
	--< don''t want to overload the cpu when admins are making big changes by assigning courses to units/ etc>--
	--< so don''t ''clean up'' the status of courses for at least one day after the last update to this course status.>--
	-- **********************************

	DECLARE @when DATETIME

	SET @when = DATEADD(d, - 1, getutcdate())

	INSERT INTO tblUserCourseStatus (
		[UserID]
		,[CourseID]
		,[CourseStatusID]
		,[ModulesAssigned]
		,[DateCreated]
		)
	SELECT CCS.UserID
		,CCS.CourseID
		,0
		,'''' AS ModulesAssigned
		,GETUTCDATE() AS DateCreated
	FROM tblUserCourseStatus CCS  --< Detail Course Status information >--
	INNER JOIN (
																					--<  Last (Latest) Course Status  >--
		SELECT max(tblUserCourseStatus.UserCourseStatusID) AS maxUserCourseStatusID
			,tbluser.UserID
			,CourseID
		FROM tblUserCourseStatus
		INNER JOIN tblUser ON tblUser.UserID = tblUserCourseStatus.UserID
		WHERE tblUser.OrganisationID = @orgid
			AND tblUser.Active = 1
		GROUP BY tbluser.UserID
			,CourseID
																					--<  Last (Latest) Course Status  >--
		) lastStatus ON lastStatus.CourseID = CCS.CourseID
		AND lastStatus.UserID = CCS.UserID
		AND lastStatus.maxUserCourseStatusID = CCS.UserCourseStatusID
	LEFT JOIN (
																					--<         C   A   M              >--
																					--<   Current   Assigned  Modules  >--
																					--<   All modules a User Currently has access to                       >--
		SELECT um.UserID
			,um.ModuleID
			,um.CourseID
		FROM (
			SELECT tU.UserID
				,tU.UnitID
				,tU.OrganisationID
				,tM.ModuleID
				,tC.CourseID
			FROM dbo.tblUser tU
			--< get the courses a user has access to >--
			INNER JOIN dbo.tblOrganisationCourseAccess tOCA ON tOCA.OrganisationID = tU.OrganisationID
			--< get the course details >--
			INNER JOIN dbo.tblCourse tC ON tC.CourseID = tOCA.GrantedCourseID
			--< get the Active modules in a course >--
			INNER JOIN dbo.tblModule tM ON tM.CourseID = tC.CourseID
				AND tM.Active = 1
			--< get the details on which modules a user is configured to access >--
			LEFT OUTER JOIN dbo.tblUserModuleAccess tUsrMA ON tUsrMA.UserID = tU.UserID
				AND tUsrMA.ModuleID = tM.ModuleID
			--< get the details on which modules a user''s Unit is excluded from  >--
			LEFT OUTER JOIN dbo.tblUnitModuleAccess tUnitMA ON tUnitMA.UnitID = tU.UnitID
				AND tUnitMA.DeniedModuleID = tM.ModuleID
			WHERE tU.OrganisationID = @OrgID
				AND tU.Active = 1
				--< Active users only >--
				AND (
					tu.UnitID IS NOT NULL
					--< Get the modules that the user''s Unit is not denied >--
					AND (
						tUnitMA.DeniedModuleID IS NULL
						--<  and the user does  have special access to  it>--
						AND tUsrMA.ModuleID IS NULL
						)
					--< or Get modules that the user has been specially  granted >--
					OR tUsrMA.Granted = 1
					)
			) um
		INNER JOIN (
			SELECT u.UnitID
				,m.CourseID
				,m.ModuleID
			FROM tblOrganisationCourseAccess c
			INNER JOIN tblModule m ON m.CourseID = c.GrantedCourseID
			INNER JOIN tblOrganisation o -- Get default compliance rules
				ON o.OrganisationID = c.OrganisationID
			INNER JOIN tblUnit u ON u.OrganisationID = c.OrganisationID
			WHERE o.OrganisationID = @OrgID
			) umr ON umr.ModuleID = um.ModuleID
			AND umr.UnitID = um.UnitID
			AND um.UnitID IN (
				SELECT UnitID
				FROM tblUnit
				WHERE OrganisationID = @OrgID
				)
			AND um.UserID IN (
				SELECT UserID
				FROM tblUser
				WHERE OrganisationID = @OrgID
				)
																							--<   C   A   M   >--

		) CAM ON CAM.userid = CCS.userid
		AND cam.CourseID = CCS.CourseID
	WHERE CAM.UserID IS NULL
		AND CCS.CourseStatusID <> 0
		AND CCS.DateCreated < @when
END
' 
END
GO




--CREATE NONCLUSTERED INDEX IX_tblUser_Org
--ON [dbo].[tblUser] ([OrganisationID],[Active])
--INCLUDE ([UserID])
--GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[tblUser]') AND name = N'IX_tblUser_Org')
CREATE NONCLUSTERED INDEX [IX_tblUser_Org] ON [tblUser] 
(
	[OrganisationID] ASC,
	[Active] ASC
)
INCLUDE ( [UserID]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO




---CREATE NONCLUSTERED INDEX IX_tblUserCourseStatus3
---ON [dbo].[tblUserCourseStatus] ([CourseStatusID],[DateCreated])
---INCLUDE ([UserCourseStatusID],[UserID],[CourseID])
---GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[tblUserCourseStatus]') AND name = N'IX_tblUserCourseStatus3')
CREATE NONCLUSTERED INDEX [IX_tblUserCourseStatus3] ON [tblUserCourseStatus] 
(
	[CourseStatusID] ASC,
	[DateCreated] ASC
)
INCLUDE ( [UserCourseStatusID],
[UserID],
[CourseID]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOvernightJobPreprocessOneOrg]') AND type in (N'P', N'PC'))
DROP PROCEDURE [prcOvernightJobPreprocessOneOrg]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOvernightJobPreprocessOneOrg]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE Procedure [prcOvernightJobPreprocessOneOrg]
AS
BEGIN


declare @cursor_OrgID	    int
-- get the next OrgID (prcOvernightJobGetNextPreprocessingOrg remembers the last OrgID to be preprocessed)
exec @cursor_OrgID = dbo.prcOvernightJobGetNextPreprocessingOrg

-- update the UserLessonStatus for this org (handles the administrative changes to modules assigned to students)
--(originally this appears to have been done by triggers but it appears that the triggers slowed the ASP.NET WebPage too much and were replaced by the overnight job)
exec prcUserLessonStatus_Update_Quick @cursor_OrgID

exec prcPreprocessOneOrgUnassignedCourses @cursor_OrgID
exec prcPreprocessOneOrgAssignedCourses @cursor_OrgID
exec prcPreprocessOneOrgNoLongerPassedCourses @cursor_OrgID
exec prcPreprocessOneOrgNoLongerFailedCourses @cursor_OrgID

END' 
END
GO





IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUserQuizStatus_Update_Quick]') AND type in (N'P', N'PC'))
DROP PROCEDURE [prcUserQuizStatus_Update_Quick]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUserQuizStatus_Update_Quick]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/****** Object:  Stored Procedure dbo.prcUserQuizStatus_Update_Quick    Script Date: 3/05/2004 10:56:48 AM ******/

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

prcUserQuizStatus_Update_Quick

**/
CREATE   Procedure [prcUserQuizStatus_Update_Quick]
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
on q.ModuleID = um.ModuleID and q.active = 1
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


--DECLARE @DaysWarningBeforeExpiry int
--SELECT @DaysWarningBeforeExpiry = DaysWarningBeforeExpiry FROM tblOrganisation where OrganisationID = @OrgID
--IF (@DaysWarningBeforeExpiry IS NULL)
--BEGIN -- Default value of 30 days before quiz -- no longer use 30 days default
--	DECLARE @QuizExpiryDate DateTime
--	SELECT @QuizExpiryDate = dateadd(d,-30,QuizDueDate) FROM tblOrganisation where OrganisationID = @OrgID

--	delete from tblQuizExpiryAtRisk where OrganisationID = @OrgID
--	and not exists (select @OrgID,cam.UserID,
--	cam.ModuleID, DateDiff(day,dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID), dateadd(month, cam.QuizFrequency, dbo.udfUTCtoDaylightSavingTime(sm.DateTimeCompleted,@OrgID)))
--	from #tblCurrentAssignedModules cam
--	inner join #tblStartedModules sm
--	on sm.UserID = cam.UserID
--	and sm.ModuleID = cam.ModuleID
--	where
--	(
--		cam.QuizCompletionDate is null
--		and dbo.udfGetSaltOrgDate(@OrgID) < @QuizExpiryDate
--		and tblQuizExpiryAtRisk.UserID = cam.UserID
--		and tblQuizExpiryAtRisk.ModuleID = cam.ModuleID
--		and tblQuizExpiryAtRisk.OrganisationID = @OrgID
--	))
--	SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_Update_Quick'',''delete from tblQuizExpiryAtRisk'',''delete from tblQuizExpiryAtRisk'',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_Update_Quick'',1,1,null,getutcdate(),getutcdate()) END



--	insert into tblQuizExpiryAtRisk -- add new users who meet the 30 days default rule
--	(
--	OrganisationID,
--	UserID,
--	ModuleID,
--	DaysToExpiry
--	)
--	select @OrgID,cam.UserID,
--	cam.ModuleID, 30
--	from #tblCurrentAssignedModules cam
--	inner join #tblStartedModules sm
--	on sm.UserID = cam.UserID
--	and sm.ModuleID = cam.ModuleID
--	where
--	(
--		cam.QuizCompletionDate is null
--		and dbo.udfGetSaltOrgDate(@OrgID) < @QuizExpiryDate
--	)
--	and not exists
--		(SELECT * FROM tblQuizExpiryAtRisk
--		where 	tblQuizExpiryAtRisk.UserID = cam.UserID
--		and tblQuizExpiryAtRisk.ModuleID = cam.ModuleID
--		and tblQuizExpiryAtRisk.OrganisationID = @OrgID)
--	SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_Update_Quick'',''insert into tblQuizExpiryAtRisk'',''insert into tblQuizExpiryAtRisk'',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_Update_Quick'',1,1,null,getutcdate(),getutcdate()) END

--END





delete from tblQuizExpiryAtRisk where OrganisationID = @OrgID   -- delete from ExpiryAtRisk those users who somehow are no longer at risk
and not exists (
--select @OrgID,cam.UserID,
--cam.ModuleID, DateDiff(day,dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID), dateadd(month, cam.QuizFrequency, dbo.udfUTCtoDaylightSavingTime(sm.DateTimeCompleted,@OrgID)))
--from #tblCurrentAssignedModules cam
--inner join #tblStartedModules sm
--on sm.UserID = cam.UserID
--and sm.ModuleID = cam.ModuleID
--where
--(
--	cam.QuizCompletionDate is null
--	and DateDiff(day, dateadd(month, cam.QuizFrequency, dbo.udfUTCtoDaylightSavingTime(sm.DateTimeCompleted,@OrgID)),dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID)) <= @DaysWarningBeforeExpiry
--	and tblQuizExpiryAtRisk.UserID = cam.UserID
--	and tblQuizExpiryAtRisk.ModuleID = cam.ModuleID
--	and tblQuizExpiryAtRisk.OrganisationID = @OrgID
--)
select @OrgID,cam.UserID,
cam.ModuleID,
DateDiff(day,dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID),
dateadd(month, cam.QuizFrequency,
dbo.udfUTCtoDaylightSavingTime(sm.DateTimeCompleted,@OrgID)))
FROM #tblCurrentAssignedModules cam
INNER JOIN #tblStartedModules sm	ON sm.UserID = cam.UserID	AND sm.ModuleID = cam.ModuleID
INNER JOIN tblModule M ON M.moduleID = sm.moduleID
INNER JOIN tblReminderEscalation RemEsc ON  RemEsc.CourseID = M.CourseID
WHERE RemEsc.OrgID = @OrgID AND RemEsc.RemindUsers = 1 AND
(
(
cam.QuizCompletionDate IS NULL
and (dbo.udfUTCtoDaylightSavingTime(	getutcdate(),@OrgID)
>
DateAdd(                -- Expiry date minus days before expiry to warn user
day
,-RemEsc.DaysQuizExpiry
,dateadd( -- Expiry date
month
, cam.QuizFrequency
, dbo.udfUTCtoDaylightSavingTime(sm.DateTimeCompleted,@OrgID)))
)
)
OR

(
cam.QuizCompletionDate IS NOT NULL
and DateDiff(day, dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID), cam.QuizCompletionDate) <= RemEsc.DaysQuizExpiry
)
)
)
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_Update_Quick'',''delete from tblQuizExpiryAtRisk'',''delete from tblQuizExpiryAtRisk'',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_Update_Quick'',1,1,null,getutcdate(),getutcdate()) END



insert into tblQuizExpiryAtRisk -- add users that are now AtRisk that were not already flagged as AtRisk
(
OrganisationID,
UserID,
ModuleID,
DaysToExpiry
)

select @OrgID,cam.UserID,
cam.ModuleID,
CASE WHEN ( cam.QuizFrequency IS NULL )
then DateDiff(day,dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID),
QuizCompletionDate)

ELSE
DateDiff(day,dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID),
dateadd(month, cam.QuizFrequency,
dbo.udfUTCtoDaylightSavingTime(sm.DateTimeCompleted,@OrgID)))
END

FROM #tblCurrentAssignedModules cam
INNER JOIN #tblStartedModules sm	ON sm.UserID = cam.UserID	AND sm.ModuleID = cam.ModuleID
INNER JOIN tblModule M ON M.moduleID = sm.moduleID
INNER JOIN tblReminderEscalation RemEsc ON  RemEsc.CourseID = M.CourseID
WHERE RemEsc.OrgID = @OrgID AND RemEsc.RemindUsers = 1 AND
(
(
cam.QuizCompletionDate IS NULL
and (dbo.udfUTCtoDaylightSavingTime(	getutcdate(),@OrgID)
>
DateAdd(                -- Expiry date minus days before expiry to warn user
day
,-RemEsc.DaysQuizExpiry
,dateadd( -- Expiry date
month
, cam.QuizFrequency
, dbo.udfUTCtoDaylightSavingTime(sm.DateTimeCompleted,@OrgID)))
)
)
OR

(
cam.QuizCompletionDate IS NOT NULL
and DateDiff(day, dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID), cam.QuizCompletionDate) <= RemEsc.DaysQuizExpiry
)
)
and not exists
(SELECT * FROM tblQuizExpiryAtRisk
where 	tblQuizExpiryAtRisk.UserID = cam.UserID
and tblQuizExpiryAtRisk.ModuleID = cam.ModuleID
and tblQuizExpiryAtRisk.OrganisationID = @OrgID)
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_Update_Quick'',''insert into tblQuizExpiryAtRisk'',''insert into tblQuizExpiryAtRisk'',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_Update_Quick'',1,1,null,getutcdate(),getutcdate()) END








drop table  #tblCurrentUserQuizStatus

drop table #tblCurrentAssignedModules

drop table #tblStartedModules
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


SET QUOTED_IDENTIFIER OFF
' 
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPreprocessOneOrgAssignedCourses]') AND type in (N'P', N'PC'))
DROP PROCEDURE [prcPreprocessOneOrgAssignedCourses]
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPreprocessOneOrgAssignedCourses]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcPreprocessOneOrgAssignedCourses] @orgid INT
AS
BEGIN

	-- **********************************
	--< This procedure looks for Courses for which a user  >--
	--<   * has access to any modules>--
	--<    * currently has a Course Status of unAssigned>--
	--< All Couses in the Organisation that match these criteria have their status recalculated >--
	-- **********************************




declare @UserID int, @ModuleID int
DECLARE ModuleLOOP CURSOR
FOR
	SELECT   
	CCS.UserID,	uma.moduleid

	FROM tblUserCourseStatus CCS  --< Detail Course Status information >--
	INNER JOIN (
																					--<  Last (Latest) Course Status  >--
		SELECT max(tblUserCourseStatus.UserCourseStatusID) AS maxUserCourseStatusID
			,tbluser.UserID
			,CourseID
		FROM tblUserCourseStatus
		INNER JOIN tblUser ON tblUser.UserID = tblUserCourseStatus.UserID
		WHERE  tblUser.OrganisationID = @OrgID AND tblUser.Active = 1
		GROUP BY tbluser.UserID
			,CourseID
																					--<  Last (Latest) Course Status  >--
		) lastStatus ON lastStatus.CourseID = CCS.CourseID
		AND lastStatus.UserID = CCS.UserID
		AND lastStatus.maxUserCourseStatusID = CCS.UserCourseStatusID
		
		inner join vwUserModuleAccess UMA on UMA.CourseID = CCS.CourseID and UMA.UserID = CCS.UserID
		
	WHERE  CCS.CourseStatusID  =  0
Open ModuleLOOP

FETCH NEXT FROM ModuleLOOP
Into
@UserID, @ModuleID

WHILE @@FETCH_STATUS = 0
BEGIN
	EXEC prcUserQuizStatus_UpdateCourseStatus @UserID, @ModuleID
	DECLARE @Err integer
	SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcPreprocessOneOrgAssignedCourses'',''prcUserQuizStatus_UpdateCourseStatus'',''prcUserQuizStatus_UpdateCourseStatus'',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_Update_Quick'',1,1,null,getutcdate(),getutcdate()) END


FETCH NEXT FROM ModuleLOOP
Into
@UserID, @ModuleID
END

CLOSE ModuleLOOP
DEALLOCATE ModuleLOOP




END
' 
END


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPreprocessOneOrgNoLongerFailedCourses]') AND type in (N'P', N'PC'))
DROP PROCEDURE [prcPreprocessOneOrgNoLongerFailedCourses]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPreprocessOneOrgNoLongerFailedCourses]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create PROCEDURE [prcPreprocessOneOrgNoLongerFailedCourses] @orgid INT
AS
BEGIN

	-- **********************************
	--< This procedure looks for Courses for which a user  >--
	--<   * has access to any modules with a status of '' Passed''>--
	--<   * has NO access to any modules with a status of ''Not Passed''>--
	--<    * currently has a Course Status of NOT Passed>--
	--< All Couses in the Organisation that match these criteria have their status recalculated >--
	-- **********************************




declare @UserID int, @ModuleID int
DECLARE ModuleLOOP CURSOR
FOR
	SELECT   
	CCS.UserID,	CAM.moduleid
	FROM tblUserCourseStatus CCS  --< Detail Course Status information >--
	INNER JOIN (
																					--<  Last (Latest) Course Status  >--
		SELECT max(tblUserCourseStatus.UserCourseStatusID) AS maxUserCourseStatusID
			,tbluser.UserID
			,CourseID
		FROM tblUserCourseStatus
		INNER JOIN tblUser ON tblUser.UserID = tblUserCourseStatus.UserID
		WHERE tblUser.OrganisationID = @orgid
			AND tblUser.Active = 1
		GROUP BY tbluser.UserID
			,CourseID
																					--<  Last (Latest) Course Status  >--
		) lastStatus ON lastStatus.CourseID = CCS.CourseID
		AND lastStatus.UserID = CCS.UserID
		AND lastStatus.maxUserCourseStatusID = CCS.UserCourseStatusID
	INNER JOIN (
																					--<         C   A   M              >--
																					--<   Current   Assigned  Modules  >--
																					--<   All modules a User Currently has access to                       >--
		SELECT um.UserID
			,um.ModuleID
			,um.CourseID
		FROM (
			SELECT tU.UserID
				,tU.UnitID
				,tU.OrganisationID
				,tM.ModuleID
				,tC.CourseID
			FROM dbo.tblUser tU
			--< get the courses a user has access to >--
			INNER JOIN dbo.tblOrganisationCourseAccess tOCA ON tOCA.OrganisationID = tU.OrganisationID
			--< get the course details >--
			INNER JOIN dbo.tblCourse tC ON tC.CourseID = tOCA.GrantedCourseID
			--< get the Active modules in a course >--
			INNER JOIN dbo.tblModule tM ON tM.CourseID = tC.CourseID
				AND tM.Active = 1
			--< get the details on which modules a user is configured to access >--
			LEFT OUTER JOIN dbo.tblUserModuleAccess tUsrMA ON tUsrMA.UserID = tU.UserID
				AND tUsrMA.ModuleID = tM.ModuleID
			--< get the details on which modules a user''s Unit is excluded from  >--
			LEFT OUTER JOIN dbo.tblUnitModuleAccess tUnitMA ON tUnitMA.UnitID = tU.UnitID
				AND tUnitMA.DeniedModuleID = tM.ModuleID
			WHERE tU.OrganisationID = @OrgID
				AND tU.Active = 1
				--< Active users only >--
				AND (
					tu.UnitID IS NOT NULL
					--< Get the modules that the user''s Unit is not denied >--
					AND (
						tUnitMA.DeniedModuleID IS NULL
						--<  and the user does  have special access to  it>--
						AND tUsrMA.ModuleID IS NULL
						)
					--< or Get modules that the user has been specially  granted >--
					OR tUsrMA.Granted = 1
					)
			) um
		INNER JOIN (
			SELECT u.UnitID
				,m.CourseID
				,m.ModuleID
			FROM tblOrganisationCourseAccess c
			INNER JOIN tblModule m ON m.CourseID = c.GrantedCourseID
			INNER JOIN tblOrganisation o -- Get default compliance rules
				ON o.OrganisationID = c.OrganisationID
			INNER JOIN tblUnit u ON u.OrganisationID = c.OrganisationID
			WHERE o.OrganisationID = @OrgID
			) umr ON umr.ModuleID = um.ModuleID
			AND umr.UnitID = um.UnitID
			AND um.UnitID IN (
				SELECT UnitID
				FROM tblUnit
				WHERE OrganisationID = @OrgID
				)
			AND um.UserID IN (
				SELECT UserID
				FROM tblUser
				WHERE OrganisationID = @OrgID
				)
																							--<   C   A   M   >--


		) CAM ON CAM.userid = CCS.userid
		AND cam.CourseID = CCS.CourseID
		
		inner join (select QuizStatus.UserID,QuizStatus.ModuleID,QuizStatus.QuizStatusID from
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
where m.active = 1 and QuizStatus.QuizStatusID = 2
) PMS on PMS.UserID=CAM.UserID and PMS.ModuleID = CAM.ModuleID  --PassedModulesStatus
left join (select QuizStatus.UserID,QuizStatus.ModuleID,QuizStatus.QuizStatusID from
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
where m.active = 1 and QuizStatus.QuizStatusID <> 2 -- FailedUserQuizStatus
) FQS on FQS.UserID=CAM.UserID and FQS.ModuleID = CAM.ModuleID		
	WHERE 
	  CCS.CourseStatusID = 1 and PMS.QuizStatusID =2		and FQS.QuizStatusID IS NULL




Open ModuleLOOP

FETCH NEXT FROM ModuleLOOP
Into
@UserID, @ModuleID

WHILE @@FETCH_STATUS = 0
BEGIN
	EXEC prcUserQuizStatus_UpdateCourseStatus @UserID, @ModuleID
	DECLARE @Err integer
	SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcPreprocessOneOrgAssignedCourses'',''prcUserQuizStatus_UpdateCourseStatus'',''prcUserQuizStatus_UpdateCourseStatus'',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_Update_Quick'',1,1,null,getutcdate(),getutcdate()) END


FETCH NEXT FROM ModuleLOOP
Into
@UserID, @ModuleID
END

CLOSE ModuleLOOP
DEALLOCATE ModuleLOOP




END
' 
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPreprocessOneOrgNoLongerPassedCourses]') AND type in (N'P', N'PC'))
DROP PROCEDURE [prcPreprocessOneOrgNoLongerPassedCourses]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPreprocessOneOrgNoLongerPassedCourses]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create PROCEDURE [prcPreprocessOneOrgNoLongerPassedCourses] @orgid INT
AS
BEGIN

	-- **********************************
	--< This procedure looks for Courses for which a user  >--
	--<   * has access to any modules with a status of ''Not Passed''>--
	--<    * currently has a Course Status of Passed>--
	--< All Couses in the Organisation that match these criteria have their status recalculated >--
	-- **********************************




declare @UserID int, @ModuleID int
DECLARE ModuleLOOP CURSOR
FOR
	SELECT   
	CCS.UserID,	CAM.moduleid
	FROM tblUserCourseStatus CCS  --< Detail Course Status information >--
	INNER JOIN (
																					--<  Last (Latest) Course Status  >--
		SELECT max(tblUserCourseStatus.UserCourseStatusID) AS maxUserCourseStatusID
			,tbluser.UserID
			,CourseID
		FROM tblUserCourseStatus
		INNER JOIN tblUser ON tblUser.UserID = tblUserCourseStatus.UserID
		WHERE tblUser.OrganisationID = @orgid
			AND tblUser.Active = 1
		GROUP BY tbluser.UserID
			,CourseID
																					--<  Last (Latest) Course Status  >--
		) lastStatus ON lastStatus.CourseID = CCS.CourseID
		AND lastStatus.UserID = CCS.UserID
		AND lastStatus.maxUserCourseStatusID = CCS.UserCourseStatusID
	INNER JOIN (
																					--<         C   A   M              >--
																					--<   Current   Assigned  Modules  >--
																					--<   All modules a User Currently has access to                       >--
		SELECT um.UserID
			,um.ModuleID
			,um.CourseID
		FROM (
			SELECT tU.UserID
				,tU.UnitID
				,tU.OrganisationID
				,tM.ModuleID
				,tC.CourseID
			FROM dbo.tblUser tU
			--< get the courses a user has access to >--
			INNER JOIN dbo.tblOrganisationCourseAccess tOCA ON tOCA.OrganisationID = tU.OrganisationID
			--< get the course details >--
			INNER JOIN dbo.tblCourse tC ON tC.CourseID = tOCA.GrantedCourseID
			--< get the Active modules in a course >--
			INNER JOIN dbo.tblModule tM ON tM.CourseID = tC.CourseID
				AND tM.Active = 1
			--< get the details on which modules a user is configured to access >--
			LEFT OUTER JOIN dbo.tblUserModuleAccess tUsrMA ON tUsrMA.UserID = tU.UserID
				AND tUsrMA.ModuleID = tM.ModuleID
			--< get the details on which modules a user''s Unit is excluded from  >--
			LEFT OUTER JOIN dbo.tblUnitModuleAccess tUnitMA ON tUnitMA.UnitID = tU.UnitID
				AND tUnitMA.DeniedModuleID = tM.ModuleID
			WHERE tU.OrganisationID = @OrgID
				AND tU.Active = 1
				--< Active users only >--
				AND (
					tu.UnitID IS NOT NULL
					--< Get the modules that the user''s Unit is not denied >--
					AND (
						tUnitMA.DeniedModuleID IS NULL
						--<  and the user does  have special access to  it>--
						AND tUsrMA.ModuleID IS NULL
						)
					--< or Get modules that the user has been specially  granted >--
					OR tUsrMA.Granted = 1
					)
			) um
		INNER JOIN (
			SELECT u.UnitID
				,m.CourseID
				,m.ModuleID
			FROM tblOrganisationCourseAccess c
			INNER JOIN tblModule m ON m.CourseID = c.GrantedCourseID
			INNER JOIN tblOrganisation o -- Get default compliance rules
				ON o.OrganisationID = c.OrganisationID
			INNER JOIN tblUnit u ON u.OrganisationID = c.OrganisationID
			WHERE o.OrganisationID = @OrgID
			) umr ON umr.ModuleID = um.ModuleID
			AND umr.UnitID = um.UnitID
			AND um.UnitID IN (
				SELECT UnitID
				FROM tblUnit
				WHERE OrganisationID = @OrgID
				)
			AND um.UserID IN (
				SELECT UserID
				FROM tblUser
				WHERE OrganisationID = @OrgID
				)
																							--<   C   A   M   >--


		) CAM ON CAM.userid = CCS.userid
		AND cam.CourseID = CCS.CourseID
		
		inner join (select QuizStatus.UserID,QuizStatus.ModuleID,QuizStatus.QuizStatusID from
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
where m.active = 1) CMS on CMS.UserID=CAM.UserID and CMS.ModuleID = CAM.ModuleID
		
	WHERE 
	  CCS.CourseStatusID = 2 and CMS.QuizStatusID <>2		




Open ModuleLOOP

FETCH NEXT FROM ModuleLOOP
Into
@UserID, @ModuleID

WHILE @@FETCH_STATUS = 0
BEGIN
	EXEC prcUserQuizStatus_UpdateCourseStatus @UserID, @ModuleID
	DECLARE @Err integer
	SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcPreprocessOneOrgAssignedCourses'',''prcUserQuizStatus_UpdateCourseStatus'',''prcUserQuizStatus_UpdateCourseStatus'',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_Update_Quick'',1,1,null,getutcdate(),getutcdate()) END


FETCH NEXT FROM ModuleLOOP
Into
@UserID, @ModuleID
END

CLOSE ModuleLOOP
DEALLOCATE ModuleLOOP




END
' 
END
GO


