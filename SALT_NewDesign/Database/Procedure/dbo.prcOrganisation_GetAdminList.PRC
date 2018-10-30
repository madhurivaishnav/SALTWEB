SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisation_GetAdminList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


/*Summary:
Gets a List of all the Administrators for a particular organisation.

Parameters:
@organisationID

Returns:
Nothing

Called By:
Organisation.cs.

Calls:
Nothing

Remarks:
None

Author: Peter Vranich
Date Created: 12th February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

**/
CREATE   Procedure [prcOrganisation_GetAdminList]
(
@organisationID Integer = Null -- ID of the Organisation that you wish to get the Admins for.
)

As

Select
UserID,
FirstName,
LastName,
Email,
OrganisationID,
CreatedBy,
dbo.udfUTCtoDaylightSavingTime(DateCreated, @organisationID) as DateCreated,
UpdatedBy,
dbo.udfUTCtoDaylightSavingTime(DateUpdated, @organisationID) as DateUpdated
From
tblUser
Where
((OrganisationID = @organisationID)
And (UserTypeID = 2)
And (Active = 1))
' 
END
GO
