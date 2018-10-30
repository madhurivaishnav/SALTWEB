SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetPoliciesAssignedToUsers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
Summary:		Compiles a %POLICY_NAMES% block and returns it with a bunch of user info for sending email to that user
				(Mainly just returns a list of users and the policies that they are assigned to (that meet the flagged conditions))

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

CREATE PROCEDURE [GetPoliciesAssignedToUsers]
	@policy_ids varchar(8000),
	@user_ids varchar(8000),
	@accepted varchar (20)
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
		@userid int,
		@new_policy_names varchar(8000),
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
				dbo.udfCsvToInt(@user_ids)

	-- clean up the input so it resembles ''userid:policyid,userid:policyid,''
	SELECT @policy_ids = replace(rtrim(ltrim(replace(replace(replace(@policy_ids,'' '',''''),'',,'','',''),'','','' ''))),'' '','','') + '',''

	-- rip the policies into a table
	INSERT INTO @policies
		SELECT
			*
			FROM
				dbo.udfCsvToInt(@policy_ids)
	-- Note to self: String operations take hundreds of times longer than cursor operations so first think of a way to limit the number of string operations, then get rid of the cursors.
	SELECT @new_policy_names = ''''
	SELECT @modified_policy_names = ''''
	DECLARE concatenator CURSOR READ_ONLY FOR
		SELECT DISTINCT
			usr.userid
			FROM
				@policies pols 
				INNER JOIN tblUserPolicyAccess polacs ON polacs.policyid = pols.policyid AND polacs.granted = ''True''
				INNER JOIN tblUserPolicyAccepted polacd ON polacd.policyid = pols.policyid AND polacd.Accepted = @strAccepted
				INNER JOIN tblUser usr ON usr.userid = polacs.userid AND usr.userid = polacd.userid AND usr.active = ''True'' 
				INNER JOIN @selected_units su ON usr.unitid = su.unitid 
	OPEN concatenator
	FETCH NEXT FROM concatenator INTO @userid
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT
				@new_policy_names = @new_policy_names + [PolicyName] + char(13) + char(10) + char(9)
				FROM
					tblpolicy pol 
					INNER JOIN @policies pols ON	pol.policyid = pols.policyid
					INNER JOIN tblUserPolicyAccess polacc ON polacc.policyid = pol.policyid AND polacc.granted = ''True''
					INNER JOIN tblUserPolicyAccepted polacd ON polacd.policyid = pols.policyid AND polacd.Accepted = @strAccepted
					INNER JOIN tblUser usr ON usr.userid = polacc.userid AND usr.active = ''True'' AND usr.userid = @userid

			SELECT @new_policy_names = substring(@new_policy_names, 1, len(@new_policy_names) - 3)

			INSERT INTO
				@result
				SELECT
					usr.lastname, usr.firstname, usr.userid, usr.email, @new_policy_names, @modified_policy_names, hier.HierarchyName
					FROM
						tbluser usr
						INNER JOIN tblUnitHierarchy hier ON hier.UnitID = usr.UnitID 
					WHERE
						userid = @userid
			SELECT @new_policy_names = ''''
			SELECT @modified_policy_names = ''''
			FETCH NEXT FROM concatenator INTO @userid
		END
	CLOSE concatenator
	DEALLOCATE concatenator


	--Get Data in report format
	SELECT 
		DISTINCT UserID, HierarchyName, LastName, FirstName,  email, new_policy_names, modified_policy_names 

 FROM @result
END
' 
END
GO
