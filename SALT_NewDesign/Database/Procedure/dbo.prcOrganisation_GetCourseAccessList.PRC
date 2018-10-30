SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisation_GetCourseAccessList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


/*
Summary:
Gets a list of all Courses and flags which one the organisation has access to.

Parameters:
@organisationID Integer

Returns:
CourseID
Name
Notes
Active
Granted
CreatedBy
DateCreated
UpdatedBy
DateUpdated

Called By:
Course.cs
Calls: None

Remarks: None

Author: Peter Vranich
Date Created: 19th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE Procedure [prcOrganisation_GetCourseAccessList]
(
@organisationID Integer -- The ID of the organisation that you wish to get the course access list for.
)

As

Set NoCount On

Select
CourseID,
Name,
Notes,
Active,
Case
When toca.GrantedCourseID Is Not Null Then 1
Else 0
End As Granted,
CreatedBy,
dbo.udfUTCtoDaylightSavingTime(DateCreated, @organisationID),
UpdatedBy,
dbo.udfUTCtoDaylightSavingTime(DateUpdated, @organisationID)
From
tblCourse As tc
Left Outer Join tblOrganisationCourseAccess As toca
On tc.CourseID = toca.GrantedCourseID
And toca.OrganisationID = @organisationID
Order By
Name


' 
END
GO
