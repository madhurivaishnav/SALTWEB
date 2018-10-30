SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcRequiresEffectiveDate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra Jagtap
-- Create date: 9/11/2011
-- Description:	Checks if report type requires effective date in order to decide whether the parent page of periodic control has to disable effective date
-- =============================================
CREATE PROCEDURE [prcRequiresEffectiveDate] 
	-- Add the parameters for the stored procedure here
	@ReportId int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT RequiresParamEffectiveDate FROM tblReportInterface
		WHERE ReportID=@ReportId	
 
END
' 
END
GO
