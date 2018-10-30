SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPolicy_SetUnitAccess]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Set''s a list of units that have access to a profile

Parameters:
@PolicyID integer
@UnitID integer

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

Create procedure [prcPolicy_SetUnitAccess]
(
@PolicyID int,
@UnitID int
)
as
set nocount on

update tblUnitPolicyAccess
set Granted = 1
where PolicyID = @PolicyID
and UnitID = @UnitID

' 
END
GO
