SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcApplication_GetDatabaseVersion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:
Gets SQL Server version

Called By: Dependency
Calls: None

Remarks: Raises an error if the parameter is null

Author: Jack Liu
Date Created: 23/02/2004

prcApplication_GetDatabaseVersion

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE  Procedure [prcApplication_GetDatabaseVersion]
as
set nocount on
select @@version
' 
END
GO
