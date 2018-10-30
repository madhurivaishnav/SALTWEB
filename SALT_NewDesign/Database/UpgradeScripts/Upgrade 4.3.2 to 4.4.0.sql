
-- Add Include Inactive checkbox for Warning Report
update tblReportInterface set requiresParamIncludeInactive = 1 where reportid=29


-- add new column of userid to tblEmail
IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tblEmail' 
		AND  COLUMN_NAME = 'UserID')
BEGIN
alter table tblEmail
	add UserID int default null
END
				
/****** Object:  StoredProcedure [dbo].[prcQuizSession_UpdateEndQuizInfo]    Script Date: 03/18/2013 14:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/****** Object:  StoredProcedure [dbo].[prcQuizSession_UpdateEndQuizInfo]    Script Date: 03/18/2013 15:20:54 ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcQuizSession_UpdateEndQuizInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcQuizSession_UpdateEndQuizInfo]
GO
/****** Object:  StoredProcedure [dbo].[prcQuizSession_UpdateEndQuizInfo]    Script Date: 03/18/2013 15:20:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcQuizSession_UpdateEndQuizInfo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Update record in tblQuizSession
Insert record into tblUserQuizStatus
Insert record into tblUserCourseStatus

Returns:
data table

Called By:
ToolBook.cs: UpdateEndQuizInfo

Author: Li Zhang
Date Created: 13-10-2006
Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	mikev		1/5/2007		Added QuizCompletionDate
**/

CREATE PROCEDURE [dbo].[prcQuizSession_UpdateEndQuizInfo]
(
@QuizSessionID	varchar(50) -- unique GUID that identifies this toolbook quiz session
, @Duration	int -- the duration in seconds of the quiz as mesured by toolbook
, @Score 	int -- the score as mesured by toolbook
, @UserID	int	-- user id
, @QuizID	int -- quiz id
, @PassMark	int	-- quiz pass mark
, @UnitID	int	-- user''s unit id
, @ModuleID	int -- quiz module id
, @CourseID	int -- module course id
, @OldCourseStatus	int -- course status before update
, @NewQuizStatus int -- the quiz status
, @NewCourseStatus	int	-- course status after update
, @QuizFrequency	int -- quiz frequency
, @QuizCompletionDate	datetime -- quiz completiondate
)
AS
SET nocount on
SET xact_abort on
BEGIN TRANSACTION

declare @OrgID int
select @OrgID = organisationID from tblUnit where tblUnit.UnitID=@UnitID

set @QuizCompletionDate = dbo.udfDaylightSavingTimeToUTC(@QuizCompletionDate, @OrgID)

DECLARE @dateCreated datetime
SET @dateCreated = GETUTCDATE()

IF EXISTS
(
SELECT QuizSessionID
FROM tblQuizSession
WHERE QuizSessionID = @QuizSessionID
AND	DateTimeStarted IS NOT NULL
AND DateTimeCompleted IS NULL
)
BEGIN
-- < update tblQuizSession >--
UPDATE tblQuizSession
SET DateTimeCompleted = @dateCreated
, Duration = @Duration
, QuizScore = @Score
, QuizPassMark = @PassMark
WHERE
QuizSessionID = @QuizSessionID

--< insert into tblUserQuizStatus >--
INSERT INTO
tblUserQuizStatus
(
UserID,
ModuleID,
QuizStatusID,
QuizFrequency,
QuizPassMark,
QuizCompletionDate,
QuizScore,
QuizSessionID,
DateCreated
)
VALUES
(
@UserID,
@ModuleID,
@NewQuizStatus,
@QuizFrequency,
@PassMark,
@QuizCompletionDate,
@Score,
@QuizSessionID,
@dateCreated
)

--< insert into tblUserCourseStatus >--

-- if the user redo the quiz when they are still having a completed user course status
-- check if the last 2 course status is a completed status
-- if it is then we update the date of the last course status id to avoid new rows being inserted
-- if not we just add a new row
IF (@OldCourseStatus=2 and @OldCourseStatus = @NewCourseStatus)
BEGIN
declare @total int, @usercoursestatusid int

-- check if the last 2 courses is completed
select *
into #tblUserCompleted
from tblUserCourseStatus
where
UserCourseStatusID in
(
	-- we get the last 2 course status here
	select top 2 usercoursestatusid from tblUserCourseStatus
	where UserID=@userid and CourseID=@CourseID
	order by DateCreated desc
)
and CourseStatusID=2

select @total = COUNT(*) from #tblUserCompleted

-- if the last 2 course status is complete then we update the date of the last course status
if(@total = 2)
begin

select @usercoursestatusid = max(usercoursestatusid) from #tblUserCompleted
update tblUserCourseStatus set DateCreated=GETUTCDATE() where UserCourseStatusID=@usercoursestatusid

end
else
begin

EXEC prcUserCourseStatus_Insert @UserID, @ModuleID, @NewCourseStatus

end

drop table #tblUserCompleted

END
ELSE
IF (@OldCourseStatus = -1) or (@OldCourseStatus <> @NewCourseStatus)
BEGIN
EXEC prcUserCourseStatus_Insert @UserID, @ModuleID, @NewCourseStatus
END
ELSE
BEGIN
IF NOT EXISTS (SELECT UserID FROM vwUserModuleAccess where UserID = @UserID AND CourseID = @CourseID) AND
EXISTS (SELECT UserCourseStatusID FROM tblUserCourseStatus WHERE UserID = @UserID AND CourseID = @CourseID AND CourseStatusID <> 0)
BEGIN
EXEC prcUserCourseStatus_Insert @UserID, @ModuleID, @NewCourseStatus = 0
END
END

END

COMMIT TRANSACTION


' 
END
GO


/****** Object:  StoredProcedure [dbo].[prcUser_Create]    Script Date: 03/18/2013 15:20:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcUser_Create]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcUser_Create]
GO
/****** Object:  StoredProcedure [dbo].[prcUser_Create]    Script Date: 03/18/2013 15:20:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcUser_Create]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
Inserts a new user.

Parameters:
@organisationID		(Mandatory)
@unitID 			(Mandatory)
@firstName 			(Mandatory)
@lastName			(Mandatory)
@userName			(Mandatory)
@email				(Mandatory)
@active			(Mandatory)
@userTypeID			(Mandatory)
@actionUserID			(Mandatory)
@password			(Mandatory)

Returns:
@intErrorNumber As ''ErrorNumber'',
@strErrorMessage As ''ErrorMessage''

Called By:
User.cs.

Calls:
Nothing

Assumptions:
The majority of business logic related to password
lengths, confirmation passwords, valid emails etc.
are implemented through the UI.
Assumption is that the parameters when passed in
contain valid data.

Remarks:
Exception:
0. Succeed
1. RecordNotFound
2. FK constraint
3. PKViolationException
4. UniqueViolationException
5. MissingParameterException
7. IntegrityConstraintException
10. BusinessServiceException (General)


Author: Peter Vranich
Date Created: 20th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	Jack Liu	15/09/2005		User name is only unique per organisation

**/
CREATE  Procedure [dbo].[prcUser_Create]
(
@organisationID Integer = Null,
@unitID Integer = Null,
@firstName nvarchar(50) = Null,
@lastName nvarchar(50) = Null,
@userName nvarchar(100) = Null,
@email nvarchar(100) = null,
@active bit = null,
@userTypeID Integer = Null,
@actionUserID Integer = Null,
@password nvarchar(50) = Null,
@externalID nvarchar(50) = Null,
@TimeZoneID Integer = Null,
@DelinquencyManagerEmail nvarchar(100) = Null,
@NotifyUnitAdmin bit = null,
@NotifyOrgAdmin bit = null,
@NotifyMgr bit = null
)

As

Set NoCount On
Set Xact_Abort On

Begin Transaction

-- Declarations
Declare @strErrorMessage Varchar(200) -- Holds the error message
Declare @intErrorNumber Integer -- Holds the error number
Declare @UserID integer -- Holds the UserID once created

