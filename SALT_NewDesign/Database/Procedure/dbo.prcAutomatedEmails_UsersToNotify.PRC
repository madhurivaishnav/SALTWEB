
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcAutomatedEmails_UsersToNotify]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[prcAutomatedEmails_UsersToNotify]
(
@OrganisationID int
)


AS

BEGIN

declare @OrgMidnight datetime
set @OrgMidnight =  dbo.udfGetSaltOrgMidnight(@OrganisationID)

declare @StopEmails bit
set @StopEmails = 0
select @StopEmails = StopEmails from tblOrganisation where OrganisationID = @OrganisationID 


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
,AtRiskOfdelinquency nvarchar(max) null
,Delinquent nvarchar(max) null)



insert into #UsersToNotify
SELECT distinct UsersToNotify.userid , UsersToNotify.NewContent , PassedCourses, PassedModules ,AtRiskOfdelinquency, delinquent FROM
(
	-- users with courses expired, due to new content
	SELECT '''' as UserCourseStatusID, tblExpiredNewContent.UserID , tblCourse.Name + '' - ''+ tblModule.Name as NewContent , '''' as PassedCourses ,'''' as PassedModules ,  '''' as AtRiskOfdelinquency,'''' as Delinquent
	FROM  tblExpiredNewContent INNER JOIN
	tblModule ON tblModule.ModuleID = tblExpiredNewContent.ModuleID
	INNER JOIN tblCourse ON tblCourse.CourseID = tblModule.CourseID 
	WHERE tblExpiredNewContent.organisationID = @OrganisationID
    and @StopEmails = 0
    
	-- users with passed courses
	UNION all SELECT '''' as UserCourseStatusID, CS.userid , '''' as NewContent,''   ''+ C.Name as PassedCourses,'''' as PassedModules,  '''' as AtRiskOfdelinquency, '''' as Delinquent
	FROM tblUserCourseStatus CS
	inner join tblUser U ON U.UserID = CS.UserID
	INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
	where U.OrganisationID = @OrganisationID and CS.CourseStatusID=2 and DATEDIFF(d,CS.DateCreated,@OrgMidnight) < 1
	and @StopEmails = 0

	-- users with passed modules
	UNION all SELECT '''' as UserCourseStatusID, QuizStatus.userid ,	'''' as NewContent, '''' as PassedCourses,	''   ''+c.name  + '' - '' + m.name as PassedModules, '''' as AtRiskOfdelinquency, '''' as delinquent
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
    and @StopEmails = 0
    
	-- users with courses at risk (pre expiry)
	union all SELECT DISTINCT '''' as UserCourseStatusID, AR.userID,  '''' as NewContent , '''' as PassedCourses,'''' as PassedModules, ''   ''+ C.Name +'' ( ''+M.name +'') ''+ convert(varchar (11),ar.ExpiryDate ,113) as AtRiskOfdelinquency,'''' as delinquent
	from tblQuizExpiryAtRisk AR
	INNER JOIN tblUser U On U.UserID = AR.UserID
	inner join tblModule M on m.ModuleID = AR.ModuleID and m.Active = 1 and AR.OrganisationID = @OrganisationID
	INNER JOIN tblCourse C ON C.CourseID = M.CourseID
	where U.Active = 1 AND ar.PreExpiryNotified = 0
	and ar.ExpiryDate >= dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrganisationID)
    and @StopEmails = 0
    
	-- users with expired courses
	union all SELECT DISTINCT '''' as UserCourseStatusID, AR.userID,  '''' as NewContent , '''' as PassedCourses,'''' as PassedModules, '''' as AtRiskOfdelinquency ,''   ''+ C.Name +'' ( ''+M.name +'') ''+ convert(varchar (11),ar.ExpiryDate ,113)  as delinquent
	from tblQuizExpiryAtRisk AR
	INNER JOIN tblUser U On U.UserID = AR.UserID
	inner join tblModule M on m.ModuleID = AR.ModuleID and m.Active = 1 and AR.OrganisationID = @OrganisationID
	INNER JOIN tblCourse C ON C.CourseID = M.CourseID
	INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = @OrganisationID) AND (RemEsc.CourseId = C.CourseID) and RemEsc.PostExpReminder =1
	where U.Active = 1 AND ar.PreExpiryNotified != 0 
		and (ar.ExpiryNotifications =0 and ExpiryDate<=GETUTCDATE())
		and ar.ExpiryDate >= dateadd(year,-1,GETUTCDATE())
		or (ar.ExpiryNotifications>0 and ar.ExpiryNotifications<=(RemEsc.NumOfRemNotfy-1) and DATEADD (DAY,remesc.RepeatRem,ar.datenotified)<GETUTCDATE() )
    and @StopEmails = 0
    
) UsersToNotify

create index in_1 on #UsersToNotify(userid)


create table #UsersToNotifyList
(userid int not null
,NewContent nvarchar(max) null
,PassedCourses nvarchar(max) null
,PassedModules nvarchar(max) null
,AtRiskOfdelinquency nvarchar(max) null
,delinquent nvarchar(max) null)

create index in_2 on #UsersToNotifyList(userid)

declare @userid int
,@NewContent nvarchar(max)
,@PassedCourses nvarchar(max)
,@PassedModules nvarchar(max)
,@AtRiskOfdelinquency nvarchar(max)
,@delinquent nvarchar(max)

while exists (select 1 from #UsersToNotify)
begin
	set rowcount 1
	
	select @userid = userid
	,@NewContent = NewContent
	, @PassedCourses = PassedCourses
	,@PassedModules = PassedModules
	,@AtRiskOfdelinquency = AtRiskOfdelinquency
	,@delinquent =Delinquent

	from #UsersToNotify
	if exists (select * from #UsersToNotifyList where userid = @userid)
	begin

		update #UsersToNotifyList set
		NewContent = rtrim(CAST(#UsersToNotifyList.NewContent + (case when #UsersToNotifyList.NewContent = '''' or @NewContent = '''' then '''' else ''<BR>'' end ) + (case when @NewContent ='''' then '''' else ''&nbsp;&nbsp;'' end) +@NewContent AS NVARCHAR(max)))
		, PassedCourses = rtrim(CAST(#UsersToNotifyList.PassedCourses + (case when #UsersToNotifyList.PassedCourses = '''' or @PassedCourses = '''' then '''' else ''<BR>'' end)+ (case when @PassedCourses ='''' then '''' else ''&nbsp;&nbsp;'' end) + @PassedCourses AS NVARCHAR(max)))
		,PassedModules = rtrim(CAST(#UsersToNotifyList.PassedModules + (case when #UsersToNotifyList.PassedModules = '''' or @PassedModules = '''' then '''' else ''<BR>'' end)+ (case when @PassedModules ='''' then '''' else ''&nbsp;&nbsp;'' end) + @PassedModules AS NVARCHAR(max)))
		,AtRiskOfdelinquency = rtrim(CAST(#UsersToNotifyList.AtRiskOfdelinquency + (case when #UsersToNotifyList.AtRiskOfdelinquency = '''' or @AtRiskOfdelinquency = '''' then '''' else ''<BR>'' end)+ (case when @AtRiskOfdelinquency ='''' then '''' else ''&nbsp;&nbsp;'' end) + @AtRiskOfdelinquency AS NVARCHAR(max)))
		,delinquent = rtrim(CAST(#UsersToNotifyList.delinquent + (case when #UsersToNotifyList.delinquent = '''' or @delinquent = '''' then '''' else ''<BR>'' end)+ (case when @delinquent ='''' then '''' else ''&nbsp;&nbsp;'' end) + @delinquent AS NVARCHAR(max)))
		from #UsersToNotifyList
		where #UsersToNotifyList.userid = @userid
		
	end
	else
	begin

		insert #UsersToNotifyList(userid,NewContent,PassedCourses,PassedModules,AtRiskOfdelinquency,delinquent)
		values (@userid,@NewContent,@PassedCourses,@PassedModules,@AtRiskOfdelinquency,@delinquent)

	end
	
	delete #UsersToNotify where
	@userid = userid
	and @NewContent = NewContent
	and  @PassedCourses = PassedCourses
	and  @PassedModules = PassedModules
	and  @AtRiskOfdelinquency = AtRiskOfdelinquency
	and @delinquent = Delinquent
	set rowcount 0
end

-- 
-- select the final result the result set for return to the app  (also, builds the whole body just once for each user!)

SELECT l.UserID,
-- Recipient Email Address
(SELECT Email FROM tblUser WHERE UserID = l.UserID) as RecipientEmail,

-- Sender Email Address
(SELECT dbo.udfUser_GetAdministratorsEmailAddress (l.UserID)) as SenderEmail,

-- Subject
(select REPLACE(
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_Subject'')
,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_Subject''))),''%APP_NAME%'',(SELECT Value FROM tblAppConfig where Name = ''AppName''))) as Subject,


--1. Body --Header
(select coalesce((SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_Header'')
,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_Header''))),''header error''))

--2. Body --Passed Courses
+coalesce( (select case when PassedCourses = '''' then '''' else replace (
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_PassedCourses'')
,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_PassedCourses''))),''%AUTO_LIST%'',PassedCourses)end),'''')

--3. Body --Passed Modules
+coalesce( (select case when PassedModules = '''' then '''' else '' <br /> '' + replace (
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_PassedModules'')
,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_PassedModules''))),''%AUTO_LIST%'',PassedModules)end),'''')

