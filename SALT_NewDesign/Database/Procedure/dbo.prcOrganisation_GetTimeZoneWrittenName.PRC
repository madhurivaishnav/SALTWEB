SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisation_GetTimeZoneWrittenName]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


Create Procedure [prcOrganisation_GetTimeZoneWrittenName]
(
@OrgID int 		-- Organisation ID
)

As

Set NoCount On

-- Declarations
Declare @userID Integer

-- Validation
If (@OrgID Is Null)
Begin
Raiserror(''The Parameter @OrgID was null.  @OrgID does not accept Null values.'', 16, 1)
Return
End

-- Logic

Select
WrittenName
From
tblOrganisation ORG
inner join tblTimeZone TZ on ORG.TimeZoneID = TZ.TimeZoneID

WHERE ORG.OrganisationID = @OrgID


' 
END
GO
