SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUnit_GetOne]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
Summary: Gets details of one Unit

Called By: Unit.cs
Calls: None

Remarks: Raises an error if the parameter is null

Author: Jack Liu
Date Created: 10th of February 2004

prcUnit_GetOne 5

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE  Procedure [prcUnit_GetOne]
(
@unitID Integer = null
)

As

If @unitID Is Null
Begin
Raiserror(''The Parameter @unitID was null.  @unitID does not accept Null values.'', 16, 1)
Return
End

Select
u.UnitID,
u.Name,
u.ParentUnitID,
u.Hierarchy,
dbo.udfGetUnitPathway(u.UnitID) as Pathway,
u.Active,
u.OrganisationID,
o.OrganisationName as Organisation,
u.CreatedBy,
dbo.udfUTCtoDaylightSavingTime(u.DateCreated, u.OrganisationID) as DateCreated,
u.UpdatedBy,
dbo.udfUTCtoDaylightSavingTime(u.DateUpdated, u.OrganisationID) as DateUpdated
From
tblUnit u
left join tblOrganisation o
on u.OrganisationID = o.OrganisationID
Where	u.UnitID = @unitID
' 
END
GO
