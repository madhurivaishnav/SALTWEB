SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_AdminSummaryReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*Summary:
This will show the Current or historic Admin Report

See the remarks below.

Returns:

Called By: Current Admin Report
Calls:

Remarks:

1. Get the Current or historic user module status  based on the search criteria

2.  Group and sort the result
2.1    Group by Unit_User
Columns output:
Unit,
[User],
Course,
Module,
QuizStatus,
QuizScore,
QuizStatusDate,
LessonStatus

2.2    Group by Course
Columns output:
Course,
Module,
Unit,
[User],
QuizStatus,
QuizScore,
QuizStatusDate,
LessonStatus

then sorted by, either:
QuizScore
Last Name
QuizStatusDate


Author: Jack Liu
Date Created: 1 Mar 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	Mark Donald	27/07/2009		add userName and userEmail params
#2  J hedlefs   09/06/2011      timezone


prcReport_AdminSummaryReport 3, '''', ''1,2,3,4'','''','''',NULL,NULL,''20040222'',''Unit_User'','''',4
prcReport_AdminSummaryReport 3, '''', ''1,2,3,4'','''','''',NULL,NULL,null,''Course'',''QuizDate'',4

--------------------

**/

CREATE      procedure [prcReport_AdminSummaryReport]
(
@organisationID 	int,
@unitIDs		Varchar(MAX),
@courseIDs		Varchar(8000),
@userFirstName		nVarchar(50),
@userLastName		nVarchar(50),
@userName			nVarchar(100),
@userEmail			nVarchar(100),
@effectiveDateOrg 		datetime,
@groupBy		nVarchar(50),
@sortBy			nVarchar(50),
@adminUserID		int,
@classificationID 	int,
@inclInactive	int -- Flag for including inactive user or not
--@inclInactive = 0: do not include inactive users
--@inclInactive = 1: include inactive users
)
As
set nocount on
/*
1. Get the Current or historic user module status  based on the search criteria
Unit,
[User],
Course,
Module,
QuizStatus,
QuizScore,
QuizStatusDate,
LessonStatus,
UnitID,
UserID,
CourseID,
ModuleID
*/

DECLARE @defaultDate DATETIME
SET @defaultDate = getUTCdate()

if  not ( @sortBy  = ''QUIZ_SCORE'' or @sortBy  = ''QUIZ_DATE'' or @sortBy  = ''LAST_NAME'')
Begin
-- sort order is not QUIZ_SCORE, QUIZ_DATE or LAST_NAME
set @sortBy = ''LAST_NAME''
End
Declare @tblResult TABLE
(
-- General
Unit		nVarchar(200),
[User]		nVarchar(100),
Course		nVarchar(100),
Module		nVarchar(100),
[Sequence]  Int,
-- Quiz Specific
QuizStatus	nvarchar(50),
QuizScore	Int,
QuizStatusDate	DateTime,
-- Lesson Specific
LessonStatus	nvarchar(50),
-- Hidden
UnitID		Int,
UserID		Int,
UserName	nvarchar(100),
ExternalID	nvarchar(50),
CourseID	Int,
ModuleID	Int,
Active		Int,
ClassificationName nvarchar(50),  -- This may need to be changed when multiple classifications become needed.
ClassificationValue nvarchar(50)
)
Insert Into
@tblResult
select
Results.*,
tblClassificationType.Name,
tblClassification.Value
from
-- ***************************** Timezone conversion is done in the UDF **********************************************
dbo.udfReport_HistoricAdminSummaryOptimised(@organisationID,@unitIDs,@courseIDs,@userFirstName,@userLastName,@userName,@userEmail,@effectiveDateOrg,@adminUserID,@classificationID,@defaultDate,@inclInactive)
-- *******************************************************************************************************************
as Results
left join
tblUserClassification on tblUserClassification.UserID = Results.UserID
left join
tblClassification on tblClassification.ClassificationID = tblUserClassification.ClassificationID
left join
tblClassificationType on tblClassification.ClassificationTypeID = tblClassificationType.ClassificationTypeID
/*
2.  Group and sort the result
2.1    Group by Unit/User
Columns output:
Unit,
[User],
Course,
Module,
QuizStatus,
QuizScore,
QuizStatusDate,
LessonStatus
*/
if (@groupBy = ''Unit_User'')
begin
select
Unit,
[User],
Course,
Module,
QuizStatus,
QuizScore,
QuizStatusDate,
LessonStatus,
UnitID,
UserID,
UserName,
ExternalID,
CourseID,
ModuleID,
Active,
ClassificationName,
ClassificationValue
from @tblResult
order by Unit, UnitID, [User], userID,  Course, CourseID, [Sequence]
end
/*
2.2    Group by Course
Columns output:
Course,
Module,
Unit,
[User],
QuizStatus,
QuizScore,
QuizStatusDate,
LessonStatus
then sorted by, either:
QuizScore
Last Name
QuizStatusDate
*/
else -- (@groupBy = ''Course'')
begin
if (@sortBy = ''QUIZ_SCORE'')
begin
select
*
from @tblResult
order by Course, CourseID, [Sequence], Unit, UnitID, QuizScore desc,[user]
end
else if (@sortBy = ''QUIZ_DATE'')
begin
select
*
from @tblResult
order by Course, CourseID, [Sequence], Unit, UnitID, QuizStatusDate desc,[user]
end
else -- order by ''LAST_NAME''
begin
select
*
from @tblResult
order by Course, CourseID, [Sequence], Unit, UnitID, [user]
end
end


' 
END
GO
