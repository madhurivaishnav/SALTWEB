SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUnit_GetUnitNames]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
Summary:
Convert unit IDs  array such as  ''''1,2,5,7'''' to Unit names array  ''''Unit 1, Unit 1 > Unit 2 > Unit 5 > Unit 7, Unit 1 > Unit 2 > Unit 5 > Unit 7''''

Called By:

Calls:

Remarks:


Author: Jack Liu
Date Created: 1 Apr 2005

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

exec prcUnit_GetUnitNames ''''19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,84''''

**/
CREATE  Procedure [prcUnit_GetUnitNames]
(
@unitIDs varchar(4000)
)
as
declare	@unitNames varchar(8000)

select @UnitIDs='',''+@UnitIDs+'',''

--Convert unit IDs  ''''1,2,5,7'''' to Unit names ''''Unit 1, Unit 1 > Unit 2 > Unit 5 > Unit 7, Unit 1 > Unit 2 > Unit 5 > Unit 7''''


--dbo.udfGetUnitPathway(u.UnitID) as Pathway,

--char(13)+char(10)
select @unitNames=IsNull(@unitNames+'' , '','''')+dbo.udfGetUnitPathway(tblUnit.UnitID)
from tblUnit
where charindex(@UnitIDs, '',''+cast(UnitID as varchar)+'','')>0
order by Hierarchy

select @unitNames as UnitNames
' 
END
GO
