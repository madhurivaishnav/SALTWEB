SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcLessonQuizSession_CheckSessionUnique]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



/*Summary:
Given SessionID (lesson or quiz) guid
returns true if the session is unique else returns false
Returns:
scaler bit 0 = false,  1 = true

Called By: TooolBooLlistner.aspx via Businessservices.Toolbook.SessionIsUnique
Calls:

Remarks:


Author:
Stephen Kennedy-Clark
Date Created: 3 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1



--------------------

**/


CREATE   Proc [prcLessonQuizSession_CheckSessionUnique]
(
@sessionID varchar(50) -- The session ID
)

AS

Set NoCount On

------------------------------------------
-- Declerations
------------------------------------------
Declare @intReurnValue int
set @intReurnValue = 1

------------------------------------------
-- Check to see if lesson or session already exists
------------------------------------------
if exists
(
(select LessonSessionID from tblLessonSession where LessonSessionID = @sessionID)
union
(select QuizSessionID from tblQuizSession where QuizSessionID = @sessionID)
)
Begin
set @intReurnValue = 0
End

Select @intReurnValue
Return

' 
END
GO
