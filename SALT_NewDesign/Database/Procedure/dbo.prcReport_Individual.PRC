SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_Individual]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Given a user id returns the list of courses / modules and the latest results for that user
If the User id is ommited it returns results for all users
Returns:
Course ID

Called By:
Home.aspx via Businessservices.Report.GetIndividualReport
Calls:
udfReport_IndividualDetails
Remarks:


Author:
Stephen Kennedy-Clark
Date Created: 6 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	Peter Kneale	8/3/04			Modified, removed two level tier report format



--------------------

**/

CREATE       Proc [prcReport_Individual]
(
@userID int = null -- the user ID
)
AS
------------------------------------------
Set Nocount On

Select

UserID
, CourseID
, CourseName
, ModuleID
, ModuleName
, LessonID
, tLS.Status as ''LessonStatus''
, tQS.Status as ''QuizStatus''
, QuizScore
, QuizPassMark
, [Sequence]

From
udfReport_IndividualDetails(@userID) tID
--< inner join onto lesson status to get the name of the status>--
inner join tblLessonStatus tLS
on tLS.LessonStatusID = tID.LessonStatus
inner join tblQuizStatus tQS
on tQS.QuizStatusID =  tID.QuizStatus

Order by userid, CourseID, [Sequence]
' 
END
GO
