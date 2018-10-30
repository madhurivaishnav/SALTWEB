SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUserModuleAccess_Validate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


/*Summary:
Validates that a user has Access to a lesson / quiz
Given User ID
Returns:
int
0 - (false) - indicates user does NOT have access
1 - (true)  - indicates user does have access

Called By: TooolBooLlistner.aspx
Calls:

Remarks:
Given the Module ID and UserID this proc returns true or false
Both paramaters are manditory
Author:
Stephen Kennedy-Clark
Date Created: 2 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	Jack Liu	23/02/2004		Get module access from view


prcUserModuleAccess_Validate @UserID = 11, @ModuleID = 1

**/

CREATE    PROC [prcUserModuleAccess_Validate]
(
@UserID int, -- the user ID
@ModuleID int-- the Module ID
)

AS
set nocount on

declare @Ret_Value int
if exists(select ModuleID
from vwUserModuleAccess
where UserID=@UserID
and ModuleID = @ModuleID)
Begin
set @Ret_Value = 1
end
else
Begin
set @Ret_Value = 0
End


Select @Ret_Value
Return




' 
END
GO