-- Initialise variables
Set @strErrorMessage = ''''
Set @intErrorNumber = 0

-- PARAMETER VALIDATION
--==============================================================

-- If user type is not SALT Administrator, check that a OrgID and UnitID has been supplied
If(@userTypeID <>1)
Begin
If(@organisationID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @organisationID in stored procedure prcUser_Create''
Goto Finalise
End

--Validate Parameter @unitID
If(@unitID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @unitID in stored procedure prcUser_Create''
Goto Finalise
End
End

--Validate Parameter @firstName
If(@firstName Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @firstName in stored procedure prcUser_Create''
Goto Finalise
End

--Validate Parameter @lastName
If(@lastName Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @lastName in stored procedure prcUser_Create''
Goto Finalise
End

--Validate Parameter @userName
If(@userName Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @userName in stored procedure prcUser_Create''
Goto Finalise
End

--Validate Parameter @email
If(@email Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @email in stored procedure prcUser_Create''
Goto Finalise
End

--Validate Parameter @active
If(@active Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @active in stored procedure prcUser_Create''
Goto Finalise
End

--Validate Parameter @userTypeID
If(@userTypeID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @userTypeID in stored procedure prcUser_Create''
Goto Finalise
End

--Validate Parameter @createdByUserID
If(@actionUserID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @updatedByUserID in stored procedure prcUser_Create''
Goto Finalise
End

-- If a unit was specified make sure it exists
--=========================================================
If (@unitID Is Not Null)
Begin
If Not Exists(Select * From tblUnit Where UnitID = @unitID)
Begin
Set @intErrorNumber = 1
Set @strErrorMessage = ''The specified unit could be found or may not be active.''
Goto Finalise
End
End

If(@userTypeID <>1)
begin
-- User name is unique per organisation
If Exists(Select * From tblUser Where Username = @userName and (organisationID=@organisationID or organisationID is null))
Begin
Set @intErrorNumber = 4
Set @strErrorMessage = @userName
Goto Finalise
End
end
else
begin
If Exists(Select * From tblUser Where Username = @userName)
Begin
Set @intErrorNumber = 4
Set @strErrorMessage = @userName
Goto Finalise
End
end


If Exists(Select * From tblUser Where Email = @email)
Begin
Set @intErrorNumber = 41
Set @strErrorMessage = ''The email address '' + @email + '' already exists.  <BR>Please choose another email address.''
Goto Finalise
End

Insert Into tblUser
(
OrganisationID,
FirstName,
LastName,
UserName,
Password,
Email,
UnitID,
UserTypeID,
Active,
CreatedBy,
DateCreated,
ExternalID,
NewStarter,
TimeZoneID,
DelinquencyManagerEmail,
NotifyMgr,
NotifyOrgAdmin,
NotifyUnitAdmin
)
Values
(
@organisationID,
@firstName,
@lastName,
@userName,
@password,
@email,
@unitID,
@userTypeID,
@active,
@actionUserID,
GETUTCDATE(),
@externalID, -- http://bugs.salt.devbdw.com/edit_bug.aspx?id=274
1,
@TimeZoneID, 
@DelinquencyManagerEmail,
@NotifyMgr,
@NotifyOrgAdmin,
@NotifyUnitAdmin
)

update tblUser set DateArchived = getutcdate() where Active = 0 and DateArchived IS NULL AND UserID = @@Identity
update tblUser set DateArchived = null where Active = 1 and NOT(DateArchived IS NULL) AND UserID = @@Identity

-- Set the error message to successfull
Set @strErrorMessage = @@Identity
Set @UserID = @@Identity


-- Get ProfilePeriodID''s for Organisation
create table #ProfilePeriod
(
ProfilePeriodID int
)

insert into #ProfilePeriod
select ProfilePeriodID
from tblProfilePeriod  pp
join tblprofile p
on pp.profileid = p.profileid
where p.organisationid = @OrganisationID


-- insert user into profileperiodaccess against all profileperiodid''s
-- for the organisation
insert into tblUserProfilePeriodAccess
select
pp.ProfilePeriodID,
@UserID,
uppa.granted
from #ProfilePeriod pp
join tblUnitProfilePeriodAccess uppa
on uppa.ProfilePeriodID = pp.ProfilePeriodID
where uppa.UnitID = @UnitID

drop table #ProfilePeriod

-- Get Policies for Organisation
create table #Policy
(
PolicyID int,
Granted bit
)

insert into #Policy
select p.PolicyID,
case when (select distinct granted from tblUnitPolicyAccess where unitID = @unitID and policyid = p.policyid) is null then 0
else (select distinct granted from tblUnitPolicyAccess where unitID = @unitID and policyid = p.policyid) end
from tblPolicy p where
OrganisationID = @OrganisationID
and deleted = 0


-- insert user into policy for all policy''s associated with organisation
insert into tblUserPolicyAccepted (PolicyID, UserID, Accepted)
select PolicyID, @UserID, 0 from #Policy

-- insert user into policyaccess for all policies
insert into tblUserPolicyAccess (PolicyID, UserID, Granted)
select PolicyID, @UserID, Granted  from #Policy

drop table #Policy

-- Finalise the procedure
Goto Finalise


Finalise:
If(@intErrorNumber > 0)
Begin
Rollback Transaction
Select
@intErrorNumber As ''ErrorNumber'',
@strErrorMessage As ''ErrorMessage''
End
Else
Begin
Commit Transaction
Select
@intErrorNumber As ''ErrorNumber'',
@strErrorMessage As ''ErrorMessage''
End
' 
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcAutomatedEmails_UsersToNotify]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcAutomatedEmails_UsersToNotify]
GO
/****** Object:  StoredProcedure [dbo].[prcAutomatedEmails_UsersToNotify]    Script Date: 04/02/2013 15:48:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcAutomatedEmails_UsersToNotify]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[prcAutomatedEmails_UsersToNotify]
(
@OrganisationID int
)


AS

BEGIN

declare @OrgMidnight datetime

set @OrgMidnight =  DATEADD(d,-1,dbo.udfGetSaltOrgMidnight(@OrganisationID))



--                    H O U S E K E E P I N G
--tblUserCourseDetails contains information on notifications about courses that have ''at risk'' quizes
--add any new courses
INSERT INTO tblUserCourseDetails (UserID,CourseID,UserCourseStatusID,NumberOfDelinquencyNotifications, NewStarterFlag, AtRiskQuizList, NotifiedModuleList, LastDelinquencyNotification)

select U.UserID,CourseID,UserCourseStatusID,0,null,'''','''',null
FROM  tblUser U inner join tblUserCourseStatus tUCS ON U.UserID = tUCS.UserID and U.OrganisationID = @organisationID  INNER JOIN
(SELECT MAX(UserCourseStatusID) AS MaxUserCourseStatusID
FROM   dbo.tblUserCourseStatus
GROUP BY UserID, CourseID) AS currentStatus ON tUCS.UserCourseStatusID = currentStatus.MaxUserCourseStatusID

where  CourseStatusID in (1,2) and UserCourseStatusID NOT IN (SELECT UserCourseStatusID FROM tblUserCourseDetails)






--remove data on courses that are now unassigned
DELETE FROM tblUserCourseDetails WHERE UserCourseStatusID IN
(SELECT UserCourseStatusID
FROM  tblUser U inner join tblUserCourseStatus tUCS ON U.UserID = tUCS.UserID and U.OrganisationID = @organisationID  INNER JOIN
(SELECT MAX(UserCourseStatusID) AS MaxUserCourseStatusID
FROM   dbo.tblUserCourseStatus
GROUP BY UserID, CourseID) AS currentStatus ON tUCS.UserCourseStatusID = currentStatus.MaxUserCourseStatusID

where  CourseStatusID = 0
)








--                    S E L E C T    T H E    R E S U L T S

--declare @OrganisationID int
--set @OrganisationID = 68

create table #UsersToNotify
(userid int not null
,NewContent nvarchar(max) null
,PassedCourses nvarchar(max) null
,PassedModules nvarchar(max) null
,AtRiskContent nvarchar(max) null
,AtRiskOfdelinquency nvarchar(max) null)



insert into #UsersToNotify
SELECT distinct UsersToNotify.userid , UsersToNotify.NewContent , PassedCourses, PassedModules ,AtRiskContent,AtRiskOfdelinquency FROM
(

SELECT '''' as UserCourseStatusID, tblExpiredNewContent.UserID , tblCourse.Name + '' - ''+ tblModule.Name as NewContent , '''' as PassedCourses ,'''' as PassedModules , '''' as AtRiskContent, '''' as AtRiskOfdelinquency
FROM  tblExpiredNewContent INNER JOIN
tblModule ON tblExpiredNewContent.ModuleID = tblModule.ModuleID INNER JOIN
tblCourse ON tblModule.CourseID = tblCourse.CourseID
WHERE tblExpiredNewContent.organisationID = @OrganisationID



-- users with passed courses
UNION all SELECT '''' as UserCourseStatusID, CS.userid , '''' as NewContent,''   ''+ C.Name as PassedCourses,'''' as PassedModules, '''' as AtRiskContent, '''' as AtRiskOfdelinquency
FROM tblUserCourseStatus CS
inner join tblUser U ON U.UserID = CS.UserID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
where U.OrganisationID = @OrganisationID and CS.CourseStatusID=2 and DATEDIFF(d,CS.DateCreated,@OrgMidnight) < 0 and u.Active=1


-- users with passed modules
UNION all SELECT '''' as UserCourseStatusID, QuizStatus.userid ,
'''' as NewContent, '''' as PassedCourses,
''   ''+c.name  + '' - '' + m.name as PassedModules, '''' as AtRiskContent,
'''' as AtRiskOfdelinquency
from
tblUserQuizStatus QuizStatus
join tblUser  u on u.UserID = QuizStatus.UserID and u.OrganisationID = @OrganisationID
inner join tblModule m on m.ModuleID = QuizStatus.ModuleID
join tblCourse c on c.CourseID = m.CourseID
inner join
(
select
max(UserQuizStatusID) UserQuizStatusID, uqs.UserID, uqs.ModuleID --UserQuizStatusID is identity
from
tblUserQuizStatus uqs
join tblUser  u on u.UserID = uqs.UserID
WHERE DATEDIFF(d,uqs.DateCreated,@OrgMidnight) < 0
and u.OrganisationID = @OrganisationID
group by
uqs.UserID,moduleID
) currentStatus
on QuizStatus.UserQuizStatusID = currentStatus.UserQuizStatusID
where m.active = 1
and QuizStatusID =2
and u.Active=1



-- users with quizes at risk ( N O R M A L    R U L E S )
UNION all SELECT DISTINCT '''' as UserCourseStatusID, AR.userID,  '''' as NewContent , '''' as PassedCourses,'''' as PassedModules,''   ''+ C.Name as AtRiskContent, '''' as AtRiskOfdelinquency
from tblQuizExpiryAtRisk AR
INNER JOIN tblUser U On U.UserID = AR.UserID
inner join tblModule M on m.ModuleID = AR.ModuleID and m.Active = 1 and AR.OrganisationID = @OrganisationID
INNER JOIN tblCourse C ON C.CourseID = M.CourseID
where U.Active = 1 AND daysToExpiry >= 0 and Notified = 0

-- users with quizes at risk ( N O R M A L    R U L E S )
UNION all SELECT DISTINCT '''' as UserCourseStatusID, AR.userID,  '''' as NewContent , '''' as PassedCourses,'''' as PassedModules,''   ''+ C.Name +'' ( ''+M.name +'') ''                       + convert(varchar (11),DATEADD(d,daysToExpiry, dbo.udfGetSaltOrgDate(@OrganisationID) ) ,113)  as AtRiskContent, '''' as AtRiskOfdelinquency
from tblQuizExpiryAtRisk AR
INNER JOIN tblUser U On U.UserID = AR.UserID
inner join tblModule M on m.ModuleID = AR.ModuleID and m.Active = 1 and AR.OrganisationID = @OrganisationID
INNER JOIN tblCourse C ON C.CourseID = M.CourseID
where U.Active = 1 AND daysToExpiry > 0 and Notified = 0




-- users with courses at risk of delinquency (1ST WARNING)

