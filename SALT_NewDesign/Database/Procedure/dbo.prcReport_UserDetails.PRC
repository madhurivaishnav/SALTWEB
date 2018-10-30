SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_UserDetails]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE  PROCEDURE [dbo].[prcReport_UserDetails]
(
@OrganisationID int,
@IncludeInactiveUsers int,
@UnitIDs varchar(max)
)
AS
SET NOCOUNT ON

IF (@IncludeInactiveUsers=0)
BEGIN

SELECT
uh.HierarchyName as UnitPathway,
u.UserID,
FirstName,
LastName,
u.UnitID,
Email,
UserName,
ExternalID,
ct.Name as GroupBy,
c.Value as Value
FROM
tblUser u
LEFT JOIN tblUserClassification uc on u.UserID = uc.UserID
LEFT JOIN tblClassification c on uc.ClassificationID = c.ClassificationID
LEFT JOIN tblClassificationType ct on c.ClassificationTypeID = ct.ClassificationTypeID
LEFT JOIN tblUnitHierarchy uh on u.UnitID = uh.UnitID
WHERE
u.Active = 1
AND
u.OrganisationID = @OrganisationID
AND
u.UnitID IN (SELECT * FROM dbo.udfCsvToInt(@UnitIDs) as tblUnitIDs)

ORDER BY
uh.HierarchyName, LastName

END

ELSE
BEGIN
SELECT
uh.HierarchyName as UnitPathway,
u.UserID,
FirstName,
CASE
WHEN u.Active = 0 then u.LastName + '' (I)''
ELSE u.LastName
END AS LastName,
u.UnitID,
Email,
UserName,
ExternalID,
ct.Name as GroupBy ,
c.Value as Value
FROM
tblUser u
LEFT JOIN tblUserClassification uc on u.UserID = uc.UserID
LEFT JOIN tblClassification c on uc.ClassificationID = c.ClassificationID
LEFT JOIN tblClassificationType ct on c.ClassificationTypeID = ct.ClassificationTypeID
LEFT JOIN tblUnitHierarchy uh on u.UnitID = uh.UnitID
WHERE

u.OrganisationID = @OrganisationID
AND
u.UnitID IN (SELECT * FROM dbo.udfCsvToInt(@UnitIDs) as tblUnitIDs)

--Active = (IsNull(@Active,1))

ORDER BY
uh.HierarchyName, LastName

END

' 
END
GO
