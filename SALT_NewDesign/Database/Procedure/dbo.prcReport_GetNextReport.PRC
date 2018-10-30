SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_GetNextReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [prcReport_GetNextReport]

AS
BEGIN
	-- NextRun is saved in the ORGs timezone so that when an ORG goes into daylight saving the Report is run at the correct time.
	-- ALL other times are saved in the ORGs timezone to reduce load on the GUI when the ORGs timezone is changed
	
	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET TerminatedNormally = 1
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		WHERE (TerminatedNormally = 0)
		AND (IsPeriodic = ''M'')
		AND ReportEndDate IS NULL -- flag to indicate that NumberOfReports is being used
		AND NumberOfReports IS NOT NULL
		AND NumberDelivered >= NumberOfReports 
	)
	
	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET TerminatedNormally = 0
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		WHERE (TerminatedNormally = 1)
		AND (IsPeriodic = ''M'')
		AND ReportEndDate IS NULL -- flag to indicate that NumberOfReports is being used
		AND NumberOfReports IS NOT NULL
		AND NumberDelivered < NumberOfReports 
	)
	


	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET 
	LastRun = ''1 Jan 1997'',
	NextRun = dbo.udfReportSchedule_CalcNextRunDate 
	(
		ReportStartDate, 
		ReportStartDate , 
		ReportFrequencyPeriod , 
		ReportFrequency , 
		ParamOrganisationID 	
	)
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		INNER JOIN tblUser ON tblReportSchedule.UserID = tblUser.UserID
		WHERE (TerminatedNormally = 0)
		AND (IsPeriodic != ''N'')
		AND (tblUser.Active = 1)
		AND LASTRUN IS NULL
		AND NEXTRUN IS NULL
	)

	
	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET LastRun = ''1 Jan 2001''
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		INNER JOIN tblUser ON tblReportSchedule.UserID = tblUser.UserID
		WHERE (TerminatedNormally = 0)
		AND (IsPeriodic != ''N'')
		AND (tblUser.Active = 1)
		AND LASTRUN IS NULL
	)
	
		
	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET NextRun = dbo.udfReportSchedule_CalcNextRunDate 
	(
		LastRun , 
		ReportStartDate , 
		ReportFrequencyPeriod , 
		ReportFrequency , 
		ParamOrganisationID 	
	)
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		INNER JOIN tblUser ON tblReportSchedule.UserID = tblUser.UserID
		--WHERE (TerminatedNormally = 0)
		AND (IsPeriodic != ''N'')
		AND (tblUser.Active = 1)
		AND NEXTRUN IS NULL
	)
	
	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET TerminatedNormally = 1
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		WHERE (TerminatedNormally = 0)
		AND (IsPeriodic = ''M'')
		AND ReportEndDate IS NOT NULL
		AND NextRun > ReportEndDate
		AND NumberOfReports IS NULL
	)
	
	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET TerminatedNormally = 0
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		WHERE (TerminatedNormally = 1)
		AND (IsPeriodic = ''M'')
		AND ReportEndDate IS NOT NULL
		AND NextRun <= ReportEndDate
		AND NumberOfReports IS NULL
	)	
		
	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET TerminatedNormally = 0
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		WHERE (TerminatedNormally = 1)
		AND (IsPeriodic = ''M'')
		AND ReportEndDate IS NULL 
		AND NumberOfReports IS  NULL
	)
	
	
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
	@ReportID int

	SELECT @ScheduleID =  ScheduleID
	FROM tblReportSchedule
	INNER JOIN tblReportInterface ON tblReportSchedule.ReportID = tblReportInterface.ReportID
	INNER JOIN tblUser ON tblReportSchedule.UserID = tblUser.UserID AND tblUser.Active = 1
	INNER JOIN tblOrganisation ON tblOrganisation.OrganisationID = tblReportSchedule.ParamOrganisationID
	WHERE  CourseStatusLastUpdated > dbo.udfGetSaltOrgMidnight(tblUser.OrganisationID)
	AND (NextRun <= dbo.udfUTCtoDaylightSavingTime(GETUTCDATE(),tblReportSchedule.ParamOrganisationID))
	AND (TerminatedNormally = 0)
	AND (IsPeriodic = ''M'')


	DECLARE @OnBehalfOf nvarchar(255)
	DECLARE @ReplyTo nvarchar(255)
	DECLARE @FromDate DateTime = CAST(''1 Jan 1997'' as datetime)
	DECLARE @DateFrom DateTime

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

		SET @RunDate = dbo.udfReportSchedule_CalcNextRunDate -- may have missed a couple of reports if the server was down so just verify that NEXTRUN makes sense
		(
			@NextRun,  
			@ReportStartDate , 
			@ReportFrequencyPeriod,  
			@ReportFrequency, 
			@OrgID
		)

		SET @NextRun = dbo.udfReportSchedule_IncrementNextRunDate -- get the new NexrRun value
		(
			@RunDate , 
			@ReportStartDate , 
			@ReportFrequencyPeriod , 
			@ReportFrequency , 
			@OrgID 	
		)
		-- now look for termination conditions
		DECLARE @TerminatedNormally bit = 0

		IF  @ReportEndDate IS NOT NULL AND (@ReportEndDate < @NextRun) BEGIN SET @TerminatedNormally = 1  END
		IF @NumberOfReports IS NOT NULL AND (@NumberOfReports < (@NumberDelivered + 1)) BEGIN SET @TerminatedNormally = 1  END
		
		-- update the Report Schedule
		UPDATE tblReportSchedule -- Move NextRun,Lastrun forward by one period
		SET NumberDelivered = NumberDelivered + 1,
		TerminatedNormally = @TerminatedNormally,
		LastRun = @RunDate,
		NextRun = @NextRun,
		LastUpdatedBy=0,
		Lastupdated=getUTCdate()
		WHERE ScheduleID = @ScheduleID

		-- get the Report period (we know the ''to'' date - just need to calculate the ''from'' date)

		IF ((@ReportPeriodType <> 2) AND (@ReportPeriodType <> 3))
		BEGIN
			SET @FromDate = CAST(''1 Jan 1997'' as datetime)
		END
		
		IF (@ReportPeriodType = 3) 
		BEGIN
			SELECT @FromDate = @RunDate 
		END
		
		IF (@ReportPeriodType = 2) 
		BEGIN
			SET @FromDate =
			CASE 
				WHEN (@ReportFrequencyPeriod=''Y'') THEN DATEADD(YEAR,-@ReportFrequency,@RunDate)
				WHEN (@ReportFrequencyPeriod=''M'') THEN DATEADD(MONTH,-@ReportFrequency,@RunDate)
				WHEN (@ReportFrequencyPeriod=''W'') THEN DATEADD(WEEK,-@ReportFrequency,@RunDate)
				WHEN (@ReportFrequencyPeriod=''D'') THEN DATEADD(DAY,-@ReportFrequency,@RunDate)
				WHEN (@ReportFrequencyPeriod=''H'') THEN DATEADD(HOUR,-@ReportFrequency,@RunDate)
			END	
	    END
		IF (@ReportID=10) OR (@ReportID=22) OR (@ReportID=23) OR (@ReportID=24)
		BEGIN
			SET @FromDate = @DateFrom
		END
		
	SELECT @OnBehalfOf = dbo.udfGetEmailOnBehalfOf (@OrgID)	
	END -- IF ScheduleID is not null


	-- return the results
	SET NOCOUNT OFF
	SELECT TOP (1) [ScheduleID]
	,RS.UserID
	,RS.ReportID
	,[LastRun]
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


END
' 
END
GO


