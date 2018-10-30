SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcQuiz_GetModuleIDByToolbookID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:
Parameters: @ToolbookID varchar(50)
Returns: integer

Called By: ToolbookListener.aspx
Calls: None

Remarks: Raises an error if the parameter is null

Author: Peter Kneale
Date Created: 9th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	GB		9/2/04			Coding standards
*/

CREATE Procedure [prcQuiz_GetModuleIDByToolbookID]
(
@ToolbookID varchar(50) = null -- Toolbook ID
)

As

Select
ModuleID
From
tblQuiz
Where
ToolbookID = @ToolBookID
' 
END
GO
