SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPolicy_UserSearch]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*Summary:
Returns results of search for users on Assign Users tab of CPDdetail.aspx

Returns:

Called By:

Calls:

Remarks:
The searching units will include all children and grandchildren
Only return users that logged on user has permission to see


Author: Aaron Cripps
Date Created: Feb 2009

Modification History
-----------------------------------------------------------
v#	Author		Date			Description

**/

CREATE  Procedure  [dbo].[prcPolicy_UserSearch]
(
@organisationID  Int,
@PolicyID int,
@parentUnitIDs  Varchar(max),
@firstName	nVarchar(50),
@lastName	nVarchar(50),
@userName	nVarChar(100),
@Email		nVarChar(100),
@ExternalID nVarChar(50),
@adminUserID		Int,
@Type nvarchar(50)
)
As
Set Nocount On

Declare @intUserTypeID Int

Select @intUserTypeID = UserTypeID
From tblUser
Where userID = @adminUserID



--Check Data
If @parentUnitIDs is null
set @parentUnitIDs =''''

If @firstName is null
Set @firstName = ''''

Set @firstName =rtrim(@firstName)

If @lastName is null
Set @lastName = ''''

Set @lastName =rtrim(@lastName)

If @userName is null
Set @userName = ''''

set @userName = rtrim(@userName)

if @Email is null
set @Email = ''''

set @Email = rtrim(@Email)

if @ExternalID is null
set @ExternalID = ''''

set @ExternalID = rtrim(@ExternalID)

if @Type = ''search''
Begin
Select
us.UserID,
us.UserName,
us.FirstName,
case
When us.Active = 0 then us.LastName + ''(I)''
Else us.LastName
end as LastName,
case
When us.LastLogin Is Null then ''Never''
Else cast(us.LastLogin as varchar)
end as LastLogin,
dbo.udfGetUnitPathway(us.UnitID) as Pathway,
us.Active,
upa.Granted

From tblUnit un, tblUser us, tblUserPolicyAccess upa

Where (un.OrganisationID = @organisationID)
and
(
us.Active=1
)
--0. Join Unit and User tables
and (
un.UnitID = us.UnitID
)
-- Join User and UserProfilePeriodAccess tables
and (
us.UserID = upa.UserID
)
and (
upa.PolicyID = @PolicyID
)
--1. Within the selected Parent Units (can select multiple units)
--The unit hierarchy contains the parent Unit ID
and (
un.UnitID in
(
Select IntValue from dbo.udfCsvToInt(@parentUnitIDs)
)
or (@parentUnitIDs='''')
)
--2. User firstname contains the entered text
and (
(firstname like ''%''+ @firstName + ''%'')
or (firstname ='''')
)
--3. User lastname contains the entered text
and (
(lastname like ''%''+ @lastName + ''%'')
or (lastname ='''')
)
-- User username contains the entered text
and (
(username like ''%'' + @userName + ''%'')
or (userName='''')
)
-- User email contains the entered text
and (
(email like ''%'' + @Email + ''%'')
or (email='''') or (email = null)
)
-- User externalid contains the entered text
and (
(externalID like ''%'' + @ExternalID + ''%'')
or (externalID = '''') or (externalid = null)
)
--4. Permission
--Salt Administrator(1), Organisation Administrator(2) has permission to access all units
--Unit Administrator(3) only has permission to those that he is administrator
and (
(@intUserTypeID<3)
or (un.UnitID in (select UnitID from tblUnitAdministrator where UserID=@adminUserID))
)
Order By Name
End
else if @Type = ''view''
Begin
Select
us.UserID,
us.UserName,
us.FirstName,
case
When us.Active = 0 then us.LastName + ''(I)''
Else us.LastName
end as LastName,
case
When us.LastLogin Is Null then ''Never''
Else cast(us.LastLogin as varchar)
end as LastLogin,
dbo.udfGetUnitPathway(us.UnitID) as Pathway,
us.Active,
upa.Granted

From tblUnit un, tblUser us, tblUserPolicyAccess upa

Where (un.OrganisationID = @organisationID)
and
(
us.Active=1
)
--0. Join Unit and User tables
and (
un.UnitID = us.UnitID
)
-- Join User and UserProfilePeriodAccess tables
and (
us.UserID = upa.UserID
)
and (
upa.PolicyID = @PolicyID
)
--1. Within the selected Parent Units (can select multiple units)
--The unit hierarchy contains the parent Unit ID
--and (
--un.UnitID in
--	(
--		Select IntValue from dbo.udfCsvToInt(@parentUnitIDs)
--	)
--	or (@parentUnitIDs='''')
--	)
--2. User firstname contains the entered text
--and (
--	(firstname like ''%''+ @firstName + ''%'')
--	or (firstname ='''')
--    )
--3. User lastname contains the entered text
--and (
--	(lastname like ''%''+ @lastName + ''%'')
--	or (lastname ='''')
--    )
-- User username contains the entered text
--and (
--	(username like ''%'' + @userName + ''%'')
--	or (userName='''')
--	)
-- User email contains the entered text
--and (
--	(email like ''%'' + @Email + ''%'')
--	or (email='''') or (email = null)
--	)
-- User externalid contains the entered text
--and (
--	(externalID like ''%'' + @ExternalID + ''%'' )
--	or (externalID = '''') or (externalid = null)
--	)
--4. Permission
--Salt Administrator(1), Organisation Administrator(2) has permission to access all units
--Unit Administrator(3) only has permission to those that he is administrator
and (
(@intUserTypeID<3)
or (un.UnitID in (select UnitID from tblUnitAdministrator where UserID=@adminUserID))
)
and upa.Granted=1
Order By Name
End
' 
END
GO
