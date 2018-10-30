SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUserLessonStatus_Update_Quick]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/* Summary:
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

If a module is assigned to a user, and there is no activity for this module, the status will be  ''''Not started''''.
If a module is unassigned from a user, the status will be ''''unassinged"(There are records in status table, but the module is not assigned to this user now)
If a module is set to inactive, the status will be ''''unassinged''''

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
CREATE Procedure [prcUserLessonStatus_Update_Quick]
(
@OrgID int	-- comma separated organisationID
)
AS
Set Nocount On



--##################################################################################################################
/*
2. Add New lesson status

2.1.     N O T      A S S I G N E D      M O D U L E S
(0) (PreviousAssignedModules - CurrentAssignedModules)
Add record of 0 (unassigned) to tblUserLessonStatus for each User-Module that has been started but now has no Course access or is specifically excluded at unit/user level
*/
--##################################################################################################################
insert into tblUserLessonStatus
(
UserID,
ModuleID,
LessonStatusID
)
select pam.UserID,
pam.ModuleID,
0  as QuizStatusID --Unassigned (0)
from

(
SELECT LessonStatus.UserID, LessonStatus.ModuleID
FROM  dbo.tblUserCurrentLessonStatus as LessonStatus
inner join tblUser on tblUser.UserID = LessonStatus.UserID and tblUser.OrganisationID = @OrgID
WHERE  (LessonStatus.Excluded = 0) OR (LessonStatus.Excluded IS NULL)
AND (LessonStatus.UserLessonStatusID <> 0)
and 	LessonStatus.LessonStatusID<>0 --not Unassigned (0)
)  pam


left join (SELECT tU.UserID, tM.ModuleID, CASE WHEN (ur.LessonFrequency IS NULL AND ur.LessonCompletionDate IS NULL AND o.DefaultLessonCompletionDate IS NULL)
THEN o.DefaultLessonFrequency ELSE ur.LessonFrequency END AS LessonFrequency, CASE WHEN (ur.LessonFrequency IS NULL AND
ur.LessonCompletionDate IS NULL AND NOT (o.DefaultLessonCompletionDate IS NULL))
THEN o.DefaultLessonCompletionDate ELSE ur.LessonCompletionDate END AS LessonCompletionDate
FROM  dbo.tblUser AS tU INNER JOIN
tblUnit on tU.UnitID = tblUnit.UnitID and tblUnit.OrganisationID = @OrgID INNER JOIN
dbo.tblOrganisationCourseAccess AS tOCA ON tOCA.OrganisationID = tU.OrganisationID AND tOCA.OrganisationID = @OrgID INNER JOIN
dbo.tblOrganisation AS o ON o.OrganisationID = tOCA.OrganisationID INNER JOIN
dbo.tblModule AS tM ON tM.Active = 1 AND tOCA.GrantedCourseID = tM.CourseID LEFT OUTER JOIN
dbo.tblUserModuleAccess AS tUsrMA ON tUsrMA.UserID = tU.UserID AND tUsrMA.ModuleID = tM.ModuleID LEFT OUTER JOIN
dbo.tblUnitModuleAccess AS tUnitMA ON tUnitMA.UnitID = tU.UnitID AND tUnitMA.DeniedModuleID = tM.ModuleID LEFT OUTER JOIN
dbo.tblUnitRule AS ur ON ur.ModuleID = tM.ModuleID AND ur.UnitID = tU.UnitID
WHERE (tU.Active = 1) AND (tU.UnitID IS NOT NULL) AND (tUnitMA.DeniedModuleID IS NULL) AND (tUsrMA.ModuleID IS NULL) OR
(tUsrMA.Granted = 1)) cam -- Current Assigned Modules

on cam.UserID = pam.UserID
and cam.ModuleID = pam.ModuleID
where cam.moduleID is null
and cam.UserID in (select UserID from tblUser where OrganisationID = @OrgID)



