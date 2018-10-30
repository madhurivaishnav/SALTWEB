SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_GetCPDReportName]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE   Procedure [prcReport_GetCPDReportName]
(
@OrgID int
)

As

select CPDReportName from tblorganisation where OrganisationID= @OrgID
' 
END
GO
