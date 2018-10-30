SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_UnitAdministrators]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/**

Summary:		Get a list of existing unit administrators for an organisation, by unit.

Returns:		Result set

Called By:		UnitAdministratorReport.rdl

Example call:	execute prcReport_UnitAdministrators 109
(use this for testing inside SQL management studio)

Author:			Mark Donald

Date Created:	30/07/2009

Modification History
-----------------------------------------------------------
Author		Date			Description



**/
CREATE PROCEDURE [dbo].[prcReport_UnitAdministrators]
(
@organisationID	int,
@IncludeInactive int,
@UnitIDs varchar(max)
)

AS

set nocount on

SELECT
dbo.udfGetUnitPathway(t.unitid) AS unitpathway,
lastname,
firstname,
CASE WHEN u.active = 1 THEN '''' ELSE ''(i)'' END AS flag,
username,
email,
externalid,
groupby,
[value]
FROM
tblunitadministrator ua, tblunit t, tbluser u
LEFT JOIN (
SELECT userid, ct.[name] as groupby, c.[value]
FROM tbluserclassification uc, tblclassification c, tblclassificationtype ct
WHERE c.classificationid = uc.classificationid
AND c.classificationtypeid = ct.classificationtypeid
) AS i ON i.userid = u.userid
WHERE
ua.userid = u.userid AND t.unitid = ua.unitid
AND usertypeid=3 --Unit administrator(3)
AND t.organisationid = @organisationID
AND (@IncludeInactive = 1 OR u.active = 1)
AND t.unitid IN (SELECT * FROM dbo.udfCsvToInt(@UnitIDs))
ORDER BY
unitpathway, lastname, firstname

' 
END
GO
