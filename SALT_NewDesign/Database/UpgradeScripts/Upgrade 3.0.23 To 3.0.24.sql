set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO

/*Summary:
Calculate the latest course status for a user - course

Returns:
int CourseID

Called By:
prcQuizSession_GetEndQuizInfo
Calls:
Stored procedure

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

Author: Li Zhang
Date Created: 13-10-2006
Modification History
-----------------------------------------------------------
v#	Author		Date			Description
3.0.24 Li Zhang		19-01-2007		Avoid use the row count result of vwUserQuizStatus and vwUserModule in calculating the user course status 
**/



ALTER PROCEDURE [dbo].[prcUserCourseStatus_Calc]
(
@CourseID int	-- The course ID
, @UserID int 	-- The user ID
, @NewQuizStatus int	-- New quiz status for calculating latest course status
, @ModuleID int -- quiz module ID
)
AS
------------------------------------
SET Nocount On

BEGIN

DECLARE @intStatus int, -- Return Value
@intRowCount int,
@intQuizFrequency int

DECLARE	@tblUserQuizStatus TABLE
(
ModuleID    int
, QuizStatusID int
)

--< select all user quiz status details before update >--

INSERT INTO
@tblUserQuizStatus
(
ModuleID
, QuizStatusID
)
SELECT
vUQS.ModuleID
, vUQS.QuizStatusID
FROM vwUserQuizStatus vUQS
INNER JOIN vwUserModuleAccess vUMA
ON
vUQS.ModuleID = vUMA.ModuleID
AND vUMA.Userid = @UserID
AND vUMA.CourseID = @CourseID
AND vUQS.CourseID = @CourseID
AND vUQS.UserID = @UserID

--< get the rowcount >--

SET @intRowCount = @@RowCount

--< update the @tblUserQuizStatus with the latest user quiz details >--
--< when user sit the course for the first time >--
IF @intRowCount = 0
BEGIN

INSERT  INTO @tblUserQuizStatus
(	ModuleID
, QuizStatusID
)
VALUES
(
@ModuleID
, @NewQuizStatus
)
END

--< user who had sat some modules in the course >--
IF @intRowCount <> 0
BEGIN
--< user resit the same module >--
IF EXISTS (SELECT QuizStatusID FROM @tblUserQuizStatus WHERE ModuleID = @ModuleID)
	BEGIN
	--< quiz record exists, update quiz status >--
	UPDATE @tblUserQuizStatus SET QuizStatusID = @NewQuizStatus WHERE ModuleID = @ModuleID
	END
ELSE
	BEGIN
	INSERT  INTO @tblUserQuizStatus
	(	ModuleID
	, QuizStatusID
	)
	VALUES
	(
	@ModuleID
	, @NewQuizStatus
	)
	END
END

--< star to calculate the latest course status >--
--< if there are any results for anything other than passed then the course is incomplete >--

IF EXISTS (SELECT ModuleID FROM @tblUserQuizStatus WHERE QuizStatusID <> 2)
BEGIN
	--< Course status: Incomplete >--
RETURN  1
END

--< Get number of modules that the user has access to >--
select * into #tblTemp from vwUserModuleAccess where userID = @UserID and courseID=@CourseID
SET @intRowCount = @@RowCount

--<  all the quizes are passed then the course is complete >--
IF  (SELECT COUNT(ModuleID) FROM @tblUserQuizStatus WHERE QuizStatusID = 2) = @intRowCount
BEGIN
--< Course status: Complete >--
drop table #tblTemp
RETURN 2
END

--< User doesn’t have access to any module in the course>--
IF (@intRowCount = 0)
BEGIN
	RETURN 0
END

--< otherwise course incomplete >--
RETURN 1

END
