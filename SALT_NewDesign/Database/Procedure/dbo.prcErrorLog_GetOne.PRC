SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcErrorLog_GetOne]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*Summary:
Returns a single error
Returns:
A single error of the tblErrorLog table

Called By:
ErrorLog Class.

Calls:
Nothing
Remarks:
None.

Author:
Peter Kneale
Date Created: 9 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


prcErrorLog_GetReport
**/
CREATE Procedure [prcErrorLog_GetOne]
@ErrorLogID int,
@OrgID int

As

Set NoCount On

SELECT
[ErrorLogID],
[Source],
[Module],
[Function],
[Code],
[Message],
[StackTrace],
[ErrorLevel],
[ErrorLevelDescription],
[ErrorStatusDescription],
[ErrorStatus],
[Resolution],
dbo.udfUTCtoDaylightSavingTime([DateCreated], @OrgID) as DateCreated,
dbo.udfUTCtoDaylightSavingTime([DateUpdated], @OrgID) as DateUpdated
FROM
tblErrorLog
Inner Join
tblErrorLevel
on
tblErrorLog.[ErrorLevel] = tblErrorLevel.[ErrorLevelID]
Inner Join
tblErrorStatus
on
tblErrorLog.[ErrorStatus] = tblErrorStatus.[ErrorStatusID]
Where
ErrorLogID = @ErrorLogID



' 
END
GO
