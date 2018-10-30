SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcModule_GetListByCourse]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary: Gets a list of Modules per Course
Parameters:
@courseID Integer ID of the Course to return the Modules for.
Returns:

Called By:
Module.cs
Calls:

Remarks:

Author: Gavin Buddis
Date Created: 16th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE Procedure [prcModule_GetListByCourse]
(
@courseID Integer = Null, -- ID of the Course to return the Modules for.
@OrgID int
)

As

Set Nocount On

If(@courseID Is Null)
Begin
Raiserror(''The @courseID parameter was Null.  You must supply a value.'', 16, 1)
Return
End

Select
ModuleID,
CourseID,
[Name],
[Sequence],
[Description],
Active,
CreatedBy,
dbo.udfUTCtoDaylightSavingTime(DateCreated, @OrgID),
UpdatedBy,
dbo.udfUTCtoDaylightSavingTime(DateUpdated, @OrgID)
From
tblModule
Where
(CourseID = @courseID)
Order By
[Sequence] ASC
' 
END
GO
