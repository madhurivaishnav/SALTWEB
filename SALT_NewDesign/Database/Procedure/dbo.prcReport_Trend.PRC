SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_Trend]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:
refer to section 16.5.5.2 of Func. Spec. returns avg. score
and num of user per module for a selected course and unit

Called By: Report.cs, TrendReport.aspx.cs
Calls: udfCsvToInt

Remarks: Raises an error if a parameter is null

Author: Claude Nehme
Date Created: 16th of February 2004

prcReport_Trend "1,2,3", 1,1

Modification History
-----------------------------------------------------------
v#	Author			Date			Description
#1	Peter Kneale 	03/03/04		Added ''Passed or Failed Users only''
#2	Jack Liu		05/03/04		Remove the hierarchy unit, change to flat file
#3	Jack Liu		14/09/05		Order the result by Module
and order by most recent(the last recorded status with specified passmark)
#4	Usman Tjiudri	11 Nov 2005		Include BoldMark indicator for the latest PassMark record.
#5	j hedlefs		09/06/2011		timezone

*/

CREATE     Procedure [dbo].[prcReport_Trend]
(
@organisationID integer = null,
@unitIDs varchar(max) = null,
@courseID integer = null,
@fromDateOrg datetime,
@toDateOrg datetime
)

as
DECLARE @fromDate 		datetime
DECLARE @toDate 		datetime
SET @fromDate = dbo.udfDaylightSavingTimeToUTC(@fromDateOrg,@OrganisationID)
SET @toDate = dbo.udfDaylightSavingTimeToUTC(@toDateOrg,@OrganisationID)

Set NoCount On

If @courseID Is Null
Begin
Raiserror(''The Parameter @courseID was null.  @courseID does not accept Null values.'', 16, 1)
Return
End

-- Temporary table to store the query for further data manipulation.
Declare @tblResult Table
(
Unit		nVarchar(200),
UnitID		Int,
Course		nVarchar(100),
CourseID	Int,
Module		nVarchar(100),
ModuleID	Int,
NumOfUsers	Int,
QuizCount int,
QuizPassMark	Int,
AvgScore	Int,
LastUserQuizStatusID Int,
BoldMark	Bit -- Indicator whether current record should be bold or not
)

If @unitIDs Is Null
Begin
Insert Into @tblResult
(
Unit,
UnitID,
Course,
CourseID,
Module,
ModuleID,
NumOfUsers,
QuizCount,
QuizPassMark,
AvgScore,
LastUserQuizStatusID
)
Select 	dbo.udfGetUnitPathway(un.UnitID) as Unit,
un.UnitID,
min(co.Name) as  Course,
co.CourseID,
min(mo.Name) as Module,
mo.ModuleID,
count(DISTINCT usr.UserID) as NumOfUsers,
count(usr.UserID) as QuizCount,
uqs.QuizPassMark,
avg(uqs.QuizScore) as AvgScore,
max(uqs.UserQuizStatusID) as LastUserQuizStatusID
From
tblUser usr
inner join tblUnit un on un.UnitID = usr.UnitID
inner join tblUserQuizStatus uqs on usr.UserID = uqs.UserID
and (uqs.QuizStatusID = 2 or uqs.QuizStatusID = 3) 	-- Passed or Failed Users only
and uqs.DateCreated between @fromDate and dateadd(dd,1,@toDate)
inner join tblModule mo on mo.ModuleID = uqs.ModuleID
inner join tblCourse co on mo.CourseID = co.CourseID and co.CourseID = @courseID
Where
usr.UnitID is not null
and 	usr.Active = 1
and 	un.OrganisationID = @organisationID
Group By
un.UnitID,
co.CourseID,
mo.ModuleID,
uqs.QuizPassMark
Order By
Unit,
Course,
Module,
LastUserQuizStatusID desc

End
Else
Begin
Insert Into @tblResult
(
Unit,
UnitID,
Course,
CourseID,
Module,
ModuleID,
NumOfUsers,
QuizCount,
QuizPassMark,
AvgScore,
LastUserQuizStatusID
)
Select	dbo.udfGetUnitPathway(un.UnitID) as Unit,
un.UnitID,
min(co.Name) as  Course,
co.CourseID,
min(mo.Name) as Module,
mo.ModuleID,
count(DISTINCT usr.UserID) as NumOfUsers,
count(usr.UserID) as QuizCount,
uqs.QuizPassMark,
avg(uqs.QuizScore) as AvgScore,
max(uqs.UserQuizStatusID) as LastUserQuizStatusID
From
tblUser usr
inner join tblUnit un on un.UnitID = usr.UnitID
inner join dbo.udfCsvToInt(@unitIDs) as selectedUnit on selectedUnit.IntValue= un.UnitID
inner join tblUserQuizStatus uqs on usr.UserID = uqs.UserID
and (uqs.QuizStatusID = 2 or uqs.QuizStatusID = 3) 	-- Passed or Failed Users only
and uqs.DateCreated between @fromDate and dateadd(dd,1,@toDate)
inner join tblModule mo on mo.ModuleID = uqs.ModuleID
inner join tblCourse co on mo.CourseID = co.CourseID and co.CourseID = @courseID
Where
usr.UnitID is not null
and 	usr.Active = 1
Group By
un.UnitID,
co.CourseID,
mo.ModuleID,
uqs.QuizPassMark
Order By
Unit,
Course,
Module,
LastUserQuizStatusID desc
End

-- Update BoldMark field for group of records (by Unit, Course and Module) with more than one version of pass mark.
Update @tblResult
Set BoldMark = 1
Where LastUserQuizStatusID In (
Select tb.QuizStatusID From
(Select UnitID, CourseID, ModuleID, Max(LastUserQuizStatusID) As QuizStatusID from @tblResult Group by UnitID, CourseID, ModuleID having count(*) > 1) As tb
)

-- Returning records to callers
Select * From @tblResult

' 
END
GO
