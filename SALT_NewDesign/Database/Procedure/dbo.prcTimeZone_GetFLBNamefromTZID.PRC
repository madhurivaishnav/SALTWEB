SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcTimeZone_GetFLBNamefromTZID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra
-- Create date: 29/06/2011
-- Description:	Gets the FLB Name of timezone from id
-- =============================================
CREATE PROCEDURE [prcTimeZone_GetFLBNamefromTZID]
@TimezoneID int
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

SELECT FLB_Name FROM tblTimeZone WHERE TimeZoneID=@TimezoneID

END
' 
END
GO
