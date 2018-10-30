SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_EmailReportToAdministrators]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
Get a list of users that will appear in the administrtors email list

Returns:
AdminUserID,UserUnitID,Administrator Email,Administrator Name, Administrator''s Unit, User Unit, User name
AdminUserID,UserUnitID,Administrator Email,Administrator Name, Administrator''s Unit, User Unit, User name
AdminUserID,UserUnitID,Administrator Email,Administrator Name, Administrator''s Unit, User Unit, User name
AdminUserID,UserUnitID,Administrator Email,Administrator Name, Administrator''s Unit, User Unit, User name
AdminUserID,UserUnitID,Administrator Email,Administrator Name, Administrator''s Unit, User Unit, User name

order by AdminUserID,UserUnitID

Called By: Email report
Calls:

Remarks:

Sending to Administrators
If "Administrators" was selected as the Recipient Type, then the email will be sent to the administrators of the user''s Units.

If a user belongs to a Unit that does not have its own administrator, the email will go to the Organisation Administrators.

Only one email will be sent to each administrator.

Within the body of the email for each administrator will be the list of users who are in the Units which they administer. (See Appendix A).
The list will group the users into Units and have the Unit name as the heading for each group.



Author:Jack Liu
Date Created: 27 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

prcReport_EmailReportToAdministrators 3, ''42,48,11''

select * from tbluser where userID = 42

--------------------

**/

CREATE Proc [prcReport_EmailReportToAdministrators]
(
@organisationID int,
@unitIDs 			varchar(MAX),
@courseIDs 			varchar(8000),
@classificationID 	int,
@courseModuleStatus	int,
@quizDateFrom 		datetime,
@quizDateTo 		datetime,
@includeInactive	int
)

AS

Set Nocount On
DECLARE @quizDateFromOrg 		datetime
DECLARE @quizDateToOrg 		datetime
SET @quizDateFromOrg = dbo.udfDaylightSavingTimeToUTC(@quizDateFrom,@OrganisationID)
SET @quizDateToOrg = dbo.udfDaylightSavingTimeToUTC(@quizDateTo,@OrganisationID)

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
AdminUserID int
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
A.DateCreated < DATEADD(DD, 1, @quizDateToOrg)
and A.CourseID = B.CourseID
GROUP BY
A.UserID, A.CourseID
) A, @Users B, tblUserCourseStatus C, tblUser D
WHERE
A.UserID = B.UserID
AND B.UserID = C.UserID
AND A.LatestCourseStatus = C.UserCourseStatusID
AND (C.DateCreated BETWEEN @quizDateFromOrg AND @quizDateToOrg)
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
AND (B.DateCreated BETWEEN @quizDateFromOrg AND @quizDateToOrg)

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
insert into @tblUnitAdministrator (UnitID, AdminUserID)
select u.UnitID, ua.UserID
from @tblUnit u
inner join tblUnitAdministrator ua
on ua.UnitID = u.UnitID
inner join tblUser us
on us.UserID = ua.UserID and us.UserTypeID = 3 --Unit Administrator

--If a user belongs to a Unit that does not have its own administrator, the email will go to the Organisation Administrators.
insert into @tblUnitAdministrator (UnitID, AdminUserID)
select u.UnitID, us.UserID
from tblUser us
cross join @tblUnit u
where us.OrganisationID = @organisationID
and us.UserTypeID = 2 -- Organisation Administrator
and u.UnitID not in (select UnitID from @tblUnitAdministrator)
and us.Active = 1


-- Tidy up the results
SELECT
DISTINCT adminuserid userid, hierarchyname, lastname, firstname,
dbo.udfUTCtoDaylightSavingTime(DateCreated, @OrganisationID) as DateCreated,
dbo.udfUTCtoDaylightSavingTime(DateArchived, @OrganisationID) as DateArchived,
NULL courseid
FROM
@tblunitadministrator a
INNER JOIN tbluser u ON userid = a.adminuserid
INNER JOIN tblunithierarchy h ON h.unitid = u.unitid
WHERE
u.active = 1
ORDER BY
hierarchyname, adminuserid
' 
END
GO
