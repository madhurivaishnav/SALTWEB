SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPolicy_SetUserAccessByUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Set''s a users that have access to a profile

Parameters:
@PolicyID integer
@UserID integer
@Granted bit

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

Create procedure [prcPolicy_SetUserAccessByUser]
(
@PolicyID int,
@UserID int,
@Granted bit
)
as
set nocount on

update tblUserPolicyAccess
set Granted = @Granted
where PolicyID = @PolicyID
and UserID = @UserID

' 
END
GO
