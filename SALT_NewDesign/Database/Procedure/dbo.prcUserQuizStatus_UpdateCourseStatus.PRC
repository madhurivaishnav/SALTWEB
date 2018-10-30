IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUserQuizStatus_UpdateCourseStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [prcUserQuizStatus_UpdateCourseStatus]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUserQuizStatus_UpdateCourseStatus]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
for the record just in the tblUserQuizStatus:
-- get the old course status in tblUserCourseStatus
-- calculate the new course status
-- insert new course status into tblUserCourseStatus if old and new course status are different

called by:
prcUserQuizStatus_Update

Author: Li Zhang
Date Created: 24-10-2006
*/

CREATE PROCEDURE [prcUserQuizStatus_UpdateCourseStatus]
(
@UserID int
, @ModuleID int
)
AS
SET nocount ON
--SET xact_abort ON

DECLARE @intOldCourseStatus int
DECLARE @intNewCourseStatus int
DECLARE @intCourseID int

SET @intCourseID = (select CourseID from tblModule where ModuleID = @ModuleID)
DECLARE @Err integer
EXEC @intOldCourseStatus = prcUserCourseStatus_GetStatus @intCourseID, @UserID
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_UpdateCourseStatus'',''prcUserCourseStatus_GetStatus'',''UserID=''+CAST(@UserID AS varchar(10)),CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_UpdateCourseStatus'',1,1,null,getutcdate(),getutcdate()) END

IF @Err = 0
BEGIN
EXEC @intNewCourseStatus = prcUserCourseStatus_Calculate @intCourseID, @UserID
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_UpdateCourseStatus'',''prcUserCourseStatus_Calculate'',''UserID=''+CAST(@UserID AS varchar(10)),CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_UpdateCourseStatus'',1,1,null,getutcdate(),getutcdate()) END

IF @Err = 0
BEGIN
IF (@intOldCourseStatus = -1) or (@intOldCourseStatus <> @intNewCourseStatus)
BEGIN
EXEC prcUserCourseStatus_Insert @UserID, @ModuleID, @intNewCourseStatus
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_UpdateCourseStatus'',''prcUserCourseStatus_Insert'',''UserID=''+CAST(@UserID AS varchar(10)),CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_UpdateCourseStatus'',1,1,null,getutcdate(),getutcdate()) END

END
ELSE
BEGIN
IF NOT EXISTS (
Select
tU.UserID
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
--< get the details on which moduels a user''s Unit is excluded from  >--
Left Outer Join dbo.tblUnitModuleAccess tUnitMA
On  tUnitMA.UnitID = tU.UnitID
And tUnitMA.DeniedModuleID = tM.ModuleID
Where
tC.CourseID = @intCourseID AND tU.UserID = @UserID AND
tU.Active = 1
--< Active users only >--
and tu.UnitID is not null
--< Get the modules that the user''s Unit is not denied >--
and (tUnitMA.DeniedModuleID  is null
--<  and the user does not have special access to  it>--
And tUsrMA.ModuleID is null)
--< or Get modules that the user has been specially  granted
or tUsrMA.Granted=1
)
AND EXISTS (SELECT UserCourseStatusID FROM tblUserCourseStatus WHERE UserID = @UserID AND CourseID = @intCourseID AND CourseStatusID <> 0)
BEGIN
EXEC prcUserCourseStatus_Insert @UserID, @ModuleID, @StatusID = 0
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_UpdateCourseStatus'',''prcUserCourseStatus_Insert'',''UserID=''+CAST(@UserID AS varchar(10)),CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_UpdateCourseStatus'',1,1,null,getutcdate(),getutcdate()) END
IF (@intOldCourseStatus <> 1) and ( @intNewCourseStatus = 1)
BEGIN
UPDATE   tblUserCourseDetails
SET  LastDelinquencyNotification = null, LastDelNoteToMgr = 0, NumberOfDelinquencyNotifications = 0
WHERE UserID = @UserID AND CourseID = @intCourseID
END
END
END
END
END

' 
END
GO


