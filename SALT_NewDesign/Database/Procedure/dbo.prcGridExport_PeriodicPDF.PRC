SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcGridExport_PeriodicPDF]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcGridExport_PeriodicPDF]

	@Param1 NVarChar(4000),
	@Param2 NVarChar(4000),
	@Param3 NVarChar(4000),
	@CurrentCultureName NVarChar(4000)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @OrgID int
	Declare @UserID int
	DECLARE @Sort NVarChar(4000)
	SET @OrgID = @Param1
	SET @UserID = @Param2
	SET @Sort = @Param3
	DECLARE @SQL NVarChar(4000)
	DECLARE @LangID NVarChar(4000)
		SELECT @LangID = LangID FROM tblLang where tblLang.LangCode =   @CurrentCultureName 
		IF @LangID IS NULL 
		BEGIN
			SET @LangID = 2
		END

	--DECLARE @CCList TABLE(ScheduleId int, CC int)
	--INSERT INTO @CCList(ScheduleId, CC) 
	--	(SELECT ccl.ScheduleId, Count(UserId) as CC FROM tblCCList ccl
	--		GROUP BY ccl.ScheduleId
	--		HAVING ccl.ScheduleId In 
	--			(SELECT rs.ScheduleId FROM tblReportSchedule rs
	--			INNER JOIN dbo.tblUser u ON u.UserID = rs.UserID WHERE ParamOrganisationID = @OrgID))

	 SET @SQL = 
	 --N''SELECT   ''''Report Title'''', ''''Report Type'''',''''Report Interval'''',''''Date Created'''',''''Report Starts On'''',''''Report Ends On'''',''''Next Run'''',''''Report Owner'''',''''Administration Level'''',''''Report Delivered To;'''',''''Unique ID''''    UNION ALL ''+
N''SELECT rs.ReportTitle,
ri.ReportName, 
CAST(rs.ReportFrequency AS varchar(5))+'''' ''''+
CASE 
WHEN (rs.ReportFrequencyPeriod = ''''D'''') THEN 
(SELECT LangEntryValue
FROM tblLangValue
where LangID = ''+@LangID+''and LangInterfaceID = 
	(SELECT LangInterfaceID
	FROM tblLangInterface
	where LangInterfaceName = ''''/Reporting/PeriodicReport.aspx''''  )
and LangResourceID = 
	(SELECT LangResourceID
	FROM tblLangResource
	where LangResourceName = ''''optPeriodType.1''''))
WHEN (rs.ReportFrequencyPeriod = ''''W'''') THEN 
(SELECT LangEntryValue
FROM tblLangValue
where LangID = ''+@LangID+''
and LangInterfaceID = 
	(SELECT LangInterfaceID
	FROM tblLangInterface
	where LangInterfaceName = ''''/Reporting/PeriodicReport.aspx''''  )
and LangResourceID = 
	(SELECT LangResourceID
	FROM tblLangResource
	where LangResourceName = ''''optPeriodType.2''''))
WHEN (rs.ReportFrequencyPeriod = ''''M'''') THEN 
(SELECT LangEntryValue
FROM tblLangValue
where LangID = ''+@LangID+''
and LangInterfaceID = 
	(SELECT LangInterfaceID
	FROM tblLangInterface
	where LangInterfaceName = ''''/Reporting/PeriodicReport.aspx''''  )
and LangResourceID = 
	(SELECT LangResourceID
	FROM tblLangResource
	where LangResourceName = ''''optPeriodType.3''''))
ELSE 
(SELECT LangEntryValue
FROM tblLangValue
where LangID = ''+@LangID+''
and LangInterfaceID = 
	(SELECT LangInterfaceID
	FROM tblLangInterface
	where LangInterfaceName = ''''/Reporting/PeriodicReport.aspx''''  )
and LangResourceID = 
	(SELECT LangResourceID
	FROM tblLangResource
	where LangResourceName = ''''optPeriodType.3''''))
END AS ReportInterval, 
convert(varchar (11),dbo.udfUTCtoDaylightSavingTime(rs.DateCreated,rs.ParamOrganisationID),113) as DateCreated , 
convert(varchar (11),rs.ReportStartDate,113) as StartDate ,  
CASE WHEN rs.ReportEndDate IS NULL THEN ''''--'''' ELSE  convert(varchar (11),rs.ReportEndDate,113)  END as EndDate, 
CASE WHEN rs.NextRun > rs.ReportEndDate THEN ''''--''''
		 WHEN rs.NextRun = cast(''''01 jan 2050'''' as datetime) THEN ''''--''''
		 ELSE convert(varchar(11), rs.NextRun, 113) END
		 as NextRun, 
(u.FirstName + '''' '''' + u.LastName) as Username,
CASE WHEN u.UserTypeID = 1 THEN ''''APP ADMIN''''
WHEN u.UserTypeID = 2 THEN (SELECT LangEntryValue
FROM tblLangValue
where LangID = ''+@LangID+''
and LangInterfaceID = 
	(SELECT LangInterfaceID
	FROM tblLangInterface
	where LangInterfaceName = ''''GLOBAL.UserControls.AdminMenu.ascx''''  )
and LangResourceID = 
	(SELECT LangResourceID
	FROM tblLangResource
	where LangResourceName = ''''lblAdminMenuOrganisation''''))
WHEN u.UserTypeID = 3 THEN (SELECT LangEntryValue
FROM tblLangValue
where LangID = ''+@LangID+''
and LangInterfaceID = 
	(SELECT LangInterfaceID
	FROM tblLangInterface
	where LangInterfaceName = ''''GLOBAL.UserControls.AdminMenu.ascx''''  )
and LangResourceID = 
	(SELECT LangResourceID
	FROM tblLangResource
	where LangResourceName = ''''lblAdminMenuUnit'''')) 
ELSE  (SELECT LangEntryValue
FROM tblLangValue
where LangID = ''+@LangID+''
and LangInterfaceID = 
	(SELECT LangInterfaceID
	FROM tblLangInterface
	where LangInterfaceName = ''''GLOBAL.UserControls.AdminMenu.ascx''''  )
and LangResourceID = 
	(SELECT LangResourceID
	FROM tblLangResource
	where LangResourceName = ''''lblAdminMenuUser'''')) 
END as AdministrationLevel,
CASE WHEN ((SELECT count(*) FROM tblCCList WHERE tblCCList.ScheduleID = rs.ScheduleID) > 0) THEN (Convert(varchar, (SELECT 1+count(*) FROM tblCCList WHERE tblCCList.ScheduleID = rs.ScheduleID)) + '''' Recepients'''') ELSE u.Email  END as DeliveredTo,
rs.ScheduleID as UniqueID
FROM dbo.tblReportSchedule rs JOIN dbo.tblReportInterface ri ON rs.ReportID = ri.ReportID		inner JOIN dbo.tblUser u ON u.UserID = rs.UserID		inner JOIN dbo.tblUserType ut ON u.UserTypeID = ut.UserTypeID				WHERE rs.ParamOrganisationID = ''+@Param1+'' AND rs.IsPeriodic != ''''N''''		ORDER BY ''+ @Sort

	EXEC dbo.sp_executesql @SQL

END
' 
END
GO


