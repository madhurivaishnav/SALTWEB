SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcProfile_GetUnitAccess]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Get''s a list of units that have access to a profile

Parameters:
@organisationID Integer
@ProfileID integer

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

Create procedure [prcProfile_GetUnitAccess]
(
--@ProfileID int,
@ProfilePeriodID int
)
as
set nocount on

select
UnitID
from tblUnitProfilePeriodAccess
where ProfilePeriodID = @ProfilePeriodID
and Granted=1

' 
END
GO
