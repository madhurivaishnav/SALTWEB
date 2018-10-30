SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcTimeZoneRule_add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcTimeZoneRule_add]
(
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

DECLARE @TimezoneID int
DECLARE @Period_start datetime, @Period_end datetime
exec prcTimeZone_GetTimeZoneID @WrittenName, @TimezoneID out
IF (@year_start < 1970) set @year_start = 1970  -- UNIX EPOCH
IF (@year_end > 2999) set @year_end = 2999		-- Y3K BUG?



-- the first_start_date and last_end_date may cover a period of decades so we now have to decide if the rule is applied at the datetime given
-- so calculate the exact start and end dates and times for the relevant daylight saving period (in the year being considered)


-- start with a period (@Period_start datetime, @period_end datetime) that just has the correct year digits


--if  (@startmonth > @endmonth) set @year_start = @year_start - 1   -- rule spans december 31 so adjust

IF(@startmonth > @endmonth)  set @year_end = @year_end + 1  -- rule spans december 31 so adjust






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
AND TimezoneID = @TimezoneID

IF (@Existing <> 0)
BEGIN
SET @Error = 1
END
ELSE
BEGIN
INSERT INTO tblTimeZoneDaylightSavingRules
([TimezoneID]
,[offset_mins]
,[start_year]
,[end_year]
,[hours_start]
,[day_start]
,[week_start]
,[month_start]
,[hours_end]
,[day_end]
,[week_end]
,[month_end]
,[first_start_date]
,[last_end_date]
)
VALUES
(@TimezoneID,
@OffsetDaylight,
@year_start,
@year_end,
@StartTimeOfDay,
@day_start,
@week_start ,
@StartMonth ,
@EndTimeOfDay ,
@EndDayOfWeek ,
@EndWeek ,
@EndMonth,
@Period_start,
@Period_end
)
SET @Error = 0
END

SELECT @Error

END
' 
END
GO
