SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcLessonSession_StartLesson]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
-- Check that the lesson has not already been started
-- if it has - return false
-- if it has not, start it and return true
Returns:
boolean (bit) OKToStart true = 1, false = 0

Called By:
Businessservices.Toolbook.StartLesson
Calls:

Remarks:

Author:
Stephen Kennedy-Clark
Date Created: 2 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
#2 Removed unnecessary transactions

-----------
prcLessonSession_StartLesson @LessonSessionID = ''4986F67F-FF29-4979-9A97-D7846839E0DB''


**/

CREATE     Procedure [prcLessonSession_StartLesson]
(
@lessonSessionID varchar(50) -- ToolBook Session ID - GUID
)

As
Set NoCount On
Set Xact_Abort On



------------------------------------------
-- Declerations
------------------------------------------
Declare @bitReturnValue bit -- Return Value

------------------------------------------
-- Check that the lesson has not already been started
-- if it has - return false
-- if it has not, start it and return true
-- Start the lesson ( insert a start date )
------------------------------------------
if exists (select LessonSessionID from tblLessonSession where LessonSessionID=@LessonSessionID and DateTimeStarted is null)
Begin -- it is ok to start, record start and return true
--< do update >--
Update
tblLessonSession
Set
[DateTimeStarted] = GETUTCDATE()
Where
[LessonSessionID] = @LessonSessionID
--< set return value >--
Set @bitReturnValue = 1
End
Else
Begin  -- it is NOT ok to start, return false
--< set return value >--
Set @bitReturnValue = 0
End


------------------------------------------
-- select SessionID
------------------------------------------

Select @bitReturnValue as ''OKToStart''
' 
END
GO
