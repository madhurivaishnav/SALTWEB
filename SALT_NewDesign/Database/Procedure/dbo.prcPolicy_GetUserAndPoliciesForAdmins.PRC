SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPolicy_GetUserAndPoliciesForAdmins]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:		Compiles a %USER-POLICY_NAMES% block and returns it with a bunch of user info for sending email to that user


Parameters:		Comma separated list of adminuserID,policyID,unitID
Returns:		table (lastname nvarchar(50), firstname nvarchar(50), userid int, email nvarchar(100), policy_name varchar(8000))

Called By:		BusinessServices.{Policy.GetUserAndPoliciesForAdmins in Policy.cs
Calls:			None

Remarks:		None

Author:			John H
Date Created:	21 May 2010

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE PROCEDURE [dbo].[prcPolicy_GetUserAndPoliciesForAdmins]
@admin_ids varchar(8000),
@policy_ids varchar(8000),
@unit_ids varchar(max),
@accepted varchar (20),
@acceptedDateFrom 		datetime,
@acceptedDateTo 		datetime,
@OrgID int
AS
BEGIN
SET NOCOUNT ON;

set @acceptedDateFrom = dbo.udfDaylightSavingTimeToUTC(@acceptedDateFrom, @OrgID)
set @acceptedDateTo = dbo.udfDaylightSavingTimeToUTC(@acceptedDateTo, @OrgID)

DECLARE @policies TABLE (policyid int)
DECLARE @selected_units TABLE (unitid int)
DECLARE @selected_admins TABLE (userid int)
DECLARE @result TABLE (firstname nvarchar(50), policyname nvarchar(50), userid int, email nvarchar(100), user_list varchar(8000), PolicyID int, HierarchyName nvarchar(500))

DECLARE
@pos int,
@colon_pos int,
@temp varchar(50),
@admid int , @PolicyID int,
@PolicyName varchar(8000),
@user_list varchar(8000),
@users_with_policies varchar(8000),
@modified_policy_names varchar(8000),
@strAccepted varchar(5),
@aunit int


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

SELECT @aunit = (SELECT TOP (1) unitid FROM @selected_units)

-- rip the admin selection
INSERT INTO @selected_admins
SELECT
*
FROM
dbo.udfCsvToInt(@admin_ids)




SELECT @policy_ids = replace(rtrim(ltrim(replace(replace(replace(@policy_ids,'' '',''''),'',,'','',''),'','','' ''))),'' '','','') + '',''

-- rip the policies into a table
INSERT INTO @policies
SELECT
*
FROM
dbo.udfCsvToInt(@policy_ids)
-- Note to self: String operations take hundreds of times longer than cursor operations so first think of a way to limit the number of string operations, then get rid of the cursors.

SELECT @user_list = ''''
DECLARE concatenator CURSOR READ_ONLY FOR
SELECT DISTINCT
uadm.userid , pol.PolicyName, pol.policyid
FROM
tblpolicy pol
INNER JOIN @policies pols ON pol.policyid = pols.policyid
INNER JOIN tblUserPolicyAccess polacc ON polacc.policyid = pol.policyid AND polacc.granted = ''True''
INNER JOIN tblUserPolicyAccepted polacd ON polacd.policyid = pols.policyid AND polacd.Accepted = @strAccepted
AND (
((COALESCE(polacd.DateAccepted,CAST(''1/1/1980'' AS DateTime)) >= @acceptedDateFrom) AND (COALESCE(polacd.DateAccepted,CAST(''1/1/2999'' AS DateTime)) < @acceptedDateTo))OR (@strAccepted = ''False''))

INNER JOIN tblUser u ON u.userid = polacc.userid AND u.userid = polacd.userid AND u.active = ''True''
INNER JOIN udf_GetAdminEmailsForORG(@orgID) uadm ON u.UnitID = uadm.unitid
INNER JOIN tblUnitHierarchy hier ON hier.UnitID = u.UnitID
INNER JOIN @selected_units su ON su.unitID = u.unitid
INNER JOIN @selected_admins sa on sa.userid = uadm.userid
ORDER BY uadm.userid
OPEN concatenator
FETCH NEXT FROM concatenator INTO @admID , @policyName, @PolicyID
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @user_list = COALESCE(@user_list,'''') +  char(13) + char(10) + char(9)  + u.FirstName + '' '' + u.LastName
FROM
tblpolicy pol
INNER JOIN @policies pols ON pol.policyid = pols.policyid AND pol.policyid = @PolicyID
INNER JOIN tblUserPolicyAccess polacc ON polacc.policyid = pol.policyid AND polacc.granted = ''True''
INNER JOIN tblUserPolicyAccepted polacd ON polacd.policyid = pols.policyid AND polacd.Accepted = @strAccepted
AND (
((COALESCE(polacd.DateAccepted,CAST(''1/1/1980'' AS DateTime)) >= @acceptedDateFrom) AND (COALESCE(polacd.DateAccepted,CAST(''1/1/2999'' AS DateTime)) < @acceptedDateTo))OR (@strAccepted = ''False''))

INNER JOIN tblUser u ON u.userid = polacc.userid AND u.userid = polacd.userid AND u.active = ''True''
INNER JOIN udf_GetAdminEmailsForORG(@orgID) uadm ON u.UnitID = uadm.unitid AND uadm.userid = @admid
INNER JOIN tblUnitHierarchy hier ON hier.UnitID = u.UnitID
INNER JOIN @selected_units su ON su.unitID = u.unitid
ORDER BY u.LastName , u.FirstName

INSERT INTO
@result
SELECT
adm.firstName+'' ''+adm.lastname, @policyName, adm.userid, adm.email, @user_list, @PolicyID, unt.HierarchyName
FROM
tblUser adm
INNER JOIN tblUnitHierarchy unt ON unt.unitid = adm.unitid AND adm.userid = @admID AND adm.active = ''True''

SELECT @user_list = ''''

FETCH NEXT FROM concatenator INTO @admID , @policyName, @PolicyID
END
CLOSE concatenator
DEALLOCATE concatenator


--Get Data in report format
SELECT
DISTINCT UserID, HierarchyName, PolicyName, FirstName,  email, user_list, PolicyID
FROM @result
END
' 
END
GO
