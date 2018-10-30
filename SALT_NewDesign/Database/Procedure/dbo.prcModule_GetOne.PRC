SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcModule_GetOne]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


/*
Summary: Gets the details of one Module
Parameters: @moduleID integer
Returns: ModuleID, CourseID, Name, Sequence, Description, Active, CreatedBy, DateCreated, UpdatedBy, DateUpdated

Called By: Module.cs
Calls: None

Remarks: Raises an error if the parameter is null

Author: Gavin Buddis
Date Created: 16th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE Procedure [prcModule_GetOne]
(
@moduleID Integer = null, -- ModuleID
@OrgID int
)

As

If @moduleID Is Null
Begin
Raiserror(''The Parameter @moduleID was null.  @moduleID does not accept Null values.'', 16, 1)
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
ModuleID = @moduleID


' 
END
GO
