SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPreprocessOneOrgNoLongerFailedCourses]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create PROCEDURE [prcPreprocessOneOrgNoLongerFailedCourses] @orgid INT
AS
BEGIN

	-- **********************************
	--< This procedure looks for Courses for which a user  >--
	--<   * has access to any modules with a status of '' Passed''>--
	--<   * has NO access to any modules with a status of ''Not Passed''>--
	--<    * currently has a Course Status of NOT Passed>--
	--< All Couses in the Organisation that match these criteria have their status recalculated >--
	-- **********************************




declare @UserID int, @ModuleID int
DECLARE ModuleLOOP CURSOR
FOR
	SELECT   
	CCS.UserID,	CAM.moduleid
	FROM tblUserCourseStatus CCS  --< Detail Course Status information >--
	INNER JOIN (
																					--<  Last (Latest) Course Status  >--
		SELECT max(tblUserCourseStatus.UserCourseStatusID) AS maxUserCourseStatusID
			,tbluser.UserID
			,CourseID
		FROM tblUserCourseStatus
		INNER JOIN tblUser ON tblUser.UserID = tblUserCourseStatus.UserID
		WHERE tblUser.OrganisationID = @orgid
			AND tblUser.Active = 1
		GROUP BY tbluser.UserID
			,CourseID
																					--<  Last (Latest) Course Status  >--
		) lastStatus ON lastStatus.CourseID = CCS.CourseID
		AND lastStatus.UserID = CCS.UserID
		AND lastStatus.maxUserCourseStatusID = CCS.UserCourseStatusID
	INNER JOIN (
																					--<         C   A   M              >--
																					--<   Current   Assigned  Modules  >--
																					--<   All modules a User Currently has access to                       >--
		SELECT um.UserID
			,um.ModuleID
			,um.CourseID
		FROM (
			SELECT tU.UserID
				,tU.UnitID
				,tU.OrganisationID
				,tM.ModuleID
				,tC.CourseID
			FROM dbo.tblUser tU
			--< get the courses a user has access to >--
			INNER JOIN dbo.tblOrganisationCourseAccess tOCA ON tOCA.OrganisationID = tU.OrganisationID
			--< get the course details >--
			INNER JOIN dbo.tblCourse tC ON tC.CourseID = tOCA.GrantedCourseID
			--< get the Active modules in a course >--
			INNER JOIN dbo.tblModule tM ON tM.CourseID = tC.CourseID
				AND tM.Active = 1
			--< get the details on which modules a user is configured to access >--
			LEFT OUTER JOIN dbo.tblUserModuleAccess tUsrMA ON tUsrMA.UserID = tU.UserID
				AND tUsrMA.ModuleID = tM.ModuleID
			--< get the details on which modules a user''s Unit is excluded from  >--
			LEFT OUTER JOIN dbo.tblUnitModuleAccess tUnitMA ON tUnitMA.UnitID = tU.UnitID
				AND tUnitMA.DeniedModuleID = tM.ModuleID
			WHERE tU.OrganisationID = @OrgID
				AND tU.Active = 1
				--< Active users only >--
				AND (
					tu.UnitID IS NOT NULL
					--< Get the modules that the user''s Unit is not denied >--
					AND (
						tUnitMA.DeniedModuleID IS NULL
						--<  and the user does  have special access to  it>--
						AND tUsrMA.ModuleID IS NULL
						)
					--< or Get modules that the user has been specially  granted >--
					OR tUsrMA.Granted = 1
					)
			) um
		INNER JOIN (
			SELECT u.UnitID
				,m.CourseID
				,m.ModuleID
			FROM tblOrganisationCourseAccess c
			INNER JOIN tblModule m ON m.CourseID = c.GrantedCourseID
			INNER JOIN tblOrganisation o -- Get default compliance rules
				ON o.OrganisationID = c.OrganisationID
			INNER JOIN tblUnit u ON u.OrganisationID = c.OrganisationID
			WHERE o.OrganisationID = @OrgID
			) umr ON umr.ModuleID = um.ModuleID
			AND umr.UnitID = um.UnitID
			AND um.UnitID IN (
				SELECT UnitID
				FROM tblUnit
				WHERE OrganisationID = @OrgID
				)
			AND um.UserID IN (
				SELECT UserID
				FROM tblUser
				WHERE OrganisationID = @OrgID
				)
																							--<   C   A   M   >--


		) CAM ON CAM.userid = CCS.userid
		AND cam.CourseID = CCS.CourseID
		
		inner join (select QuizStatus.UserID,QuizStatus.ModuleID,QuizStatus.QuizStatusID from
tblUserQuizStatus QuizStatus
inner join tblModule m on m.ModuleID = QuizStatus.ModuleID
inner join
(
select
max(UserQuizStatusID) UserQuizStatusID --UserQuizStatusID is identity
from
tblUserQuizStatus
WHERE
tblUserQuizStatus.UserID in (select UserID from tblUser where OrganisationID = @OrgID)
group by
UserID,moduleID
) currentStatus
on QuizStatus.UserQuizStatusID = currentStatus.UserQuizStatusID
where m.active = 1 and QuizStatus.QuizStatusID = 2
) PMS on PMS.UserID=CAM.UserID and PMS.ModuleID = CAM.ModuleID  --PassedModulesStatus
left join (select QuizStatus.UserID,QuizStatus.ModuleID,QuizStatus.QuizStatusID from
tblUserQuizStatus QuizStatus
inner join tblModule m on m.ModuleID = QuizStatus.ModuleID
inner join
(
select
max(UserQuizStatusID) UserQuizStatusID --UserQuizStatusID is identity
from
tblUserQuizStatus
WHERE
tblUserQuizStatus.UserID in (select UserID from tblUser where OrganisationID = @OrgID)
group by
UserID,moduleID
) currentStatus
on QuizStatus.UserQuizStatusID = currentStatus.UserQuizStatusID
where m.active = 1 and QuizStatus.QuizStatusID <> 2 -- FailedUserQuizStatus
) FQS on FQS.UserID=CAM.UserID and FQS.ModuleID = CAM.ModuleID		
	WHERE 
	  CCS.CourseStatusID = 1 and PMS.QuizStatusID =2		and FQS.QuizStatusID IS NULL




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
