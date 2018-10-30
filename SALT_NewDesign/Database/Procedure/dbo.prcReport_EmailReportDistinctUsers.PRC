SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_EmailReportDistinctUsers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Used to build the CC list on step 2 of the report

Quiz Status
QuizStatusID Status
------------ --------------------------------------------------
0            Unassigned
1            Not Started
2            Passed
3            Failed
4            Expired (Time Elapsed)
5            Expired (New Content)

Course Status
CourseStatusID Status
-------------- --------------------------------------------------
0              Unassigned
1              InComplete
2              Complete

CourseModuleStatus enum
--------------------------------------------------
Complete	= 1,
Failed		= 2,
NotStarted	= 3,
Unknown		= 4

When "Course/Module Status" is set to "Complete"
This will find users that:
- Belong to any of the Units in @unitIDs
- AND are currently assigned Modules from the selected Course
- AND have the Custom Classification option
- AND have (at the end of the time-period in question) got a status of Complete in tblUserCourseStatus
- AND the event that made them complete happened some time in the time-period in question

exec prcReport_EmailReportDistinctUsers
@organisationID = 3,
@unitIDs = ''5,6,7'',
@courseID = 5,
@classificationID = 1,
@courseModuleStatus = 0,
@quizDateFrom = ''Jan  1 2004 12:00:00:000AM'',
@quizDateTo = ''Sep 17 2004 11:59:59:000PM''

exec prcReport_EmailReportDistinctUsers
@organisationID = 3,
@unitIDs = ''5,6,7'',
@courseID = 5,
@classificationID = 1,
@courseModuleStatus = 3,
@quizDateFrom = ''Jan  1 2004 12:00:00:000AM'',
@quizDateTo = ''Sep 17 2004 11:59:59:000PM''


*/
CREATE        Proc [prcReport_EmailReportDistinctUsers]
(
@organisationID		int,
@unitIDs 			varchar(MAX),
@courseIDs 			varchar(8000),
@classificationID 	int,
@courseModuleStatus	int,
@quizDateFromOrg 		datetime,
@quizDateToOrg 		datetime,
@includeInactive	int
)
AS
------------------------------------------
Set Nocount On

DECLARE @quizDateFrom 		datetime
DECLARE @quizDateTo 		datetime
SET @quizDateFrom = dbo.udfDaylightSavingTimeToUTC(@quizDateFromOrg,@OrganisationID)
SET @quizDateTo = dbo.udfDaylightSavingTimeToUTC(@quizDateToOrg,@OrganisationID)




Declare
@CONST_INCOMPLETE     	int,
@CONST_COMPLETE     	int,
@CONST_FAILD            int,
@CONST_NOTSTARTED 	    int,
@CONST_UNKNOWN 	        int,
@CONST_EXPIRED_TIMELAPSED int,
@CONST_EXPIRED_NEWCONTENT int

set @CONST_INCOMPLETE	= 0
set @CONST_COMPLETE	    = 1
set @CONST_FAILD		= 2
set @CONST_NOTSTARTED	= 3
set @CONST_EXPIRED_TIMELAPSED	= 4
set @CONST_EXPIRED_NEWCONTENT  = 5

