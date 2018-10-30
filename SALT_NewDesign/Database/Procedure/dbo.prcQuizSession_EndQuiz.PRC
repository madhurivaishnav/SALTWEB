SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcQuizSession_EndQuiz]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
this proc records that a Quiz has ended by updating tblQuizSession
is Sets
-- DateTimeCompleted from getutcDate();
-- Duration from Toolbook
-- QuizScore from Toolbook
-- QuizPassMark passmark (Using prcQuiz_GetPassMark).
it also:
-- Checks that the Quiz has started -- if it has NOT -> return false
-- Checks that the Quiz has not already ended -- if it has -> return false



Returns:
boolean (bit) OK true = 1, false = 0

Called By:
ToolbookListener.cs via Businessservices.Toolbook.EndQuizSession

Calls:
udfQuiz_GetPassMark
udfGetUserIDBySessionID
udfGetQuizIDBySessionID

Remarks:

Author:
Stephen Kennedy-Clark
Date Created: 11 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


-----------
prcQuizSession_EndQuiz @quizSessionID =
select * from tblQuizSession

**/

CREATE   Procedure  [prcQuizSession_EndQuiz]
(
@quizSessionID	varchar(50) 	-- unique GUID that identifies this toolbook quiz session
, @duration	int		-- The duration in seconds of the quiz as messured by toolbook
, @score	int		-- the score as mesured by toolbook
)

As
--Begin Transaction
Set NoCount On
Set Xact_Abort On

------------------------------------------
-- Declerations
------------------------------------------
Declare   @intRetVal 	bit 		-- return value indicating sucess or failure
, @intUserID 	int		-- user id
, @intQuizID 	int		-- Quiz id
, @intPassMark 	int		-- Pass Mark
, @intUnitID 	int		-- Unit ID
, @intModuleID 	int		-- Module ID

------------------------------------------
-- initations
------------------------------------------
Set @intUserID	   = dbo.udfGetUserIDBySessionID(@quizSessionID)
Set @intQuizID	   = dbo.udfGetQuizIDBySessionID(@quizSessionID)
Select @intUnitID  = (Select Top 1 UnitID From tblUser Where UserID = @intUserID)
Select @intModuleID= (Select Top 1 ModuleID From tblQuiz Where QuizID = @intQuizID)
Set @intPassMark   = dbo.udfQuiz_GetPassMark(@intUnitID,@intModuleID)


------------------------------------------
-- Checks that the Quiz has started - if it has not -> return false
-- and
-- Checks that the Quiz has not already ended - if it has -> return false
-- If all is OK then end the Quiz by recording end time, duration and score
------------------------------------------
If Exists
(
Select
QuizSessionID
From
tblQuizSession
Where
QuizSessionID=@quizSessionID
--< Check that the Quiz has started >--
And DateTimeStarted Is Not Null
--< Check that the @quizSessionID has not already ended >--
And DateTimeCompleted Is Null
)


Begin --< it is ok to End, record End and return true >--
Update
[tblQuizSession]
Set
[DateTimeCompleted]	= getutcdate()
, [Duration]		= @duration
, [QuizScore]		= @score
, [QuizPassMark]	= @intPassMark

Where
[QuizSessionID]  	= @quizSessionID
set @intRetVal = 1 --< return 1 indicates sucess >--


End
Else
Begin  -- it is NOT ok to End, return false
set @intRetVal = 0
End


------------------------------------------
-- return
------------------------------------------

Select @intRetVal as ''OKToEnd''

--Commit Tran
' 
END
GO
