SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcTimeZone_GetTZIDfromFLBName]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra
-- Create date: 27/06/2011
-- Description:	Gets the timezone id from its display name
-- =============================================
CREATE PROCEDURE [prcTimeZone_GetTZIDfromFLBName]
@FLBName nvarchar(240)
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

SELECT TimeZoneID FROM tblTimeZone WHERE FLB_Name LIKE ''%'' + @FLBName + ''%''

END
' 
END
GO
