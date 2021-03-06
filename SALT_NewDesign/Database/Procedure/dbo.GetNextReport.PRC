SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetNextReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [GetNextReport]

AS
BEGIN

SET NOCOUNT ON
DECLARE @ScheduleID int
SELECT @ScheduleID = MIN (ScheduleID)
  FROM tblReportSchedule
  WHERE ((LastRun IS NULL) AND ReportStartDate < GETUTCDATE())
  OR ((ReportFrequencyPeriod=''Y'') AND (GETUTCDATE() < DATEADD(YEAR,ReportFrequency,LastRun)))
  OR  ((ReportFrequencyPeriod=''M'') AND (GETUTCDATE() < DATEADD(MONTH,ReportFrequency,LastRun)))
  OR  ((ReportFrequencyPeriod=''W'') AND (GETUTCDATE() < DATEADD(WEEK,ReportFrequency,LastRun)))
  OR  ((ReportFrequencyPeriod=''D'') AND (GETUTCDATE() < DATEADD(DAY,ReportFrequency,LastRun)))
  
UPDATE tblReportSchedule SET LastRun = GETUTCDATE() WHERE ScheduleID = @ScheduleID 
  
SET NOCOUNT OFF
SELECT TOP (1) [ScheduleID]
      ,[UserID]
      ,[ReportID]
      ,[LastRun]
      ,[ReportDuration]
      ,[ReportDurationPeriod]
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
      ,[ParamOnlyUsersWithShortfall]
      ,[ParamEffectiveDate]
      ,[ParamSortBy]
      ,[ParamClassificationID]
  FROM tblReportSchedule
  WHERE ScheduleID = @ScheduleID 
  
  END
' 
END
GO
