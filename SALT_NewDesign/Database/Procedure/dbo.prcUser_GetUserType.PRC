SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_GetUserType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary: Get user type

Role (UserType) Change

A Role change occurs when an administrator''s type changes.
This type of checking should occur at every user initiated event within the system
so that new permissions are enforced as soon as they are applied.
If a Role Change is detected, the administrator should be automatically logged out of the system
and redirected to the login page.

It is used by global.asax, all requests will be checked with data

Returns:  User type

Called By: User.cs
Calls: None

Remarks: Raises an error if the parameter is null

Author: Jack Liu
Date Created: 18th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE Procedure [prcUser_GetUserType]
(
@userID Integer, -- User ID
@userTypeID integer=null output -- User type
)

As
Set NoCount On


Select @userTypeID = UserTypeID
From	tblUser
Where	UserID = @userID


' 
END
GO
