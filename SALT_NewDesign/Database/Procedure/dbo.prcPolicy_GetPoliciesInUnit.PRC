SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPolicy_GetPoliciesInUnit]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*
Summary:		Compiles a %POLICY_NAMES% block and returns it with a bunch of user info for sending email to that user
(Mainly just returns a list of policies that are assigned to users that meet the flagged conditions)
Parameters:		Comma separated list of userID:courseID
Returns:		table (lastname nvarchar(50), firstname nvarchar(50), userid int, email nvarchar(100), policy_name varchar(8000))

Called By:		BusinessServices.{Policy.prcPolicy_GetUsersByPolicyAndUnit in Policy.cs
Calls:			None

Remarks:		None

Author:			Mark Donald (John R copied prcCourse_UserMashup - no optimising attempted as execution time expected to be small)
Date Created:	13 Nov 2009 (copied 18/05/2010)

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE PROCEDURE [dbo].[prcPolicy_GetPoliciesInUnit]
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
DECLARE @result TABLE (policy_names varchar(8000))
DECLARE
@pos int,
@colon_pos int,
@temp varchar(50),
@userid int,
@policy_names varchar(8000),
@modified_policy_names varchar(8000),
@strAccepted varchar(5)



IF @accepted = ''0''
BEGIN
SELECT @strAccepted = ''True''
END
ELSE
BEGIN
SELECT @strAccepted = ''False''
END



-- rip the user selection
INSERT INTO @selected_units
SELECT
*
FROM
dbo.udfCsvToInt(@unit_ids)

-- clean up the input so it resembles ''userid:policyid,userid:policyid,''
SELECT @policy_ids = replace(rtrim(ltrim(replace(replace(replace(@policy_ids,'' '',''''),'',,'','',''),'','','' ''))),'' '','','') + '',''

-- rip the policies into a table
INSERT INTO @policies
SELECT
*
FROM
dbo.udfCsvToInt(@policy_ids)
-- Note to self: String operations take hundreds of times longer than cursor operations so first think of a way to limit the number of string operations, then get rid of the cursors.


SELECT DISTINCT pol.PolicyName
FROM
@policies pols
INNER JOIN tblPolicy pol ON pol.PolicyID = pols.PolicyID
INNER JOIN tblUserPolicyAccess polacs ON polacs.policyid = pols.policyid AND polacs.granted = ''True''
INNER JOIN tblUserPolicyAccepted polacd ON polacd.policyid = pols.policyid AND polacd.Accepted = @strAccepted
AND (
((COALESCE(polacd.DateAccepted,CAST(''1/1/1980'' AS DateTime)) >= @acceptedDateFrom) AND (COALESCE(polacd.DateAccepted,CAST(''1/1/2999'' AS DateTime)) < @acceptedDateTo))OR (@strAccepted = ''False''))

INNER JOIN tblUser usr ON usr.userid = polacs.userid AND usr.userid = polacd.userid AND usr.active = ''True''
INNER JOIN @selected_units su ON usr.unitid = su.unitid
END
' 
END
GO
