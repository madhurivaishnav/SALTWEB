SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPolicy_GetAdminsInOrgPendingPolicy]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
Summary:		Mainly just returns a list of unit admins that meet the flagged conditions

Parameters:		Comma separated list of userID:courseID
Returns:		table (lastname nvarchar(50), firstname nvarchar(50), userid int, email nvarchar(100), policy_name varchar(8000))

Called By:		BusinessServices.{Policy.GetAdminsInOrgPendingPolicy in Policy.cs
Calls:			None

Remarks:		None

Author:			John H
Date Created:	21 MAy 2010

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE PROCEDURE [dbo].[prcPolicy_GetAdminsInOrgPendingPolicy]
@policy_ids varchar(8000),
@unit_ids varchar(max),
@accepted varchar (20),
@acceptedDateFrom 		datetime,
@acceptedDateTo 		datetime
AS
BEGIN
SET NOCOUNT ON;

DECLARE @policies TABLE (policyid int)
DECLARE @selected_units TABLE (unitid int)
DECLARE @result TABLE (firstname nvarchar(50), lastname nvarchar(50), userid int, email nvarchar(100), new_policy_names varchar(8000), modified_policy_names varchar(8000), HierarchyName nvarchar(500))
DECLARE
@pos int,
@colon_pos int,
@temp varchar(50),
@userid int, @admid int,
@new_policy_names varchar(8000),
@users_with_policies varchar(8000),
@modified_policy_names varchar(8000),
@strAccepted varchar(5),
@aunit int,@orgID int

IF @accepted = ''0''
BEGIN
SELECT @strAccepted = ''True''
END
ELSE
BEGIN
SELECT @strAccepted = ''False''
END



-- rip the unit selection
INSERT INTO @selected_units
SELECT
*
FROM
dbo.udfCsvToInt(@unit_ids)

SELECT @policy_ids = replace(rtrim(ltrim(replace(replace(replace(@policy_ids,'' '',''''),'',,'','',''),'','','' ''))),'' '','','') + '',''
SELECT @aunit = (SELECT TOP (1) unitid FROM @selected_units)
SELECT @orgID = OrganisationID FROM tblUnit WHERE tblUnit.UnitID = @aunit


set @acceptedDateFrom = dbo.udfDaylightSavingTimeToUTC(@acceptedDateFrom, @orgID)
set @acceptedDateTo = dbo.udfDaylightSavingTimeToUTC(@acceptedDateTo, @orgID)

-- rip the policies into a table
INSERT INTO @policies
SELECT
*
FROM
dbo.udfCsvToInt(@policy_ids)



--	SELECT DISTINCT adm.UserID, hier.HierarchyName, adm.LastName, adm.FirstName,  adm.email, '''',''''
SELECT DISTINCT adm.UserID, unt.Name as HierarchyName, adm.LastName, adm.FirstName,  adm.email, '''',''''
FROM
@policies pols
INNER JOIN tblUserPolicyAccess polacs ON polacs.policyid = pols.policyid AND polacs.granted = ''True''
INNER JOIN tblUserPolicyAccepted polacd ON polacd.policyid = pols.policyid AND polacd.Accepted = @strAccepted
AND (
((COALESCE(polacd.DateAccepted,CAST(''1/1/1980'' AS DateTime)) >= @acceptedDateFrom) AND (COALESCE(polacd.DateAccepted,CAST(''1/1/2999'' AS DateTime)) < @acceptedDateTo))OR (@strAccepted = ''False''))
INNER JOIN tblUser usr ON usr.userid = polacs.userid AND usr.userid = polacd.userid AND usr.active = ''True''
INNER JOIN @selected_units su ON usr.unitid = su.unitid
INNER JOIN udf_GetAdminEmailsForORG(@orgID) uadm ON uadm.UnitID = su.unitid
INNER JOIN tblUnitHierarchy hier ON hier.UnitID = usr.UnitID
INNER JOIN tblUnit unt ON unt.UnitID = usr.UnitID
INNER JOIN tblUser adm ON adm.userid = uadm.userid
WHERE NOT EXISTS
(SELECT *
FROM
@policies Spols
INNER JOIN tblUserPolicyAccess Spolacs ON Spolacs.policyid = Spols.policyid AND Spolacs.granted = ''True''
INNER JOIN tblUserPolicyAccepted Spolacd ON Spolacd.policyid = Spols.policyid AND Spolacd.Accepted = @strAccepted
AND (
((COALESCE(polacd.DateAccepted,CAST(''1/1/1980'' AS DateTime)) >= @acceptedDateFrom) AND (COALESCE(polacd.DateAccepted,CAST(''1/1/2999'' AS DateTime)) < @acceptedDateTo))OR (@strAccepted = ''False''))
INNER JOIN tblUser Susr ON Susr.userid = Spolacs.userid AND Susr.userid = Spolacd.userid AND Susr.active = ''True''
INNER JOIN @selected_units Ssu ON Susr.unitid = Ssu.unitid
INNER JOIN udf_GetAdminEmailsForORG(@orgID) Suadm ON Suadm.UnitID = Ssu.unitid
INNER JOIN tblUnitHierarchy Shier ON Shier.UnitID = Susr.UnitID
INNER JOIN tblUnit Sunt ON Sunt.UnitID = Susr.UnitID
INNER JOIN tblUser Sadm ON Sadm.userid = Suadm.userid and Sadm.UserID = adm.UserID
WHERE (hier.hierarchy LIKE Shier.hierarchy+'',%'') )





END


SET ANSI_NULLS ON
' 
END
GO
