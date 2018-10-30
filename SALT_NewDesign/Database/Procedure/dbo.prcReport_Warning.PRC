SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_Warning]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/******************************************************************************
**		Name: prcReport_Warning
**
**		Called by:
**
**		Auth: Mark Donald
**		Date: 7 Dec 2009
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**
*******************************************************************************/


CREATE PROCEDURE [dbo].[prcReport_Warning]
(
@organisationID int,
@unitIDs varchar(max),
@courseIDs varchar(8000),
@classificationID int,
@warningPeriod int,
@warningUnit varchar(2),
@IncludeInactive int
)
AS
SET NOCOUNT ON;

DECLARE @Units TABLE (UnitID INT PRIMARY KEY(UnitID))
DECLARE @Courses TABLE(CourseID INT PRIMARY KEY(CourseID))
DECLARE @CoursesWithAccess 	TABLE (CourseID INT PRIMARY KEY(CourseID))
DECLARE @Users TABLE(UserID INT , UnitID INT PRIMARY KEY(UserID, UnitID))
DECLARE @tblCurrentAssignedModules TABLE (
CourseID int,
UserID int,
UnitID int,
ModuleID int,
QuizFrequency int,
QuizCompletionDate datetime
)
DECLARE @tblStartedModules TABLE (
UserID int,
ModuleID int,
DateTimeCompleted datetime
)

INSERT INTO
@Courses
SELECT
*
FROM
dbo.udfCsvToInt(@courseIDs)

INSERT INTO
@Units
SELECT
*
FROM
dbo.udfCsvToInt(@unitIDs)

-- Get users for specfied units, matching Custom Classification option (if provided)
INSERT INTO @Users
SELECT
DISTINCT A.UserID, A.UnitiD
FROM
tblUser A
JOIN @Units B on A.UnitID = B.UnitID
JOIN tblUnit C on B.UnitID = C.UnitID AND C.Active = 1
LEFT JOIN tblUserClassification uc ON uc.UserID  = A.UserID
WHERE
A.Active = (case when @includeinactive = 0 then 1 else A.active end )
AND ((@classificationID =0) OR (classificationID = @classificationID))
--If classification is Any (0), This will find users of any Custom Classification

-- Get compliance rules for in-scope modules
INSERT INTO @tblCurrentAssignedModules
SELECT
CourseID, UserID, um.UnitID, um.ModuleID, QuizFrequency, QuizCompletionDate
FROM
(SELECT
tU.UserID, tU.UnitID, tM.ModuleID
FROM
dbo.tblUser tU
INNER JOIN dbo.tblOrganisationCourseAccess tOCA ON tOCA.OrganisationID = tU.OrganisationID
INNER JOIN dbo.tblCourse tC ON tC.CourseID = tOCA.GrantedCourseID
INNER JOIN dbo.tblModule tM ON tM.CourseID = tC.CourseID AND tM.Active = 1
LEFT OUTER JOIN dbo.tblUserModuleAccess tUsrMA ON tUsrMA.UserID = tU.UserID
AND tUsrMA.ModuleID = tM.ModuleID
LEFT OUTER JOIN dbo.tblUnitModuleAccess tUnitMA ON tUnitMA.UnitID = tU.UnitID
AND tUnitMA.DeniedModuleID = tM.ModuleID
WHERE
tU.OrganisationID = @organisationID
AND	tU.Active = (case when @includeinactive = 0 then 1 else tU.Active end )
AND tu.UnitID IS NOT NULL
AND dbo.udfUserCourseComplete(tu.userid, tm.courseid) = 1
AND ((tUnitMA.DeniedModuleID IS NULL AND tUsrMA.ModuleID IS NULL)
OR tUsrMA.Granted=1)
) um
INNER JOIN (
SELECT
u.UnitID, m.CourseID, m.ModuleID,
CASE
WHEN (
ur.QuizFrequency IS NULL
AND ur.QuizCompletionDate IS NULL
AND o.DefaultQuizCompletionDate IS NULL
) THEN
o.DefaultQuizFrequency
ELSE
ur.QuizFrequency
END AS QuizFrequency,
CASE
WHEN (
ur.QuizFrequency IS NULL
AND ur.QuizCompletionDate IS NULL
AND o.DefaultQuizCompletionDate IS NOT NULL
) THEN
o.DefaultQuizCompletionDate
ELSE
ur.QuizCompletionDate
END AS QuizCompletionDate
FROM
tblOrganisationCourseAccess c
INNER JOIN tblModule m ON m.CourseID = c.GrantedCourseID
INNER JOIN tblOrganisation o ON o.OrganisationID = c.OrganisationID -- default compliance rules
INNER JOIN tblUnit u ON u.OrganisationID = c.OrganisationID
LEFT JOIN tblUnitRule ur ON ur.ModuleID = m.ModuleID AND ur.UnitID = u.unitID -- unit specific rules
WHERE o.OrganisationID = @organisationID
) umr ON umr.ModuleID  = um.ModuleID
AND umr.UnitID = um.UnitID
AND um.UnitID IN (SELECT DISTINCT UnitID FROM @users)
AND um.UserID IN (SELECT DISTINCT UserID FROM @users)
AND umr.CourseID IN (SELECT CourseID FROM @courses)

