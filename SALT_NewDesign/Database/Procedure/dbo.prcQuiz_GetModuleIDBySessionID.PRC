SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcQuiz_GetModuleIDBySessionID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:
Parameters: @ToolbookID varchar(50)
Returns: integer

Called By: ToolbookListener.aspx
Calls: udfGetQuizIDBySessionID, udfGetModuleIDByQuizID

Remarks: Raises an error if the parameter is null

Author: Peter Kneale
Date Created: 9th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date		Description
#1	GB		9/2/04		Coding standards
#2	GB		3/3/04		Changed to retrieve QuizID by SessionID rather than ToolbookID
*/

CREATE  Procedure [prcQuiz_GetModuleIDBySessionID]
(
@sessionID varchar(50) = null -- Session ID
)

As

Declare @intQuizID int 		-- Quiz ID
Declare @intRetVal Int		-- Module ID that is to be returned

-- Retrieve the QuizID from the supplied SessionID
Set @intQuizID = dbo.udfGetQuizIDBySessionID(@sessionID)

-- Retrieve the ModuleID from the retrieved QuizID
Set @intRetVal = dbo.udfGetModuleIDByQuizID(@intQuizID)

-- Return the ModuleID
Select @intRetVal As ''ModuleID''
' 
END
GO
