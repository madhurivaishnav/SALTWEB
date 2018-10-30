SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcGridExport_PeriodicRS]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcGridExport_PeriodicRS]

	@Param1 NVarChar(4000),
	@Param2 NVarChar(4000),
	@Param3 NVarChar(4000),
	@CurrentCultureName NVarChar(4000),
	@Expanded bit
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @OrgID int
	Declare @UserID int
	DECLARE @Sort NVarChar(4000)
	SET @OrgID=@Param1
	SET @UserID=@Param2
	SET @Sort=@Param3
	DECLARE @SQL NVarChar(4000)
	DECLARE @LangID NVarChar(4000)
		SELECT @LangID=LangID FROM tblLang where tblLang.LangCode=  @CurrentCultureName 
		IF @LangID IS NULL 
		BEGIN
			SET @LangID=2
		END

IF (@Expanded = 1)
BEGIN

	 SET @SQL=
	 --N''SELECT   ''''Report Title'''', ''''Report Type'''',''''Report Interval'''',''''Date Created'''',''''Report Starts On'''',''''Report Ends On'''',''''Next Run'''',''''Report Owner'''',''''Administration Level'''',''''Report Delivered To;'''',''''Unique ID''''    UNION ALL ''+
N''SELECT rs.ReportTitle as C1,
ri.ReportName as C2,
CAST(rs.ReportFrequency AS varchar(5))+'''' ''''+
CASE
WHEN (rs.ReportFrequencyPeriod=''''D'''') THEN
(SELECT LangEntryValue
FROM tblLangValue
where LangID=''+@LangID+''and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=''''/Reporting/PeriodicReport.aspx'''')
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''''optPeriodType.1''''))
WHEN (rs.ReportFrequencyPeriod=''''W'''') THEN
(SELECT LangEntryValue
FROM tblLangValue
where LangID=''+@LangID+''
and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=''''/Reporting/PeriodicReport.aspx'''')
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''''optPeriodType.2''''))
WHEN (rs.ReportFrequencyPeriod=''''M'''') THEN 
(SELECT LangEntryValue
FROM tblLangValue
where LangID=''+@LangID+''
and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=''''/Reporting/PeriodicReport.aspx'''')
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''''optPeriodType.3''''))
ELSE
(SELECT LangEntryValue
FROM tblLangValue
where LangID=''+@LangID+''
and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=''''/Reporting/PeriodicReport.aspx'''')
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''''optPeriodType.3''''))
END AS C3, 
convert(varchar (11),dbo.udfUTCtoDaylightSavingTime(rs.DateCreated,rs.ParamOrganisationID),113) as C4 , 
convert(varchar (11),rs.ReportStartDate,113) as C5 ,  
CASE WHEN rs.ReportEndDate IS NULL THEN ''''--'''' ELSE  convert(varchar (11),rs.ReportEndDate,113)  END as C6, 
CASE WHEN rs.NextRun > rs.ReportEndDate THEN ''''--''''
		 WHEN rs.NextRun = cast(''''1 jan 2050'''' as datetime) THEN ''''--''''
		 ELSE convert(varchar(11), rs.NextRun, 113) END
		 as C7,
(u.FirstName + '''' '''' + u.LastName) as C8,
CASE WHEN u.UserTypeID=1 THEN ''''APP ADMIN''''
WHEN u.UserTypeID=2 THEN (SELECT LangEntryValue
FROM tblLangValue
where LangID=''+@LangID+''
and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=''''GLOBAL.UserControls.AdminMenu.ascx'''')
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''''lblAdminMenuOrganisation''''))
WHEN u.UserTypeID=3 THEN (SELECT LangEntryValue
FROM tblLangValue
where LangID=''+@LangID+''
and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=''''GLOBAL.UserControls.AdminMenu.ascx'''')
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''''lblAdminMenuUnit''''))
ELSE  (SELECT LangEntryValue
FROM tblLangValue
where LangID=''+@LangID+''
and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=''''GLOBAL.UserControls.AdminMenu.ascx'''')
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''''lblAdminMenuUser''''))
END as C9,
ccu.Email as C10,
rs.ScheduleID as C11
FROM dbo.tblReportSchedule rs JOIN dbo.tblReportInterface ri ON rs.ReportID=ri.ReportID
INNER JOIN dbo.tblUser u ON u.UserID=rs.UserID
INNER JOIN dbo.tblUserType ut ON u.UserTypeID=ut.UserTypeID
INNER JOIN (SELECT ScheduleId,UserID FROM tblCCList UNION ALL SELECT ScheduleId,UserID FROM tblReportSchedule) as cc ON  cc.ScheduleId=rs.ScheduleId
INNER JOIN tblUser ccu ON cc.UserID=ccu.UserID
WHERE rs.ParamOrganisationID=''+@Param1+'' AND rs.IsPeriodic !=''''N''''	ORDER BY ''+ @Sort
END
ELSE
BEGIN
	 SET @SQL = 
	 --N''SELECT   ''''Report Title'''', ''''Report Type'''',''''Report Interval'''',''''Date Created'''',''''Report Starts On'''',''''Report Ends On'''',''''Next Run'''',''''Report Owner'''',''''Administration Level'''',''''Report Delivered To;'''',''''Unique ID''''    UNION ALL ''+
N''SELECT rs.ReportTitle as C1,
ri.ReportName as C2, 
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
END AS C3, 
convert(varchar (11),dbo.udfUTCtoDaylightSavingTime(rs.DateCreated,rs.ParamOrganisationID),113) as C4, 
convert(varchar (11),rs.ReportStartDate,113) as C5,
CASE WHEN rs.ReportEndDate IS NULL THEN ''''--'''' ELSE  convert(varchar (11),rs.ReportEndDate,113)  END as C6,
CASE WHEN rs.NextRun > rs.ReportEndDate THEN ''''--''''
		 WHEN rs.NextRun = cast(''''1 jan 2050'''' as datetime) THEN ''''--''''
		 ELSE convert(varchar(11), rs.NextRun, 113) END
		 as C7,
(u.FirstName + '''' '''' + u.LastName) as C8,
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
END as C9,
CASE WHEN ((SELECT count(*) FROM tblCCList WHERE tblCCList.ScheduleID = rs.ScheduleID) > 0) THEN (Convert(varchar, (SELECT 1+count(*) FROM tblCCList WHERE tblCCList.ScheduleID = rs.ScheduleID)) + '''' Recepients'''') ELSE u.Email  END as C10,
rs.ScheduleID as C11
FROM dbo.tblReportSchedule rs JOIN dbo.tblReportInterface ri ON rs.ReportID = ri.ReportID		inner JOIN dbo.tblUser u ON u.UserID = rs.UserID		inner JOIN dbo.tblUserType ut ON u.UserTypeID = ut.UserTypeID				WHERE rs.ParamOrganisationID = ''+@Param1+'' AND rs.IsPeriodic != ''''N''''		ORDER BY ''+ @Sort
END

	EXEC dbo.sp_executesql @SQL

END
' 
END
GO


