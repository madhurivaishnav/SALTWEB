SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisation_SaveCourseAccess]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:
Saves the course access settings for an organisation.

Called By:
Organisation.cs

Calls:
None

Remarks:
None

Author: Peter Vranich
Date Created: 19th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

Test:
Exec prcOrganisation_SaveCourseAccess 1, ''1, 3''
*/

CREATE Procedure [prcOrganisation_SaveCourseAccess]
(
@organisationID Integer,
@grantedCourseIDs VarChar(1000)
)

As

Set NoCount On
Set Xact_Abort On

Begin Transaction

-- Remove the existing settings
Delete From tblOrganisationCourseAccess
Where
OrganisationID = @organisationID

-- Insert the new settings
Insert Into tblOrganisationCourseAccess
(
OrganisationID,
GrantedCourseID
)
Select
@organisationID,
gc.IntValue
From dbo.udfCsvToInt(@grantedCourseIDs) As gc

Commit Transaction

' 
END
GO
