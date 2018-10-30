SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUnit_GetUnitsByOrganisation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Get all units in the specified organisation

Returns:
Flat  hierarchy table


Called By:
Calls:

Remarks:
This procedure will be used by many other procedures to get unit tree for special purpose.
The @disabledUnitIDs, @selectedUnitIDs, @expandedUnitIDs parameters are comma delimited string, such as ''1,34,67''
These strings will be different according different criteria.
For example: For unit administrators, they only have permission to manage the units  that the administrator  has administration rights

if  @parentUnitID is not null, it will show all sub units of this unit

The returned flat  hierarchy table will be used by UnitTreeConvert.xslt to convert to hierarchy tree document.
The standard tree document can be used by TreeView  Control

Author:
Jack Liu
Date Created: 6 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


prcUnit_GetUnitsByOrganisation 3,'''','''','''',1
prcUnit_GetUnitsByOrganisation 3, ''1,4,5''

**/

CREATE  PROC [prcUnit_GetUnitsByOrganisation]
(
@organisationID  int,
@disabledUnitIDs varchar(4000)=null,
@selectedUnitIDs varchar(4000)=null,
@expandedUnitIDs varchar(4000)=null,
@parentUnitID	int =null,
@includingInactiveUnits bit = 0
)

AS


set nocount on
declare @strParentHierarchy varchar(500)

set @disabledUnitIDs = '','' + @disabledUnitIDs  + '',''
set @selectedUnitIDs = '','' + @selectedUnitIDs + '',''
set @expandedUnitIDs= '','' + @expandedUnitIDs + '',''

if (@includingInactiveUnits = 1)
begin
-- Return Only Units that are currently active
if (@parentUnitID>0)
select @strParentHierarchy = Hierarchy +'',%''
from tblUnit
where UnitID=@parentUnitID
else
set @strParentHierarchy=''%'';

SELECT 	UnitID,
case
when ParentUnitID = @parentUnitID then null
else ParentUnitID
end as ParentUnitID,

case
when Active=0 then [Name] +'' (I)''
else [Name]
end as Name,

case
when charindex('','' + cast(UnitID as varchar)+'','', @disabledUnitIDs)>0 then 1
else 0
end as Disabled,
case
when charindex('','' + cast(UnitID as varchar)+'','', @selectedUnitIDs)>0 then 1
else 0
end as Selected,
case
when charindex('','' + cast(UnitID as varchar)+'','', @expandedUnitIDs)>0 then 1
else 0
end as Expanded
from tblUnit as Unit
where OrganisationID =@organisationID
and Hierarchy like @strParentHierarchy
order by Hierarchy
end
else
begin
if (@parentUnitID>0)
select @strParentHierarchy = Hierarchy +'',%''
from tblUnit
where UnitID=@parentUnitID
else
set @strParentHierarchy=''%'';

SELECT 	UnitID,
case
when ParentUnitID = @parentUnitID then null
else ParentUnitID
end as ParentUnitID,

[Name],

case
when charindex('','' + cast(UnitID as varchar)+'','', @disabledUnitIDs)>0 then 1
else 0
end as Disabled,
case
when charindex('','' + cast(UnitID as varchar)+'','', @selectedUnitIDs)>0 then 1
else 0
end as Selected,
case
when charindex('','' + cast(UnitID as varchar)+'','', @expandedUnitIDs)>0 then 1
else 0
end as Expanded
from tblUnit as Unit
where OrganisationID =@organisationID
and Hierarchy like @strParentHierarchy
and Active = 1
order by Hierarchy
end
' 
END
GO
