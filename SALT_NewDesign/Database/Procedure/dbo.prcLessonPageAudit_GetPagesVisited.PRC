SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcLessonPageAudit_GetPagesVisited]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'







/*Summary:
Given (UserID or SessionID) and (lessonID or ToolbookID)
return a list of the pages that a user has visited in thIs lesson (toolbook)
Returns:
ordered table of distinct PageID''s

Called By: TooolBooLlistner.aspx
Calls:

Remarks:
- at least one of UserID or SessionID must be supplied
- at least one of lessonID or ToolbookID must be supplied
- returns true (Int 1) if the user''s unit has access to the course the lesson Is in
and neither of the users unit / or the user themselves have been excluded from accessing that module.

Author:
Stephen Kennedy-Clark
Date Created: 2 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1



--------------------
prcLessonPageAudit_GetPagesVisited @userID=11, @lessonSessionID=''D91F43C9-AA74-46FC-AAA6-F3B4E184FEFF''
select * from tblLessonSession
**/


CREATE        Proc [prcLessonPageAudit_GetPagesVisited]
(
@userID Int = Null,			-- The users ID
@lessonSessionID Varchar(50) = Null,	-- The Lesson Session ID (a GUID)
@lessonID Int = Null,			-- The Lesson ID
@toolBookID Varchar(50) = Null		-- The ToolBook ID
)

As

Set  NOCOUNT ON


------------------------------------------
-- Validation - ensure that the required paramaters
-- were supplied
------------------------------------------

--< check that either the userID or the lessonSessionID were supplied >--
If @userID Is Null AND @lessonSessionID Is Null
Begin
Raiserror (''Procedure prcLessonPageAudit_GetPagesVisited expects at least one  the following pramaters: UserID or SessionID'', 16, 1)
Return
End


------------------------------------------
-- If @userID not suppled then get it from @lessonSessionID
------------------------------------------
If @userID Is Null
Begin
Set  @userID= dbo.udfGetUserIDBySessionID(@lessonSessionID)
End


------------------------------------------
-- If @lessonID not suppled then get it from @toolBookID
------------------------------------------

If @lessonID Is Null and @toolBookID is not null
Begin
Set  @lessonID = dbo.udfGetLessonIDByToolbookID(@toolBookID)
End

If @lessonID Is Null and @toolBookID is null and @lessonSessionID is not null
Begin
set @lessonID = dbo.udfGetLessonIDBySessionID(@lessonSessionID)
end

------------------------------------------
-- Join and select back tblLessonPageAudit to tblLessonSession
-- to get all the pages the user has visited
------------------------------------------

select distinct
tLP.ToolbookPageID
from
tblLessonPage tLP
inner join tblLessonPageAudit tLPA
on tLPA.LessonPageID = tLP.LessonPageID
inner Join tblLessonSession tLS
on tLS.LessonSessionID = tLPA.LessonSessionID
Where
tLS.userID = @userID
and tLS.LessonID = @lessonID







' 
END
GO
