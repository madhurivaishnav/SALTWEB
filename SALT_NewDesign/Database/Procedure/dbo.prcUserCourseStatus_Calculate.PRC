SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUserCourseStatus_Calculate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*Summary:
Returns the current course status for a user - course

Returns:
int CourseStatusID

Called By:
trgUserQuizStatus
Calls:
trigger

Remarks:

QuizStatusID Status
------------ --------------------------------------------------
0            Unassigned
1            Not Started
2            Passed
3            Failed
4            Expired (Time Elapsed)
5            Expired (New Content)


CourseStatusID Status
-------------- --------------------------------------------------
0              Unassigned
1              InComplete
2              Complete

Author: Stepehn Clark
Date Created: 24 March 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1 S K-Clark	7 March 2005	Access to a course but no modules in it is now considered for compliance as no access to the course
3.0.24 Li Zhang		09-02-2007		Avoid use the row count result of vwUserQuizStatus and vwUserModule in calculating the user course status
 Chris Plewright	20-11-2013		Check for expiry, and return incomplete.

exec @intCurrentCourseStatus = prcUserCourseStatus_GetStatus @CourseID = @intCourseID, @UserID = @int@UserID
exec @intNewCourseStatus = prcUserCourseStatus_Calculate @CourseID = @intCourseID, @UserID = @intUserID

DECLARE @return_status int
EXEC @return_status = prcUserCourseStatus_Calculate @CourseID = 19, @userID = 1108
SELECT ''Return Status'' = @return_status


**/



CREATE       Procedure [dbo].[prcUserCourseStatus_Calculate]
(
@CourseID int	-- The course ID
, @UserID int 	-- The user ID
)
AS
------------------------------------
Set Nocount On

--< if all the users results for this quiz are passed then the course was completed >--
Declare @intStatus int, -- Return Value
@intRowCount int

declare @tblUserQuizStatus table
(
ModuleID    int
, QuizStatusID int
, QuizFrequency int
, QuizPassMark int
, QuizScore   int
, DateCreated  datetime
, DateLastReset datetime
)

insert into
@tblUserQuizStatus
(
ModuleID
, QuizStatusID
, QuizFrequency
, QuizPassMark
, QuizScore
, DateCreated
, DateLastReset
)
select
vUQS.ModuleID
, vUQS.QuizStatusID
, vUQS.QuizFrequency
, vUQS.QuizPassMark
, vUQS.QuizScore
, vUQS.DateCreated
, vUQS.DateLastReset
from
(
	select
	QuizStatus.UserQuizStatusID
	, QuizStatus.UserID
	, QuizStatus.ModuleID
	, m.CourseID
	, QuizStatus.QuizStatusID
	, QuizStatus.QuizFrequency
	, QuizStatus.QuizPassMark
	, QuizStatus.QuizSessionID
	, QuizStatus.QuizScore
	, QuizStatus.DateCreated
	, QuizStatus.DateLastReset
	from
	tblUserQuizStatus QuizStatus
	inner join tblModule m on m.ModuleID = QuizStatus.ModuleID AND m.CourseID = @CourseID
	inner join
		(
		select
		max(UserQuizStatusID) UserQuizStatusID --UserQuizStatusID is identity
		from
		tblUserQuizStatus
		WHERE
		tblUserQuizStatus.UserID = @userID
		group by
		UserID,moduleID
		) currentStatus
	on QuizStatus.UserQuizStatusID = currentStatus.UserQuizStatusID
	where m.active = 1
) vUQS
inner join
(
	Select
	tU.UserID
	, tU.FirstName
	, tU.LastName
	, tU.UnitID
	, tU.OrganisationID
	, tM.ModuleID
	, tM.CourseID
	, tC.Name ''CourseName''
	, tM.Name
	, tM.Sequence
	, tM.Description
	From
	dbo.tblUser tU
	--< get the courses a user has access to >--
	Inner Join dbo.tblOrganisationCourseAccess tOCA
	On  tOCA.OrganisationID = tU.OrganisationID
	--< get the course details >--
	Inner join dbo.tblCourse tC
	On tC.CourseID = tOCA.GrantedCourseID
	--< get the Active modules in a course >--
	inner join dbo.tblModule tM
	On tM.CourseID = tC.CourseID
	and tM.Active = 1
	--< get the details on which moduels a user is configured to access >--
	Left Outer join dbo.tblUserModuleAccess tUsrMA
	On  tUsrMA.UserID = tU.UserID
	And tUsrMA.ModuleID = tM.ModuleID
	--< get the details on which moduels a users Unit is excluded from  >--
	Left Outer Join dbo.tblUnitModuleAccess tUnitMA
	On  tUnitMA.UnitID = tU.UnitID
	And tUnitMA.DeniedModuleID = tM.ModuleID
	Where
	tC.CourseID = @CourseID AND tU.UserID = @UserID
	--AND tU.Active = 1
	--< Active users only >--
	and tu.UnitID is not null
	--< Get the modules that the users Unit is not denied >--
	and (tUnitMA.DeniedModuleID  is null
	--<  and the user does not have special access to  it>--
	And tUsrMA.ModuleID is null)
	--< or Get modules that the user has been specially  granted
	or tUsrMA.Granted=1
) vUMA
on
vUQS.ModuleID = vUMA.ModuleID
and vUQS.CourseID = @CourseID
and vUQS.UserID = @userID
and vUMA.CourseID = @CourseID
and vUMA.UserID = @userID



