SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_UnitPath]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[prcReport_UnitPath]
(
@OrganisationID int,
@IncludeInactiveUnits int,
@UnitIDs varchar(max)
)
AS
begin
if @IncludeInactiveUnits = 1
BEGIN
select

UnitID ,
dbo.udfGetUnitPathway(tblUnit.UnitID) as ''UnitPathway'',
dbo.udfGetUnitIDPathway(tblUnit.UnitID) as ''UnitIDPathway'',

CASE
WHEN Active = 0  THEN [Name] + '' (I)''
ELSE [Name]
END as [Name]



from

tblUnit

where

tblUnit.OrganisationID = @OrganisationID
and tblUnit.UnitID in (SELECT * FROM dbo.udfCsvToInt(@unitIDs) tU)


order by

dbo.udfGetUnitPathway(tblUnit.UnitID)
END
else
BEGIN
select

UnitID,

dbo.udfGetUnitPathway(tblUnit.UnitID) as ''UnitPathway'',

dbo.udfGetUnitIDPathway(tblUnit.UnitID) as ''UnitIDPathway'',

Name



from

tblUnit

where

tblUnit.OrganisationID = @OrganisationID
and tblUnit.UnitID in (SELECT * FROM dbo.udfCsvToInt(@unitIDs) tU)
and tblUnit.Active = 1

order by

dbo.udfGetUnitPathway(tblUnit.UnitID)
END
end
' 
END
GO
