SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcCourse_GetSelected]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:		Gets a list of Courses
Parameters:		Comma separated list of courseIDs
Returns:		table

Called By:		BusinessServices.Course.GetCourseList in Course.cs
Calls:			None

Remarks:		None

Author:			Mark Donald
Date Created:	10 Nov 2009

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE PROCEDURE [prcCourse_GetSelected]
@courseIDs varchar(8000)
, @OrgID int
AS
BEGIN
SET NOCOUNT ON;

SELECT
courseid, [name], notes, active, createdby, dbo.udfUTCtoDaylightSavingTime(datecreated, @OrgID), updatedby, dbo.udfUTCtoDaylightSavingTime(dateupdated, @OrgID)
FROM
tblcourse
WHERE
courseid IN (SELECT * FROM dbo.udfCsvToInt(@courseIDs))
ORDER BY [name]
END
' 
END
GO
