SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcLessonPageAudit_GetPagesVisitedBySessionID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Given (UserID or SessionID) and (lessonID or ToolbookID)
return a list of the pages that a user has visited in this lesson (toolbook)
Returns:
ordered table of distinct PageID''s

Called By:
TooolBooLlistner.aspx via Businessservices.Toolbook.GetPagesVisited
Calls:
dbo.udfGetUserIDBySessionID
dbo.udfGetLessonIDBySessionID
Remarks:
- at least one of UserID or SessionID must be supplied
- at least one of lessonID or ToolbookID must be supplied
- returns true (Int 1) if the user''s unit has access to the course the lesson is in
and neither of the users unit / or the user themselves have been excluded From accessing that module.
-------------------
-- get the lessionID from this sessionID
-- get all the sessions that this user has started against this lesson
-- get (distinct) all the lessnoPageID''s that the user has visited
-- get the toolbookPageID''s from these lesson-PageID''s pages that have been visited in these sessions
-------------------

Author:
Stephen Kennedy-Clark
Date Created: 2 Feb 2004

Modification History
-----------------------------------------------------------
v# Author  Date   Description
#1



--------------------
prcLessonPageAudit_GetPagesVisitedBySessionID @lessonSessionID = ''036E63C1-1724-4480-A42C-70F63D8A0FDA''
exec prcLessonPageAudit_GetPagesVisitedBySessionID @lessonSessionID = ''036E63C1-1724-4480-A42C-70F63D8A0FDA''
exec prcBookMark_GetBookMarkBySessionID @lessonSessionID = ''036E63C1-1724-4480-A42C-70F63D8A0FDA''
exec prcUser_GetNameBySessionID @sessionID  = ''036E63C1-1724-4480-A42C-70F63D8A0FDA''
exec prcLessonPageAudit_InsertPageVisited @lessonSessionID = ''036E63C1-1724-4480-A42C-70F63D8A0FDA'', @toolBookPageID = ''salt_29-230001''
exec prcLessonPageAudit_InsertPageVisited @lessonSessionID = ''036E63C1-1724-4480-A42C-70F63D8A0FDA'', @toolBookPageID = ''salt_29-230002''
print dbo.udfGetUserIDBySessionID(''036E63C1-1724-4480-A42C-70F63D8A0FDA'') -- 4
print dbo.udfGetLessonIDBySessionID(''036E63C1-1724-4480-A42C-70F63D8A0FDA'') -- 16

**/


CREATE PROC [prcLessonPageAudit_GetPagesVisitedBySessionID]
(
@lessonSessionID varchar(50)  -- The Lesson Session ID ( a GUID)
)

AS

Set NOCOUNT ON


------------------------------------------
-- Declerations
------------------------------------------
Declare
@intUserID  integer  -- The Users ID
,@intLessonID  integer  -- The Lesson ID

------------------------------------------
-- If @intUserID not suppled then get it From @lessonSessionID
------------------------------------------

Set @intUserID= dbo.udfGetUserIDBySessionID(@lessonSessionID)



------------------------------------------
-- get @intLessonID From @lessonSessionID
------------------------------------------
Set @intLessonID = dbo.udfGetLessonIDBySessionID(@lessonSessionID)


-------------------


select distinct
tLP.ToolBookPageID
from
( --< get all the sessions (SessionID''s) that this user has started against this lesson >--
select
lessonSessionID
, LessonID
from
tblLessonSession
where
UserID = @intUserID
and lessonID = @intLessonID
) ilvLS -- in line view Lesson - Session
--< get the pages the user has visited in all these sessions >--
inner join tblLessonPageAudit tLPA
on tLPA.LessonSessionID = ilvLS.lessonSessionID
--< to get the toolbook page id we need to joi onto tblLessonPage >--
inner join tblLessonPage tLP
on tLP.LessonPageID = tLPA.LessonPageID










' 
END
GO
