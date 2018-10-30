IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblLang_RecordLock]') AND parent_object_id = OBJECT_ID(N'[tblLang]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblLang_RecordLock]') AND type = 'D')
BEGIN
ALTER TABLE [tblLang] ADD  CONSTRAINT [DF_tblLang_RecordLock]  DEFAULT (newid()) FOR [RecordLock]
END
End
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcSearchAdminUsers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra Jagtap
-- Create date: 27/10/2011
-- Description:	Searches the Unit and Org Admins with First name and last name
-- =============================================
ALTER PROCEDURE [prcSearchAdminUsers] 
(
	-- Add the parameters for the stored procedure here
	@OrgID int,
	@Firstname varchar(100), 
	@LastName varchar(100)
) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

If @Firstname is null
Set @Firstname = ''''

Set @Firstname =rtrim(@firstName)

If @LastName is null
Set @LastName = ''''

Set @LastName =rtrim(@lastName)

	SELECT UserID, FirstName, LastName, UserName, Email, ut.Type
		FROM tblUser u JOIN tblUserType ut ON u.UserTypeID = ut.UserTypeID
		WHERE FirstName like @Firstname + ''%'' 
		AND LastName like @LastName +''%'' AND OrganisationID=@OrgID
		AND u.UserTypeID <> 4 
		AND u.Active = 1
END' 
END
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcGetPeriodicReportListUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra Jagtap
-- Create date: 18/10/2011
-- Description:	Gets the list of periodic reports for a user
-- =============================================
ALTER PROCEDURE [prcGetPeriodicReportListUser]
(
	@OrgID int,
	@Username varchar(50)
) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @CCList TABLE(ScheduleId int, CC int)
	INSERT INTO @CCList(ScheduleId, CC) 
		(SELECT ccl.ScheduleId, Count(UserId) as CC FROM tblCCList ccl
			GROUP BY ccl.ScheduleId
			HAVING ccl.ScheduleId In 
				(SELECT rs.ScheduleId FROM tblReportSchedule rs
				JOIN dbo.tblUser u ON u.UserID = rs.UserID))

	SELECT rs.ScheduleID, rs.ReportID, rs.UserID, rs.ReportTitle, ri.ReportName, 
	(convert(varchar, rs.ReportFrequency) + (CASE rs.ReportFrequencyPeriod WHEN ''D'' THEN '' Days'' WHEN ''W'' THEN '' Weeks'' WHEN ''M'' THEN '' Months'' WHEN ''Y'' THEN '' Years'' END)) AS ReportFrequency, 
	convert(varchar(11), rs.DateCreated, 113) as DateCreated,
	convert(varchar(11), rs.ReportStartDate, 113) as ReportStartDate, 
	convert(varchar(11), rs.ReportEndDate, 113) as ReportEndDate, 
	CASE WHEN rs.NextRun > rs.ReportEndDate THEN ''''
		 WHEN rs.NextRun = cast(''1 jan 2050'' as datetime) THEN ''''
		 ELSE convert(varchar(11), rs.NextRun, 113) END
		 as NextRun, 
	(u.FirstName + '' '' + u.LastName) as Username, ut.Type, 
	CASE WHEN (ccl.CC > 0) THEN (Convert(varchar, (ccl.CC + 1)) + '' Recepients'') ELSE u.UserName END as CCUser
		FROM dbo.tblReportSchedule rs JOIN dbo.tblReportInterface ri ON rs.ReportID = ri.ReportID
		JOIN dbo.tblUser u ON u.UserID = rs.UserID
		JOIN dbo.tblUserType ut ON u.UserTypeID = ut.UserTypeID
		LEFT JOIN @CCList ccl ON ccl.ScheduleId = rs.ScheduleId
		WHERE rs.ParamOrganisationID = @OrgID AND rs.IsPeriodic != ''N''
		AND u.UserName = @Username AND (u.UserTypeID <> 1 OR u.UserTypeID = 3)
END
' 
END
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcGetPeriodicReportList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra Jagtap
-- Create date: 30/09/2011
-- Description:	Gets the list of periodic reports
-- =============================================
ALTER PROCEDURE [prcGetPeriodicReportList]
(
	@OrgID int
) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @CCList TABLE(ScheduleId int, CC int)
	INSERT INTO @CCList(ScheduleId, CC) 
		(SELECT ccl.ScheduleId, Count(UserId) as CC FROM tblCCList ccl
			GROUP BY ccl.ScheduleId
			HAVING ccl.ScheduleId In 
				(SELECT rs.ScheduleId FROM tblReportSchedule rs
				JOIN dbo.tblUser u ON u.UserID = rs.UserID))

	SELECT rs.ScheduleID, rs.ReportID, rs.UserID, rs.ReportTitle, ri.ReportName, 
	(convert(varchar, rs.ReportFrequency) + (CASE rs.ReportFrequencyPeriod WHEN ''D'' THEN '' Days'' WHEN ''W'' THEN '' Weeks'' WHEN ''M'' THEN '' Months'' WHEN ''Y'' THEN '' Years'' END)) AS ReportFrequency, 
	convert(varchar(11), rs.DateCreated, 113) as DateCreated,
	convert(varchar(11), rs.ReportStartDate, 113) as ReportStartDate, 
	convert(varchar(11), rs.ReportEndDate, 113) as ReportEndDate,
	CASE WHEN rs.NextRun > rs.ReportEndDate THEN ''''
		 WHEN rs.NextRun = cast(''1 jan 2050'' as datetime) THEN ''''
		 ELSE convert(varchar(11), rs.NextRun, 113) END
		 as NextRun, 
	(u.FirstName + '' '' + u.LastName) as Username, ut.Type, 
	CASE WHEN (ccl.CC > 0) THEN (Convert(varchar, (ccl.CC + 1)) + '' Recepients'') ELSE u.UserName END as CCUser
		FROM dbo.tblReportSchedule rs JOIN dbo.tblReportInterface ri ON rs.ReportID = ri.ReportID
		JOIN dbo.tblUser u ON u.UserID = rs.UserID
		JOIN dbo.tblUserType ut ON u.UserTypeID = ut.UserTypeID
		LEFT JOIN @CCList ccl ON ccl.ScheduleId = rs.ScheduleId
		WHERE rs.ParamOrganisationID = @OrgID AND rs.IsPeriodic != ''N''

