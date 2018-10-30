SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPolicy_SetUserAccessByUnit]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/**Summary:
Set''s a users that have access to a profile

Parameters:
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
Date Created: Feb 2008

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

**/

Create procedure [prcPolicy_SetUserAccessByUnit]
(
@PolicyID int,
@UnitID int
)
as
set nocount on

update tblUserPolicyAccess
set Granted = 1
where PolicyID = @PolicyID
and UserID in
(select UserID from tblUser where UnitID = @UnitID and active=1)

' 
END
GO
