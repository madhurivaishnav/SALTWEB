SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcSetPeriodicFields]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra Jagtap
-- Create date: 27/10/2011
-- Description:	Sets the periodicity related fields for a periodic report
-- =============================================
CREATE PROCEDURE [prcSetPeriodicFields] 
(
	@ScheduleId int,
	@ReportTitle nvarchar(100),
	@IsPeriodic char(1),
	@ReportStartDate datetime,
	@ReportFrequency int, 
	@ReportFrequencyPeriod char(1),
	@ReportEndDate datetime,
	@NumberOfReports int,
	@ReportPeriodType int,
	@ReportFromDate datetime
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF NOT EXISTS (SELECT ScheduleId FROM tblReportSchedule WHERE ScheduleId = @ScheduleId)
	BEGIN
		INSERT INTO tblReportSchedule(ReportTitle, IsPeriodic, ReportStartDate, ReportFrequency, ReportFrequencyPeriod, ReportEndDate, NumberOfReports, ReportPeriodType, ReportFromDate, NextRun)
			VALUES (@ReportTitle, @IsPeriodic, @ReportStartDate, @ReportFrequency, @ReportFrequencyPeriod, @ReportEndDate, @NumberOfReports, @ReportPeriodType, @ReportFromDate, NULL)
	END
	ELSE
	BEGIN
		 UPDATE tblReportSchedule SET ReportTitle=@ReportTitle, IsPeriodic=@IsPeriodic, ReportStartDate=@ReportStartDate, ReportFrequency=@ReportFrequency, 
			ReportFrequencyPeriod=@ReportFrequencyPeriod, ReportEndDate=@ReportEndDate, NumberOfReports=@NumberOfReports, ReportPeriodType=@ReportPeriodType, ReportFromDate=@ReportFromDate,
			NextRun=NULL WHERE ScheduleID=@ScheduleId
	END 
END' 
END
GO
