SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcCourse_GetListByUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
Summary: Gets a list of all Courses a user can access
Parameters: None
Returns:

Called By: BusinessServices.Course.GetCourseListAccessableToUser
Calls: None

Remarks: None

Author: Stephen Kenendy-Clark
Date Created: 04th of May 2004

prcCourse_GetListByUser 11
Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE  Procedure [prcCourse_GetListByUser]
(
@userid  int -- The UserID
)

As

-------------------------------------------------------------
-- Return Select
-------------------------------------------------------------
Select distinct
c.[CourseID]
, c.[Name]
, c.[Notes]
, c.[Active]
, c.[CreatedBy]
, dbo.udfUTCtoDaylightSavingTime(c.[DateCreated], vUMA.OrganisationID)
, c.[UpdatedBy]
, dbo.udfUTCtoDaylightSavingTime(c.[DateUpdated], vUMA.OrganisationID)
From
[tblCourse] c
inner Join vwUserModuleAccess vUMA
on vUMA.CourseID = c.CourseID
and vUMA.userid = @userid
order by c.Name
' 
END
GO
