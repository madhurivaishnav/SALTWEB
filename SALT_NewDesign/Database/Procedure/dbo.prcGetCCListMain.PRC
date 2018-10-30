SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcGetCCListMain]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra Jagtap
-- Create date: 4/11/2011
-- Description:	Get the CC List on the Periodic report main page
-- =============================================
CREATE PROCEDURE [prcGetCCListMain] 
	-- Add the parameters for the stored procedure here
	@ScheduleId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT u.UserID, FirstName, LastName, Email FROM tblCCList cc 
    JOIN tblUser u ON u.UserID = cc.UserID
    WHERE cc.ScheduleId = @ScheduleId
END' 
END
GO
