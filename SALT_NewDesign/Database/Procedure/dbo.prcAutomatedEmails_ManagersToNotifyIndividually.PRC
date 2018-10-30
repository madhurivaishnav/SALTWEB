SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcAutomatedEmails_ManagersToNotifyIndividually]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [prcAutomatedEmails_ManagersToNotifyIndividually]
(
@OrganisationID int
)


AS

BEGIN


--                    S E L E C T    T H E    R E S U L T S

--declare @OrganisationID int
--set @OrganisationID = 68

	;with UsersToNotify (userid,DelinquentCourse,username,uFirstname,uLastname) as 
	(
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

		from 
		(  SELECT
		RowNum = Row_Number() OVER (partition BY userid order by userid)
		,userid,DelinquentCourse,username,uFirstname,uLastname

		FROM UsersToNotify
		) AS pl
		join UsersToNotifyList cte on pl.RowNum = cte.numb and (cte.userid is null or pl.userid = cte.userid)
	)




	, ManagersToNotifyList(numb, ManagerEmail, DelinquentCourse, FirstName, LastName,username,ManagerName,uFirstname,uLastname,deluserid, mgruserid) as
	(
	select numb,  CAST(UsersManagers.Email AS NVARCHAR(max)),DelinquentCourse,FirstName,LastName,UL.username,UsersManagers.UserName,uFirstname,uLastname, UL.userid, UsersManagers.mgruserid
	FROM UsersToNotifyList UL
	inner join (select max(numb) AS maxnumb,Userid  from UsersToNotifyList  group by userid) max on max.maxnumb = UL.numb and max.userid = UL.userid
	INNER JOIN
		(
			SELECT tblUnitAdmins.username, U.UserID, tblUnitAdmins.Email ,tblUnitAdmins.FirstName, tblUnitAdmins.LastName, tblUnitAdmins.UserID as mgruserid
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
			SELECT ''DelinquencyManager'' as username, tblUserDelinquencyManager.UserID, tblUserDelinquencyManager.DelinquencyManagerEmail,'' '' AS FirstName, '' '' AS LastName,-1 as mgruserid
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
	(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Overdue_Summary_Header'')

	,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Overdue_Summary_Header_Individual'')))
	
	
	
	

	--delinquent
	+ ''<BR>'' +''<B>''+ uFirstname +'' ''+uLastname+''</B>''+''&nbsp;&nbsp;''   + DelinquentCourse+ ''<BR>''

	--Email Sig
	+     
	(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Overdue_Summary_Sig'')
				,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Overdue_Summary_Sig'')))+ ''<BR>''  
	 as Body
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
