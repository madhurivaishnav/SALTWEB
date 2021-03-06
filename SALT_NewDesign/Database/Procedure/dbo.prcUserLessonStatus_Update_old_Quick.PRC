/****** Object:  StoredProcedure [dbo].[prcUserLessonStatus_Update_old_Quick]    Script Date: 12/19/2012 15:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUserLessonStatus_Update_old_Quick]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/* Summary:
Update lesson status for each user
This schedule task only updates three status:
Unassigned Modules (0)
New Assigned Modules (Not Started(1))
Expired Modules (Time Elapsed)(4)

Returns:

Called By:

Calls:
Nothing

Remarks:
This is a schedule job running every night to check there are any changes in the user lesson status based on current compliance rules.
If they are the same as the current status, ignore it, otherwise a new status will be created.

If a module is assigned to a user, and there is no activity for this module, the status will be  ''Not started''.
If a module is unassigned from a user, the status will be ''unassinged"(There are records in status table, but the module is not assigned to this user now)
If a module is set to inactive, the status will be ''unassinged''

------------ Decision Processes -------------

1. Get CurrentAssignedModules and PreviousAssignedModules
1.1  CurrentAssignedModules
Get all modules that are currently assigned to each users
and compliance rules

1.2  PreviousAssignedModules
Get a list of modules that is in the lesson status table that the last statuses are not Unassigned (0)

2. Add New lesson status
2.1. Unassigned Modules (0) (PreviousAssignedModules - CurrentAssignedModules)

2.2. New Assigned Modules (Not Started(1)) (CurrentAssignedModules- PreviousAssignedModules)

2.3. Expired Modules (Time Elapsed)(4): Expired a lesson if the cycle started date is past the lesson frequency
a)Get the last cycle started date which current lesson status is In Progress (2), or Completed(3)
b)If the cycle started date is past the current lesson date/frequency, the new status is Expired (Time Expired)(4)



------------ Data need to be recorded -------------

LessonFrequency
0  Unassigned:  		-
1  Not Started: 		Y
4  Expired (Time Elapsed): 	Y


Author: Jack Liu
Date Created: 21 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	mikev		1/5/2007		Added LessonCompletionDate

prcUserLessonStatus_Update

**/
CREATE Procedure [prcUserLessonStatus_Update_old_Quick]
(
@OrgID int	-- comma separated organisationID
)
AS
Set Nocount On

/*

1. Get CurrentAssignedModules and PreviousAssignedModules
1.1  CurrentAssignedModules
Get all modules that are currently assigned to each users
and compliance rules
*/

-- mikev(1): added lessonCompletionDate
select 	um.UserID,
um.ModuleID,
umr.LessonFrequency,
umr.LessonCompletionDate
into #tblCurrentAssignedModules
from vwUserModuleAccess um
inner join vwUnitModuleRule umr
on umr.ModuleID  = um.ModuleID
and umr.UnitID = um.UnitID
where um.UnitID in (select UnitID from tblUnit where OrganisationID = @OrgID)
and um.UserID IN (select UserID from tblUser where OrganisationID = @OrgID)


-- select * from #tblCurrentAssignedModules
/*
1.2  PreviousAssignedModules
Get a list of modules that is in the lesson status table that the last statuses are not Unassigned (0)

*/

select 	uls.UserID,
uls.ModuleID
into #PreviousAssignedModules
from vwUserLessonStatus uls
where 	uls.LessonStatusID<>0 --not Unassigned (0)
and uls.UserID IN (select UserID from tblUser where OrganisationID = @OrgID)

/*
2. Add New lesson status
2.1. Unassigned Modules (0) (PreviousAssignedModules - CurrentAssignedModules)
*/

insert into tblUserLessonStatus
(
UserID,
ModuleID,
LessonStatusID
)
select pam.UserID,
pam.ModuleID,
0  as QuizStatusID --Unassigned (0)
from #PreviousAssignedModules pam
left join #tblCurrentAssignedModules cam
on cam.UserID = pam.UserID
and cam.ModuleID = pam.ModuleID
where cam.moduleID is null
and cam.UserID in (select UserID from tblUser where OrganisationID = @OrgID)


/*
2.2. New Assigned Modules (Not Started(1)) (CurrentAssignedModules- PreviousAssignedModules)
*/

-- mikev(1): Added LessonCompletionDate
insert into tblUserLessonStatus
(
UserID,
ModuleID,
LessonStatusID,
LessonFrequency,
LessonCompletionDate
)
select cam.UserID,
cam.ModuleID,
1  as LessonStatusID,--Not Started(1)
cam.LessonFrequency, cam.LessonCompletionDate
from #tblCurrentAssignedModules cam
left join #PreviousAssignedModules pam
on cam.UserID = pam.UserID
and cam.ModuleID = pam.ModuleID
where pam.moduleID is null
and cam.UserID in (select UserID from tblUser where OrganisationID = @OrgID)

/*
2.3. Expired Modules (Time Elapsed)(4): Expired a lesson if the cycle started date is past the lesson frequency
a)Get the last cycle started date which current lesson status is In Progress (2), or Completed(3)
b)If the cycle started date is past the current lesson frequency, the new status is Expired (Time Expired)(4)
*/

select 	max(LastStarted.UserLessonStatusID) LastStartedStatusID
into #tblLastStartedStatus
from tblUserLessonStatus LastStarted
inner join vwUserLessonStatus CurrentStatus
on  LastStarted.UserID = CurrentStatus.UserID
and  LastStarted.ModuleID = CurrentStatus.ModuleID
and CurrentStatus.LessonStatusID in (2,3)
where LastStarted.LessonStatusID = 2
and LastStarted.UserID in (select UserID from tblUser where OrganisationID = @OrgID)
group by LastStarted.UserID, LastStarted.moduleID

-- mikev(1): added LessonCompletionDate
insert into tblUserLessonStatus
(
UserID,
ModuleID,
LessonStatusID,
LessonFrequency,
LessonCompletionDate
)
select cam.UserID,
cam.ModuleID,
4  as LessonStatusID, --(Time Elapsed)(4)
cam.LessonFrequency, cam.LessonCompletionDate
from #tblLastStartedStatus lss
inner join tblUserLessonStatus uls
on uls.UserLessonStatusID = lss.LastStartedStatusID
inner join #tblCurrentAssignedModules cam
on cam.UserID = uls.UserID
and cam.ModuleID = uls.ModuleID
where
(
cam.LessonCompletionDate is null
and DateDiff(day,GETUTCDATE(), dateadd(month, cam.LessonFrequency, uls.DateCreated)) <= 0
)
or
(
isnull(DateDiff(day, GETUTCDATE(), cam.LessonCompletionDate), 1) <= 0
)
and cam.UserID in (select UserID from tblUser where OrganisationID = @OrgID)
--Expired

drop table #tblCurrentAssignedModules

drop table #PreviousAssignedModules

drop table #tblLastStartedStatus

-- Extend completion dates
update tblOrganisation
set DefaultLessonCompletionDate = dateadd(year, 1, [DefaultLessonCompletionDate])
where DefaultLessonCompletionDate < GETUTCDATE() and OrganisationID = @OrgID

update tblUnitRule
set LessonCompletionDate = dateadd(year, 1, [LessonCompletionDate])
where LessonCompletionDate < GETUTCDATE() and UnitID IN (select UnitID from tblUnit where OrganisationID = @OrgID)
-- /Extend completion dates


SET QUOTED_IDENTIFIER ON
' 
END
GO
