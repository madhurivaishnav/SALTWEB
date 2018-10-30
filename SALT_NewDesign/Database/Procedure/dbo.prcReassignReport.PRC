SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReassignReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra Jagtap
-- Create date: 31/10/2011
-- Description:	Reassigns the owner of the periodic report
-- =============================================
CREATE PROCEDURE [prcReassignReport] 
(
	-- Add the parameters for the stored procedure here
	@ScheduleId int,
	@UserId int
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE tblReportSchedule SET UserID=@UserId
		WHERE ScheduleID=@ScheduleId
END
' 
END
GO
