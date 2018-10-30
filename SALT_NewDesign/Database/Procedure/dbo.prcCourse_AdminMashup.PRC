SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcCourse_AdminMashup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:		Compiles a bunch of info based on the selected units/courses then filters it based on administrator selection
Parameters:		Comma separated list of userID:courseID, comma separated list of adminID (unit administrators)
Returns:		table (lastname firstname userid email course_names)

Called By:		BusinessServices.Course.GetAdminMashup in Course.cs
Calls:			None

Remarks:		None

Author:			Mark Donald
Date Created:	20 Jan 2010

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE PROCEDURE [prcCourse_AdminMashup]
@organisationID int,
@unitIDs 			varchar(MAX),
@courseIDs 			varchar(8000),
@input_csv varchar(8000),
@adminids varchar(8000),
@classificationID 	int,
@courseModuleStatus	int,
@quizDateFrom 		datetime,
@quizDateTo 		datetime,
@includeInactive	int
AS
BEGIN
SET NOCOUNT ON;


set @quizDateFrom = dbo.udfDaylightSavingTimeToUTC(@quizDateFrom, @organisationID)
set @quizDateTo = dbo.udfDaylightSavingTimeToUTC(@quizDateTo, @organisationID)

declare @tblUserUnit table
(
UserID int,
UnitID int
)


declare @tblUnit table
(
unitID int
)

declare @tblUnitAdministrator table
(
unitID int,
AdminUserID int,
firstname nvarchar(200),
lastname nvarchar(200)
)
Set Nocount On
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
DECLARE @mashup TABLE (userid int, courseid int)
DECLARE @selectedadmin TABLE (adminid int)
DECLARE
@pos int,
@colon_pos int,
@temp varchar(50)

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

INSERT INTO
@selectedadmin
SELECT
*
FROM
dbo.udfCsvToInt(@adminids)

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

INSERT INTO @tblUserUnit(UserID, UnitID)
SELECT
DISTINCT A.UserID, A.UnitID
FROM
(SELECT
A.UserID, D.UnitID
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
WHERE
--If classification is Any (0), This will find users of any Custom Classification
(@classificationID =0 OR tblUserClassification.classificationID = @classificationID)
AND A.UserID IN (select UserID from tblUser where OrganisationID = @organisationID and Active = 1)
ORDER BY
A.UserID, A.UnitID
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
INSERT INTO @tblUserUnit(UserID, UnitID)
SELECT
DISTINCT A.UserID, UnitID
FROM
(select
distinct userid, moduleid
from
@UsersQuizStatusNOTSTARTED
) A, tblUser B, tblModule D
WHERE
A.UserID = B.UserID
AND A.ModuleID = D.ModuleID
AND D.Active = 1
ORDER BY
A.UserID, UnitID
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
INSERT INTO @tblUserUnit(UserID, UnitID)
SELECT
A.UserID, UnitID
FROM
(SELECT
DISTINCT A.UserID, B.UnitID
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
WHERE
--If classification is Any (0), This will find users of any Custom Classification
@classificationID =0 OR tblUserClassification.classificationID = @classificationID
ORDER BY
A.UserID, UnitID

end --/ Not started - Any


insert into @tblUnit(UnitID)
select distinct UnitID
from @tblUserUnit

---If "Administrators" was selected as the Recipient Type, then the email will be sent to the administrators of the users Units.
insert into @tblUnitAdministrator (UnitID, AdminUserID,firstname, lastname)
select u.UnitID, ua.UserID, us.firstname, us.lastname
from @tblUnit u
inner join tblUnitAdministrator ua
on ua.UnitID = u.UnitID
inner join tblUser us
on us.UserID = ua.UserID and us.UserTypeID = 3 --Unit Administrator

--If a user belongs to a Unit that does not have its own administrator, the email will go to the Organisation Administrators.
insert into @tblUnitAdministrator (UnitID, AdminUserID,firstname, lastname)
select u.UnitID, us.UserID, us.firstname, us.lastname
from tblUser us
cross join @tblUnit u
where us.OrganisationID = @organisationID
and us.UserTypeID = 2 -- Organisation Administrator
and u.UnitID not in (select UnitID from @tblUnitAdministrator)
and us.Active = 1


-- clean up the input so it resembles ''userid:courseid,userid:courseid,''
SELECT @input_csv = replace(rtrim(ltrim(replace(replace(replace(@input_csv,'' '',''''),'',,'','',''),'','','' ''))),'' '','','') + '',''

-- rip input_csv
WHILE patindex(''%,%'', @input_csv) <> 0
BEGIN
SELECT @pos = patindex(''%,%'', @input_csv)
SELECT @temp = left(@input_csv, @pos - 1)
SELECT @colon_pos = patindex(''%:%'', @input_csv)
INSERT @mashup VALUES (
cast(substring(@temp, 1, @colon_pos - 1) AS int),
cast(substring(@temp, @colon_pos + 1, len(@temp)) AS int)
)
SELECT @input_csv = substring(@input_csv, @pos + 1, len(@input_csv))
END

-- join @mashup, @tblunitadministrator & @selectedadmin tables & sort results by adminid and courseid
SELECT
adminid, a.email, a.firstname, a.lastname, m.courseid, [name] coursename, u.firstname, u.lastname, n.firstname, n.lastname, u.UserID
FROM
@mashup m,
@tblunitadministrator n,
@selectedadmin s,
tbluser a,
tblcourse c,
tbluser u
WHERE
u.userid = m.userid
AND n.unitid = u.unitid
AND a.userid = adminid
AND adminid = adminuserid
AND c.courseid = m.courseid
ORDER BY
adminid, m.courseid

END
' 
END
GO
