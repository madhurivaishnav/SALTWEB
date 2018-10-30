SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPreprocessOneOrgUnassignedCourses]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcPreprocessOneOrgUnassignedCourses] @orgid INT
AS
BEGIN
	-- **********************************
	--< This procedure looks for Courses for which a user  >--
	--<   * has no access to any modules>--
	--<    * currently has a Course Status other than unAssigned>--
	--< All Couses in the Organisation that match these criteria are set to ''Unassigned''>--
	--< it is believed that the overnight job currently handles the reverse of this case correctly.>--
	--< don''t want to overload the cpu when admins are making big changes by assigning courses to units/ etc>--
	--< so don''t ''clean up'' the status of courses for at least one day after the last update to this course status.>--
	-- **********************************

	DECLARE @when DATETIME

	SET @when = DATEADD(d, - 1, getutcdate())

	INSERT INTO tblUserCourseStatus (
		[UserID]
		,[CourseID]
		,[CourseStatusID]
		,[ModulesAssigned]
		,[DateCreated]
		)
	SELECT CCS.UserID
		,CCS.CourseID
		,0
		,'''' AS ModulesAssigned
		,GETUTCDATE() AS DateCreated
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
	LEFT JOIN (
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
	WHERE CAM.UserID IS NULL
		AND CCS.CourseStatusID <> 0
		AND CCS.DateCreated < @when
END
' 
END
GO