--##################################################################################################################
/*
2.2.      N E W     A S S I G N E D     M O D U L E S
(Not Started(1)) (CurrentAssignedModules- PreviousAssignedModules)
*/
--##################################################################################################################


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
cam.LessonFrequency,
cam.LessonCompletionDate
from
(
SELECT tU.UserID, tM.ModuleID, CASE WHEN (ur.LessonFrequency IS NULL AND ur.LessonCompletionDate IS NULL AND o.DefaultLessonCompletionDate IS NULL)
THEN o.DefaultLessonFrequency ELSE ur.LessonFrequency END AS LessonFrequency, CASE WHEN (ur.LessonFrequency IS NULL AND
ur.LessonCompletionDate IS NULL AND NOT (o.DefaultLessonCompletionDate IS NULL))
THEN o.DefaultLessonCompletionDate ELSE ur.LessonCompletionDate END AS LessonCompletionDate
FROM  dbo.tblUser AS tU INNER JOIN
tblUnit on tU.UnitID = tblUnit.UnitID and tblUnit.OrganisationID = @OrgID INNER JOIN
dbo.tblOrganisationCourseAccess AS tOCA ON tOCA.OrganisationID = tU.OrganisationID AND tOCA.OrganisationID = @OrgID INNER JOIN
dbo.tblOrganisation AS o ON o.OrganisationID = tOCA.OrganisationID INNER JOIN
dbo.tblModule AS tM ON tM.Active = 1 AND tOCA.GrantedCourseID = tM.CourseID LEFT OUTER JOIN
dbo.tblUserModuleAccess AS tUsrMA ON tUsrMA.UserID = tU.UserID AND tUsrMA.ModuleID = tM.ModuleID LEFT OUTER JOIN
dbo.tblUnitModuleAccess AS tUnitMA ON tUnitMA.UnitID = tU.UnitID AND tUnitMA.DeniedModuleID = tM.ModuleID LEFT OUTER JOIN
dbo.tblUnitRule AS ur ON ur.ModuleID = tM.ModuleID AND ur.UnitID = tU.UnitID
WHERE (tU.Active = 1) AND (tU.UnitID IS NOT NULL) AND (tUnitMA.DeniedModuleID IS NULL) AND (tUsrMA.ModuleID IS NULL) OR
(tUsrMA.Granted = 1)
) cam
left join
(
SELECT LessonStatus.UserID, LessonStatus.ModuleID
FROM  dbo.tblUserCurrentLessonStatus as LessonStatus
inner join tblUser on tblUser.UserID = LessonStatus.UserID and tblUser.OrganisationID = @OrgID
WHERE  (LessonStatus.Excluded = 0) OR (LessonStatus.Excluded IS NULL)
AND (LessonStatus.UserLessonStatusID <> 0)
and 	LessonStatus.LessonStatusID<>0 --not Unassigned (0)
)  pam
on cam.UserID = pam.UserID
and cam.ModuleID = pam.ModuleID
where pam.moduleID is null



