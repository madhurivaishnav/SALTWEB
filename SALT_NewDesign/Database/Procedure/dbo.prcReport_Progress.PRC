SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_Progress]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/******************************************************************************
**		Name: prcReport_Progress
**
**		Called by:
**
**		Auth: Mark Donald
**		Date: 11 Jan 2010
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**
*******************************************************************************/


CREATE PROCEDURE [dbo].[prcReport_Progress]
(
@organisationID int,
@unitIDs varchar(max),
@courseIDs varchar(8000),
@includeInactive int,
@classificationID int
)
AS
SET NOCOUNT ON;
BEGIN
DECLARE @currentstatus TABLE (usercoursestatusid int)
INSERT INTO @currentstatus
SELECT
max(usercoursestatusid) usercoursestatusid
FROM
tblusercoursestatus
GROUP BY
userid, courseid

SELECT
hierarchyname ''unitpathway'', lastname, firstname, CASE u.active WHEN 1 THEN NULL ELSE ''(i)'' END flag,
c.name coursename, externalid, email, username, [status] currentstatus, previousstatus, (
SELECT
convert(varchar(10), dbo.udfUTCtoDaylightSavingTime(max(datecreated),@OrganisationID), 103)
FROM
tblusercoursestatus
WHERE
userid = s.userid
AND courseid = s.courseid
AND coursestatusid = 2
) AS lastcompletiondate
FROM
tblusercoursestatus s
INNER JOIN tblcourse c ON
c.courseid = s.courseid
AND c.courseid IN (SELECT IntValue FROM dbo.udfCsvToInt(@courseIDs))
INNER JOIN tbluser u ON
u.userid = s.userid
AND u.unitid IN (SELECT IntValue FROM dbo.udfCsvToInt(@unitIDs))
LEFT JOIN (
SELECT
userid, courseid, max(usercoursestatusid) usercoursestatusid -- 2nd most recent record
FROM
tblusercoursestatus
WHERE
usercoursestatusid NOT IN (SELECT usercoursestatusid FROM @currentstatus)
GROUP BY
userid, courseid
) AS p ON
s.userid = p.userid
AND s.courseid = p.courseid
LEFT JOIN (
SELECT
usercoursestatusid, v.coursestatusid, [status] previousstatus
FROM
tblusercoursestatus v
INNER JOIN tblcoursestatus z ON
v.coursestatusid = z.coursestatusid
WHERE
z.coursestatusid > 0
) AS def2 ON
def2.usercoursestatusid = p.usercoursestatusid
LEFT JOIN tbluserclassification g ON
g.userid = u.userid,
tblunithierarchy h,
tblcoursestatus def,
@currentstatus r
WHERE
h.unitid = u.unitid
AND def.coursestatusid = s.coursestatusid
AND s.usercoursestatusid = r.usercoursestatusid
AND u.organisationid = @organisationID
AND (@includeInactive = 1 OR u.active = 1)
AND (@classificationID = 0 OR classificationID = @classificationID)
ORDER BY
unitpathway, lastname, firstname, coursename
END
' 
END
GO
