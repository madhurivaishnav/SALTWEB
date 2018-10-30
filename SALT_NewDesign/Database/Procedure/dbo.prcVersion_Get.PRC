SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcVersion_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:
Get the current product version

Parameters:


Returns:
None

Called By:
Database Configuration

Calls:
None

Remarks:

Author: Jack Liu
Date Created: 8/March/2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


*/

CREATE procedure [prcVersion_Get]
as
set nocount on

select version from tblVersion


' 
END
GO
