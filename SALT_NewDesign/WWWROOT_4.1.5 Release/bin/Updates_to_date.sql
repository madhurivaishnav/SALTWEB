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


 