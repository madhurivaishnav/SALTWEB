SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcGetCCList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra Jagtap
-- Create date: 26/10/2011
-- Description:	Gets the list of cc users for a periodic report
-- =============================================
CREATE PROCEDURE [prcGetCCList] 
(
	@ScheduleId int
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT u.UserID, u.Username FROM tblCCList cc
		JOIN tblUser u ON cc.UserId = u.UserID
		WHERE cc.ScheduleId = @ScheduleId
END' 
END
GO
