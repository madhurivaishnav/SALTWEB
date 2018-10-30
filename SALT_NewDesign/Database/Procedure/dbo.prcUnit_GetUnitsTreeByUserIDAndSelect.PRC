SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUnit_GetUnitsTreeByUserIDAndSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Get all units in the specified organisation and can be selected by the specified user.
The default selected unit is passed in via the @selectedUnitID parameter.
All parents of the selected unit back up the the root of the tree will be expanded.

Returns:
Flat hierarchy table


Called By:
User.cls
Calls:
prcUnit_GetUnitsByOrganisation
Remarks:

@permission:
A: [A]dministrator
P: Administrator with [P]ropagating right
S: Administrator of the Unit and all of its [S]ub-units
Empty or null: All units, no permission needed

Author:
Peter Kneale
Date Created: 2 Mar 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


prcUnit_GetUnitsTreeByUserID 3, 5,''S''


**/

CREATE Procedure [prcUnit_GetUnitsTreeByUserIDAndSelect]
(
@organisationID  	Integer,		-- Organisation ID of the calling user
@userID 		Integer, 		-- User ID of the calling user
@permission 		Char(1)=''A'',	-- Permission as described above
@selectedUnitID 	Integer		-- Unit ID of the unit that is to be selected initially
)

AS

set nocount on

-- Declarations

Declare @intUserTypeID	 	Integer		-- User Type of the calling user
Declare @strDisabledUnitIDs 	Varchar(4000)	-- CSV List of disabled units
Declare @strExpandedUnitID 	Varchar(4000)	-- CSV List of expanded Units

Declare @EnableUnit Table
(
UnitID Integer
)
-- Replace null permission with empty string
If @permission is null
Begin
Set @permission=''''
End

-- Get user type
Select
@intUserTypeID = UserTypeID
from
tblUser
where
userID = @userID



--Salt Administrator, Organisation Administrator has permission to access all units
If (@intUserTypeID=1 or @intUserTypeID=2 or @permission='''')
Begin
Insert 	Into
@EnableUnit(UnitID)
Select
u.UnitID
From
tblUnit as u
Where
(u.organisationID=@organisationID)
End

--A: Unit Administrator only has permission to those that he is administrator
Else If @permission=''A''
Begin
--Get a list of unit id that the user is  the administrator
Insert Into
@EnableUnit(UnitID)
Select 	u.UnitID
From 	tblUnit as u
Inner join tblUnitAdministrator as ua
On (u.unitID=ua.unitID)
and (ua.userID = @userID)
Where 	(u.organisationID=@organisationID)

End

--P: Administrator with [P]ropagating right
Else If @permission=''P''
Begin
--Get a list of unit id that the user has [P]ropagating right
Insert Into @EnableUnit(UnitID)
Select 	u.UnitID
From 	tblUnit as u
Inner join tblUnitAdministrator as ua
on (u.unitID=ua.unitID)
and (ua.userID = @userID)
and (ua.propagate=1)
Where 	(u.organisationID=@organisationID)
End
--S: Administrator of the Unit and all of its [S]ub-units
Else If @permission=''S''
Begin
Insert Into @EnableUnit(UnitID)
Select
u.UnitID
From 	tblUnit as u
Inner join tblUnitAdministrator as ua
on (u.unitID=ua.unitID)
and (ua.userID = @userID)
Where 	(u.organisationID=@organisationID)
and not exists(
select su.unitid
from tblUnit su --sub-units
left join tblUnitAdministrator ua
on su.unitID=ua.unitID
and ua.userID = @userID
where su.hierarchy+'','' like u.hierarchy+'',%'' --Current Unit and all sub-units
and ua.unitID is null	--Not administrator
)--Administrator of all sub-units
end

--Get a list of unit id that the user dn''t have permission
Select
@strDisabledUnitIDs= isNull(@strDisabledUnitIDs + '','','''')+ cast(u.unitID as varchar)
From
tblUnit as u
left join @EnableUnit as eu
on (u.unitID=eu.unitID)
Where
(u.organisationID=@organisationID)
and eu.UnitID is null

-- Get the hierarchy in CSV format down to this unit so that they can be expanded and make the
-- selected unit visible
Select
@strExpandedUnitID = Hierarchy
From
tblUnit
Where
UnitID = @selectedUnitID

-- Get the Tree
Exec prcUnit_GetUnitsByOrganisation @organisationID, @strDisabledUnitIDs,@selectedUnitID, @strExpandedUnitID
' 
END
GO
