SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisation_GetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary: Gets a list of all Organisation
Parameters: None
Returns: OrganisationID, OrganisationName,  Logo, Notes, DefaultLessonFrequency, DefaultQuizFrequency, DefaultQuizPassMark, CreatedBy, DateCreated,  UpdatedBy, DateUpdated

Called By: Header.ascx
Calls: None

Remarks: None

Author: Peter Vranich
Date Created: 28th of January 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE Procedure [prcOrganisation_GetList]

As

Select
OrganisationID,
OrganisationName,
Logo,
Notes,
DefaultLessonFrequency,
DefaultQuizFrequency,
DefaultQuizPassMark,
dbo.udfUTCtoDaylightSavingTime(DefaultLessonCompletionDate, OrganisationID),
dbo.udfUTCtoDaylightSavingTime(DefaultQuizCompletionDate, OrganisationID),
DomainName,
CreatedBy,
dbo.udfUTCtoDaylightSavingTime(DateCreated, OrganisationID),
UpdatedBy,
dbo.udfUTCtoDaylightSavingTime(DateUpdated, OrganisationID)
From
tblOrganisation
order by OrganisationName


' 
END
GO
