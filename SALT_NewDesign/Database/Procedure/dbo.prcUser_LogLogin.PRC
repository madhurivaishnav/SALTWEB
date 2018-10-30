SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_LogLogin]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Logs the fact that a user has successfully logged in.
Returns:
nothing

Called By: Login.ascx
Calls:

Remarks:

Author:
Peter Kneale
Date Created: 17 Jan 2005

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	Jack Liu	14/09/2005		Change the UserName parameter to UserID, the user name is not unique after add domain name


prcUser_LogLogin ''Jack''
**/

CREATE  PROC [prcUser_LogLogin]
(
@userID  int
)

AS

set nocount on

Update
tblUser
Set
LastLogin = GETUTCDATE()
where
userID=@userID

' 
END
GO
