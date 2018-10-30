SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisation_CheckUnitTree]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Check and rebuild unit tree hierarchy for a specified organisation,


Returns:
none


Called By:
Calls:

Remarks:
The unit hierarchy data are redundent and may be inconsistent with the actual tree structure

This procedure will guarantee the tree hierarchy are correct.


Author: Jack Liu
Date Created: 6 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


prcOrganisation_CheckUnitTree 3
prcOrganisation_CheckUnitTree


**/

CREATE  PROCEDURE [prcOrganisation_CheckUnitTree]
(
@organisationID  int=null
)
as
set nocount on

declare @intLevel int
declare @intRecordCount int

SET XACT_ABORT On

begin tran
--Initialize
Update tblUnit
set 	[level]=null,
Hierarchy=null
where 	(organisationID = @organisationID)
or (@organisationID is null)

--Build top level
set @intLevel=0

Update tblUnit
set 	[level]=@intLevel+1,
Hierarchy=cast(UnitID as varchar)
where 	((organisationID = @organisationID)
or (@organisationID is null))
and (parentUnitID is null)

set @intRecordCount=@@ROWCOUNT
set @intLevel=@intLevel+1

-- build middle level
while @intRecordCount>0
begin

Update 	tblUnit
set 	[Level]=@intLevel+1,
Hierarchy=parent.Hierarchy + '','' + cast(tblUnit.UnitID as varchar)
from 	tblUnit
inner join tblUnit parent
on tblUnit.ParentUnitID = parent.UnitID
and parent.[Level] = @intLevel
where (tblUnit.organisationID = @organisationID)
or (@organisationID is null)

set @intRecordCount=@@ROWCOUNT
set @intLevel=@intLevel+1
end

COMMIT TRAN
' 
END
GO
