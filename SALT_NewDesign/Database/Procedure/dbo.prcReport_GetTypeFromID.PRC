SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_GetTypeFromID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra Jagtap
-- Create date: 10/11/2011
-- Description:	Gets report type name from report id
-- =============================================
CREATE PROCEDURE [prcReport_GetTypeFromID] 
	-- Add the parameters for the stored procedure here
	@ReportId int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ReportName FROM tblReportInterface
		WHERE ReportID = @ReportId
END
' 
END
GO
