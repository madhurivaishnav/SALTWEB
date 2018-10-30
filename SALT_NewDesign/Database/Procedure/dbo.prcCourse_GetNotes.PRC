SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcCourse_GetNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


/*Summary:
Given a Course id return the Course notes
Returns:
Course Notes

Called By: Home.aspx via BusinessServices.Course.GetNotes
Calls: null

Remarks:


Author:
Stephen Kennedy-Clark
Date Created: 6 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

--------------------
prcCourse_GetNotes @courseID=11

**/

CREATE  Proc [prcCourse_GetNotes]
(
@courseID int -- Course ID
)
AS
------------------------------------------
Set Nocount On
Select
Notes
From
tblCourse
Where
CourseID = @courseID





' 
END
GO
