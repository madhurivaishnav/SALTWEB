SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcLesson_GetListByModule]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*Summary:
Selects a list of lessons for a module. Caller can specify whether to only return only valid modules.

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
0. Succeed
5. ParameterException


Author: Gavin Buddis
Date Created: 16 February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	mikev		4/5/2007		Added WorkSiteIDs to select

**/
CREATE  Procedure [prcLesson_GetListByModule]
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
Set @strErrorMessage = ''Missing or Null parameter @moduleID in stored procedure prcLesson_GetListByModule''
Goto Finalise
End

If (@activeOnly = 1)
Begin
Select
LessonID,
ModuleID,
ToolbookID,
ToolbookLocation,
dbo.udfUTCtoDaylightSavingTime(DatePublished, @OrgID),
LoadedBy,
dbo.udfUTCtoDaylightSavingTime(DateLoaded, @OrgID),
Active,
LWorkSiteID,
QFWorkSiteID
From
tblLesson
Where
ModuleID = @moduleID
And Active = 1
End
Else
Begin
Select
LessonID,
ModuleID,
ToolbookID,
ToolbookLocation,
dbo.udfUTCtoDaylightSavingTime(DatePublished, @OrgID),
LoadedBy,
dbo.udfUTCtoDaylightSavingTime(DateLoaded, @OrgID),
Active,
LWorkSiteID,
QFWorkSiteID
From
tblLesson
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
