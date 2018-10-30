SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUnit_GetModuleAccess]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/****** Object:  Stored Procedure dbo.prcUnit_GetModuleAccess    Script Date: 30/03/2004 3:56:31 PM ******/
/*
Summary:
Gets unit module access settings

Called By: Unit.cs
Calls: None

Remarks: Raises an error if the parameter is null

Author: Jack Liu
Date Created: 10th of February 2004

prcUnit_GetOne 5

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	Peter Kneale 30/3/04        Filtered out inactive modules

prcUnit_GetModuleAccess 30, 1

*/

CREATE   Procedure [prcUnit_GetModuleAccess]
(
@unitID Int,
@courseID int
)

As

set nocount on

Select 	m.ModuleID,
m.Name,
case
when uma.unitID is null then 1
else 0
end as Granted
From tblModule m
left join tblUnitModuleAccess uma
on m.ModuleID = uma.DeniedModuleID
and uma.UnitID=@unitID
where
m.CourseId= @courseID
and
m.Active = 1
order by m.Sequence







' 
END
GO
