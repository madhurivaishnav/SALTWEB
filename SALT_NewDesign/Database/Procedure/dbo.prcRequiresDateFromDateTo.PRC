SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcRequiresDateFromDateTo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra Jagtap
-- Create date: 9/11/2011
-- Description:	checks if report contains datefrom and dateto controls to disable when more than once control is selected for periodic report
-- =============================================
CREATE PROCEDURE [prcRequiresDateFromDateTo] 
	-- Add the parameters for the stored procedure here
	@ReportId int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT RequiresParamDateFrom & RequiresParamDateTo FROM tblReportInterface WHERE ReportID=@ReportId
     
END
' 
END
GO
