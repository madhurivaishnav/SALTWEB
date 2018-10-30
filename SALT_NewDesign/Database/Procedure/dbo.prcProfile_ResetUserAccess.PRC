SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcProfile_ResetUserAccess]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Reset''s all User''s access to profile to 0

Parameters:
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

Create procedure [prcProfile_ResetUserAccess]
(
@ProfileID int
)
as
set nocount on

declare @ProfilePeriodID int
set @ProfilePeriodID =
(select ProfilePeriodID
from tblProfilePeriod
where ProfileID = @ProfileID and profileperiodactive=1)

update tblUserProfilePeriodAccess
set Granted = 0
where ProfilePeriodID = @ProfilePeriodID

' 
END
GO
