SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisation_GetAllocatedDiskSpace]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE Procedure [prcOrganisation_GetAllocatedDiskSpace]
(
@OrganisationID int
)

as

select
AllocatedDiskSpace
from tblOrganisation
where OrganisationID = @OrganisationID

' 
END
GO
