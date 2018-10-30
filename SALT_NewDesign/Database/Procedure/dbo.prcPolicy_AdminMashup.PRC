SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPolicy_AdminMashup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


/*
Summary:		Compiles a bunch of info based on the selected units/policies then filters it based on administrator selection
Parameters:		Comma separated list of userID:policyID, comma separated list of adminID (unit administrators)
Returns:		table (lastname firstname userid email policy_names)

Called By:		BusinessServices.policy.GetAdminMashup in policy.cs
Calls:			None

Remarks:		None

Author:			Mark Donald
Date Created:	20 Jan 2010

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE PROCEDURE [prcPolicy_AdminMashup]
@organisationID int,
@unitIDs 			varchar(MAX),
@policyIDs 			varchar(8000),
@input_csv varchar(8000),
@adminids varchar(8000),
@classificationID 	int,
@policyStatus	int,
@acceptedDateFrom 		datetime,
@acceptedDateTo 		datetime,
@includeInactive	int
AS
BEGIN
SET NOCOUNT ON;


set @acceptedDateFrom = dbo.udfDaylightSavingTimeToUTC(@acceptedDateFrom, @organisationID)
set @acceptedDateTo = dbo.udfDaylightSavingTimeToUTC(@acceptedDateTo, @organisationID)

declare @tblUserUnit table
(
UserID int,
UnitID int
)


declare @tblUnit table
(
unitID int
)

declare @tblUnitAdministrator table
(
unitID int,
AdminUserID int
)
Set Nocount On
Declare
@CONST_NOT_ACCEPTED     int,
@CONST_ACCEPTED     	int,
@CONST_UNKNOWN          int


set @CONST_NOT_ACCEPTED	= 0
set @CONST_ACCEPTED	    = 1
set @CONST_UNKNOWN		= 2


DECLARE @Units TABLE (UnitID INT)
DECLARE @policies TABLE (policyID INT)
DECLARE @policiesWithAccess TABLE (policyID INT PRIMARY KEY, [name] nvarchar(100))
DECLARE @UserModuleWithAccess TABLE (UserID INT, ModuleID INT, UnitID INT, PRIMARY KEY(UserID, ModuleID, UnitID))
DECLARE @AllModules TABLE (ModuleID INT PRIMARY KEY(ModuleID))
DECLARE @Users TABLE (UserID INT, UnitID INT PRIMARY KEY(UserID, UnitID))
DECLARE @UsersNQuizStatus TABLE (
UserID	INT, ModuleID INT, LatestQuizID INT, QuizStatusID INT, QuizScore INT,
PRIMARY KEY(UserID, ModuleID, LatestQuizID, QuizStatusID)
)
DECLARE @UsersQuizStatusNOTSTARTED TABLE (
UserID	INT, ModuleID INT, LatestQuizID INT, QuizStatusID INT, QuizScore INT,
PRIMARY KEY(UserID, ModuleID, LatestQuizID, QuizStatusID)
)
DECLARE @mashup TABLE (userid int, policyid int)
DECLARE @selectedadmin TABLE (adminid int)
DECLARE
@pos int,
@colon_pos int,
@temp varchar(50)

INSERT INTO
@policies
SELECT
*
FROM
dbo.udfCsvToInt(@policyIDs)

INSERT INTO
@Units
SELECT
*
FROM
dbo.udfCsvToInt(@unitIDs)

INSERT INTO
@selectedadmin
SELECT
*
FROM
dbo.udfCsvToInt(@adminids)

if @policyStatus = @CONST_ACCEPTED
BEGIN
SELECT

untadm.UserID, usr.Email, adm.FirstName, adm.LastName, pol.policyID, pol.PolicyName, usr.FirstName, usr.LastName
FROM
@policies ps
INNER JOIN tblPolicy pol ON ps.policyID = pol.policyID
INNER JOIN tblUserPolicyAccepted polacp ON polacp.policyID = pol.policyID AND polacp.Accepted = ''True'' AND COALESCE(polacp.DateAccepted,CAST(''1/1/1980'' AS DateTime)) >= @acceptedDateFrom AND COALESCE(polacp.DateAccepted,CAST(''1/1/2999'' AS DateTime)) < @acceptedDateTo
INNER JOIN tblUserPolicyAccess polacs ON polacs.policyID = pol.policyID AND polacs.Granted = ''True'' AND polacp.userID = polacs.userID
INNER JOIN tblUser usr ON usr.userID = polacp.userID
INNER JOIN tblUnitAdministrator untadm ON untadm.UnitID = usr.UserID
INNER JOIN tblUser adm ON adm.UserID = untadm.UserID
WHERE pol.organisationID = @organisationID;
END
else
BEGIN
SELECT

untadm.UserID, usr.Email, adm.FirstName, adm.LastName, pol.policyID, pol.PolicyName, usr.FirstName, usr.LastName
FROM
@policies ps
INNER JOIN tblPolicy pol ON ps.policyID = pol.policyID
INNER JOIN tblUserPolicyAccepted polacp ON polacp.policyID = pol.policyID AND polacp.Accepted = ''False''
INNER JOIN tblUserPolicyAccess polacs ON polacs.policyID = pol.policyID AND polacs.Granted = ''True'' AND polacp.userID = polacs.userID
INNER JOIN tblUser usr ON usr.userID = polacp.userID
INNER JOIN tblUnitAdministrator untadm ON untadm.UnitID = usr.UserID
INNER JOIN tblUser adm ON adm.UserID = untadm.UserID
WHERE pol.organisationID = @organisationID;

END

END




' 
END
GO