END
' 
END
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[tblCCList]') AND type in (N'U'))
DROP TABLE [tblCCList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[tblCCList]') AND type in (N'U'))
BEGIN
CREATE TABLE [tblCCList](
	[CCId] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[ScheduleId] [int] NOT NULL,
 CONSTRAINT [PK_tblCCList] PRIMARY KEY CLUSTERED 
(
	[CCId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[tblCCList]') AND name = N'IX_tblCCList')
CREATE NONCLUSTERED INDEX [IX_tblCCList] ON [tblCCList] 
(
	[ScheduleId] ASC,
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblLangInterface_InterfaceType]') AND parent_object_id = OBJECT_ID(N'[tblLangInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblLangInterface_InterfaceType]') AND type = 'D')
BEGIN
ALTER TABLE [tblLangInterface] ADD  CONSTRAINT [DF_tblLangInterface_InterfaceType]  DEFAULT ('') FOR [InterfaceType]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblLangInterface_RecordLock]') AND parent_object_id = OBJECT_ID(N'[tblLangInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblLangInterface_RecordLock]') AND type = 'D')
BEGIN
ALTER TABLE [tblLangInterface] ADD  CONSTRAINT [DF_tblLangInterface_RecordLock]  DEFAULT (newid()) FOR [RecordLock]
END


End
GO



IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblLangResource_ResourceType]') AND parent_object_id = OBJECT_ID(N'[tblLangResource]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblLangResource_ResourceType]') AND type = 'D')
BEGIN
ALTER TABLE [tblLangResource] ADD  CONSTRAINT [DF_tblLangResource_ResourceType]  DEFAULT ('') FOR [ResourceType]
END


End
GO


IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblLangValue_RecordLock]') AND parent_object_id = OBJECT_ID(N'[tblLangValue]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblLangValue_RecordLock]') AND type = 'D')
BEGIN
ALTER TABLE [tblLangValue] ADD  CONSTRAINT [DF_tblLangValue_RecordLock]  DEFAULT (newid()) FOR [RecordLock]
END


