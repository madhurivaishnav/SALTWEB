SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_GetIdFromEmail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra Jagtap
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [prcUser_GetIdFromEmail] 
	-- Add the parameters for the stored procedure here
	@Email nvarchar(100) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT UserID FROM tblUser WHERE Email = @Email
END
' 
END
GO
