SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisation_CheckDisabledPasswordField]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [prcOrganisation_CheckDisabledPasswordField]
(
@OrgID int
)
as
Select
DisablePasswordField
From
tblOrganisation
Where
OrganisationID = @OrgID
' 
END
GO
