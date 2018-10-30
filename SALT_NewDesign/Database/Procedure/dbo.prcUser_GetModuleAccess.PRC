SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_GetModuleAccess]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/****** Object:  Stored Procedure dbo.prcUser_GetModuleAccess    Script Date: 30/03/2004 4:01:35 PM ******/
/*
Summary:
Gets user module access settings

Called By: Unit.cs
Calls: None

Remarks: Raises an error if the parameter is null

Author: Jack Liu
Date Created: 10th of February 2004

prcUnit_GetOne 5

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	Peter Kneale    30/3/04    Filtered out inactive modules

prcUser_GetModuleAccess 1, 1

*/

CREATE   Procedure [prcUser_GetModuleAccess]
(
@userID Int,
@courseID int
)

As

set nocount on

declare @intUnitID int
select @intUnitID = unitID
from tblUser
where UserID = @userID

Select 	m.ModuleID,
m.Name,
case
when ((unitma.DeniedModuleID  is null
And userma.ModuleID is null)
or userma.Granted=1)  then 1
else 0 end as Granted
From tblModule m
left join tblUnitModuleAccess unitma
on m.ModuleID = unitma.DeniedModuleID
and unitma.UnitID=@intUnitID
left join tblUserModuleAccess userma
on m.ModuleID = userma.ModuleID
and userma.UserID=@userID
where
m.CourseId= @courseID
and
m.Active = 1
order by m.Sequence








' 
END
GO
