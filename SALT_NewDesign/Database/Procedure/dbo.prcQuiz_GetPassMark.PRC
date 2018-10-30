SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcQuiz_GetPassMark]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary: Returns the pass mark for the given module for the given unit
Parameters: @UnitID integer, @ModuleID integer
Returns: integer

Called By: ToolbookListener.aspx
Calls: udfQuiz_GetPassMark

Remarks: Raises an error if the parameter is null

Author: Peter Kneale
Date Created: 9th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	GB		9/2/04			Coding standards
#2	SKC		11/2/04		Moved functionality into a udf so that it is accessable to other stored proc''s

-- prcQuiz_GetPassMark 1,1
*/

CREATE  Procedure [prcQuiz_GetPassMark]
(
@UnitID int = null,
@ModuleID int = null
)

As

If @UnitID Is Null
Begin
Raiserror(''The Parameter @UnitID was null.  @UnitID does not accept Null values.'', 16, 1)
Return
End

If @ModuleID Is Null
Begin
Raiserror(''The Parameter @ModuleID was null.  @ModuleID does not accept Null values.'', 16, 1)
Return
End

Select
dbo.udfQuiz_GetPassMark(@UnitID, @ModuleID) As ''PassMark''
' 
END
GO
