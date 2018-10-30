SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcLink_GetListByOrganisation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary: Gets a List of Links per Organisation
Parameters:
@organisationID Integer ID of the Organisatyion to return the Links for.
Returns:

Called By:
Links.cs
Calls:

Remarks:

Author: Peter Vranich
Date Created: 10th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE Procedure [prcLink_GetListByOrganisation]
(
@organisationID Integer = Null -- ID of the Organisation to return the Links for.
)

As

Set Nocount On

If(@organisationID Is Null)
Begin
Raiserror(''The @organisationID parameter was Null.  You must supply a value.'', 16, 1)
Return
End

Select
LinkID,
OrganisationID,
Caption,
Url,
ShowDisclaimer,
CreatedBy,
dbo.udfUTCtoDaylightSavingTime(DateCreated, @organisationID),
UpdatedBy,
dbo.udfUTCtoDaylightSavingTime(DateUpdated, @organisationID),
LinkOrder
From
tblLink
Where
(OrganisationID = @organisationID)
Order by
LinkOrder, Caption
' 
END
GO
