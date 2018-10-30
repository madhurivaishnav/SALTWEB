SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOvernightJobGetNextPreprocessingOrg]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcOvernightJobGetNextPreprocessingOrg]

AS
BEGIN
IF (0 = (SELECT COUNT(*) FROM tblCounters))
begin
DECLARE @Org INT
SELECT @Org = OrganisationID  FROM tblOrganisation order by OrganisationID
INSERT tblCounters (OvernightJobCurrentOrg) VALUES (@Org )
end
DECLARE @MaxOrg INT
SELECT @MaxOrg = OrganisationID  FROM tblOrganisation order by OrganisationID
DECLARE @LastOrg INT
SELECT @LastOrg = COALESCE(OvernightJobCurrentOrg,1) FROM tblCounters
IF (@LastOrg = @MaxOrg)
BEGIN
SELECT @Org = OrganisationID  FROM tblOrganisation order by OrganisationID DESC
UPDATE tblCounters SET OvernightJobCurrentOrg = @Org
END
ELSE
BEGIN
SELECT @Org = OrganisationID  FROM tblOrganisation WHERE OrganisationID > @LastOrg order by OrganisationID DESC
UPDATE tblCounters SET OvernightJobCurrentOrg = @Org
END

SELECT @Org = COALESCE(OvernightJobCurrentOrg,1) FROM tblCounters
SELECT @org
RETURN @org
END
' 
END
GO
