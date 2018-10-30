SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcCourse_GetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


/*
Summary: Gets a list of all Courses
Parameters: None
Returns: table

Called By: BusinessServices.Course.GetCourseList in Course.cs
Calls: None

Remarks: None

Author: Stephen Kenendy-Clark
Date Created: 06th of Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE  Procedure [prcCourse_GetList]

@OrgID int

As

Select
[CourseID]
, [Name]
, [Notes]
, [Active]
, [CreatedBy]
, dbo.udfUTCtoDaylightSavingTime([DateCreated], @OrgID)
, [UpdatedBy]
, dbo.udfUTCtoDaylightSavingTime([DateUpdated], @OrgID)
From
[tblCourse]
Order by Name

' 
END
GO
