SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[udfReport_HistoricAdminSummary]') AND xtype in (N'FN', N'IF', N'TF'))
BEGIN
execute dbo.sp_executesql @statement = N'

/****** Object:  User Defined Function dbo.udfReport_HistoricAdminSummary    Script Date: 20/04/2004 8:25:58 AM ******/


/*Summary:
Get the Current or historic user module status  based on the search criteria

See the remarks below.

Returns: table

Called By: Current historic Admin Report
Calls:

Remarks:

1. Get User and course List based on search criteria
1.1 Get Unit List
1.1.1 If unit ids are passed in, convert the CSV format to a table
1.1.2 If no unit is selected, get a list of of all units that the admin user has permission to access
1.2 Get User list Based on the first name and last name in the search cirteria
1.3 Get Course list Based on the selected course in the search criteria and Used can select multiple Courses
2. Get the User Quiz and Lesson status up to the effective date
2.1 If there is no effective date is passed in, get the current module status
2.2 If there is effective date, get the module status up to the effective date
3.  Get a list of the user''s quiz and lesson historic status

Author: Jack Liu
Date Created: 1 Mar 2004

Modification History
-----------------------------------------------------------
v#	Author		Date				Description
#1.1	Usman Tjiudri	10/11/2005	Performance tuning: 
									- use temp-table to populate Unit Pathway 
									- join the temp-table to populate tblResult
									  instead of using udfGetUnitPathway function in the join.
#2.0	Serguei Chkaroupine 28/02/06 -New insert statement for histric admin report
									- it will insert all lessons that match current quizmodule pair
									- Current admin report performance fix. Added WHERE statement to
									  most of the insert statements.

select * from dbo.udfReport_HistoricAdminSummary(3, '''', ''1,2,3,4'','''','''',''20040222'',4)

--------------------

**/
--instead of using udfGetUnitPathway function in the join.