End
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[tblReportScheduleAudit]') AND type in (N'U'))
DROP TABLE [tblReportScheduleAudit]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[tblReportScheduleAudit]') AND type in (N'U'))
BEGIN
CREATE TABLE [tblReportScheduleAudit](
	[AuditID] [int] IDENTITY(1,1) NOT NULL,
	[ScheduleID] [int] NULL,
	[UserID] [int] NULL,
	[ReportID] [int] NULL,
	[LastRun] [datetime] NULL,
	[NextRun] [datetime] NULL,
	[ReportDuration] [int] NULL,
	[ReportDurationPeriod] [char](1) NULL,
	[ReportStartDate] [datetime] NULL,
	[ReportEndDate] [datetime] NULL,
	[NumberOfReports] [int] NULL,
	[ReportFrequency] [int] NULL,
	[ReportFrequencyPeriod] [char](1) NULL,
	[DocumentType] [char](1) NULL,
	[ReportTitle] [nvarchar](100) NULL,
	[ParamOrganisationID] [int] NULL,
	[ParamCompleted] [char](1) NULL,
	[ParamStatus] [char](1) NULL,
	[ParamFailCount] [int] NULL,
	[ParamCourseIDs] [nvarchar](800) NULL,
	[ParamHistoricCourseIDs] [nvarchar](800) NULL,
	[ParamAllUnits] [char](1) NULL,
	[ParamTimeExpired] [int] NULL,
	[ParamTimeExpiredPeriod] [char](1) NULL,
	[ParamQuizStatus] [char](1) NULL,
	[ParamGroupBy] [char](1) NULL,
	[ParamGroupingOption] [int] NULL,
	[ParamFirstName] [nvarchar](200) NULL,
	[ParamLastName] [nvarchar](200) NULL,
	[ParamUserName] [nvarchar](200) NULL,
	[ParamEmail] [nvarchar](200) NULL,
	[ParamIncludeInactive] [char](1) NULL,
	[ParamSubject] [nvarchar](200) NULL,
	[ParamBody] [nvarchar](200) NULL,
	[ParamProfileID] [int] NULL,
	[ParamOnlyUsersWithShortfall] [char](1) NULL,
	[ParamEffectiveDate] [datetime] NULL,
	[ParamSortBy] [char](1) NULL,
	[ParamClassificationID] [int] NULL,
	[ParamUnitIDs] [nvarchar](max) NULL,
	[ParamLangCode] [nvarchar](10) NULL,
	[ParamDateTo] [datetime] NULL,
	[ParamDateFrom] [datetime] NULL,
	[ParamLicensingPeriod] [nvarchar](4000) NULL,
	[ParamProfilePeriodID] [int] NULL,
	[ReportPeriodType] [int] NULL,
	[ReportFromDate] [datetime] NULL,
	[IsPeriodic] [char](1) NULL,
	[LastUpdatedBy] [int] NULL,
	[LastUpdated] [datetime] NULL,
	[LastUpdAction] [char](1) NULL,
	[TerminatedNormally] [bit] NULL,
	[NumberDelivered] [int] NULL,
	[DateCreated] [datetime] NULL,
 CONSTRAINT [PK_tblReportScheduleAudit] PRIMARY KEY CLUSTERED 
(
	[AuditID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO


IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblUnit_Level]') AND parent_object_id = OBJECT_ID(N'[tblUnit]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblUnit_Level]') AND type = 'D')
BEGIN
ALTER TABLE [tblUnit] ADD  CONSTRAINT [DF_tblUnit_Level]  DEFAULT ((0)) FOR [Level]
END


End
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[tblUserPolicyAccepted]') AND name = N'_dta_index_tblUserPolicyAccepted_10_1641108937__K2_K3_K5_K4')
CREATE NONCLUSTERED INDEX [_dta_index_tblUserPolicyAccepted_10_1641108937__K2_K3_K5_K4] ON [tblUserPolicyAccepted] 
(
	[PolicyID] ASC,
	[UserID] ASC,
	[DateAccepted] ASC,
	[Accepted] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO



IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[tblUserPolicyAccess]') AND name = N'_dta_index_tblUserPolicyAccess_10_1737109279__K4_K2_K3')
CREATE NONCLUSTERED INDEX [_dta_index_tblUserPolicyAccess_10_1737109279__K4_K2_K3] ON [tblUserPolicyAccess] 
(
	[Granted] ASC,
	[PolicyID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[trgLessonSession]'))
DROP TRIGGER [trgLessonSession]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[trgLessonSession]'))
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Check lesson status for the Lesson session started and completed

Returns:

Called By:

Calls:
Nothing

Remarks:

select * from tblLessonSession

1. Get the module Lesson current status and the current status date

2. Starting a lesson session (update DateTimeStarted), check whether need to start a new frequency (In Progress)
a)If new frequency has already been started, ignore this session
(The current status is In Progress(2) or Completed (3))
b)If new frequency has not been started, start it.
(The current status is  Unassigned (0), Not Started (1), Expired (Time Elapsed) (4),Expired (New Content) (5),  or no status,
insert the new status In Progress (2) <------)

3. Completing a lesson session  (update DateTimeCompleted), check whether the lesson status is Completed
a)The current status is Completed(3), ignore this session
b)New frequency started(the current status is In Progress(2)):
If  all pages have been accessed from new frequency starting date(current status date),
set the lesson Completed (insert the new status Completed (3) <------)
c)Other Status (Unassigned (0), Not Started (1), Expired (Time Elapsed) (4),Expired (New Content) (5),  or no status
Ignore it. The current status should be Completed, or In Progress, If it is other status, some errors occur.

Author: Jack Liu
Date Created: 20 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	Peter Kneale 23 Nov	2005	Removed Transactions



**/

CREATE TRIGGER [trgLessonSession] ON [tblLessonSession]
FOR Update
AS
set nocount on

--Only fire the trigger if there is only one record updated
if ((select count(LessonID) from inserted)=1)
begin

declare @intUserID int,  @intLessonID int, @dteDateTimeStarted datetime, @dteDateTimeCompleted datetime
declare @intLessonStatusID int,  @intNewLessonStatusID int
declare @dteStatusDate datetime

/*
1. Get the module Lesson current status and the current status date
*/

select  @intUserID = ls.UserID,
@intLessonID = ls.LessonID,
@dteDateTimeStarted = ls.DateTimeStarted,
@dteDateTimeCompleted = ls.DateTimeCompleted,
@intLessonStatusID = uls.LessonStatusID,
@dteStatusDate = uls.DateCreated
from inserted ls
inner join tblLesson l
on l.LessonID = ls.LessonID
left join vwUserLessonStatus uls
on uls.UserID = ls.UserID
and uls.ModuleID = l.ModuleID


/*

2. Starting a lesson session (update DateTimeStarted), check whether need to start a new frequency (In Progress)
a)If new frequency has already been started, ignore this session
(The current status is In Progress(2) or Completed (3))
b)If new frequency has not been started, start it.
(The current status is  Unassigned (0), Not Started (1), Expired (Time Elapsed) (4),Expired (New Content) (5),  or no status,
insert the new status In Progress (2) <------)
*/
set @intNewLessonStatusID = -1 --<----- Ignore it

if (Update(DateTimeStarted) and @dteDateTimeStarted is not null)
begin
If (@intLessonStatusID = 2) -- or @intLessonStatusID = 3)
begin
set @intNewLessonStatusID = -1  --<----- Ignore it
end
else
begin
set @intNewLessonStatusID = 2 --<----- Add new status  In Progress (2)
end
end
/*
3. Completing a lesson session  (update DateTimeCompleted), check whether the lesson status is Completed
a)The current status is Completed(3), ignore this session
b)New frequency started(the current status is In Progress(2)):
If  all pages have been accessed from new frequency starting date(current status date),
set the lesson Completed (insert the new status Completed (3) <------)
c)Other Status (Unassigned (0), Not Started (1), Expired (Time Elapsed) (4),Expired (New Content) (5),  or no status
Ignore it. The current status should be Completed, or In Progress, If it is other status, some errors occur.

*/
else 	if (Update(DateTimeCompleted) and @dteDateTimeCompleted is not null)
begin
If (@intLessonStatusID = 3)
begin
set @intNewLessonStatusID = -1
end
else if (@intLessonStatusID = 2)
begin
--Check whether all pages have been accessed from current status date (new frequency starting date)
if not exists (select lp.LessonPageID
from tblLesson l
inner join tblLessonPage lp
on lp.LessonID = l.LessonID
left join (
select distinct lpaHistory.LessonPageID
from tblLessonSession lsHistory
inner join tblLessonPageAudit lpaHistory
on lpaHistory.LessonSessionID = lsHistory.LessonSessionID
and lpaHistory.DateAccessed>=@dteStatusDate
where 	lsHistory.UserID = @intUserID
and lsHistory.LessonID = @intLessonID
) PageAccessed -- Get all pages accessed since new frequency starting date
on PageAccessed.LessonPageID = lp.LessonPageID
where l.LessonID = @intLessonID
and  PageAccessed.LessonPageID is null)
begin
set @intNewLessonStatusID = 3  --<----- Add new status Completed (3)
end
end
end
--select @intNewLessonStatusID
if (@intNewLessonStatusID>-1)
begin
insert into tblUserLessonStatus
(
UserID,
ModuleID,
LessonStatusID,
LessonFrequency
)
Select 	@intUserID,
l.ModuleID,
@intNewLessonStatusID as LessonStatusID,
umr.LessonFrequency
From  tblUser us
inner join tblLesson l -- Get Module
on l.LessonID = @intLessonID
inner join vwUnitModuleRule umr --Get Rules
on umr.ModuleID  = l.ModuleID
and umr.UnitID = us.UnitID
where us.UserID = @intUserID
end
end





' 
GO


 
 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcCPD_Report]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
