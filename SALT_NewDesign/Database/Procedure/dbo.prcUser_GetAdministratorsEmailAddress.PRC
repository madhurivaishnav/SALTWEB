SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_GetAdministratorsEmailAddress]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra Jagtap
-- Create date: 01/07/2011
-- Description:	Gets nearest admin for user
-- =============================================
CREATE PROCEDURE [prcUser_GetAdministratorsEmailAddress]
@UserId int
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

-- Insert statements for procedure here
SELECT dbo.udfUser_GetAdministratorsEmailAddress(@UserId)
END
' 
END
GO
