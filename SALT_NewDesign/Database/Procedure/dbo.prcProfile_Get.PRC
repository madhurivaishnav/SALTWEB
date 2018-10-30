SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcProfile_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
Gets a profile

Parameters:
@ProfileID int,

Returns:
Nothing

Called By:
Policy.cs.

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

CREATE procedure [prcProfile_Get]
(
@ProfileID int,
@profileperiodID int,
@OrgID int
)
as

select
pro.profilename,
dbo.udfUTCtoDaylightSavingTime(propd.datestart, @OrgID) as DateStart,
dbo.udfUTCtoDaylightSavingTime(propd.dateend, @OrgID) as DateEnd,
propd.points,
propd.endofperiodaction,
propd.monthincrement,
dbo.udfUTCtoDaylightSavingTime(propd.futuredatestart, @OrgID) as FutureDateStart,
dbo.udfUTCtoDaylightSavingTime(propd.futuredateend, @OrgID) as FutureDateEnd,
propd.futurepoints,
propd.ApplyToQuiz,
propd.ApplyToLesson
from
tblProfile pro
left join tblProfilePeriod propd on pro.profileid = propd.profileid
where
pro.profileid = @ProfileID
and (@profileperiodID = -1 or propd.profileperiodid = @profileperiodid)
and (profileperiodactive =  1   or ((dbo.udfUTCtoDaylightSavingTime(propd.datestart, @OrgID)) > (dbo.udfUTCtoDaylightSavingTime(GETUTCDATE(), @OrgID))))
' 
END
GO
