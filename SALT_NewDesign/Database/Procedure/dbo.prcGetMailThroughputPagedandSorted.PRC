SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcGetMailThroughputPagedandSorted]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra Jagtap
-- Create date: 21/06/2011
-- Description:	Custom paging and sorting of mail throughput
-- =============================================
CREATE PROCEDURE [prcGetMailThroughputPagedandSorted]
@sortExpression nvarchar(100),
@startRowIndex int,
@maximumRows int
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

IF LEN(@sortExpression) = 0
SET @sortExpression = ''Percent of Expected Emails''

SELECT ''OrganisationName'', ''Emails delivered in last hour'', ''Emails delivered in last day'', ''Percent of Expected Emails''
FROM (SELECT o.OrganisationName AS OrganisationName, dbo.udfGetEmailsinHour(o.OrganisationName) AS "Emails delivered in last hour", dbo.udfGetEmailsinDay(o.OrganisationName) AS "Emails delivered in last day", dbo.udfGetPercentExpectedEmails(o.OrganisationName) AS "Percent of Expected Emails",
ROW_NUMBER() OVER (ORDER BY @sortExpression) AS RowRank
FROM tblEmail AS e INNER JOIN tblOrganisation AS o ON e.OrganisationID = o.OrganisationID) AS MailWithRowNumbers
WHERE ''RowRank'' > CONVERT(nvarchar(10), @startRowIndex)
AND ''RowRank'' <= (CONVERT(nvarchar(10), @startRowIndex) + CONVERT(nvarchar(10), @maximumRows))
END
' 
END
GO
