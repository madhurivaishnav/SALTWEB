SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcAutomatedEmails_ManagersToNotifyList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [prcAutomatedEmails_ManagersToNotifyList]
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
,username nvarchar(200) null
,deluserid int
,mgruserid int)

create index inx_3 on #ManagersToNotify(ManagerName)

INSERT into #ManagersToNotify( ManagerName, ManagerEmail ,DelinquentCourse,FirstName,LastName,username, deluserid,mgruserid) 

select  UsersManagers.username as managername,  UsersManagers.Email ,''<BR><B>''+U.Firstname+'' ''+U.Lastname+''</B><BR>&nbsp;&nbsp;''+DelinquentCourse,UsersManagers.FirstName as FirstName,UsersManagers.LastName, U.username,u.UserID,mgruserid
FROM #UsersToNotifyList UL
inner join tblUser U on U.userid=UL.userid


INNER JOIN
	(
		SELECT tblUnitAdmins.username, U.UserID, tblUnitAdmins.Email ,tblUnitAdmins.FirstName, tblUnitAdmins.LastName,tblUnitAdmins.UserID as mgruserid
		FROM  tblUser U  
					INNER JOIN  tblUnitAdministrator ON U.UnitID = tblUnitAdministrator.UnitID
					INNER JOIN   dbo.tblUser AS tblUnitAdmins ON dbo.tblUnitAdministrator.UserID = tblUnitAdmins.UserID AND tblUnitAdmins.UserTypeID = 3
					WHERE  U.NotifyUnitAdmin = 1
		UNION ALL 
		SELECT tblOrgAdmins.username, U.UserID, tblOrgAdmins.Email ,tblOrgAdmins.FirstName, tblOrgAdmins.LastName,tblOrgAdmins.UserID as mgruserid
		FROM  tblUser U  
					INNER JOIN  dbo.tblUser AS tblOrgAdmins ON U.OrganisationID = tblOrgAdmins.OrganisationID
					WHERE  U.NotifyOrgAdmin = 1 AND tblOrgAdmins.UserTypeID = 2
		UNION ALL
		SELECT ''DelinquencyManager'' as username, tblUserDelinquencyManager.UserID, tblUserDelinquencyManager.DelinquencyManagerEmail,'' '' AS FirstName, '' '' AS LastName, -1 as mgruserid
		FROM  dbo.tblUser AS tblUserDelinquencyManager WHERE  NotifyMgr = 1 and tblUserDelinquencyManager.Email IS NOT NULL AND (tblUserDelinquencyManager.Email != '''')
	) UsersManagers ON UsersManagers.UserID = UL.UserID



create table #ManagersToNotifyList
(ManagerName nvarchar(200) null
,ManagerEmail nvarchar(200) null
,DelinquentCourse nvarchar(max) null
,FirstName nvarchar(200) null
,LastName nvarchar(200) null
,username nvarchar(200) null
,deluserid int
,mgruserid int)

create index inx_4 on #ManagersToNotifyList(ManagerName)




declare 
@ManagerName nvarchar(200)
,@ManagerEmail nvarchar(200)
,@FirstName nvarchar(200)
,@LastName nvarchar(200)
,@username nvarchar(200)
,@deluserid int
,@mgruserid int

while exists (select 1 from #ManagersToNotify)
begin
	set rowcount 1
	select @ManagerName = ManagerName
	,@DelinquentCourse = DelinquentCourse
	,@ManagerEmail = ManagerEmail
	,@username = username
	,@FirstName = FirstName
	,@LastName = LastName
	,@deluserid = deluserid
	,@mgruserid = mgruserid
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
		insert #ManagersToNotifyList(ManagerName,DelinquentCourse,ManagerEmail ,username ,FirstName ,LastName,deluserid, mgruserid )
		values (@ManagerName,@DelinquentCourse,@ManagerEmail,@username ,@FirstName ,@LastName,@deluserid,@mgruserid )
	end

	delete #ManagersToNotify where
	@ManagerName = ManagerName
	and @DelinquentCourse = DelinquentCourse
	and @ManagerEmail = ManagerEmail
	and @username = username
	and @FirstName = FirstName
	and @LastName = LastName
	and @deluserid =deluserid
	and @mgruserid=mgruserid
	set rowcount 0
end




SELECT l.ManagerEmail,
-- Recipient Email Address
l.ManagerEmail as RecipientEmail,

-- Sender Email Address
l.ManagerEmail as SenderEmail,

-- Subject
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Overdue_Summary_Subject'')
	,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Overdue_Summary_Subject''))) as Subject,



-- Header
(
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Overdue_Summary_Header'')
								,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Overdue_Summary_Header'')))
)


--delinquent
+ ''<BR>'' + DelinquentCourse + ''<BR>''

--Email Sig
+     
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Overdue_Summary_Sig'')
			,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Overdue_Summary_Sig'')))+ ''<BR>''   as Body
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


if OBJECT_ID(''tempdb..#UsersToNotifyList'') is not null
begin
	drop table #UsersToNotifyList
end

if  OBJECT_ID(''tempdb..#UsersToNotify'')is not null
begin
	drop table #UsersToNotify
END


if OBJECT_ID(''tempdb..#ManagersToNotify'') is not null
begin
	drop table #ManagersToNotify
end


if OBJECT_ID(''tempdb..#ManagersToNotifyList'') is not null
begin
	drop table #ManagersToNotifyList
end


END


' 
END
GO
