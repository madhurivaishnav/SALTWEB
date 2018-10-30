SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcProfile_GetPolicyPoints]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Gets policies and points for an organisation

Parameters:
@OrganisationID int,

Returns:
Nothing

Called By:
Profile.cs.

Calls:
Nothing

Remarks:
None

Author: Aaron Cripps
Date Created: July 2008

Modification History
-----------------------------------------------------------
v#	Author		Date			Description

**/

create procedure [prcProfile_GetPolicyPoints]
(
@OrganisationID int,
@ProfilePeriodID int
)
as

declare @policytmp table
(
policyid int,
policyname nvarchar(255),
ptsid int,
pts numeric(10,1)
)

insert into @policytmp (policyid, policyname)
select
policyid, policyname
from
tblpolicy
where organisationid =@organisationid
and deleted = 0

update @policytmp set ptsid = pp.profilepointsid, pts =pp.points
from
@policytmp pt
left join tblprofilepoints pp on pt.policyid = pp.typeid and pp.active = 1 and pp.profilepointstype =''P''
where pp.profileperiodid = @profileperiodid


select
ptsid as profilepointsid,
policyid,
policyname,
coalesce(pts,0) as policypoints
from @policytmp


' 
END
GO