UNION all SELECT DISTINCT UserCourseStatusID  , userID ,  '''' as NewContent , '''' as PassedCourses,'''' as PassedModules, '''' as AtRiskContent,''   ''+ Name +'' '' + convert(varchar (11),DATEADD(d,DaysToCompleteCourse, dbo.udfUTCtoDaylightSavingTime(DateCreated,@OrganisationID)),113)  as AtRiskOfdelinquency
FROM (SELECT MAX(CD.UserCourseStatusID) as UserCourseStatusID, CS.userID ,  RemEsc.DaysToCompleteCourse, MIN(CS.DateCreated) as DateCreated,C.Name,CS.CourseID
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID) AND (RemindUsers=1)
where U.Active = 1
AND ((o.DefaultQuizCompletionDate is not null AND CS.DateCreated >  dateadd(year,-1,o.DefaultQuizCompletionDate))
OR     (o.DefaultQuizCompletionDate is  null AND CS.DateCreated >= (select ISNULL((SELECT MAX(DateCreated) FROM tblUserCourseStatus Expired where expired.CourseStatusID in (0,2) and Expired.CourseID = CS.CourseID and Expired.UserID =CS.UserID) ,''1 jan 1990'')) ))
AND CD.LastDelinquencyNotification IS NULL
AND coursestatusid=1
AND o.OrganisationID = @OrganisationID
AND (GETUTCDATE() > DATEADD(d,RemEsc.DaysToCompleteCourse-RemEsc.NumOfRemNotfy*RemEsc.RepeatRem, CS.DateCreated))
AND (RemEsc.NumOfRemNotfy > cd.NumberOfDelinquencyNotifications)
AND (GETUTCDATE() < DATEADD(m,RemEsc.DaysToCompleteCourse+6, CS.DateCreated))
GROUP BY  CS.CourseID, CS.userID ,  RemEsc.DaysToCompleteCourse, C.Name) ThisCycle




---- users with courses at risk of delinquency (SUBSEQUENT WARNINGS)

UNION all SELECT DISTINCT UserCourseStatusID  , userID ,  '''' as NewContent , '''' as PassedCourses,'''' as PassedModules, '''' as AtRiskContent,''   ''+ Name +'' '' + convert(varchar (11),DATEADD(d,DaysToCompleteCourse, dbo.udfUTCtoDaylightSavingTime(DateCreated,@OrganisationID)),113)  as AtRiskOfdelinquency
FROM (SELECT MAX(CD.UserCourseStatusID) as UserCourseStatusID, CS.userID ,  RemEsc.DaysToCompleteCourse, MIN(CS.DateCreated) as DateCreated,C.Name,CS.CourseID
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID) AND (RemindUsers=1)
where U.Active = 1 AND coursestatusid=1 AND o.OrganisationID = @OrganisationID
AND CD.LastDelinquencyNotification IS NOT NULL
AND ((o.DefaultQuizCompletionDate is not null AND CS.DateCreated >  dateadd(year,-1,o.DefaultQuizCompletionDate))
OR     (o.DefaultQuizCompletionDate is  null AND CS.DateCreated >= (select ISNULL((SELECT MAX(DateCreated) FROM tblUserCourseStatus Expired where expired.CourseStatusID in (0,2) and Expired.CourseID = CS.CourseID and Expired.UserID =CS.UserID) ,''1 jan 1990'')) ))
AND coursestatusid=1
AND o.OrganisationID = @OrganisationID
AND (GETUTCDATE() > DATEADD(d,RemEsc.DaysToCompleteCourse-RemEsc.NumOfRemNotfy*RemEsc.RepeatRem, CS.DateCreated))
AND (RemEsc.NumOfRemNotfy > cd.NumberOfDelinquencyNotifications)
AND (GETUTCDATE() > DATEADD(d,RemEsc.RepeatRem, CD.LastDelinquencyNotification))
AND (GETUTCDATE() < DATEADD(m,RemEsc.DaysToCompleteCourse+6, CS.DateCreated))

GROUP BY  CS.CourseID, CS.userID ,  RemEsc.DaysToCompleteCourse, C.Name) ThisQuizCycle




) UsersToNotify


create index in_1 on #UsersToNotify(userid)



create table #UsersToNotifyList
(userid int not null
,NewContent nvarchar(max) null
,PassedCourses nvarchar(max) null
,PassedModules nvarchar(max) null
,AtRiskContent nvarchar(max) null
,AtRiskOfdelinquency nvarchar(max) null)

create index in_2 on #UsersToNotifyList(userid)

declare @userid int
,@NewContent nvarchar(max)
,@PassedCourses nvarchar(max)
,@PassedModules nvarchar(max)
,@AtRiskContent nvarchar(max)
,@AtRiskOfdelinquency nvarchar(max)

