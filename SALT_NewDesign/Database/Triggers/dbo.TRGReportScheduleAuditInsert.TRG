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


 