--4. Body --Expired Content
+ coalesce( (select case when NewContent = '''' then '''' else '' <br /> '' + replace(
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_ExpiredContent'')
,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_ExpiredContent''))),''%AUTO_LIST%'',NewContent)end),'''')

--5. Body --Delinquent
+ coalesce((select case when delinquent = '''' then '''' else '' <br /> '' + replace(
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_AtRiskOfBeingOverdue'')
,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_AtRiskOfBeingOverdue''))),''%AUTO_LIST%'',delinquent)end),'''')

--6. Body --AtRiskOfdelinquency
+coalesce( (select case when AtRiskOfdelinquency = '''' then '''' else '' <br /> '' + replace(
 ( SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_AtRiskOfExpiry'')
,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_AtRiskOfExpiry''))),''%AUTO_LIST%'',AtRiskOfdelinquency) end),'''')

--7. Body --Email Sig
+     (select REPLACE(
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_Sig'')
,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_Sig'')))+ ''<BR>''  ,''%APP_NAME%'',(SELECT Value FROM tblAppConfig where Name = ''AppName''))) as Body
, -- Sender"On Behalf Of" Email Address
(SELECT dbo.udfUser_GetAdministratorsOnBehalfOfEmailAddress (l.UserID))  as OnBehalfOfEmail,


*

FROM
#UsersToNotifyList l
where NewContent !='''' or PassedCourses !='''' or PassedModules != '''' or AtRiskOfdelinquency != ''''  or delinquent != ''''





