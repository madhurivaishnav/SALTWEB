SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcAppConfig_GetMailServices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary: Get mail services 
Parameters:
Returns:

Called By:
Calls:

Remarks:

Author: VDL
Date Created: 04 Jan 2012

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

create Procedure [prcAppConfig_GetMailServices]
As
begin 

	Set Nocount On

	Select
		Name,
		Value
	From
		tblAppConfig
	where 
		Name like ''MailService_%''

END
' 
END
GO
