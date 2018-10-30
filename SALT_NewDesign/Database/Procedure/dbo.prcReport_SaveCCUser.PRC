SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_SaveCCUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra Jagtap
-- Create date: 6/12/2011
-- Description:	Saves the CC users for periodic report
-- =============================================
CREATE PROCEDURE [prcReport_SaveCCUser] 
	-- Add the parameters for the stored procedure here
	@ScheduleId int = 0, 
	@UserId int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF NOT EXISTS (SELECT * FROM tblCCList WHERE ScheduleId = @ScheduleId AND UserID = @UserId)
	BEGIN
INSERT INTO tblCCList (UserID,ScheduleID) VALUES (@UserId, @ScheduleId)
	END

END
' 
END
GO
