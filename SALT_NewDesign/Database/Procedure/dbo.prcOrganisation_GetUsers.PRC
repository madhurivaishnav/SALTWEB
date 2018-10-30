SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisation_GetUsers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
Gets a list of all users that are not organisation administrators for the specified organisation.

Parameters:
@organisationID Integer
@firstName Varchar(50) = ''''
@lastname Varchar(50) = ''''

Returns:
Nothing

Called By:
Organisation.cs.

Calls:
Nothing

Remarks:

Author: Peter Vranich
Date Created: 17th February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

**/
CREATE    Procedure [prcOrganisation_GetUsers]
(
@organisationID Integer = Null, -- ID of the Organisation to get the users from.
@firstName nVarchar(50) = '''', -- First name of the user(s) to search for.
@lastname nVarchar(50) = '''' -- Last name of the user(s) to search for.
)

As

Set NoCount On

-- Declarations
Declare @intUserTypeOrgAdmin Integer -- Holds the value for the OrgAdmin UserTypeID from the tblUserType table.

-- Initialisation
Select @intUserTypeOrgAdmin = UserTypeID From tblUserType Where Type = ''Organisation Administrator''

If(@firstName Is Null)
Begin
Set @firstName = ''''
End

If(@lastName Is Null)
Begin
Set @lastName = ''''
End


Select
UserID,
FirstName,
LastName,
Email,
OrganisationID,
CreatedBy,
dbo.udfUTCtoDaylightSavingTime(DateCreated, OrganisationID) as DateCreated,
UpdatedBy,
dbo.udfUTCtoDaylightSavingTime(DateUpdated, OrganisationID) as DateUpdated
From
tblUser
Where
((OrganisationID = @organisationID)
And (FirstName Like ''%'' + @firstName + ''%'')
And (LastName Like ''%'' + @lastName + ''%'')
And (UserTypeID > @intUserTypeOrgAdmin)
And (UnitID Is Not Null)
And (Active = 1))
' 
END
GO
