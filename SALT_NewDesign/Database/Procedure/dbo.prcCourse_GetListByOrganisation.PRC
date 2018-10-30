SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcCourse_GetListByOrganisation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'




/*
Summary: Gets a list of all Courses
Parameters: None
Returns:

Called By: BusinessServices.Course.GetCourseListAccessableToOrg
Calls: None

Remarks: None

Author: Stephen Kenendy-Clark
Date Created: 06th of Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/


CREATE     Procedure [prcCourse_GetListByOrganisation]
(
@organisationID  int -- The organisation ID
,@excludeInactive int
)

As

-------------------------------------------------------------
-- Return Select
-------------------------------------------------------------
Select
c.[CourseID]
, c.[Name]
, c.[Notes]
, c.[Active]
, c.[CreatedBy]
, dbo.udfUTCtoDaylightSavingTime(c.[DateCreated], @organisationID)
, c.[UpdatedBy]
, dbo.udfUTCtoDaylightSavingTime(c.[DateUpdated], @organisationID)
From
[tblCourse] c
inner Join tblOrganisationCourseAccess oca
on oca.GrantedCourseID = c.CourseID and (@excludeInactive = 0 or (@excludeInactive = 1 and Active = 1))
and oca.organisationID = @organisationID
order by c.Name





' 
END
GO
