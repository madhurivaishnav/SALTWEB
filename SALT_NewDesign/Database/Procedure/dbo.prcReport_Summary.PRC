SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_Summary]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
This Report provides a high level summary information.
It shows how many users in each unit are complete or incomplete in each course.
The results can be views as a bar graph

Called By:
SummaryReport in Reporting Services

Calls:
udfReport_CompletUsers_logic
udfReport_IncompletUsers_logic
Remarks:


Author:
Jack Liu
Date Created: 31 March 2005

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
Mark Donald	23/07/2009		Add @classificationID parameter and use it
to filter insert into #result table

prcReport_Summary 8, ''19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,84'' ,7, null

prcReport_Summary 8, ''19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,84'' ,7, ''20041130''

--------------------

**/

CREATE  Proc [dbo].[prcReport_Summary]
(
@organisationID Integer,	-- Organisation of the current user
@unitIDs varchar(max) = '''',	-- string of unit id''s
@courseID int,			-- course ID to restrict search to
@effectiveDateOrg datetime = Null,	-- Effective date as at when to run the report
@classificationID int
)

AS
------------------------------------------
Set Nocount On
DECLARE @effectiveDate 		datetime
SET @effectiveDate = dbo.udfDaylightSavingTimeToUTC(@effectiveDateOrg,@OrganisationID)
CREATE TABLE #result
(
UnitID		Int,
UnitPathway 	nVarchar(4000),
Complete	int,
Incomplete	int
)
declare @rowCount as integer

insert into #result
select
UnitID,
min(UnitPathway) as UnitPathway,
sum(Complete) as Complete,
sum(Incomplete) as Incomplete
from (Select
UnitID,
UnitPathWay,
1 as Complete,
0 as Incomplete,
UserID
From	dbo.udfReport_CompleteUsersLogic(@organisationID, @unitIDs, @courseID,@effectiveDate)
Union all
Select
UnitID,
UnitPathWay,
0 as Complete,
1 as Incomplete,
UserID
from  dbo.udfReport_IncompleteUsersLogic(@organisationID, @unitIDs, @courseID,@effectiveDate)
) as Users
LEFT JOIN tblUserClassification c ON c.UserID  = Users.UserID
WHERE
((@classificationID =0) OR (classificationID = @classificationID))
--If classification is Any (0), This will find users of any Custom Classification
group by UnitID
Order By UnitPathway

set @rowCount=@@rowcount

if (@rowCount>1)
begin
insert into #result
select 0,
''Total'',
Sum(Complete),
Sum(Incomplete)
from #result

set @rowCount = @rowCount+1
end

select *,
@rowCount  as Count
from #result

drop table #result
' 
END
GO
