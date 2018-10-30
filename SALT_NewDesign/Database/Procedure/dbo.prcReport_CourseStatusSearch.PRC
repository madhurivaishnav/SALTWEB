SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_CourseStatusSearch]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/******************************************************************************
**		File:
**		Name: prcReport_CourseStatusSearch
**		Desc: Given a list of unit IDs, course IDs,
**
**		This template can be customized:
**
**		Return values:
**
**		Called by:
**
**		Parameters:
**		Input							Output
**     ----------							-----------
**
**		Auth:
**		Date:
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		23/07/2009	Mark Donald			Add @classificationID parameter and use
**										it to filter the insert into @Users
**		17/08/2009	Mark Donald			Change column order of ''fail option''
**										select statement to match others
**
*******************************************************************************/

--exec prcReport_CourseStatusSearch 109, ''4463,4464,4465,4469,4478,4479'', ''92'', 3, ''1997-01-01'',''2011-07-01'', 0, 0
CREATE       Procedure [prcReport_CourseStatusSearch]
(
@organisationID		int,
@unitIDs 		varchar(max),
@courseIDs 		varchar(8000),
@courseModuleStatus	int,
@dateFromOrg 		datetime,
@dateToOrg 		datetime,
@IncludeInactive int,
@classificationID int
)
AS

begin
------------------------------------------
DECLARE @dateFrom 		datetime
DECLARE @dateTo 		datetime
SET @dateFrom = dbo.udfDaylightSavingTimeToUTC(@dateFromOrg,@OrganisationID)
SET @dateTo = dbo.udfDaylightSavingTimeToUTC(@dateToOrg,@OrganisationID)

Set Nocount On

Declare
@CONST_INCOMPLETE     	int,
@CONST_COMPLETE     	int,
@CONST_FAILD            int,
@CONST_NOTSTARTED 	    int,
@CONST_EXPIRED_TIMELAPSED		int,
@CONST_EXPIRED_NEWCONTENT		int

set @CONST_INCOMPLETE	= 0
set @CONST_COMPLETE	= 1
set @CONST_FAILD	= 2
set @CONST_NOTSTARTED	= 3
set @CONST_EXPIRED_TIMELAPSED   = 4
set @CONST_EXPIRED_NEWCONTENT	= 5

DECLARE @Units TABLE
(
UnitID INT PRIMARY KEY(UnitID)
)

DECLARE @Courses TABLE
(
CourseID INT PRIMARY KEY(CourseID)
)

DECLARE @CoursesWithAccess 	TABLE (CourseID INT PRIMARY KEY(CourseID))
DECLARE @UserModuleWithAccess TABLE(UserID INT, ModuleID INT, UnitID INT PRIMARY KEY(UserID, ModuleID, UnitID))
DECLARE @AllModules TABLE(ModuleID INT PRIMARY KEY(ModuleID))
DECLARE @Users TABLE(UserID INT , UnitID INT PRIMARY KEY(UserID, UnitID))
DECLARE @UsersNQuizStatus
TABLE
(
UserID	INT,
ModuleID INT,
LatestQuizID INT,
QuizStatusID INT,
QuizScore INT
PRIMARY KEY(UserID, ModuleID, LatestQuizID, QuizStatusID)
)

DECLARE @UsersQuizStatusNOTSTARTED
TABLE
(
UserID	INT,
ModuleID INT,
LatestQuizID INT,
QuizStatusID INT,
QuizScore INT
PRIMARY KEY(UserID, ModuleID, LatestQuizID, QuizStatusID)
)

INSERT INTO @Courses SELECT * FROM dbo.udfCsvToInt(@courseIDs)

INSERT INTO @Units SELECT * FROM  dbo.udfCsvToInt(@unitIDs)

--Get Rid of courses which do not have access to specified org
INSERT INTO @CoursesWithAccess
SELECT A.CourseID FROM @Courses A, tblOrganisationCourseAccess B, tblCourse C
WHERE A.CourseID = B.GrantedCourseID AND B.OrganisationID = @organisationID AND
A.CourseID = C.CourseID AND C.Active = 1

--Get All the users for all specfied units, matching Custom Classification option (if provided)
INSERT INTO @Users
SELECT
DISTINCT A.UserID, A.UnitiD
FROM
tblUser A
join @Units B on A.UnitID = B.UnitID
join tblUnit C on B.UnitID = C.UnitID AND C.Active = 1
LEFT JOIN tblUserClassification uc ON uc.UserID  = A.UserID
WHERE
A.Active = CASE @IncludeInactive WHEN 0 THEN 1 ELSE A.Active END
AND ((@classificationID =0) OR (classificationID = @classificationID))
--If classification is Any (0), This will find users of any Custom Classification



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
-- - AND have (at the end of the time-period in question) got a status of Complete in tblUserCourseStatus
-- - AND the event that made them complete happened some time in the time-period in question
--------------------
-- InComplete
--------------------
-- A user is in-completed if for any reason they are not complete but do have access to the course
-- This will find users that:
-- - Belong to any of the Units in @unitIDs
-- - AND are currently assigned Modules from the selected Courses
-- - AND have (at the end of the time-period in question) got a status of Incomplete in tblUserCourseStatus
-- - AND the event that made them complete happened some time in the time-period in question

