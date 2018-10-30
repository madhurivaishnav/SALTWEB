SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcModuleStatusUpdateHistory_GetLastRun]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Get the Module Status Updatelast run date time

Returns:

Called By:

Calls:
Nothing

Remarks:

Author: Jack Liu
Date Created: 26 March 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

prcModuleStatusUpdateHistory_GetLastRun

**/
CREATE Procedure [prcModuleStatusUpdateHistory_GetLastRun]

@OrgID int

AS
Set Nocount On
select dbo.udfUTCtoDaylightSavingTime((select  max(FinishTime) as LastRunDate
from tblModuleStatusUpdateHistory), @OrgID) as LastRunDate




' 
END
GO
