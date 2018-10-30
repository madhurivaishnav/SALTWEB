SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcQuizSession_CreateQuizAudit]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
Given a QuizSessionID and ToolbookPageID creates an entry in the
tblQuizAudit Table.

Returns:
Nothing

Called By:
ToolbookListener.cs

Calls:
dbo.udfGetQuizIDBySessionID
dbo.udfGetQuizQuestionIDByToolbookPageID

Remarks:
The duration of the quiz is set to be 0 because toolbook does not
currently return this information, it may be added at a later date.

Author:
Peter Kneale
Date Created: 10 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

**/

CREATE    Procedure [prcQuizSession_CreateQuizAudit]
(
@strQuizSessionID varchar(50),		-- Users Session ID
@strToolbookPageID varchar(50)	-- the Toolbook Page ID of the Quiz
)

As

Set NoCount On
Set Xact_Abort On
Begin Tran

------------------------------------------
-- Declerations
------------------------------------------
Declare @intQuizQuestionID  Integer		-- QuizQuestionID from Salt database.
Declare @intQuizID 	       Integer		-- QuizID from Salt database.

------------------------------------------
-- Get Quiz ID by SessionID
------------------------------------------
Set @intQuizID =  dbo.udfGetQuizIDBySessionID (@strQuizSessionID)
If (@intQuizID Is NULL or datalength(@intQuizID) = 0)
Begin
ROLLBACK
Raiserror (''Procedure prcQuizSession_CreateQuizAudit could not determine the @intQuizID using udfGetQuizIDBySessionID'', 16, 1)
Return
End

------------------------------------------
-- Get Question ID by SessionID
------------------------------------------
Set @intQuizQuestionID 	= dbo.udfGetQuizQuestionIDByToolbookPageID (@strToolbookPageID,@intQuizID)
If (@intQuizQuestionID Is NULL or datalength(@intQuizQuestionID) = 0)
Begin
ROLLBACK
Raiserror (''Procedure prcQuizSession_CreateQuizAudit could not determine the @intQuizQuestionID using udfGetQuizQuestionIDByToolbookPageID'', 16, 1)
Return
End

------------------------------------------
-- Insert
------------------------------------------
Insert Into
tblQuizQuestionAudit
(
QuizSessionID,
QuizQuestionID,
Duration,
DateAccessed
)
Values
(
@strQuizSessionID,
@intQuizQuestionID,
0,			-- Duration is recorded as 0 becuase the duration per question is not returned from Toolbook.
getutcDate()
)
Commit Tran
' 
END
GO
