SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcAutomatedEmails_OrganisationsToNotify]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE   Procedure [prcAutomatedEmails_OrganisationsToNotify]
AS
Set Nocount On



declare @OrgID	    int

SELECT @OrgID = cast(coalesce((SELECT top 1 OrganisationID
from tblOrganisation
WHERE DelinquenciesLastNotified < CourseStatusLastUpdated and dateadd(hh,0,CourseStatusLastUpdated )< dbo.udfUTCtoDaylightSavingTime(getutcdate(),OrganisationID)) ,-1) as varchar(50))

update tblOrganisation set DelinquenciesLastNotified = dbo.udfUTCtoDaylightSavingTime(getutcdate(),OrganisationID) where @OrgID = OrganisationID


select @OrgID
return @OrgID


' 
END
GO
