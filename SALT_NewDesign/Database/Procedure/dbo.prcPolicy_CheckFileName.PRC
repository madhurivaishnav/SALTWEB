SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPolicy_CheckFileName]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:
Stored procedure to check if a Policy with the same filename
as that being uploaded already exists on the server

Parameters:
@OrganisationID int
@PolicyFileName nvarchar(255)

Called By:
policydetails.aspx

Author: Aaron Cripps
Date Created: June 2008

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

*/
create procedure [prcPolicy_CheckFileName]
(
@OrganisationID int,
@PolicyFileName nvarchar(255)
)
as

select PolicyFileName
from tblPolicy
where OrganisationID = @OrganisationID
and PolicyFileName = @PolicyFileName
and Deleted = 0

' 
END
GO
