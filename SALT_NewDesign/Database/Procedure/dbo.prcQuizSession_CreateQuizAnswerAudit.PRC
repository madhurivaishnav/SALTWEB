SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcQuizSession_CreateQuizAnswerAudit]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



/*Summary:
Given a QuizSessionID, ToolbookPageID and ToolbookAnswerID creates an
entry in the tblQuizAnswerAudit Table.

Returns:
Nothing

Called By:
ToolbookListener.cs

Calls:
dbo.udfGetQuizIDBySessionID
dbo.udfGetQuizQuestionIDByToolbookPageID
dbo.udfGetQuizAnswerIDByToolbookAnswerID

Remarks:

Author:
Peter Kneale
Date Created: 10 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	Gavin Buddis	1 Mar 2004		Retreived the QuizAnswerID to insert rather than the ToolbookAnswerID

**/

CREATE    Procedure [prcQuizSession_CreateQuizAnswerAudit]
(
@strQuizSessionID 	Varchar(50),		-- Users Session ID
@strToolbookPageID 	Varchar(50),		-- the Toolbook ID of the quiz
@intToolbookAnswerID 	Integer			-- the Quiz Answer ID
)

As

Set NoCount On
Set Xact_Abort On
Begin Transaction

------------------------------------------
-- Declerations
-----------------------------------------
Declare @intQuizID integer
Declare @intQuizQuestionID integer
Declare @intQuizAnswerID integer

------------------------------------------
-- Get Quiz ID by SessionID
-------------------------------------------
Set @intQuizID = dbo.udfGetQuizIDBySessionID(@strQuizSessionID)
If (@intQuizID is NULL or datalength(@intQuizID) = 0)
Begin
Rollback
INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''Procedure prcQuizSession_CreateQuizAudit '',''No data found in tblQuizSession for QuizSessionID'',''@strQuizSessionID = ''+CAST(@strQuizSessionID AS varchar(40)),''No data found in tblQuizSession for QuizSessionID'',''No data found in tblQuizSession for QuizSessionID'',''prcQuizSession_CreateQuizAudit'',1,1,null,getutcdate(),getutcdate()) 
Raiserror (''Procedure prcQuizSession_CreateQuizAudit could not determine the @intQuizID using udfGetQuizIDBySessionID'', 16, 1)
Return
End

------------------------------------------
-- Get Quiz Question ID by Toolbook PageID
-------------------------------------------
Set @intQuizQuestionID 	=  dbo.udfGetQuizQuestionIDByToolbookPageID(@strToolbookPageID, @intQuizID)
If (@intQuizQuestionID is NULL or datalength(@intQuizQuestionID) = 0)
Begin
Rollback
INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''Procedure prcQuizSession_CreateQuizAudit '',''udfGetQuizQuestionIDByToolbookPageID returned null'',''@strToolbookPageID = ''+CAST(@strToolbookPageID AS varchar(40))+'', @intQuizID = ''+CAST(@intQuizID AS varchar(40)),''udfGetQuizQuestionIDByToolbookPageID returned null'',''udfGetQuizQuestionIDByToolbookPageID returned null'',''prcQuizSession_CreateQuizAudit'',1,1,null,getutcdate(),getutcdate()) 
Raiserror (''Procedure prcQuizSession_CreateQuizAudit could not determine the @intQuizQuestionID using udfGetQuizQuestionIDByToolbookPageID'', 16, 1)
Return
End

------------------------------------------
-- Get Quiz Answer ID by Toolbook AnswerID
-------------------------------------------
DECLARE @intValidAnswer integer
Set @intValidAnswer =
(
Select count(*)
From
tblQuizAnswer
Where
ToolbookAnswerID = @intToolbookAnswerID
And
QuizQuestionID = @intQuizQuestionID
)
if (@intValidAnswer = 0)
BEGIN
   Rollback
   INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''Procedure prcQuizSession_CreateQuizAudit '',''ToolBook Answer is not in the list of possible answers for this Quiz'',''@toolbookAnswerID = ''+CAST(@intToolbookAnswerID AS varchar(40))+'', @quizQuestionID = ''+CAST(@intQuizQuestionID AS varchar(40)),''ToolBook Answer is not in the list of possible answers for this Quiz'',''ToolBook Answer is not in the list of possible answers for this Quiz'',''prcQuizSession_CreateQuizAudit'',1,1,null,getutcdate(),getutcdate())
   DECLARE @ErrStr varchar(2000)
   Set @ErrStr = ''ToolBook Answer is not in the list of possible answers for this Quiz, @toolbookAnswerID = ''+CAST(@intToolbookAnswerID AS varchar(40))+'', @quizQuestionID = ''+CAST(@intQuizQuestionID AS varchar(40))
   Raiserror (@ErrStr, 16, 1)
   Return 
END
ELSE
BEGIN
	Set @intQuizAnswerID = dbo.udfGetQuizAnswerIDByToolbookAnswerID(@intToolbookAnswerID, @intQuizQuestionID)
	If (@intQuizAnswerID is NULL or datalength(@intQuizAnswerID) = 0)
	Begin
	Rollback
	INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''Procedure prcQuizSession_CreateQuizAudit '',''dbo.udfGetQuizAnswerIDByToolbookAnswerID returned null'',''@intToolbookAnswerID = ''+CAST(@intToolbookAnswerID AS varchar(40))+'', @intQuizQuestionID = ''+CAST(@intQuizQuestionID AS varchar(40)),''dbo.udfGetQuizAnswerIDByToolbookAnswerID returned null'',''dbo.udfGetQuizAnswerIDByToolbookAnswerID returned null'',''prcQuizSession_CreateQuizAudit'',1,1,null,getutcdate(),getutcdate())
	Raiserror (''Procedure prcQuizSession_CreateQuizAudit could not determine the @intAnswerID using udfGetQuizAnswerIDByToolbookAnswerID'', 16, 1)
	Return
	End
END
------------------------------------------
-- Insert
------------------------------------------
Insert Into
tblQuizAnswerAudit
(
QuizSessionID,
QuizQuestionID,
QuizAnswerID
)
Values
(
@strQuizSessionID,
@intQuizQuestionID,
@intQuizAnswerID
)
Commit Tran

' 
END
GO
