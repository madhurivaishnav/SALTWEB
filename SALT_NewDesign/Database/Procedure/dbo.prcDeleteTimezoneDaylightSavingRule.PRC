SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcDeleteTimezoneDaylightSavingRule]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra Jagtap
-- Create date: 18/06/2011
-- Description:	Deletes Daylight saving rule for timezone
-- =============================================
CREATE PROCEDURE [prcDeleteTimezoneDaylightSavingRule]
@TimezoneId int,
@RuleID int
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

DELETE FROM tblTimeZoneDaylightSavingRules
WHERE TimezoneID=@TimezoneId AND TimezoneRuleID=@RuleID
END
' 
END
GO
