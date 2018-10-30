SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_ActiveInactive]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [prcReport_ActiveInactive]
(
@FromDate	datetime,
@ToDate		datetime,
@CourseIDs	varchar(max),
@OrganisationID int,
@IncludeInactive int
)
AS

/******************************************************************************
**		File:
**		Name: dbo.prcReport_ActiveInactive
**		Desc:
**
**		This template can be customized:
**
**		Return values:
**
**		Called by:   Active INactive Users Report
**
**		Parameters:
**		Input							Output
**     ----------							-----------
**		Comma separated course id''s
**
**		Auth: Serguei Chkaroupine
**		Date: 5/01/2006
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		23/03/07	Yoppy Suwanto			Added a new colum Unit Pathway and sorted by it
**		21/07/09	Mark Donald				Order by LastName, FirstName
**		24/03/11	John Hedlefs			Timezone conversions
*******************************************************************************/

BEGIN

SELECT distinct
tblUnitHierarchy.HierarchyName as UnitPathway,
uma.[UserID],
uma.[LastName],
uma.[FirstName],
CASE
WHEN tblUser.Active <> 1 THEN ''(i)''
ELSE ''''
END as Flag
,tblUser.[ExternalID]
,tblUser.[Email]
,tblUser.[UserName]
,[CourseName]
-- used to count inactive users (RS does not counts nulls)
,CASE
WHEN Active = 0 THEN 1
ELSE NULL
END as Active,
dbo.udfUTCtoDaylightSavingTime(tblUser.DateCreated,@OrganisationID) as ''DateCreated'',
dbo.udfUTCtoDaylightSavingTime(case when Active = 0 then coalesce(tblUser.DAteArchived,tblUser.DateUpdated) end,@OrganisationID) as ''DateArchived''
FROM
-- derived table UserModuleAccess
(SELECT
tU.UserID,
tU.FirstName,
tU.LastName,
tU.UnitID,
tU.OrganisationID,
tM.ModuleID,
tM.CourseID,
tC.Name AS CourseName

FROM
dbo.tblUser AS tU INNER JOIN
dbo.tblOrganisationCourseAccess AS tOCA ON tOCA.OrganisationID = tU.OrganisationID INNER JOIN
dbo.tblCourse AS tC ON tC.CourseID = tOCA.GrantedCourseID INNER JOIN
dbo.tblModule AS tM ON tM.CourseID = tC.CourseID AND tM.Active = 1 LEFT OUTER JOIN
dbo.tblUserModuleAccess AS tUsrMA ON tUsrMA.UserID = tU.UserID AND tUsrMA.ModuleID = tM.ModuleID LEFT OUTER JOIN
dbo.tblUnitModuleAccess AS tUnitMA ON tUnitMA.UnitID = tU.UnitID AND tUnitMA.DeniedModuleID = tM.ModuleID

WHERE
(tU.UnitID IS NOT NULL) AND
(tUnitMA.DeniedModuleID IS NULL) AND
(tUsrMA.ModuleID IS NULL) OR
(tUsrMA.Granted = 1)
)
as uma -- end derived table UserModuleAccess
LEFT JOIN tblUser on uma.UserID = tblUser.UserID
LEFT JOIN tblUnitHierarchy on tblUnitHierarchy.UnitID = tblUser.UnitID

WHERE
uma.OrganisationID = @OrganisationID
AND CourseID in (SELECT * FROM dbo.udfCsvToInt(@CourseIDs))
AND tblUser.DateCreated between dbo.udfDaylightSavingTimeToUTC(@FromDate,@OrganisationID) and dbo.udfDaylightSavingTimeToUTC(@ToDate,@OrganisationID)
and tblUser.Active = (case when @includeinactive =0 then 1 else tbluser.active end )

ORDER BY
UnitPathway,
uma.[LastName],
uma.[FirstName]

--Order By CourseName


END
' 
END
GO
