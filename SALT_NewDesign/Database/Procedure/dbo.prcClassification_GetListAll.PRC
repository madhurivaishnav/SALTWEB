SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcClassification_GetListAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:
Gets a list of all classifications for the specified classification type.

Parameters:
@classificationTypeID Integer

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

Author: Peter Vranich
Date Created: 19th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE Procedure [prcClassification_GetListAll]
(
@classificationTypeID Integer = Null -- ID of the Classification Type that you wish to get the Classification List For.
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
(ClassificationTypeID = @classificationTypeID)


' 
END
GO