--Find the latest status of courses
SELECT
A.UserID, D.UnitID,
D.FirstName,
D.LastName,
case when D.Active = 1 then ''''  else ''(i)'' end as Flag,
F.HierarchyName AS ''UnitPathWay'',
dbo.udfUTCtoDaylightSavingTime( C.DateCreated , @organisationID)as ''Date'',
D.Username as ''UserName'',
D.Email as ''Email'',
D.ExternalID as ''ExternalID'',
E.[Name] as ''CourseName'',
dbo.udfUTCtoDaylightSavingTime(D.DateCreated, @organisationID)as ''DateCreated'',
case when D.Active =0 then coalesce(dbo.udfUTCtoDaylightSavingTime(D.DateArchived,@organisationid ),dbo.udfUTCtoDaylightSavingTime(D.DateUpdated,@organisationid)) end  as ''DateArchived''
FROM
(SELECT
A.UserID, A.CourseID, MAX(A.UserCourseStatusID) AS ''LatestCourseStatus''
FROM
tblUserCourseStatus A, @CoursesWithAccess B
WHERE
A.DateCreated < DATEADD(DD, 1, @dateTo)
and
A.CourseID = B.CourseID
GROUP BY
A.UserID, A.CourseID
) A,
@Users B, tblUserCourseStatus C, tblUser D, tblCourse E, tblUnitHierarchy F
WHERE
A.UserID = B.UserID AND B.UserID = C.UserID AND
A.LatestCourseStatus = C.UserCourseStatusID AND
(C.DateCreated BETWEEN @dateFrom AND dateadd(d,1,@dateTo)) AND
C.CourseStatusID = case @courseModuleStatus
when @CONST_COMPLETE then 2   -- Complete
when @CONST_INCOMPLETE then 1 -- InComplete
end AND
A.UserID = D.UserID AND A.CourseID = E.CourseID AND
D.UnitID = F.UnitID
ORDER BY
CourseName, UnitPathWay, LastName, FirstName

end -- completed / -- InComplete


if @courseModuleStatus = @CONST_FAILD or @courseModuleStatus = @CONST_EXPIRED_TIMELAPSED or @courseModuleStatus = @CONST_EXPIRED_NEWCONTENT
begin -- Failed
--------------------
-- Failed  --
--------------------
-- When "Course/Module Status" is set to "Failed"
-- This will find users that:
--  - Belong to any of the Units in @unitIDs
--  - AND are currently assigned Modules from the selected Courses
--  - AND took a quiz, for a Module within the selected Course, within the date range of DateCreated in UserQuizStatus and failed it
--  - AND who currently have a status other than "Passed" for that same quiz
--------------------

--Find All Modules for all units with access

INSERT INTO @UserModuleWithAccess
SELECT DISTINCT A.UserID, A.ModuleID, A.UnitID FROM
(
SELECT A.UserID, A.ModuleID, A.UnitID
FROM vwUserModuleAccess A where courseid in (SELECT courseid from @Courses) )A, @Users B
Where A.UserID = B.UserID

--Find the latest status of all quiz for all the modules
INSERT INTO @UsersNQuizStatus
SELECT DISTINCT
A.UserID, A.ModuleID, A.LatestQuizID, B.QuizStatusID, B.QuizScore
FROM
(
SELECT
A.UserID, A.ModuleID, MAX(B.UserQuizStatusID) AS ''LatestQuizID''
FROM
@UserModuleWithAccess A, tblUserQuizStatus B
WHERE
A.UserID = B.UserID AND A.ModuleID = B.ModuleID
GROUP BY
A.UserID, A.ModuleID) A,
tblUserQuizStatus B
WHERE
A.UserID = B.UserID AND A.ModuleID = B.ModuleID AND
A.LatestQuizID = B.UserQuizStatusID AND
(B.DateCreated BETWEEN @dateFrom AND dateadd(d,1,@dateTo))

INSERT INTO @UsersQuizStatusNOTSTARTED
SELECT * FROM @UsersNQuizStatus WHERE QuizStatusID = case @courseModuleStatus
when @CONST_FAILD then 3   -- Failed
when @CONST_EXPIRED_TIMELAPSED then 4 -- Expired time lapsed
when @CONST_EXPIRED_NEWCONTENT then 5 -- Expired new content
end


--Get Data in report format
SELECT DISTINCT
A.UserID,
B.UnitID AS ''Unit'' ,
B.FirstName,
B.LastName,
case when B.Active = 1 then ''''  else ''(i)'' end  as Flag,
E.HierarchyName AS ''UnitPathWay'',
dbo.udfUTCtoDaylightSavingTime( C.DateCreated,@organisationID) AS ''Date'',
B.UserName,
B.Email,
B.ExternalID,C.Name AS ''CourseName'',
dbo.udfUTCtoDaylightSavingTime(B.DateCreated,@organisationID) AS ''DateCreated'',
case when B.Active =0 then coalesce(dbo.udfUTCtoDaylightSavingTime(B.DateArchived, @OrganisationID), dbo.udfUTCtoDaylightSavingTime(B.DateUpdated, @OrganisationID)) end as ''DateArchived''
FROM
(
select distinct userid, moduleid from @UsersQuizStatusNOTSTARTED) A,
tblUser B, tblCourse C, tblModule D, tblUnitHierarchy E
WHERE
A.UserID = B.UserID AND B.Active = 1 AND
A.ModuleID = D.ModuleID AND
B.UnitID = E.UnitID AND
D.CourseID = C.CourseID AND C.Active = 1 AND D.Active = 1
ORDER BY
CourseName, UnitPathWay, LastName, FirstName


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
--  - AND are currently assigned Modules from the selected Courses
--  - AND who have not started ANY of the quizes they have access to in this course within the selected date range(DateCreated in vwUserQuizStatus)
--------------------


