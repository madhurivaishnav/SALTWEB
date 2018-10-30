SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_AtRisk]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/******************************************************************************
**		File:
**		Name: prcReport_AtRisk
**		Desc: Returns a list of users who have failed a quiz the specified
**				of times.
**
**		Auth: Mark Donald
**		Date: 23 Dec 2009
**
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**      09/06/2011	j hedlefs			timezone
*******************************************************************************/


CREATE       Procedure [dbo].[prcReport_AtRisk]
(
@organisationID int,
@unitIDs varchar(max),
@courseIDs varchar(8000),
@failCounter int,
@dateFrom datetime,
@dateTo datetime,
@classificationID int
)
AS
SET NOCOUNT ON

DECLARE @Units TABLE (UnitID INT PRIMARY KEY(UnitID))
DECLARE @Courses TABLE (CourseID INT PRIMARY KEY(CourseID))
DECLARE @Users TABLE(UserID INT , UnitID INT PRIMARY KEY(UserID, UnitID))

INSERT INTO @Courses SELECT * FROM dbo.udfCsvToInt(@courseIDs)
INSERT INTO @Units SELECT * FROM  dbo.udfCsvToInt(@unitIDs)

--Get All the users for all specfied units, matching Custom Classification option (if provided)
INSERT INTO @Users
SELECT
DISTINCT A.UserID, A.UnitiD
FROM
tblUser A
JOIN @Units B ON A.UnitID = B.UnitID
JOIN tblUnit C ON B.UnitID = C.UnitID AND C.Active = 1
LEFT JOIN tblUserClassification uc ON uc.UserID  = A.UserID
WHERE
A.Active = 1
AND ((@classificationID =0) OR (classificationID = @classificationID))
--If classification is Any (0), This will find users of any Custom Classification

BEGIN
SELECT
s.userid, s.moduleid, hierarchyname as unitpathway, lastname, firstname, externalid, email, username, c.[name] as coursename, m.[name] as modulename, failnumber, [status] as currentstatus
FROM
(SELECT
q.userid, moduleid,
sum(CASE quizstatusid WHEN 3 THEN 1 ELSE 0 END) AS failnumber,
max(userquizstatusid) AS currentstatusid
FROM
tbluserquizstatus q, tbluser u
WHERE
q.userid = u.userid
AND organisationid = @organisationID
AND q.datecreated BETWEEN dbo.udfDaylightSavingTimeToUTC(@dateFrom,@OrganisationID) AND dateadd(dd, 1, dbo.udfDaylightSavingTimeToUTC(@dateTo,@OrganisationID))
GROUP BY
q.userid, moduleid
HAVING
sum(CASE quizstatusid WHEN 3 THEN 1 ELSE 0 END) >= @failCounter) s
LEFT JOIN tblusermoduleaccess a ON
a.userid = s.userid AND a.moduleid = s.moduleid
JOIN tbluser u ON
u.userid = s.userid
LEFT JOIN tblunitmoduleaccess n ON
n.unitid = u.unitid AND s.moduleid = deniedmoduleid,
tbluserquizstatus uq,
@Users x,
@Courses w,
tblmodule m,
tblcourse c,
tblquizstatus q,
tblunithierarchy h
WHERE
(
(deniedmoduleid IS NULL AND a.moduleid IS NULL)
OR a.granted = 1
)
AND uq.userquizstatusid = s.currentstatusid
AND x.userid = s.userid
AND m.moduleid = s.moduleid
AND c.courseid = m.courseid
AND w.courseid = m.courseid
AND q.quizstatusid = uq.quizstatusid
AND h.unitid = u.unitid
ORDER BY
unitpathway, lastname, firstname
END

' 
END
GO