ALTER procedure [prcCPD_Report]
(
@profileid int = -1,
@profileperiodid int = -1,
@firstname varchar(200)='''',
@lastname varchar(200) ='''',
@username varchar(200)='''',
@shortfallusers smallint=0,
@UnitIDs varchar(8000)='''',
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


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcEmail_Search]') AND type in (N'P', N'PC'))
DROP PROCEDURE [prcEmail_Search]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcEmail_Search]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
The procedure will search email sent within the selected date range to a email and contain text in subject or body

Returns:


Called By:
Calls:

Remarks:


Author: Jack Liu
Date Created: 25 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
select * from tblEmail


prcEmail_Search''20040102'',''20040228'','''','''',''''

**/

CREATE  PROCEDURE [prcEmail_Search]
(

@dateFrom  datetime,
@dateTo  datetime,
@toEmail nvarchar(50),
@subject nvarchar(50),
@body nvarchar(50),
@organisationID int
)
as
set nocount on

set @dateFrom = dbo.udfDaylightSavingTimeToUTC(@dateFrom, @organisationID)
set @dateTo = dbo.udfDaylightSavingTimeToUTC(DATEADD(day,1,@dateTo), @organisationID)

if @toEmail=''''
set @toEmail=null

if @subject=''''
set @subject=null

if @body=''''
set @body=null


select  ToEmail,
subject,
body,
dbo.udfUTCtoDaylightSavingTime(DateCreated, @organisationID) as DateCreated
from tblEmail
where DateCreated between @dateFrom and  @dateTo
and (@toEmail is null  or toEmail =@toEmail)
and (@subject is null  or subject like ''%''+ @subject +''%'')
and (@body is null  or body   like ''%''+ @body +''%'')
and OrganisationID = IsNull(@organisationID,OrganisationID)
order by datecreated
' 
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_GetNextOnceOnlyReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [prcReport_GetNextOnceOnlyReport]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_GetNextOnceOnlyReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [prcReport_GetNextOnceOnlyReport]

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
	,[ParamPolicyIDs]
    ,[ParamAcceptance]
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
		when (tblReportinterface.ReportID = 22) or (tblReportinterface.ReportID = 23) or (tblReportinterface.ReportID = 24) or (tblReportinterface.ReportID = 10) 
		then 
		(
			select coalesce(LangEntryValue, (select coalesce(tblLangValue.LangEntryValue,''Missing Localisation'') FROM tblLangValue where tblLang.LangID = tblLangValue.LangID   AND (tblLangValue.Active = 1) and tblLangValue.LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''Report.Summary'') and tblLangValue.LangResourceID = tblLangResource.LangResourceID))
		)

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
END
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
	,[ParamPolicyIDs]
    ,[ParamAcceptance]
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
	when (tblReportinterface.ReportID = 22) or (tblReportinterface.ReportID = 23) or (tblReportinterface.ReportID = 24) or (tblReportinterface.ReportID = 10) 
	then 
		(
			select coalesce(LangEntryValue, (select coalesce(tblLangValue.LangEntryValue,''Missing Localisation'') FROM tblLangValue where tblLang.LangID = tblLangValue.LangID   AND (tblLangValue.Active = 1) and tblLangValue.LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''Report.Summary'') and tblLangValue.LangResourceID = tblLangResource.LangResourceID))
		)

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


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_GetNextUrgentReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [prcReport_GetNextUrgentReport]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_GetNextUrgentReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [prcReport_GetNextUrgentReport]

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
,[ParamPolicyIDs]
,[ParamAcceptance]
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
when (tblReportinterface.ReportID = 22) or (tblReportinterface.ReportID = 23) or (tblReportinterface.ReportID = 24) or (tblReportinterface.ReportID = 10) 
then 
	(
		select coalesce(LangEntryValue, (select coalesce(tblLangValue.LangEntryValue,''Missing Localisation'') FROM tblLangValue where tblLang.LangID = tblLangValue.LangID   AND (tblLangValue.Active = 1) and tblLangValue.LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''Report.Summary'') and tblLangValue.LangResourceID = tblLangResource.LangResourceID))
	)

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
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_GetReportRequiredParameters]') AND type in (N'P', N'PC'))
DROP PROCEDURE [prcReport_GetReportRequiredParameters]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_GetReportRequiredParameters]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [prcReport_GetReportRequiredParameters]
@ReportID int
AS
BEGIN
SELECT [ReportID]
,[ReportName]
,[RDLname]
,[RequiresParamCompleted]
,[RequiresParamStatus]
,[RequiresParamFailCount]
,[RequiresParamCourseID]
,[RequiresParamCourseIDs]
,[RequiresParamHistoricCourseIDs]
,[RequiresParamUnitIDs]
,[RequiresParamAllUnits]
,[RequiresParamTimeExpired]
,[RequiresParamTimeExpiredPeriod]
,[RequiresParamQuizStatus]
,[RequiresParamGroupBy]
,[RequiresParamGroupingOption]
,[RequiresParamFirstName]
,[RequiresParamLastName]
,[RequiresParamUserName]
,[RequiresParamEmail]
,[RequiresParamIncludeInactive]
,[RequiresParamSubject]
,[RequiresParamBody]
,[RequiresParamDateTo]
,[RequiresParamDateFrom]
,[RequiresParamProfileID]
,[RequiresParamProfilePeriodID]
,[RequiresParamPolicyIDs]
,[RequiresParamAcceptanceStatus]
,[RequiresParamOnlyUsersWithShortfall]
,[ParamLangInterfaceName]
,[RequiresParamEffectiveDate]
,[RequiresParamSortBy]
,[RequiresParamClassificationID]
,[RequiresParamServerURL]
,[RequiresParamToDate]
,[RequiresParamFromDate]
,[RequiresParamUserID]
,[RequiresParamAdminUserID]
,[RequiresParamOrganisationID]

