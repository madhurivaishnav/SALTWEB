SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisation_GetPolicyUsedSpace]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE Procedure [prcOrganisation_GetPolicyUsedSpace]
(
@OrganisationID int
)

as

select sum(PolicyFileSize)
from tblPolicy
where OrganisationID=@OrganisationID
and Deleted=0
and Active=1

' 
END
GO
