SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcQuizSession_StartQuiz]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
-- Check that the quiz has not already been started
-- if it has - return false
-- if it has not, start it and return true
Returns:
boolean (bit) OKToStart true = 1, false = 0

Called By:
ToolbookListener.cs
Calls:

Remarks:

Author:
Peter Kneale
Date Created: 10 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


-----------
prcQuizSession_StartQuiz @QuizSessionID = ''4986F67F-FF29-4979-9A97-D7846839E0DB''


**/

CREATE Procedure  [prcQuizSession_StartQuiz]
(
@QuizSessionID varchar(50)
)

As

Set NoCount On
Set Xact_Abort On
Begin Tran


------------------------------------------
-- Declerations
------------------------------------------
Declare @RetVal bit 		-- Return value holding bit indicating success condition as described above

------------------------------------------
-- Check that the quiz has not already been started
-- if it has - return false
-- if it has not, start it and return true
-- Start the quiz ( insert a start date )
------------------------------------------
If Exists
(
Select
QuizSessionID
From
tblQuizSession
Where
QuizSessionID = @QuizSessionID
And
DateTimeStarted is Null
)

Begin
-- it is ok to start, record start and return true
--< do update >--
Update
tblQuizSession
Set
DateTimeStarted =	GETUTCDATE()
Where
QuizSessionID = @QuizSessionID
--< set return value >--
Set @RetVal = 1
End

Else

Begin  -- it is NOT ok to start, return false
--< set return value >--
Set @RetVal = 0
End

Commit Tran

------------------------------------------
-- select SessionID
------------------------------------------

Select @RetVal as ''OKToStart''
Return
' 
END
GO