-- Get module completion details
INSERT INTO @tblStartedModules
SELECT
um.userID, um.moduleID, qs.DateTimeCompleted
FROM
@tblCurrentAssignedModules um
INNER JOIN (
SELECT
um.userID, um.moduleID, max(DateTimeCompleted) AS DateTimeCompleted
FROM
@tblCurrentAssignedModules um
INNER JOIN tblQuiz q ON q.ModuleID = um.ModuleID
INNER JOIN tblQuizSession qs ON qs.QuizID= q.quizID
AND qs.userID = um.userID
AND qs.DateTimeCompleted IS NOT NULL
GROUP BY
um.userID, um.moduleID
) AS LastQuizDate ON
LastQuizDate.userID = um.userID
AND LastQuizDate.ModuleID = um.ModuleID
INNER JOIN tblQuiz q ON q.ModuleID = um.ModuleID
INNER JOIN tblQuizSession qs ON
qs.QuizID= q.quizID
AND qs.userID = um.userID
AND qs.DateTimeCompleted = LastQuizDate.DateTimeCompleted

-- User/course combos where the courses are about to be marked incomplete due to module expiry
BEGIN
SELECT
c.[name] as CourseName,
HierarchyName AS UnitPathway,
LastName,
FirstName,
case when u.Active = 1 then ''''  else ''(i)'' end as Flag,
ExternalID,
Email,
UserName,
dbo.udfUTCtoDaylightSavingTime(max(DateTimeCompleted), @organisationID) AS CompletionDate,
dbo.udfUTCtoDaylightSavingTime(min(isnull(QuizCompletionDate, dateadd(month, QuizFrequency, DateTimeCompleted))), @organisationID) AS ExpiryDate
FROM
@tblCurrentAssignedModules cam
INNER JOIN @tblStartedModules sm ON sm.UserID = cam.UserID AND sm.ModuleID = cam.ModuleID,
tblCourse c,
tblUser u,
tblUnitHierarchy h
WHERE
c.CourseID = cam.CourseID
AND u.UserID = cam.UserID
AND h.UnitID = cam.UnitID
GROUP BY
c.[name], HierarchyName,  LastName, FirstName, ExternalID, Email, Username, u.Active
HAVING
min(isnull(
QuizCompletionDate,
dateadd(month, QuizFrequency, DateTimeCompleted)
)) < CASE @warningUnit
WHEN ''mm'' THEN
dateadd(mm, @warningPeriod, getutcdate())
ELSE
dateadd(dd, @warningPeriod, getutcdate())
END
ORDER BY
CourseName, UnitPathway, LastName, FirstName
END

' 
END
GO
