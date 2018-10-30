SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcProfile_SetUnitAccess]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Set''s a list of units that have access to a profile

Parameters:
@organisationID Integer
@ProfileID integer
@UnitID integer

Returns:
Nothing

Called By:
Profile.cs.

Calls:
Nothing

Remarks:

Author: Aaron Cripps
Date Created: July 2008

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

**/

Create procedure [prcProfile_SetUnitAccess]
(
@ProfileID int,
@UnitID int
)
as
set nocount on

declare @ProfilePeriodID int
set @ProfilePeriodID =
(select ProfilePeriodID
from tblProfilePeriod
where ProfileID = @ProfileID and profileperiodactive=1)

update tblUnitProfilePeriodAccess
set Granted = 1
where ProfilePeriodID = @ProfilePeriodID
and UnitID = @UnitID

' 
END
GO
