SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcTimeZoneRule_update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra Jagtap
-- Create date: 18/06/2011
-- Description:	Updates the daylight saving rule for timeaone
-- =============================================
CREATE PROCEDURE [prcTimeZoneRule_update]
(
@RuleID int,
@WrittenName NVarChar(60),
@OffsetDaylight Int,
@year_start Int,
@year_end  Int,
@StartTimeOfDay Int,
@day_start Int,
@week_start Int,
@StartMonth Int,
@EndTimeOfDay Int,
@EndDayOfWeek Int,
@EndWeek Int,
@EndMonth Int,
@Error bit output
)
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

DECLARE @TimezoneID int
DECLARE @Period_start datetime, @Period_end datetime
exec prcTimeZone_GetTimeZoneID @WrittenName, @TimezoneID out
IF (@year_start < 1970) set @year_start = 1970  -- UNIX EPOCH
IF (@year_end > 2999) set @year_end = 2999		-- Y3K BUG?

-- Calculate the earlist start date and the last finish date
set @Period_start = ''1 jan 2000'' -- start with a known datetime
Set @Period_start = DATEADD(year,@year_start- 2000,@Period_start) -- then adjust it to match the definition
Set @Period_start = DATEADD(month,@StartMonth-1,@Period_start)
Set @Period_start = DATEADD(week,@week_start-1,@Period_start)
Declare @day_offset int
if (@day_start >=  DatePart(weekday,@Period_start) ) set @day_offset = @day_start -  DatePart(weekday,@Period_start) else  set @day_offset = @day_start -  DatePart(weekday,@Period_start) + 7
Set @Period_start = DATEADD(day,@day_offset,@Period_start)
-- We may have jumped to the next month if week = 5 so step back a week if necessary
if (DatePart(month,@Period_start) > @StartMonth) set @Period_start = DATEADD(week,-1,@Period_start)
SET @Period_start = DATEADD(minute, @StartTimeOfDay, @Period_start)

set @Period_end = ''1 jan 2000'' -- start with a known datetime
Set @Period_end = DATEADD(year,@year_end- 2000,@Period_end) -- then adjust it to match the definition
Set @Period_end = DATEADD(month,@EndMonth-1,@Period_end)
Set @Period_end = DATEADD(week,@EndWeek-1,@Period_end)
if (@EndDayOfWeek >=  DatePart(weekday,@Period_end) ) set @day_offset = @EndDayOfWeek -  DatePart(weekday,@Period_end) else  set @day_offset = @EndDayOfWeek -  DatePart(weekday,@Period_end) + 7
Set @Period_end = DATEADD(day,@day_offset,@Period_end)
-- We may have jumped to the next month if week = 5 so step back a week if necessary
if (DatePart(month,@Period_end) > @EndMonth) set @Period_end = DATEADD(week,-1,@Period_end)
SET @Period_end = DATEADD(minute, @EndTimeOfDay, @Period_end)

DECLARE @Existing int

SELECT @Existing = COUNT(*) FROM tblTimeZoneDaylightSavingRules
WHERE (first_start_date < @Period_end) AND (last_end_date > @Period_start)
AND TimezoneID = @TimezoneID AND TimezoneRuleID <> @RuleID

IF (@Existing <> 0)
BEGIN
SET @Error = 1
END
ELSE
BEGIN
UPDATE tblTimeZoneDaylightSavingRules SET
offset_mins=@OffsetDaylight
, start_year=@year_start
, end_year=@year_end
, hours_start=@StartTimeOfDay
, day_start=@day_start
, week_start=@week_start
, month_start=@StartMonth
, hours_end=@EndTimeOfDay
, day_end=@EndDayOfWeek
, week_end=@EndWeek
, month_end=@EndMonth
, first_start_date=@Period_start
, last_end_date=@Period_end
WHERE TimezoneID=@TimezoneID AND TimezoneRuleID=@RuleID

SET @Error = 0
END

SELECT @Error
END
' 
END
GO