DECLARE @Units TABLE (UnitID INT)
DECLARE @Courses TABLE (CourseID INT)
DECLARE @CoursesWithAccess TABLE (CourseID INT PRIMARY KEY, [name] nvarchar(100))
DECLARE @UserModuleWithAccess TABLE (UserID INT, ModuleID INT, UnitID INT, PRIMARY KEY(UserID, ModuleID, UnitID))
DECLARE @AllModules TABLE (ModuleID INT PRIMARY KEY(ModuleID))
DECLARE @Users TABLE (UserID INT, UnitID INT PRIMARY KEY(UserID, UnitID))
DECLARE @UsersNQuizStatus TABLE (
UserID	INT, ModuleID INT, LatestQuizID INT, QuizStatusID INT, QuizScore INT,
PRIMARY KEY(UserID, ModuleID, LatestQuizID, QuizStatusID)
)
DECLARE @UsersQuizStatusNOTSTARTED TABLE (
UserID	INT, ModuleID INT, LatestQuizID INT, QuizStatusID INT, QuizScore INT,
PRIMARY KEY(UserID, ModuleID, LatestQuizID, QuizStatusID)
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

--Get Rid of courses which do not have access to specified org
INSERT INTO
@CoursesWithAccess
SELECT
A.CourseID, [name]
FROM
@Courses A, tblOrganisationCourseAccess B, tblCourse C
WHERE
A.CourseID = B.GrantedCourseID
AND B.OrganisationID = @organisationID
AND A.CourseID = C.CourseID
AND C.Active = 1

--Get All the users for all specfied units
INSERT INTO
@Users
SELECT
DISTINCT A.UserID, A.UnitiD
FROM
tblUser A
join  @Units B on A.UnitID = B.UnitID
join  tblUnit C on B.UnitID = C.UnitID  AND C.Active = 1
WHERE
@includeinactive =1 or A.Active = 1 -- show all or only active users



if @courseModuleStatus = @CONST_COMPLETE or @courseModuleStatus = @CONST_INCOMPLETE
begin -- completed / -- InComplete
--------------------
-- Completed --
--------------------
-- A user is completed if they became complete and remained completed in the period of interest
-- the query only needs to check to see status at the max date in this period as a line item
-- as tblUserCourseStatus is only writen to when an event occours that would
-- change the status.
-- When "Course/Module Status" is set to "Complete"
-- This will find users that:
-- - Belong to any of the Units in @unitIDs
-- - AND are currently assigned Modules from the selected Course
-- - AND have the Custom Classification option (if provided)
-- - AND have (at the end of the time-period in question) got a status of Complete in tblUserCourseStatus
-- - AND the event that made them complete happened some time in the time-period in question
--------------------
-- InComplete
--------------------
-- A user is in-completed if for any reason they are not complete but do have access to the course
-- This will find users that:
-- - Belong to any of the Units in @unitIDs
-- - AND are currently assigned Modules from the selected Course
-- - AND have the Custom Classification option (if provided)
-- - AND have (at the end of the time-period in question) got a status of Incomplete in tblUserCourseStatus
-- - AND the event that made them complete happened some time in the time-period in question

SELECT
DISTINCT A.UserID, F.HierarchyName, A.FirstName, A.LastName, dbo.udfUTCtoDaylightSavingTime(A.DateCreated, @organisationID) as DateCreated, dbo.udfUTCtoDaylightSavingTime(A.DateArchived, @organisationID) as DateArchived
FROM
(SELECT
A.UserID, D.UnitID, D.FirstName, D.LastName + case when D.Active <> 1 then ''(i)'' else '''' end as ''LastName'',
D.DateCreated as DateCreated, D.DateArchived as DateArchived, A.CourseID
FROM
(SELECT
A.UserID, A.CourseID, MAX(A.UserCourseStatusID) AS ''LatestCourseStatus''
FROM
tblUserCourseStatus A, @CoursesWithAccess B
WHERE
A.DateCreated < DATEADD(DD, 1, @quizDateTo)
and A.CourseID = B.CourseID
GROUP BY
A.UserID, A.CourseID
) A, @Users B, tblUserCourseStatus C, tblUser D
WHERE
A.UserID = B.UserID
AND B.UserID = C.UserID
AND A.LatestCourseStatus = C.UserCourseStatusID
AND (C.DateCreated BETWEEN @quizDateFrom AND @quizDateTo)
AND C.CourseStatusID = case @courseModuleStatus
when @CONST_COMPLETE then 2   -- Complete
when @CONST_INCOMPLETE then 1 -- InComplete
end
AND A.UserID = D.UserID
) A
LEFT JOIN tblUserClassification ON tblUserClassification.UserID = A.UserID
AND tblUserClassification.classificationID = isnull( @classificationID, tblUserClassification.classificationID )
LEFT JOIN tblUnitHierarchy F ON F.UnitID = A.UnitID
WHERE
--If classification is Any (0), This will find users of any Custom Classification
(@classificationID =0 OR tblUserClassification.classificationID = @classificationID)
AND A.UserID IN (select UserID from tblUser where OrganisationID = @organisationID and Active = 1)
ORDER BY
F.HierarchyName, A.LastName, A.FirstName
END -- completed / -- InComplete


if @courseModuleStatus = @CONST_FAILD or @courseModuleStatus = @CONST_EXPIRED_TIMELAPSED or @courseModuleStatus = @CONST_EXPIRED_NEWCONTENT
begin -- Failed
--------------------
-- Failed  --
--------------------
-- When "Course/Module Status" is set to "Failed"
-- This will find users that:
--  - Belong to any of the Units in @unitIDs
--  - AND are currently assigned Modules from the selected Course
--  - AND have the Custom Classification option
--  - AND took a quiz, for a Module within the selected Course, within the date range and failed it
--  - AND who currently have a status other than "Passed" for that same quiz
--------------------

INSERT INTO
@UserModuleWithAccess
SELECT
DISTINCT A.UserID, A.ModuleID, A.UnitID
FROM
(SELECT
A.UserID, A.ModuleID, A.UnitID
FROM
vwUserModuleAccess A
where
courseid in (SELECT courseid from @Courses)
)A, @Users B
Where
A.UserID = B.UserID

--Find the latest status of all quiz for all the modules
INSERT INTO
@UsersNQuizStatus
SELECT
DISTINCT A.UserID, A.ModuleID, A.LatestQuizID, B.QuizStatusID, B.QuizScore
FROM
(SELECT
A.UserID, A.ModuleID, MAX(B.UserQuizStatusID) AS ''LatestQuizID''
FROM
@UserModuleWithAccess A, tblUserQuizStatus B
WHERE
A.UserID = B.UserID
AND A.ModuleID = B.ModuleID
GROUP BY
A.UserID, A.ModuleID
) A, tblUserQuizStatus B
WHERE
A.UserID = B.UserID
AND A.ModuleID = B.ModuleID
AND A.LatestQuizID = B.UserQuizStatusID

INSERT INTO
@UsersQuizStatusNOTSTARTED
SELECT
*
FROM
@UsersNQuizStatus
WHERE
QuizStatusID = case @courseModuleStatus
when @CONST_FAILD then 3   -- Failed
when @CONST_EXPIRED_TIMELAPSED then 4 -- Expired time lapsed
when @CONST_EXPIRED_NEWCONTENT then 5 -- Expired new content
end

--Get Data in report format
SELECT
DISTINCT A.UserID, C.HierarchyName, B.FirstName, B.LastName + case when B.Active <> 1 then ''(i)'' else '''' end as ''LastName'',
dbo.udfUTCtoDaylightSavingTime(B.DateCreated, @OrganisationID) as DateCreated,
dbo.udfUTCtoDaylightSavingTime(B.DateArchived, @OrganisationID) as DateArchived
FROM
(select
distinct userid, moduleid
from
@UsersQuizStatusNOTSTARTED
) A, tblUser B, tblModule D, tblUnitHierarchy C
WHERE
A.UserID = B.UserID
AND B.UnitID = C.UnitID
AND A.ModuleID = D.ModuleID
AND D.Active = 1
ORDER BY
C.HierarchyName, B.LastName + case when B.Active <> 1 then ''(i)'' else '''' end, B.FirstName
end --/ Failed


-- Not started --

if @courseModuleStatus = @CONST_NOTSTARTED
begin -- Not started - Any
--------------------
-- Not started  --
--------------------
-- When "Course/Module Status" is set to "Not Started"
-- This will find users that:
--  - Belong to any of the Units in @unitIDs
--  - AND are currently assigned Modules from the selected Course
--  - AND have the Custom Classification option
--  - AND who have not started ANY of the quizes they have access to in this course
--------------------

INSERT INTO
@UserModuleWithAccess
SELECT
DISTINCT A.UserID, A.ModuleID, A.UnitID
FROM
(SELECT
A.UserID, A.ModuleID, A.UnitID
FROM
vwUserModuleAccess A
where
courseid in (SELECT courseid from @Courses)
) A, @Users B
Where
A.UserID = B.UserID

--Find the latest status of all quiz for all the modules
INSERT INTO
@UsersNQuizStatus
SELECT
DISTINCT A.UserID, A.ModuleID, A.LatestQuizID, B.QuizStatusID, B.QuizScore
FROM
(SELECT
A.UserID, A.ModuleID, MAX(B.UserQuizStatusID) AS ''LatestQuizID''
FROM
@UserModuleWithAccess A, tblUserQuizStatus B
WHERE
A.UserID = B.UserID
AND A.ModuleID = B.ModuleID
GROUP BY
A.UserID, A.ModuleID
) A, tblUserQuizStatus B
WHERE
A.UserID = B.UserID
AND A.ModuleID = B.ModuleID
AND A.LatestQuizID = B.UserQuizStatusID
AND (B.DateCreated BETWEEN @quizDateFrom AND @quizDateTo)

--select * from @UsersNQuizStatus

--Get User with Quiz NOT STARTED
INSERT INTO
@UsersQuizStatusNOTSTARTED
SELECT
*
FROM
@UsersNQuizStatus
WHERE
QuizStatusID NOT IN (2,3)
AND UserID NOT IN (SELECT UserID FROM @UsersNQuizStatus WHERE QuizStatusID IN (2,3))

--select * from @UsersQuizStatusNOTSTARTED
--select distinct userid,moduleid from @UsersQuizStatusNOTSTARTED

--Get Data in report format
SELECT
DISTINCT A.UserID, B.HierarchyName, A.LastName+ case when A.Active <> 1 then ''(i)'' else '''' end as ''LastName'',
A.FirstName,
dbo.udfUTCtoDaylightSavingTime(A.DateCreated, @OrganisationID) as DateCreated,
dbo.udfUTCtoDaylightSavingTime(A.DateArchived, @OrganisationID) as DateArchived
FROM
(SELECT
DISTINCT A.UserID, B.UnitID, B.FirstName, B.LastName, B.active, B.DateCreated, B.DateArchived, courseid
FROM
(SELECT
DISTINCT userid, moduleid
FROM
@UsersQuizStatusNOTSTARTED
) A, tblUser B, tblModule D
WHERE
A.UserID = B.UserID
AND A.ModuleID = D.ModuleID
AND D.Active = 1
) A
LEFT JOIN tblUserClassification ON tblUserClassification.UserID = A.UserID
AND tblUserClassification.classificationID = isnull( @classificationID, tblUserClassification.classificationID )
LEFT JOIN tblUnitHierarchy B ON B.UnitID = A.UnitID
WHERE
--If classification is Any (0), This will find users of any Custom Classification
@classificationID =0 OR tblUserClassification.classificationID = @classificationID
ORDER BY
B.HierarchyName, A.LastName+ case when A.Active <> 1 then ''(i)'' else '''' end, A.FirstName

end --/ Not started - Any


' 
END
GO
