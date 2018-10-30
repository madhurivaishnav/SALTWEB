SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcQuizSession_GetQuizIDByToolbookID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:

Parameters: @ToolbookID varchar(50)

Returns: integer

Called By: ToolbookListener.aspx

Calls: None

Remarks: Raises an error any input parameter is null

Author: Peter Kneale
Date Created: 4th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	GB		9/2/04			Coding standards
*/

CREATE Procedure [prcQuizSession_GetQuizIDByToolbookID]
(
@strToolbookID varchar(50)
)

As

If @strToolbookID Is Null
Begin
Raiserror(''The Parameter @strToolbookID was null.  @strToolbookID does not accept Null values.'', 16, 1)
Return
End

Select
Top 1 *
From
[tblQuiz]
Where
ToolbookID = @strToolbookID
' 
END
GO
