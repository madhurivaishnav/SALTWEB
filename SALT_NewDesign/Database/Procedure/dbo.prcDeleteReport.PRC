SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcDeleteReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra Jagtap
-- Create date: 2/11/2011
-- Description:	Deletes periodic report along with adding entry in audit table
-- =============================================
CREATE PROCEDURE [prcDeleteReport] 
	-- Add the parameters for the stored procedure here
	@ScheduleId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
    DELETE FROM tblReportSchedule WHERE ScheduleID=@ScheduleId
	
END
' 
END
GO