FROM tblReportInterface
WHERE ReportID = @ReportID
end
' 
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcGridExport_PeriodicRS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [prcGridExport_PeriodicRS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcGridExport_PeriodicRS]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcGridExport_PeriodicRS]

	@Param1 NVarChar(4000),
	@Param2 NVarChar(4000),
	@Param3 NVarChar(4000),
	@CurrentCultureName NVarChar(4000),
	@Expanded bit
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @OrgID int
	Declare @UserID int
	DECLARE @Sort NVarChar(4000)
	SET @OrgID=@Param1
	SET @UserID=@Param2
	SET @Sort=@Param3
	DECLARE @SQL NVarChar(4000)
	DECLARE @LangID NVarChar(4000)
		SELECT @LangID=LangID FROM tblLang where tblLang.LangCode=  @CurrentCultureName 
		IF @LangID IS NULL 
		BEGIN
			SET @LangID=2
		END

IF (@Expanded = 1)
BEGIN

	 SET @SQL=
	 --N''SELECT   ''''Report Title'''', ''''Report Type'''',''''Report Interval'''',''''Date Created'''',''''Report Starts On'''',''''Report Ends On'''',''''Next Run'''',''''Report Owner'''',''''Administration Level'''',''''Report Delivered To;'''',''''Unique ID''''    UNION ALL ''+
