SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_GetNameBySessionID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'





/*Summary:
Given a SessionID
returns the users name (Firstname + " " + LastName) as Name
Returns:
scalar - string - user''s name

Called By:
TooolBooLlistner.aspx via Businessservices.Toolbook.GetUser
Calls:

Remarks:


Author:
Stephen Kennedy-Clark
Date Created: 4 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


--------------------


**/


CREATE   PROC [prcUser_GetNameBySessionID]
(
@SessionID varchar(50) -- Toolbook session ID - A GUID
)

AS

SET NOCOUNT ON

------------------------------------------
-- Declerations
------------------------------------------
Declare @userID int

------------------------------------------
-- get @userID from @lessonSessionID
------------------------------------------
SET @userID= dbo.udfGetUserIDBySessionID(@SessionID)

------------------------------------------
-- Return Scalar
------------------------------------------

SELECT top 1
[FirstName] + '' '' + [LastName] as ''Name''
FROM
tblUser
WHERE
UserID = @userID

return




' 
END
GO
