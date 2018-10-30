SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPreprocessOneOrgAssignedCourses]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcPreprocessOneOrgAssignedCourses] @orgid INT
AS
BEGIN

	-- **********************************
	--< This procedure looks for Courses for which a user  >--
	--<   * has access to any modules>--
	--<    * currently has a Course Status of unAssigned>--
	--< All Couses in the Organisation that match these criteria have their status recalculated >--
	-- **********************************




declare @UserID int, @ModuleID int
DECLARE ModuleLOOP CURSOR
FOR
	SELECT   
	CCS.UserID,	uma.moduleid

	FROM tblUserCourseStatus CCS  --< Detail Course Status information >--
	INNER JOIN (
																					--<  Last (Latest) Course Status  >--
		SELECT max(tblUserCourseStatus.UserCourseStatusID) AS maxUserCourseStatusID
			,tbluser.UserID
			,CourseID
		FROM tblUserCourseStatus
		INNER JOIN tblUser ON tblUser.UserID = tblUserCourseStatus.UserID
		WHERE  tblUser.OrganisationID = @OrgID AND tblUser.Active = 1
		GROUP BY tbluser.UserID
			,CourseID
																					--<  Last (Latest) Course Status  >--
		) lastStatus ON lastStatus.CourseID = CCS.CourseID
		AND lastStatus.UserID = CCS.UserID
		AND lastStatus.maxUserCourseStatusID = CCS.UserCourseStatusID
		
		inner join vwUserModuleAccess UMA on UMA.CourseID = CCS.CourseID and UMA.UserID = CCS.UserID
		
	WHERE  CCS.CourseStatusID  =  0
Open ModuleLOOP

FETCH NEXT FROM ModuleLOOP
Into
@UserID, @ModuleID

WHILE @@FETCH_STATUS = 0
BEGIN
	EXEC prcUserQuizStatus_UpdateCourseStatus @UserID, @ModuleID
	DECLARE @Err integer
	SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcPreprocessOneOrgAssignedCourses'',''prcUserQuizStatus_UpdateCourseStatus'',''prcUserQuizStatus_UpdateCourseStatus'',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_Update_Quick'',1,1,null,getutcdate(),getutcdate()) END


FETCH NEXT FROM ModuleLOOP
Into
@UserID, @ModuleID
END

CLOSE ModuleLOOP
DEALLOCATE ModuleLOOP




END
' 
END
GO
