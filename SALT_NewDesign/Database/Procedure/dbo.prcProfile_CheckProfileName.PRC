SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcProfile_CheckProfileName]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:
Stored procedure to check if a Profile with the same name
as that being created already exists

Parameters:
@OrganisationID int
@ProfileName nvarchar(255)

Called By:
Profile.cs

Author: Aaron Cripps
Date Created: July 2008

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

*/
create procedure [prcProfile_CheckProfileName]
(
@OrganisationID int,
@ProfileName nvarchar(255)
)
as

select ProfileName
from tblProfile
where OrganisationID = @OrganisationID
and ProfileName = @ProfileName

' 
END
GO
