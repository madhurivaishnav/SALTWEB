SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUnit_GetUsers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:
Gets a list of users from a specific Unit

Called By: Unit.cs
Calls: None

Remarks: Raises an error if the parameter is null

Author: Jack Liu
Date Created: 10th of February 2004

prcUnit_GetOne 5

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE  Procedure [prcUnit_GetUsers]
(
@unitID Integer = null,
@includeInactiveUsers bit = 0
)

As

If @unitID Is Null
Begin
Raiserror(''The Parameter @unitID was null.  @unitID does not accept Null values.'', 16, 1)
Return
End
if (@includeInactiveUsers = 0)
Begin
Select 	UserID,
UserName,
FirstName,
LastName,
Email,
Active
From tblUser
Where UnitID = @unitID
And
Active = 1
order by LastName
End
Else
Begin
Select 	UserID,
UserName,
FirstName,
LastName,
Email,
Active
From tblUser
Where UnitID = @unitID

order by LastName
End
' 
END
GO
