SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPolicy_GetUnitAccess]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Get''s a list of units that have access to a policy

Parameters:
@PolicyID

Returns:
Nothing

Called By:
Policy.cs.

Calls:
Nothing

Remarks:

Author: Aaron Cripps
Date Created: Feb 2009

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

**/

Create procedure [prcPolicy_GetUnitAccess]
(
@PolicyID int
)
as
set nocount on

select
UnitID
from tblUnitPolicyAccess
where PolicyID = @PolicyID
and Granted=1

' 
END
GO
