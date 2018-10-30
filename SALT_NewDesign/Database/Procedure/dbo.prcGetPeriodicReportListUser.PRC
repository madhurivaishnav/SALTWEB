SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcGetPeriodicReportListUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra Jagtap
-- Create date: 18/10/2011
-- Description:	Gets the list of periodic reports for a user
-- =============================================
CREATE PROCEDURE [prcGetPeriodicReportListUser]
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