N''SELECT rs.ReportTitle as C1,
ri.ReportName as C2,
CAST(rs.ReportFrequency AS varchar(5))+'''' ''''+
CASE
WHEN (rs.ReportFrequencyPeriod=''''D'''') THEN
(SELECT LangEntryValue
FROM tblLangValue
where LangID=''+@LangID+''and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=''''/Reporting/PeriodicReport.aspx'''')
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''''optPeriodType.1''''))
WHEN (rs.ReportFrequencyPeriod=''''W'''') THEN
(SELECT LangEntryValue
FROM tblLangValue
where LangID=''+@LangID+''
and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=''''/Reporting/PeriodicReport.aspx'''')
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''''optPeriodType.2''''))
WHEN (rs.ReportFrequencyPeriod=''''M'''') THEN 
(SELECT LangEntryValue
FROM tblLangValue
where LangID=''+@LangID+''
and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=''''/Reporting/PeriodicReport.aspx'''')
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''''optPeriodType.3''''))
ELSE
(SELECT LangEntryValue
FROM tblLangValue
where LangID=''+@LangID+''
and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=''''/Reporting/PeriodicReport.aspx'''')
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''''optPeriodType.3''''))
END AS C3, 
convert(varchar (11),dbo.udfUTCtoDaylightSavingTime(rs.DateCreated,rs.ParamOrganisationID),113) as C4 , 
convert(varchar (11),rs.ReportStartDate,113) as C5 ,  
CASE WHEN rs.ReportEndDate IS NULL THEN ''''--'''' ELSE  convert(varchar (11),rs.ReportEndDate,113)  END as C6, 
CASE WHEN rs.NextRun > rs.ReportEndDate THEN ''''--''''
		 WHEN rs.NextRun = cast(''''1 jan 2050'''' as datetime) THEN ''''--''''
		 ELSE convert(varchar(11), rs.NextRun, 113) END
		 as C7,
(u.FirstName + '''' '''' + u.LastName) as C8,
CASE WHEN u.UserTypeID=1 THEN ''''APP ADMIN''''
WHEN u.UserTypeID=2 THEN (SELECT LangEntryValue
FROM tblLangValue
where LangID=''+@LangID+''
and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=''''GLOBAL.UserControls.AdminMenu.ascx'''')
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''''lblAdminMenuOrganisation''''))
WHEN u.UserTypeID=3 THEN (SELECT LangEntryValue
FROM tblLangValue
where LangID=''+@LangID+''
and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=''''GLOBAL.UserControls.AdminMenu.ascx'''')
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''''lblAdminMenuUnit''''))
ELSE  (SELECT LangEntryValue
FROM tblLangValue
where LangID=''+@LangID+''
and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=''''GLOBAL.UserControls.AdminMenu.ascx'''')
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''''lblAdminMenuUser''''))
END as C9,
ccu.Email as C10,
rs.ScheduleID as C11
FROM dbo.tblReportSchedule rs JOIN dbo.tblReportInterface ri ON rs.ReportID=ri.ReportID
INNER JOIN dbo.tblUser u ON u.UserID=rs.UserID
INNER JOIN dbo.tblUserType ut ON u.UserTypeID=ut.UserTypeID
INNER JOIN (SELECT ScheduleId,UserID FROM tblCCList UNION ALL SELECT ScheduleId,UserID FROM tblReportSchedule) as cc ON  cc.ScheduleId=rs.ScheduleId
INNER JOIN tblUser ccu ON cc.UserID=ccu.UserID
WHERE rs.ParamOrganisationID=''+@Param1+'' AND rs.IsPeriodic !=''''N''''	ORDER BY ''+ @Sort
END
ELSE
BEGIN
	 SET @SQL = 
	 --N''SELECT   ''''Report Title'''', ''''Report Type'''',''''Report Interval'''',''''Date Created'''',''''Report Starts On'''',''''Report Ends On'''',''''Next Run'''',''''Report Owner'''',''''Administration Level'''',''''Report Delivered To;'''',''''Unique ID''''    UNION ALL ''+
N''SELECT rs.ReportTitle as C1,
ri.ReportName as C2, 
CAST(rs.ReportFrequency AS varchar(5))+'''' ''''+
CASE 
WHEN (rs.ReportFrequencyPeriod = ''''D'''') THEN 
(SELECT LangEntryValue
FROM tblLangValue
where LangID = ''+@LangID+''and LangInterfaceID = 
	(SELECT LangInterfaceID
	FROM tblLangInterface
	where LangInterfaceName = ''''/Reporting/PeriodicReport.aspx''''  )
and LangResourceID = 
	(SELECT LangResourceID
	FROM tblLangResource
	where LangResourceName = ''''optPeriodType.1''''))
WHEN (rs.ReportFrequencyPeriod = ''''W'''') THEN 
(SELECT LangEntryValue
FROM tblLangValue
where LangID = ''+@LangID+''
and LangInterfaceID = 
	(SELECT LangInterfaceID
	FROM tblLangInterface
	where LangInterfaceName = ''''/Reporting/PeriodicReport.aspx''''  )
and LangResourceID = 
	(SELECT LangResourceID
	FROM tblLangResource
	where LangResourceName = ''''optPeriodType.2''''))
WHEN (rs.ReportFrequencyPeriod = ''''M'''') THEN 
(SELECT LangEntryValue
FROM tblLangValue
where LangID = ''+@LangID+''
and LangInterfaceID = 
	(SELECT LangInterfaceID
	FROM tblLangInterface
	where LangInterfaceName = ''''/Reporting/PeriodicReport.aspx''''  )
and LangResourceID = 
	(SELECT LangResourceID
	FROM tblLangResource
	where LangResourceName = ''''optPeriodType.3''''))
ELSE 
(SELECT LangEntryValue
FROM tblLangValue
where LangID = ''+@LangID+''
and LangInterfaceID = 
	(SELECT LangInterfaceID
	FROM tblLangInterface
	where LangInterfaceName = ''''/Reporting/PeriodicReport.aspx''''  )
and LangResourceID = 
	(SELECT LangResourceID
	FROM tblLangResource
	where LangResourceName = ''''optPeriodType.3''''))
END AS C3, 
convert(varchar (11),dbo.udfUTCtoDaylightSavingTime(rs.DateCreated,rs.ParamOrganisationID),113) as C4, 
convert(varchar (11),rs.ReportStartDate,113) as C5,
CASE WHEN rs.ReportEndDate IS NULL THEN ''''--'''' ELSE  convert(varchar (11),rs.ReportEndDate,113)  END as C6,
CASE WHEN rs.NextRun > rs.ReportEndDate THEN ''''--''''
		 WHEN rs.NextRun = cast(''''1 jan 2050'''' as datetime) THEN ''''--''''
		 ELSE convert(varchar(11), rs.NextRun, 113) END
		 as C7,
(u.FirstName + '''' '''' + u.LastName) as C8,
CASE WHEN u.UserTypeID = 1 THEN ''''APP ADMIN''''
WHEN u.UserTypeID = 2 THEN (SELECT LangEntryValue
FROM tblLangValue
where LangID = ''+@LangID+''
and LangInterfaceID = 
	(SELECT LangInterfaceID
	FROM tblLangInterface
	where LangInterfaceName = ''''GLOBAL.UserControls.AdminMenu.ascx''''  )
and LangResourceID = 
	(SELECT LangResourceID
	FROM tblLangResource
	where LangResourceName = ''''lblAdminMenuOrganisation''''))
WHEN u.UserTypeID = 3 THEN (SELECT LangEntryValue
FROM tblLangValue
where LangID = ''+@LangID+''
and LangInterfaceID = 
	(SELECT LangInterfaceID
	FROM tblLangInterface
	where LangInterfaceName = ''''GLOBAL.UserControls.AdminMenu.ascx''''  )
and LangResourceID = 
	(SELECT LangResourceID
	FROM tblLangResource
	where LangResourceName = ''''lblAdminMenuUnit'''')) 
ELSE  (SELECT LangEntryValue
FROM tblLangValue
where LangID = ''+@LangID+''
and LangInterfaceID = 
	(SELECT LangInterfaceID
	FROM tblLangInterface
	where LangInterfaceName = ''''GLOBAL.UserControls.AdminMenu.ascx''''  )
and LangResourceID = 
	(SELECT LangResourceID
	FROM tblLangResource
	where LangResourceName = ''''lblAdminMenuUser'''')) 
END as C9,
CASE WHEN ((SELECT count(*) FROM tblCCList WHERE tblCCList.ScheduleID = rs.ScheduleID) > 0) THEN (Convert(varchar, (SELECT 1+count(*) FROM tblCCList WHERE tblCCList.ScheduleID = rs.ScheduleID)) + '''' Recepients'''') ELSE u.Email  END as C10,
rs.ScheduleID as C11
FROM dbo.tblReportSchedule rs JOIN dbo.tblReportInterface ri ON rs.ReportID = ri.ReportID		inner JOIN dbo.tblUser u ON u.UserID = rs.UserID		inner JOIN dbo.tblUserType ut ON u.UserTypeID = ut.UserTypeID				WHERE rs.ParamOrganisationID = ''+@Param1+'' AND rs.IsPeriodic != ''''N''''		ORDER BY ''+ @Sort
END

	EXEC dbo.sp_executesql @SQL

END
' 
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcGridExport_PeriodicPDF]') AND type in (N'P', N'PC'))
DROP PROCEDURE [prcGridExport_PeriodicPDF]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcGridExport_PeriodicPDF]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcGridExport_PeriodicPDF]

	@Param1 NVarChar(4000),
	@Param2 NVarChar(4000),
	@Param3 NVarChar(4000),
	@CurrentCultureName NVarChar(4000)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @OrgID int
	Declare @UserID int
	DECLARE @Sort NVarChar(4000)
	SET @OrgID = @Param1
	SET @UserID = @Param2
	SET @Sort = @Param3
	DECLARE @SQL NVarChar(4000)
	DECLARE @LangID NVarChar(4000)
		SELECT @LangID = LangID FROM tblLang where tblLang.LangCode =   @CurrentCultureName 
		IF @LangID IS NULL 
		BEGIN
			SET @LangID = 2
		END

	--DECLARE @CCList TABLE(ScheduleId int, CC int)
	--INSERT INTO @CCList(ScheduleId, CC) 
	--	(SELECT ccl.ScheduleId, Count(UserId) as CC FROM tblCCList ccl
	--		GROUP BY ccl.ScheduleId
	--		HAVING ccl.ScheduleId In 
	--			(SELECT rs.ScheduleId FROM tblReportSchedule rs
	--			INNER JOIN dbo.tblUser u ON u.UserID = rs.UserID WHERE ParamOrganisationID = @OrgID))

	 SET @SQL = 
	 --N''SELECT   ''''Report Title'''', ''''Report Type'''',''''Report Interval'''',''''Date Created'''',''''Report Starts On'''',''''Report Ends On'''',''''Next Run'''',''''Report Owner'''',''''Administration Level'''',''''Report Delivered To;'''',''''Unique ID''''    UNION ALL ''+
N''SELECT rs.ReportTitle,
ri.ReportName, 
CAST(rs.ReportFrequency AS varchar(5))+'''' ''''+
CASE 
WHEN (rs.ReportFrequencyPeriod = ''''D'''') THEN 
(SELECT LangEntryValue
FROM tblLangValue
where LangID = ''+@LangID+''and LangInterfaceID = 
	(SELECT LangInterfaceID
	FROM tblLangInterface
	where LangInterfaceName = ''''/Reporting/PeriodicReport.aspx''''  )
and LangResourceID = 
	(SELECT LangResourceID
	FROM tblLangResource
	where LangResourceName = ''''optPeriodType.1''''))
WHEN (rs.ReportFrequencyPeriod = ''''W'''') THEN 
(SELECT LangEntryValue
FROM tblLangValue
where LangID = ''+@LangID+''
and LangInterfaceID = 
	(SELECT LangInterfaceID
	FROM tblLangInterface
	where LangInterfaceName = ''''/Reporting/PeriodicReport.aspx''''  )
and LangResourceID = 
	(SELECT LangResourceID
	FROM tblLangResource
	where LangResourceName = ''''optPeriodType.2''''))
WHEN (rs.ReportFrequencyPeriod = ''''M'''') THEN 
(SELECT LangEntryValue
FROM tblLangValue
where LangID = ''+@LangID+''
and LangInterfaceID = 
	(SELECT LangInterfaceID
	FROM tblLangInterface
	where LangInterfaceName = ''''/Reporting/PeriodicReport.aspx''''  )
and LangResourceID = 
	(SELECT LangResourceID
	FROM tblLangResource
	where LangResourceName = ''''optPeriodType.3''''))
ELSE 
(SELECT LangEntryValue
FROM tblLangValue
where LangID = ''+@LangID+''
and LangInterfaceID = 
	(SELECT LangInterfaceID
	FROM tblLangInterface
	where LangInterfaceName = ''''/Reporting/PeriodicReport.aspx''''  )
and LangResourceID = 
	(SELECT LangResourceID
	FROM tblLangResource
	where LangResourceName = ''''optPeriodType.3''''))
END AS ReportInterval, 
convert(varchar (11),dbo.udfUTCtoDaylightSavingTime(rs.DateCreated,rs.ParamOrganisationID),113) as DateCreated , 
convert(varchar (11),rs.ReportStartDate,113) as StartDate ,  
CASE WHEN rs.ReportEndDate IS NULL THEN ''''--'''' ELSE  convert(varchar (11),rs.ReportEndDate,113)  END as EndDate, 
CASE WHEN rs.NextRun > rs.ReportEndDate THEN ''''--''''
		 WHEN rs.NextRun = cast(''''01 jan 2050'''' as datetime) THEN ''''--''''
		 ELSE convert(varchar(11), rs.NextRun, 113) END
		 as NextRun, 
(u.FirstName + '''' '''' + u.LastName) as Username,
CASE WHEN u.UserTypeID = 1 THEN ''''APP ADMIN''''
WHEN u.UserTypeID = 2 THEN (SELECT LangEntryValue
FROM tblLangValue
where LangID = ''+@LangID+''
and LangInterfaceID = 
	(SELECT LangInterfaceID
	FROM tblLangInterface
	where LangInterfaceName = ''''GLOBAL.UserControls.AdminMenu.ascx''''  )
and LangResourceID = 
	(SELECT LangResourceID
	FROM tblLangResource
	where LangResourceName = ''''lblAdminMenuOrganisation''''))
WHEN u.UserTypeID = 3 THEN (SELECT LangEntryValue
FROM tblLangValue
where LangID = ''+@LangID+''
and LangInterfaceID = 
	(SELECT LangInterfaceID
	FROM tblLangInterface
	where LangInterfaceName = ''''GLOBAL.UserControls.AdminMenu.ascx''''  )
and LangResourceID = 
	(SELECT LangResourceID
	FROM tblLangResource
	where LangResourceName = ''''lblAdminMenuUnit'''')) 
ELSE  (SELECT LangEntryValue
FROM tblLangValue
where LangID = ''+@LangID+''
and LangInterfaceID = 
	(SELECT LangInterfaceID
	FROM tblLangInterface
	where LangInterfaceName = ''''GLOBAL.UserControls.AdminMenu.ascx''''  )
and LangResourceID = 
	(SELECT LangResourceID
	FROM tblLangResource
	where LangResourceName = ''''lblAdminMenuUser'''')) 
END as AdministrationLevel,
CASE WHEN ((SELECT count(*) FROM tblCCList WHERE tblCCList.ScheduleID = rs.ScheduleID) > 0) THEN (Convert(varchar, (SELECT 1+count(*) FROM tblCCList WHERE tblCCList.ScheduleID = rs.ScheduleID)) + '''' Recepients'''') ELSE u.Email  END as DeliveredTo,
rs.ScheduleID as UniqueID
FROM dbo.tblReportSchedule rs JOIN dbo.tblReportInterface ri ON rs.ReportID = ri.ReportID		inner JOIN dbo.tblUser u ON u.UserID = rs.UserID		inner JOIN dbo.tblUserType ut ON u.UserTypeID = ut.UserTypeID				WHERE rs.ParamOrganisationID = ''+@Param1+'' AND rs.IsPeriodic != ''''N''''		ORDER BY ''+ @Sort

	EXEC dbo.sp_executesql @SQL

END
' 
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcGridExport_PeriodicCSV]') AND type in (N'P', N'PC'))
DROP PROCEDURE [prcGridExport_PeriodicCSV]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcGridExport_PeriodicCSV]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcGridExport_PeriodicCSV]

	@Param1 NVarChar(4000),
	@Param2 NVarChar(4000),
	@Param3 NVarChar(4000),
	@CurrentCultureName NVarChar(4000)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @OrgID int
	Declare @UserID int
	DECLARE @Sort NVarChar(4000)
	SET @OrgID=@Param1
	SET @UserID=@Param2
	SET @Sort=@Param3
	DECLARE @SQL NVarChar(4000)
	DECLARE @LangID NVarChar(4000)
		SELECT @LangID=LangID FROM tblLang where tblLang.LangCode=  @CurrentCultureName 
		IF @LangID IS NULL 
		BEGIN
			SET @LangID=2
		END

	--DECLARE @CCList TABLE(ScheduleId int, CC int)
	--INSERT INTO @CCList(ScheduleId, CC) 
	--	(SELECT ccl.ScheduleId, Count(UserId) as CC FROM tblCCList ccl
	--		GROUP BY ccl.ScheduleId
	--		HAVING ccl.ScheduleId In 
	--			(SELECT rs.ScheduleId FROM tblReportSchedule rs
	--			INNER JOIN dbo.tblUser u ON u.UserID=rs.UserID WHERE ParamOrganisationID=@OrgID))

	 SET @SQL=
	 --N''SELECT   ''''Report Title'''', ''''Report Type'''',''''Report Interval'''',''''Date Created'''',''''Report Starts On'''',''''Report Ends On'''',''''Next Run'''',''''Report Owner'''',''''Administration Level'''',''''Report Delivered To;'''',''''Unique ID''''    UNION ALL ''+
N''SELECT rs.ReportTitle,
ri.ReportName,
CAST(rs.ReportFrequency AS varchar(5))+'''' ''''+
CASE
WHEN (rs.ReportFrequencyPeriod=''''D'''') THEN
(SELECT LangEntryValue
FROM tblLangValue
where LangID=''+@LangID+''and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=''''/Reporting/PeriodicReport.aspx'''')
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''''optPeriodType.1''''))
WHEN (rs.ReportFrequencyPeriod=''''W'''') THEN
(SELECT LangEntryValue
FROM tblLangValue
where LangID=''+@LangID+''
and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=''''/Reporting/PeriodicReport.aspx'''')
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''''optPeriodType.2''''))
WHEN (rs.ReportFrequencyPeriod=''''M'''') THEN 
(SELECT LangEntryValue
FROM tblLangValue
where LangID=''+@LangID+''
and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=''''/Reporting/PeriodicReport.aspx'''')
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''''optPeriodType.3''''))
ELSE
(SELECT LangEntryValue
FROM tblLangValue
where LangID=''+@LangID+''
and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=''''/Reporting/PeriodicReport.aspx'''')
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''''optPeriodType.3''''))
END AS ReportInterval, 
convert(varchar (11),dbo.udfUTCtoDaylightSavingTime(rs.DateCreated,rs.ParamOrganisationID),113) as DateCreated , 
convert(varchar (11),rs.ReportStartDate,113) as StartDate ,  
CASE WHEN rs.ReportEndDate IS NULL THEN ''''--'''' ELSE  convert(varchar (11),rs.ReportEndDate,113)  END as EndDate, 
CASE WHEN rs.NextRun > rs.ReportEndDate THEN ''''--''''
		 WHEN rs.NextRun = cast(''''1 jan 2050'''' as datetime) THEN ''''--''''
		 ELSE convert(varchar(11), rs.NextRun, 113) END
		 as NextRun,
(u.FirstName + '''' '''' + u.LastName) as Username,
CASE WHEN u.UserTypeID=1 THEN ''''APP ADMIN''''
WHEN u.UserTypeID=2 THEN (SELECT LangEntryValue
FROM tblLangValue
where LangID=''+@LangID+''
and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=''''GLOBAL.UserControls.AdminMenu.ascx'''')
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''''lblAdminMenuOrganisation''''))
WHEN u.UserTypeID=3 THEN (SELECT LangEntryValue
FROM tblLangValue
where LangID=''+@LangID+''
and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=''''GLOBAL.UserControls.AdminMenu.ascx'''')
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''''lblAdminMenuUnit''''))
ELSE  (SELECT LangEntryValue
FROM tblLangValue
where LangID=''+@LangID+''
and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=''''GLOBAL.UserControls.AdminMenu.ascx'''')
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''''lblAdminMenuUser''''))
END as AdministrationLevel,
ccu.Email as DeliveredTo,
rs.ScheduleID as UniqueID
FROM dbo.tblReportSchedule rs JOIN dbo.tblReportInterface ri ON rs.ReportID=ri.ReportID
INNER JOIN dbo.tblUser u ON u.UserID=rs.UserID
INNER JOIN dbo.tblUserType ut ON u.UserTypeID=ut.UserTypeID
INNER JOIN (SELECT ScheduleId,UserID FROM tblCCList UNION ALL SELECT ScheduleId,UserID FROM tblReportSchedule) as cc ON  cc.ScheduleId=rs.ScheduleId
INNER JOIN tblUser ccu ON cc.UserID=ccu.UserID
WHERE rs.ParamOrganisationID=''+@Param1+'' AND rs.IsPeriodic !=''''N''''	ORDER BY ''+ @Sort

	EXEC dbo.sp_executesql @SQL

END
' 
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUserQuizStatus_InsertExpiry]') AND type in (N'P', N'PC'))
DROP PROCEDURE [prcUserQuizStatus_InsertExpiry]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUserQuizStatus_InsertExpiry]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [prcUserQuizStatus_InsertExpiry]
(
	@UserID int
	, @ModuleID int
	,@OrganisationID int
)
AS
	SET nocount ON
	insert tblExpiredNewContent (ModuleID,OrganisationID,UserID)
	values (@ModuleID ,@OrganisationID,@UserID)

' 
END
GO


If  exists (select * from tblLangValue where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/MyTraining.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'locDue')) 
begin 
update tblLangValue 
set LangEntryValue = N'Quiz Due'
where (LangID =2)
and (LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/MyTraining.aspx'))
and (LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'locDue'))
end 
GO

If  exists (select * from tblLangValue where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/MyTraining.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'locQuiz')) 
begin 
update tblLangValue 
set LangEntryValue = N'Quiz'
where (LangID =2)
and (LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/MyTraining.aspx'))
and (LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'locQuiz'))
end 
GO
