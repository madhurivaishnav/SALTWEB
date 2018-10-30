SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcGetTimezoneDaylightRules]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra Jagtap
-- Create date: 18/06/2011
-- Description:	Gets daylight saving rules for timezone and start year
-- =============================================
CREATE PROCEDURE [prcGetTimezoneDaylightRules]
@TimezoneId int,
@RuleID int
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

SELECT tz.WrittenName AS WrittenName, tzd.start_year AS StartYear, tzd.end_year AS EndYear, tzd.offset_mins AS Offset,
tzd.hours_start AS TimeStart, tzd.day_start AS WeekdayStart, tzd.week_start AS WeekStart, tzd.month_start AS MonthStart,
tzd.hours_end AS TimeEnd, tzd.day_end AS WeekdayEnd, tzd.week_end AS WeekEnd, tzd.month_end AS MonthEnd
FROM tblTimeZoneDaylightSavingRules tzd JOIN tblTimeZone tz ON tzd.TimezoneID = tz.TimeZoneID
WHERE tzd.TimezoneID=@TimezoneId AND tzd.TimezoneRuleID=@RuleID

END
' 
END
GO
