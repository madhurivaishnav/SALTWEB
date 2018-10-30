SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUserCourseStatus_GetOne]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'




/*
Summary: Gets othe details of one Organisation
Parameters: 	@courseID integer
@userID integer
Returns:

Called By: User.cs
Calls: None

Remarks: Raises an error if either of the input parameters are null

Author: Gavin Buddis
Date Created: 2/4/04

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE  Procedure [prcUserCourseStatus_GetOne]
(
@userID int, 	-- The User ID
@courseID int, 	-- the Course ID
@OrgID int
)

As

If @courseID Is Null
Begin
Raiserror(''The Parameter @courseID was null.  @courseID does not accept Null values.'', 16, 1)
Return
End

If @userID Is Null
Begin
Raiserror(''The Parameter @userID was null.  @userID does not accept Null values.'', 16, 1)
Return
End

DECLARE
@modulesassigned varchar(1000), -- sql2000 doesn''t allow the naked column value (modulesassigned) to be used as a param for a table udf that''s used in a join
@coursestatusid int

SELECT
TOP 1 @modulesassigned = modulesassigned, @coursestatusid = coursestatusid
FROM
tblusercoursestatus
WHERE
userid = @userid
AND courseid = @courseid
ORDER BY
datecreated DESC

SELECT
TOP 1 @userid userid, @courseid courseid, @coursestatusid coursestatusid, @modulesassigned modulesassigned, dbo.udfUTCtoDaylightSavingTime(datecreated, @OrgID) as datecreated
FROM
tbluserquizstatus,
dbo.udfCsvToInt(@modulesassigned)
WHERE
moduleid = intvalue
AND userid = @userid
AND quizstatusid = 2 -- passed
ORDER BY
datecreated DESC

' 
END
GO
