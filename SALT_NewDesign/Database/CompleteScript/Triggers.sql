SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgLessonSession]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgLessonSession]
GO

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

CREATE TRIGGER trgLessonSession ON [dbo].[tblLessonSession] 
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





GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[TRGReportScheduleAuditDelete]'))
DROP TRIGGER [TRGReportScheduleAuditDelete]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[TRGReportScheduleAuditDelete]'))
EXEC dbo.sp_executesql @statement = N'CREATE TRIGGER [TRGReportScheduleAuditDelete]
   ON  [tblReportSchedule] 
   AFTER  DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
INSERT INTO tblReportScheduleAudit
           ([ScheduleID]
		   ,[UserID]
           ,[ReportID]
           ,[LastRun]
           ,[NextRun]
           ,[ReportDuration]
           ,[ReportDurationPeriod]
           ,[ReportStartDate]
           ,[ReportEndDate]
           ,[NumberOfReports]
           ,[ReportFrequency]
           ,[ReportFrequencyPeriod]
           ,[DocumentType]
           ,[ReportTitle]
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
           ,[ParamOnlyUsersWithShortfall]
           ,[ParamEffectiveDate]
           ,[ParamSortBy]
           ,[ParamClassificationID]
           ,[ParamUnitIDs]
           ,[ParamLangCode]
           ,[ParamDateTo]
           ,[ParamDateFrom]
           ,[ParamLicensingPeriod]
           ,[ParamProfilePeriodID]
           ,[ReportPeriodType]
           ,[ReportFromDate]
           ,[IsPeriodic]
           ,[LastUpdatedBy]
           ,[LastUpdated]
           ,[NumberDelivered]
           ,[TerminatedNormally]
           ,[LastUpdAction]
         ,DateCreated  )
SELECT [ScheduleID]
      ,[UserID]
      ,[ReportID]
      ,[LastRun]
      ,[NextRun]
      ,[ReportDuration]
      ,[ReportDurationPeriod]
      ,[ReportStartDate]
      ,[ReportEndDate]
      ,[NumberOfReports]
      ,[ReportFrequency]
      ,[ReportFrequencyPeriod]
      ,[DocumentType]
      ,[ReportTitle]
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
      ,[ParamOnlyUsersWithShortfall]
      ,[ParamEffectiveDate]
      ,[ParamSortBy]
      ,[ParamClassificationID]
      ,[ParamUnitIDs]
      ,[ParamLangCode]
      ,[ParamDateTo]
      ,[ParamDateFrom]
      ,[ParamLicensingPeriod]
      ,[ParamProfilePeriodID]
      ,[ReportPeriodType]
      ,[ReportFromDate]
      ,[IsPeriodic]
      ,[LastUpdatedBy]
      ,[LastUpdated]
      ,[NumberDelivered]
      ,[TerminatedNormally]
      ,''D''
     ,DateCreated 
  FROM  deleted

END
' 
GO


 

IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[TRGReportScheduleAuditInsert]'))
DROP TRIGGER [TRGReportScheduleAuditInsert]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[TRGReportScheduleAuditInsert]'))
EXEC dbo.sp_executesql @statement = N'CREATE TRIGGER [TRGReportScheduleAuditInsert]
   ON  [tblReportSchedule] 
   AFTER  INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
INSERT INTO tblReportScheduleAudit
           ([ScheduleID]
		   ,[UserID]
           ,[ReportID]
           ,[LastRun]
           ,[NextRun]
           ,[ReportDuration]
           ,[ReportDurationPeriod]
           ,[ReportStartDate]
           ,[ReportEndDate]
           ,[NumberOfReports]
           ,[ReportFrequency]
           ,[ReportFrequencyPeriod]
           ,[DocumentType]
           ,[ReportTitle]
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
           ,[ParamOnlyUsersWithShortfall]
           ,[ParamEffectiveDate]
           ,[ParamSortBy]
           ,[ParamClassificationID]
           ,[ParamUnitIDs]
           ,[ParamLangCode]
           ,[ParamDateTo]
           ,[ParamDateFrom]
           ,[ParamLicensingPeriod]
           ,[ParamProfilePeriodID]
           ,[ReportPeriodType]
           ,[ReportFromDate]
           ,[IsPeriodic]
           ,[LastUpdatedBy]
           ,[LastUpdated]
           ,[NumberDelivered]
           ,[TerminatedNormally]
           ,[LastUpdAction]
         ,DateCreated  )
