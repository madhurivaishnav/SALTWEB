SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUserCourseStatus_insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



/*Summary:
Inserts a new line in the tblUserCourseStatus

Returns:
null

Called By:
trgUserQuizStatus
Calls:

Remarks:




Author: Stepehn Clark
Date Created: 24 March 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	JH			07 Oct 2011		add error logging, allow updates to courses after all modules in those courses have been made inactive


**/
CREATE    procedure [prcUserCourseStatus_insert]
(
@UserID   int -- The User ID
, @ModuleID int -- The Module ID
, @StatusID int -- The Status ID Completed = 1 Incomplete = 0
)
As
------------------------

Declare @intCourse int,
@intInactiveCourse int
, @strModuleIDs varchar(200)
DECLARE @Err integer
IF @StatusID in (0,1) 
BEGIN 
	set @intCourse = (select top 1 CourseID from tblModule where ModuleID = @ModuleID and active = 1) --If no modules active don''t set status to "Not Started"
	if @intCourse is null
	begin
		--Raiserror (''error in prcUserCourseStatus_insert, module is inactive!'', 16, 1)
		--INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated]) VALUES(''prcUserCourseStatus_insert'',''prcUserCourseStatus_GetStatus'',''UserID=''+CAST(@UserID AS varchar(10)),''error - no active course!'',''ModuleID = ''+CAST(@ModuleID AS VARCHAR(10))+'', StatusID = ''+CAST(@StatusID AS VARCHAR(10)),''prcUserQuizStatus_UpdateCourseStatus'',1,1,null,getutcdate(),getutcdate()) 
		return
	end
END
ELSE 
BEGIN
	set @intCourse = (select top 1 CourseID from tblModule where ModuleID = @ModuleID)   --Some quiz results but now all modules inactive so save the results
	if @intCourse is null
	begin
		Raiserror (''error in prcUserCourseStatus_insert, course does not exist!'', 16, 1)
		INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated]) VALUES(''prcUserCourseStatus_insert'',''prcUserCourseStatus_GetStatus'',''UserID=''+CAST(@UserID AS varchar(10)),''error - no active course!'',''ModuleID = ''+CAST(@ModuleID AS VARCHAR(10))+'', StatusID = ''+CAST(@StatusID AS VARCHAR(10)),''prcUserQuizStatus_UpdateCourseStatus'',1,1,null,getutcdate(),getutcdate()) 
		return
	end
END
-------------------------------------------------------
--- Get the ModulesID''s as a comma seperated string
-------------------------------------------------------
set @strModuleIDs = '''' -- string to hold moduelids
select
@strModuleIDs = cast(ModuleID as varchar) + '','' + @strModuleIDs
from
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
--< get the details on which moduels a user''s Unit is excluded from  >--
Left Outer Join dbo.tblUnitModuleAccess tUnitMA
On  tUnitMA.UnitID = tU.UnitID
And tUnitMA.DeniedModuleID = tM.ModuleID
Where
tC.CourseID = @intCourse AND tU.UserID = @UserID AND
tU.Active = 1
--< Active users only >--
and tu.UnitID is not null
--< Get the modules that the user''s Unit is not denied >--
and (tUnitMA.DeniedModuleID  is null
--<  and the user does not have special access to  it>--
And tUsrMA.ModuleID is null)
--< or Get modules that the user has been specially  granted
or tUsrMA.Granted=1
) as tempTable
where
CourseID = @intCourse
and  UserID = @UserID
-------------------------------------------------------
--- insert the new values
-------------------------------------------------------

INSERT INTO
tblUserCourseStatus
(
UserID,
CourseID,
CourseStatusID,
ModulesAssigned,
DateCreated
)
VALUES
(
@UserID
, @intCourse
, @StatusID
, @strModuleIDs
, GETUTCDATE()
)
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserCourseStatus_insert'',''INSERT INTO tblUserCourseStatus'',''UserID=''+CAST(@UserID AS varchar(10)),''CourseID = ''+CAST(@intCourse AS VARCHAR(10)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_UpdateCourseStatus'',1,1,null,getutcdate(),getutcdate()) END




' 
END
GO
