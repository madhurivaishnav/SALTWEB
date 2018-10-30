SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcLessonPageAudit_InsertPageVisited]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- exec prcLessonPageAudit_InsertPageVisited @lessonSessionID = ''EC58F6F8-85FB-4BEC-9E42-1C54E4B16D3F'', @toolBookPageID = ''salt_2-293008''
/*Summary:
inserts the page visited
returns true if the lesson has not (a) already been finished and (b) page exists in the toolbook
Returns:
bit 1 = true, 0 = false

Called By:
TooolBooLlistner.aspx via Businessservices.Toolbook.RecordPageVisited
Calls:
dbo.udfGetLessonPageIDByToolbookPageID

Remarks:
- at least one of lessonPageID or ToolbookPageID must be supplied
- returns nothing
Exception:
0. Success
4. UniqueViolationException
5. MissingParameterException
10. BusinessServiceException (General)

Author:
Stephen Kennedy-Clark
Date Created: 3 Feb 2004

Modification History
-----------------------------------------------------------
v# Author  Date   Description
#1

exec prcLessonPageAudit_InsertPageVisited @lessonSessionID = ''4686890D-B458-402B-B32A-80F8FDCEB6BA'', @toolBookPageID = ''salt_34-253006''
exec prcLessonPageAudit_InsertPageVisited @lessonSessionID = ''F6D89B6F-CE87-4AF0-880F-61037538B0BC'', @toolBookPageID = ''salt_29-231005''
exec prcLessonPageAudit_InsertPageVisited @lessonSessionID = ''EC58F6F8-85FB-4BEC-9E42-1C54E4B16D3F'', @toolBookPageID = ''salt_2-293008''
exec prcLessonPageAudit_InsertPageVisited @lessonSessionID = ''0860A9EA-3D97-423C-AAC4-42435A15E336'', @toolBookPageID = ''salt_34-250002''
exec prcLessonPageAudit_InsertPageVisited @lessonSessionID = ''0860A9EA-3D97-423C-AAC4-42435A15E336'', @toolBookPageID = ''salt_34-250008A''
print dbo.udfGetLessonPageIDByToolbookPageID(''salt_34-250002'')
--------------------


**/


CREATE     PROC [prcLessonPageAudit_InsertPageVisited]
(
@lessonSessionID  varchar(50)  -- the Lesson Session ID
, @lessonPageID   int   = null -- the lesson page id
, @toolBookPageID  varchar(50)  = null -- the toolbook page id
)

AS
Set NoCount On
Set Xact_Abort On
Begin Transaction



------------------------------------------
-- Declerations
------------------------------------------
Declare @intReturnValue int 		-- Return Value
, @strErrorMessage varchar(100) -- error message
, @intErrorNumber int		-- error Number
, @intLessonID int		-- the lesson ID
-- Initialise variables
Set @intErrorNumber = 0
Set @strErrorMessage = ''''


------------------------------------------
-- Validation - ensure that the required paramaters
-- were supplied
------------------------------------------

--< check that either the userID or the lessonSessionID were supplied >--
IF @lessonPageID IS NULL AND @toolBookPageID IS NULL
BEGIN
set @intErrorNumber = 5 -- MissingParameterException
set @strErrorMessage = ''Procedure prcLessonPageAudit_InsertPageVisited expects at least one  the following pramaters: @lessonPageID or @toolBookPageID''
Goto Finalise
END

------------------------------------------
-- If @lessonPageID not suppled then get it from @toolBookPageID
------------------------------------------

IF @lessonPageID IS NULL
BEGIN
-- first we need the lesson ID because toolbook id''s are not unique
SET @intLessonID = dbo.udfGetLessonIDBySessionID(@lessonSessionID)
-- now we can get the lessonpageID from the
SET @lessonPageID = dbo.udfGetLessonPageIDByToolbookPageID(@toolBookPageID, @intLessonID)
END
IF @lessonPageID IS NULL
BEGIN
set @intErrorNumber = 10 --BusinessServiceException
set @strErrorMessage =  ''Procedure prcLessonPageAudit_InsertPageVisited was passed a value for the paramater "@toolBookPageID" that does not exist in this database''
Goto Finalise
END
------------------------------------------
-- Validation - ensure that the lesson has been started but is not already finished
-- and that the ToolBook pageID exists
------------------------------------------
if exists --< ensure that the lesson has been started but is not already finished  >--
(
Select
LessonSessionID
From
tblLessonSession
where
LessonSessionID = @lessonSessionID
and DateTimeStarted is not null
and DateTimeCompleted is null
)
and exists --< ensure that the ToolBook pageID exists >--
(
SELECT TOP 1
LessonPageID
FROM
tblLessonPage
WHERE
ToolbookPageID = @toolBookPageID
)

Begin --< It''s ok to continue>--

------------------------------------------
-- insert the new row
-- what checks for uniquness should be preformed ???
------------------------------------------
if not exists (select LessonSessionID from tblLessonPageAudit where LessonPageID = @lessonPageID and LessonSessionID = @lessonSessionID)
Begin
INSERT INTO
[tblLessonPageAudit]
(
[LessonSessionID],
[LessonPageID],
[DateAccessed]
)
VALUES(
@lessonSessionID,
@lessonPageID,
getdate()
)
End
set @intReturnValue = 1
End
Else
Begin --< opps - error, either the lesson has finished or has not been started ??? TB should error.salt will handel this gracefully in TBListiner>--
set @intReturnValue = 0
Goto Finalise
End



------------------------------------------
-- return
------------------------------------------
Finalise:
If(@intErrorNumber > 0)
Begin
set @strErrorMessage = ''Error Number: '' + cast(@intErrorNumber as char(2) ) + '' ,'' + @strErrorMessage
Raiserror (@strErrorMessage, 16, 1)
Rollback Transaction
select @intReturnValue as ''Insert is OK''
End
Else
Begin
Commit Transaction
select @intReturnValue as ''Insert is OK''
End









' 
END
GO