--                    H O U S E K E E P I N G  (tidy up for tomorrow)

-- Update record of "at risk of Delinquency" notifications
-- Update tblUserCourseDetails.LastDelinquencyNotification
UPDATE tblUserCourseDetails  SET LastDelinquencyNotification = GETUTCDATE(), NumberOfDelinquencyNotifications = NumberOfDelinquencyNotifications + 1
WHERE  UserCourseStatusID in (-- users with courses at risk of delinquency (1ST WARNING)

SELECT DISTINCT UserCourseStatusID
FROM (SELECT MAX(CD.UserCourseStatusID) as UserCourseStatusID, CS.userID ,  RemEsc.DaysToCompleteCourse, MIN(CS.DateCreated) as DateCreated,C.Name,CS.CourseID
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on O.OrganisationID = u.OrganisationID 
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID) AND (RemindUsers=1)
where U.Active = 1 and @StopEmails = 0
AND ((o.DefaultQuizCompletionDate is not null AND CS.DateCreated >  dateadd(year,-1,o.DefaultQuizCompletionDate))
OR     (o.DefaultQuizCompletionDate is  null AND CS.DateCreated >= (select ISNULL((SELECT MAX(DateCreated) FROM tblUserCourseStatus Expired where expired.CourseStatusID in (0,2) and Expired.CourseID = CS.CourseID and Expired.UserID =CS.UserID) ,''1 jan 1990'')) ))
AND CD.LastDelinquencyNotification IS NULL
AND coursestatusid=1
AND o.OrganisationID = @OrganisationID
AND (GETUTCDATE() > DATEADD(d,RemEsc.DaysToCompleteCourse-RemEsc.NumOfRemNotfy*RemEsc.RepeatRem, CS.DateCreated))
AND (RemEsc.NumOfRemNotfy > cd.NumberOfDelinquencyNotifications)
AND (GETUTCDATE() < DATEADD(d,RemEsc.DaysToCompleteCourse+6, CS.DateCreated))
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
where U.Active = 1 AND coursestatusid=1 AND o.OrganisationID = @OrganisationID and @StopEmails = 0
AND CD.LastDelinquencyNotification IS NOT NULL
AND ((o.DefaultQuizCompletionDate is not null AND CS.DateCreated >  dateadd(year,-1,o.DefaultQuizCompletionDate))
OR     (o.DefaultQuizCompletionDate is  null AND CS.DateCreated >= (select ISNULL((SELECT MAX(DateCreated) FROM tblUserCourseStatus Expired where expired.CourseStatusID in (0,2) and Expired.CourseID = CS.CourseID and Expired.UserID =CS.UserID) ,''1 jan 1990'')) ))
AND coursestatusid=1
AND o.OrganisationID = @OrganisationID
AND (GETUTCDATE() > DATEADD(d,RemEsc.DaysToCompleteCourse-RemEsc.NumOfRemNotfy*RemEsc.RepeatRem, CS.DateCreated))
AND (RemEsc.NumOfRemNotfy > cd.NumberOfDelinquencyNotifications)
AND (GETUTCDATE() > DATEADD(d,RemEsc.RepeatRem, CD.LastDelinquencyNotification))
AND (GETUTCDATE() < DATEADD(d,RemEsc.DaysToCompleteCourse+6, CS.DateCreated))

GROUP BY  CS.CourseID, CS.userID ,  RemEsc.DaysToCompleteCourse, C.Name) ThisQuizCycle
)


