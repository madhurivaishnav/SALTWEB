SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_GetReportRequiredParameters]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [prcReport_GetReportRequiredParameters]
@ReportID int
AS
BEGIN
SELECT [ReportID]
,[ReportName]
,[RDLname]
,[RequiresParamCompleted]
,[RequiresParamStatus]
,[RequiresParamFailCount]
,[RequiresParamCourseID]
,[RequiresParamCourseIDs]
,[RequiresParamHistoricCourseIDs]
,[RequiresParamUnitIDs]
,[RequiresParamAllUnits]
,[RequiresParamTimeExpired]
,[RequiresParamTimeExpiredPeriod]
,[RequiresParamQuizStatus]
,[RequiresParamGroupBy]
,[RequiresParamGroupingOption]
,[RequiresParamFirstName]
,[RequiresParamLastName]
,[RequiresParamUserName]
,[RequiresParamEmail]
,[RequiresParamIncludeInactive]
,[RequiresParamSubject]
,[RequiresParamBody]
,[RequiresParamDateTo]
,[RequiresParamDateFrom]
,[RequiresParamProfileID]
,[RequiresParamProfilePeriodID]
,[RequiresParamPolicyIDs]
,[RequiresParamAcceptanceStatus]
,[RequiresParamOnlyUsersWithShortfall]
,[ParamLangInterfaceName]
,[RequiresParamEffectiveDate]
,[RequiresParamSortBy]
,[RequiresParamClassificationID]
,[RequiresParamServerURL]
,[RequiresParamToDate]
,[RequiresParamFromDate]
,[RequiresParamUserID]
,[RequiresParamAdminUserID]
,[RequiresParamOrganisationID]

FROM tblReportInterface
WHERE ReportID = @ReportID
end
' 
END
GO


