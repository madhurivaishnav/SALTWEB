SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcQuizSession_GetQuizIDBySessionID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:

Parameters: @strSessionID varchar(50)

Returns: integer

Called By: ToolbookListener.aspx

Calls: udfGetQuizIDBySessionID

Remarks: Raises an error any input parameter is null

Author: Peter Kneale
Date Created: 4th of February 2004

Modification History
-----------------------------------------------------------
v#	Author	Date		Description
#1	GB	9/2/04		Coding standards
#2	GB	3/3/04		Changed to retrieve QuizID by SessionID rather than ToolbookID
*/

CREATE  Procedure [prcQuizSession_GetQuizIDBySessionID]
(
@strSessionID varchar(50)
)
As
-- Declarations
Declare @intRetVal Int

-- Validation
If @strSessionID Is Null
Begin
Raiserror(''The Parameter @strSessionID was null.  @strSessionID does not accept Null values.'', 16, 1)
Return
End

-- Logic
Set @intRetVal = dbo.udfGetQuizIDBySessionID(@strSessionID)
If @intRetVal Is Null
Begin
Raiserror(''The QuizID could not be determined using udfGetQuizIDBySessionID .'', 16, 1)
Return
End

Select @intRetVal As ''QuizID''
' 
END
GO
