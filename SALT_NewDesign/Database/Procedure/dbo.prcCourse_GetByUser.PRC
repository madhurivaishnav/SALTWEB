SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcCourse_GetByUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


/*Summary:
Given a user id returns the list of Active courses a user has access to
If the User id is ommited it returns all the courses
Returns:
Course ID

Called By: Home.aspx
Calls:

Remarks:


Author:
Stephen Kennedy-Clark
Date Created: 6 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1



--------------------
prcCourse_GetByUser @userID=11

**/

CREATE  Proc [prcCourse_GetByUser]
(
@userID int = Null
)
AS
------------------------------------------
Set Nocount On
Select Distinct
CourseID
, Name
From
tblCourse tC
inner join tblOrganisationCourseAccess tOCA
on tC.CourseID = tOCA.GrantedCourseID
inner join tblUser tU
on tU.OrganisationID = tOCA.OrganisationID
Where
tC.Active = 1
and tU.UserID = isnull(@userID, tU.UserID)
Order By
tC.CourseID




' 
END
GO
