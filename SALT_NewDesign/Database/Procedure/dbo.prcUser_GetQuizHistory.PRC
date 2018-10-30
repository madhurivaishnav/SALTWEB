SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_GetQuizHistory]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
Summary: Returns the quiz history for a given user for a given module
Parameters: @UserID integer, @ModuleID integer
Returns:

Recordset 1
Status,
QuizPassMark,
QuizScore,
DateCreated,
QuizStatusID,
QuizSessionID

Called By:
User.cs
Calls:


Remarks: Raises an error if the parameter is null

Author: Peter Kneale
Date Created: 9th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description

-- prcUser_GetQuizHistory 1,1
*/
CREATE Procedure [prcUser_GetQuizHistory]
@UserID 	Integer,		-- UserID of the user that we want the quiz history on
@ModuleID 	Integer,		-- Module ID from which we need the quiz history information
@OrgID int
As
Set NoCount On

--------------------------------------------------------------------
---- Declarations
--------------------------------------------------------------------

--------------------------------------------------------------------
---- Logic
----- Get the Users Quiz Details
--------------------------------------------------------------------

Select
Status,
QuizPassMark,
QuizScore,
dbo.udfUTCtoDaylightSavingTime(DateCreated, @OrgID) as DateCreated,
tblUserQuizStatus.QuizStatusID,
QuizSessionID
From
tblUserQuizStatus, tblQuizStatus
Where
tblUserQuizStatus.QuizStatusID = tblQuizStatus.QuizStatusID
And
tblUserQuizStatus.UserID = @userID
And
tblUserQuizStatus.ModuleID = @moduleID

Order By
DateCreated desc
' 
END
GO
