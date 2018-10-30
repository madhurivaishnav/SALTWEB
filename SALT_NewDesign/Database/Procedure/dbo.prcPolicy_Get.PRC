SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPolicy_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Gets a policy

Parameters:
@PolicyID int,

Returns:
Nothing

Called By:
Policy.cs.

Calls:
Nothing

Remarks:
None

Author: Aaron Cripps
Date Created: June 2008

Modification History
-----------------------------------------------------------
v#	Author		Date			Description

**/

create procedure [prcPolicy_Get]
(
@PolicyID int,
@OrgID int
)
as

select
PolicyID,
OrganisationID,
PolicyName,
Active,
Deleted,
PolicyFileName,
PolicyFileSize,
dbo.udfUTCtoDaylightSavingTime(UploadDate, @OrgID),
ConfirmationMessage
from tblPolicy
where
PolicyID = @PolicyID
and deleted = 0


' 
END
GO
