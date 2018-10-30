SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcAppConfig_GetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary: Get a list of application configuration
Parameters:
Returns:

Called By:
Calls:

Remarks:

Author: Jack Liu
Date Created: 24th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE Procedure [prcAppConfig_GetList]
As

Set Nocount On

Select
Name,
Value
From
tblAppConfig
order by Name





' 
END
GO
