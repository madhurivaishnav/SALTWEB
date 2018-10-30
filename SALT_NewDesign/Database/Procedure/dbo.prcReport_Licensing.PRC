SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_Licensing]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [prcReport_Licensing]
(
@strCourseLicensingID varchar(8000),
@OrganisationID int
)
AS

BEGIN

IF (@strCourseLicensingID = ''0'')
BEGIN
SELECT
Header.Name as CourseName,
Header.LicenseNumber,
Header.Period,
Header.LicensesRemaining,
tblUnitHierarchy.HierarchyName as UnitPathway,
tblUser.FirstName + '' '' + tblUser.LastName AS FullName,
tblUser.ExternalID,
tblUser.Email,
dbo.udfUTCtoDaylightSavingTime(tblUser.DateCreated, @OrganisationID) as DateCreated,
tblUser.Active,
CASE
WHEN (tblUser.Active = 0 AND DateArchived IS NULL) THEN ''YES''
ELSE CONVERT(varchar, dbo.udfUTCtoDaylightSavingTime(DateArchived, @OrganisationID), 103)
END AS DateArchive,
Header.LicensesUsed
FROM tblCourseLicensingUser
INNER JOIN tblUser ON tblCourseLicensingUser.UserID = tblUser.UserID
INNER JOIN tblUnitHierarchy ON tblUser.UnitID = tblUnitHierarchy.UnitID
RIGHT JOIN tblCourseLicensing ON tblCourseLicensingUser.CourseLicensingID = tblCourseLicensing.CourseLicensingID
and tblCourseLicensing.OrganisationID = @OrganisationID
RIGHT JOIN (
SELECT	tblCourseLicensing.CourseLicensingID,
tblCourse.Name,
tblCourseLicensing.LicenseNumber,
CONVERT(varchar, dbo.udfUTCtoDaylightSavingTime(tblCourseLicensing.DateStart, @OrganisationID), 103) + '' - '' + CONVERT(varchar, dbo.udfUTCtoDaylightSavingTime(tblCourseLicensing.DateEnd, @OrganisationID), 103) AS Period,
tblCourseLicensing.LicenseNumber - coalesce(COUNT(tblCourseLicensingUser.CourseLicensingUserID),0) AS LicensesRemaining,
coalesce(COUNT(tblCourseLicensingUser.CourseLicensingUserID),0) AS LicensesUsed
FROM tblCourseLicensingUser AS tblCourseLicensingUser
RIGHT JOIN tblCourseLicensing ON  tblCourseLicensingUser.CourseLicensingID = tblCourseLicensing.CourseLicensingID
and tblCourseLicensing.OrganisationID = @OrganisationID
INNER JOIN tblCourse ON tblCourseLicensing.CourseID = tblCourse.CourseID
WHERE tblCourseLicensing.OrganisationID = @OrganisationID
GROUP BY tblCourse.Name, tblCourseLicensing.LicenseNumber, tblCourseLicensing.DateStart,
tblCourseLicensing.DateEnd, tblCourseLicensing.CourseLicensingID
HAVING      (tblCourseLicensing.DateStart < GETUTCDATE()) AND (dateadd(d,1,tblCourseLicensing.DateEnd) > GETUTCDATE())
) AS Header ON tblCourseLicensing.CourseLicensingID = Header.CourseLicensingID
order by tblUnitHierarchy.HierarchyName,Header.Name,tblUser.FirstName + '' '' + tblUser.LastName

END
ELSE
BEGIN
SELECT
Header.Name as CourseName,
Header.LicenseNumber,
Header.Period,
Header.LicensesRemaining,
tblUnitHierarchy.HierarchyName as UnitPathway,
tblUser.FirstName + '' '' + tblUser.LastName AS FullName,
tblUser.ExternalID,
tblUser.Email,
dbo.udfUTCtoDaylightSavingTime(tblUser.DateCreated, @OrganisationID) as DateCreated,
tblUser.Active,
CASE
WHEN (tblUser.Active = 0 AND DateArchived IS NULL) THEN ''YES''
ELSE CONVERT(varchar, dbo.udfUTCtoDaylightSavingTime(DateArchived, @OrganisationID), 103)
END AS DateArchive,
Header.LicensesUsed
FROM tblCourseLicensingUser
INNER JOIN tblUser ON tblCourseLicensingUser.UserID = tblUser.UserID
INNER JOIN tblUnitHierarchy ON tblUser.UnitID = tblUnitHierarchy.UnitID
RIGHT JOIN tblCourseLicensing ON tblCourseLicensingUser.CourseLicensingID = tblCourseLicensing.CourseLicensingID
and tblCourseLicensing.OrganisationID = @OrganisationID
RIGHT JOIN (
SELECT	tblCourseLicensing.CourseLicensingID,
tblCourse.Name,
tblCourseLicensing.LicenseNumber,
CONVERT(varchar, dbo.udfUTCtoDaylightSavingTime(tblCourseLicensing.DateStart, @OrganisationID), 103) + '' - '' + CONVERT(varchar, dbo.udfUTCtoDaylightSavingTime(tblCourseLicensing.DateEnd, @OrganisationID), 103) AS Period,
tblCourseLicensing.LicenseNumber - coalesce(COUNT(tblCourseLicensingUser.CourseLicensingUserID),0) AS LicensesRemaining,
coalesce(COUNT(tblCourseLicensingUser.CourseLicensingUserID),0) AS LicensesUsed
FROM tblCourseLicensingUser AS tblCourseLicensingUser
RIGHT JOIN tblCourseLicensing ON tblCourseLicensingUser.CourseLicensingID = tblCourseLicensing.CourseLicensingID
and tblCourseLicensing.OrganisationID = @OrganisationID
INNER JOIN tblCourse ON tblCourseLicensing.CourseID = tblCourse.CourseID
inner join dbo.udfCsvToInt(@strCourseLicensingID) as CourseLicensing on CourseLicensing.IntValue= tblCourseLicensing.CourseLicensingID
WHERE tblCourseLicensing.OrganisationID = @OrganisationID
GROUP BY tblCourse.Name, tblCourseLicensing.LicenseNumber, dbo.udfUTCtoDaylightSavingTime(tblCourseLicensing.DateStart, @OrganisationID),
dbo.udfUTCtoDaylightSavingTime(tblCourseLicensing.DateEnd, @OrganisationID), tblCourseLicensing.CourseLicensingID
) AS Header ON tblCourseLicensing.CourseLicensingID = Header.CourseLicensingID
order by tblUnitHierarchy.HierarchyName,Header.Name,tblUser.FirstName + '' '' + tblUser.LastName
END
END
' 
END
GO
