SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcGetEmailThroughput]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [prcGetEmailThroughput]
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

SELECT o.OrganisationName AS OrganisationName, dbo.udfGetEmailsinHour(o.OrganisationName) AS "Emails delivered in last hour", dbo.udfGetEmailsinDay(o.OrganisationName) AS "Emails delivered in last day", dbo.udfGetPercentExpectedEmails(o.OrganisationName) AS "Percent of Expected Emails"
FROM tblEmail e JOIN tblOrganisation o ON e.OrganisationID = o.OrganisationID
GROUP BY OrganisationName
ORDER BY "Percent of Expected Emails" DESC
END' 
END
GO