--Find All Modules for all units with access

INSERT INTO @UserModuleWithAccess
SELECT DISTINCT A.UserID, A.ModuleID, A.UnitID FROM
(
SELECT A.UserID, A.ModuleID, A.UnitID
FROM vwUserModuleAccess A where courseid in (SELECT courseid from @Courses) )A, @Users B
Where A.UserID = B.UserID

--Find the latest status of all quiz for all the modules
INSERT INTO @UsersNQuizStatus
SELECT  DISTINCT
A.UserID, A.ModuleID, A.LatestQuizID, B.QuizStatusID, B.QuizScore
FROM
(
SELECT
A.UserID, A.ModuleID, MAX(B.UserQuizStatusID) AS ''LatestQuizID''
FROM
@UserModuleWithAccess A, tblUserQuizStatus B
WHERE
A.UserID = B.UserID AND A.ModuleID = B.ModuleID
GROUP BY
A.UserID, A.ModuleID) A, tblUserQuizStatus B
WHERE
A.UserID = B.UserID AND A.ModuleID = B.ModuleID AND
A.LatestQuizID = B.UserQuizStatusID AND
(B.DateCreated BETWEEN @dateFrom AND dateadd(d,1,@dateTo))


--Get User with Quiz NOT STARTED
INSERT INTO @UsersQuizStatusNOTSTARTED
SELECT * FROM @UsersNQuizStatus WHERE QuizStatusID NOT IN (2,3,4,5) AND
UserID NOT IN (SELECT UserID FROM @UsersNQuizStatus WHERE QuizStatusID IN (2,3,4,5))


--Get Data in report format
SELECT DISTINCT
A.UserID,
B.UnitID ,
B.FirstName,
B.LastName,
case when B.Active = 1 then '''' else ''(i)'' end  as Flag,
dbo.udfGetUnitPathway(B.UnitID) AS ''UnitPathWay'',
dbo.udfUTCtoDaylightSavingTime(C.DateCreated,@organisationID) AS ''Date'',
B.UserName,
B.Email,
B.ExternalID,
C.Name AS ''CourseName'',
dbo.udfUTCtoDaylightSavingTime(B.DateCreated,@OrganisationID) as ''DateCreated'',
case when B.Active =0 then coalesce(dbo.udfUTCtoDaylightSavingTime(B.DateArchived,@OrganisationID),dbo.udfUTCtoDaylightSavingTime(B.DateUpdated,@OrganisationID)) end as ''DateArchived''
FROM
(select distinct userid, moduleid from @UsersQuizStatusNOTSTARTED) A,
tblUser B, tblCourse C, tblModule D, tblUnitHierarchy E
WHERE
A.UserID = B.UserID AND B.Active = 1 AND
A.ModuleID = D.ModuleID AND B.UnitID = E.UnitID AND
D.CourseID = C.CourseID AND C.Active = 1 AND D.Active = 1
ORDER BY
CourseName, UnitPathWay, LastName, FirstName

end --/ Not started - Any
END
' 
END
GO
