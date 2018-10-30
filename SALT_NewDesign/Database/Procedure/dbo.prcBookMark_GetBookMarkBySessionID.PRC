SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcBookMark_GetBookMarkBySessionID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'






/*Summary:
Given (UserID or SessionID) and (lessonID or ToolbookID)
returns the bookmark for this lesson (toolbook) for this user
Returns:
table, 1 row (lessonPageID int,  Tolbook Page ID string)

Called By:
TooolBooLlistner.aspx via BusinessServices.Toolbook.GetBookmark
Calls:
dbo.udfGetUserIDBySessionID
dbo.udfGetLessonIDBySessionID
Remarks:
- at least one of UserID or SessionID must be supplied
- at least one of lessonID or ToolbookID must be supplied
- returns both the lessonPageID and the Tolbook Page ID for this page

Author:
Stephen Kennedy-Clark
Date Created: 2 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1



--------------------
exec prcBookMark_GetBookMarkBySessionID @lessonSessionID = ''134E8E5F-EC8A-4C95-8FA5-142AC87246C1''

**/


CREATE     PROC [prcBookMark_GetBookMarkBySessionID]
(
@lessonSessionID varchar(50) -- the lesson Session ID
)

AS

SET NOCOUNT ON

select top 1
ToolBookPageID
from

tblLessonSession tLS

inner join tblLessonPage tLP
on tLP.LessonID = tLS.LessonID

inner join tblBookmark tBM
on tBM.lessonPageID = tLP.LessonPageID
and tBM.UserID = tLS.UserID
where
lessonSessionID = @lessonSessionID

order by
--< only get the latest bookmark set >--
tBM.DateCreated




' 
END
GO
