SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcModule_GetDetailsForHomePage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'





/*Summary:
Given a users ID this proc Gets all Details For the datagrid on the HomePage
Returns:
ordered table of distinct PageID''s

Called By:
TooolBooLlistner.aspx via Businessservices.user.HomePageDetails
Calls:
dbo.udfReport_IndividualDetails
dbo.udfGetLessonStatus
dbo.tblLesson
Remarks:


Author:
Stephen Kennedy-Clark
Date Created: 2 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


--------------------
exec prcModule_GetDetailsForHomePage @userID = 2, @courseID = 1

**/
CREATE Procedure [prcModule_GetDetailsForHomePage]

(
@userID  int = null     -- ID of this User
, @courseID int	= null	-- ID of this Course
, @ProfileID int,
	@CurrentCultureName NVarChar(40) = ''en-AU''
)
AS
------------------------------------------
Set Nocount On



if @ProfileID <> -1
begin
	select
	userModule.UserID
	, userModule.CourseID
	, userModule.ModuleID
	, userModule.ModuleName
	, userModule.LessonID
	, userModule.LessonStatus
	, userModule.LessonStatusName
	, userModule.QuizStatus
	, userModule.QuizStatusName
	, userModule.QFSPath
	, case
	when userProfilePoints.Points is null
	then 0
	else userProfilePoints.Points
	end Points
	,QuizExpiryDate as QuizDue
	,LastComp
	,Red
	from
	(
	select
	udfRID.*, tLS.LessonStatusID, tLS.Status LessonStatusName, tQs.QuizStatusID, tQs.Status QuizStatusName
	from
	udfReport_IndividualDetailsExtended(@userID,@CurrentCultureName) udfRID
	--< Get the name of the lesson status >--
	inner join tblLessonStatus tLS
	on tLS.LessonStatusID = udfRID.LessonStatus
	--< Get the name of the quiz status >--
	inner join tblQuizStatus tQS
	on tQS.QuizStatusID = udfRID.QuizStatus
	) userModule

	left join
	(
	select
	ppts.*, pp.ProfileID, pp.ProfilePeriodActive
	from
	tblProfilePoints ppts
	inner join tblProfilePeriod pp
	on pp.ProfilePeriodID = ppts.ProfilePeriodID
	where
	ppts.ProfilePointsType=''M''
	and ppts.Active = 1
	and (pp.ProfileID = @ProfileID)
	and pp.profileperiodactive = 1
	) userProfilePoints
	on
	userProfilePoints.TypeID = userModule.ModuleID
	where
	userModule.CourseID = isNull(@courseID, userModule.CourseID)
	order by
	[Sequence]
end
else
begin
	select
	udfRID.UserID
	, udfRID.CourseID
	--, CourseName
	, udfRID.ModuleID
	, udfRID.ModuleName
	, udfRID.LessonID
	, udfRID.LessonStatus as LessonStatus
	, tLS.Status 	      as LessonStatusName
	, udfRID.QuizStatus   as QuizStatus
	, tQS.Status 	      as QuizStatusName
	--, QuizScore
	--, QuizPassMark
	, udfRID.QFSPath
	, 0			  as Points
	,QuizExpiryDate as QuizDue
	,LastComp
	,Red
	from
	udfReport_IndividualDetailsExtended(@userID,@CurrentCultureName) udfRID
	--< Get the name of the lesson status >--
	inner join tblLessonStatus tLS
	on tLS.LessonStatusID = udfRID.LessonStatus
	--< Get the name of the quiz status >--
	inner join tblQuizStatus tQS
	on tQS.QuizStatusID = udfRID.QuizStatus
	--	left join tblProfilePoints ppts
	--		on ppts.TypeID = udfRID.ModuleID
	--	left join tblProfilePeriod pp
	--		on pp.ProfilePeriodID = ppts.ProfilePeriodID
	where
	udfRID.CourseID = isNull(@courseID, udfRID.CourseID)
	--	and ppts.ProfilePointsType=''M''
	--	and ppts.Active = 1
	--	and (pp.ProfileID = @ProfileID or @profileid  =-1)
	order by
	[Sequence]
end

' 
END
GO
