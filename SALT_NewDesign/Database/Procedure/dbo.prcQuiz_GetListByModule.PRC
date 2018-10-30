SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcQuiz_GetListByModule]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*Summary:
Selects a list of quizzes for a module. Caller can specify whether to only return active quizzes.

Parameters:
@moduleID
@activeOnly

Returns:
@intErrorNumber As ''ErrorNumber'',
@strErrorMessage As ''ErrorMessage''

Called By:
Module.cs.

Calls:
Nothing

Remarks:
Exception:
0. Succeeded
5. ParameterException
10. BusinessServiceException (General)


Author: Gavin Buddis
Date Created: 16 February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	mikev		4/5/2007		Added WorkSiteID to select

**/
CREATE  Procedure [prcQuiz_GetListByModule]
(
@moduleID Integer = Null,
@activeOnly Bit = 0,
@OrgID int
)

As

Set Nocount On

-- Declarations
Declare @strErrorMessage Varchar(200) -- Holds the error message
Declare @intErrorNumber Integer -- Holds the error number

-- Initialise variables
Set @strErrorMessage = ''''
Set @intErrorNumber = 0

--Validate Parameter @moduleID
If (@moduleID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @moduleID in stored procedure prcQuiz_GetListByModule''
Goto Finalise
End

If (@activeOnly = 1)
Begin
Select
QuizID,
ModuleID,
ToolbookID,
ToolbookLocation,
dbo.udfUTCtoDaylightSavingTime(DatePublished, @OrgID),
LoadedBy,
dbo.udfUTCtoDaylightSavingTime(DateLoaded, @OrgID),
Active,
WorkSiteID
From
tblQuiz
Where
ModuleID = @moduleID And
Active = 1
End
Else
Begin
Select
QuizID,
ModuleID,
ToolbookID,
ToolbookLocation,
dbo.udfUTCtoDaylightSavingTime(DatePublished, @OrgID),
LoadedBy,
dbo.udfUTCtoDaylightSavingTime(DateLoaded, @OrgID),
Active,
WorkSiteID
From
tblQuiz
Where
ModuleID = @moduleID

End

Finalise:
If(@intErrorNumber > 0)
Begin
Select
@intErrorNumber As ''ErrorNumber'',
@strErrorMessage As ''ErrorMessage''
End



' 
END
GO