--select * from dbo.udfReport_HistoricAdminSummary(3, '''', ''1,2,3,4'','''','''',''20040222'',4)

--------------------



ALTER         Function [udfReport_HistoricAdminSummary]
(
@organisationID 	Int,
@unitIDs			Varchar(8000),
@courseIDs			Varchar(8000),
@userFirstName		nVarchar(50),
@userLastName		nVarchar(50),
@effectiveDate 		Datetime,
@adminUserID		Int,
@classificationID 	Int
)
Returns @tblResult Table
(
-- General
Unit			nVarchar(200),
[User]			nVarchar(100),
Course			nVarchar(100),
Module			nVarchar(100),
[Sequence]		Int,

-- Quiz Specific
QuizStatus		Varchar(50),
QuizScore		Int,
QuizStatusDate	Datetime,

-- Lesson Specific
LessonStatus	Varchar(50),

-- Hidden
UnitID			Int,
UserID			Int,
UserName		nVarchar(100),
ExternalID		nVarchar(50),
CourseID		Int,
ModuleID		Int
)
As Begin
Declare @userTypeID Int
Declare @tblUnit 	Table(UnitID Int)
Declare @tblUser 	Table(UserID Int)
Declare @tblCourse 	Table(CourseID Int, Name nVarchar(50))
Declare @tblUnitPathway Table(UnitID Int, Pathway nVarchar(200)) -- New table

Declare @tblUserQuizStatus Table
(
[UserQuizStatusID] [int] Not Null,
[UserID] [int] Not Null,
[ModuleID] [int] Not Null,
[QuizStatusID] [int] Not Null,
[QuizScore] [int] Null,
[DateCreated] [datetime] Not Null
)

Declare @tblUserLessonStatus Table
(
[UserLessonStatusID] [int] ,
[UserID] [int] ,
[ModuleID] [int] ,
[LessonStatusID] [int] ,
[DateCreated] [datetime]
)


/*
1. Get User and course List based on search criteria
1.1 Get Unit List
1.1.1 If unit ids are passed in, convert the CSV format to a table
1.1.2 If no unit is selected, get a list of of all units that the admin user has permission to access
1.2 Get User list
Based on the first name and last name in the search cirteria
1.3 Get Course list
Based on the selected course in the search criteria
Used can select multiple Courses
*/

If @unitIDs Is Null Set @unitIDs = ''''

If (@unitIDs !='''')
Begin
Insert Into @tblUnit (UnitID)
Select intValue
From dbo.udfCsvToInt(@unitIDs)
End
Else
Begin
Select @userTypeID = userTypeID
From tblUser
Where userID = @adminUserID

--Get all units in that organisation if user is Salt Admin(1) or Org admin (2)
If (@userTypeID=1 Or @userTypeID=2)
Begin
Insert Into @tblUnit (UnitID)
Select UnitID
From tblUnit
Where OrganisationID = @OrganisationID
End
--Get units that the user is admministrator if user is Unit Admin(3)
Else If (@userTypeID=3)
Begin
Insert Into @tblUnit (UnitID)
Select u.UnitID
From tblUnit u
Inner Join tblUnitAdministrator ua On ua.UnitID = u.UnitID And ua.userID = @AdminUserID
Where u.OrganisationID = @OrganisationID
End
End

--FirstName or Last Name specified in search criteria
If (@userFirstName Is Null) Set @userFirstName = ''''
If (@userLastName Is Null) Set @userLastName = ''''

Insert Into @tblUser (UserID)
Select	u.UserID
From tblUser u
Inner Join @tblUnit unit On u.UnitID = unit.UnitID
Left Join tblUserClassification uc On uc.UserID  = u.UserID
Where u.FirstName Like ''%'' + @userFirstName + ''%''
And LastName Like ''%'' + @userLastName + ''%''
And --AND have the Custom Classification option
--If classification is Any (0), This will find users of any Custom Classification
( (@classificationID =0) Or (uc.classificationID = @classificationID) )
And (u.Active=1)
AND (u.OrganisationID = @OrganisationID)

-- Search criteria contains course id''s
Insert Into @tblCourse (CourseID, Name)
Select c.CourseID, c.name
From dbo.udfCsvToInt(@courseIDs) ca
Inner Join tblCourse c On ca.intValue = c.CourseID

/*
2. Get the User Quiz and Lesson status up to the effective date
2.1 If there is no effective date is passed in, get the current module status
2.2 If there is effective date, get the module status up to the effective date
*/

If (@effectiveDate Is Null)
Begin
Insert Into @tblUserQuizStatus
(
[UserQuizStatusID],
[UserID],
[ModuleID],
[QuizStatusID],
[QuizScore],
[DateCreated]
)
Select
[UserQuizStatusID],
[UserID],
[ModuleID],
[QuizStatusID],
[QuizScore],
[DateCreated]
From vwUserQuizStatus
Where QuizStatusID <> 0
AND UserID in  (SELECT UserID FROM @tblUser)

Insert Into @tblUserLessonStatus
(
[UserLessonStatusID],
[UserID],
[ModuleID],
[LessonStatusID],
[DateCreated]
)
Select
[UserLessonStatusID],
[UserID],
[ModuleID],
[LessonStatusID],
[DateCreated]
From vwUserLessonStatus
Where LessonStatusID <> 0
AND UserID in  (SELECT UserID FROM @tblUser)
End

Else

Begin
Insert Into @tblUserQuizStatus
(
[UserQuizStatusID],
[UserID],
[ModuleID],
[QuizStatusID],
[QuizScore],
[DateCreated]
)
Select
[UserQuizStatusID],
[UserID],
[ModuleID],
[QuizStatusID],
[QuizScore],
[DateCreated]
From dbo.udfReport_HistoricUserQuizStatus(@effectiveDate)
Where QuizStatusID <> 0
AND UserID in  (SELECT UserID FROM @tblUser)

Insert Into @tblUserLessonStatus
(
[UserLessonStatusID],
[UserID],
[ModuleID],
[LessonStatusID],
[DateCreated]
)
Select
[UserLessonStatusID],
[UserID],
[ModuleID],
[LessonStatusID],
[DateCreated]
From dbo.udfReport_HistoricUserLessonStatus(@effectiveDate)
Where LessonStatusID <> 0
AND UserID in  (SELECT UserID FROM @tblUser)


-- This part fixes migration issue (note this will affect historic admin report only as it does supply effective date)
-- It will insert userid, moduleid and earliest lesson status for each quiz that does not have lesson record yet
-- into @tblUserLessonStatus
Insert Into @tblUserLessonStatus
(
[UserLessonStatusID],
[UserID],
[ModuleID],
[LessonStatusID],
[DateCreated]
)
Select
1,
uls.[UserID],
uls.[ModuleID],
uls.LessonStatusID,
uls.DateCreated
From  @tblUserQuizStatus uqs
INNER JOIN tblUserLessonStatus uls
ON uqs.UserID = uls.UserID AND uqs.ModuleID = uls.ModuleID
INNER JOIN 
(
 -- this derived table gets earliest lesson datecreated in a group
	SELECT  UserID, ModuleID, min(DateCreated) as DateCreated
	FROM tblUserLessonStatus
	WHERE UserID in (SELECT UserID FROM @tblUser)
	GROUP BY UserID, ModuleID --, DateCreated
) as els -- Earliest Lesson Status
ON els.UserID = uls.UserID AND els.ModuleID = uls.ModuleID AND els.DateCreated = uls.DateCreated
WHERE NOT EXISTS
(
	SELECT 1 FROM @tblUserLessonStatus uls 
	WHERE uqs.UserID = uls.UserID and uqs.ModuleID = uls.ModuleID
)
AND uls.UserID in (SELECT UserID FROM @tblUser)



End

/* Populate Unit Pathway using temp-table */
Insert Into @tblUnitPathway
Select UnitID As [UnitID], dbo.udfGetUnitPathway(UnitID) As [Pathway]
From @tblUnit
--Order By tblUnit.UnitID
-- sp_help udfCsvToInt
/* 3.  Get the user''s quiz and lesson status details */
Insert Into @tblResult
(
Unit,
[User],
Course,
Module,
[Sequence],
QuizStatus,
QuizStatusDate,	-- These columns have been reordered
QuizScore,	    -- These columns have been reordered
LessonStatus,
UnitID,
UserID,
UserName,
ExternalID,
CourseID,
ModuleID
)
Select
-- General
up.Pathway 						As Unit, -- Unit Name
u.LastName + '' '' + u.FirstName  As ''User'', -- User Full Name
c.Name			  				As Course, -- Course Name
m.Name			  				As Module, -- Module Name
m.Sequence						As Sequence,

-- Quiz Specific
qs.Status						As QuizStatus,
uqs.DateCreated 			    as QuizStatusDate,	-- These columns have been reordered
uqs.QuizScore 				    as QuizScore,		-- These columns have been reordered

-- Lesson Specific
ls.status 						As LessonStatus,

-- Hidden
u.UnitID						As UnitID,
u.UserID						As UserID,
u.UserName						As UserName,
u.ExternalID						As ExternalID,
c.CourseID						As CourseID,
m.ModuleID						As ModuleID

From @tblUserQuizStatus uqs
Inner Join tblQuizStatus qs On qs.QuizStatusID = uqs.QuizStatusID
Inner Join @tblUser us 	On us.UserID = uqs.UserID
Inner Join tblUser u On u.UserID = us.UserID
INNER Join @tblUnitPathway up On up.UnitID = u.UnitID
INNER Join tblModule m On m.ModuleID = uqs.ModuleID
INNER Join @tblCourse c On c.CourseID = m.CourseID
INNER Join @tblUserLessonStatus uls On uls.UserID = u.UserID And uls.ModuleID = m.ModuleID
INNER Join tblLessonStatus ls On ls.LessonStatusID = uls.LessonStatusID


	Return
End

' 
END

GO





IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcSalt_GrantPermission]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary: 
	Grant all required permission to the website user
	User don''t need to be an dbowner
	Required Permission
	1. Execute permission to all procedures
	2. Select permission to all tables and views that are used in dynamic query
		That permission is not required, all dynamic query need to be reviewed before set this permission

Parameters: 
Returns: 
		
Called By: 
Calls: 

Remarks:

Author: Jack Liu
Date Created: 25th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	


prcSalt_GrantPermission ''Salt_user''


select * from sysobjects
where xtype=''p''
order by name

prcSalt_GrantPermission
*/


ALTER   procedure [prcSalt_GrantPermission]
(
	@login sysname
)
as
declare @userName sysname

declare @name varchar(100), @sql varchar(1000)

set nocount on

--1. Check whether the login has been granted access permission to this database
--If not, grant access permission 
select @userName = u.name 
from sysusers u
	inner join master.dbo.syslogins  l
		on u.sid = l.sid
where u.uid < 16382
	and l.name=@login

if @userName is null
begin
	-- If the db user name is used by other login, drop it
	If exists(select 1 from sysusers where name=@login)
	begin	
		EXEC sp_revokedbaccess @login
	end

	EXEC sp_grantdbaccess @login, @userName output
end


--2. Grant minimum permission	
DECLARE Proc_Cursor CURSOR FOR
select name from sysobjects where xtype=''p'' and Category=0
OPEN Proc_Cursor
FETCH NEXT FROM Proc_Cursor
into @name
WHILE @@FETCH_STATUS = 0
BEGIN
	set @sql=''GRANT execute ON [''+ @name + ''] TO ''+  @userName
	exec(@sql)
	FETCH NEXT FROM Proc_Cursor
	into @name
END
CLOSE Proc_Cursor
DEALLOCATE Proc_Cursor

EXEC sp_droprolemember ''db_owner'', @userName




' 
END
GO

 IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[udfGetUnitIDPathway]') AND xtype in (N'FN', N'IF', N'TF'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfGetUnitPathway    Script Date: 20/04/2004 8:25:57 AM ******/

/*
Summary:
user Defined Function that returns pathway of a specified unit
Returns:
">" delimited pathway of a unit
e.g. "Unit 1 > Unit 2 > Unit 5 > Unit 7"

Called By:

Calls:

Remarks:


Author: Jack Liu
Date Created: 6 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


select  dbo.udfGetUnitIDPathway(9)

select dbo.udfGetUnitPathway(UnitID)
from tblUnit

**/
ALTER  FUNCTION [udfGetUnitIDPathway]
(
@UnitID int
)
RETURNS varchar(4000)
Begin

declare @strPathway varchar(4000)
declare @strHierarchy varchar(500)

select @strHierarchy='',''+hierarchy+'',''
from tblUnit
where UnitID = @UnitID

--Convert unit ID hierarchy ''1,2,5,7'' to pathway ''Unit 1 > Unit 2 > Unit 5 > Unit 7''

select @strPathway=IsNull(@strPathway+'' > '','''')+cast(UnitID as varchar(50))
from tblUnit
where charindex('',''+cast(UnitID as varchar)+'','', @strHierarchy)>0
order by [Level]

--select @strPathway

RETURN @strPathway
End








' 
END
GO



/****** Object:  User Defined Function dbo.udfReport_HistoricAdminSummary    Script Date: 20/04/2004 8:25:58 AM ******/
/*Summary:
Get the Current or historic user module status  based on the search criteria
See the remarks below.
Returns: table
Called By: Current historic Admin Report
Calls:
Remarks:
1. Get User and course List based on search criteria
1.1 Get Unit List
1.1.1 If unit ids are passed in, convert the CSV format to a table
1.1.2 If no unit is selected, get a list of of all units that the admin user has permission to access
1.2 Get User list Based on the first name and last name in the search cirteria
1.3 Get Course list Based on the selected course in the search criteria and Used can select multiple Courses
2. Get the User Quiz and Lesson status up to the effective date
2.1 If there is no effective date is passed in, get the current module status
2.2 If there is effective date, get the module status up to the effective date
3.  Get a list of the user's quiz and lesson historic status
Author: Jack Liu
Date Created: 1 Mar 2004
Modification History
-----------------------------------------------------------
v#	Author		Date				Description
#1.1	Usman Tjiudri	10/11/2005	Performance tuning:
- use temp-table to populate Unit Pathway
- join the temp-table to populate tblResult
instead of using udfGetUnitPathway function in the join.
#2.0	Serguei Chkaroupine 28/02/06 -New insert statement for histric admin report
- it will insert all lessons that match current quizmodule pair
- Current admin report performance fix. Added WHERE statement to
most of the insert statements.
#3	Mark Donald	27/07/2009			add userName and userEmail params
#4	William Tio	01/12/2009			
- remove the wrong logic to exclude the user quiz/lesson status
- replace with 'not exists'

select * from dbo.udfReport_HistoricAdminSummary(3, '', '1,2,3,4','','',NULL,NULL,'20040222',4)
--------------------
**/

ALTER                Function [dbo].[udfReport_HistoricAdminSummaryOptimised]
(
@organisationID 	Int,
@unitIDs			Varchar(8000),
@courseIDs			Varchar(8000),
@userFirstName		Varchar(50),
@userLastName		Varchar(50),
@userName			Varchar(100),
@userEmail			Varchar(100),
@effectiveDate 		Datetime,
@adminUserID		Int,
@classificationID 	Int,
@defaultDate		DateTime,
@inclInactive		int
)
Returns @tblResult Table
(
-- General
Unit			nVarchar(200),
[User]			nVarchar(100),
Course			nVarchar(100),
Module			nVarchar(100),
[Sequence]		Int,
-- Quiz Specific
QuizStatus		Varchar(50),
QuizScore		Int,
QuizStatusDate	Datetime,
-- Lesson Specific
LessonStatus	Varchar(50),
-- Hidden
UnitID			Int,
UserID			Int,
UserName		nVarchar(100),
ExternalID		nVarchar(50),
CourseID		Int,
ModuleID		Int,
Active	int
)
As Begin

--Variables declarations
DECLARE @UserTypeID 	INT
DECLARE @tblUnit 				Table(UnitID INT PRIMARY KEY(UnitID))
DECLARE @tblUser 				Table(UserID INT, UnitID INT, Active INT)
DECLARE @tblCourse 				Table(CourseID INT, [Name] NVARCHAR(100) PRIMARY KEY(CourseID))
DECLARE @CoursesWithAccess 		TABLE (CourseID INT PRIMARY KEY(CourseID))
DECLARE @UserModuleWithAccess 	TABLE(UserID INT, ModuleID INT, UnitID INT PRIMARY KEY(UserID, ModuleID, UnitID))
DECLARE @AllModules 			TABLE(ModuleID INT PRIMARY KEY(ModuleID))
DECLARE @tblUserQuizStatus 		Table
(
[UserQuizStatusID] [int] Not Null,
[UserID] [int] Not Null,
[ModuleID] [int] Not Null,
[QuizStatusID] [int] Not Null,
[QuizScore] [int] Null,
[DateCreated] [datetime] Not Null
)
DECLARE @tblUserLessonStatus 	Table
(
[UserLessonStatusID] [int] ,
[UserID] [int] ,
[ModuleID] [int] ,
[LessonStatusID] [int] ,
[DateCreated] [datetime]
)
DECLARE @vwUserModuleAccess table
(
UserID INT not null,
FirstName varchar(255),
LastName varchar(255),
UnitID INT,
OrganisationID INT,
ModuleID INT,
CourseID INT,
CourseName nvarchar(100),
[Name] nvarchar(100),
Sequence INT,
Description nvarchar(1000)
)

DECLARE @tblOrganisationCourseAccess table
(
OrganisationID int,
GrantedCourseID int
)
---------------------------------------------------------------------------------------------

--set the default date depending on effective date
set @defaultdate = coalesce (@effectivedate,@defaultdate)
---------------------------------------------------------------------------------------------

--Check If Unit ID is specified
IF @unitIDs IS NULL
BEGIN
--Check User Type
SELECT
@UserTypeID = UserTypeID
FROM
tblUser
WHERE UserID = @adminUserID

--Get all units in Organisation if user is Salt Admin(1) or Org admin (2)
IF (@UserTypeID = 1 Or @UserTypeID = 2)
BEGIN
INSERT INTO
@tblUnit (UnitID)
SELECT
UnitID
FROM
tblUnit
WHERE OrganisationID = @OrganisationID
END

--Get units that the user is admministrator if user is Unit Admin(3)
IF (@UserTypeID = 3)
BEGIN
INSERT INTO
@tblUnit (UnitID)
SELECT
U.UnitID
FROM
tblUnit U INNER JOIN tblUnitAdministrator UA ON
UA.UnitID = U.UnitID AND
UA.UserID = @adminUserID
WHERE
U.OrganisationID = @OrganisationID
END
END
ELSE
BEGIN
--Seperate comma seperated values as Table rows
INSERT INTO @tblUnit SELECT * FROM  dbo.udfCsvToInt(@unitIDs)
END
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
--FirstName, Last Name, etc specified in search criteria
IF (@userFirstName IS NULL) 	SET @userFirstName = ''
IF (@userLastName IS NULL) 		SET @userLastName = ''
IF (@userName IS NULL) 			SET @userName = ''
IF (@userEmail IS NULL) 		SET @userEmail = ''

INSERT INTO
@tblUser (UserID, UnitID, Active)
SELECT DISTINCT
U.UserID, U.UnitID, U.Active
FROM
tblUser U INNER JOIN @tblUnit UN ON	U.UnitID = UN.UnitID
and datediff(day,U.datecreated,@defaultdate)>=0-- created on or b4 specified date
LEFT JOIN tblUserClassification UC ON UC.UserID  = U.UserID
WHERE
U.FirstName Like '%' + @userFirstName + '%' AND
LastName Like '%' + @userLastName + '%' AND
UserName Like '%' + @userName + '%' AND
Email Like '%' + @userEmail + '%' AND
--AND have the Custom Classification option
--If classification is Any (0), This will find users of any Custom Classification
((@classificationID = 0) OR (UC.classificationID = @classificationID)) AND
--inclInactive = 0: do not include inactive user
--inclInactive = 1: include inactive user
(U.Active = CASE @inclInactive WHEN 0 THEN 1 ELSE U.Active END) AND
(U.OrganisationID = @OrganisationID)

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
-- Search criteria contains Course ID's
INSERT INTO
@tblCourse (CourseID, [Name])
SELECT
C.CourseID, C.[Name]
FROM
dbo.udfCsvToInt(@courseIDs) CA INNER JOIN tblCourse C ON
CA.intValue = C.CourseID AND C.Active = 1

-- added to deal with past courses - adds past course to intermediate @tblOrganisationCourseAccess table
-- to mimic it being a current course so results will be returned
insert into
@tblOrganisationCourseAccess (OrganisationID, GrantedCourseID)
select
@Organisationid, C.CourseID
from
dbo.udfCsvToInt(@courseIDs) CA inner join tblCourse C on
CA.intValue = C.CourseID and C.Active = 1

INSERT INTO @vwUserModuleAccess   SELECT   tU.UserID, tU.FirstName, tU.LastName, tU.UnitID, tU.OrganisationID, tM.ModuleID, tM.CourseID, tC.Name AS CourseName, tM.Name, tM.Sequence,
tM.Description
FROM         tblUser AS tU INNER JOIN
@tblUser tbU on tbU.UserID = tU.UserID
inner join
@tblOrganisationCourseAccess AS tOCA ON tOCA.OrganisationID = tU.OrganisationID INNER JOIN
tblCourse AS tC ON tC.CourseID = tOCA.GrantedCourseID INNER JOIN
tblModule AS tM ON tM.CourseID = tC.CourseID AND tM.Active = 1 LEFT OUTER JOIN
tblUserModuleAccess AS tUsrMA ON tUsrMA.UserID = tU.UserID AND tUsrMA.ModuleID = tM.ModuleID LEFT OUTER JOIN
tblUnitModuleAccess AS tUnitMA ON tUnitMA.UnitID = tU.UnitID AND tUnitMA.DeniedModuleID = tM.ModuleID
WHERE     tM.CourseID in (SELECT courseid from @tblCourse ) AND (tU.UnitID IS NOT NULL) AND (tUnitMA.DeniedModuleID IS NULL) AND (tUsrMA.ModuleID IS NULL) OR
(tUsrMA.Granted = 1)
--select * from @vwUserModuleAccess where UnitID is null

INSERT INTO @UserModuleWithAccess
SELECT DISTINCT UserID, ModuleID, UnitID FROM @vwUserModuleAccess where UnitID is not null

INSERT INTO @tblUserQuizStatus
(
[UserQuizStatusID],
[UserID],
[ModuleID],
[QuizStatusID],
[QuizScore],
[DateCreated]
)
SELECT
A.[UserQuizStatusID],
A.[UserID],
A.[ModuleID],
A.[QuizStatusID],
A.[QuizScore],
A.[DateCreated]
FROM
(
SELECT
A.UserID, A.ModuleID, MAX(B.UserQuizStatusID) AS 'LatestQuizID'
FROM
@UserModuleWithAccess A, tblUserQuizStatus B
WHERE
A.UserID = B.UserID AND A.ModuleID = B.ModuleID AND B.QuizStatusID <> 0
AND DateDiff(day, B.DateCreated, @effectiveDate)>=0
GROUP BY
A.UserID, A.ModuleID
) B, tblUserQuizStatus A, @tblUser C
WHERE
A.UserQuizStatusID = B.LatestQuizID AND B.UserID = C.UserID AND A.UserID = C.UserID
-- li June 2008:
-- User who has access to a module but doesn't have a record in tblUserQuizStatus is a new user
-- this logic will include new user in the current and historic admin report before user quiz status
-- is updated by overnight job

INSERT INTO @tblUserQuizStatus
(
[UserQuizStatusID],
[UserID],
[ModuleID],
[QuizStatusID],
[QuizScore],
[DateCreated]
)
SELECT
0, -- UserQuizStatusID
A.[UserID],
A.[ModuleID],
1, -- QuizStatus: Not Started
null, -- QuizScore
@defaultDate -- DateCreated (here set to @defaultdate which is passed in as getDate())
FROM @UserModuleWithAccess A
join  @tblUser B on A.UserID = B.UserID
-- User doesn't have quiz activities
/* WT: this part is replaced with not exists, the logic below will subtract userid with moduleid
where  A.UserID  + '-' + A.MODULEID NOT IN
(	Select D.UserID + '-' + D.Moduleid
from @tblUserQuizStatus D
where datediff(day, d.datecreated, @defaultdate)>=0)*/
where not exists
(	Select D.UserID, D.Moduleid
	from @tblUserQuizStatus D
	where datediff(day, d.datecreated, @defaultdate)>=0
	and D.Userid=B.userid and D.moduleid=A.moduleid
)
-- end logic for including new user's quiz status



Insert Into @tblUserLessonStatus
(
[UserLessonStatusID],
[UserID],
[ModuleID],
[LessonStatusID],
[DateCreated]
)
Select
A.[UserLessonStatusID],
A.[UserID],
A.[ModuleID],
A.[LessonStatusID],
A.[DateCreated]
FROM
(
SELECT
B.UserID, B.ModuleID, MAX(B.UserLessonStatusID) AS 'LatestLessonStatusID'
FROM
@UserModuleWithAccess A, tblUserLessonStatus B
WHERE
A.UserID = B.UserID AND A.ModuleID = B.ModuleID AND
DateDiff(day, B.DateCreated, @effectiveDate)>=0 AND
B.LessonStatusID <> 0 --Unassigned
GROUP BY
B.UserID, B.ModuleID
) B, tblUserLessonStatus A, @tblUser C
WHERE
A.UserLessonStatusID = B.LatestLessonStatusID AND B.UserID = C.UserID AND A.UserID = C.UserID

-- start logic for including new user's lesson status
INSERT INTO @tblUserLessonStatus
(
[UserLessonStatusID],
[UserID],
[ModuleID],
[LessonStatusID],
[DateCreated]
)
SELECT
0, -- UserLessonStatusID
A.[UserID],
A.[ModuleID],
1, -- LessonStatus: Not Started
@defaultDate -- DateCreated (here set to @defaultdate which is passed in as getDate())
FROM @UserModuleWithAccess A
join  @tblUser B on A.UserID = B.UserID
where 
-- User doesn't have lesson activities for the date entered
/* WT: this part is replaced with not exists, the logic below will subtract userid with moduleid
A.UserID + '-' + A.Moduleid NOT IN
(	Select D.UserID + '-' + D.Moduleid
from @tblUserLessonStatus D
where datediff(day, d.datecreated, @defaultdate)>=0 )*/
not exists
(	Select D.UserID, D.Moduleid
	from @tblUserLessonStatus D
	where datediff(day, d.datecreated, @defaultdate)>=0
	and D.Userid=B.userid and D.moduleid=A.moduleid
)
-- end logic for including new user's lesson status

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
-- This part fixes migration issue (note this will affect historic admin report only as it does supply effective date)
-- It will insert userid, moduleid and earliest lesson status for each quiz that does not have lesson record yet
-- into @tblUserLessonStatus
Insert Into @tblUserLessonStatus
(
[UserLessonStatusID],
[UserID],
[ModuleID],
[LessonStatusID],
[DateCreated]
)
SELECT 1,
A.[UserID],
A.[ModuleID],
B.LessonStatusID,
A.DateCreated
FROM (
SELECT
A.UserID, A.ModuleID, MIN(A.DateCreated) AS 'DateCreated'
FROM
tblUserLessonStatus A, @tblUser B
WHERE
A.UserID = B.UserID
GROUP BY
A.UserID, A.ModuleID
) A , tblUserLessonStatus B WHERE

A.UserID = B.UserID AND A.ModuleID = B.ModuleID AND A.DateCreated = B.DateCreated AND
(CAST(A.UserID AS VARCHAR(10)) + CAST(A.ModuleID AS VARCHAR(10)))
NOT IN (SELECT CAST(A.UserID AS VARCHAR(10)) + CAST(A.ModuleID AS VARCHAR(10)) FROM @tblUserLessonStatus)


---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
Insert Into @tblResult
(
Unit,
[User],
Course,
Module,
[Sequence],
QuizStatus,
QuizStatusDate,	-- These columns have been reordered
QuizScore,	    -- These columns have been reordered
LessonStatus,
UnitID,
UserID,
UserName,
ExternalID,
CourseID,
ModuleID
)
Select distinct
-- General
up.HierarchyName 				As Unit, -- Unit Name
[User] = CASE u.Active when 0 then u.LastName + ' ' + u.FirstName + '(i)' ELSE u.LastName + ' ' + u.FirstName End , -- User Full Name
c.Name			  				As Course, -- Course Name
m.Name			  				As Module, -- Module Name
m.Sequence						As Sequence,
-- Quiz Specific
qs.Status						As QuizStatus,
uqs.DateCreated 			    as QuizStatusDate,	-- These columns have been reordered
uqs.QuizScore 				    as QuizScore,		-- These columns have been reordered
-- Lesson Specific
ls.status 						As LessonStatus,
-- Hidden
u.UnitID						As UnitID,
u.UserID						As UserID,
u.UserName						As UserName,
u.ExternalID						As ExternalID,
c.CourseID						As CourseID,
m.ModuleID						As ModuleID
--u.Active						As Active
From @tblUserQuizStatus uqs
Inner Join tblQuizStatus qs On qs.QuizStatusID = uqs.QuizStatusID
inner Join @tblUser us 	On us.UserID = uqs.UserID
Inner Join tblUser u On u.UserID = us.UserID
INNER Join tblUnitHierarchy up On up.UnitID = u.UnitID
INNER Join tblModule m On m.ModuleID = uqs.ModuleID
INNER Join @tblCourse c On c.CourseID = m.CourseID
INNER Join @tblUserLessonStatus uls On uls.UserID = u.UserID And uls.ModuleID = m.ModuleID
INNER Join tblLessonStatus ls On ls.LessonStatusID = uls.LessonStatusID
where @effectivedate is null or (datediff(day,uqs.datecreated,@effectivedate)>=0 and datediff(day, uls.datecreated, @effectivedate)>=0)
RETURN
END
GO








/****** Object:  StoredProcedure [dbo].[prcUser_Import]    Script Date: 07/15/2008 10:07:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prcUser_Import]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prcUser_Import]
GO

/*
Summary: Insert/Update the details of tblUser table
Parameters: 
		@userXML text The XML document containing the User data.
		@ID Integer ID of either the Organisation or Unit
		@hierachy VarChar(12) hierachy where the call to upload useres was made from. can only be Organisation or Unit.
		@userID Integer = null -- ID of user inporting the xmlData
Returns: 
		
		
Called By: 
		User.cs
Calls: 
		
Author: Li Zhang
Date Created: July 2008

Modification History
-----------------------------------------------------------
v#	Author		Date		Description

*/

Create    Procedure prcUser_Import
(
	@userName nvarchar(200),
	@password nvarchar(100),
	@firstName nvarchar(200),
	@lastName nvarchar(200),
	@email nvarchar(255),
	@unitID int,
	@classificationName nvarchar(100),
	@classificationOption nvarchar(100),
	@externalID	nvarchar(100),
	@archival	bit,
	@isUpdate bit,
	@uniqueField int,
	@userID int,
	@orgID int
)

As

Set NoCount On

Set Xact_Abort On
Begin Transaction

	
	--Declarations
	Declare @uniqueField_Email int 
	Declare @uniuqeField_Username int

	set @uniqueField_Email = 1
	set @uniuqeField_Username = 2

	--update 
	IF (@isUpdate = 1)
	BEGIN
	
		IF (@uniqueField = @uniqueField_Email)
		BEGIN
			update tblUser
			set UserName = ISNULL(@userName,u.UserName),
				FirstName = ISNULL(@firstName, u.FirstName),
				LastName = ISNULL(@lastName, u.LastName),
				Password = ISNULL(@password, u.password),
				ExternalID = ISNULL(@externalID, u.externalID),
				UnitID = ISNULL(@unitID, u.UnitID),
				Active = Case @archival when 1 then 0 -- archive user = true
										when 0 then 1 -- archive user = false
										else u.Active end,--remain unchanged
				DateArchived = Case @archival when 1 then getdate()
												when 0 then null
												else u.DateArchived end,
				DateUpdated = getdate(),
				UpdatedBy = @userID
			FROM tblUser u
			WHERE
				u.Email = @email
				and 
				u.OrganisationID = @orgID
		END
	
		IF (@uniqueField = @uniuqeField_Username)
		BEGIN
			update tblUser
			set FirstName = ISNULL(@firstName, u.FirstName),
				LastName = ISNULL(@lastName, u.LastName),
				Password = ISNULL(@password, u.password),
				Email = ISNULL(@Email, u.Email),
				ExternalID = ISNULL(@externalID, u.externalID),
				UnitID = ISNULL(@unitID, u.UnitID),
				Active = Case @archival when 1 then 0 
										when 0 then 1
										else u.Active end,
				DateArchived = Case @archival when 1 then getdate()
												when 0 then null
												else u.DateArchived end,
				DateUpdated = getdate(),
				UpdatedBy = @userID
			FROM tblUser u
			WHERE
				u.Username = @username
				and 
				u.OrganisationID = @orgID
		END
	END
	IF @isUpdate = 0
	BEGIN
		insert into tblUser
				(
					Username,
					Password,
					Firstname,
					Lastname,
					Email,
					ExternalID,
					OrganisationID,
					UnitID,
					CreatedBy,
					Active,
					DateArchived,
					NewStarter
				) values
				(
					@username,
					@password,
					@firstname,
					@lastname,
					@email,
					@externalID,
					@orgID,
					@unitID,
					@userID,
					case @archival when 1 then 0 else 1 end,
					case @archival when 1 then getdate() else null end,
					1
				)
		declare @t int
		select @t = UserID from tblUser where Username = @username and Email = @email

		--Insert the classification data into the tblUserCalssification table.
		Insert Into tblUserClassification
		(
			UserID,
			ClassificationID
		)
		select
			@t,
			cls.ClassificationID
		From
			tblClassificationType As c, tblClassification As cls
		where c.Name = @classificationName
					And (c.OrganisationID = @orgID)
					and cls.ClassificationTypeID = c.ClassificationTypeID
					AND cls.Value = @classificationOption
					And (cls.Active = 1)
					
		
		--insert course licencing for the imported user
		INSERT INTO tblCourseLicensingUser(CourseLicensingID, UserID) 
			SELECT 		DISTINCT 
				tblCourseLicensing.CourseLicensingID, 
				vwUserModuleAccess.UserID
				
			FROM
				tblCourseLicensing 
				INNER JOIN vwUserModuleAccess ON tblCourseLicensing.CourseID = vwUserModuleAccess.CourseID 
					AND tblCourseLicensing.OrganisationID = vwUserModuleAccess.OrganisationID 
				INNER JOIN tblUser ON vwUserModuleAccess.UserID = tblUser.UserID 
				LEFT OUTER JOIN	tblCourseLicensingUser ON tblUser.UserID = tblCourseLicensingUser.UserID 
					AND tblCourseLicensing.CourseLicensingID = tblCourseLicensingUser.CourseLicensingID
			WHERE 
				tblCourseLicensing.DateStart <= GETDATE() 
				AND tblCourseLicensing.DateEnd >= GETDATE() 
				AND tblCourseLicensingUser.CourseLicensingID IS NULL 
				AND tblUser.userid = @t


		-- Get ProfilePeriodIDs for Organisation
		create table #ProfilePeriod
		(
			ProfilePeriodID int
		)
		
		insert into #ProfilePeriod
			select ProfilePeriodID 
			from tblProfilePeriod  pp 
			join tblprofile p 
			on pp.profileid = p.profileid 
			where p.organisationid = @orgID
		
		
		-- insert user into profileperiodaccess against all profileperiodids
		-- for the organisation
		insert into tblUserProfilePeriodAccess
		select ProfilePeriodID, @t, 0 from #ProfilePeriod

		drop table #ProfilePeriod

		-- Get Policies for Organisation
		create table #Policy
		(
			PolicyID int
		)
		
		insert into #Policy
			select PolicyID
			from tblPolicy 
			where OrganisationID = @orgID
			and deleted = 0

		-- insert user  policy access for all policies associated with organisation
		insert into tbluserpolicyaccess (PolicyID, UserID,Granted)
		select PolicyID, @t, 0 from #Policy
		
		-- insert user policy acceptance for all policies for this org
		insert into tblUserPolicyAccepted (PolicyID, UserID, Accepted)
		select PolicyID, @t, 0 from #Policy

		drop table #Policy
	END
commit

GO

