SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUnit_GetModuleRule]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
Summary:
Gets unit module compliance rules

Called By: Unit.cs
Calls: None

Remarks: Raises an error if the parameter is null

Author: Jack Liu
Date Created: 18th of February 2004


Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

prcUnit_GetModuleRule 1, 1

*/

CREATE  Procedure [prcUnit_GetModuleRule]
(
@unitID Int,
@courseID int
)

As

set nocount on

Select 	m.ModuleID,
m.Name,
umr.UsingDefault,
isnull(umr.LessonFrequency, 0) as LessonFrequency,
isnull(umr.QuizFrequency, 0) as QuizFrequency,
umr.QuizPassMark,
dbo.udfUTCtoDaylightSavingTime(umr.LessonCompletionDate, u.OrganisationID) as LessonCompletionDate,
dbo.udfUTCtoDaylightSavingTime(umr.QuizCompletionDate, u.OrganisationID) as QuizCompletionDate
From vwUnitModuleRule umr
inner join tblModule m 	on m.ModuleID=  umr.ModuleID
join tblUnit u on u.UnitID = umr.UnitID
where umr.UnitID = @unitID
and umr.CourseId= @courseID
order by m.Sequence
' 
END
GO