-- get the rowcount
set @intRowCount = @@RowCount

-- if nothing was returned then there is something wrong (scheduled task has not been run ??)

if @intRowCount = 0
Begin --1
/***** this logic has been changed
Previoulsy:
If a person had access to a course but not to any modules
in the course then they still have access to the the course as far as compliance is concerned
Now:
If a person does not have access to any modules in a course then from the point of view of
compliance reporting they do not have access to the course
*/
return 0 -- unassigned ?
End --/1

-- if there are any results for anything other than passed then the course is incomplete
if exists (select ModuleID from @tblUserQuizStatus where QuizStatusID <> 2)
Begin --4
return  1 --Incomplete
End --/4

-- if there are ANY passes, but NONE of them were created AFTER the expiry or quiz reset dates, then return as Incomplete.
-- this is needed because the user may have passed the course initially, but was later unassigned from the module, 
--  and so didnt get marked as unassigned during the time when the course was expired or quiz reset.  
--  then the user may have been re-assigned to the module, but is still left with a previous completed 
--  status from a course that would have expired if they were active at that time of expiry or quiz reset.
if exists (select ModuleID from @tblUserQuizStatus where QuizStatusID = 2)
begin
	---there were passes, BUT - quiz reset date so incomplete...
	if exists ( select ModuleID from @tblUserQuizStatus where QuizStatusID = 2 and  DateLastReset is not null)
	Begin 
	  return  1 --Incomplete
	End
	
	-- check expiry...
	declare @intQuizFrequency int
	SELECT @intQuizFrequency = (
		SELECT  TOP 1   ISNULL(ur.QuizFrequency, o.DefaultQuizFrequency)
		FROM   	tblUnitRule AS ur 
		RIGHT JOIN tblUser AS u ON ur.UnitID = u.UnitID
		INNER JOIN tblOrganisation AS o ON u.OrganisationID = o.OrganisationID
		WHERE	u.UserID = @UserID
		)

	declare @dtmQuizCompletionDate datetime 
	set @dtmQuizCompletionDate = null
	SET @dtmQuizCompletionDate = (
		SELECT  TOP 1	ISNULL(ur.QuizCompletionDate, o.DefaultQuizCompletionDate)
		FROM   	tblUnitRule AS ur 
		RIGHT JOIN tblUser AS u ON ur.UnitID = u.UnitID
		INNER JOIN tblOrganisation AS o ON u.OrganisationID = o.OrganisationID
		WHERE	u.UserID = @UserID
		)

	if (@dtmQuizCompletionDate is null and @intQuizFrequency is not null)
	begin
	  select @dtmQuizCompletionDate  = ISNULL(@dtmQuizCompletionDate , dateadd(mm,0-@intQuizFrequency,GETDATE()))
	end
   
	if @dtmQuizCompletionDate is not null AND not exists ( select ModuleID from @tblUserQuizStatus where QuizStatusID = 2 and DateCreated > @dtmQuizCompletionDate )
	Begin 
	  return  1 --Incomplete
	End 
end

---

select * into #tblTemp from
(
Select
tU.UserID
, tU.FirstName
, tU.LastName
, tU.UnitID
, tU.OrganisationID
, tM.ModuleID
, tM.CourseID
, tC.Name ''CourseName''
, tM.Name
, tM.Sequence
, tM.Description
From
dbo.tblUser tU
--< get the courses a user has access to >--
Inner Join dbo.tblOrganisationCourseAccess tOCA
On  tOCA.OrganisationID = tU.OrganisationID
--< get the course details >--
Inner join dbo.tblCourse tC
On tC.CourseID = tOCA.GrantedCourseID
--< get the Active modules in a course >--
inner join dbo.tblModule tM
On tM.CourseID = tC.CourseID
and tM.Active = 1
--< get the details on which moduels a user is configured to access >--
Left Outer join dbo.tblUserModuleAccess tUsrMA
On  tUsrMA.UserID = tU.UserID
And tUsrMA.ModuleID = tM.ModuleID
--< get the details on which moduels a users Unit is excluded from  >--
Left Outer Join dbo.tblUnitModuleAccess tUnitMA
On  tUnitMA.UnitID = tU.UnitID
And tUnitMA.DeniedModuleID = tM.ModuleID
Where
tC.CourseID = @CourseID AND tU.UserID = @UserID
-- AND tU.Active = 1
--< Active users only >--
and tu.UnitID is not null
--< Get the modules that the users Unit is not denied >--
and (tUnitMA.DeniedModuleID  is null
--<  and the user does not have special access to  it>--
And tUsrMA.ModuleID is null)
--< or Get modules that the user has been specially  granted
or tUsrMA.Granted=1
) as vwUserModuleAccess where userID = @UserID and courseID=@CourseID
SET @intRowCount = @@RowCount
--  all the quizes are passed then the course is complete
if  (select count(ModuleID) from @tblUserQuizStatus where QuizStatusID = 2) = @intRowCount
Begin --5
return 2 --Complete
End --/5
drop table #tblTemp

-- Code should never fall through to here, but just in case
return 1 -- Incomplete


' 
END
GO
