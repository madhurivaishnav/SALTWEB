SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_CourseStatusReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Given a user id returns the list of courses / modules and the latest results for that user
If the User id is ommited it returns results for all users
Returns:
Course ID

Called By:
Home.aspx via Businessservices.Report.GetCourseStatusReport
Calls:
udfReport_CompletUsers_logic
udfReport_IncompletUsers_logic
Remarks:


Author:

Date Created: 16 March 2006

Modification History
-----------------------------------------------------------
v#	Author		Date			Description

--------------------

**/

CREATE          Proc [prcReport_CourseStatusReport]

(
@organisationID Integer,		-- Organisation of the current user
@unitIDs varchar(max) = '''',	-- string of unit id''s
@courseIDs varchar(8000),			-- course IDs to restrict search to
@effectiveFromDate datetime = Null,	-- Effective date as at when to run the report
@effectiveToDate datetime = Null,	-- Effective date as at when to run the report
@completed bit = 0 		-- Completed or incompleted flag
-- 1 = True = completed users
-- 0 = false (default) = not comleted or INcompleted users
)

AS
------------------------------------------
Set Nocount On
If @completed = 1
Begin
Select
userID
, unitID
, FirstName
, LastName
, UnitPathway
,Date
,Username
,Email
,ExternalID
,CourseName
From
dbo.udfReport_CompleteCourseLogic(@organisationID, @unitIDs, @courseIDs,@effectiveFromDate,@effectiveToDate)
Order By
CourseName,UnitPathway,LastName, FirstName
End
Else
Begin
Select
userID
, unitID
, FirstName
, LastName
, UnitPathway
, Username
, Email
, ExternalID
, CourseName
From
dbo.udfReport_IncompleteCourseLogic(@organisationID, @unitIDs, @courseIDs,@effectiveFromDate,@effectiveToDate)
Order By
CourseName,UnitPathway,LastName,FirstName
End
' 
END
GO
