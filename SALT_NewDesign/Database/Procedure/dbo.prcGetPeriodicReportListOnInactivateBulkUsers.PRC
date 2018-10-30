SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcGetPeriodicReportListOnInactivateBulkUsers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra Jagtap
-- Create date: 21/10/2011
-- Description:	Gets the list of periodic reports on bulk inactivating users
-- =============================================
CREATE PROCEDURE [prcGetPeriodicReportListOnInactivateBulkUsers]
(
	@OrgID int
) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @InActivatedUsers TABLE(UserID int, Processed bit)
	INSERT INTO @InActivatedUsers(UserID, Processed) (SELECT UserID, Processed from tblBulkInactiveUsers WHERE Processed = 0)

	SELECT rs.ScheduleID, rs.UserID, ri.ReportID, rs.ReportTitle, u.Username, ri.ReportName, rs.ReportFrequency
		FROM dbo.tblReportSchedule rs JOIN dbo.tblReportInterface ri ON rs.ReportID = ri.ReportID
		JOIN dbo.tblUser u ON u.UserID = rs.UserID
		WHERE rs.ParamOrganisationID = @OrgID
		AND u.UserID in (SELECT UserID FROM @InActivatedUsers)
			
	UPDATE tblBulkInactiveUsers SET Processed = 1 
		WHERE UserID in (SELECT UserID FROM @InActivatedUsers)
		
	DELETE FROM tblBulkInactiveUsers WHERE Processed = 1

END
' 
END
GO
