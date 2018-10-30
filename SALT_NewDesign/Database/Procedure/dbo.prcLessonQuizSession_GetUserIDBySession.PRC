SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcLessonQuizSession_GetUserIDBySession]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


/*Summary:
Starts a Lesson and Returns a  sessionID
Returns:
UserID int

Called By: TooolBooLlistner.aspx
prcUserModuleAccess_Validate
Calls:
udfGetUserIDBySessionID
Remarks:


Author:
Stephen Kennedy-Clark
Date Created: 2 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


declare @val int
execute @val =prcLessonQuizSession_GetUserIDBySession @SessionID=''EDB764D3-5099-4E94-B870-DEE8C56243EA''
print @val

print dbo.udfGetUserIDBySessionID(''EDB764D3-5099-4E94-B870-DEE8C56243EA'')
-- select * from tblQuizSession
-- select * from tblLessonSession
**/

CREATE Proc [prcLessonQuizSession_GetUserIDBySession]
(
@SessionID varchar(50)
)

As

Set NoCount On


------------------------------------------
-- Declerations
------------------------------------------
Declare @intRetVal int

------------------------------------------
-- get user id for this session
------------------------------------------
set @intRetVal = dbo.udfGetUserIDBySessionID(@SessionID)

------------------------------------------
-- return
------------------------------------------
select @intRetVal as ''SessionName'';
' 
END
GO
