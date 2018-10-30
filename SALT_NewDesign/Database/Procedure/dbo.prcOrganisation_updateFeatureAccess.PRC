SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisation_UpdateFeatureAccess]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'  

CREATE Procedure [prcOrganisation_UpdateFeatureAccess]
(
@OrganisationID int,
@featurename nvarchar(100),
@granted tinyint
)

As


if(@granted = 1)
begin

delete from tblOrganisationFeatureAccess
where
organisationid=@organisationid and featurename=@featurename

insert into tblOrganisationFeatureAccess
(organisationid, featurename, granted)
values
(@organisationid, @featurename, @granted)

end
else if(@granted = 0)
begin

delete from tblOrganisationFeatureAccess
where
organisationid=@organisationid and featurename=@featurename

end
'
END
GO

