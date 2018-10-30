SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_GetNextUrgentReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prcReport_GetNextUrgentReport]

AS
BEGIN
-- Only returns NOW schedules - Send these first to give a greater sense of response by the application
-- NEXTRUN is always saved in UTC to reduce conversion times
-- NextRun is never null
SET NOCOUNT ON

DECLARE @ScheduleID int,
@RunDate datetime,
@ReportStartDate datetime,
@ReportFrequencyPeriod char(1),
@ReportFrequency int,
@OrgID int	,
@ReportFromDate datetime,
@NumberDelivered int,
@NumberOfReports int,
@ReportEndDate datetime,
@ReportPeriodType int,
@ReportID int,
@DateFrom DateTime

UPDATE tblReportSchedule -- remove schedules for inactive users
SET NumberDelivered = 0,
TerminatedNormally = 1,
LastRun = getUTCdate(),
NextRun = null
WHERE ScheduleID in
(
SELECT ScheduleID
FROM tblReportSchedule
INNER JOIN tblUser ON tblReportSchedule.UserID = tblUser.UserID
WHERE (TerminatedNormally = 0)
AND (IsPeriodic = ''N'')
AND (tblUser.Active = 0)
)

SELECT @ScheduleID = ScheduleID
FROM tblReportSchedule
INNER JOIN tblReportInterface ON tblReportSchedule.ReportID = tblReportInterface.ReportID
INNER JOIN tblUser ON tblReportSchedule.UserID = tblUser.UserID
INNER JOIN tblOrganisation ON tblOrganisation.OrganisationID = tblReportSchedule.ParamOrganisationID
WHERE  CourseStatusLastUpdated > dbo.udfGetSaltOrgMidnight(tblUser.OrganisationID)
AND (TerminatedNormally = 0)
AND (IsPeriodic = ''N'')
AND (tblUser.Active = 1)

DECLARE @OnBehalfOf nvarchar(255)
DECLARE @ReplyTo nvarchar(255)
DECLARE @FromDate DateTime = CAST(''1 Jan 2002'' as datetime)

IF (@ScheduleID IS NOT NULL)
BEGIN
DECLARE @NextRun datetime
SELECT @NextRun = NextRun,
@ReportStartDate = ReportStartDate,
@ReportFrequencyPeriod = ReportFrequencyPeriod,
@ReportFrequency = ReportFrequency,
@OrgID = ParamOrganisationID,
@ReportFromDate = ReportFromDate,
@NumberDelivered = NumberDelivered,
@NumberOfReports = NumberOfReports,
@ReportEndDate = ReportEndDate ,
@ReportPeriodType = coalesce(ReportPeriodType ,3),
@ReportID = ReportID,
@DateFrom = ParamDateFrom
FROM tblReportSchedule WHERE ScheduleID = @ScheduleID

-- we know the to date - just need to read the from date
SET @FromDate = @ReportStartDate

-- except if its these reports
IF (@ReportID=2) or (@ReportID = 25)
BEGIN
SET @FromDate = @DateFrom 
END




END -- IF ScheduleID is not null


-- return the results
SET NOCOUNT OFF
SELECT TOP (1) [ScheduleID]
,RS.UserID
,RS.ReportID
,RS.ParamDateTo as LastRun
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
,[ParamProfilePeriodID]
,[ParamPolicyIDs]
,[ParamAcceptance]
,[ParamOnlyUsersWithShortfall]
,[ParamEffectiveDate]
,[ParamSortBy]
,[ParamClassificationID]
,ParamLangInterfaceName
, case
when tblReportinterface.ReportID = 26 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.2''))
when tblReportinterface.ReportID = 27 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.2''))
when tblReportinterface.ReportID = 3 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.1''))
when tblReportinterface.ReportID = 6 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.1''))
when (tblReportinterface.ReportID = 22) or (tblReportinterface.ReportID = 23) or (tblReportinterface.ReportID = 24) or (tblReportinterface.ReportID = 10)
then
(
select coalesce(LangEntryValue, (select coalesce(tblLangValue.LangEntryValue,''Missing Localisation'') FROM tblLangValue where tblLang.LangID = tblLangValue.LangID   AND (tblLangValue.Active = 1) and tblLangValue.LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''Report.Summary'') and tblLangValue.LangResourceID = tblLangResource.LangResourceID))
)

else coalesce(tblLangValue.LangEntryValue,''Missing Localisation'')
end as ReportName
,tblReportInterface.RDLname
,tblUser.FirstName
,tblUser.LastName
,tblUser.Email
,ParamUnitIDs
,paramOrganisationID
,RS.ParamLangCode
,ParamLangCode
,ParamLicensingPeriod
,RS.ReportEndDate
,RS.ReportTitle
,RS.NumberOfReports
,RS.ReportFromDate
,(dbo.udfGetCCList(RS.ScheduleID)) as CCList
,RS.ReportPeriodType
,dbo.udfGetEmailOnBehalfOf (ParamOrganisationID) as OnBehalfOf
,RS.NextRun
,RS.ReportFromDate
,@FromDate as FromDate
,dbo.udfGetEmailReplyTo (ParamOrganisationID,tblUser.FirstName + '' '' + tblUser.LastName + '' <'' + tblUser.Email + ''>'') as ReplyTo
,CASE when exists (SELECT Value FROM  tblAppConfig WHERE (Name = ''SEND_AUTO_EMAILS'') AND (UPPER(Value) = ''YES'')) then 0 ELSE 1 END as StopEmails
,CAST(convert( varchar(11), dbo.udfUTCtoDaylightSavingTime(DATEADD(d,1,GETUTCDATE()),@OrgID),113) AS DateTime) as Tomorrow
,CASE when tblUser.usertypeid=4 then dbo.udfUser_GetAdministratorsEmailAddress (tblUser.UserID) else tblUser.Email end as SenderEmail
,IsPeriodic
FROM
tblReportinterface
inner join tblReportSchedule RS  on tblReportinterface.ReportID = RS.ReportID
INNER JOIN tblUser ON RS.UserID = tblUser.UserID
LEFT OUTER JOIN tblLang ON tblLang.LangCode = RS.ParamLangCode
LEFT OUTER JOIN tblLangInterface ON  paramlanginterfacename = tblLangInterface.langinterfacename
LEFT OUTER JOIN tblLangResource ON  tblLangResource.langresourcename = ''rptreporttitle''
LEFT OUTER JOIN tblLangValue ON tblLang.LangID = tblLangValue.LangID   AND (tblLangValue.Active = 1) and tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID and tblLangValue.LangResourceID = tblLangResource.LangResourceID

WHERE ScheduleID = @ScheduleID


-- remove spent "NOW" Schedule to reduce size of table
DELETE FROM tblReportSchedule
WHERE ScheduleID = @ScheduleID

END
' 
END



GO


 