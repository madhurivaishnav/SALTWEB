SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_GetSALTAdministrators]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'






/*Summary:
Gets a list of all SALT Administrators.  Restrict to those with
the specified Active status if specified.

Parameters:
@active Bit

Returns:
Nothing

Called By:
User.cs.

Calls:
Nothing

Remarks:

Author: Gavin Buddis
Date Created: 23rd March 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

**/
CREATE   Procedure [prcUser_GetSALTAdministrators]
(
@requestedByUserID Integer = Null, -- User ID of the currently logged in user
@OrgID int
)

As

Set NoCount On

Select
UserID,
Username,
FirstName,
case
When Active = 0 Then LastName + '' (I)''
Else LastName
End As LastName,
Email,
Active,
CreatedBy,
dbo.udfUTCtoDaylightSavingTime(DateCreated, @OrgID),
UpdatedBy,
dbo.udfUTCtoDaylightSavingTime(DateUpdated, @OrgID)
From
tblUser
Where
(UserID <> @requestedByUserID)
And (UserTypeID = 1)



' 
END
GO
