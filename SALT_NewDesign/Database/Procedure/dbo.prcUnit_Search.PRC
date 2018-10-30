SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUnit_Search]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*Summary:
The procedure will search within the selected Parent Units for those Units whose name contains the entered text.
(If not Parent Units have been selected, the system will search across the whole organisation.)

Returns:
Unit Name
Full pathway


Called By:
Calls:

Remarks:
The searching units will include all children and grandchildren
Only return units that user has permission to see


Author: Jack Liu
Date Created: 9 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	Aaron		27/03/2007		@parentUnitIDs type modified from Varchar(500)



prcUnit_Search 3,'''',''unit'''' '',4

**/

CREATE  PROCEDURE [dbo].[prcUnit_Search]
(

@organisationID  int,
@parentUnitIDs  varchar(max),
@unitID int = 0,
@unitName	nvarchar(100),
@userID		int,
@includingInactiveUnits bit = 0
)
as
set nocount on

declare @intUserTypeID int

select @intUserTypeID = UserTypeID
from tblUser
where userID = @userID

--Check Data
if @parentUnitIDs is null
set @parentUnitIDs =''''

if @unitName is null
set @unitName = ''''

set @unitName =rtrim(@unitName)

-- Return all units even those that are inactive
if (@includingInactiveUnits = 1)
Begin

select 	u.UnitID,
case
when u.Active=1 then u.Name
else u.Name + ''(I)''
end as Name,
dbo.udfGetUnitPathway(u.UnitID) as Pathway
from tblUnit u
left join dbo.udfCsvToInt(@parentUnitIDs) as pu on u.UnitID=pu.intValue
where (u.OrganisationID = @organisationID)
--1. Within the selected Parent Units (can select multiple units)
--The unit hierarchy contains the parent Unit ID
and (
pu.intValue is not null
or (@parentUnitIDs='''')
)
--2. Unit name contains the entered text
and (
(name like ''%''+ @unitName + ''%'')
or (name ='''')
)
--3. Permission
--Salt Administrator(1), Organisation Administrator(2) has permission to access all units
--Unit Administrator(3) only has permission to those that he is administrator
and (
(@intUserTypeID<3)
or (u.UnitID in (select UnitID from tblUnitAdministrator where UserID=@userID))
)
order by name
End
Else
Begin
-- Return only active units
select 	u.UnitID,
u.Name,
dbo.udfGetUnitPathway(u.UnitID) as Pathway
from tblUnit u
left join dbo.udfCsvToInt(@parentUnitIDs) as pu on u.UnitID=pu.intValue
where (u.OrganisationID = @organisationID)
-- Active Units Only
and
(u.Active = 1)
and (
pu.intValue is not null
or (@parentUnitIDs='''')
)
--2. Unit name contains the entered text
and (
(name like ''%''+ @unitName + ''%'')
or (name ='''')
)
--3. Permission
--Salt Administrator(1), Organisation Administrator(2) has permission to access all units
--Unit Administrator(3) only has permission to those that he is administrator
and (
(@intUserTypeID<3)
or (u.UnitID in (select UnitID from tblUnitAdministrator where UserID=@userID))
)
-- 4. Unit ID
and (
(@unitID != 0 and u.unitid = @unitID ) or (@unitID = 0 and u.unitid > 0)
)
order by name
End



' 
END
GO
