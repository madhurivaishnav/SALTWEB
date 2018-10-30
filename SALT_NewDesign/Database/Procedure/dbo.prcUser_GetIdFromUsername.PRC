SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_GetIdFromUsername]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra Jagtap
-- Create date: 14/11/2011
-- Description:	Gets UserId from Username
-- =============================================
CREATE PROCEDURE [prcUser_GetIdFromUsername] 
	-- Add the parameters for the stored procedure here
	@Username nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT UserID FROM tblUser WHERE  UserName = @Username
END
' 
END
GO
