SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcGetPeriodicReportListOnInactivateUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra Jagtap
-- Create date: 21/10/2011
-- Description:	Gets the list of periodic reports on inactivating user
-- =============================================
CREATE PROCEDURE [prcGetPeriodicReportListOnInactivateUser]
(
	@OrgID int,
	@Username varchar(50)
) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  	SELECT rs.ScheduleID, rs.UserID, ri.ReportID, rs.ReportTitle, u.Username, ri.ReportName, rs.ReportFrequency
	FROM dbo.tblReportSchedule rs JOIN dbo.tblReportInterface ri ON rs.ReportID = ri.ReportID
	JOIN dbo.tblUser u ON u.UserID = rs.UserID
	WHERE rs.ParamOrganisationID = @OrgID AND 
	(u.Username=@Username OR rs.scheduleid in 
	(select scheduleid from tblCCList ccl JOIN 
	tblUser tu ON tu.userid = ccl.userid where tu.username = @Username))
END
-- OR ' 
END
GO
