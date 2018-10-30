SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcQuizSession_BeforeStartQuiz]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*Summary:
Given a UserID and QuizID starts a Quiz and returns a QuizSessionID
Returns:
QuizSessionID guid

Called By:
ToolbookListener.cs

Calls:

Remarks:
starts a Quiz and returns the details of the Quiz Session so that it can be opened by salt

Author:
Peter Kneale
Date Created: 2 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date		Description
#1	GB		2/3/04		Added join to Module table in return select
#2 Removed unnecessary transactions

prcQuizSession_BeforeStartQuiz @UserID=11, @QuizID=1

**/

CREATE  Procedure [prcQuizSession_BeforeStartQuiz]
(
@userID int,		-- Users ID
@moduleID int		-- the Quiz ID
)

As

Set NoCount On
Set Xact_Abort On

------------------------------------------
-- Declarations
------------------------------------------
Declare @strQuizSessionID varchar(50)	-- GUID identifying the new session
Declare @intQuizID int			-- Quiz ID the user is starting

------------------------------------------
-- Start New Session
------------------------------------------
Set @strQuizSessionID = newid()

------------------------------------------
-- Start New Session
------------------------------------------
Set @intQuizID =
(
Select Top
1 QuizID
From
tblQuiz
Where
moduleID = @moduleID
And
Active=1
)
If (@intQuizID is NULL or datalength(@intQuizID) = 0)
Begin
Raiserror (''Procedure prcQuizSession_BeforeStartQuiz could not determine the @intQuizID'', 16, 1)
Return
End

------------------------------------------
-- Insert
------------------------------------------
Insert Into
tblQuizSession
(
QuizSessionID,
UserID,
QuizID
)
Values
(
@strQuizSessionID,
@userID,
@intQuizID
)

------------------------------------------
-- select Session Details: SessionID, ModuleName, CourseName and Location
------------------------------------------
Select Top 1
tblModule.[Name] 		As ''ModuleName'',
tblCourse.[Name] 		As ''CourseName'',
@strQuizSessionID 		As ''SessionID'',
tblQuiz.ToolbookLocation 	As ''Location''
,Scorm1_2
From
tblModule
Inner Join tblQuiz
on tblQuiz.ModuleID 	= tblModule.ModuleID
Inner Join tblCourse
on tblCourse.CourseID	 = tblModule.CourseID

Where
tblModule.ModuleID = @moduleID
And
tblQuiz.Active = 1

Return
' 
END
GO
