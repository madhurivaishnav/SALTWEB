SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_GetTypeFromScheduleId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra Jagtap
-- Create date: 10/11/2011
-- Description:	Gets report type id from schedule id
-- =============================================
CREATE PROCEDURE [prcReport_GetTypeFromScheduleId] 
	-- Add the parameters for the stored procedure here
	@ScheduleId int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ReportName FROM tblReportSchedule rs
		JOIN tblReportInterface ri ON  rs.ReportID = ri.ReportID
		WHERE rs.ScheduleID = @ScheduleId
END
' 
END
GO
