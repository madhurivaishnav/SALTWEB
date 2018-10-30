SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_CompletedUsersDetails]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:
Given an list of incomplete users, derive all of the module status explaining why the users
are incomplete

Returns:
Table of Incomplete Users with the module status details

Called By:
Reporting/Advanced/CompletedUsersReport.aspx

Calls:
udfReport_IncompletUsers_logic

Remarks:


Author:
Yoppy Suwanto

Date Created: 05 Mar 2008

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1  Mark Donald	24/07/2009		Add LastCompleted col to selects

prcReport_CompletedUsersDetails @unitIDs=''1,2,3,4'' , @courseID=1 , @completed = 0
prcReport_CompletedUsersDetails @organisationid=11, @unitIDs=null , @courseID=53, @effectivedate = null

--------------------

**/
CREATE            Proc [dbo].[prcReport_CompletedUsersDetails]
(
@organisationID Integer,	-- Organisation of the current user
@unitIDs varchar(max) = '''',	-- string of unit ids
@courseID int,					-- course ID to restrict search to
@effectiveDateOrg datetime = Null	-- Effective date as at when to run the report
--@completed bit = 0 			-- always run for incomplete status
)
AS
begin
/*
declare @orgid int
declare @courseid int
declare @unitids varchar(8000)
declare @effectivedate datetime

set @orgid = 11
set @courseid = 53
set @unitids = null
set @effectivedate = ''4 August 2007''
*/

DECLARE @effectiveDate DateTime
SET @effectiveDate = dbo.udfDaylightSavingTimeToUTC(@effectiveDateOrg,@OrganisationID)

if (@effectiveDateOrg is null)
/*
-- Report on current latest date
*/
Begin

select max(userquizstatusid) userquizstatusid
into #tmpUserQuizStatus
from tblUserQuizStatus
where userid in (select userid from tblUser where organisationid = @organisationID)
and moduleid in (select moduleid from tblModule where courseid = @courseid)
group by userid, moduleid

Select
IU.userID
, IU.unitID
, IU.FirstName
, IU.LastName
, IU.UnitPathway
, case when lastcompleted is null then ''Never'' else convert(varchar(10),dbo.udfUTCtoDaylightSavingTime(LastCompleted,@OrganisationID),103) end  as LastCompleted
, IU.Username
, IU.Email
, IU.ExternalID
, tM.[name] as ''Module''
, tQS.status
--,tM.moduleid
--,tUQS.quizstatusid
--,tUQS.userquizstatusid

From
dbo.udfReport_IncompleteUsersLogic(@organisationID, @unitIDs, @courseID,null) IU
inner join tblUserQuizStatus tUQS
on tUQS.userid = IU.userid
--inner join tmpUserQuizStatis UQS
--      on tUQS.userquizstatusid = UQS.userquizstatusid
inner join tblModule tM
on tUQS.moduleid = tM.moduleid
inner join tblQuizStatus tQS
on tQS.quizstatusid = tUQS.quizstatusid

Where
--tUQS.quizstatusid <> 2 --Every status except pass quiz status
tUQS.quizstatusid in (1,3,4,5)
and tUQS.moduleid in (select moduleid from tblModule where courseid = @courseid)
and tUQS.userquizstatusid in (select userquizstatusid from #tmpUserQuizStatus)

Order By
UnitPathway, LastName, FirstName,  tM.sequence

drop table #tmpUserQuizStatus

end

Else
-- Report results up to the effective date
Begin


select max(userquizstatusid) userquizstatusid
into #tmpUserQuizStatusDate
from tblUserQuizStatus
where userid in (select userid from tblUser where organisationid = @organisationID)
and moduleid in (select moduleid from tblModule where courseid = @courseid)
and Datecreated < @effectiveDate
group by userid, moduleid

Select
IU.userID
, IU.unitID
, IU.FirstName
, IU.LastName
, IU.UnitPathway
, case when lastcompleted is null then ''Never'' else convert(varchar(10),dbo.udfUTCtoDaylightSavingTime(LastCompleted,@OrganisationID),103) end  as LastCompleted
, IU.Username
, IU.Email
, IU.ExternalID
, tM.[name] as ''Module''
, tQS.status
--,tM.moduleid
--,tUQS.quizstatusid
--,tUQS.userquizstatusid

From
dbo.udfReport_IncompleteUsersLogic(@organisationID, @unitIDs, @courseID,@effectiveDate) IU
inner join tblUserQuizStatus tUQS
on tUQS.userid = IU.userid
--inner join tmpUserQuizStatis UQS
--      on tUQS.userquizstatusid = UQS.userquizstatusid
inner join tblModule tM
on tUQS.moduleid = tM.moduleid
inner join tblQuizStatus tQS
on tQS.quizstatusid = tUQS.quizstatusid

Where
--tUQS.quizstatusid <> 2 --Every status except pass quiz status
tUQS.quizstatusid in (1,3,4,5)
and tUQS.moduleid in (select moduleid from tblModule where courseid = @courseid)
and tUQS.userquizstatusid in (select userquizstatusid from #tmpUserQuizStatusDate)

Order By
UnitPathway, LastName, FirstName, tM.sequence

drop table #tmpUserQuizStatusDate

end
END

' 
END
GO
