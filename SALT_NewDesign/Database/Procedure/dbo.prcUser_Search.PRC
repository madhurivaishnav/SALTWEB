SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_Search]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*Summary:
The procedure will search within the selected Parent Units for those Users whose name contains the entered first and last names.
(If no Parent Units have been selected, the system will search across the whole organisation.)

Returns:
Unit Name
Full pathway

Called By:
Calls:

Remarks:
The searching units will include all children and grandchildren
Only return users that logged on user has permission to see


Author: Gavin Buddis
Date Created: 2 Mar 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	Aaron		27/03/2007		@parentUnitIDs modified from Varchar(500)


**/

CREATE  Procedure  [dbo].[prcUser_Search]
(
@organisationID  Int,
@parentUnitIDs  Varchar(max),
@firstName	nVarchar(100),
@lastName	nVarchar(100),
@adminUserID		Int,
@includeInactiveUsers bit
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



if (@includeInactiveUsers = 0)
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
us.Active

From tblUnit un, tblUser us

Where (un.OrganisationID = @organisationID)
and
(
us.Active=1
)
--0. Join Unit and User tables
and (
un.UnitID = us.UnitID
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
--4. Permission
--Salt Administrator(1), Organisation Administrator(2) has permission to access all units
--Unit Administrator(3) only has permission to those that he is administrator
and (
(@intUserTypeID<3)
or (un.UnitID in (select UnitID from tblUnitAdministrator where UserID=@adminUserID))
)
Order By Name
End
Else
Begin
Select 	us.UserID,
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
us.Active

From tblUnit un, tblUser us

Where (un.OrganisationID = @organisationID)
--0. Join Unit and User tables
and (
un.UnitID = us.UnitID
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
--4. Permission
--Salt Administrator(1), Organisation Administrator(2) has permission to access all units
--Unit Administrator(3) only has permission to those that he is administrator
and (
(@intUserTypeID<3)
or (un.UnitID in (select UnitID from tblUnitAdministrator where UserID=@adminUserID))
)
Order By Name
End
' 
END
GO
