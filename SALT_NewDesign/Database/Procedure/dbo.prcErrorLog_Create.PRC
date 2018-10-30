SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcErrorLog_Create]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
Creates a new entry in the error log.
Returns:
Nothing.

Called By:
ErrorLog Class.

Calls:
Nothing
Remarks:
This procedure creates an entry in the error log when an error is raised.
The Date Created field will be stamped with the current date and time.

Author:
Peter Kneale
Date Created: 9 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


prcErrorLog_Create ''Source'', ''Module'', ''Function'', ''Code'', ''Message'', ''StackTrace'', 1
**/

CREATE Procedure [prcErrorLog_Create]

@strSource varchar(1000) ,		-- Source of Error
@strModule varchar(100), 		-- Module Error occured in
@strFunction varchar(100), 		-- Function Error occured in
@strCode varchar(100), 			-- Code executing when error occurred
@strMessage varchar(500), 		-- Message from exception
@strStackTrace varchar(8000), 		-- Complete stack trace from exception
@intErrorLevel int			-- Error Level from tblErrorLevel

AS
Set NoCount On
Set Xact_Abort On
Begin Tran

Insert Into
tblErrorLog
(
Source,
Module,
[Function],
Code,
Message,
StackTrace,
ErrorLevel,
DateCreated,
DateUpdated
)
Values
(
@strSource,
@strModule,
@strFunction,
@strCode,
@strMessage,
@strStackTrace,
@intErrorLevel,
GetUTCDate(),
GetUTCDate()
)

Commit Tran
' 
END
GO
