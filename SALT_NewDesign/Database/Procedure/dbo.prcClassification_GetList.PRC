SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcClassification_GetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*
Summary:
Gets a list of Classifications for the specified classification type.

Parameters:
OrganisationID

Returns:
ClassificationID
ClassificationTypeID
Value
Active

Called By:
Classification.cs

Calls:
None

Remarks:
None

Author: John Crawford
Date Created: 17th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE     Procedure [prcClassification_GetList]
(
@classificationTypeID Integer = Null -- ID of the classification type that you wish to get the classification list for.
)

As

Set NoCount On

Select
ClassificationID,
ClassificationTypeID,
Value,
Active
From
tblClassification
Where
((ClassificationTypeID = @classificationTypeID)
And (Active = 1))
Order By
Value Asc




' 
END
GO
