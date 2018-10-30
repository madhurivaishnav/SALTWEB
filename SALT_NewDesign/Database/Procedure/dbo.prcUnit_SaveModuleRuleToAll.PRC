SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUnit_SaveModuleRuleToAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:
Populate the compliance rules to all modules in the course

Called By: Unit.cs
Calls: None

Remarks:

Author: Jack Liu
Date Created: 18th of February 2004


Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

prcUnit_SaveModuleRuleToAll 1, 1

*/

CREATE  Procedure [prcUnit_SaveModuleRuleToAll]
(
@unitID Int,
@courseID int,
@lessonFrequency int,
@quizFrequency int,
@quizPassMark int,
@lessonCompletionDate DateTime = Null, -- Lesson completion date
@quizCompletionDate DateTime = Null, -- Quiz completion date
@adminUserID int,
@OrgID int
)

As

set nocount on

set xact_abort on
Begin Tran

set @lessonCompletionDate = dbo.udfDaylightSavingTimeToUTC(@lessonCompletionDate, @OrgID)
set @quizCompletionDate = dbo.udfDaylightSavingTimeToUTC(@quizCompletionDate, @OrgID)

Delete tblUnitRule
from tblUnitRule ur
inner join tblModule m
on  ur.ModuleID  = m.ModuleID
where ur.UnitID=@unitID
and m.CourseId= @courseID

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
Select 	@unitID,
m.ModuleID,
@lessonFrequency,
@quizFrequency,
@quizPassMark,
@lessonCompletionDate,
@quizCompletionDate,
@adminUserID,
GETUTCDATE()
From tblModule m
where m.CourseId= @courseID

commit tran





' 
END
GO
