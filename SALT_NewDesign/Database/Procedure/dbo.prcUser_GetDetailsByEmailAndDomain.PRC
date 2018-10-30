SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_GetDetailsByEmailAndDomain]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
Summary: Gets the details of one User by their email address
Parameters: @emailAddress varchar(100)
Returns: UserID, FirstName, LastName, UserName, Password, Email, ExternalID, OrganisationID, UnitID, UserTypeID, Active, CreatedBy, DateCreated, UpdatedBy, DateUpdated

Called By: User.cs
Calls: None

Remarks: Raises an error if the parameter is null

Author: Gavin Buddis
Date Created: 10th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE Procedure [prcUser_GetDetailsByEmailAndDomain]
(
@emailAddress varchar(100) = null, -- Email Address
@DomainName varchar(100)
)

As
Set NoCount On

If @emailAddress Is Null
Begin
Raiserror(''The Parameter @emailAddress was null.  @emailAddress does not accept Null values.'', 16, 1)
Return
End

Select TOP (1)
UserID,
FirstName,
LastName,
UserName,
Password,
Email,
ExternalID,
tblUSer.OrganisationID,
UnitID,
UserTypeID,
Active,
tblUser.CreatedBy,
dbo.udfUTCtoDaylightSavingTime(tblUser.DateCreated, tblOrganisation.OrganisationID),
tblUser.UpdatedBy,
dbo.udfUTCtoDaylightSavingTime(tblUser.DateUpdated, tblOrganisation.OrganisationID)
From
tblUser
INNER JOIN tblOrganisation ON tblOrganisation.OrganisationID = tblUser.OrganisationID
Where
Email = @emailAddress
AND DomainName like @DomainName+''%''
AND tblUser.Active = 1
' 
END
GO