SELECT [ScheduleID]
      ,[UserID]
      ,[ReportID]
      ,[LastRun]
      ,[NextRun]
      ,[ReportDuration]
      ,[ReportDurationPeriod]
      ,[ReportStartDate]
      ,[ReportEndDate]
      ,[NumberOfReports]
      ,[ReportFrequency]
      ,[ReportFrequencyPeriod]
      ,[DocumentType]
      ,[ReportTitle]
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
      ,[ParamOnlyUsersWithShortfall]
      ,[ParamEffectiveDate]
      ,[ParamSortBy]
      ,[ParamClassificationID]
      ,[ParamUnitIDs]
      ,[ParamLangCode]
      ,[ParamDateTo]
      ,[ParamDateFrom]
      ,[ParamLicensingPeriod]
      ,[ParamProfilePeriodID]
      ,[ReportPeriodType]
      ,[ReportFromDate]
      ,[IsPeriodic]
      ,[LastUpdatedBy]
      ,[LastUpdated]
      ,[NumberDelivered]
      ,[TerminatedNormally]
      ,''I''
     ,DateCreated 
  FROM  inserted
WHERE   IsPeriodic = ''N''

END
' 
GO


 

IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[TRGReportScheduleAuditUpdate]'))
DROP TRIGGER [TRGReportScheduleAuditUpdate]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[TRGReportScheduleAuditUpdate]'))
EXEC dbo.sp_executesql @statement = N'CREATE TRIGGER [TRGReportScheduleAuditUpdate]
   ON  [tblReportSchedule] 
   AFTER  UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
INSERT INTO tblReportScheduleAudit
           ([ScheduleID]
		   ,[UserID]
           ,[ReportID]
           ,[LastRun]
           ,[NextRun]
           ,[ReportDuration]
           ,[ReportDurationPeriod]
           ,[ReportStartDate]
           ,[ReportEndDate]
           ,[NumberOfReports]
           ,[ReportFrequency]
           ,[ReportFrequencyPeriod]
           ,[DocumentType]
           ,[ReportTitle]
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
           ,[ParamOnlyUsersWithShortfall]
           ,[ParamEffectiveDate]
           ,[ParamSortBy]
           ,[ParamClassificationID]
           ,[ParamUnitIDs]
           ,[ParamLangCode]
           ,[ParamDateTo]
           ,[ParamDateFrom]
           ,[ParamLicensingPeriod]
           ,[ParamProfilePeriodID]
           ,[ReportPeriodType]
           ,[ReportFromDate]
           ,[IsPeriodic]
           ,[LastUpdatedBy]
           ,[LastUpdated]
           ,[NumberDelivered]
           ,[TerminatedNormally]
           ,[LastUpdAction]
         ,DateCreated  )
SELECT [ScheduleID]
      ,[UserID]
      ,[ReportID]
      ,[LastRun]
      ,[NextRun]
      ,[ReportDuration]
      ,[ReportDurationPeriod]
      ,[ReportStartDate]
      ,[ReportEndDate]
      ,[NumberOfReports]
      ,[ReportFrequency]
      ,[ReportFrequencyPeriod]
      ,[DocumentType]
      ,[ReportTitle]
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
      ,[ParamOnlyUsersWithShortfall]
      ,[ParamEffectiveDate]
      ,[ParamSortBy]
      ,[ParamClassificationID]
      ,[ParamUnitIDs]
      ,[ParamLangCode]
      ,[ParamDateTo]
      ,[ParamDateFrom]
      ,[ParamLicensingPeriod]
      ,[ParamProfilePeriodID]
      ,[ReportPeriodType]
      ,[ReportFromDate]
      ,[IsPeriodic]
      ,[LastUpdatedBy]
      ,[LastUpdated]
      ,[NumberDelivered]
      ,[TerminatedNormally]
      ,''U''
     ,DateCreated 
  FROM  inserted

END
' 
GO


 