--##################################################################################################################
/*
2.3.       E X P I R E D    M O D U L E S
(Time Elapsed)(4): Expired a lesson if the cycle started date is past the lesson frequency
a)Get the last cycle started date which current lesson status is In Progress (2), or Completed(3)
b)If the cycle started date is past the current lesson frequency, the new status is Expired (Time Expired)(4)
*/
--##################################################################################################################




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
from (
select 	max(LastStarted.UserLessonStatusID) LastStartedStatusID
from tblUserLessonStatus LastStarted
inner join
(
SELECT LessonStatus.UserLessonStatusID, LessonStatus.UserID, LessonStatus.ModuleID, m.CourseID, LessonStatus.LessonStatusID, LessonStatus.LessonFrequency,
LessonStatus.DateCreated
FROM  dbo.tblUserCurrentLessonStatus as LessonStatus
inner join tblUser on tblUser.UserID = LessonStatus.UserID and tblUser.OrganisationID = @OrgID
inner join tblModule m on m.ModuleID = LessonStatus.ModuleID

WHERE  (LessonStatus.Excluded = 0) OR (LessonStatus.Excluded IS NULL)
) CurrentStatus
on  LastStarted.UserID = CurrentStatus.UserID
and  LastStarted.ModuleID = CurrentStatus.ModuleID
and CurrentStatus.LessonStatusID in (2,3)
where LastStarted.LessonStatusID = 2
and LastStarted.UserID in (select UserID from tblUser where OrganisationID = @OrgID)
group by LastStarted.UserID, LastStarted.moduleID
) lss
inner join tblUserLessonStatus uls
on uls.UserLessonStatusID = lss.LastStartedStatusID
inner join (SELECT tU.UserID, tM.ModuleID, CASE WHEN (ur.LessonFrequency IS NULL AND ur.LessonCompletionDate IS NULL AND o.DefaultLessonCompletionDate IS NULL)
THEN o.DefaultLessonFrequency ELSE ur.LessonFrequency END AS LessonFrequency, CASE WHEN (ur.LessonFrequency IS NULL AND
ur.LessonCompletionDate IS NULL AND NOT (o.DefaultLessonCompletionDate IS NULL))
THEN o.DefaultLessonCompletionDate ELSE ur.LessonCompletionDate END AS LessonCompletionDate
FROM  dbo.tblUser AS tU INNER JOIN
dbo.tblOrganisationCourseAccess AS tOCA ON tOCA.OrganisationID = tU.OrganisationID AND tOCA.OrganisationID = @OrgID INNER JOIN
dbo.tblOrganisation AS o ON o.OrganisationID = tOCA.OrganisationID INNER JOIN
dbo.tblUnit AS u ON u.OrganisationID = tU.OrganisationID and u.UnitID = tU.UnitID INNER JOIN
dbo.tblModule AS tM ON tM.Active = 1 AND tOCA.GrantedCourseID = tM.CourseID LEFT OUTER JOIN
dbo.tblUserModuleAccess AS tUsrMA ON tUsrMA.UserID = tU.UserID AND tUsrMA.ModuleID = tM.ModuleID LEFT OUTER JOIN
dbo.tblUnitModuleAccess AS tUnitMA ON tUnitMA.UnitID = tU.UnitID AND tUnitMA.DeniedModuleID = tM.ModuleID LEFT OUTER JOIN
dbo.tblUnitRule AS ur ON ur.ModuleID = tM.ModuleID AND ur.UnitID = tU.UnitID
WHERE (tU.Active = 1) AND (tU.UnitID IS NOT NULL) AND (tUnitMA.DeniedModuleID IS NULL) AND (tUsrMA.ModuleID IS NULL) OR
(tUsrMA.Granted = 1)) cam
on cam.UserID = uls.UserID
and cam.ModuleID = uls.ModuleID
where
(
cam.LessonCompletionDate is null
and DateDiff(day,getutcdate(), dateadd(month, cam.LessonFrequency, uls.DateCreated)) <= 0
)
or
(
isnull(DateDiff(day, getutcdate(), cam.LessonCompletionDate), 1) <= 0
)
and cam.UserID in (select UserID from tblUser where OrganisationID = @OrgID)
--Expired





--##################################################################################################################
-- Extend completion dates
update tblOrganisation
set DefaultLessonCompletionDate = dateadd(year, 1, [DefaultLessonCompletionDate])
where DefaultLessonCompletionDate < getutcdate() and OrganisationID = @OrgID

--##################################################################################################################
update tblUnitRule
set LessonCompletionDate = dateadd(year, 1, [LessonCompletionDate])
where LessonCompletionDate < getutcdate() and UnitID IN (select UnitID from tblUnit where OrganisationID = @OrgID)
-- /Extend completion dates
--##################################################################################################################




SET QUOTED_IDENTIFIER ON
' 
END
GO
