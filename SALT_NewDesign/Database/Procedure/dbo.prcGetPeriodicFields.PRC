SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcGetPeriodicFields]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Name
-- Create date: 26/10/2011
-- Description:	Gets the periodicity related fields for a periodic report
-- =============================================
CREATE PROCEDURE [prcGetPeriodicFields] 
(
	-- Add the parameters for the stored procedure here
	@ScheduleId int
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ReportTitle, IsPeriodic, ReportStartDate, ReportFrequency, ReportFrequencyPeriod, 
		CASE WHEN ((ReportEndDate IS NULL) AND (NumberOfReports IS NULL)) THEN 1 ELSE 0 END AS NoEndDate,
		CASE WHEN NumberOfReports IS NOT NULL THEN 1 ELSE 0 END AS EndAfter,
		NumberOfReports, CASE WHEN ReportEndDate IS NOT NULL THEN 1 ELSE 0 END AS EndOn,
		ReportEndDate, ReportPeriodType, ReportFromDate FROM tblReportSchedule WHERE ScheduleID=@ScheduleId 
END' 
END
GO
