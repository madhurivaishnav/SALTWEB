SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_GetUserForCC]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra Jagtap
-- Create date: 18/11/2011
-- Description:	Get the user fields required forr CC list pop up for periodic reports
-- =============================================
CREATE PROCEDURE [prcUser_GetUserForCC] 
	-- Add the parameters for the stored procedure here
	@UserID int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT UserID, FirstName, LastName, UserName, Email
	FROM tblUser WHERE UserID = @UserID
END
' 
END
GO
