SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcSqlAgentRunningStatus_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
return teh running state of the SQLServerAgent
Returns:
sclaer

Called By:
Bdw.Application.Salt.BusinessServices.Application.GetSqlAgentRunningStatus
Calls:
master..xp_servicecontrol
Remarks:
- May not work if permissions are insuficient

Author:
Stephen Kennedy-Clark
Date Created: 10 May 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1



--------------------
prcSqlAgentRunningStatus_Get

**/
CREATE Procedure [prcSqlAgentRunningStatus_Get]

AS


EXEC master..xp_servicecontrol ''QUERYSTATE'', ''SQLServerAgent''

' 
END
GO
