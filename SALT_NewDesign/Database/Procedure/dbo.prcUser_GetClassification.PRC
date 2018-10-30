SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_GetClassification]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



/*
Summary: Gets a list of Classification Types for an Organisation
Parameters: OrganisationID
Returns: ClassificationID, ClassificationTypeID, Value, Active

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

CREATE Procedure [prcUser_GetClassification]
(
@userID Integer = Null -- ID of the Classification Type that you wish to get the Classification List For.
)

As

Select
UserID,
ClassificationID
From
tblUserClassification
Where
UserID = @UserID



' 
END
GO
