SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPolicy_ResetUnitAccess]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Reset''s all Unit''s access to profile to 0

Parameters:
@ProfileID integer

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

Create procedure [prcPolicy_ResetUnitAccess]
(
@PolicyID int
)
as
set nocount on


update tblUnitPolicyAccess
set Granted = 0
where PolicyID = @PolicyID

' 
END
GO
