SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_GetUserIDBySessionID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Given a SessionID
return the users  UserID

Parameters
SessionID	Varchar (mandatory)

Returns:
scalar - int - user''s id

Called By:
TooolBookListener.aspx

Calls:
udfGetUserIDBySessionID

Remarks:


Author:
Peter Kneale
Date Created: 9 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


**/


CREATE Procedure [prcUser_GetUserIDBySessionID]
(
@SessionID varchar(50) 		-- Session ID of the user we are looking for.
)

As

Set NoCount On

-- Declarations
Declare @userID Integer

-- Validation
If (@SessionID Is Null)
Begin
Raiserror(''The Parameter @SessionID was null.  @SessionID does not accept Null values.'', 16, 1)
Return
End

-- Logic
Set @userID= dbo.udfGetUserIDBySessionID(@SessionID)

Select
@UserID as ''UserID''
' 
END
GO
