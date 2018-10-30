SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_ReassignReportInactive]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra Jagtap
-- Create date: 14/12/2011
-- Description:	Reassigns owner or cc for the periodic report
-- =============================================
CREATE PROCEDURE [prcReport_ReassignReportInactive] 
	-- Add the parameters for the stored procedure here
	@ScheduleId int = 0, 
	@FromUser int = 0,
	@ToUser int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF EXISTS (SELECT * FROM tblReportSchedule 
		WHERE ScheduleID = @ScheduleId AND UserID = @FromUser)
	BEGIN
		UPDATE tblReportSchedule SET UserID = @ToUser
			WHERE ScheduleID = @ScheduleId
	END
	
	IF EXISTS (SELECT * FROM tblCCList
		WHERE ScheduleId = @ScheduleId AND UserID = @FromUser)
	BEGIN
		UPDATE tblCCList SET UserID = @ToUser
			WHERE ScheduleID = @ScheduleId
	END
	
END
' 
END
GO
