SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUnit_SaveModuleRule]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:
Populate the compliance rules to an individual module

Called By: Unit.cs
Calls: None

Remarks:

Author: Jack Liu
Date Created: 18th of February 2004


Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

prcUnit_SaveModuleRule 1, 1

*/

CREATE  Procedure [prcUnit_SaveModuleRule]
(
@unitID Int,
@moduleID int,
@usingDefault bit,
@lessonFrequency int,
@quizFrequency int,
@quizPassMark int,
@lessonCompletionDate datetime,
@quizCompletionDate datetime,
@adminUserID int,
@OrgID int
)

As

set nocount on

set @lessonCompletionDate = dbo.udfDaylightSavingTimeToUTC(@lessonCompletionDate, @OrgID)
set @quizCompletionDate = dbo.udfDaylightSavingTimeToUTC(@quizCompletionDate, @OrgID)

--1. If the module uses default rules, delete the existing individual rule
if (@usingDefault=1)
begin
Delete
from tblUnitRule
where UnitID=@unitID
and moduleID= @moduleID
end
--2. If the module contains individual rule, update the existing individual rule
else if exists(select ModuleID
from tblUnitRule
where UnitID=@unitID
and moduleID= @moduleID)
begin
Update tblUnitRule
set 	LessonFrequency = @LessonFrequency,
QuizFrequency = @QuizFrequency,
QuizPassMark = @QuizPassMark,
LessonCompletionDate = @lessonCompletionDate,
QuizCompletionDate = @quizCompletionDate,
UpdatedBy = @adminUserID,
DateUpdated =  GETUTCDATE()
where UnitID=@unitID
and moduleID= @moduleID

end
--3. If the module doesn''t contain any individual rule, add the new rule
else
begin
insert into tblUnitRule
(
UnitID,
ModuleID,
LessonFrequency,
QuizFrequency,
QuizPassMark,
LessonCompletionDate,
QuizCompletionDate,
CreatedBy,
DateCreated
)
values (
@unitID,
@moduleID,
@lessonFrequency,
@quizFrequency,
@quizPassMark,
@lessonCompletionDate,
@quizCompletionDate,
@adminUserID,
GETUTCDATE()
)

end





' 
END
GO
