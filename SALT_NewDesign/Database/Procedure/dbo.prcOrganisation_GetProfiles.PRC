SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisation_GetProfiles]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Get''s a list of profiles for an organisation

Parameters:
@OrganisationID int,

Returns:
Nothing

Called By:
Policy.cs.

Calls:
Nothing

Remarks:
None

Author: Aaron Cripps
Date Created: June 2008

Modification History
-----------------------------------------------------------
v#	Author		Date			Description

**/

create procedure [prcOrganisation_GetProfiles]
(
@OrganisationID int
)
as

select
pro.profileid,
propd.profileperiodid,
pro.profilename,
dbo.udfUTCtoDaylightSavingTime(propd.datestart, @OrganisationID),
dbo.udfUTCtoDaylightSavingTime(propd.dateend, @OrganisationID),
dbo.udfUTCtoDaylightSavingTime(propd.futuredatestart, @OrganisationID),
dbo.udfUTCtoDaylightSavingTime(propd.futuredateend, @OrganisationID),
case when ((propd.datestart < GETUTCDATE()) and (GETUTCDATE() < dateadd(hh,24,propd.dateend))) then ''Enabled'' else ''Disabled'' end [ProfileStatus]
from
tblProfile pro
left join tblProfilePeriod propd on pro.profileid = propd.profileid
where
pro.organisationid = @OrganisationID
and (profileperiodactive = 1)
order by
pro.profilename

' 
END
GO
