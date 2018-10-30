SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcProfile_GetModulePointsByCourse]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
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

CREATE Procedure [prcProfile_GetModulePointsByCourse]
(
@courseID int, -- ID of the Course to return the Modules for.
@ProfilePeriodID int,
@OrgID int
)

As

BEGIN

Set Nocount On

If(@courseID Is Null)
Begin
Raiserror(''The @courseID parameter was Null.  You must supply a value.'', 16, 1)
Return
End

create table  #Modules
(
ModuleID int,
CourseID int,
Name nvarchar(100),
Sequence int,
Description nvarchar(1000),
Active bit,
CreatedBy int,
DateCreated datetime,
UpdatedBy int,
DateUpdated datetime
)

insert into #Modules
exec prcModule_GetListByCourse @CourseID, @OrgID

alter table #modules add [ptsid] int, pts numeric(10,1)

update #modules set ptsid = pp.ProfilePointsID, pts = pp.Points
from
#Modules m
left outer join tblProfilePoints pp	on m.ModuleID = pp.typeID
where
(pp.profilepointstype = ''M''
and pp.active = 1
and pp.ProfilePeriodID = @ProfilePeriodID)

select
ptsid as ProfilePointsID,
m.ModuleID,
m.Name as [Module Name],
coalesce(pts,0) as Points
from #modules m
where m.active = 1

drop table #modules
END

/****** Object:  StoredProcedure [dbo].[prcPolicy_GetAdminsInOrgPendingPolicy]    Script Date: 07/07/2011 13:54:32 ******/
SET ANSI_NULLS ON
' 
END
GO