while exists (select 1 from #UsersToNotify)
begin
set rowcount 1
select @userid = userid
,@NewContent = NewContent
, @PassedCourses = PassedCourses
,@PassedModules = PassedModules
,@AtRiskContent = AtRiskContent
,@AtRiskOfdelinquency = AtRiskOfdelinquency

from #UsersToNotify
if exists (select * from #UsersToNotifyList where userid = @userid)
begin
update #UsersToNotifyList set
NewContent = rtrim(CAST(#UsersToNotifyList.NewContent + (case when #UsersToNotifyList.NewContent = '''' or @NewContent = '''' then '''' else ''<BR>'' end ) + (case when @NewContent ='''' then '''' else ''&nbsp;&nbsp;'' end) +@NewContent AS NVARCHAR(max)))
, PassedCourses = rtrim(CAST(#UsersToNotifyList.PassedCourses + (case when #UsersToNotifyList.PassedCourses = '''' or @PassedCourses = '''' then '''' else ''<BR>'' end)+ (case when @PassedCourses ='''' then '''' else ''&nbsp;&nbsp;'' end) + @PassedCourses AS NVARCHAR(max)))
,PassedModules = rtrim(CAST(#UsersToNotifyList.PassedModules + (case when #UsersToNotifyList.PassedModules = '''' or @PassedModules = '''' then '''' else ''<BR>'' end)+ (case when @PassedModules ='''' then '''' else ''&nbsp;&nbsp;'' end) + @PassedModules AS NVARCHAR(max)))
,AtRiskContent = rtrim(CAST(#UsersToNotifyList.AtRiskContent + (case when #UsersToNotifyList.AtRiskContent = '''' or @AtRiskContent = '''' then '''' else ''<BR>'' end)+ (case when @AtRiskContent ='''' then '''' else ''&nbsp;&nbsp;'' end) + @AtRiskContent AS NVARCHAR(max)))
,AtRiskOfdelinquency = rtrim(CAST(#UsersToNotifyList.AtRiskOfdelinquency + (case when #UsersToNotifyList.AtRiskOfdelinquency = '''' or @AtRiskOfdelinquency = '''' then '''' else ''<BR>'' end)+ (case when @AtRiskOfdelinquency ='''' then '''' else ''&nbsp;&nbsp;'' end) + @AtRiskOfdelinquency AS NVARCHAR(max)))
from #UsersToNotifyList
where #UsersToNotifyList.userid = @userid
end
else
begin
insert #UsersToNotifyList(userid,NewContent,PassedCourses,PassedModules,AtRiskContent,AtRiskOfdelinquency)
values (@userid,@NewContent,@PassedCourses,@PassedModules,@AtRiskContent,@AtRiskOfdelinquency)

end
delete #UsersToNotify where
@userid = userid
and @NewContent = NewContent
and  @PassedCourses = PassedCourses
and  @PassedModules = PassedModules
and @AtRiskContent = AtRiskContent
and  @AtRiskOfdelinquency = AtRiskOfdelinquency
set rowcount 0
end



SELECT l.UserID,
-- Recipient Email Address
(SELECT Email FROM tblUser WHERE UserID = l.UserID) as RecipientEmail,

-- Sender Email Address
(SELECT dbo.udfUser_GetAdministratorsEmailAddress (l.UserID)) as SenderEmail,

-- Subject
(select REPLACE(
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_Subject'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_Subject''))),''%APP_NAME%'',(SELECT Value FROM tblAppConfig where Name = ''AppName''))) as Subject,



-- Header
(select coalesce((select REPLACE(
(select REPLACE(
(select REPLACE(
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_Header'')
,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_Header'')))
,''%APP_NAME%'',(SELECT Value FROM tblAppConfig where Name = ''AppName'')))
,''%FirstName%'',(SELECT COALESCE(FirstName,'''') FROM tblUser WHERE UserID = l.UserID)))
,''%LastName%'',(SELECT COALESCE(LastName,'''') FROM tblUser WHERE UserID = l.UserID))),''header error''))


--New Content
+ (select coalesce(case when NewContent = '''' then '''' else
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_ExpiredContent'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_ExpiredContent'')))+''&nbsp;&nbsp;''+NewContent+ ''<BR>'' end,''error reading Student_Summary_ExpiredContent''))

--Passed Courses
+ (select coalesce(case when PassedCourses = '''' then '''' else
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_PassedCourses'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_PassedCourses'')))+''&nbsp;&nbsp;''+PassedCourses+ ''<BR>'' end,''error reading Student_Summary_PassedCourses''))

--Passed Modules
+ (select coalesce(case when PassedModules = '''' then '''' else
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_PassedModules'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_PassedModules'')))+''&nbsp;&nbsp;''+PassedModules+ ''<BR>'' end,''error reading Student_Summary_PassedModules''))

--AtRiskContent
+ (select coalesce(case when AtRiskContent = '''' then '''' else
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_AtRiskOfExpiry'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_AtRiskOfExpiry'')))+''&nbsp;&nbsp;''+AtRiskContent+ ''<BR>'' end,''error reading Student_Summary_AtRiskOfExpiry''))

--AtRiskOfdelinquency
+ (select coalesce(case when AtRiskOfdelinquency = '''' then '''' else
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_AtRiskOfBeingOverdue'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_AtRiskOfBeingOverdue'')))+''&nbsp;&nbsp;''+AtRiskOfdelinquency+ ''<BR>'' end,''error reading Student_Summary_AtRiskOfBeingOverdue''))

--Email Sig
+     (select REPLACE(
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_Sig'')

,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_Sig'')))+ ''<BR>''  ,''%APP_NAME%'',(SELECT Value FROM tblAppConfig where Name = ''AppName''))) as Body
, -- Sender"On Behalf Of" Email Address
(SELECT dbo.udfUser_GetAdministratorsOnBehalfOfEmailAddress (l.UserID))  as OnBehalfOfEmail,


*

FROM
#UsersToNotifyList l




--                    H O U S E K E E P I N G  (tidy up for tomorrow)

-- Update record of "at risk of Delinquency" notifications
-- Update tblUserCourseDetails.LastDelinquencyNotification
UPDATE tblUserCourseDetails  SET LastDelinquencyNotification = GETUTCDATE()
WHERE  UserCourseStatusID in (-- users with courses at risk of delinquency (1ST WARNING)

SELECT DISTINCT UserCourseStatusID
FROM (SELECT MAX(CD.UserCourseStatusID) as UserCourseStatusID, CS.userID ,  RemEsc.DaysToCompleteCourse, MIN(CS.DateCreated) as DateCreated,C.Name,CS.CourseID
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID) AND (RemindUsers=1)
where U.Active = 1
AND ((o.DefaultQuizCompletionDate is not null AND CS.DateCreated >  dateadd(year,-1,o.DefaultQuizCompletionDate))
OR     (o.DefaultQuizCompletionDate is  null AND CS.DateCreated >= (select ISNULL((SELECT MAX(DateCreated) FROM tblUserCourseStatus Expired where expired.CourseStatusID in (0,2) and Expired.CourseID = CS.CourseID and Expired.UserID =CS.UserID) ,''1 jan 1990'')) ))
AND CD.LastDelinquencyNotification IS NULL
AND coursestatusid=1
AND o.OrganisationID = @OrganisationID
AND (GETUTCDATE() > DATEADD(d,RemEsc.DaysToCompleteCourse-RemEsc.NumOfRemNotfy*RemEsc.RepeatRem, CS.DateCreated))
AND (RemEsc.NumOfRemNotfy > cd.NumberOfDelinquencyNotifications)
AND (GETUTCDATE() < DATEADD(m,RemEsc.DaysToCompleteCourse+6, CS.DateCreated))
GROUP BY  CS.CourseID, CS.userID ,  RemEsc.DaysToCompleteCourse, C.Name) ThisCycle
)




UPDATE tblUserCourseDetails  SET LastDelinquencyNotification = GETUTCDATE(), NumberOfDelinquencyNotifications = NumberOfDelinquencyNotifications + 1
WHERE  UserCourseStatusID in (-- users with courses at risk of delinquency (SUBSEQUENT WARNINGS)
SELECT DISTINCT UserCourseStatusID
FROM (SELECT MAX(CD.UserCourseStatusID) as UserCourseStatusID, CS.userID ,  RemEsc.DaysToCompleteCourse, MIN(CS.DateCreated) as DateCreated,C.Name,CS.CourseID
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID) AND (RemindUsers=1)
where U.Active = 1 AND coursestatusid=1 AND o.OrganisationID = @OrganisationID
AND CD.LastDelinquencyNotification IS NOT NULL
AND ((o.DefaultQuizCompletionDate is not null AND CS.DateCreated >  dateadd(year,-1,o.DefaultQuizCompletionDate))
OR     (o.DefaultQuizCompletionDate is  null AND CS.DateCreated >= (select ISNULL((SELECT MAX(DateCreated) FROM tblUserCourseStatus Expired where expired.CourseStatusID in (0,2) and Expired.CourseID = CS.CourseID and Expired.UserID =CS.UserID) ,''1 jan 1990'')) ))
AND coursestatusid=1
AND o.OrganisationID = @OrganisationID
AND (GETUTCDATE() > DATEADD(d,RemEsc.DaysToCompleteCourse-RemEsc.NumOfRemNotfy*RemEsc.RepeatRem, CS.DateCreated))
AND (RemEsc.NumOfRemNotfy > cd.NumberOfDelinquencyNotifications)
AND (GETUTCDATE() > DATEADD(d,RemEsc.RepeatRem, CD.LastDelinquencyNotification))
AND (GETUTCDATE() < DATEADD(m,RemEsc.DaysToCompleteCourse+6, CS.DateCreated))

GROUP BY  CS.CourseID, CS.userID ,  RemEsc.DaysToCompleteCourse, C.Name) ThisQuizCycle
)

/*-- Update Record of notified NEW Modules
UPDATE tblUserCourseDetails  SET NotifiedModuleList =  ModulesAssigned  from
(SELECT UserCourseStatusID, ModulesAssigned
FROM (select tUCS.ModulesAssigned, tUCS.CourseID,tUCS.CourseStatusID,tUCS.UserCourseStatusID as UCSUserCourseStatusID
FROM  tblUser U inner join tblUserCourseStatus tUCS ON U.UserID = tUCS.UserID and U.OrganisationID = 9   INNER JOIN

(SELECT MAX(UserCourseStatusID) AS MaxUserCourseStatusID
FROM   dbo.tblUserCourseStatus
GROUP BY UserID, CourseID) AS currentStatus ON tUCS.UserCourseStatusID = currentStatus.MaxUserCourseStatusID) CS
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
Inner join tblUserCourseDetails CD on  CD.UserCourseStatusID = CS.UCSUserCourseStatusID
and  CS.CourseStatusID=1
) temp
where tblUserCourseDetails.UserCourseStatusID = temp.UserCourseStatusID*/


DELETE FROM tblExpiredNewContent WHERE organisationID = @OrganisationID



-- Update record of notified "At Risk Quizes"
-- users with quizes at risk ( N O R M A L    R U L E S )
update tblQuizExpiryAtRisk SET Notified = 1 WHERE organisationID = @OrganisationID and Notified = 0


if OBJECT_ID(''#UsersToNotifyList'') is not null
begin
drop table #UsersToNotifyList
end

if  OBJECT_ID(''#UsersToNotify'')is not null
begin
drop table #UsersToNotify
END
end





' 
END
GO



/****** Object:  StoredProcedure [dbo].[prcUser_UsernameSearch]    Script Date: 04/05/2013 16:18:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcUser_UsernameSearch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcUser_UsernameSearch]
GO
/****** Object:  StoredProcedure [dbo].[prcUnit_Search]    Script Date: 04/05/2013 16:18:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcUnit_Search]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcUnit_Search]
GO
/****** Object:  StoredProcedure [dbo].[prcUnit_Search]    Script Date: 04/05/2013 16:18:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcUnit_Search]') AND type in (N'P', N'PC'))
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
/****** Object:  StoredProcedure [dbo].[prcUser_UsernameSearch]    Script Date: 04/05/2013 16:18:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcUser_UsernameSearch]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*Summary:
The procedure will search within the selected Parent Units for those Users whose name contains the entered first and last names.
(If no Parent Units have been selected, the system will search across the whole organisation.)

Returns:
Unit Name
Full pathway

Called By:
Calls:

Remarks:
The searching units will include all children and grandchildren
Only return users that logged on user has permission to see


Author: Gavin Buddis
Date Created: 2 Mar 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	Li Zhang	4/4/2006		Added search on username function
#2	VDL			26 Sep 2008		Add Search on email field / add boolean logic for include inactive users


**/

CREATE  Procedure  [dbo].[prcUser_UsernameSearch]
(
@organisationID  Int,
@parentUnitIDs  Varchar(500),
@firstName	nVarchar(100),
@lastName	nVarchar(100),
@userName   nVarchar(200),
@userEmail	nvarchar(300),
@userID		int = 0,
@adminUserID		Int,
@includeInactiveUsers bit
)
As
Set Nocount On

Declare @intUserTypeID Int

Select @intUserTypeID = UserTypeID
From tblUser
Where userID = @adminUserID

--Check Data
If @parentUnitIDs is null
set @parentUnitIDs =''''

If @firstName is null
Set @firstName = ''''

Set @firstName =rtrim(@firstName)

If @lastName is null
Set @lastName = ''''

Set @lastName =rtrim(@lastName)

If @userName is null
Set @userName = ''''

Set @userName = rtrim(@userName)

if @userEmail is null
Set @userEmail =''''


Select
us.UserID,
us.UserName,
us.FirstName,
case
When us.Active = 0 then us.LastName + ''(I)''
Else us.LastName
end as LastName,
case
When us.LastLogin Is Null then ''Never''
Else cast(dbo.udfUTCtoDaylightSavingTime(us.LastLogin,@OrganisationID) as varchar)
end as LastLogin,
dbo.udfGetUnitPathway(us.UnitID) as Pathway,
us.Active

From tbluser us
join tblunit un on us.unitid = un.unitid

Where (us.OrganisationID = @organisationID)
and
(
us.Active= case when @includeInactiveUsers=0 then 1 else us.active end
)
--1. Within the selected Parent Units (can select multiple units)
--The unit hierarchy contains the parent Unit ID
and (
un.UnitID in
(
Select IntValue from dbo.udfCsvToInt(@parentUnitIDs)
)
or (@parentUnitIDs='''')
)
--2. User firstname contains the entered text
and (
(us.firstname like ''%''+ @firstName + ''%'')
or (us.firstname ='''')
)
--3. User lastname contains the entered text
and (
(us.lastname like ''%''+ @lastName + ''%'')
or (us.lastname ='''')
)
--4. User username contains the entered text
and (
(us.UserName like ''%'' + @userName + ''%'')
or (us.UserName ='''')
)
--4.5 User Email Address is the entered text
and (
(us.email like ''%'' + @userEmail + ''%'')
or (@useremail ='''')
)
--5. Permission
--Salt Administrator(1), Organisation Administrator(2) has permission to access all units
--Unit Administrator(3) only has permission to those that he is administrator
and (
(@intUserTypeID<3)
or (un.UnitID in (select UnitID from tblUnitAdministrator where UserID=@adminUserID))
)
-- 6. User ID
and (
(@userid != 0 and us.userid = @userid ) or (@userid = 0 and us.userid > 0)
)


Order By Name' 
END
GO



/****** Object:  UserDefinedFunction [dbo].[udfUnit_GetAdministratorsEmailAddress]    Script Date: 04/08/2013 15:34:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udfUnit_GetAdministratorsEmailAddress]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udfUnit_GetAdministratorsEmailAddress]
GO
/****** Object:  UserDefinedFunction [dbo].[udfUser_GetAdministratorsEmailAddress]    Script Date: 04/08/2013 15:34:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udfUser_GetAdministratorsEmailAddress]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udfUser_GetAdministratorsEmailAddress]
GO
/****** Object:  UserDefinedFunction [dbo].[udfUser_GetAdministratorsEmailAddress]    Script Date: 04/08/2013 15:34:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udfUser_GetAdministratorsEmailAddress]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE function [dbo].[udfUser_GetAdministratorsEmailAddress]
(
@UserID	int
)
Returns varchar(100)
AS
BEGIN
DECLARE @UnitID int
SELECT @UnitID = UnitID FROM tblUser WHERE UserID = @UserID

DECLARE @Email VARCHAR(100)
SELECT @Email = coalesce(
-- try to get the closest unit admin then search further afield
(Select top 1	u.Email
from tblUnitAdministrator ua
inner join tblUser u on ua.userID = u.UserID
where ua.unitID=@unitID
and u.active = 1
and u.usertypeID=3 --Unit administrator(3)
and u.unitID=@unitID
and u.Email is not null),


(Select top 1	u.Email
from tblUnitAdministrator ua
inner join tblUser u on ua.userID = u.UserID
where ua.unitID=@unitID
and u.active = 1
and u.usertypeID=3 --Unit administrator(3)
and u.Email is not null),

(Select top 1	u.Email
from tblUser u inner join tblUnit un on un.OrganisationID = u.OrganisationID
where un.unitID=@unitID
and u.active = 1
and UserTypeID = 2
and Email is not null),


(Select top 1	u.Email
from tblUser u inner join tblUnit un on un.OrganisationID = u.OrganisationID
and u.active = 1
where un.unitID=@unitID
and UserTypeID = 1
and Email is not null),

--all else failed so get the salt admin
(Select top 1	u.Email
from tblUser u
where UserTypeID = 1
and Email is not null))



return @Email
END
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[udfUnit_GetAdministratorsEmailAddress]    Script Date: 04/08/2013 15:34:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udfUnit_GetAdministratorsEmailAddress]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE function [dbo].[udfUnit_GetAdministratorsEmailAddress]
(
@unitID	int
)
Returns varchar(100)
AS
BEGIN
DECLARE @Email VARCHAR(100)
SELECT @Email = coalesce(
-- try to get the closest unit admin then search further afield
(Select top 1	u.Email
from tblUnitAdministrator ua
inner join tblUser u on ua.userID = u.UserID
where ua.unitID=@unitID
and u.active = 1
and u.usertypeID=3 --Unit administrator(3)
and u.unitID=@unitID
and u.Email is not null),


(Select top 1	u.Email
from tblUnitAdministrator ua
inner join tblUser u on ua.userID = u.UserID
where ua.unitID=@unitID
and u.active = 1
and u.usertypeID=3 --Unit administrator(3)
and u.Email is not null),

(Select top 1	u.Email
from tblUser u inner join tblUnit un on un.OrganisationID = u.OrganisationID
where un.unitID=@unitID
and u.active = 1
and UserTypeID = 2
and Email is not null),


(Select top 1	u.Email
from tblUser u inner join tblUnit un on un.OrganisationID = u.OrganisationID
where un.unitID=@unitID
and u.active = 1
and UserTypeID = 1
and Email is not null),

--all else failed so get the salt admin
(Select top 1	u.Email
from tblUser u
where UserTypeID = 1
and Email is not null))



return @Email
END
' 
END
GO


/****** Object:  StoredProcedure [dbo].[prcEmail_Search]    Script Date: 04/08/2013 17:05:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcEmail_Search]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcEmail_Search]
GO
/****** Object:  StoredProcedure [dbo].[prcEmail_Search]    Script Date: 04/08/2013 17:05:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcEmail_Search]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
The procedure will search email sent within the selected date range to a email and contain text in subject or body

Returns:


Called By:
Calls:

Remarks:


Author: Jack Liu
Date Created: 25 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
select * from tblEmail


prcEmail_Search''20040102'',''20040228'','''','''',''''

**/

CREATE  PROCEDURE [dbo].[prcEmail_Search]
(

@dateFrom  datetime,
@dateTo  datetime,
@toEmail nvarchar(50),
@subject nvarchar(50),
@body nvarchar(50),
@organisationID int
)
as
set nocount on

set @dateFrom = dbo.udfDaylightSavingTimeToUTC(@dateFrom, @organisationID)
set @dateTo = dbo.udfDaylightSavingTimeToUTC(DATEADD(day,1,@dateTo), @organisationID)

if @toEmail=''''
set @toEmail=null

if @subject=''''
set @subject=null

if @body=''''
set @body=null


select
emailid,
ToEmail,
subject,
body,
dbo.udfUTCtoDaylightSavingTime(DateCreated, @organisationID) as DateCreated
from tblEmail
where DateCreated between @dateFrom and  @dateTo
and (@toEmail is null  or toEmail =@toEmail)
and (@subject is null  or subject like ''%''+ @subject +''%'')
and (@body is null  or body   like ''%''+ @body +''%'')
and OrganisationID = IsNull(@organisationID,OrganisationID)
order by datecreated
' 
END
GO



/****** Object:  StoredProcedure [dbo].[prcEmail_SearchByID]    Script Date: 04/08/2013 17:29:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcEmail_SearchByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcEmail_SearchByID]
GO
/****** Object:  StoredProcedure [dbo].[prcEmail_SearchByID]    Script Date: 04/08/2013 17:29:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcEmail_SearchByID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
The procedure will get an email by ID

Author: William Tio
Date Created: 08 April 2013

**/

CREATE PROCEDURE [dbo].[prcEmail_SearchByID]
(
@emailid int,
@organisationid int
)
as
set nocount on

select
emailid,
ToEmail,
toname,
subject,
body,
dbo.udfUTCtoDaylightSavingTime(DateCreated, @organisationID) as DateCreated,
userid
from tblEmail
where
emailid = @emailid
and organisationid=@organisationid
order by datecreated
' 
END
GO


/****** Object:  StoredProcedure [dbo].[prcReport_Warning]    Script Date: 04/09/2013 15:31:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_Warning]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcReport_Warning]
GO
/****** Object:  StoredProcedure [dbo].[prcReport_WarningGrandTotal]    Script Date: 04/09/2013 15:31:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_WarningGrandTotal]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcReport_WarningGrandTotal]
GO
/****** Object:  StoredProcedure [dbo].[prcReport_WarningGrandTotal]    Script Date: 04/09/2013 15:31:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_WarningGrandTotal]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/******************************************************************************
**		Name: prcReport_WarningGrandTotal
**		Desc: a copy of prcreport_Warning, but with select statements
**				altered to return a total, instead of a list of data.
**

**		Return values: Grand Total distinct users in Warning report
**
**		Auth: Mark Donald
**		Date: 17 Nov 2009




**
*******************************************************************************/


CREATE       Procedure [dbo].[prcReport_WarningGrandTotal]
(
@organisationID		int,
@unitIDs 		varchar(max),
@courseIDs 		varchar(8000),
@classificationID int,
@warningPeriod int,
@warningUnit varchar(2),
@IncludeInactive int

)
AS
SET NOCOUNT ON;

DECLARE @Units TABLE (UnitID INT PRIMARY KEY(UnitID))
DECLARE @Courses TABLE(CourseID INT PRIMARY KEY(CourseID))
DECLARE @CoursesWithAccess 	TABLE (CourseID INT PRIMARY KEY(CourseID))
DECLARE @Users TABLE(UserID INT , UnitID INT PRIMARY KEY(UserID, UnitID))
DECLARE @tblCurrentAssignedModules TABLE (
CourseID int,
UserID int,
UnitID int,
ModuleID int,
QuizFrequency int,
QuizCompletionDate datetime
)
DECLARE @tblStartedModules TABLE (
UserID int,
ModuleID int,
DateTimeCompleted datetime
)

INSERT INTO
@Courses
SELECT
*
FROM
dbo.udfCsvToInt(@courseIDs)

INSERT INTO
@Units
SELECT
*
FROM
dbo.udfCsvToInt(@unitIDs)

-- Get users for specfied units, matching Custom Classification option (if provided)
INSERT INTO @Users
SELECT
DISTINCT A.UserID, A.UnitiD
FROM
tblUser A
JOIN @Units B on A.UnitID = B.UnitID
JOIN tblUnit C on B.UnitID = C.UnitID AND C.Active = 1
LEFT JOIN tblUserClassification uc ON uc.UserID  = A.UserID
WHERE
A.Active = (case when @includeinactive = 0 then 1 else A.active end )
AND ((@classificationID =0) OR (classificationID = @classificationID))
--If classification is Any (0), This will find users of any Custom Classification

-- Get compliance rules for in-scope modules
INSERT INTO @tblCurrentAssignedModules
SELECT
CourseID, UserID, um.UnitID, um.ModuleID, QuizFrequency, QuizCompletionDate
FROM
(SELECT
tU.UserID, tU.UnitID, tM.ModuleID
FROM
dbo.tblUser tU
INNER JOIN dbo.tblOrganisationCourseAccess tOCA ON tOCA.OrganisationID = tU.OrganisationID
INNER JOIN dbo.tblCourse tC ON tC.CourseID = tOCA.GrantedCourseID
INNER JOIN dbo.tblModule tM ON tM.CourseID = tC.CourseID AND tM.Active = 1
LEFT OUTER JOIN dbo.tblUserModuleAccess tUsrMA ON tUsrMA.UserID = tU.UserID
AND tUsrMA.ModuleID = tM.ModuleID
LEFT OUTER JOIN dbo.tblUnitModuleAccess tUnitMA ON tUnitMA.UnitID = tU.UnitID
AND tUnitMA.DeniedModuleID = tM.ModuleID
WHERE
tU.OrganisationID = @organisationID
AND	tU.Active = (case when @includeinactive = 0 then 1 else tU.Active end )
AND tu.UnitID IS NOT NULL
AND dbo.udfUserCourseComplete(tu.userid, tm.courseid) = 1
AND ((tUnitMA.DeniedModuleID IS NULL AND tUsrMA.ModuleID IS NULL)
OR tUsrMA.Granted=1)
) um
INNER JOIN (
SELECT
u.UnitID, m.CourseID, m.ModuleID,
CASE
WHEN (
ur.QuizFrequency IS NULL
AND ur.QuizCompletionDate IS NULL
AND o.DefaultQuizCompletionDate IS NULL
) THEN
o.DefaultQuizFrequency
ELSE
ur.QuizFrequency
END AS QuizFrequency,
CASE
WHEN (
ur.QuizFrequency IS NULL
AND ur.QuizCompletionDate IS NULL
AND o.DefaultQuizCompletionDate IS NOT NULL
) THEN
o.DefaultQuizCompletionDate
ELSE
ur.QuizCompletionDate
END AS QuizCompletionDate
FROM
tblOrganisationCourseAccess c
INNER JOIN tblModule m ON m.CourseID = c.GrantedCourseID
INNER JOIN tblOrganisation o ON o.OrganisationID = c.OrganisationID -- default compliance rules
INNER JOIN tblUnit u ON u.OrganisationID = c.OrganisationID
LEFT JOIN tblUnitRule ur ON ur.ModuleID = m.ModuleID AND ur.UnitID = u.unitID -- unit specific rules
WHERE o.OrganisationID = @organisationID
) umr ON umr.ModuleID  = um.ModuleID
AND umr.UnitID = um.UnitID
AND um.UnitID IN (SELECT DISTINCT UnitID FROM @users)
AND um.UserID IN (SELECT DISTINCT UserID FROM @users)
AND umr.CourseID IN (SELECT CourseID FROM @courses)

-- Get module completion details
INSERT INTO @tblStartedModules
SELECT
um.userID, um.moduleID, qs.DateTimeCompleted
FROM
@tblCurrentAssignedModules um
INNER JOIN (
SELECT
um.userID, um.moduleID, max(DateTimeCompleted) AS DateTimeCompleted
FROM
@tblCurrentAssignedModules um
INNER JOIN tblQuiz q ON q.ModuleID = um.ModuleID
INNER JOIN tblQuizSession qs ON qs.QuizID= q.quizID
AND qs.userID = um.userID
AND qs.DateTimeCompleted IS NOT NULL
GROUP BY
um.userID, um.moduleID
) AS LastQuizDate ON
LastQuizDate.userID = um.userID
AND LastQuizDate.ModuleID = um.ModuleID
INNER JOIN tblQuiz q ON q.ModuleID = um.ModuleID
INNER JOIN tblQuizSession qs ON
qs.QuizID= q.quizID
AND qs.userID = um.userID
AND qs.DateTimeCompleted = LastQuizDate.DateTimeCompleted


BEGIN
SELECT







count(DISTINCT UserID) AS TotalDistinctUsers
FROM
-- User/course combos where the courses are about to be marked incomplete due to module expiry
(SELECT
cam.UserID, max(DateTimeCompleted) AS CompletionDate,
min(isnull(QuizCompletionDate, dateadd(month, QuizFrequency, DateTimeCompleted))) AS ExpiryDate
FROM
@tblCurrentAssignedModules cam
INNER JOIN @tblStartedModules sm ON sm.UserID = cam.UserID AND sm.ModuleID = cam.ModuleID







GROUP BY

cam.UserID
HAVING
min(isnull(
QuizCompletionDate,
dateadd(month, QuizFrequency, DateTimeCompleted)
)) < CASE @warningUnit
WHEN ''mm'' THEN
dateadd(mm, @warningPeriod, getutcdate())
ELSE
dateadd(dd, @warningPeriod, getutcdate())
END) AS warning_report


END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[prcReport_Warning]    Script Date: 04/09/2013 15:31:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_Warning]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/******************************************************************************
**		Name: prcReport_Warning
**
**		Called by:
**
**		Auth: Mark Donald
**		Date: 7 Dec 2009
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**
*******************************************************************************/


CREATE PROCEDURE [dbo].[prcReport_Warning]
(
@organisationID int,
@unitIDs varchar(max),
@courseIDs varchar(8000),
@classificationID int,
@warningPeriod int,
@warningUnit varchar(2),
@IncludeInactive int
)
AS
SET NOCOUNT ON;

DECLARE @Units TABLE (UnitID INT PRIMARY KEY(UnitID))
DECLARE @Courses TABLE(CourseID INT PRIMARY KEY(CourseID))
DECLARE @CoursesWithAccess 	TABLE (CourseID INT PRIMARY KEY(CourseID))
DECLARE @Users TABLE(UserID INT , UnitID INT PRIMARY KEY(UserID, UnitID))
DECLARE @tblCurrentAssignedModules TABLE (
CourseID int,
UserID int,
UnitID int,
ModuleID int,
QuizFrequency int,
QuizCompletionDate datetime
)
DECLARE @tblStartedModules TABLE (
UserID int,
ModuleID int,
DateTimeCompleted datetime
)

INSERT INTO
@Courses
SELECT
*
FROM
dbo.udfCsvToInt(@courseIDs)

INSERT INTO
@Units
SELECT
*
FROM
dbo.udfCsvToInt(@unitIDs)

-- Get users for specfied units, matching Custom Classification option (if provided)
INSERT INTO @Users
SELECT
DISTINCT A.UserID, A.UnitiD
FROM
tblUser A
JOIN @Units B on A.UnitID = B.UnitID
JOIN tblUnit C on B.UnitID = C.UnitID AND C.Active = 1
LEFT JOIN tblUserClassification uc ON uc.UserID  = A.UserID
WHERE
A.Active = (case when @includeinactive = 0 then 1 else A.active end )
AND ((@classificationID =0) OR (classificationID = @classificationID))
--If classification is Any (0), This will find users of any Custom Classification

-- Get compliance rules for in-scope modules
INSERT INTO @tblCurrentAssignedModules
SELECT
CourseID, UserID, um.UnitID, um.ModuleID, QuizFrequency, QuizCompletionDate
FROM
(SELECT
tU.UserID, tU.UnitID, tM.ModuleID
FROM
dbo.tblUser tU
INNER JOIN dbo.tblOrganisationCourseAccess tOCA ON tOCA.OrganisationID = tU.OrganisationID
INNER JOIN dbo.tblCourse tC ON tC.CourseID = tOCA.GrantedCourseID
INNER JOIN dbo.tblModule tM ON tM.CourseID = tC.CourseID AND tM.Active = 1
LEFT OUTER JOIN dbo.tblUserModuleAccess tUsrMA ON tUsrMA.UserID = tU.UserID
AND tUsrMA.ModuleID = tM.ModuleID
LEFT OUTER JOIN dbo.tblUnitModuleAccess tUnitMA ON tUnitMA.UnitID = tU.UnitID
AND tUnitMA.DeniedModuleID = tM.ModuleID
WHERE
tU.OrganisationID = @organisationID
AND	tU.Active = (case when @includeinactive = 0 then 1 else tU.Active end )
AND tu.UnitID IS NOT NULL
AND dbo.udfUserCourseComplete(tu.userid, tm.courseid) = 1
AND ((tUnitMA.DeniedModuleID IS NULL AND tUsrMA.ModuleID IS NULL)
OR tUsrMA.Granted=1)
) um
INNER JOIN (
SELECT
u.UnitID, m.CourseID, m.ModuleID,
CASE
WHEN (
ur.QuizFrequency IS NULL
AND ur.QuizCompletionDate IS NULL
AND o.DefaultQuizCompletionDate IS NULL
) THEN
o.DefaultQuizFrequency
ELSE
ur.QuizFrequency
END AS QuizFrequency,
CASE
WHEN (
ur.QuizFrequency IS NULL
AND ur.QuizCompletionDate IS NULL
AND o.DefaultQuizCompletionDate IS NOT NULL
) THEN
o.DefaultQuizCompletionDate
ELSE
ur.QuizCompletionDate
END AS QuizCompletionDate
FROM
tblOrganisationCourseAccess c
INNER JOIN tblModule m ON m.CourseID = c.GrantedCourseID
INNER JOIN tblOrganisation o ON o.OrganisationID = c.OrganisationID -- default compliance rules
INNER JOIN tblUnit u ON u.OrganisationID = c.OrganisationID
LEFT JOIN tblUnitRule ur ON ur.ModuleID = m.ModuleID AND ur.UnitID = u.unitID -- unit specific rules
WHERE o.OrganisationID = @organisationID
) umr ON umr.ModuleID  = um.ModuleID
AND umr.UnitID = um.UnitID
AND um.UnitID IN (SELECT DISTINCT UnitID FROM @users)
AND um.UserID IN (SELECT DISTINCT UserID FROM @users)
AND umr.CourseID IN (SELECT CourseID FROM @courses)

-- Get module completion details
INSERT INTO @tblStartedModules
SELECT
um.userID, um.moduleID, qs.DateTimeCompleted
FROM
@tblCurrentAssignedModules um
INNER JOIN (
SELECT
um.userID, um.moduleID, max(DateTimeCompleted) AS DateTimeCompleted
FROM
@tblCurrentAssignedModules um
INNER JOIN tblQuiz q ON q.ModuleID = um.ModuleID
INNER JOIN tblQuizSession qs ON qs.QuizID= q.quizID
AND qs.userID = um.userID
AND qs.DateTimeCompleted IS NOT NULL
GROUP BY
um.userID, um.moduleID
) AS LastQuizDate ON
LastQuizDate.userID = um.userID
AND LastQuizDate.ModuleID = um.ModuleID
INNER JOIN tblQuiz q ON q.ModuleID = um.ModuleID
INNER JOIN tblQuizSession qs ON
qs.QuizID= q.quizID
AND qs.userID = um.userID
AND qs.DateTimeCompleted = LastQuizDate.DateTimeCompleted

-- User/course combos where the courses are about to be marked incomplete due to module expiry
BEGIN
SELECT
c.[name] as CourseName,
HierarchyName AS UnitPathway,
LastName,
FirstName,
ExternalID,
Email,
UserName,
dbo.udfUTCtoDaylightSavingTime(max(DateTimeCompleted), @organisationID) AS CompletionDate,
dbo.udfUTCtoDaylightSavingTime(min(isnull(QuizCompletionDate, dateadd(month, QuizFrequency, DateTimeCompleted))), @organisationID) AS ExpiryDate
FROM
@tblCurrentAssignedModules cam
INNER JOIN @tblStartedModules sm ON sm.UserID = cam.UserID AND sm.ModuleID = cam.ModuleID,
tblCourse c,
tblUser u,
tblUnitHierarchy h
WHERE
c.CourseID = cam.CourseID
AND u.UserID = cam.UserID
AND h.UnitID = cam.UnitID
GROUP BY
c.[name], HierarchyName,  LastName, FirstName, ExternalID, Email, Username
HAVING
min(isnull(
QuizCompletionDate,
dateadd(month, QuizFrequency, DateTimeCompleted)
)) < CASE @warningUnit
WHEN ''mm'' THEN
dateadd(mm, @warningPeriod, getutcdate())
ELSE
dateadd(dd, @warningPeriod, getutcdate())
END
ORDER BY
CourseName, UnitPathway, LastName, FirstName
END
' 
END
GO



/****** Object:  StoredProcedure [dbo].[prcUser_GetCourseList]    Script Date: 04/12/2013 12:09:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcUser_GetCourseList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcUser_GetCourseList]
GO
/****** Object:  StoredProcedure [dbo].[prcCourse_EbookGet]    Script Date: 04/12/2013 12:09:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcCourse_EbookGet]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcCourse_EbookGet]
GO
/****** Object:  StoredProcedure [dbo].[prcCourse_EbookAdd]    Script Date: 04/12/2013 12:09:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcCourse_EbookAdd]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcCourse_EbookAdd]
GO
/****** Object:  StoredProcedure [dbo].[prcCourse_EbookDelete]    Script Date: 04/12/2013 12:09:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcCourse_EbookDelete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcCourse_EbookDelete]
GO
/****** Object:  StoredProcedure [dbo].[prcUserEbook_Add]    Script Date: 04/12/2013 12:09:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcUserEbook_Add]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcUserEbook_Add]
GO
/****** Object:  StoredProcedure [dbo].[prcOrganisation_GetFeatureAccess]    Script Date: 04/12/2013 12:09:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_GetFeatureAccess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcOrganisation_GetFeatureAccess]
GO
/****** Object:  StoredProcedure [dbo].[prcOrganisation_UpdateFeatureAccess]    Script Date: 04/12/2013 12:09:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_UpdateFeatureAccess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcOrganisation_UpdateFeatureAccess]
GO
/****** Object:  StoredProcedure [dbo].[prcOrganisation_GetAllFeatureAccess]    Script Date: 04/12/2013 12:09:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_GetAllFeatureAccess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcOrganisation_GetAllFeatureAccess]
GO
/****** Object:  Table [dbo].[tblUserEbook]    Script Date: 04/12/2013 12:08:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblUserEbook]') AND type in (N'U'))
DROP TABLE [dbo].[tblUserEbook]
GO
/****** Object:  Table [dbo].[tblEbook]    Script Date: 04/12/2013 12:08:54 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblEbook2_DateDeleted]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblEbook] DROP CONSTRAINT [DF_tblEbook2_DateDeleted]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblEbook]') AND type in (N'U'))
DROP TABLE [dbo].[tblEbook]
GO
/****** Object:  Table [dbo].[tblOrganisationFeatureAccess]    Script Date: 04/18/2013 16:13:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblOrganisationFeatureAccess]') AND type in (N'U'))
DROP TABLE [dbo].[tblOrganisationFeatureAccess]
GO
/****** Object:  Table [dbo].[tblOrganisationFeatureAccess]    Script Date: 04/18/2013 16:13:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblOrganisationFeatureAccess]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblOrganisationFeatureAccess](
	[OrganisationFeatureAccessID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[OrganisationID] [int] NOT NULL,
	[FeatureName] [nvarchar](100) NOT NULL,
	[Granted] [tinyint] NOT NULL,
 CONSTRAINT [PK_tblOrganisationFeatureAccess] PRIMARY KEY CLUSTERED 
(
	[OrganisationFeatureAccessID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[tblEbook]    Script Date: 04/12/2013 12:08:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblEbook]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblEbook](
	[EbookID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[EbookFileName] [nvarchar](500) NOT NULL,
	[ServerFileName] [varchar](500) NOT NULL,
	[CourseID] [int] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[DateDeleted] [datetime] NULL CONSTRAINT [DF_tblEbook2_DateDeleted]  DEFAULT (NULL),
 CONSTRAINT [PK_tblEbook2] PRIMARY KEY CLUSTERED 
(
	[EbookID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblUserEbook]    Script Date: 04/12/2013 12:08:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblUserEbook]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblUserEbook](
	[UserBookID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[EbookID] [int] NOT NULL,
	[UserAgent] [nvarchar](1000) NOT NULL,
	[DateDownloaded] [datetime] NOT NULL,
	[Result] [nvarchar](100) NULL,
 CONSTRAINT [PK_tblUserEbook] PRIMARY KEY CLUSTERED 
(
	[UserBookID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  StoredProcedure [dbo].[prcOrganisation_GetAllFeatureAccess]    Script Date: 04/12/2013 12:09:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_GetAllFeatureAccess]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[prcOrganisation_GetAllFeatureAccess]

As

/*
declare 
@columns nvarchar(max),
@sql nvarchar(max)

set @columns = N''''

select @columns += N'','' + Quotename(organisationfeaturename)
	from (select organisationfeaturename from tblOrganisationfeature) tmp


set @sql = N''
select organisationid, organisationname, '' + stuff(@columns, 1, 1, '''') + '' '' + ''
from
(
select
ofa.organisationid, o.organisationname, organisationfeaturename, granted
from
tblOrganisation o inner join
tblOrganisationFeatureAccess ofa
	on ofa.organisationid = o.organisationid
inner join tblOrganisationFeature ofea
	on ofea.organisationfeatureid=ofa.organisationfeatureid
) as source
pivot
(
	max(granted)
	for organisationfeaturename in( '' + stuff(@columns, 1, 1, '''') + '' )
) as pvt 
order by organisationname''

print @sql

exec sp_executesql @sql
*/

declare 
@columns nvarchar(max), 
@sql nvarchar(max)

-- append the text with column when adding new feature in the organisation application access
set @columns = ''[cpd profile],[policy],[ebook]''

set @sql = N''
select organisationid, organisationname, '' + @columns + '' '' + ''
from
(
select
o.organisationid, o.organisationname, featurename, granted
from
tblOrganisation o left join
tblOrganisationFeatureAccess ofa
	on ofa.organisationid = o.organisationid
) as source
pivot
(
	max(granted)
	for featurename in( '' + @columns + '' )
) as pvt 
order by organisationname''

exec sp_executesql @sql' 
END
GO
/****** Object:  StoredProcedure [dbo].[prcOrganisation_UpdateFeatureAccess]    Script Date: 04/12/2013 12:09:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_UpdateFeatureAccess]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE Procedure [dbo].[prcOrganisation_UpdateFeatureAccess]
(
@OrganisationID int,
@featurename nvarchar(100),
@granted tinyint
)

As

delete from tblOrganisationFeatureAccess
where
organisationid=@organisationid and featurename=@featurename

if(@granted = 1)
begin

insert into tblOrganisationFeatureAccess
(organisationid, featurename, granted)
values
(@organisationid, @featurename, @granted)

end
else if(@granted = 0)
begin

delete from tblOrganisationFeatureAccess
where
organisationid=@organisationid and featurename=@featurename

end


' 
END
GO
/****** Object:  StoredProcedure [dbo].[prcOrganisation_GetFeatureAccess]    Script Date: 04/12/2013 12:09:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_GetFeatureAccess]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE Procedure [dbo].[prcOrganisation_GetFeatureAccess]
(
@OrganisationID int,
@featureName nvarchar(100)
)

As

select
granted
from tblOrganisationFeatureAccess
where
organisationid=@organisationid
and featurename=@featurename


' 
END
GO
/****** Object:  StoredProcedure [dbo].[prcUserEbook_Add]    Script Date: 04/12/2013 12:09:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcUserEbook_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE  Procedure [dbo].[prcUserEbook_Add]
(
@UserID int,
@EbookID int,
@UserAgent nvarchar(1000),
@Result nvarchar(100)
)

As


insert into
tblUserEbook
(userid, ebookid, useragent, datedownloaded, result)
values
(@UserID, @EbookID, @UserAgent, getUTCDate(), @Result)

' 
END
GO
/****** Object:  StoredProcedure [dbo].[prcCourse_EbookDelete]    Script Date: 04/12/2013 12:09:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcCourse_EbookDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE  Procedure [dbo].[prcCourse_EbookDelete]
(
@courseID int
)

As

update tblEBook 
set DateDeleted = getUTCDate() 
where
courseid = @courseid
and dateDeleted is null

' 
END
GO
/****** Object:  StoredProcedure [dbo].[prcCourse_EbookAdd]    Script Date: 04/12/2013 12:09:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcCourse_EbookAdd]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE   Procedure [dbo].[prcCourse_EbookAdd]
(
@courseid int,
@ebookFileName nvarchar(500),
@serverFileName varchar(500)
)

As

-- insert a new ebook record
Insert Into tblEbook
(
EbookFileName,
ServerFileName,
CourseID,
DateCreated
)
values
(
@ebookFileName,
@serverFileName,
@courseid,
getUTCDate()
)

' 
END
GO
/****** Object:  StoredProcedure [dbo].[prcCourse_EbookGet]    Script Date: 04/12/2013 12:09:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcCourse_EbookGet]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE  Procedure [dbo].[prcCourse_EbookGet]
(
@courseid int,
@organisationid	int		
)

As

select
ebookid,
ebookfilename,
serverfilename,
courseid,
dbo.udfUTCtoDaylightSavingTime(DateCreated, @organisationid) as DateCreated
from
tblEbook 
where
courseid=@courseid
and datedeleted is null

' 
END
GO
/****** Object:  StoredProcedure [dbo].[prcUser_GetCourseList]    Script Date: 04/12/2013 12:09:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcUser_GetCourseList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Gets course List for User My Training page

Parameters:


Returns:


Called By:
User.cs.

Calls:


Assumptions:


Remarks:



Author: Aaron Cripps
Date Created: August 2008

Modification History
-----------------------------------------------------------
v#	Author		Date			Description


**/

CREATE  Procedure [dbo].[prcUser_GetCourseList]
(
@UserID int,
@ProfileID int,
@CurrentCultureName NVarChar(40) = ''en-AU''
)

As

DECLARE @OrgID int

Select @OrgID = OrganisationID FROM tblUser where UserID = @UserID
create table #UserCourse
(
CourseID int,
[Name] nvarchar(100),
Notes nvarchar(1000),
Active bit,
CreatedBy int,
DateCreated datetime,
UpdatedBy int,
DateUpdated datetime
)

insert into #UserCourse
exec prcCourse_GetListByUser @UserID

Create table #CourseName
(
CourseID int,
[Name] nvarchar(100),
DateCreated datetime
)

Create Table #CourseStatus
(
CourseID int,
CourseStatusID int,
DateCreated datetime
)

insert into #CourseStatus
select
ucs.CourseID,
ucs.CourseStatusID,
max(ucs.DateCreated) as DateCreated
from
tblUserCourseStatus ucs
join #UserCourse uc	on  ucs.CourseID = uc.CourseID
where
ucs.UserID = @UserID
and not exists (select * from tblusercoursestatus ucs2
where ucs.courseid = ucs2.courseid
and ucs.userid = ucs2.userid
and ucs.datecreated <ucs2.datecreated )
group by
ucs.CourseID, ucs.CourseStatusID
order by
DateCreated desc

Create Table #CourseStatusTemp
(
CourseID int,
DateCreated datetime
)

insert into #CourseStatusTemp
select
CourseID,
max(DateCreated)
from
#CourseStatus
group by CourseID

Create Table #CourseList
(
CourseID int,
[Name] nvarchar(100),
CourseStatusID int,
Due varchar(11),
LastComp varchar(11),
Red char(1)
)

Declare @DefaultLessonCompletionDate Datetime
Declare @DefaultQuizCompletionDate Datetime
DECLARE @DefaultQuizFrequency integer

SELECT @DefaultQuizCompletionDate = DefaultQuizCompletionDate
,@DefaultLessonCompletionDate = DefaultLessonCompletionDate
,@DefaultQuizFrequency = DefaultQuizFrequency
FROM tblOrganisation where OrganisationID = (SELECT OrganisationID FROM tblUser WHERE UserID = @UserID)

declare @OrganisationID integer

select @OrganisationID = OrganisationID FROM tblUser WHERE UserID = @UserID







insert into #CourseList
select
uc.CourseID,
uc.[Name],
cs.CourseStatusID,
case

when cs.CourseStatusID = 2 and @DefaultQuizCompletionDate is  null  then '' ''
when cs.CourseStatusID = 2 and   @DefaultQuizCompletionDate is not null
then convert(varchar (11),dbo.udfUserUTCtoDaylightSavingTime(@DefaultQuizCompletionDate,@OrganisationID),113)
when cs.CourseStatusID <> 2 and (RemEsc.DaysToCompleteCourse is null OR ((RemEsc.NotifyMgr = 0) AND (RemEsc.RemindUsers = 0))) then ''-- ''
when cs.CourseStatusID <> 2 and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and CStart.DateCreated is null
then CAST(RemEsc.DaysToCompleteCourse AS VARCHAR(5))																																															-- course just added , overnight job has not caught up yet
+ (SELECT  '' ''+LangEntryValue  FROM tblLangValue
where LangInterfaceID = (SELECT  LangInterfaceID   FROM tblLangInterface WHERE LangInterfaceName = ''GLOBAL.MISC'')
and LangID =(SELECT LangID FROM tblLang where tblLang.LangCode=  @CurrentCultureName)
and LangResourceID = (SELECT LangResourceID  FROM tblLangResource where   LangResourceName = ''days'' ))

when cs.CourseStatusID <> 2 and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and CStart.DateCreated is not null	 AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,CS.DateCreated,getUTCdate())) >= 0
then CAST(RemEsc.DaysToCompleteCourse -   DATEDIFF(day,CS.DateCreated,getUTCdate()) AS VARCHAR(5))
+ (SELECT  '' ''+LangEntryValue  FROM tblLangValue
where LangInterfaceID = (SELECT  LangInterfaceID   FROM tblLangInterface WHERE LangInterfaceName = ''GLOBAL.MISC'')
and LangID =(SELECT LangID FROM tblLang where tblLang.LangCode=  @CurrentCultureName)
and LangResourceID = (SELECT LangResourceID  FROM tblLangResource where   LangResourceName = ''days'' ))
when cs.CourseStatusID <> 2 and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and CStart.DateCreated is not null	 AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,CS.DateCreated,getUTCdate())) < 0
then convert(varchar (11),DATEADD(day,RemEsc.DaysToCompleteCourse,dbo.udfUTCtoDaylightSavingTime(CS.DateCreated,@OrgID)),113)


end ,
case
when CPass.DateCreated is null then '' ''
when CPass.DateCreated is not null then convert(varchar (11),dbo.udfUTCtoDaylightSavingTime(CPass.DateCreated,@OrgID),113)
end ,

case when cs.CourseStatusID <> 2 and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and CStart.DateCreated is not null	 AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,CS.DateCreated,getUTCdate())) < 0		then 1 else 0 end

from
#UserCourse uc
left outer join #CourseStatus cs on uc.CourseID = cs.CourseID
left outer join (SELECT MIN(UserCourseStatusID) as UserCourseStatusID,[UserID] ,[CourseID] FROM tblUserCourseStatus LastAttempt where LastAttempt.UserID = @UserID and not exists (SELECT * FROM tblUserCourseStatus PreviousAttempt where PreviousAttempt.UserID = @UserID and PreviousAttempt.CourseStatusID = 0 and PreviousAttempt.UserCourseStatusID < LastAttempt.UserCourseStatusID and PreviousAttempt.CourseID = LastAttempt.CourseID and PreviousAttempt.UserID = LastAttempt.UserID) group by [UserID] ,[CourseID]
) CSID ON CSID.UserID = @UserID and CSID.courseID = cs.courseID
left outer join tblUserCourseStatus CStart ON CStart.UserID = @UserID and CStart.courseID = cs.courseID and CStart.UserCourseStatusID = CSID.UserCourseStatusID
left outer join tblReminderEscalation RemEsc on RemEsc.CourseId = cs.CourseID and RemEsc.orgID = @OrgID
--last passed course date
left outer join
(SELECT MAX(UserCourseStatusID) as UserCourseStatusID,[UserID] ,[CourseID] FROM tblUserCourseStatus PreviousAttempt where PreviousAttempt.userID = @UserID  and PreviousAttempt.CourseStatusID = 2 group by [UserID] ,[CourseID]
) CPSID ON CPSID.UserID = @UserID and CPSID.courseID = cs.courseID
left outer join tblUserCourseStatus CPass ON CPass.UserID = @UserID and CPass.courseID = cs.courseID and CPass.UserCourseStatusID = CPSID.UserCourseStatusID





--Now get points available for each course
Create Table #CoursePoints
(
CourseID int,
PointsAvailable numeric(10,1)
)

insert into #CoursePoints
select
cl.CourseID, sum(ppts.Points)
from
#CourseList cl
join tblModule m on m.CourseID = cl.CourseID
join tblProfilePoints ppts on m.ModuleID = ppts.TypeID
join tblProfilePeriod pp on ppts.ProfilePeriodID = pp.ProfilePeriodID
where
m.Active = 1 and ppts.Active = 1 and pp.ProfileID = @ProfileID
group by
cl.CourseID


select
@ProfileID as ProfileID,
cl.CourseID, cl.[Name],
coalesce(cl.CourseStatusID, 1) as CourseStatusID,
cp.PointsAvailable,
cl.Due ,
cl.LastComp,
cl.red,
e.ebookid
from
#CourseList cl
left join #CoursePoints cp on cl.CourseID = cp.CourseID
left join tblEbook e
	on e.courseid=cl.courseid and e.datedeleted is null
order by cl.[Name]


drop table #UserCourse
drop table #CourseName
drop table #CourseStatus
drop table #CourseStatusTemp
drop table #CourseList
drop table #CoursePoints

' 
END
GO


-- grant all organisation with the ebook access
insert into tblOrganisationFeatureAccess (organisationid, featurename, granted)
select
o.organisationid, 'ebook', 1
from
tblOrganisation o
order by o.organisationid


-- grant organisation with the policy access
insert into tblOrganisationFeatureAccess (organisationid, featurename, granted)
select
o.organisationid, 'cpd profile', 1
from
tblOrganisation o
inner join tblOrganisationCPDAccess o1
	on o.organisationid=o1.organisationid
where
	o1.grantCPDAccess = 1
order by o.organisationid


-- grant organisation with the cpd profile access
insert into tblOrganisationFeatureAccess (organisationid, featurename, granted)
select
o.organisationid, 'policy', 1
from
tblOrganisation o
inner join tblOrganisationPolicyAccess o1
	on o.organisationid=o1.organisationid
where
	o1.grantPolicyAccess = 1
order by o.organisationid



/****** Object:  ForeignKey [FK_tblOrganisationCPDAccess_tblOrganisation]    Script Date: 04/12/2013 12:12:47 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblOrganisationCPDAccess_tblOrganisation]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblOrganisationCPDAccess]'))
ALTER TABLE [dbo].[tblOrganisationCPDAccess] DROP CONSTRAINT [FK_tblOrganisationCPDAccess_tblOrganisation]
GO
/****** Object:  ForeignKey [FK_tblOrganisationPolicyAccess_tblOrganisation]    Script Date: 04/12/2013 12:12:47 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblOrganisationPolicyAccess_tblOrganisation]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblOrganisationPolicyAccess]'))
ALTER TABLE [dbo].[tblOrganisationPolicyAccess] DROP CONSTRAINT [FK_tblOrganisationPolicyAccess_tblOrganisation]
GO
/****** Object:  StoredProcedure [dbo].[prcOrganisation_GetCPDAccess]    Script Date: 04/12/2013 12:12:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_GetCPDAccess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcOrganisation_GetCPDAccess]
GO
/****** Object:  StoredProcedure [dbo].[prcOrganisation_GetCPDPolicyAccess]    Script Date: 04/12/2013 12:12:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_GetCPDPolicyAccess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcOrganisation_GetCPDPolicyAccess]
GO
/****** Object:  StoredProcedure [dbo].[prcOrganisation_GetPolicyAccess]    Script Date: 04/12/2013 12:12:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_GetPolicyAccess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcOrganisation_GetPolicyAccess]
GO
/****** Object:  StoredProcedure [dbo].[prcOrganisation_UpdateCPDPolicyAccess]    Script Date: 04/12/2013 12:12:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_UpdateCPDPolicyAccess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcOrganisation_UpdateCPDPolicyAccess]
GO
/****** Object:  Table [dbo].[tblOrganisationCPDAccess]    Script Date: 04/12/2013 12:12:47 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblOrganisationCPDAccess_tblOrganisation]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblOrganisationCPDAccess]'))
ALTER TABLE [dbo].[tblOrganisationCPDAccess] DROP CONSTRAINT [FK_tblOrganisationCPDAccess_tblOrganisation]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblOrganisationCPDAccess]') AND type in (N'U'))
DROP TABLE [dbo].[tblOrganisationCPDAccess]
GO
/****** Object:  Table [dbo].[tblOrganisationPolicyAccess]    Script Date: 04/12/2013 12:12:47 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblOrganisationPolicyAccess_tblOrganisation]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblOrganisationPolicyAccess]'))
ALTER TABLE [dbo].[tblOrganisationPolicyAccess] DROP CONSTRAINT [FK_tblOrganisationPolicyAccess_tblOrganisation]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblOrganisationPolicyAccess]') AND type in (N'U'))
DROP TABLE [dbo].[tblOrganisationPolicyAccess]
GO



