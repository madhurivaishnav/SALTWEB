SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcClassification_GetType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


/*
Summary: Gets a list of Classification Types for an Organisation
Parameters: OrganisationID
Returns: ClassificationTypeID, OrganisationID, Name

Called By: Classification.cs
Calls: None

Remarks: None

Author: John Crawford
Date Created: 17th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE   Procedure [prcClassification_GetType]
(
@organisationID Integer = Null -- ID of the Organisation that you wish to get the Classifications For.
)

As

Set NoCount On

Select
ClassificationTypeID,
OrganisationID,
[Name]
From
tblClassificationType
Where
OrganisationID = @organisationID



' 
END
GO
