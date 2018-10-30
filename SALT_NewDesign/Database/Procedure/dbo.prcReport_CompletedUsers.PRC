SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_CompletedUsers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'








/*Summary:
Given a user id returns the list of courses / modules and the latest results for that user
If the User id is ommited it returns results for all users
Returns:
Course ID

Called By:
Home.aspx via Businessservices.Report.GetCompletedUsersReport
Calls:
udfReport_CompletUsers_logic
udfReport_IncompletUsers_logic
Remarks:


Author:
Stephen Kennedy-Clark
Date Created: 18 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1  Liz Dionisio(UW)	8/11/2005		Added Username, Email and ExternalID to returned recordset
#2  Mark Donald	24/07/2009		Add LastCompleted column to incomplete users select statement

prcReport_CompletedUsers @unitIDs=''1,2,3,4'' , @courseID=1 , @completed = 0

--------------------

**/

CREATE          Proc [prcReport_CompletedUsers]

(
@organisationID Integer,		-- Organisation of the current user
@unitIDs varchar(MAX) = '''',	-- string of unit id''s
@courseID int,			-- course ID to restrict search to
@effectiveDate datetime = Null,	-- Effective date as at when to run the report
@completed bit = 0 		-- Completed or incompleted flag
-- 1 = True = completed users
-- 0 = false (default) = not comleted or INcompleted users
)

AS
------------------------------------------
Set Nocount On
If @completed = 1
Begin
SELECT
f.userid, unitid, firstname, lastname, unitpathway,
dbo.udfUTCtoDaylightSavingTime(max(q.datecreated), @organisationID) as date, --date
username, email, externalid
FROM
dbo.udfreport_completeuserslogic(@organisationid, @unitids, @courseid, @effectivedate) f,
tbluserquizstatus q,
tblmodule m
WHERE
m.courseid = @courseid
AND q.moduleid = m.moduleid
AND q.userid = f.userid
AND quizstatusid = 2 -- passed
GROUP BY
f.userid, unitid, firstname, lastname, unitpathway, username, email, externalid
ORDER BY
unitpathway, lastname, firstname
End
Else
Begin
Select
userID
, unitID
, FirstName
, LastName
, UnitPathway
, LastCompleted
, Username
, Email
, ExternalID
From
dbo.udfReport_IncompleteUsersLogic(@organisationID, @unitIDs, @courseID,@effectiveDate)
Order By
UnitPathway, LastName, FirstName
End
' 
END
GO
