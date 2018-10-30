SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcLessonSession_EndLesson]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



/*Summary:
this proc records that a lesson has ended
it also:
-- Checks that the lesson has started -- if it has not - return false
-- Checks that the lesson has not already ended -- if it has - return false

Returns:
boolean (bit) OK true = 1, false = 0

Called By:
Businessservices.Toolbook.EndLessonSession
Calls:
dbo.udfGetUserIDBySessionID
dbo.udfGetLessonPageIDByToolbookPageID
dbo.udfGetLessonIDBySessionID
Remarks:

Author:
Stephen Kennedy-Clark
Date Created: 5 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
#2 Removed unnecessary transactions

-----------
prcLessonSession_EndLesson @LessonSessionID = ''4986F67F-FF29-4979-9A97-D7846839E0DB''
select * from tblLessonSession

**/

CREATE      Procedure  [prcLessonSession_EndLesson]
(
@lessonSessionID	varchar(50),		-- the lesson session id
@duration		int,			-- the duration
@bookmark		varchar(50)  = null 	-- the bookmark
)

As
Set NoCount On
Set Xact_Abort On


------------------------------------------
-- Declerations
------------------------------------------
Declare @bitReturnCalue  bit, -- Return Code
@intUserID 	 int, -- User ID
@intLessonPageID int, -- Lesson Page ID
@intlessonID 	 int  -- Lesson ID (PK on lesson table)

------------------------------------------
-- initations
------------------------------------------
set @intUserID 	   	= dbo.udfGetUserIDBySessionID(@lessonSessionID)
set @intlessonID	= dbo.udfGetLessonIDBySessionID(@lessonSessionID)

------------------------------------------
-- Checks that the lesson has started - if it has not -> return false
-- and
-- Checks that the lesson has not already ended - if it has -> return false
-- If all is OK then end the lessson by recording lesson end time and duration
-- and delete the old bookmark
-- and then set the bookmark (if one was given)
------------------------------------------
If Exists
(
Select
LessonSessionID
From
tblLessonSession
Where
LessonSessionID=@LessonSessionID
--< Check that the lesson has started >--
And DateTimeStarted Is Not Null
--< Check that the lesson has not already ended >--
And DateTimeCompleted Is Null
)


Begin --< it is ok to End, record End and return true >--
Update
[tblLessonSession]
Set
[DateTimeCompleted]= GETUTCDATE(),
[Duration]         = @duration
Where
[LessonSessionID]  = @lessonSessionID
------------------------------------------

--< delete the existing bookmark for this user for this lesson >--
delete tblBookmark
From
tblBookmark tBM
Inner Join tblLessonPage tLP
On tLP.LessonPageID = tBM.LessonPageID
Where
tLP.LessonID = @intlessonID
And tBM.UserID = @intUserID
------------------------------------------

--< create a new bookmark for this user for this lesson >--
if len(@bookmark) != 0 or @bookmark is not null
begin
set @intLessonPageID = dbo.udfGetLessonPageIDByToolbookPageID(@bookmark, @intlessonID)
Insert Into
tblBookmark
(
[LessonPageID]
, [UserID]
, [DateCreated]
)
Values
(
@intLessonPageID
, @intUserID
, GETUTCDATE()
)
end
------------------------------------------
set @bitReturnCalue = 1 --< return 1 indicates sucess >--


End
Else
Begin  -- it is NOT ok to End, return false
set @bitReturnCalue = 0
End


------------------------------------------
-- return
------------------------------------------

Select @bitReturnCalue as ''OKToEnd''




' 
END
GO