DELETE FROM tblExpiredNewContent WHERE organisationID = @OrganisationID  and @StopEmails = 0


-- Update record for post expiry notified -- use same criteria as selection above.
update tblQuizExpiryAtRisk SET --PreExpiryNotified = case when preexpirynotified = 0 then 1 else PreExpiryNotified end,
	ExpiryNotifications  = case when @StopEmails=1 then remesc.NumOfRemNotfy else ExpiryNotifications +1  end,
	datenotified = case when @StopEmails= 1 then null else  GETUTCDATE() end
from tblQuizExpiryAtRisk AR
	INNER JOIN tblUser U On U.UserID = AR.UserID
	inner join tblModule M on m.ModuleID = AR.ModuleID and m.Active = 1 and AR.OrganisationID = @OrganisationID
	INNER JOIN tblCourse C ON C.CourseID = M.CourseID
	INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = @OrganisationID) AND (RemEsc.CourseId = C.CourseID) and RemEsc.PostExpReminder =1
	where U.Active = 1 AND ar.PreExpiryNotified != 0 
		and (ar.ExpiryNotifications =0 and ExpiryDate<=GETUTCDATE())
		and ar.ExpiryDate >= dateadd(year,-1,GETUTCDATE())
		or (ar.ExpiryNotifications>0 and ar.ExpiryNotifications<=(RemEsc.NumOfRemNotfy-1) and DATEADD (DAY,remesc.RepeatRem,ar.datenotified)<GETUTCDATE() )    


--update record for pre expiry notified -- straightforward where not prexpiry notified
update tblQuizExpiryAtRisk set 
	PreExpiryNotified = 1,
	DateNotified = case when @StopEmails= 1 then null else GETUTCDATE() end
from tblQuizExpiryAtRisk ar
join tblUser u on u.UserID= ar.UserID
where PreExpiryNotified = 0 and u.OrganisationID = @OrganisationID



if OBJECT_ID(''tempdb..#UsersToNotifyList'') is not null
begin
drop table #UsersToNotifyList
end

if  OBJECT_ID(''tempdb..#UsersToNotify'')is not null
begin
drop table #UsersToNotify
END
end
' 
END
GO