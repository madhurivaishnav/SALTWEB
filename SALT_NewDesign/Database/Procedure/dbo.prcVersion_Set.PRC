SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcVersion_Set]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:
Set the product version with version ID

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

CREATE procedure [prcVersion_Set]
(
@version varchar(50)
)
as
set nocount on

update tblVersion
set version =@version


' 
END
GO
