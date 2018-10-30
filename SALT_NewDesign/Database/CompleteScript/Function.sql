SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetSaltDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [GetSaltDate]
(

)
RETURNS DateTime
AS
BEGIN

DECLARE @UTCDate datetime

SELECT @UTCDate = dbo.getUTCdate()


RETURN @UTCDate

END
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ToUTC]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [ToUTC]
(
@LocalTime DateTime
)
RETURNS DateTime
AS
BEGIN
IF (@LocalTime is null) RETURN null

DECLARE @DSTTime datetime
DECLARE @UTC_Offset int
DECLARE @Timezone datetime
DECLARE @offset_mins int, @hours_start int, @day_start int, @week_start int, @month_start int, @hours_end int, @day_end int, @week_end int, @month_end int, @year_end int , @year_start int
SELECT @UTC_Offset = TZ.OffsetUTC , @Timezone = TZ.TimezoneID
FROM tblTimeZone TZ
INNER JOIN tblAppConfig App ON  App.Value=TZ.WrittenName
--WHERE TZ.TimeZoneID = Org.TimeZoneID
IF (@UTC_Offset IS NULL)
BEGIN
Set @DSTTime = ''1 Jan 1900'' --  create an "error" that will be apparent in Report
END
ELSE
BEGIN
Set @DSTTime = DATEADD(minute,-@UTC_Offset,@LocalTime )
SELECT  @offset_mins = offset_mins, --get definition of the (at most) 1 definition that may cover the datetime
@hours_start = hours_start, --overlapping definitions removed by GUI so only 1 result returned
@day_start = day_start,
@week_start = week_start,
@month_start = month_start,
@hours_end = hours_end,
@day_end = day_end,
@week_end = week_end,
@month_end = month_end
FROM tblTimeZoneDaylightSavingRules
WHERE  TimezoneID = @Timezone
AND @LocalTime >= first_start_date
AND @LocalTime <= last_end_date
Set @year_start = year(@LocalTime) --now calculate the exact start and end dates and times for the year under consideration

DECLARE @Period_start datetime, @period_end datetime
Set @year_start = year(@LocalTime)
set @year_end = year(@LocalTime)

if (month(@LocalTime) <= @month_end) and (@month_start > @month_end) set @year_start = @year_start - 1   -- rule spans december 31 so adjust

IF(@month_start > @month_end) and (month(@LocalTime) >= @month_start) set @year_end = @year_start + 1  -- rule spans december 31 so adjust

--IF(@month_start > @month_end) set @year_end = @year_start + 1 else set @year_end = @year_start
--DECLARE @Period_start datetime, @period_end datetime

set @Period_start = ''1 jan 2000'' -- start with a known datetime
set @year_start = @year_start - 2000
Set @Period_start = DATEADD(year,@year_start,@Period_start) -- then set the year correctly
-- Then move to the correct month
Set @Period_start = DATEADD(month,@month_start-1,@Period_start)
-- Then move to the correct week (let week 5 slide to the next month for now)
Set @Period_start = DATEADD(week,@week_start-1,@Period_start)
-- Now move FORWARD to the correct day (say) the 5th sunday of february
Declare @day_offset int
if (@day_start >=  DatePart(weekday,@Period_start) ) set @day_offset = @day_start -  DatePart(weekday,@Period_start) else  set @day_offset = @day_start -  DatePart(weekday,@Period_start) + 7
Set @Period_start = DATEADD(day,@day_offset,@Period_start)
-- We may have jumped to the next month if week = 5 so step back a week if necessary
if (DatePart(month,@Period_start) > @month_start) set @Period_start = DATEADD(week,-1,@Period_start)
Set @Period_start = DATEADD(minute,@hours_start,@Period_start)  ---TODO check if offset applied OK for 1 hour either side of daylight saving start and end

set @Period_end = ''1 jan 2000'' -- start with a known datetime
set @year_end = @year_end - 2000
Set @Period_end = DATEADD(year,@year_end,@Period_end) -- then adjust it to match the definition
Set @Period_end = DATEADD(month,@month_end-1,@Period_end)
Set @Period_end = DATEADD(week,@week_end-1,@Period_end)
if (@day_end >=  DatePart(weekday,@Period_end) ) set @day_offset = @day_end -  DatePart(weekday,@Period_end) else  set @day_offset = @day_end -  DatePart(weekday,@Period_end) + 7
Set @Period_end = DATEADD(day,@day_offset,@Period_end)
-- We may have jumped to the next month if week = 5 so step back a week if necessary
if (DatePart(month,@Period_end) > @month_end) set @Period_end = DATEADD(week,-1,@Period_end)
Set @Period_end = DATEADD(minute,@hours_end,@Period_end)  ---TODO check if offset applied OK for 1 hour either side of daylight saving start and end
--Set @Period_end = DATEADD(minute,-@offset_mins,@Period_end) -- end time is quoted with daylight savings included


IF (@LocalTime >= @Period_start)
AND (@LocalTime < @Period_end) set @DSTTime = DATEADD(minute,-@offset_mins,@DSTTime)
END
RETURN @DSTTime
END
' 
END
GO


SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfCsvToInt]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfCsvToInt    Script Date: 20/04/2004 8:25:57 AM ******/


/*
Summary:
user Defined Function converts a comma seperated string into a table
Returns:
table
Called By:
dbo.prcOrganisation_SaveCourseAccess
dbo.prcReport_CurrentAdminSummary
dbo.prcReport_EmailReportToAdministrators
dbo.prcReport_EmailReportUserSearch
dbo.prcReport_HistoricPointAdminSummaryReport
dbo.prcReport_HistoricRangeAdminLessonSummaryReport
dbo.prcReport_HistoricRangeAdminQuizSummaryReport
dbo.prcReport_Trend
dbo.prcUnit_Search
dbo.prcUser_ClassificationUpdate
dbo.prcUser_GetEmailAddress
dbo.prcUser_SaveModuleAccess
dbo.prcUser_Search
dbo.udfReport_CompletUsers_logic
dbo.udfReport_HistoricAdminSummary
dbo.udfReport_IncompletUsers_logic
Calls:
null
Remarks:
bassed on several examples found at http://www.sqlteam.com/

Author:
Stephen Kennedy Clark
Date Created:
Monday 16 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

use:

select * from dbo.udfCsvToInt('''')
select * from dbo.udfCsvToInt('',,,,,1'')
select * from dbo.udfCsvToInt(''1,,,,,,'')
select * from dbo.udfCsvToInt(''1,,3,,34534534,,'')

**/

CREATE   Function [udfCsvToInt]
(
@commaSepperatedList varchar(MAX) = '''' -- Input string, comma seperated list of integers to be returned as a table
)
returns @tblIntTable table
(IntValue int)
AS
begin
if @commaSepperatedList <> ''''
begin
-- get rid of spaces
while CHARINDEX('' '' , @commaSepperatedList) <> 0
begin
set @commaSepperatedList = replace(@commaSepperatedList,'' '','''')
end

-- get rid of "null" values
while CHARINDEX('',,'' , @commaSepperatedList) <> 0
begin
set @commaSepperatedList = replace(@commaSepperatedList,'',,'','','')
end

set @commaSepperatedList = replace(@commaSepperatedList,'',,'','','')

-- get rid of leading and trailing commas
if @commaSepperatedList like('',%'')
begin
set @commaSepperatedList = right(@commaSepperatedList,len(@commaSepperatedList)-1)
end
if @commaSepperatedList like(''%,'')
begin
set @commaSepperatedList = left(@commaSepperatedList,len(@commaSepperatedList)-1)
end

declare @sep char(1)
set @sep = '',''

declare @intPos int
declare @strTemp varchar(500)

set @commaSepperatedList = @commaSepperatedList + '',''

while patindex(''%,%'' , @commaSepperatedList) <> 0
begin

select @intPos =  patindex(''%,%'' , @commaSepperatedList)
select @strTemp = left(@commaSepperatedList, @intPos - 1)

Insert @tblIntTable
Values (Cast(@strTemp as int))

select @commaSepperatedList = stuff(@commaSepperatedList, 1, @intPos, '''')
end
end
return
end
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfDaylightSavingTimeToUTC]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [udfDaylightSavingTimeToUTC]
(
@LocalTime DateTime,
@OrgID int
)
RETURNS DateTime
AS
BEGIN
-- trap error condition
IF (@LocalTime is null) RETURN null

DECLARE @OrgLocalTime datetime
DECLARE @UTC_Offset int
DECLARE @Timezone datetime
DECLARE @offset_mins int, @hours_start int, @day_start int, @week_start int, @month_start int, @hours_end int, @day_end int, @week_end int, @month_end int, @year_end int , @year_start int


SELECT @UTC_Offset = TZ.OffsetUTC , @Timezone = TZ.TimezoneID
FROM tblTimeZone TZ
INNER JOIN tblOrganisation Org ON TZ.TimeZoneID = Org.TimeZoneID
WHERE Org.OrganisationID = @OrgID
IF (@UTC_Offset IS NULL)
BEGIN
Set @OrgLocalTime = ''1 Jan 1900'' 	-- create an "error" that will be apparent in Report (The timezone does not exist so create an error that will draw attention to the problem)
END
ELSE
BEGIN
-- get the daylight saving rules of the (at most) 1 definition that may cover the datetime
--overlapping definitions are removed by the GUI so a maximum of 1 result can be returned
Set @OrgLocalTime = DATEADD(minute,-@UTC_Offset,@LocalTime )
SELECT  @offset_mins = offset_mins,
@hours_start = hours_start,
@day_start = day_start,
@week_start = week_start,
@month_start = month_start,
@hours_end = hours_end,
@day_end = day_end,
@week_end = week_end,
@month_end = month_end
FROM tblTimeZoneDaylightSavingRules
WHERE  TimezoneID = @Timezone
AND @LocalTime >= first_start_date
AND @LocalTime <= last_end_date

-- the first_start_date and last_end_date may cover a period of decades so we now have to decide if the rule is applied at the datetime given
-- so calculate the exact start and end dates and times for the relevant daylight saving period (in the year being considered)


-- start with a period (@Period_start datetime, @period_end datetime) that just has the correct year digits
DECLARE @Period_start datetime, @period_end datetime
Set @year_start = year(@LocalTime)
set @year_end = year(@LocalTime)

if (month(@LocalTime) <= @month_end) and (@month_start > @month_end) set @year_start = @year_start - 1   -- rule spans december 31 so adjust

IF(@month_start > @month_end) and (month(@LocalTime) >= @month_start) set @year_end = @year_start + 1  -- rule spans december 31 so adjust


set @Period_start = ''1 jan 2000''
set @year_start = @year_start - 2000
Set @Period_start = DATEADD(year,@year_start,@Period_start)
-- ok year digit ok (for @Period_start) so move on



-- Then set the month digit correctly
Set @Period_start = DATEADD(month,@month_start-1,@Period_start)


-- Then move to the correct week (let week 5 slide to the next month for now)
Set @Period_start = DATEADD(week,@week_start-1,@Period_start)

-- Now move FORWARD to the correct day (say) the 5th sunday of february
Declare @day_offset int
if (@day_start >=  DatePart(weekday,@Period_start) ) set @day_offset = @day_start -  DatePart(weekday,@Period_start) else  set @day_offset = @day_start -  DatePart(weekday,@Period_start) + 7
Set @Period_start = DATEADD(day,@day_offset,@Period_start)

-- now fix up the week = 5 rule - week=5 means "last week in the month" not "add 5 weeks"
-- (We may have jumped to the next month if week = 5 so step back a week if necessary)
if (DatePart(month,@Period_start) > @month_start) set @Period_start = DATEADD(week,-1,@Period_start)


-- now add the hours part of the rule - i.e. rule starts at 02:00
Set @Period_start = DATEADD(minute,@hours_start,@Period_start)  ---TODO check if offset applied OK for 1 hour either side of daylight saving start and end




-- we have calculated the start of the Daylight saving rule (to the hour) for the year in question
-- no do exactly the same for the end time of the daylight saving rule for the year in question:
set @Period_end = ''1 jan 2000''
set @year_end = @year_end - 2000
Set @Period_end = DATEADD(year,@year_end,@Period_end)
Set @Period_end = DATEADD(month,@month_end-1,@Period_end)
Set @Period_end = DATEADD(week,@week_end-1,@Period_end)
if (@day_end >=  DatePart(weekday,@Period_end) ) set @day_offset = @day_end -  DatePart(weekday,@Period_end) else  set @day_offset = @day_end -  DatePart(weekday,@Period_end) + 7
Set @Period_end = DATEADD(day,@day_offset,@Period_end)
-- We may have jumped to the next month if week = 5 so step back a week if necessary
if (DatePart(month,@Period_end) > @month_end)
BEGIN
set @Period_end = DATEADD(week,-1,@Period_end)
END
Set @Period_end = DATEADD(minute,@hours_end,@Period_end)  ---TODO check if offset applied OK for 1 hour either side of daylight saving start and end
--Set @Period_end = DATEADD(minute,-@offset_mins,@Period_end) -- end time is quoted with daylight savings included

-- now all we have to do is check if the rule applied to the timestamp in question
IF (@LocalTime >= @Period_start)
AND (@LocalTime < @Period_end)
BEGIN
-- it did so apply the daylight saving offset
set @OrgLocalTime = DATEADD(minute,-@offset_mins,@OrgLocalTime)
END

END
RETURN @OrgLocalTime
--RETURN @PERIOD_END

END
' 
END
GO


SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetActiveQuizIDByModuleID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfGetActiveQuizIDByModuleID    Script Date: 20/04/2004 8:25:57 AM ******/


/*
Summary:
user Defined Function that returns a quiz id based on the module id
Returns:
integer

Called By:
prcUser_GetQuizHistory
Calls:

Remarks:
None
Author:
Peter Kneale
Date Created: 3 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

*/

CREATE  Function [udfGetActiveQuizIDByModuleID]
(
@ModuleID Integer		-- Module ID from which we want the active quiz
)
Returns int

Begin

Declare @retVal int

set @retVal =
(
Select Top 1
QuizID
From
tblQuiz
Where
ModuleID = @moduleID
And
Active = 1
)

Return @retVal
End
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetCCList]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE  FUNCTION [udfGetCCList]
(
@ScheduleID int
)
RETURNS nvarchar(4000)
Begin

declare @CCList nvarchar(4000)
set @CCList = ''''

select @CCList=   @CCList  + CASE WHEN @CCList = '''' THEN '''' ELSE '','' END + tblUser.FirstName + '' '' + tblUser.LastName + '' <'' + tblUser.Email + ''>''
FROM tblCCList
INNER JOIN tblUser ON tblUser.UserID = tblCCList.UserID 
WHERE tblUser.Active = 1 
AND tblCCList.ScheduleID = @ScheduleID 


RETURN @CCList
End
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetEmailOnBehalfOf]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [udfGetEmailOnBehalfOf]
(
@OrgID int
)
RETURNS nvarchar(255)
AS
BEGIN
	DECLARE @OnBehalfOf nvarchar(255)
	SELECT @OnBehalfOf = [Value]
	  FROM tblAppConfig
	  WHERE [Name] = ''Email_OnBehalfOf''
RETURN @OnBehalfOf
END
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetEmailReplyTo]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [udfGetEmailReplyTo]
(
@OrgID int,
@Sender nvarchar(255)
)
RETURNS nvarchar(255)
AS
BEGIN
	DECLARE @OnBehalfOf nvarchar(255)
	SELECT @OnBehalfOf = ''''
RETURN @OnBehalfOf
END
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetEmailsinDay]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [udfGetEmailsinDay]
(
@OrgName nvarchar(50)
)
RETURNS int
AS
BEGIN
-- Declare the return variable here
DECLARE @EmailsinDay int

-- Add the T-SQL statements to compute the return value here
SET @EmailsinDay = (SELECT COUNT(OrganisationID) FROM dbo.tblEmail
WHERE OrganisationID = (SELECT OrganisationID FROM tblOrganisation WHERE OrganisationName = @OrgName) AND
DateCreated BETWEEN DATEADD(DAY, -1, GETUTCDATE()) AND GETUTCDATE())

-- Return the result of the function
RETURN @EmailsinDay

END
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetEmailsinHour]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra Jagtap
-- Create date: 14/06/2011
-- Description:	Gets emails delivered in last 1 hour
-- =============================================
CREATE FUNCTION [udfGetEmailsinHour]
(
@OrgName nvarchar(50)
)
RETURNS int
AS
BEGIN
-- Declare the return variable here
DECLARE @EmailsinHour int

-- Add the T-SQL statements to compute the return value here
SET @EmailsinHour = (SELECT COUNT(OrganisationID) FROM dbo.tblEmail
WHERE OrganisationID = (SELECT OrganisationID FROM tblOrganisation WHERE OrganisationName = @OrgName) AND
DateCreated BETWEEN DATEADD(hour, -1, GETUTCDATE()) AND GETUTCDATE())

-- Return the result of the function
RETURN @EmailsinHour

END
' 
END
GO


SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetLastCompletedDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfGetLastCompletedDate    Script Date: 24/07/2009 4:47 PM ******/


/*
Summary:		Calculates the date when the user last
completed the course, or ''Never'' (if status
is not incomplete or they have never
completed the course.

Returns:		varchar

Called By:		vwUserCourseStatus,
udfReport_HistoricViewCourseStatus

Author:			Mark Donald
Create date:	24/07/2009

Modification History
-----------------------------------------------------------
Author		Date			Description

*/

CREATE FUNCTION [udfGetLastCompletedDate]
(
@userCourseStatusID int,
@userID int,
@courseID int,
@courseStatusID int
)
RETURNS varchar(10)
AS
BEGIN

RETURN (SELECT
coalesce(convert(varchar(10), max(DateCreated), 103), ''Never'')
FROM
tblUserCourseStatus
WHERE
@courseStatusID = 1 --incompleted users only
AND UserID = @userID
AND CourseID = @courseID
AND CourseStatusID = 2
AND UserCourseStatusID < @userCourseStatusID)

END
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetLessonIDBySessionID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfGetLessonIDBySessionID    Script Date: 20/04/2004 8:25:57 AM ******/





/*
Summary:
user Defined Function that returns a lesson id given a Session id
only Works for a lesson
Returns:
scaler - lesson id - int

Called By:
dbo.prcBookMark_GetBookMarkBySessionID
dbo.prcLessonPageAudit_GetPagesVisited
dbo.prcLessonPageAudit_GetPagesVisitedBySessionID
dbo.prcLessonSession_EndLesson
dbo.prcLessonPageAudit_InsertPageVisited

Calls:

Remarks:


Author:
Stephen Kennedy-Clark
Date Created: 3 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


print dbo.udfGetLessonIDByToolbookID(''toolBookID-1'')
-- select * from tblLesson

**/
CREATE    FUNCTION [udfGetLessonIDBySessionID]
(
@sessionID varchar(50) -- The session ID - GUID
)
RETURNS INT --< UserID >--
Begin
------------------------------------------
-- get Lesson id for this Session
------------------------------------------

DECLARE @retVal int
set @retVal =
(
(
SELECT TOP 1
LessonID
FROM
tblLessonSession
WHERE
LessonSessionID = ltrim(rtrim(@sessionID))
)
)
RETURN @retVal
End
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetLessonIDByToolbookID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfGetLessonIDByToolbookID    Script Date: 20/04/2004 8:25:57 AM ******/



/*
Summary:
user Defined Function that returns a lesson id given a toolbook id
only Works for a lesson
Returns:
scaler - toolbook id - int

Called By:
dbo.prcLessonPageAudit_GetPagesVisited
Calls:

Remarks:


Author:
Stephen Kennedy-Clark
Date Created: 3 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


print dbo.udfGetLessonIDByToolbookID(''toolBookID-1'')
-- select * from tblLesson

**/
CREATE  FUNCTION [udfGetLessonIDByToolbookID]
(
@toolBookID varchar(50) -- Toolbook ID
)
RETURNS INT --< UserID >--
Begin
------------------------------------------
-- get Lesson id for this Toolbook
------------------------------------------

DECLARE @retVal int
set @retVal =
(
(
SELECT TOP 1
LessonID
FROM
tblLesson
WHERE
ToolbookID = ltrim(rtrim(@toolBookID))
and Active=1
)
)
RETURN @retVal
End
' 
END
GO


SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetLessonIDByToolbookIDAndModuleID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfGetLessonIDByToolbookIDAndModuleID    Script Date: 20/04/2004 8:25:57 AM ******/

/*
Summary:
user Defined Function that returns a lesson id given a toolbook id and a module id
only Works for a lesson
Returns:
scaler - toolbook id - int

Called By:

Calls:

Remarks:


Author:
Peter Kneale
Date Created: 19 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


print dbo.udfGetLessonIDByToolbookIDAndModuleID(''toolBookID-1'',5)
-- select * from tblLesson

**/
CREATE Function [udfGetLessonIDByToolbookIDAndModuleID]
(
@toolBookID 	Varchar(50), 		-- Toolbook Id of the Lesson
@moduleID 	Integer			-- ModuleId of the module the lessson belongs to.
)
Returns Int --< LessonID >--
Begin
-- get Lesson id for this Toolbook
Declare @retVal int
set @retVal =
(
(
Select Top 1
LessonID
From
tblLesson
Where
ToolbookID = ltrim(rtrim(@toolBookID))
And
ModuleID = @moduleID
And
Active=1
)
)
Return @retVal
End
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetLessonPageIDByToolbookPageID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfGetLessonPageIDByToolbookPageID    Script Date: 20/04/2004 8:25:57 AM ******/






/*
Summary:
user Defined Function that returns a Lesson Page ID given a Toolbook Page ID
only Works for a lesson
Returns:
scaler - Lesson Page id - int

Called By:
dbo.prcLessonPageAudit_InsertPageVisited
dbo.prcLessonSession_EndLesson
Calls:

Remarks:


Author:
Stephen Kennedy-Clark
Date Created: 3 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


print dbo.udfGetLessonIDByToolbookID(''toolBookID-1'')
-- select * from tblLessonPage

**/
CREATE     FUNCTION [udfGetLessonPageIDByToolbookPageID]
(
@toolBookPageID varchar(50) -- Tool Book Page ID
, @lessonID	integer	    -- The lesson id
)
RETURNS INT --< LessonPageID >--
Begin
------------------------------------------
-- get Lesson Page ID for this Toolbook Page ID
------------------------------------------

DECLARE @retVal int
set @retVal =
(
(
SELECT TOP 1
LessonPageID
FROM
tblLessonPage
WHERE
ToolbookPageID = @toolBookPageID
and lessonID = @lessonID
)
)

RETURN @retVal
End
' 
END
GO


SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetLessonStatus]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfGetLessonStatus    Script Date: 20/04/2004 8:25:57 AM ******/



/*
Summary:
user Defined Function that returns a sessionID given a module id and a userID
only the users Latest Status ID is returned
Returns:
integer

Called By: prcModule_GetDetailsForHomePage

Calls:

Remarks:


Author:	Stephen Kennedy Clark
Date Created: Fiday 13 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	GB		9/2/04			Coding standards

print dbo.udfGetLessonStatus(4,41)
select * from tblUserLessonStatus

Order by DateCreated desc
**/

CREATE   Function [udfGetLessonStatus]
(
@moduleID Integer -- the module to get the users status for
, @userID Integer -- the user id to get the status for
)
Returns Integer --< Lesson Status >-

Begin

Declare @intReturnValue Integer -- User Status

Set @intReturnValue =
(
Select Top 1
LessonstatusID
From
tblUserLessonStatus
Where
UserID = @userID
and ModuleID = @moduleID
Order by DateCreated desc
)

Return @intReturnValue

End
' 
END
GO


SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetModuleIDByLessonID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfGetModuleIDByLessonID    Script Date: 20/04/2004 8:25:57 AM ******/



/*
Summary:
user Defined Function that returns a module id given a toolbook id
only Works for a quiz
Returns:
scaler - module id - int

Called By:

Calls:

Remarks:


Author:
Peter Kneale, Stephen Kennedy-Clark
Date Created: 3 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


**/
CREATE  Function [udfGetModuleIDByLessonID]
(
@LessonID Integer -- the id of the lesson in question
)
Returns Integer --< UserID >--
Begin
-- Declarations
Declare @retVal Integer

-- get Quiz id for this Toolbook
set @retVal =
(
(
Select Top 1
ModuleID
From
tblLesson
Where
LessonID = @LessonID
)
)
Return @retVal
End
' 
END
GO


SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetModuleIDByQuizID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfGetModuleIDByQuizID    Script Date: 20/04/2004 8:25:57 AM ******/


/*
Summary:
user Defined Function that returns a module id given a toolbook (Quiz) id
Returns:
integer

Called By:

Calls:
Nothing

Remarks:
None

Author:
Peter Kneale, Stephen Kennedy-Clark
Date Created: 3 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	GB		9/2/04			Coding standards

*/

CREATE  Function [udfGetModuleIDByQuizID]
(
@QuizID Integer -- The id of the quiz (PK) in question
)
Returns Integer

Begin
-- Declarations
Declare @retVal Integer

-- Get ModuleID By Quiz ID
set @retVal =
(
Select Top 1
ModuleID
From
tblQuiz
Where
QuizID = @QuizID
)

Return @retVal
End
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetPercentExpectedEmails]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra Jagtap
-- Create date: 15/06/2011
-- Description:	Calculates the percentage of expected emails sent in the last day
--				The percentage is calculated on the average workload
--				(averaged over last 7 days)
-- =============================================
CREATE FUNCTION [udfGetPercentExpectedEmails]
(
@OrgName nvarchar(50)
)
RETURNS int
AS
BEGIN
-- Declare the return variable here
DECLARE @ExpectedEmails int
DECLARE @EmailsinLastDay int
DECLARE @EmailsinLast7days int

SET @EmailsinLastDay = (SELECT COUNT(OrganisationID) FROM dbo.tblEmail
WHERE OrganisationID = (SELECT OrganisationID FROM tblOrganisation WHERE OrganisationName = @OrgName) AND
DateCreated BETWEEN DATEADD(DAY, -1, GETUTCDATE()) AND GETUTCDATE())

SET @EmailsinLast7days = (SELECT COUNT(OrganisationID) FROM dbo.tblEmail
WHERE OrganisationID = (SELECT OrganisationID FROM tblOrganisation WHERE OrganisationName = @OrgName) AND
DateCreated BETWEEN DATEADD(DAY, -7, GETUTCDATE()) AND GETUTCDATE())

IF (@EmailsinLast7days <> 0)
BEGIN
SET @ExpectedEmails = ((@EmailsinLastDay * 7 * 100)/@EmailsinLast7days)
END
ELSE
SET @ExpectedEmails = 0

-- Return the result of the function
RETURN @ExpectedEmails

END
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetQuizAnswerIDByToolbookAnswerID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfGetQuizAnswerIDByToolbookAnswerID    Script Date: 20/04/2004 8:25:57 AM ******/


/*
Summary:
user Defined Function that returns a Quiz Answer ID given a
ToolbookAnswerID and a Quiz Question ID

Returns:
scalar - Quiz Answer Id - int

Called By:
ToolbookListener.cs Calls Stored Procedures which call this.

Calls:

Remarks:


Author:
Gavin Buddis
Date Created: 1 Mar 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1



**/
CREATE  Function [udfGetQuizAnswerIDByToolbookAnswerID]
(
@toolbookAnswerID Varchar(50),
@quizQuestionID	Integer
)

Returns Int --< QuizAnswerID >--
Begin
------------------------------------------
-- get Quiz Answer ID for this Toolbook Answer ID
------------------------------------------

Declare @intRetVal Integer
Set @intRetVal =
(
Select Top 1
QuizAnswerID
From
tblQuizAnswer
Where
ToolbookAnswerID = @toolbookAnswerID
And
QuizQuestionID = @quizQuestionID
)



Return @intRetVal

End
' 
END
GO


SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetQuizIDBySessionID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfGetQuizIDBySessionID    Script Date: 20/04/2004 8:25:57 AM ******/

/*
Summary:
user Defined Function that returns a Quiz id given a Session id
Returns:
integer

Called By:
ToolbookListener.aspx

Calls:

Remarks:


Author:	Peter Kneale
Date Created: 3 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	GB		9/2/04			Coding standards

**/

CREATE  Function [udfGetQuizIDBySessionID]
(
@sessionID Varchar(50) --Session ID used to determine the Quiz ID
)
Returns Integer

Begin
-- Declarations
Declare @retVal Integer --Quiz ID to be returned

-- Get Quiz ID from Session
Set @retVal =
(
Select Top 1
QuizID
From
tblQuizSession
Where
QuizSessionID = ltrim(rtrim(@sessionID))
)

Return @retVal

End
' 
END
GO


SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetQuizIDByToolbookID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfGetQuizIDByToolbookID    Script Date: 20/04/2004 8:25:57 AM ******/




/*
Summary:
user Defined Function that returns a quiz id given a toolbook id
only Works for a quiz
Returns:
scaler - toolbook id - int

Called By:

Calls:

Remarks:


Author:
Peter Kneale, Stephen Kennedy-Clark
Date Created: 3 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


**/
CREATE   Function [udfGetQuizIDByToolbookID]
(
@toolbookID Varchar(50)
)

Returns Integer
Begin
-- Declarations
Declare @retVal Integer

-- Get QuizID by toolbook ID
Set @retVal =
(
Select Top 1
QuizID
From
tblQuiz
Where
ToolbookID = ltrim(rtrim(@toolBookID))
and Active=1
)
Return @retVal
End
' 
END
GO


SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetQuizIDByToolbookIDAndModuleID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfGetQuizIDByToolbookIDAndModuleID    Script Date: 20/04/2004 8:25:57 AM ******/


/*
Summary:
user Defined Function that returns a quiz id given a toolbook id and module id
only Works for a quiz
Returns:
scaler - toolbook id - int

Called By:

Calls:

Remarks:


Author:
Peter Kneale
Date Created: 18 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


**/
CREATE Function [udfGetQuizIDByToolbookIDAndModuleID]
(
@toolbookID 	Varchar(50),		-- Toolbook ID used to determine quiz id
@moduleID	Integer			-- Module ID that quiz must belong to
)

Returns Integer

Begin
-- Declarations
Declare @retVal Integer

-- Get Quiz ID by toolbookID and moduleID
Set @retVal =
(
Select Top 1
QuizID
From
tblQuiz
Where
ToolbookID = ltrim(rtrim(@toolBookID))
And
ModuleID = @moduleID
And
Active=1
)

Return @retVal

End
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetQuizQuestionIDByToolbookPageID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfGetQuizQuestionIDByToolbookPageID    Script Date: 20/04/2004 8:25:57 AM ******/

/*
Summary:
user Defined Function that returns a Quiz Question ID given a Toolbook Page ID
only Works for a quiz
Returns:
scalar - Quiz Question Id - int

Called By:
ToolbookListener.cs Calls Stored Procedures which call this.

Calls:

Remarks:


Author:
Peter Kneale - Stephen Kennedy-Clark
Date Created: 3 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1



**/
CREATE Function [udfGetQuizQuestionIDByToolbookPageID]
(
@toolBookPageID 	Varchar(50),	-- The id of the toolbook page
@quizID		Integer		-- The id of the quiz
)

Returns Int --< QuizQuestionID >--
Begin
-- Declarations
Declare @intRetVal Integer

-- get Quiz Question ID for this Toolbook Page ID
Set @intRetVal =
(
Select Top 1
QuizQuestionID
From
tblQuizQuestion
Where
ToolbookPageID = @toolBookPageID
And QuizID = @quizID
)


Return @intRetVal

End
' 
END
GO


SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetQuizStatus]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfGetQuizStatus    Script Date: 20/04/2004 8:25:57 AM ******/




/*
Summary:
user Defined Function that returns a status id for quizes given a module id and a userID
only the users Latest Status ID is returned
Returns:
integer

Called By: prcModule_GetDetailsForHomePage

Calls:

Remarks:


Author:	Stephen Kennedy Clark
Date Created: Fiday 13 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

print dbo.udfGetQuizStatus(3, 11)
**/

CREATE    Function [udfGetQuizStatus]
(
@moduleID int -- the module to get the users status for
, @userID int -- the user id to get the status for
)
Returns Integer

Begin

Declare @retVal Integer -- User Status

Set @retVal =
(
Select Top 1
QuizStatusID
From
tblUserQuizStatus
Where
UserID = @userID
and ModuleID = @moduleID
Order by DateCreated desc
)

Return @retVal

End
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetSaltDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [udfGetSaltDate]
(

)
-- This function should be called by all Stored Procedures in SALT that use getdate() or getUTCdate()
-- By directing all calls through this function it is easy to perform testing on date related business rules - for
-- example by changing the function call (below) to	SELECT @UTCDate = DATEADD(YEAR,1,dbo.getUTCdate()) it is possible to enter test data through the WebSite that is 1 year old

RETURNS DateTime
AS
BEGIN

DECLARE @UTCDate datetime

SELECT @UTCDate = dbo.getUTCdate()


RETURN @UTCDate

END
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetSaltOrgDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [udfGetSaltOrgDate]
(
@OrgID int

)
RETURNS DateTime
AS
BEGIN

DECLARE @ORGDate datetime

SELECT @ORGDate = CAST(convert( varchar(11), dbo.udfUTCtoDaylightSavingTime(GETUTCDATE(),@OrgID),113) AS DateTime)


RETURN @ORGDate

END
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetSaltOrgDateStr]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [udfGetSaltOrgDateStr]
(
@OrgID int

)
RETURNS Table
AS

return


SELECT  convert( varchar(17), dbo.udfUTCtoDaylightSavingTime(GETUTCDATE(),@OrgID),113) as PrintDate
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetSaltOrgMidnight]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [udfGetSaltOrgMidnight]
(
@OrgID int

)
RETURNS DateTime
AS
BEGIN

DECLARE @ORGDate DateTime ,@OrgMidnight datetime

SELECT @OrgMidnight = CAST(convert( varchar(11), dbo.udfUTCtoDaylightSavingTime(GETUTCDATE(),@OrgID),113) AS DateTime)

SELECT @ORGDate = dbo.udfDaylightSavingTimeToUTC(@OrgMidnight,@OrgID)

RETURN @ORGDate

END
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetSaltOrgTomorrow]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create FUNCTION [udfGetSaltOrgTomorrow]
(
@OrgID int

)
RETURNS DateTime
AS
BEGIN

DECLARE @ORGDate DateTime ,@OrgMidnight datetime

SELECT @OrgMidnight = CAST(convert( varchar(11), dbo.udfUTCtoDaylightSavingTime(DATEADD(d,1,GETUTCDATE()),@OrgID),113) AS DateTime)

-- return it in Daylight saving time

RETURN @ORGDate

END
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetToolbookPageIDByLessonPageID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfGetToolbookPageIDByLessonPageID    Script Date: 20/04/2004 8:25:57 AM ******/




/*
Summary:
user Defined Function that returns a Toolbook Page ID given a Lesson Page ID
only Works for a lesson
Returns:
scaler - Toolbook Page id - varchar(50)

Called By:

Calls:

Remarks:


Author:
Stephen Kennedy-Clark
Date Created: 3 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


print dbo.udfGetLessonPageIDByToolbookPageID(''toolBookID-1'')
-- select * from tblLessonPage

**/
CREATE   FUNCTION [udfGetToolbookPageIDByLessonPageID]
(
@lessonPageID int -- The PK value for a lesson in the LessonPage table
)
RETURNS varchar(50) --< ToolBookPageID >--
Begin
------------------------------------------
-- get Toolbook Page ID  for this Lesson Page ID
------------------------------------------

DECLARE @retVal int
set @retVal =
(
SELECT TOP 1
ToolbookPageID
FROM
tblLessonPage
WHERE
LessonPageID = @lessonPageID
)

RETURN @retVal
End
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetUnitIDPathway]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfGetUnitPathway    Script Date: 20/04/2004 8:25:57 AM ******/

/*
Summary:
user Defined Function that returns pathway of a specified unit
Returns:
">" delimited pathway of a unit
e.g. "Unit 1 > Unit 2 > Unit 5 > Unit 7"

Called By:

Calls:

Remarks:


Author: Jack Liu
Date Created: 6 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


select  dbo.udfGetUnitIDPathway(9)

select dbo.udfGetUnitIDPathway(UnitID)
from tblUnit

**/
CREATE  FUNCTION [udfGetUnitIDPathway]
(
@UnitID int
)
RETURNS nvarchar(4000)
Begin

declare @strPathway nvarchar(4000)
declare @strHierarchy nvarchar(500)

select @strHierarchy='',''+hierarchy+'',''
from tblUnit
where UnitID = @UnitID

--Convert unit ID hierarchy ''1,2,5,7'' to pathway ''Unit 1 > Unit 2 > Unit 5 > Unit 7''

select @strPathway=IsNull(@strPathway+'' > '','''')+cast(UnitID as varchar)
from tblUnit
where charindex('',''+cast(UnitID as varchar)+'','', @strHierarchy)>0
order by [Level]

--select @strPathway

RETURN @strPathway
End
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetUnitPathway]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfGetUnitPathway    Script Date: 20/04/2004 8:25:57 AM ******/

/*
Summary:
user Defined Function that returns pathway of a specified unit
Returns:
">" delimited pathway of a unit
e.g. "Unit 1 > Unit 2 > Unit 5 > Unit 7"

Called By:

Calls:

Remarks:


Author: Jack Liu
Date Created: 6 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


select  dbo.udfGetUnitPathway(9)

select dbo.udfGetUnitPathway(UnitID)
from tblUnit

**/
CREATE  FUNCTION [udfGetUnitPathway]
(
@UnitID int
)
RETURNS nvarchar(4000)
Begin

declare @strPathway nvarchar(4000)
declare @strHierarchy nvarchar(500)

select @strHierarchy='',''+hierarchy+'',''
from tblUnit
where UnitID = @UnitID

--Convert unit ID hierarchy ''''1,2,5,7'''' to pathway ''''Unit 1 > Unit 2 > Unit 5 > Unit 7''''

select @strPathway=IsNull(@strPathway+'' > '','''')+Name
from tblUnit
where charindex('',''+cast(UnitID as varchar)+'','', @strHierarchy)>0
order by [Level]

--select @strPathway

RETURN @strPathway
End
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetUserIDBySessionID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfGetUserIDBySessionID    Script Date: 20/04/2004 8:25:57 AM ******/


/*Summary:
user Defined Function that return a user id given a session id
Works for both the lesson and quiz
Returns:
UserID int

Called By:
dbo.prcBookMark_GetBookMark
dbo.prcBookMark_GetBookMarkBySessionID
dbo.prcLessonPageAudit_GetPagesVisited
dbo.prcLessonPageAudit_GetPagesVisitedBySessionID
dbo.prcLessonQuizSession_GetUserIDBySession
dbo.prcLessonSession_EndLesson
dbo.prcQuizSession_EndQuiz
dbo.prcUser_GetNameBySessionID
dbo.prcUser_GetUserIDBySessionID
Calls:

Remarks:


Author:
Stephen Kennedy-Clark
Date Created: 2 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


print dbo.udfGetUserIDBySessionID(''52FC3930-B1B6-474D-B041-28771E9964AD'')
-- select * from tblQuizSession
-- select * from tblLessonSession
**/
CREATE  FUNCTION [udfGetUserIDBySessionID]
(
@sessionID varchar(50) -- Session ID a GUID
)
RETURNS INT --< UserID >--
Begin
------------------------------------------
-- get user id for this session
------------------------------------------

DECLARE @retVal int
set @retVal =
(
Select Top 1
UserID
From
(
--< tblQuizSession >--
Select
userID
From
tblQuizSession
where
QuizSessionID = @SessionID
UNION

--< tblLessonSession >--
Select
userID
From
tblLessonSession
Where
LessonSessionID =  @SessionID
) t1 --< Dummy Table name to stop SQL complaining >--
)
RETURN @retVal
End
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetUserModuleAccess]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/*
Summary:
user Defined Function that returnsthe ModulesID''s as a comma seperated string
Returns:


Remarks:


Author: Jack Liu
Date Created: 6 09 2005

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


select  dbo.udfGetUserModuleAccess(2,333)



**/
CREATE  FUNCTION [udfGetUserModuleAccess]
(
@UserID int,
@CourseID int
)
RETURNS varchar(4000)
Begin

declare @strModuleIDs varchar(8000)

set @strModuleIDs = '''' -- string to hold moduelids
select
@strModuleIDs = cast(ModuleID as varchar) + '','' + @strModuleIDs
from
vwUserModuleAccess
where
CourseID = @CourseID
and  UserID = @UserID

RETURN @strModuleIDs
End
' 
END
GO


SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfGetUserQuizDetails]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfGetUserQuizDetails    Script Date: 20/04/2004 8:25:57 AM ******/



/*
Summary:
user Defined Function that returns a table containing *
for the last quiz sat by a user
Returns:
table

Called By: prcModule_GetDetailsForHomePage

Calls:

Remarks:


Author:	Stephen Kennedy Clark
Date Created: Fiday 17 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

select * from  dbo.udfGetUserQuizDetails(11)
**/

CREATE  Function [udfGetUserQuizDetails]
(
@userID int -- the user id to get the status for
)
Returns table
as
Return
select 	UserID
, ModuleID
, QuizStatusID
, QuizFrequency
, QuizPassMark
, QuizScore
, DateCreated
from
tblUserQuizStatus tUQS_Outer
Where not exists
(
Select
UserID
From
tblUserQuizStatus tUQS_Inner
Where
tUQS_Inner.UserID = tUQS_Outer.UserID
and tUQS_Inner.ModuleID = tUQS_Outer.ModuleID
and tUQS_Inner.DateCreated < tUQS_Outer.DateCreated
)
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfIsGUID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfIsGUID    Script Date: 20/04/2004 8:25:57 AM ******/

/*
Summary:
user Defined Function that returns 1 (true) if the value supplied was a GUID
else it returns 0 (false)
Returns:
scaler - bit  0 = false, 1 = true

Called By:
prcCourse_GetOneBySessionID
Calls:

Remarks:


Author:
Stephen Kennedy-Clark
Date Created: 3 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1



print dbo.udfIsGUID(newID())
**/
CREATE    FUNCTION [udfIsGUID]
(
@testString varchar(50) -- presumably this is a - GUID
)
RETURNS bit --< boolean >--
Begin
------------------------------------------
-- Declerations
------------------------------------------
DECLARE @returnValue int

set @returnValue = 0
------------------------------------------
-- Try and cast
------------------------------------------
if @testString like replicate(''[0-9a-fA-F]'', 8) + ''-'' +
replicate(''[0-9a-fA-F]'', 4) + ''-'' +
replicate(''[0-9a-fA-F]'', 4) + ''-'' +
replicate(''[0-9a-fA-F]'', 4) + ''-'' +
replicate(''[0-9a-fA-F]'', 12)
Begin
set @returnValue = 1
End
------------------------------------------
RETURN @returnValue



End
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfQuiz_GetPassMark]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfQuiz_GetPassMark    Script Date: 20/04/2004 8:25:57 AM ******/

/*
Summary:
user Defined Function that returns the pass mark for the given module for the given unit
Parameters: @UnitID integer, @ModuleID integer
Returns: integer
Returns:
scaler - Passmark - integer

Called By:
prcQuiz_GetPassMark
Calls:

Remarks:


Author:
Stephen Kennedy-Clark
Date Created: 11 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	Jack Liu        18/02/2003	 	Get quizPassMark from tblUnitRule, if it is null
Get the organisation default quiz pass mark

print dbo.udfQuiz_GetPassMark(1,2)

**/
CREATE   Function [udfQuiz_GetPassMark]
(
@UnitID 	int	-- Unit ID
, @ModuleID 	int	-- Unit ID
)
RETURNS INT --< Passmark >--
Begin

DECLARE @retVal int
--Get quizPassMark from tblUnitRule, if it is null
--Get the organisation default quiz pass mark
Select 	@retVal =isNull(ur.QuizPassMark, o.DefaultQuizPassMark)
From  tblUnit u
inner join tblOrganisation o
on  o.OrganisationID = u.OrganisationID
left join tblUnitRule ur
on ur.ModuleID = @ModuleID
and ur.UnitID=@unitID
where u.UnitID=@unitID


RETURN @retVal
End
' 
END
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfReportSchedule_CalcNextRunDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [udfReportSchedule_CalcNextRunDate]
(
@MinimumRun datetime,
@ReportStartDate datetime,
@ReportFrequencyPeriod char(1),
@ReportFrequency int,
@OrgID int
)
RETURNS  datetime
AS
BEGIN
-- NextRun is saved in the ORGs timezone so that when an ORG goes into daylight saving the Report is run at the correct time.
-- ALL other times are saved in the ORGs timezone to reduce load on the GUI when the ORGs timezone is changed
DECLARE @NextRun DateTime
SET @NextRun = @MinimumRun
IF (@NextRun < @ReportStartDate )
BEGIN
     SET @NextRun = @ReportStartDate
END
DECLARE @NumReportPeriodsToNextRun bigint
if (@ReportFrequency = 0)
begin
set @ReportFrequency = 1
end
SELECT @NumReportPeriodsToNextRun =
1 + CASE
WHEN (@ReportFrequencyPeriod=''Y'') THEN DATEDIFF(YEAR,@ReportStartDate,@MinimumRun)/ @ReportFrequency
WHEN (@ReportFrequencyPeriod=''M'') THEN DATEDIFF(MONTH,@ReportStartDate,@MinimumRun)/ @ReportFrequency
WHEN (@ReportFrequencyPeriod=''W'') THEN DATEDIFF(WEEK,@ReportStartDate,@MinimumRun)/ @ReportFrequency
WHEN (@ReportFrequencyPeriod=''D'') THEN DATEDIFF(DAY,@ReportStartDate,@MinimumRun)/ @ReportFrequency
WHEN (@ReportFrequencyPeriod=''H'') THEN DATEDIFF(HOUR,@ReportStartDate,@MinimumRun)/ @ReportFrequency
END



DECLARE @NumReportPeriodsToNow bigint
SELECT @NumReportPeriodsToNow =
CASE
WHEN (@ReportFrequencyPeriod=''Y'') THEN DATEDIFF(YEAR,			@ReportStartDate,dbo.udfUTCtoDaylightSavingTime(getUTCdate(),@OrgID))/ @ReportFrequency
WHEN (@ReportFrequencyPeriod=''M'') THEN DATEDIFF(MONTH,	@ReportStartDate,dbo.udfUTCtoDaylightSavingTime(getUTCdate(),@OrgID))/ @ReportFrequency
WHEN (@ReportFrequencyPeriod=''W'') THEN DATEDIFF(WEEK,		@ReportStartDate,dbo.udfUTCtoDaylightSavingTime(getUTCdate(),@OrgID))/ @ReportFrequency
WHEN (@ReportFrequencyPeriod=''D'') THEN DATEDIFF(DAY,			@ReportStartDate,dbo.udfUTCtoDaylightSavingTime(getUTCdate(),@OrgID))/ @ReportFrequency
WHEN (@ReportFrequencyPeriod=''H'') THEN DATEDIFF(HOUR,		@ReportStartDate,dbo.udfUTCtoDaylightSavingTime(getUTCdate(),@OrgID))/ @ReportFrequency
END


IF ((@NumReportPeriodsToNextRun) < @NumReportPeriodsToNow) --We have missed an entire reporting period!!!
AND (DATEADD(DAY,2,@NextRun) < dbo.udfUTCtoDaylightSavingTime(getUTCdate(),@OrgID))  --- it is more than 2 days that we are behind for this report!!!
BEGIN --- need to skip some reports as the server has been down for a long time or the date has jumped by a big increment and we don''t want to thrash the servers
SELECT @NextRun = CASE -- Just Move NextRun forward so we have at most one report to deliver
WHEN (@ReportFrequencyPeriod=''Y'') THEN DATEADD(YEAR,@NumReportPeriodsToNow*@ReportFrequency,@ReportStartDate)
WHEN (@ReportFrequencyPeriod=''M'') THEN DATEADD(MONTH,@NumReportPeriodsToNow*@ReportFrequency,@ReportStartDate)
WHEN (@ReportFrequencyPeriod=''W'') THEN DATEADD(WEEK,@NumReportPeriodsToNow*@ReportFrequency,@ReportStartDate)
WHEN (@ReportFrequencyPeriod=''D'') THEN DATEADD(DAY,@NumReportPeriodsToNow*@ReportFrequency,@ReportStartDate)
WHEN (@ReportFrequencyPeriod=''H'') THEN DATEADD(HOUR,@NumReportPeriodsToNow*@ReportFrequency,@ReportStartDate)
END
END


-- Return the result of the function
RETURN  @NextRun

END
' 
END

GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfReportSchedule_IncrementNextRunDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [udfReportSchedule_IncrementNextRunDate]
(
	@RunDate datetime, 
	@ReportStartDate datetime, 
	@ReportFrequencyPeriod char(1), 
	@ReportFrequency int, 
	@OrgID int	
)
RETURNS  datetime
AS
BEGIN
	if (@ReportFrequency = 0)
	begin
	   set @ReportFrequency = 1
	 end
	-- NextRun is saved in the ORGs timezone so that when an ORG goes into daylight saving the Report is run at the correct time.
	-- ALL other times are saved in the ORGs timezone to reduce load on the GUI when the ORGs timezone is changed

	DECLARE @NumReportPeriodsToNextRun bigint
	SELECT @NumReportPeriodsToNextRun = 
	1 + CASE 
		WHEN (@ReportFrequencyPeriod=''Y'') THEN DATEDIFF(YEAR,@ReportStartDate,@RunDate)/ @ReportFrequency
		WHEN (@ReportFrequencyPeriod=''M'') THEN DATEDIFF(MONTH,@ReportStartDate,@RunDate)/ @ReportFrequency
		WHEN (@ReportFrequencyPeriod=''W'') THEN DATEDIFF(WEEK,@ReportStartDate,@RunDate)/ @ReportFrequency
		WHEN (@ReportFrequencyPeriod=''D'') THEN DATEDIFF(DAY,@ReportStartDate,@RunDate)/ @ReportFrequency
		WHEN (@ReportFrequencyPeriod=''H'') THEN DATEDIFF(HOUR,@ReportStartDate,@RunDate)/ @ReportFrequency
	END	
	

	DECLARE @NextNextRun DateTime
	SELECT @NextNextRun = 
	CASE 
		WHEN (@ReportFrequencyPeriod=''Y'') THEN DATEADD(YEAR,@NumReportPeriodsToNextRun*@ReportFrequency,@ReportStartDate)
		WHEN (@ReportFrequencyPeriod=''M'') THEN DATEADD(MONTH,@NumReportPeriodsToNextRun*@ReportFrequency,@ReportStartDate)
		WHEN (@ReportFrequencyPeriod=''W'') THEN DATEADD(WEEK,@NumReportPeriodsToNextRun*@ReportFrequency,@ReportStartDate)
		WHEN (@ReportFrequencyPeriod=''D'') THEN DATEADD(DAY,@NumReportPeriodsToNextRun*@ReportFrequency,@ReportStartDate)
		WHEN (@ReportFrequencyPeriod=''H'') THEN DATEADD(HOUR,@NumReportPeriodsToNextRun*@ReportFrequency,@ReportStartDate)
	END	


	-- Return the result of the function
	RETURN @NextNextRun

END
' 
END
GO


SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfReport_CompleteCourseLogic]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfReport_CompleteCourseLogic    Script Date: 16/03/2006******/

/*Summary:
Selects User details for users that have Completed their training

Parameters:
@organisationID Integer,
@unitIDs	string		(Mandatory)
@courseIDs	string		(Mandatory)
@effectiveFromDate	datetime	(optional)
@effectiveToDate	datetime	(optional)
Returns:


Called By:
prcReport_CourseStatusReport

Calls:
fn dbo.udfGetUnitPathway( UnitID )
fn udfReport_completeUsers()
fn udfCsvToInt( csv )


Remarks:


Author:

Execution:


Modification History
-----------------------------------------------------------
v#	Author		Date			Description
**/
CREATE function [dbo].[udfReport_CompleteCourseLogic]
(
@organisationID Integer,	-- Organisation of the user running the report
@unitIDs Varchar(max),		-- string of unit id''s
@courseIDs varchar(8000), 			-- course IDs to restrict search to
@effectiveFromDateOrg datetime = null,	-- effective date of report From
@effectiveToDateOrg datetime = null	-- effective date of report To
)

-------------------------------------------------------------------
Returns @tblReturn Table
(
UserID		Int,
UnitID		Int,
FirstName		nVarchar(255),
LastName 	nVarchar(255),
UnitPathway 	nVarchar(3000),
[Date]		Datetime,
Username		nvarchar(100),
Email		nvarchar(100),
ExternalID		nvarchar(50),
CourseName	nvarchar(200)
)

as
Begin --1
DECLARE @effectiveFromDate 		datetime
DECLARE @effectiveToDate 		datetime
SET @effectiveFromDate = dbo.udfDaylightSavingTimeToUTC(@effectiveFromDateOrg,@OrganisationID)
SET @effectiveToDate = dbo.udfDaylightSavingTimeToUTC(@effectiveToDateOrg,@OrganisationID)

if (@unitIDs is null)
begin --2
----------------------------------------------------
--- Report on all units
----------------------------------------------------
if (@effectiveFromDate is null)
begin --4
----------------------------------------------------
--- Report on the current date
----------------------------------------------------
Insert into
@tblReturn
SELECT
tU1.userID
, tU1.UnitID
, tU1.FirstName
, tU1.LastName
, dbo.udfGetUnitPathway(tU1.UnitID) as ''UnitPathway''
, dbo.udfUTCtoDaylightSavingTime(vUCS.DateCreated,@OrganisationID) as ''Date''
, tU1.Username as ''Username''
, tU1.Email as ''Email''
, tU1.ExternalID as ''ExternalID''
, tC.Name as ''CourseName''
FROM
tblUser tU1
inner join tblUnit
on tU1.UnitID = tblUnit.UnitID
and tblUnit.organisationID = @organisationID
and tU1.Active = 1 --< only want active users >--
and tu1.userTypeID <> 1 --< not interested in saltadmins >--
inner join vwUserCourseStatus vUCS
on vUCS.UserID = tU1.userID
and vUCS.CourseStatusID = 2 --< only want completed users >--
--and vUCS.CourseID in (SELECT * FROM dbo.udfCsvToInt(@courseIDs))--
inner join dbo.udfCsvToInt(@courseIDs)tR
on tR.IntValue = vUCS.CourseID
inner join dbo.tblCourse tC
on tR.IntValue = tC.CourseID
end --/4
else
begin --5

----------------------------------------------------
--- Report on the historic date
----------------------------------------------------
Insert into
@tblReturn
SELECT
tU1.userID
, tU1.UnitID
, tU1.FirstName
, tU1.LastName
, dbo.udfGetUnitPathway(tU1.UnitID) as ''UnitPathway''
, dbo.udfUTCtoDaylightSavingTime(vUCS.DateCreated,@OrganisationID) as ''Date''
, tU1.Username as ''Username''
, tU1.Email as ''Email''
, tU1.ExternalID as ''ExternalID''
, tC.Name as ''CourseName''
FROM
tblUser tU1
inner join tblUnit
on tU1.UnitID = tblUnit.UnitID
and tblUnit.organisationID = @organisationID
and tU1.Active = 1 --< only want active users >--
and tu1.userTypeID <> 1 --< not interested in saltadmins >--
inner join  dbo.udfReport_HistoricUserCourseStatusWithinRange(@effectiveFromDate, @effectiveToDate) vUCS
on vUCS.UserID = tU1.userID
and vUCS.CourseStatusID = 2 --< only want completed users >--
--and vUCS.CourseID in (SELECT * FROM dbo.udfCsvToInt(@courseIDs))--
inner join dbo.udfCsvToInt(@courseIDs)tR
on tR.IntValue = vUCS.CourseID
inner join dbo.tblCourse tC
on tR.IntValue = tC.CourseID
end  --/5
end --/2
else
begin --3
----------------------------------------------------
--- Report on specified units
----------------------------------------------------
if (@effectiveFromDate is null)
Begin --6
----------------------------------------------------
--- Report on the current date
----------------------------------------------------
Insert into
@tblReturn
SELECT
tU1.userID
, tU1.UnitID
, tU1.FirstName
, tU1.LastName
, dbo.udfGetUnitPathway(tU1.UnitID) as ''UnitPathway''
, dbo.udfUTCtoDaylightSavingTime(vUCS.DateCreated,@OrganisationID) as ''Date''
, tU1.Username as ''Username''
, tU1.Email as ''Email''
, tU1.ExternalID as ''ExternalID''
, tC.Name as ''CourseName''
FROM
tblUser tU1
inner join tblUnit on
tU1.UnitID = tblUnit.UnitID
and tblUnit.organisationID = @organisationID
and tU1.Active = 1 --< only want active users >--
and tu1.userTypeID <> 1 --< not interested in saltadmins >--
inner join vwUserCourseStatus vUCS
on vUCS.UserID = tU1.userID
and vUCS.CourseStatusID = 2 --< only want completed users >--
--and vUCS.CourseID in (SELECT * FROM dbo.udfCsvToInt(@courseIDs))--
inner join dbo.udfCsvToInt(@courseIDs)tR
on tR.IntValue = vUCS.CourseID
inner join dbo.tblCourse as tC
on tR.IntValue = tC.CourseID
inner join dbo.udfCsvToInt(@unitIDs) tU
on tU.IntValue = tblUnit.UnitID --< restrict units to thoes in the list >--
end  --/6
else
Begin  --7
----------------------------------------------------
--- Report on the historic date
----------------------------------------------------
Insert into
@tblReturn
SELECT
tU1.userID
, tU1.UnitID
, tU1.FirstName
, tU1.LastName
, dbo.udfGetUnitPathway(tU1.UnitID) as ''UnitPathway''
, dbo.udfUTCtoDaylightSavingTime(vUCS.DateCreated,@OrganisationID) as ''Date''
, tU1.Username as ''Username''
, tU1.Email as ''Email''
, tU1.ExternalID as ''ExternalID''
, tC.Name as ''CourseName''
FROM
tblUser tU1
inner join tblUnit
on tU1.UnitID = tblUnit.UnitID
and tblUnit.organisationID = @organisationID
and tU1.Active = 1 --< only want active users >--
and tu1.userTypeID <> 1 --< not interested in saltadmins >--
inner join  dbo.udfReport_HistoricUserCourseStatusWithinRange(@effectiveFromDate, @effectiveToDate) vUCS
on vUCS.UserID = tU1.userID
and vUCS.CourseStatusID = 2 --< only want completed users >--
--and vUCS.CourseID = @courseID--
inner join dbo.udfCsvToInt(@courseIDs) tR
on tR.IntValue = vUCS.CourseID
inner join dbo.tblCourse as tC
on tR.IntValue = tC.CourseID
inner join dbo.udfCsvToInt(@unitIDs) tU
on tU.IntValue = tblUnit.UnitID --< restrict units to thoes in the list >--
End  --/7
end --/3
return
end -- /1
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfReport_CompleteUsersLogic]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfReport_CompleteUsersLogic    Script Date: 20/04/2004 8:25:58 AM ******/

/*Summary:
Selects User details for users that have not Completed their training

Parameters:
@organisationID Integer,
@unitIDs	string		(Mandatory)
@courseID	int		(Mandatory)
@effectiveDateOrg	datetime	(optional) (in Organisations Timezone)
Returns:


Called By:
prcReport_CompletedUsers

Calls:
fn dbo.udfGetUnitPathway( UnitID )
fn udfReport_incompleteUsers()
fn udfCsvToInt( csv )


Remarks:


Author: Stephen Kennedy-Clark
Date Created: 18 February 2004

Execution:


Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	Jack Liu	27/02/2004 		Change the "in" criteria to left join, this will improve performance
Fix the unit id bug
#2	Stephen Clark	1/4/2004		change the function to use the underlying table
#3	Peter Kneale	7/4/2004		Added function for effective date style reports
#4	Liz Dionisio(UW)	8/11/2005		Added Username, Email and ExternalID to returned recordset
#5	Yoppy Suwanto	22/08/2007		Replace the udfGetUnitPathway function with the tblUnitHierarchy usage.  This will improve perfomance
#5	j hedlefs		09/06/2011		Timezone
**/
CREATE   function [udfReport_CompleteUsersLogic]
(
@organisationID Integer,	-- Organisation of the user running the report
@unitIDs Varchar(MAX),		-- string of unit id''s
@courseID Int, 			-- course ID to restrict search to
@effectiveDateOrg datetime = null	-- effective date of report in Org timezone
)

-------------------------------------------------------------------
Returns @tblReturn Table
(
UserID		Int,
UnitID		Int,
FirstName		nVarchar(255),
LastName 	nVarchar(255),
UnitPathway 	nVarchar(4000),
[Date]		Datetime,
Username	nvarchar(100),
Email		nvarchar(100),
ExternalID	nvarchar(50)
)

as
Begin --1
DECLARE @effectiveDate DateTime
SET @effectiveDate = dbo.udfDaylightSavingTimeToUTC(@effectiveDateOrg,@OrganisationID)

if (@unitIDs is null)
begin --2
----------------------------------------------------
--- Report on all units
----------------------------------------------------
if (@effectiveDate is null)
begin --4
----------------------------------------------------
--- Report on the current date
----------------------------------------------------
Insert into
@tblReturn
SELECT
tU1.userID
, tU1.UnitID
, tU1.FirstName
, tU1.LastName
--, dbo.udfGetUnitPathway(tU1.UnitID) as ''UnitPathway''
, tUH.HierarchyName as ''UnitPathway''
, dbo.udfUTCtoDaylightSavingTime(vUCS.DateCreated,@OrganisationID) as ''Date''
, tU1.Username as ''Username''
, tU1.Email as ''Email''
, tU1.ExternalID as ''ExternalID''
FROM
tblUser tU1
inner join tblUnit
on tU1.UnitID = tblUnit.UnitID
and tblUnit.organisationID = @organisationID
and tU1.Active = 1 --< only want active users >--
and tu1.userTypeID <> 1 --< not interested in saltadmins >--
inner join vwUserCourseStatus vUCS
on vUCS.UserID = tU1.userID
and vUCS.CourseStatusID = 2 --< only want completed users >--
and vUCS.CourseID = @courseID
inner join tblUnitHierarchy tUH
on tU1.UnitID = tUH.UnitID
end --/4
else
begin --5

----------------------------------------------------
--- Report on the historic date
----------------------------------------------------
Insert into
@tblReturn
SELECT
tU1.userID
, tU1.UnitID
, tU1.FirstName
, tU1.LastName
--, dbo.udfGetUnitPathway(tU1.UnitID) as ''UnitPathway''
, tUH.HierarchyName as ''UnitPathway''
, dbo.udfUTCtoDaylightSavingTime(vUCS.DateCreated,@OrganisationID) as ''Date''
, tU1.Username as ''Username''
, tU1.Email as ''Email''
, tU1.ExternalID as ''ExternalID''
FROM
tblUser tU1
inner join tblUnit
on tU1.UnitID = tblUnit.UnitID
and tblUnit.organisationID = @organisationID
and tU1.Active = 1 --< only want active users >--
and tu1.userTypeID <> 1 --< not interested in saltadmins >--
inner join  dbo.udfReport_HistoricUserCourseStatus(@effectiveDate) vUCS
on vUCS.UserID = tU1.userID
and vUCS.CourseStatusID = 2 --< only want completed users >--
and vUCS.CourseID = @courseID
inner join tblUnitHierarchy tUH
on tU1.UnitID = tUH.UnitID
end  --/5
end --/2
else
begin --3
----------------------------------------------------
--- Report on specified units
----------------------------------------------------
if (@effectiveDate is null)
Begin --6
----------------------------------------------------
--- Report on the current date
----------------------------------------------------
Insert into
@tblReturn
SELECT
tU1.userID
, tU1.UnitID
, tU1.FirstName
, tU1.LastName
--, dbo.udfGetUnitPathway(tU1.UnitID) as ''UnitPathway''
, tUH.HierarchyName as ''UnitPathway''
, dbo.udfUTCtoDaylightSavingTime(vUCS.DateCreated,@OrganisationID) as ''Date''
, tU1.Username as ''Username''
, tU1.Email as ''Email''
, tU1.ExternalID as ''ExternalID''
FROM
tblUser tU1
inner join tblUnit on
tU1.UnitID = tblUnit.UnitID
and tblUnit.organisationID = @organisationID
and tU1.Active = 1 --< only want active users >--
and tu1.userTypeID <> 1 --< not interested in saltadmins >--
inner join vwUserCourseStatus vUCS
on vUCS.UserID = tU1.userID
and vUCS.CourseStatusID = 2 --< only want completed users >--
and vUCS.CourseID = @courseID
inner join dbo.udfCsvToInt(@unitIDs) tU
on tU.IntValue = tblUnit.UnitID --< restrict units to thoes in the list >--
inner join tblUnitHierarchy tUH
on tU1.UnitID = tUH.UnitID
end  --/6
else
Begin  --7
----------------------------------------------------
--- Report on the historic date
----------------------------------------------------
Insert into
@tblReturn
SELECT
tU1.userID
, tU1.UnitID
, tU1.FirstName
, tU1.LastName
--, dbo.udfGetUnitPathway(tU1.UnitID) as ''UnitPathway''
, tUH.HierarchyName as ''UnitPathway''
, dbo.udfUTCtoDaylightSavingTime(vUCS.DateCreated,@OrganisationID) as ''Date''
, tU1.Username as ''Username''
, tU1.Email as ''Email''
, tU1.ExternalID as ''ExternalID''
FROM
tblUser tU1
inner join tblUnit
on tU1.UnitID = tblUnit.UnitID
and tblUnit.organisationID = @organisationID
and tU1.Active = 1 --< only want active users >--
and tu1.userTypeID <> 1 --< not interested in saltadmins >--
inner join  dbo.udfReport_HistoricUserCourseStatus(@effectiveDate) vUCS
on vUCS.UserID = tU1.userID
and vUCS.CourseStatusID = 2 --< only want completed users >--
and vUCS.CourseID = @courseID
inner join dbo.udfCsvToInt(@unitIDs) tU
on tU.IntValue = tblUnit.UnitID --< restrict units to thoes in the list >--
inner join tblUnitHierarchy tUH
on tU1.UnitID = tUH.UnitID
End  --/7
end --/3
return
end -- /1
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfReport_GetEarliestLessonStatus]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [udfReport_GetEarliestLessonStatus]
(
@UserID int,
@ModuleID int
)
RETURNS INT
AS
BEGIN
DECLARE @strStatus INT

SELECT  TOP 1 @strStatus = LessonStatusID
FROM tblUserLessonStatus uls
ORDER BY uls.DateCreated ASC
RETURN @strStatus
END
' 
END
GO


SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfReport_HistoricAdminSummary]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfReport_HistoricAdminSummary    Script Date: 20/04/2004 8:25:58 AM ******/


/*Summary:
Get the Current or historic user module status  based on the search criteria

See the remarks below.

Returns: table

Called By: Current historic Admin Report
Calls:

Remarks:

1. Get User and course List based on search criteria
1.1 Get Unit List
1.1.1 If unit ids are passed in, convert the CSV format to a table
1.1.2 If no unit is selected, get a list of of all units that the admin user has permission to access
1.2 Get User list Based on the first name and last name in the search cirteria
1.3 Get Course list Based on the selected course in the search criteria and Used can select multiple Courses
2. Get the User Quiz and Lesson status up to the effective date
2.1 If there is no effective date is passed in, get the current module status
2.2 If there is effective date, get the module status up to the effective date
3.  Get a list of the user''s quiz and lesson historic status

Author: Jack Liu
Date Created: 1 Mar 2004

Modification History
-----------------------------------------------------------
v#	Author		Date				Description
#1.1	Usman Tjiudri	10/11/2005	Performance tuning:
- use temp-table to populate Unit Pathway
- join the temp-table to populate tblResult
instead of using udfGetUnitPathway function in the join.
#2.0	Serguei Chkaroupine 28/02/06 -New insert statement for histric admin report
- it will insert all lessons that match current quizmodule pair
- Current admin report performance fix. Added WHERE statement to
most of the insert statements.

select * from dbo.udfReport_HistoricAdminSummary(3, '''', ''1,2,3,4'','''','''',''20040222'',4)

--------------------

**/
--instead of using udfGetUnitPathway function in the join.

--select * from dbo.udfReport_HistoricAdminSummary(3, '''', ''1,2,3,4'','''','''',''20040222'',4)

--------------------



CREATE         Function [dbo].[udfReport_HistoricAdminSummary]
(
@organisationID 	Int,
@unitIDs			Varchar(max),
@courseIDs			Varchar(8000),
@userFirstName		nVarchar(50),
@userLastName		nVarchar(50),
@effectiveDate 		Datetime,
@adminUserID		Int,
@classificationID 	Int
)
Returns @tblResult Table
(
-- General
Unit			nVarchar(200),
[User]			nVarchar(100),
Course			nVarchar(100),
Module			nVarchar(100),
[Sequence]		Int,

-- Quiz Specific
QuizStatus		Varchar(50),
QuizScore		Int,
QuizStatusDate	Datetime,

-- Lesson Specific
LessonStatus	Varchar(50),

-- Hidden
UnitID			Int,
UserID			Int,
UserName		nVarchar(100),
ExternalID		nVarchar(50),
CourseID		Int,
ModuleID		Int
)
As Begin
Declare @userTypeID Int
Declare @tblUnit 	Table(UnitID Int)
Declare @tblUser 	Table(UserID Int)
Declare @tblCourse 	Table(CourseID Int, Name nVarchar(50))
Declare @tblUnitPathway Table(UnitID Int, Pathway nVarchar(200)) -- New table

Declare @tblUserQuizStatus Table
(
[UserQuizStatusID] [int] Not Null,
[UserID] [int] Not Null,
[ModuleID] [int] Not Null,
[QuizStatusID] [int] Not Null,
[QuizScore] [int] Null,
[DateCreated] [datetime] Not Null
)

Declare @tblUserLessonStatus Table
(
[UserLessonStatusID] [int] ,
[UserID] [int] ,
[ModuleID] [int] ,
[LessonStatusID] [int] ,
[DateCreated] [datetime]
)


/*
1. Get User and course List based on search criteria
1.1 Get Unit List
1.1.1 If unit ids are passed in, convert the CSV format to a table
1.1.2 If no unit is selected, get a list of of all units that the admin user has permission to access
1.2 Get User list
Based on the first name and last name in the search cirteria
1.3 Get Course list
Based on the selected course in the search criteria
Used can select multiple Courses
*/

If @unitIDs Is Null Set @unitIDs = ''''

If (@unitIDs !='''')
Begin
Insert Into @tblUnit (UnitID)
Select intValue
From dbo.udfCsvToInt(@unitIDs)
End
Else
Begin
Select @userTypeID = userTypeID
From tblUser
Where userID = @adminUserID

--Get all units in that organisation if user is Salt Admin(1) or Org admin (2)
If (@userTypeID=1 Or @userTypeID=2)
Begin
Insert Into @tblUnit (UnitID)
Select UnitID
From tblUnit
Where OrganisationID = @OrganisationID
End
--Get units that the user is admministrator if user is Unit Admin(3)
Else If (@userTypeID=3)
Begin
Insert Into @tblUnit (UnitID)
Select u.UnitID
From tblUnit u
Inner Join tblUnitAdministrator ua On ua.UnitID = u.UnitID And ua.userID = @AdminUserID
Where u.OrganisationID = @OrganisationID
End
End

--FirstName or Last Name specified in search criteria
If (@userFirstName Is Null) Set @userFirstName = ''''
If (@userLastName Is Null) Set @userLastName = ''''

Insert Into @tblUser (UserID)
Select	u.UserID
From tblUser u
Inner Join @tblUnit unit On u.UnitID = unit.UnitID
Left Join tblUserClassification uc On uc.UserID  = u.UserID
Where u.FirstName Like ''%'' + @userFirstName + ''%''
And LastName Like ''%'' + @userLastName + ''%''
And --AND have the Custom Classification option
--If classification is Any (0), This will find users of any Custom Classification
( (@classificationID =0) Or (uc.classificationID = @classificationID) )
And (u.Active=1)
AND (u.OrganisationID = @OrganisationID)

-- Search criteria contains course id''s
Insert Into @tblCourse (CourseID, Name)
Select c.CourseID, c.name
From dbo.udfCsvToInt(@courseIDs) ca
Inner Join tblCourse c On ca.intValue = c.CourseID

/*
2. Get the User Quiz and Lesson status up to the effective date
2.1 If there is no effective date is passed in, get the current module status
2.2 If there is effective date, get the module status up to the effective date
*/

If (@effectiveDate Is Null)
Begin
Insert Into @tblUserQuizStatus
(
[UserQuizStatusID],
[UserID],
[ModuleID],
[QuizStatusID],
[QuizScore],
[DateCreated]
)
Select
[UserQuizStatusID],
[UserID],
[ModuleID],
[QuizStatusID],
[QuizScore],
[DateCreated]
From vwUserQuizStatus
Where QuizStatusID <> 0
AND UserID in  (SELECT UserID FROM @tblUser)

Insert Into @tblUserLessonStatus
(
[UserLessonStatusID],
[UserID],
[ModuleID],
[LessonStatusID],
[DateCreated]
)
Select
[UserLessonStatusID],
[UserID],
[ModuleID],
[LessonStatusID],
[DateCreated]
From vwUserLessonStatus
Where LessonStatusID <> 0
AND UserID in  (SELECT UserID FROM @tblUser)
End

Else

Begin
Insert Into @tblUserQuizStatus
(
[UserQuizStatusID],
[UserID],
[ModuleID],
[QuizStatusID],
[QuizScore],
[DateCreated]
)
Select
[UserQuizStatusID],
[UserID],
[ModuleID],
[QuizStatusID],
[QuizScore],
[DateCreated]
From dbo.udfReport_HistoricUserQuizStatus(@effectiveDate)
Where QuizStatusID <> 0
AND UserID in  (SELECT UserID FROM @tblUser)

Insert Into @tblUserLessonStatus
(
[UserLessonStatusID],
[UserID],
[ModuleID],
[LessonStatusID],
[DateCreated]
)
Select
[UserLessonStatusID],
[UserID],
[ModuleID],
[LessonStatusID],
[DateCreated]
From dbo.udfReport_HistoricUserLessonStatus(@effectiveDate)
Where LessonStatusID <> 0
AND UserID in  (SELECT UserID FROM @tblUser)


-- This part fixes migration issue (note this will affect historic admin report only as it does supply effective date)
-- It will insert userid, moduleid and earliest lesson status for each quiz that does not have lesson record yet
-- into @tblUserLessonStatus
Insert Into @tblUserLessonStatus
(
[UserLessonStatusID],
[UserID],
[ModuleID],
[LessonStatusID],
[DateCreated]
)
Select
1,
uls.[UserID],
uls.[ModuleID],
uls.LessonStatusID,
uls.DateCreated
From  @tblUserQuizStatus uqs
INNER JOIN tblUserLessonStatus uls
ON uqs.UserID = uls.UserID AND uqs.ModuleID = uls.ModuleID
INNER JOIN
(
-- this derived table gets earliest lesson datecreated in a group
SELECT  UserID, ModuleID, min(DateCreated) as DateCreated
FROM tblUserLessonStatus
WHERE UserID in (SELECT UserID FROM @tblUser)
GROUP BY UserID, ModuleID --, DateCreated
) as els -- Earliest Lesson Status
ON els.UserID = uls.UserID AND els.ModuleID = uls.ModuleID AND els.DateCreated = uls.DateCreated
WHERE NOT EXISTS
(
SELECT 1 FROM @tblUserLessonStatus uls
WHERE uqs.UserID = uls.UserID and uqs.ModuleID = uls.ModuleID
)
AND uls.UserID in (SELECT UserID FROM @tblUser)



End

/* Populate Unit Pathway using temp-table */
Insert Into @tblUnitPathway
Select UnitID As [UnitID], dbo.udfGetUnitPathway(UnitID) As [Pathway]
From @tblUnit
--Order By tblUnit.UnitID
-- sp_help udfCsvToInt
/* 3.  Get the user''s quiz and lesson status details */
Insert Into @tblResult
(
Unit,
[User],
Course,
Module,
[Sequence],
QuizStatus,
QuizStatusDate,	-- These columns have been reordered
QuizScore,	    -- These columns have been reordered
LessonStatus,
UnitID,
UserID,
UserName,
ExternalID,
CourseID,
ModuleID
)
Select
-- General
up.Pathway 						As Unit, -- Unit Name
u.LastName + '' '' + u.FirstName  As ''User'', -- User Full Name
c.Name			  				As Course, -- Course Name
m.Name			  				As Module, -- Module Name
m.Sequence						As Sequence,

-- Quiz Specific
qs.Status						As QuizStatus,
uqs.DateCreated 			    as QuizStatusDate,	-- These columns have been reordered
uqs.QuizScore 				    as QuizScore,		-- These columns have been reordered

-- Lesson Specific
ls.status 						As LessonStatus,

-- Hidden
u.UnitID						As UnitID,
u.UserID						As UserID,
u.UserName						As UserName,
u.ExternalID						As ExternalID,
c.CourseID						As CourseID,
m.ModuleID						As ModuleID

From @tblUserQuizStatus uqs
Inner Join tblQuizStatus qs On qs.QuizStatusID = uqs.QuizStatusID
Inner Join @tblUser us 	On us.UserID = uqs.UserID
Inner Join tblUser u On u.UserID = us.UserID
INNER Join @tblUnitPathway up On up.UnitID = u.UnitID
INNER Join tblModule m On m.ModuleID = uqs.ModuleID
INNER Join @tblCourse c On c.CourseID = m.CourseID
INNER Join @tblUserLessonStatus uls On uls.UserID = u.UserID And uls.ModuleID = m.ModuleID
INNER Join tblLessonStatus ls On ls.LessonStatusID = uls.LessonStatusID


Return
End
' 
END
GO


SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfReport_HistoricAdminSummaryOptimised]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfReport_HistoricAdminSummary    Script Date: 20/04/2004 8:25:58 AM ******/
/*Summary:
Get the Current or historic user module status  based on the search criteria
See the remarks below.
Returns: table
Called By: Current historic Admin Report
Calls:
Remarks:
1. Get User and course List based on search criteria
1.1 Get Unit List
1.1.1 If unit ids are passed in, convert the CSV format to a table
1.1.2 If no unit is selected, get a list of of all units that the admin user has permission to access
1.2 Get User list Based on the first name and last name in the search cirteria
1.3 Get Course list Based on the selected course in the search criteria and Used can select multiple Courses
2. Get the User Quiz and Lesson status up to the effective date
2.1 If there is no effective date is passed in, get the current module status
2.2 If there is effective date, get the module status up to the effective date
3.  Get a list of the user''s quiz and lesson historic status
Author: Jack Liu
Date Created: 1 Mar 2004
Modification History
-----------------------------------------------------------
v#	Author		Date				Description
#1.1	Usman Tjiudri	10/11/2005	Performance tuning:
- use temp-table to populate Unit Pathway
- join the temp-table to populate tblResult
instead of using udfGetUnitPathway function in the join.
#2.0	Serguei Chkaroupine 28/02/06 -New insert statement for histric admin report
- it will insert all lessons that match current quizmodule pair
- Current admin report performance fix. Added WHERE statement to
most of the insert statements.
#3	Mark Donald	27/07/2009			add userName and userEmail params
#4	William Tio	01/12/2009
- remove the wrong logic to exclude the user quiz/lesson status
- replace with ''not exists''

select * from dbo.udfReport_HistoricAdminSummary(3, '''', ''1,2,3,4'','''','''',NULL,NULL,''20040222'',4)
--------------------
**/

CREATE                Function [dbo].[udfReport_HistoricAdminSummaryOptimised]
(
@organisationID 	Int,
@unitIDs			Varchar(max),
@courseIDs			Varchar(8000),
@userFirstName		Varchar(50),
@userLastName		Varchar(50),
@userName			Varchar(100),
@userEmail			Varchar(100),
@effectiveDate 		Datetime,
@adminUserID		Int,
@classificationID 	Int,
@defaultDate		DateTime,
@inclInactive		int
)
Returns @tblResult Table
(
-- General
Unit			nVarchar(200),
[User]			nVarchar(100),
Course			nVarchar(100),
Module			nVarchar(100),
[Sequence]		Int,
-- Quiz Specific
QuizStatus		Varchar(50),
QuizScore		Int,
QuizStatusDate	Datetime,
-- Lesson Specific
LessonStatus	Varchar(50),
-- Hidden
UnitID			Int,
UserID			Int,
UserName		nVarchar(100),
ExternalID		nVarchar(50),
CourseID		Int,
ModuleID		Int,
Active	int
)
As Begin

--Variables declarations
DECLARE @UserTypeID 	INT
DECLARE @tblUnit 				Table(UnitID INT PRIMARY KEY(UnitID))
DECLARE @tblUser 				Table(UserID INT, UnitID INT, Active INT)
DECLARE @tblCourse 				Table(CourseID INT, [Name] NVARCHAR(100) PRIMARY KEY(CourseID))
DECLARE @CoursesWithAccess 		TABLE (CourseID INT PRIMARY KEY(CourseID))
DECLARE @UserModuleWithAccess 	TABLE(UserID INT, ModuleID INT, UnitID INT PRIMARY KEY(UserID, ModuleID, UnitID))
DECLARE @AllModules 			TABLE(ModuleID INT PRIMARY KEY(ModuleID))
DECLARE @tblUserQuizStatus 		Table
(
[UserQuizStatusID] [int] Not Null,
[UserID] [int] Not Null,
[ModuleID] [int] Not Null,
[QuizStatusID] [int] Not Null,
[QuizScore] [int] Null,
[DateCreated] [datetime] Not Null
)
DECLARE @tblUserLessonStatus 	Table
(
[UserLessonStatusID] [int] ,
[UserID] [int] ,
[ModuleID] [int] ,
[LessonStatusID] [int] ,
[DateCreated] [datetime]
)
DECLARE @vwUserModuleAccess table
(
UserID INT not null,
FirstName varchar(255),
LastName varchar(255),
UnitID INT,
OrganisationID INT,
ModuleID INT,
CourseID INT,
CourseName nvarchar(100),
[Name] nvarchar(100),
Sequence INT,
Description nvarchar(1000)
)

DECLARE @tblOrganisationCourseAccess table
(
OrganisationID int,
GrantedCourseID int
)
---------------------------------------------------------------------------------------------

--set the default date depending on effective date
set @defaultdate = coalesce (@effectivedate,@defaultdate)
---------------------------------------------------------------------------------------------

--Check If Unit ID is specified
IF @unitIDs IS NULL
BEGIN
--Check User Type
SELECT
@UserTypeID = UserTypeID
FROM
tblUser
WHERE UserID = @adminUserID

--Get all units in Organisation if user is Salt Admin(1) or Org admin (2)
IF (@UserTypeID = 1 Or @UserTypeID = 2)
BEGIN
INSERT INTO
@tblUnit (UnitID)
SELECT
UnitID
FROM
tblUnit
WHERE OrganisationID = @OrganisationID
END

--Get units that the user is admministrator if user is Unit Admin(3)
IF (@UserTypeID = 3)
BEGIN
INSERT INTO
@tblUnit (UnitID)
SELECT
U.UnitID
FROM
tblUnit U INNER JOIN tblUnitAdministrator UA ON
UA.UnitID = U.UnitID AND
UA.UserID = @adminUserID
WHERE
U.OrganisationID = @OrganisationID
END
END
ELSE
BEGIN
--Seperate comma seperated values as Table rows
INSERT INTO @tblUnit SELECT * FROM  dbo.udfCsvToInt(@unitIDs)
END
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
--FirstName, Last Name, etc specified in search criteria
IF (@userFirstName IS NULL) 	SET @userFirstName = ''''
IF (@userLastName IS NULL) 		SET @userLastName = ''''
IF (@userName IS NULL) 			SET @userName = ''''
IF (@userEmail IS NULL) 		SET @userEmail = ''''

INSERT INTO
@tblUser (UserID, UnitID, Active)
SELECT DISTINCT
U.UserID, U.UnitID, U.Active
FROM
tblUser U INNER JOIN @tblUnit UN ON	U.UnitID = UN.UnitID
and datediff(day,U.datecreated,@defaultdate)>=0-- created on or b4 specified date
LEFT JOIN tblUserClassification UC ON UC.UserID  = U.UserID
WHERE
U.FirstName Like ''%'' + @userFirstName + ''%'' AND
LastName Like ''%'' + @userLastName + ''%'' AND
UserName Like ''%'' + @userName + ''%'' AND
Email Like ''%'' + @userEmail + ''%'' AND
--AND have the Custom Classification option
--If classification is Any (0), This will find users of any Custom Classification
((@classificationID = 0) OR (UC.classificationID = @classificationID)) AND
--inclInactive = 0: do not include inactive user
--inclInactive = 1: include inactive user
(U.Active = CASE @inclInactive WHEN 0 THEN 1 ELSE U.Active END) AND
(U.OrganisationID = @OrganisationID)

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
-- Search criteria contains Course IDs
INSERT INTO
@tblCourse (CourseID, [Name])
SELECT
C.CourseID, C.[Name]
FROM
dbo.udfCsvToInt(@courseIDs) CA INNER JOIN tblCourse C ON
CA.intValue = C.CourseID AND C.Active = 1

-- added to deal with past courses - adds past course to intermediate @tblOrganisationCourseAccess table
-- to mimic it being a current course so results will be returned
insert into
@tblOrganisationCourseAccess (OrganisationID, GrantedCourseID)
select
@Organisationid, C.CourseID
from
dbo.udfCsvToInt(@courseIDs) CA inner join tblCourse C on
CA.intValue = C.CourseID and C.Active = 1

INSERT INTO @vwUserModuleAccess   SELECT   tU.UserID, tU.FirstName, tU.LastName, tU.UnitID, tU.OrganisationID, tM.ModuleID, tM.CourseID, tC.Name AS CourseName, tM.Name, tM.Sequence,
tM.Description
FROM         tblUser AS tU INNER JOIN
@tblUser tbU on tbU.UserID = tU.UserID
inner join
@tblOrganisationCourseAccess AS tOCA ON tOCA.OrganisationID = tU.OrganisationID INNER JOIN
tblCourse AS tC ON tC.CourseID = tOCA.GrantedCourseID INNER JOIN
tblModule AS tM ON tM.CourseID = tC.CourseID AND tM.Active = 1 LEFT OUTER JOIN
tblUserModuleAccess AS tUsrMA ON tUsrMA.UserID = tU.UserID AND tUsrMA.ModuleID = tM.ModuleID LEFT OUTER JOIN
tblUnitModuleAccess AS tUnitMA ON tUnitMA.UnitID = tU.UnitID AND tUnitMA.DeniedModuleID = tM.ModuleID
WHERE     tM.CourseID in (SELECT courseid from @tblCourse ) AND (tU.UnitID IS NOT NULL) AND (tUnitMA.DeniedModuleID IS NULL) AND (tUsrMA.ModuleID IS NULL) OR
(tUsrMA.Granted = 1)
--select * from @vwUserModuleAccess where UnitID is null

INSERT INTO @UserModuleWithAccess
SELECT DISTINCT UserID, ModuleID, UnitID FROM @vwUserModuleAccess where UnitID is not null

INSERT INTO @tblUserQuizStatus
(
[UserQuizStatusID],
[UserID],
[ModuleID],
[QuizStatusID],
[QuizScore],
[DateCreated]
)
SELECT
A.[UserQuizStatusID],
A.[UserID],
A.[ModuleID],
A.[QuizStatusID],
A.[QuizScore],
A.[DateCreated]
FROM
(
SELECT
A.UserID, A.ModuleID, MAX(B.UserQuizStatusID) AS ''LatestQuizID''
FROM
@UserModuleWithAccess A, tblUserQuizStatus B
WHERE
A.UserID = B.UserID AND A.ModuleID = B.ModuleID AND B.QuizStatusID <> 0
AND DateDiff(day, B.DateCreated, @effectiveDate)>=0
GROUP BY
A.UserID, A.ModuleID
) B, tblUserQuizStatus A, @tblUser C
WHERE
A.UserQuizStatusID = B.LatestQuizID AND B.UserID = C.UserID AND A.UserID = C.UserID
-- li June 2008:
-- User who has access to a module but doesnt have a record in tblUserQuizStatus is a new user
-- this logic will include new user in the current and historic admin report before user quiz status
-- is updated by overnight job

INSERT INTO @tblUserQuizStatus
(
[UserQuizStatusID],
[UserID],
[ModuleID],
[QuizStatusID],
[QuizScore],
[DateCreated]
)
SELECT
0, -- UserQuizStatusID
A.[UserID],
A.[ModuleID],
1, -- QuizStatus: Not Started
null, -- QuizScore
@defaultDate -- DateCreated (here set to @defaultdate which is passed in as getDate())
FROM @UserModuleWithAccess A
join  @tblUser B on A.UserID = B.UserID
-- User doesnt have quiz activities
/* WT: this part is replaced with not exists, the logic below will subtract userid with moduleid
where  A.UserID  + ''-'' + A.MODULEID NOT IN
(	Select D.UserID + ''-'' + D.Moduleid
from @tblUserQuizStatus D
where datediff(day, d.datecreated, @defaultdate)>=0)*/
where not exists
(	Select D.UserID, D.Moduleid
from @tblUserQuizStatus D
where datediff(day, d.datecreated, @defaultdate)>=0
and D.Userid=B.userid and D.moduleid=A.moduleid
)
-- end logic for including new users quiz status



Insert Into @tblUserLessonStatus
(
[UserLessonStatusID],
[UserID],
[ModuleID],
[LessonStatusID],
[DateCreated]
)
Select
A.[UserLessonStatusID],
A.[UserID],
A.[ModuleID],
A.[LessonStatusID],
A.[DateCreated]
FROM
(
SELECT
B.UserID, B.ModuleID, MAX(B.UserLessonStatusID) AS ''LatestLessonStatusID''
FROM
@UserModuleWithAccess A, tblUserLessonStatus B
WHERE
A.UserID = B.UserID AND A.ModuleID = B.ModuleID AND
DateDiff(day, B.DateCreated, @effectiveDate)>=0 AND
B.LessonStatusID <> 0 --Unassigned
GROUP BY
B.UserID, B.ModuleID
) B, tblUserLessonStatus A, @tblUser C
WHERE
A.UserLessonStatusID = B.LatestLessonStatusID AND B.UserID = C.UserID AND A.UserID = C.UserID

-- start logic for including new users lesson status
INSERT INTO @tblUserLessonStatus
(
[UserLessonStatusID],
[UserID],
[ModuleID],
[LessonStatusID],
[DateCreated]
)
SELECT
0, -- UserLessonStatusID
A.[UserID],
A.[ModuleID],
1, -- LessonStatus: Not Started
@defaultDate -- DateCreated (here set to @defaultdate which is passed in as getDate())
FROM @UserModuleWithAccess A
join  @tblUser B on A.UserID = B.UserID
where
-- User doesnt have lesson activities for the date entered
/* WT: this part is replaced with not exists, the logic below will subtract userid with moduleid
A.UserID + ''-'' + A.Moduleid NOT IN
(	Select D.UserID + ''-'' + D.Moduleid
from @tblUserLessonStatus D
where datediff(day, d.datecreated, @defaultdate)>=0 )*/
not exists
(	Select D.UserID, D.Moduleid
from @tblUserLessonStatus D
where datediff(day, d.datecreated, @defaultdate)>=0
and D.Userid=B.userid and D.moduleid=A.moduleid
)
-- end logic for including new users lesson status

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
-- This part fixes migration issue (note this will affect historic admin report only as it does supply effective date)
-- It will insert userid, moduleid and earliest lesson status for each quiz that does not have lesson record yet
-- into @tblUserLessonStatus
Insert Into @tblUserLessonStatus
(
[UserLessonStatusID],
[UserID],
[ModuleID],
[LessonStatusID],
[DateCreated]
)
SELECT 1,
A.[UserID],
A.[ModuleID],
B.LessonStatusID,
A.DateCreated
FROM (
SELECT
A.UserID, A.ModuleID, MIN(A.DateCreated) AS ''DateCreated''
FROM
tblUserLessonStatus A, @tblUser B
WHERE
A.UserID = B.UserID
GROUP BY
A.UserID, A.ModuleID
) A , tblUserLessonStatus B WHERE

A.UserID = B.UserID AND A.ModuleID = B.ModuleID AND A.DateCreated = B.DateCreated AND
(CAST(A.UserID AS VARCHAR(10)) + CAST(A.ModuleID AS VARCHAR(10)))
NOT IN (SELECT CAST(A.UserID AS VARCHAR(10)) + CAST(A.ModuleID AS VARCHAR(10)) FROM @tblUserLessonStatus)


---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
Insert Into @tblResult
(
Unit,
[User],
Course,
Module,
[Sequence],
QuizStatus,
QuizStatusDate,	-- These columns have been reordered
QuizScore,	    -- These columns have been reordered
LessonStatus,
UnitID,
UserID,
UserName,
ExternalID,
CourseID,
ModuleID
)
Select distinct
-- General
up.HierarchyName 				As Unit, -- Unit Name
[User] = CASE u.Active when 0 then u.LastName + '' '' + u.FirstName + ''(i)'' ELSE u.LastName + '' '' + u.FirstName End , -- User Full Name
c.Name			  				As Course, -- Course Name
m.Name			  				As Module, -- Module Name
m.Sequence						As Sequence,
-- Quiz Specific
qs.Status						As QuizStatus,
dbo.udfUTCtoDaylightSavingTime(uqs.DateCreated, @organisationID) as QuizStatusDate,	-- These columns have been reordered
uqs.QuizScore 				    as QuizScore,		-- These columns have been reordered
-- Lesson Specific
ls.status 						As LessonStatus,
-- Hidden
u.UnitID						As UnitID,
u.UserID						As UserID,
u.UserName						As UserName,
u.ExternalID						As ExternalID,
c.CourseID						As CourseID,
m.ModuleID						As ModuleID
--u.Active						As Active
From @tblUserQuizStatus uqs
Inner Join tblQuizStatus qs On qs.QuizStatusID = uqs.QuizStatusID
inner Join @tblUser us 	On us.UserID = uqs.UserID
Inner Join tblUser u On u.UserID = us.UserID
INNER Join tblUnitHierarchy up On up.UnitID = u.UnitID
INNER Join tblModule m On m.ModuleID = uqs.ModuleID
INNER Join @tblCourse c On c.CourseID = m.CourseID
INNER Join @tblUserLessonStatus uls On uls.UserID = u.UserID And uls.ModuleID = m.ModuleID
INNER Join tblLessonStatus ls On ls.LessonStatusID = uls.LessonStatusID
where @effectivedate is null or (datediff(day,uqs.datecreated,@effectivedate)>=0 and datediff(day, uls.datecreated, @effectivedate)>=0)
RETURN
END
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[udfReport_HistoricAdminSummaryOptimised]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[udfReport_HistoricAdminSummaryOptimised]
GO
/****** Object:  User Defined Function dbo.udfReport_HistoricAdminSummary    Script Date: 20/04/2004 8:25:58 AM ******/
/*Summary:
Get the Current or historic user module status  based on the search criteria
See the remarks below.
Returns: table
Called By: Current historic Admin Report
Calls:
Remarks:
1. Get User and course List based on search criteria
1.1 Get Unit List
1.1.1 If unit ids are passed in, convert the CSV format to a table
1.1.2 If no unit is selected, get a list of of all units that the admin user has permission to access
1.2 Get User list Based on the first name and last name in the search cirteria
1.3 Get Course list Based on the selected course in the search criteria and Used can select multiple Courses
2. Get the User Quiz and Lesson status up to the effective date
2.1 If there is no effective date is passed in, get the current module status
2.2 If there is effective date, get the module status up to the effective date
3.  Get a list of the user's quiz and lesson historic status
Author: Jack Liu
Date Created: 1 Mar 2004
Modification History
-----------------------------------------------------------
v#	Author		Date				Description
#1.1	Usman Tjiudri	10/11/2005	Performance tuning:
- use temp-table to populate Unit Pathway
- join the temp-table to populate tblResult
instead of using udfGetUnitPathway function in the join.
#2.0	Serguei Chkaroupine 28/02/06 -New insert statement for histric admin report
- it will insert all lessons that match current quizmodule pair
- Current admin report performance fix. Added WHERE statement to
most of the insert statements.
#3	Mark Donald	27/07/2009			add userName and userEmail params
#4	William Tio	01/12/2009			
- remove the wrong logic to exclude the user quiz/lesson status
- replace with 'not exists'

select * from dbo.udfReport_HistoricAdminSummary(3, '', '1,2,3,4','','',NULL,NULL,'20040222',4)
--------------------
**/

CREATE                Function [dbo].[udfReport_HistoricAdminSummaryOptimised]
(
@organisationID 	Int,
@unitIDs			Varchar(8000),
@courseIDs			Varchar(8000),
@userFirstName		Varchar(50),
@userLastName		Varchar(50),
@userName			Varchar(100),
@userEmail			Varchar(100),
@effectiveDate 		Datetime,
@adminUserID		Int,
@classificationID 	Int,
@defaultDate		DateTime,
@inclInactive		int
)
Returns @tblResult Table
(
-- General
Unit			nVarchar(200),
[User]			nVarchar(100),
Course			nVarchar(100),
Module			nVarchar(100),
[Sequence]		Int,
-- Quiz Specific
QuizStatus		Varchar(50),
QuizScore		Int,
QuizStatusDate	Datetime,
-- Lesson Specific
LessonStatus	Varchar(50),
-- Hidden
UnitID			Int,
UserID			Int,
UserName		nVarchar(100),
ExternalID		nVarchar(50),
CourseID		Int,
ModuleID		Int,
Active	int
)
As Begin

--Variables declarations
DECLARE @UserTypeID 	INT
DECLARE @tblUnit 				Table(UnitID INT PRIMARY KEY(UnitID))
DECLARE @tblUser 				Table(UserID INT, UnitID INT, Active INT)
DECLARE @tblCourse 				Table(CourseID INT, [Name] NVARCHAR(100) PRIMARY KEY(CourseID))
DECLARE @CoursesWithAccess 		TABLE (CourseID INT PRIMARY KEY(CourseID))
DECLARE @UserModuleWithAccess 	TABLE(UserID INT, ModuleID INT, UnitID INT PRIMARY KEY(UserID, ModuleID, UnitID))
DECLARE @AllModules 			TABLE(ModuleID INT PRIMARY KEY(ModuleID))
DECLARE @tblUserQuizStatus 		Table
(
[UserQuizStatusID] [int] Not Null,
[UserID] [int] Not Null,
[ModuleID] [int] Not Null,
[QuizStatusID] [int] Not Null,
[QuizScore] [int] Null,
[DateCreated] [datetime] Not Null
)
DECLARE @tblUserLessonStatus 	Table
(
[UserLessonStatusID] [int] ,
[UserID] [int] ,
[ModuleID] [int] ,
[LessonStatusID] [int] ,
[DateCreated] [datetime]
)
DECLARE @vwUserModuleAccess table
(
UserID INT not null,
FirstName varchar(255),
LastName varchar(255),
UnitID INT,
OrganisationID INT,
ModuleID INT,
CourseID INT,
CourseName nvarchar(100),
[Name] nvarchar(100),
Sequence INT,
Description nvarchar(1000)
)

DECLARE @tblOrganisationCourseAccess table
(
OrganisationID int,
GrantedCourseID int
)
---------------------------------------------------------------------------------------------

--set the default date depending on effective date
set @defaultdate = coalesce (@effectivedate,@defaultdate)
---------------------------------------------------------------------------------------------

--Check If Unit ID is specified
IF @unitIDs IS NULL
BEGIN
--Check User Type
SELECT
@UserTypeID = UserTypeID
FROM
tblUser
WHERE UserID = @adminUserID

--Get all units in Organisation if user is Salt Admin(1) or Org admin (2)
IF (@UserTypeID = 1 Or @UserTypeID = 2)
BEGIN
INSERT INTO
@tblUnit (UnitID)
SELECT
UnitID
FROM
tblUnit
WHERE OrganisationID = @OrganisationID
END

--Get units that the user is admministrator if user is Unit Admin(3)
IF (@UserTypeID = 3)
BEGIN
INSERT INTO
@tblUnit (UnitID)
SELECT
U.UnitID
FROM
tblUnit U INNER JOIN tblUnitAdministrator UA ON
UA.UnitID = U.UnitID AND
UA.UserID = @adminUserID
WHERE
U.OrganisationID = @OrganisationID
END
END
ELSE
BEGIN
--Seperate comma seperated values as Table rows
INSERT INTO @tblUnit SELECT * FROM  dbo.udfCsvToInt(@unitIDs)
END
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
--FirstName, Last Name, etc specified in search criteria
IF (@userFirstName IS NULL) 	SET @userFirstName = ''
IF (@userLastName IS NULL) 		SET @userLastName = ''
IF (@userName IS NULL) 			SET @userName = ''
IF (@userEmail IS NULL) 		SET @userEmail = ''

INSERT INTO
@tblUser (UserID, UnitID, Active)
SELECT DISTINCT
U.UserID, U.UnitID, U.Active
FROM
tblUser U INNER JOIN @tblUnit UN ON	U.UnitID = UN.UnitID
and datediff(day,U.datecreated,@defaultdate)>=0-- created on or b4 specified date
LEFT JOIN tblUserClassification UC ON UC.UserID  = U.UserID
WHERE
U.FirstName Like '%' + @userFirstName + '%' AND
LastName Like '%' + @userLastName + '%' AND
UserName Like '%' + @userName + '%' AND
Email Like '%' + @userEmail + '%' AND
--AND have the Custom Classification option
--If classification is Any (0), This will find users of any Custom Classification
((@classificationID = 0) OR (UC.classificationID = @classificationID)) AND
--inclInactive = 0: do not include inactive user
--inclInactive = 1: include inactive user
(U.Active = CASE @inclInactive WHEN 0 THEN 1 ELSE U.Active END) AND
(U.OrganisationID = @OrganisationID)

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
-- Search criteria contains Course ID's
INSERT INTO
@tblCourse (CourseID, [Name])
SELECT
C.CourseID, C.[Name]
FROM
dbo.udfCsvToInt(@courseIDs) CA INNER JOIN tblCourse C ON
CA.intValue = C.CourseID AND C.Active = 1

-- added to deal with past courses - adds past course to intermediate @tblOrganisationCourseAccess table
-- to mimic it being a current course so results will be returned
insert into
@tblOrganisationCourseAccess (OrganisationID, GrantedCourseID)
select
@Organisationid, C.CourseID
from
dbo.udfCsvToInt(@courseIDs) CA inner join tblCourse C on
CA.intValue = C.CourseID and C.Active = 1

INSERT INTO @vwUserModuleAccess   SELECT   tU.UserID, tU.FirstName, tU.LastName, tU.UnitID, tU.OrganisationID, tM.ModuleID, tM.CourseID, tC.Name AS CourseName, tM.Name, tM.Sequence,
tM.Description
FROM         tblUser AS tU INNER JOIN
@tblUser tbU on tbU.UserID = tU.UserID
inner join
@tblOrganisationCourseAccess AS tOCA ON tOCA.OrganisationID = tU.OrganisationID INNER JOIN
tblCourse AS tC ON tC.CourseID = tOCA.GrantedCourseID INNER JOIN
tblModule AS tM ON tM.CourseID = tC.CourseID AND tM.Active = 1 LEFT OUTER JOIN
tblUserModuleAccess AS tUsrMA ON tUsrMA.UserID = tU.UserID AND tUsrMA.ModuleID = tM.ModuleID LEFT OUTER JOIN
tblUnitModuleAccess AS tUnitMA ON tUnitMA.UnitID = tU.UnitID AND tUnitMA.DeniedModuleID = tM.ModuleID
WHERE     tM.CourseID in (SELECT courseid from @tblCourse ) AND (tU.UnitID IS NOT NULL) AND (tUnitMA.DeniedModuleID IS NULL) AND (tUsrMA.ModuleID IS NULL) OR
(tUsrMA.Granted = 1)
--select * from @vwUserModuleAccess where UnitID is null

INSERT INTO @UserModuleWithAccess
SELECT DISTINCT UserID, ModuleID, UnitID FROM @vwUserModuleAccess where UnitID is not null

INSERT INTO @tblUserQuizStatus
(
[UserQuizStatusID],
[UserID],
[ModuleID],
[QuizStatusID],
[QuizScore],
[DateCreated]
)
SELECT
A.[UserQuizStatusID],
A.[UserID],
A.[ModuleID],
A.[QuizStatusID],
A.[QuizScore],
A.[DateCreated]
FROM
(
SELECT
A.UserID, A.ModuleID, MAX(B.UserQuizStatusID) AS 'LatestQuizID'
FROM
@UserModuleWithAccess A, tblUserQuizStatus B
WHERE
A.UserID = B.UserID AND A.ModuleID = B.ModuleID AND B.QuizStatusID <> 0
AND DateDiff(day, B.DateCreated, @effectiveDate)>=0
GROUP BY
A.UserID, A.ModuleID
) B, tblUserQuizStatus A, @tblUser C
WHERE
A.UserQuizStatusID = B.LatestQuizID AND B.UserID = C.UserID AND A.UserID = C.UserID
-- li June 2008:
-- User who has access to a module but doesn't have a record in tblUserQuizStatus is a new user
-- this logic will include new user in the current and historic admin report before user quiz status
-- is updated by overnight job

INSERT INTO @tblUserQuizStatus
(
[UserQuizStatusID],
[UserID],
[ModuleID],
[QuizStatusID],
[QuizScore],
[DateCreated]
)
SELECT
0, -- UserQuizStatusID
A.[UserID],
A.[ModuleID],
1, -- QuizStatus: Not Started
null, -- QuizScore
@defaultDate -- DateCreated (here set to @defaultdate which is passed in as getDate())
FROM @UserModuleWithAccess A
join  @tblUser B on A.UserID = B.UserID
-- User doesn't have quiz activities
/* WT: this part is replaced with not exists, the logic below will subtract userid with moduleid
where  A.UserID  + '-' + A.MODULEID NOT IN
(	Select D.UserID + '-' + D.Moduleid
from @tblUserQuizStatus D
where datediff(day, d.datecreated, @defaultdate)>=0)*/
where not exists
(	Select D.UserID, D.Moduleid
	from @tblUserQuizStatus D
	where datediff(day, d.datecreated, @defaultdate)>=0
	and D.Userid=B.userid and D.moduleid=A.moduleid
)
-- end logic for including new user's quiz status



Insert Into @tblUserLessonStatus
(
[UserLessonStatusID],
[UserID],
[ModuleID],
[LessonStatusID],
[DateCreated]
)
Select
A.[UserLessonStatusID],
A.[UserID],
A.[ModuleID],
A.[LessonStatusID],
A.[DateCreated]
FROM
(
SELECT
B.UserID, B.ModuleID, MAX(B.UserLessonStatusID) AS 'LatestLessonStatusID'
FROM
@UserModuleWithAccess A, tblUserLessonStatus B
WHERE
A.UserID = B.UserID AND A.ModuleID = B.ModuleID AND
DateDiff(day, B.DateCreated, @effectiveDate)>=0 AND
B.LessonStatusID <> 0 --Unassigned
GROUP BY
B.UserID, B.ModuleID
) B, tblUserLessonStatus A, @tblUser C
WHERE
A.UserLessonStatusID = B.LatestLessonStatusID AND B.UserID = C.UserID AND A.UserID = C.UserID

-- start logic for including new user's lesson status
INSERT INTO @tblUserLessonStatus
(
[UserLessonStatusID],
[UserID],
[ModuleID],
[LessonStatusID],
[DateCreated]
)
SELECT
0, -- UserLessonStatusID
A.[UserID],
A.[ModuleID],
1, -- LessonStatus: Not Started
@defaultDate -- DateCreated (here set to @defaultdate which is passed in as getDate())
FROM @UserModuleWithAccess A
join  @tblUser B on A.UserID = B.UserID
where 
-- User doesn't have lesson activities for the date entered
/* WT: this part is replaced with not exists, the logic below will subtract userid with moduleid
A.UserID + '-' + A.Moduleid NOT IN
(	Select D.UserID + '-' + D.Moduleid
from @tblUserLessonStatus D
where datediff(day, d.datecreated, @defaultdate)>=0 )*/
not exists
(	Select D.UserID, D.Moduleid
	from @tblUserLessonStatus D
	where datediff(day, d.datecreated, @defaultdate)>=0
	and D.Userid=B.userid and D.moduleid=A.moduleid
)
-- end logic for including new user's lesson status

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
-- This part fixes migration issue (note this will affect historic admin report only as it does supply effective date)
-- It will insert userid, moduleid and earliest lesson status for each quiz that does not have lesson record yet
-- into @tblUserLessonStatus
Insert Into @tblUserLessonStatus
(
[UserLessonStatusID],
[UserID],
[ModuleID],
[LessonStatusID],
[DateCreated]
)
SELECT 1,
A.[UserID],
A.[ModuleID],
B.LessonStatusID,
A.DateCreated
FROM (
SELECT
A.UserID, A.ModuleID, MIN(A.DateCreated) AS 'DateCreated'
FROM
tblUserLessonStatus A, @tblUser B
WHERE
A.UserID = B.UserID
GROUP BY
A.UserID, A.ModuleID
) A , tblUserLessonStatus B WHERE

A.UserID = B.UserID AND A.ModuleID = B.ModuleID AND A.DateCreated = B.DateCreated AND
(CAST(A.UserID AS VARCHAR(10)) + CAST(A.ModuleID AS VARCHAR(10)))
NOT IN (SELECT CAST(A.UserID AS VARCHAR(10)) + CAST(A.ModuleID AS VARCHAR(10)) FROM @tblUserLessonStatus)


---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
Insert Into @tblResult
(
Unit,
[User],
Course,
Module,
[Sequence],
QuizStatus,
QuizStatusDate,	-- These columns have been reordered
QuizScore,	    -- These columns have been reordered
LessonStatus,
UnitID,
UserID,
UserName,
ExternalID,
CourseID,
ModuleID
)
Select distinct
-- General
up.HierarchyName 				As Unit, -- Unit Name
[User] = CASE u.Active when 0 then u.LastName + ' ' + u.FirstName + '(i)' ELSE u.LastName + ' ' + u.FirstName End , -- User Full Name
c.Name			  				As Course, -- Course Name
m.Name			  				As Module, -- Module Name
m.Sequence						As Sequence,
-- Quiz Specific
qs.Status						As QuizStatus,
uqs.DateCreated 			    as QuizStatusDate,	-- These columns have been reordered
uqs.QuizScore 				    as QuizScore,		-- These columns have been reordered
-- Lesson Specific
ls.status 						As LessonStatus,
-- Hidden
u.UnitID						As UnitID,
u.UserID						As UserID,
u.UserName						As UserName,
u.ExternalID						As ExternalID,
c.CourseID						As CourseID,
m.ModuleID						As ModuleID
--u.Active						As Active
From @tblUserQuizStatus uqs
Inner Join tblQuizStatus qs On qs.QuizStatusID = uqs.QuizStatusID
inner Join @tblUser us 	On us.UserID = uqs.UserID
Inner Join tblUser u On u.UserID = us.UserID
INNER Join tblUnitHierarchy up On up.UnitID = u.UnitID
INNER Join tblModule m On m.ModuleID = uqs.ModuleID
INNER Join @tblCourse c On c.CourseID = m.CourseID
INNER Join @tblUserLessonStatus uls On uls.UserID = u.UserID And uls.ModuleID = m.ModuleID
INNER Join tblLessonStatus ls On ls.LessonStatusID = uls.LessonStatusID
where @effectivedate is null or (datediff(day,uqs.datecreated,@effectivedate)>=0 and datediff(day, uls.datecreated, @effectivedate)>=0)
RETURN
END





GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfReport_HistoricUserCourseStatus]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/*Summary:
gets the last historic course results for each user prior to the effective date

Returns:
Table

Called By:
Calls:

Remarks:


Author:
Stephen Clark
Date Created: 21 September 2004

Modification History
-----------------------------------------------------------
Author		Date			Description

Mark DOnald	24/07/2009		Added LastCompleted column to select

--------------------
select * from udfReport_HistoricUserCourseStatus(''September 5 2004'')

**/

CREATE  function [udfReport_HistoricUserCourseStatus]
(
@effectiveDate datetime
)
Returns table
as
-----------------------------------------------------------

return select
--< Historic User Course Status Clause >---
tUCS.UserCourseStatusID
, tUCS.UserID
, tUCS.CourseID
, tUCS.CourseStatusID
, tUCS.ModulesAssigned
, tUCS.DateCreated
, (SELECT
max(DateCreated)
FROM
tblUserCourseStatus
WHERE
tUCS.CourseStatusID = 1 --incompleted users only
AND UserID =tUCS.UserID
AND CourseID =tUCS.CourseID
AND CourseStatusID = 2
AND UserCourseStatusID < tUCS.UserCourseStatusID) as  LastCompleted
From
tblUserCourseStatus tUCS
--< only get data on active courses >--
inner join tblCourse tC
on tC.CourseID = tUCS.CourseID
and tC.Active = 1
--< only get the latest result for each user - prior to the efective date >--
inner join(
select
max(UserCourseStatusID) UserCourseStatusID --UserQuizStatusID is identity
from
tblUserCourseStatus
where
tblUserCourseStatus.DateCreated < DATEADD(DD, 1, @effectiveDate)
group by
UserID,CourseID
) currentStatus
on tUCS.UserCourseStatusID = currentStatus.UserCourseStatusID
--< / Historic User Course Status Clause >---
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfReport_HistoricUserCourseStatusWithinRange]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/*Summary:
gets the last historic course results for each user within a date range

Returns:
Table

Called By:
Calls:

Remarks:


Author:
Stephen Clark
Date Created: 28 September 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


--------------------
select * from udfReport_HistoricUserCourseStatusWithinRange(''September 1 2004'', ''September 30 2004'')

**/

Create function [udfReport_HistoricUserCourseStatusWithinRange]
(
@effectiveStartDate      datetime = null ,
@effectiveEndDate    datetime = null
)

Returns table
as
-----------------------------------------------------------

return select
--< Historic User Course Status Clause >---
tUCS.UserCourseStatusID
, tUCS.UserID
, tUCS.CourseID
, tUCS.CourseStatusID
, tUCS.ModulesAssigned
, tUCS.DateCreated
From
tblUserCourseStatus tUCS
--< only get data on active courses >--
inner join tblCourse tC
on tC.CourseID = tUCS.CourseID
and tC.Active = 1
--< only get the latest result for each user - prior to the efective date >--
inner join(
select
max(UserCourseStatusID) UserCourseStatusID --UserQuizStatusID is identity
from
tblUserCourseStatus
where
--< only get data in the date range specified >--
tblUserCourseStatus.DateCreated BETWEEN @effectiveStartDate and DATEADD(DD, 1, @effectiveEndDate)
group by
UserID,CourseID
) currentStatus
on tUCS.UserCourseStatusID = currentStatus.UserCourseStatusID
--< / Historic User Course Status Clause >---
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfReport_HistoricUserLessonStatus]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfReport_HistoricUserLessonStatus    Script Date: 20/04/2004 8:25:58 AM ******/

/*Summary:
gets the historic lesson results for each user(up to effective date)

Returns:
Table

Called By:
Calls:

Remarks:


Author:
Jack Liu
Date Created: 1 March 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


--------------------
-- SELECT * FROM dbo.udfReport_HistoricUserLessonStatus(''20040229'')

**/

CREATE  function [udfReport_HistoricUserLessonStatus]
(
@effectiveDate datetime
)
Returns table
as
return select 	LessonStatus.UserLessonStatusID,
LessonStatus.UserID,
LessonStatus.ModuleID,
m.CourseID,
LessonStatus.LessonStatusID,
LessonStatus.LessonFrequency,
LessonStatus.DateCreated
from tblUserLessonStatus LessonStatus
inner join tblModule m
on m.ModuleID = LessonStatus.ModuleID
inner join (select max(UserLessonStatusID) UserLessonStatusID
from tblUserLessonStatus
where DateDiff(day, DateCreated, @effectiveDate)>=0
group by 	UserID,moduleID) HistoricStatus
on LessonStatus.UserLessonStatusID = HistoricStatus.UserLessonStatusID
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfReport_HistoricUserQuizStatus]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfReport_HistoricUserQuizStatus    Script Date: 20/04/2004 8:25:58 AM ******/

/*Summary:
gets the historic quiz results for each user(up to effective date)

Returns:
Table

Called By:
Calls:

Remarks:


Author:
Jack Liu
Date Created: 1 March 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


--------------------
-- SELECT * FROM dbo.udfReport_HistoricUserQuizStatus(''20040229'')

**/

CREATE   function [udfReport_HistoricUserQuizStatus]
(
@effectiveDate datetime
)
Returns table
as
return 	select
QuizStatus.UserQuizStatusID
, QuizStatus.UserID
, QuizStatus.ModuleID
, m.CourseID
, QuizStatus.QuizStatusID
, QuizStatus.QuizFrequency
, QuizStatus.QuizPassMark
, QuizStatus.QuizScore
, QuizStatus.DateCreated

from
tblUserQuizStatus QuizStatus
inner join tblModule m on m.ModuleID = QuizStatus.ModuleID
inner join
(
select
max(UserQuizStatusID) UserQuizStatusID --UserQuizStatusID is identity
from
tblUserQuizStatus
where DateDiff(day, DateCreated, @effectiveDate)>=0
group by
UserID,moduleID
) HistoricStatus
on QuizStatus.UserQuizStatusID = HistoricStatus .UserQuizStatusID
' 
END
GO


SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfReport_IncompleteCourseLogic]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfReport_IncompleteCourseLogic ******/
/*Summary:
Selects Users that have not Completed their training

Parameters:
@organisationID	int		(optional)
@unitIDs	string		(optional)
@courseID	int		(Mandatory)
@effectiveFromDate	datetime	(optional)
@effectiveToDate	datetime	(optional)
Returns:
Table

Called By:
dbo.prcReport_CourseStatusReport

Calls:
fn dbo.udfGetUnitPathway( UnitID )
fn udfCsvToInt( csv )
fn udfReport_HistoricUserCourseStatusWithinRange
Remarks:


Author:
Date Created: 16 March 2006

Execution:


Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	j hedlefs		09/06/2011		Timezone
**/

CREATE                function [dbo].[udfReport_IncompleteCourseLogic]
(
@organisationID		Integer=null,		-- Organisation ID to search if the unit is empty
@unitIDs 		varchar(max) = null,	-- string of unit ids
@courseIDs		varchar(8000) = null,		-- course ID to restrict search to
@effectiveFromDateOrg 	datetime = null,	-- effective date of report From
@effectiveToDateOrg	datetime = null		-- effective date of report To
)

-------------------------------------------------------------------
Returns @tblReturn table
(
UserID		Int,
UnitID		Int,
FirstName		nvarchar(255),
LastName 	nvarchar(255),
UnitPathway 	nvarchar(4000),
Username		nvarchar(100),
Email		nvarchar(100),
ExternalID		nvarchar(50),
CourseName	nvarchar(200)
)

as
Begin --1
DECLARE @effectiveFromDate DateTime
SET @effectiveFromDate = dbo.udfDaylightSavingTimeToUTC(@effectiveFromDateOrg,@OrganisationID)
DECLARE @effectiveToDate DateTime
SET @effectiveToDate = dbo.udfDaylightSavingTimeToUTC(@effectiveToDateOrg,@OrganisationID)

if (@effectiveFromDate is null)
Begin
----------------------------------------------------
--- Report on the current date
----------------------------------------------------
if (@unitIDs is null)
begin --2
----------------------------------------------------
--- Report on the current date on all units
----------------------------------------------------
Insert into
@tblReturn
SELECT
tU1.userID
, tU1.UnitID
, tU1.FirstName
, tU1.LastName
, dbo.udfGetUnitPathway(tU1.UnitID) as ''UnitPathway''
, tU1.Username as ''Username''
, tU1.Email as ''Email''
, tU1.ExternalID as ''ExternalID''
, tC.Name as ''CourseName''
FROM
tblUser tU1
inner join tblUnit on
tU1.UnitID = tblUnit.UnitID
and tblUnit.organisationID = @organisationID
and tU1.Active = 1 --< only want active users >--
and tu1.userTypeID <> 1 --< not interested in saltadmins >--
inner join vwUserCourseStatus vUCS
on vUCS.UserID = tU1.userID
and vUCS.CourseStatusID = 1 --< want users that are incomplete >--
inner join dbo.udfCsvToInt(@courseIDs) tR
on tR.IntValue = vUCS.CourseID
inner join dbo.tblCourse as tC
on tR.IntValue = tC.CourseID
end --/2
else
begin --3
----------------------------------------------------
--- Report on the current date on a specific unit
----------------------------------------------------
Insert into
@tblReturn
SELECT
tU1.userID
, tU1.UnitID
, tU1.FirstName
, tU1.LastName
, dbo.udfGetUnitPathway(tU1.UnitID) as ''UnitPathway''
, tU1.Username as ''Username''
, tU1.Email as ''Email''
, tU1.ExternalID as ''ExternalID''
, tC.Name as ''CourseName''
FROM
tblUser tU1
inner join tblUnit on
tU1.UnitID = tblUnit.UnitID
and tblUnit.organisationID = @organisationID
and tU1.Active = 1 --< only want active users >--
and tu1.userTypeID <> 1 --< not interested in saltadmins >--
inner join vwUserCourseStatus vUCS
on vUCS.UserID = tU1.userID
and vUCS.CourseStatusID = 1 --< want users that are incomplete >--
--and vUCS.CourseID = @courseID--
inner join dbo.udfCsvToInt(@courseIDs) tR
on tR.IntValue = vUCS.CourseID
inner join dbo.udfCsvToInt(@unitIDs) tU
on tU.IntValue = tblUnit.UnitID
inner join dbo.tblCourse as tC
on tR.IntValue = tC.CourseID --< restrict units to thoes in the list >--

end --/3
End

Else

Begin
----------------------------------------------------
--- Report on the historic date range provided
----------------------------------------------------
if (@unitIDs is null)
begin --2
----------------------------------------------------
--- Report on the historic date range provided for all units
----------------------------------------------------
Insert into
@tblReturn
SELECT
tU1.userID
, tU1.UnitID
, tU1.FirstName
, tU1.LastName
, dbo.udfGetUnitPathway(tU1.UnitID) as ''UnitPathway''
, tU1.Username as ''Username''
, tU1.Email as ''Email''
, tU1.ExternalID as ''ExternalID''
, tC.Name as ''CourseName''
FROM
tblUser tU1
inner join tblUnit on
tU1.UnitID = tblUnit.UnitID
and tblUnit.organisationID = @organisationID
and tU1.Active = 1 --< only want active users >--
and tu1.userTypeID <> 1 --< not interested in saltadmins >--
inner join  dbo.udfReport_HistoricUserCourseStatusWithinRange(@effectiveFromDate, @effectiveToDate) vUCS
on vUCS.UserID = tU1.userID
and vUCS.CourseStatusID = 1 --< want users that are incomplete >--
--and vUCS.CourseID = @courseID--
inner join dbo.udfCsvToInt(@courseIDs) tR
on tR.IntValue = vUCS.CourseID
inner join dbo.tblCourse as tC
on tR.IntValue = tC.CourseID

end --/2
else
begin --3
----------------------------------------------------------------
--- Report on the historic date range provided for the specified units
----------------------------------------------------------------
Insert into
@tblReturn
SELECT
tU1.userID
, tU1.UnitID
, tU1.FirstName
, tU1.LastName
, dbo.udfGetUnitPathway(tU1.UnitID) as ''UnitPathway''
, tU1.Username as ''Username''
, tU1.Email as ''Email''
, tU1.ExternalID as ''ExternalID''
, tC.Name as ''CourseName''
FROM
tblUser tU1
inner join tblUnit on
tU1.UnitID = tblUnit.UnitID
and tblUnit.organisationID = @organisationID
and tU1.Active = 1 --< only want active users >--
and tu1.userTypeID <> 1 --< not interested in saltadmins >--
inner join  dbo.udfReport_HistoricUserCourseStatusWithRange(@effectiveFromDate, @effectiveToDate) vUCS
on vUCS.UserID = tU1.userID
and vUCS.CourseStatusID = 1 --< want users that are incomplete >--
--and vUCS.CourseID = @courseID--
inner join dbo.udfCsvToInt(@courseIDs) tR
on tR.IntValue = vUCS.CourseID
inner join dbo.tblCourse as tC
on tR.IntValue = tC.CourseID
inner join dbo.udfCsvToInt(@unitIDs) tU
on tU.IntValue = tblUnit.UnitID --< restrict units to thoes in the list >--

end --/3
End
return
end -- /1
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfReport_IncompleteUsers]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/*Summary:
List of users that have not completed there training requirements

Returns:
Table (userID int)

Called By:
BusinessServices.GetCompletedUsersReport
Calls:
vwUserQuizStatus
vwUserModuleAccess
dbo.udfReport_IncompletUsers_logic
Remarks:
This function abstracts dbo.udfReport_IncompletUsers_logic and
filters for the required rows

Author:
Stephen Kennedy-Clark
Date Created: 18 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


--------------------
-- SELECT * FROM dbo.udfReport_incompleteUsers(null)

**/

CREATE    function [udfReport_IncompleteUsers]()
Returns table
as
Return
SELECT DISTINCT
vUMA.UserID
, vUMA.CourseID
FROM
vwUserModuleAccess vUMA
left outer join vwUserQuizStatus vUQS
on vUQS.UserID = vUMA.UserID
and vUQS.ModuleID = vUMA.ModuleID
and vUQS.QuizStatusID = 2
where
vUQS.QuizStatusID is null -- (is null = incomplete)
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfReport_IncompleteUsersLogic]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE                  function [udfReport_IncompleteUsersLogic]
(
@organisationID		Integer=null,		-- Organisation ID to search if the unit is empty
@unitIDs 		varchar(MAX) = null,	-- string of unit id''s
@courseID		Integer = null,		-- course ID to restrict search to
@effectiveDate 		datetime = null		-- effective date of report

)

-------------------------------------------------------------------
Returns @tblReturn table
(
UserID		Int,
UnitID		Int,
FirstName		nvarchar(255),
LastName 	nvarchar(255),
UnitPathway 	nvarchar(4000),
LastCompleted	varchar(23),
Username		nvarchar(100),
Email		nvarchar(100),
ExternalID		nvarchar(50)
)

as
Begin --1
if (@effectiveDate is null)
Begin
----------------------------------------------------
--- Report on the current date
----------------------------------------------------
if (@unitIDs is null)
begin --2
----------------------------------------------------
--- Report on the current date on all units
----------------------------------------------------
Insert into
@tblReturn
SELECT
tU1.userID
, tU1.UnitID
, tU1.FirstName
, tU1.LastName
--, dbo.udfGetUnitPathway(tU1.UnitID) as ''UnitPathway''
, tUH.HierarchyName as ''UnitPathway''
, LastCompleted
, tU1.Username as ''Username''
, tU1.Email as ''Email''
, tU1.ExternalID as ''ExternalID''
FROM
tblUser tU1
inner join tblUnit on
tU1.UnitID = tblUnit.UnitID
and tblUnit.organisationID = @organisationID
and tU1.Active = 1 --< only want active users >--
and tu1.userTypeID <> 1 --< not interested in saltadmins >--
inner join vwUserCourseStatus vUCS
on vUCS.UserID = tU1.userID
and vUCS.CourseStatusID = 1 --< want users that are incomplete >--
and vUCS.CourseID = @courseID
inner join tblUnitHierarchy tUH
on tU1.UnitID = tUH.UnitID
end --/2
else
begin --3
----------------------------------------------------
--- Report on the current date on a specific unit
----------------------------------------------------
Insert into
@tblReturn
SELECT
tU1.userID
, tU1.UnitID
, tU1.FirstName
, tU1.LastName
--, dbo.udfGetUnitPathway(tU1.UnitID) as ''UnitPathway''
, tUH.HierarchyName as ''UnitPathway''
, LastCompleted
, tU1.Username as ''Username''
, tU1.Email as ''Email''
, tU1.ExternalID as ''ExternalID''
FROM
tblUser tU1
inner join tblUnit on
tU1.UnitID = tblUnit.UnitID
and tblUnit.organisationID = @organisationID
and tU1.Active = 1 --< only want active users >--
and tu1.userTypeID <> 1 --< not interested in saltadmins >--
inner join vwUserCourseStatus vUCS
on vUCS.UserID = tU1.userID
and vUCS.CourseStatusID = 1 --< want users that are incomplete >--
and vUCS.CourseID = @courseID
inner join dbo.udfCsvToInt(@unitIDs) tU
on tU.IntValue = tblUnit.UnitID --< restrict units to thoes in the list >--
inner join tblUnitHierarchy tUH
on tU1.UnitID = tUH.UnitID
end --/3
End

Else

Begin
----------------------------------------------------
--- Report on the historic date provided
----------------------------------------------------
if (@unitIDs is null)
begin --2
----------------------------------------------------
--- Report on the historic date provided for all units
----------------------------------------------------
Insert into
@tblReturn
SELECT
tU1.userID
, tU1.UnitID
, tU1.FirstName
, tU1.LastName
--, dbo.udfGetUnitPathway(tU1.UnitID) as ''UnitPathway''
, tUH.HierarchyName as ''UnitPathway''
, LastCompleted
, tU1.Username as ''Username''
, tU1.Email as ''Email''
, tU1.ExternalID as ''ExternalID''
FROM
tblUser tU1
inner join tblUnit on
tU1.UnitID = tblUnit.UnitID
and tblUnit.organisationID = @organisationID
and tU1.Active = 1 --< only want active users >--
and tu1.userTypeID <> 1 --< not interested in saltadmins >--
inner join  dbo.udfReport_HistoricUserCourseStatus(@effectiveDate) vUCS
on vUCS.UserID = tU1.userID
and vUCS.CourseStatusID = 1 --< want users that are incomplete >--
and vUCS.CourseID = @courseID
inner join tblUnitHierarchy tUH
on tU1.UnitID = tUH.UnitID

end --/2
else
begin --3
----------------------------------------------------------------
--- Report on the historic date provided for the specified units
----------------------------------------------------------------
Insert into
@tblReturn
SELECT
tU1.userID
, tU1.UnitID
, tU1.FirstName
, tU1.LastName
--, dbo.udfGetUnitPathway(tU1.UnitID) as ''UnitPathway''
, coalesce(tUH.HierarchyName,'''')  as ''UnitPathway''
, LastCompleted
, tU1.Username as ''Username''
, tU1.Email as ''Email''
, tU1.ExternalID as ''ExternalID''
FROM
tblUser tU1
inner join tblUnit on
tU1.UnitID = tblUnit.UnitID
and tblUnit.organisationID = @organisationID
and tU1.Active = 1 --< only want active users >--
and tu1.userTypeID <> 1 --< not interested in saltadmins >--
inner join  dbo.udfReport_HistoricUserCourseStatus(@effectiveDate) vUCS
on vUCS.UserID = tU1.userID
and vUCS.CourseStatusID = 1 --< want users that are incomplete >--
and vUCS.CourseID = @courseID
inner join dbo.udfCsvToInt(@unitIDs) tU
on tU.IntValue = tblUnit.UnitID --< restrict units to thoes in the list >--
inner join tblUnitHierarchy tUH
on tU1.UnitID = tUH.UnitID

end --/3
End

return
end -- /1
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfReport_IndividualDetails]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfReport_IndividualDetails    Script Date: 20/04/2004 8:25:58 AM ******/



/*Summary:
Given a users ID this udfReport_IndividualDetails Gets Details for home page and individual report
Returns:
ordered table of distinct PageID''s

Called By:
dbo.prcReport_Individual
dbo.prcModule_GetDetailsForHomePage
Calls:
dbo.vwUserQuizStatus
dbo.udfGetLessonStatus
dbo.vwUserModuleAccess
Remarks:
1. This udf required that the schema of the underlying views does not change

Author:
Stephen Kennedy-Clark
Date Created: 17 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#3.0.25 Aaron Cripps	08/05/2007		Replace vwUserCourseStatus with a select statement that filters on UserID parameter passed into the function to reduce the number of rows returned (and the time taken to retrieve rows)


--------------------


**/
CREATE function [udfReport_IndividualDetails]
(
@userID  int = null     -- ID of this User
)
------------------------------------------
Returns table
as

Return
select
vUMA.UserID		as ''UserID''
, vUMA.CourseID		as ''CourseID''
, vUMA.CourseName 	as ''CourseName''
, vUMA.ModuleID		as ''ModuleID''
, vUMA.[Name] 		as ''ModuleName''
, tL.LessonID	  	as ''LessonID''
, isNull(dbo.udfGetLessonStatus(vUMA.ModuleID,vUMA.UserID), 1) as ''LessonStatus''  -- n^2 complexety :-(
, isNull(vUQS.QuizStatusID, 1)   as ''QuizStatus''
, vUQS.QuizScore	as ''QuizScore''
, vUQS.QuizPassMark	as ''QuizPassMark''
, replace(replace( tL.ToolbookLocation,''ie4/index.html'',''qfs.html''),''default.aspx'',''QFS.html'') as ''QFSPath''
--, SUBSTRING(  tL.ToolbookLocation,0,(len(tL.ToolbookLocation)-12)  ) + ''/'' + ''QFS.html'' as ''QFSPath''
, vUMA.Sequence		as ''Sequence''
from
--< get the module access details for this user >--
vwUserModuleAccess vUMA
--< get the module access details for this user >--
left outer join tblLesson tL
on tL.ModuleID = vUMA.ModuleID
and tL.Active = 1
--< get the details of the latest quiz  >--
left outer join 
--< below replaces vwUserQuizStatus >--
(
SELECT      QuizStatus.UserID, QuizStatus.ModuleID, m.CourseID, QuizStatus.QuizStatusID, QuizStatus.QuizPassMark, QuizStatus.QuizScore
FROM         dbo.tblUserQuizStatus AS QuizStatus INNER JOIN
                      dbo.tblModule AS m ON m.ModuleID = QuizStatus.ModuleID INNER JOIN
                          (SELECT     MAX(UserQuizStatusID) AS UserQuizStatusID
                            FROM          dbo.tblUserQuizStatus where UserID = @UserID
                            GROUP BY UserID, ModuleID ) AS currentStatus ON QuizStatus.UserQuizStatusID = currentStatus.UserQuizStatusID
WHERE     (m.Active = 1)
)
--vwUserQuizStatus 
vUQS -- n^2 complexety :-(
on vUQS.UserID = vUMA.UserID
and vUQS.ModuleID = vUMA.ModuleID
Where
-- vUMA.CourseID = isnull(@courseID, vUMA.CourseID ) and
vUMA.UserID = isnull(@userID, vUMA.UserID)
' 
END
GO




IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfReport_IndividualDetailsExtended]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
/****** Object:  User Defined Function dbo.udfReport_IndividualDetails    Script Date: 20/04/2004 8:25:58 AM ******/



/*Summary:
Given a users ID this udfReport_IndividualDetails Gets Details for home page and individual report
Returns:
ordered table of distinct PageID''s

Called By:
dbo.prcModule_GetDetailsForHomePage
Calls:

dbo.udfGetLessonStatus
dbo.vwUserModuleAccess
Remarks:
1. This udf required that the schema of the underlying views does not change

Author:
Stephen Kennedy-Clark
Date Created: 17 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#3.0.25 Aaron Cripps	08/05/2007		Replace vwUserCourseStatus with a select statement that filters on UserID parameter passed into the function to reduce the number of rows returned (and the time taken to retrieve rows)


--------------------


**/
CREATE function [dbo].[udfReport_IndividualDetailsExtended]
(
@userID  int = null,     -- ID of this User
@CurrentCultureName NVarChar(40) = ''en-AU''
)
------------------------------------------
Returns table
as





Return
select
vUMA.UserID                      as ''UserID''
, vUMA.CourseID                as ''CourseID''
, vUMA.CourseName         as ''CourseName''
, vUMA.ModuleID                             as ''ModuleID''
, vUMA.[Name]                  as ''ModuleName''
, tL.LessonID                        as ''LessonID''
, isNull(dbo.udfGetLessonStatus(vUMA.ModuleID,vUMA.UserID), 1) as ''LessonStatus''  -- n^2 complexety :-(
, isNull(vUQS.QuizStatusID, 1)   as ''QuizStatus''
, vUQS.QuizScore               as ''QuizScore''
, vUQS.QuizPassMark        as ''QuizPassMark''
--, replace(replace( tL.ToolbookLocation,''ie4/index.html'',''qfs.html''),''default.aspx'',''QFS.html'') as ''QFSPath''
, CASE WHEN (tL.Scorm1_2=1) THEN QFSlocation
ELSE replace(replace( tL.ToolbookLocation,''ie4/index.html'',''qfs.html''),''default.aspx'',''QFS.html'') END as ''QFSPath''

--, SUBSTRING(  tL.ToolbookLocation,0,(len(tL.ToolbookLocation)-12)  ) + ''/'' + ''QFS.html'' as ''QFSPath''
, vUMA.Sequence                              as ''Sequence''


,case when vUQS.DateCreated is null and (RemEsc.DaysToCompleteCourse is null OR ((RemEsc.NotifyMgr = 0) AND (RemEsc.RemindUsers = 0))) then '' --- ''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        -- course just added , overdue not defined
when vUQS.DateCreated is null and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and CS.DateCreated is null then CAST(RemEsc.DaysToCompleteCourse AS VARCHAR(5)        )                                                                                                                                                                                                                                               -- course just added , overnight job has not caught up yet
when QuizStatusID = 1 and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and vUQS.DateCreated is not null              AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate())) >= 0
then CAST(RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate()) AS VARCHAR(5))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- not started , overdue is defined, not overdue
+ (SELECT  '' ''+LangEntryValue  FROM tblLangValue
where LangInterfaceID = (SELECT  LangInterfaceID   FROM tblLangInterface WHERE LangInterfaceName = ''GLOBAL.MISC'')
and LangID =(SELECT LangID FROM tblLang where tblLang.LangCode=  @CurrentCultureName)
and LangResourceID = (SELECT LangResourceID  FROM tblLangResource where   LangResourceName = ''days'' ))
when QuizStatusID = 1 and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1))  and vUQS.DateCreated is not null             AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate())) < 0
then convert(varchar (11),DATEADD(day,RemEsc.DaysToCompleteCourse,dbo.udfUTCtoDaylightSavingTime(vUQS.DateCreated,o.organisationID)),113)                                                                                                         -- not started , overdue is defined, overdue
when QuizStatusID = 4 and vUQS.DateCreated is not null
then convert(varchar (11),dbo.udfUTCtoDaylightSavingTime(vUQS.DateCreated,o.organisationID),113)                                                                                                                                                                                                                                                                                                                                                                                                                 -- Expired (Time Elapsed )
when QuizStatusID = 5 and vUQS.DateCreated is not null
then convert(varchar (11),dbo.udfUTCtoDaylightSavingTime(vUQS.DateCreated,o.organisationID),113)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          -- Expired (New Content)
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is  null   and o.DefaultQuizCompletionDate is not null
then convert(varchar (11),dbo.udfUserUTCtoDaylightSavingTime(o.DefaultQuizCompletionDate,o.organisationID),113)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 --Passed  organisation Default  Quiz Completion Date specified
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is not null
then convert(varchar (11),dbo.udfUserUTCtoDaylightSavingTime(ur.QuizCompletionDate,o.organisationID),113)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          --Passed  unit Default  Quiz Completion Date specified
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizFrequency is not null
then CAST((  DATEDIFF(day,getUTCdate(),DATEADD(month,o.DefaultQuizFrequency,vUQS.DateCreated))) AS varchar(6))                                                                                                                                                                                                                                                                                                                                                                                                                                   --Passed  organisation Default  Quiz frequency specified
+ (SELECT  '' ''+ LangEntryValue  FROM tblLangValue
where LangInterfaceID = (SELECT  LangInterfaceID   FROM tblLangInterface WHERE LangInterfaceName = ''GLOBAL.MISC'')
and LangID =(SELECT LangID FROM tblLang where tblLang.LangCode=  @CurrentCultureName)
and LangResourceID = (SELECT LangResourceID  FROM tblLangResource where   LangResourceName = ''days'' ))

when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is not null and o.DefaultQuizCompletionDate is null
then CAST((  DATEDIFF(day,getUTCdate(),DATEADD(month,ur.QuizFrequency,vUQS.DateCreated))) AS varchar(6))                                                                                                                                                                                                                                                                                                                                                                                                                                                           --Passed - unit Default  Quiz frequency specified
+ (SELECT  '' ''+LangEntryValue  FROM tblLangValue
where LangInterfaceID = (SELECT  LangInterfaceID   FROM tblLangInterface WHERE LangInterfaceName = ''GLOBAL.MISC'')
and LangID =(SELECT LangID FROM tblLang where tblLang.LangCode=  @CurrentCultureName)
and LangResourceID = (SELECT LangResourceID  FROM tblLangResource where   LangResourceName = ''days'' ))

when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizCompletionDate is not null
then convert(varchar (11),dbo.udfUserUTCtoDaylightSavingTime(o.DefaultQuizCompletionDate,o.organisationID),113)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 --Failed - previously passed - organisation Default  Quiz Completion Date specified
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is not null
then convert(varchar (11),dbo.udfUserUTCtoDaylightSavingTime(ur.QuizCompletionDate,o.organisationID),113)                                                                                                                                                                                                                                                                                                                                                 --Failed - previously passed - unit Default  Quiz Completion Date specified
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizFrequency is not null
then CAST(( DATEDIFF(day,getUTCdate(),DATEADD(month,o.DefaultQuizFrequency,LC.DateCreated))) AS varchar(6))                                                                                                                                                                                                                                                                                                                                                                                                                                    --Failed - previously passed -organisation Default  Quiz frequency specified
+ (SELECT  '' ''+LangEntryValue  FROM tblLangValue
where LangInterfaceID = (SELECT  LangInterfaceID   FROM tblLangInterface WHERE LangInterfaceName = ''GLOBAL.MISC'')
and LangID =(SELECT LangID FROM tblLang where tblLang.LangCode=  @CurrentCultureName)
and LangResourceID = (SELECT LangResourceID  FROM tblLangResource where   LangResourceName = ''days'' ))

when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is not null
then CAST((  DATEDIFF(day,getUTCdate(),DATEADD(month,ur.quizfrequency,LC.DateCreated))) AS varchar(6))                                                                                                                                                                                                                                                                                                                                                                                                                                                                           --Failed - previously passed -unit Default  Quiz frequency specified
+ (SELECT  '' ''+LangEntryValue  FROM tblLangValue
where LangInterfaceID = (SELECT  LangInterfaceID   FROM tblLangInterface WHERE LangInterfaceName = ''GLOBAL.MISC'')
and LangID =(SELECT LangID FROM tblLang where tblLang.LangCode=  @CurrentCultureName)
and LangResourceID = (SELECT LangResourceID  FROM tblLangResource where   LangResourceName = ''days'' ))

when QuizStatusID = 3 and LC.DateCreated is null and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and vUQS.DateCreated is not null         AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate())) >= 0
then convert(varchar (11),DATEADD(day,RemEsc.DaysToCompleteCourse,dbo.udfUTCtoDaylightSavingTime(vUQS.DateCreated,o.organisationID)),113)

when QuizStatusID = 3 and LC.DateCreated is null and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and vUQS.DateCreated is not null         AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate())) < 0
then convert(varchar (11),DATEADD(day,RemEsc.DaysToCompleteCourse,dbo.udfUTCtoDaylightSavingTime(vUQS.DateCreated,o.organisationID)),113)   


/*
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizCompletionDate is not null
then convert(varchar (11),dbo.udfUserUTCtoDaylightSavingTime(o.DefaultQuizCompletionDate,o.organisationID),113)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 --Failed - previously passed - organisation Default  Quiz Completion Date specified
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is not null
then convert(varchar (11),dbo.udfUserUTCtoDaylightSavingTime(ur.QuizCompletionDate,o.organisationID),113)                                                                                                                                                                                                                                                                                                                                                   --Failed - previously passed - unit Default  Quiz Completion Date specified
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizFrequency is not null
then CAST(( DATEDIFF(day,getUTCdate(),DATEADD(month,o.DefaultQuizFrequency,vUQS.DateCreated))) AS varchar(6))                                                                                                                                                                                                                                                                                                                                                                                                                                    --Failed - previously passed -organisation Default  Quiz frequency specified
+ (SELECT  '' ''+LangEntryValue  FROM tblLangValue
where LangInterfaceID = (SELECT  LangInterfaceID   FROM tblLangInterface WHERE LangInterfaceName = ''GLOBAL.MISC'')
and LangID =(SELECT LangID FROM tblLang where tblLang.LangCode=  @CurrentCultureName)
and LangResourceID = (SELECT LangResourceID  FROM tblLangResource where   LangResourceName = ''days'' ))

when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is not null
then CAST((  DATEDIFF(day,getUTCdate(),DATEADD(month,ur.quizfrequency,vUQS.DateCreated))) AS varchar(6))                                                                                                                                                                                                                                                                                                                                                                                                                                                                           --Failed - previously passed -unit Default  Quiz frequency specified
+ (SELECT  '' ''+LangEntryValue  FROM tblLangValue
where LangInterfaceID = (SELECT  LangInterfaceID   FROM tblLangInterface WHERE LangInterfaceName = ''GLOBAL.MISC'')
and LangID =(SELECT LangID FROM tblLang where tblLang.LangCode=  @CurrentCultureName)
and LangResourceID = (SELECT LangResourceID  FROM tblLangResource where   LangResourceName = ''days'' ))

when QuizStatusID = 3 and LC.DateCreated is null and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and vUQS.DateCreated is not null         AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate())) >= 0
then CAST(RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate()) AS VARCHAR(5))                                                                                                                                                                                                                                                                                                                                                                  --Failed - not previously passed , overdue is defined, not overdue
+ (SELECT  '' ''+LangEntryValue  FROM tblLangValue
where LangInterfaceID = (SELECT  LangInterfaceID   FROM tblLangInterface WHERE LangInterfaceName = ''GLOBAL.MISC'')
and LangID =(SELECT LangID FROM tblLang where tblLang.LangCode=  @CurrentCultureName)
and LangResourceID = (SELECT LangResourceID  FROM tblLangResource where   LangResourceName = ''days'' ))

when QuizStatusID = 3 and LC.DateCreated is null and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and vUQS.DateCreated is not null         AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate())) < 0
then convert(varchar (11),DATEADD(day,RemEsc.DaysToCompleteCourse,dbo.udfUTCtoDaylightSavingTime(vUQS.DateCreated,o.organisationID)),113)                                                                                                         --Failed - not previously passed , overdue is defined, overdue

*/

end
as QuizExpiryDate
,case
when LC.DateCreated is null then '' ''
else convert(varchar (11),dbo.udfUTCtoDaylightSavingTime(LC.DateCreated,o.organisationID),113)
end as LastComp

,case when vUQS.DateCreated is null and (RemEsc.DaysToCompleteCourse is null OR ((RemEsc.NotifyMgr = 0) AND (RemEsc.RemindUsers = 0))) then ''0''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        -- course just added , overdue not defined
when vUQS.DateCreated is null and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and CS.DateCreated is null then ''0''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           -- course just added , overnight job has not caught up yet
when QuizStatusID = 1 and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and vUQS.DateCreated is not null              AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate())) >= 0 then ''0''                       -- not started , overdue is defined, not overdue
when QuizStatusID = 1 and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and vUQS.DateCreated is not null              AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate())) < 0 then ''1''                         -- not started , overdue is defined, overdue
when QuizStatusID = 4 and vUQS.DateCreated is not null then ''1''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        -- Expired (Time Elapsed )
when QuizStatusID = 5 and vUQS.DateCreated is not null then ''1''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        -- Expired (New Content)
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizCompletionDate is not null
and DATEDIFF(day,o.DefaultQuizCompletionDate,getUTCdate()) < 0 then ''0''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               --Passed - organisation Default  Quiz Completion Date specified , expired
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is not null
and DATEDIFF(day,ur.QuizCompletionDate,getUTCdate()) < 0 then ''0''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    --Passed - unit Default  Quiz Completion Date specified , expired
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizCompletionDate is not null
and DATEDIFF(day,o.DefaultQuizCompletionDate,getUTCdate()) >= 0 then ''1''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              --Passed - organisation Default  Quiz Completion Date specified , not expired
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is not null
and DATEDIFF(day,ur.QuizCompletionDate,getUTCdate()) >= 0 then ''1''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    --Passed - unit Default  Quiz Completion Date specified , not expired
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizFrequency is not null
and DATEDIFF(day,DATEADD(month,o.DefaultQuizFrequency,vUQS.DateCreated),getUTCdate()) >= 0 then "1"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            --Passed - organisation Default  Quiz frequency specified
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is not null
and  DATEDIFF(day,DATEADD(month,ur.quizfrequency,vUQS.DateCreated),getUTCdate())  >= 0 then "1"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     --Passed - unit Default  Quiz frequency specified
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizFrequency is not null
and DATEDIFF(day,DATEADD(month,o.DefaultQuizFrequency,vUQS.DateCreated),getUTCdate()) < 0 then "0"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              --Passed - organisation Default  Quiz frequency specified , not expired
when QuizStatusID = 2 and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is not null
and  DATEDIFF(day,DATEADD(month,ur.quizfrequency,vUQS.DateCreated),getUTCdate())  < 0  then "0"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      --Passed - unit Default  Quiz frequency specified , not expired


when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizCompletionDate is not null
and DATEDIFF(day,o.DefaultQuizCompletionDate,getUTCdate()) < 0 then ''0''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               --failed - previously passed - organisation Default  Quiz Completion Date specified , expired
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is not null
and DATEDIFF(day,ur.QuizCompletionDate,getUTCdate()) > 0 then ''0''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    --failed - previously passed - unit Default  Quiz Completion Date specified , expired
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizCompletionDate is not null
and DATEDIFF(day,o.DefaultQuizCompletionDate,getUTCdate()) >= 0 then ''1''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              --failed - previously passed - organisation Default  Quiz Completion Date specified , not expired
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is not null
and DATEDIFF(day,ur.QuizCompletionDate,getUTCdate()) <= 0 then ''1''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    --failed - previously passed - unit Default  Quiz Completion Date specified , not expired
when QuizStatusID = 3 and LC.DateCreated is not null  and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizFrequency is not null
and DATEDIFF(day,DATEADD(month,o.DefaultQuizFrequency,vUQS.DateCreated),getUTCdate()) >= 0 then "1"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            --failed - previously passed - organisation Default  Quiz frequency specified
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is not null
and  DATEDIFF(day,getUTCdate(),DATEADD(month,ur.quizfrequency,vUQS.DateCreated)) >= 0 then "1"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      --failed - previously passed - unit Default  Quiz frequency specified
when QuizStatusID = 3 and LC.DateCreated is not null and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is null and o.DefaultQuizFrequency is not null
and DATEDIFF(day,DATEADD(month,o.DefaultQuizFrequency,vUQS.DateCreated),getUTCdate()) < 0 then "0"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              --failed - previously passed - organisation Default  Quiz frequency specified
when QuizStatusID = 3 and LC.DateCreated is not null  and vUQS.DateCreated is not null  and ur.QuizCompletionDate is null and ur.QuizFrequency is not null
and   DATEDIFF(day,getUTCdate(),DATEADD(month,ur.quizfrequency,vUQS.DateCreated)) < 0               then "0"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         --failed - previously passed - unit Default  Quiz frequency specified
when QuizStatusID  = 3 and LC.DateCreated is null and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and vUQS.DateCreated is not null         AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate())) >= 0 then ''0''                         -- not started , overdue is defined, not overdue
when QuizStatusID  = 3 and LC.DateCreated is null and RemEsc.DaysToCompleteCourse is not null and ((RemEsc.NotifyMgr = 1) OR (RemEsc.RemindUsers = 1)) and vUQS.DateCreated is not null         AND (RemEsc.DaysToCompleteCourse -   DATEDIFF(day,vUQS.DateCreated,getUTCdate())) < 0 then ''1''                           -- not started , overdue is defined, overdue




end AS Red
from
--< get the module access details for this user >--
vwUserModuleAccess vUMA
inner join tblOrganisation o
ON o.organisationID = vUMA.OrganisationID
--< get the module access details for this user >--
left outer join tblLesson tL
on tL.ModuleID = vUMA.ModuleID
and tL.Active = 1
--< get the details of the latest quiz  >--
left outer join

(
SELECT      QuizStatus.UserID, QuizStatus.ModuleID, m.CourseID, QuizStatus.QuizStatusID, QuizStatus.QuizPassMark, QuizStatus.QuizScore,QuizStatus.DateCreated
FROM         dbo.tblUserQuizStatus AS QuizStatus INNER JOIN
dbo.tblModule AS m ON m.ModuleID = QuizStatus.ModuleID INNER JOIN
(SELECT     MAX(UserQuizStatusID) AS UserQuizStatusID,ModuleID
FROM          dbo.tblUserQuizStatus where UserID = @UserID
GROUP BY ModuleID ) AS currentStatus ON QuizStatus.UserQuizStatusID = currentStatus.UserQuizStatusID and currentStatus.ModuleID = m.ModuleID
WHERE     (m.Active = 1)
)

vUQS -- n^2 complexety :-(
on vUQS.UserID = vUMA.UserID
and vUQS.ModuleID = vUMA.ModuleID
left outer join tblUnitRule ur --Get the unit specific rules
on ur.ModuleID = vUQS.ModuleID
and ur.ModuleID = vUMA.ModuleID
and ur.UnitID=vUMA.unitID
left outer join tblReminderEscalation RemEsc on RemEsc.CourseId = vUMA.CourseID
and RemEsc.orgID = o.organisationID
left outer join (SELECT MIN(UserCourseStatusID) as UserCourseStatusID,[UserID] ,[CourseID] FROM tblUserCourseStatus LastAttempt where LastAttempt.UserID = @UserID and not exists (SELECT * FROM tblUserCourseStatus PreviousAttempt where PreviousAttempt.UserID = @UserID and PreviousAttempt.CourseStatusID = 0 and PreviousAttempt.UserCourseStatusID < LastAttempt.UserCourseStatusID and PreviousAttempt.CourseID = LastAttempt.CourseID and PreviousAttempt.UserID = LastAttempt.UserID) group by [UserID] ,[CourseID]
) CSID ON CSID.UserID = @UserID and CSID.courseID = vUMA.courseID
left outer join tblUserCourseStatus CS ON CS.UserID = @UserID and CS.courseID = vUMA.courseID and CS.UserCourseStatusID = CSID.UserCourseStatusID
left outer join
( -- Last Passed Module Quiz record
SELECT      QuizStatus.UserID, QuizStatus.ModuleID,QuizStatus.DateCreated
FROM         dbo.tblUserQuizStatus AS QuizStatus INNER JOIN
dbo.tblModule AS m ON m.ModuleID = QuizStatus.ModuleID INNER JOIN
(SELECT     MAX(UserQuizStatusID) AS UserQuizStatusID,ModuleID
FROM          dbo.tblUserQuizStatus where UserID = @UserID
and QuizStatusID = 2 -- passed
GROUP BY  ModuleID ) AS currentStatus ON QuizStatus.UserQuizStatusID = currentStatus.UserQuizStatusID and currentStatus.ModuleID = m.ModuleID
WHERE     (m.Active = 1)
)
LC
on LC.UserID = vUMA.UserID
and LC.ModuleID = vUMA.ModuleID
Where
-- vUMA.CourseID = isnull(@courseID, vUMA.CourseID ) and
vUMA.UserID = isnull(@userID, vUMA.UserID)


' 
END

GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfUnit_GetAdministratorsEmailAddress]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create function [udfUnit_GetAdministratorsEmailAddress]
(
@unitID	int
)
Returns varchar(100)
AS
BEGIN
DECLARE @Email VARCHAR(100)
SELECT @Email = coalesce(
-- try to get the closest unit admin then search further afield
(Select top 1	u.Email
from tblUnitAdministrator ua
inner join tblUser u on ua.userID = u.UserID
where ua.unitID=@unitID
and u.usertypeID=3 --Unit administrator(3)
and u.unitID=@unitID
and u.Email is not null),


(Select top 1	u.Email
from tblUnitAdministrator ua
inner join tblUser u on ua.userID = u.UserID
where ua.unitID=@unitID
and u.usertypeID=3 --Unit administrator(3)
and u.Email is not null),

(Select top 1	u.Email
from tblUser u inner join tblUnit un on un.OrganisationID = u.OrganisationID
where un.unitID=@unitID
and UserTypeID = 2
and Email is not null),


(Select top 1	u.Email
from tblUser u inner join tblUnit un on un.OrganisationID = u.OrganisationID
where un.unitID=@unitID
and UserTypeID = 1
and Email is not null),

--all else failed so get the salt admin
(Select top 1	u.Email
from tblUser u
where UserTypeID = 1
and Email is not null))



return @Email
END
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfUserCourseComplete]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/****** Object:  User Defined Function dbo.udfUserCourseComplete   Script Date: 08/12/2009 8:25:58 AM ******/

/*
Summary:	Returns 1 if the given user has a current course status of complete (2) for the given course

Called By:	dbo.prcReport_Warning.PRC
dbo.prcReport_WarningGrandTotal.PRC

Author:		Mark Donald
Created:	8 Dec 2009

Modification History
-----------------------------------------------------------
v#	Author		Date			Description

*/

CREATE FUNCTION [udfUserCourseComplete]
(
@userID int,
@courseID int
)
RETURNS bit AS
BEGIN
DECLARE @course_status int
SELECT
TOP 1 @course_status = CourseStatusID
FROM
tblUserCourseStatus
WHERE
CourseID = @CourseID
AND UserID = @UserID
ORDER BY
DateCreated DESC
RETURN CASE WHEN isnull(@course_status, 0) = 2 THEN 1 ELSE 0 END
END
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfUserUTCtoDaylightSavingTime]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra Jagtap
-- Create date: 30/06/2011
-- Description:	changes time from utc to user local time while displaying
-- =============================================
CREATE FUNCTION [udfUserUTCtoDaylightSavingTime]
(
@UTC DateTime,
@UserID int
)
RETURNS DateTime
AS
BEGIN

IF (@UTC is null) RETURN null
DECLARE @UserLocalTime datetime
DECLARE @UTC_Offset int
DECLARE @Timezone datetime
DECLARE @offset_mins int, @hours_start int, @day_start int, @week_start int, @month_start int, @hours_end int, @day_end int, @week_end int, @month_end int, @year_end int , @year_start int

DECLARE @TimezoneID int
SELECT @TimezoneID = TimeZoneID FROM tblUser WHERE UserID=@UserID

IF (@TimezoneID is NULL)
BEGIN
SELECT @UTC_Offset = TZ.OffsetUTC , @Timezone = TZ.TimezoneID
FROM tblTimeZone TZ
INNER JOIN tblOrganisation Org ON TZ.TimeZoneID = Org.TimeZoneID
INNER JOIN tblUser Usr ON Usr.OrganisationID = Org.OrganisationID
WHERE Usr.UserID = @UserID
END
ELSE
BEGIN
SELECT @UTC_Offset = TZ.OffsetUTC , @Timezone = TZ.TimezoneID
FROM tblTimeZone TZ
INNER JOIN tblUser Usr ON TZ.TimeZoneID = Usr.TimeZoneID
WHERE Usr.UserID = @UserID
END

IF (@UTC_Offset IS NULL)
BEGIN
Set @UserLocalTime = ''1 Jan 1900'' -- all results are displayed by Reporting Services so create an "error" that will be apparent in Reporting Services
END
ELSE
BEGIN
Set @UserLocalTime = DATEADD(minute,@UTC_Offset,@UTC )
SELECT  @offset_mins = offset_mins, --get definition of the (at most) 1 definition that may cover the datetime
@hours_start = hours_start, --overlapping definitions removed by GUI so only 1 result returned
@day_start = day_start,
@week_start = week_start,
@month_start = month_start,
@hours_end = hours_end,
@day_end = day_end,
@week_end = week_end,
@month_end = month_end
FROM tblTimeZoneDaylightSavingRules
WHERE  TimezoneID = @Timezone
AND @UserLocalTime >= first_start_date
AND @UserLocalTime <= last_end_date

-- start with a period (@Period_start datetime, @period_end datetime) that just has the correct year digits
DECLARE @Period_start datetime, @period_end datetime
Set @year_start = year(@UserLocalTime)
set @year_end = year(@UserLocalTime)

if (month(@UserLocalTime) <= @month_end) and (@month_start > @month_end) set @year_start = @year_start - 1   -- rule spans december 31 so adjust

IF(@month_start > @month_end) and (month(@UserLocalTime) >= @month_start) set @year_end = @year_start + 1  -- rule spans december 31 so adjust


--Set @year_start = year(@UserLocalTime) --now calculate the exact start and end dates and times for the year under consideration
--IF(@month_start > @month_end) set @year_end = @year_start+1 else set @year_end = @year_start
--DECLARE @Period_start datetime, @period_end datetime

set @Period_start = ''1 jan 2000'' -- start with a known datetime
set @year_start = @year_start - 2000
Set @Period_start = DATEADD(year,@year_start,@Period_start) -- then set the year correctly
-- Then move to the correct month
Set @Period_start = DATEADD(month,@month_start-1,@Period_start)
-- Then move to the correct week (let week 5 slide to the next month for now)
Set @Period_start = DATEADD(week,@week_start-1,@Period_start)
-- Now move FORWARD to the correct day (say) the 5th sunday of february
Declare @day_offset int
if (@day_start >=  DatePart(weekday,@Period_start) ) set @day_offset = @day_start -  DatePart(weekday,@Period_start) else  set @day_offset = @day_start -  DatePart(weekday,@Period_start) + 7
Set @Period_start = DATEADD(day,@day_offset,@Period_start)
-- We may have jumped to the next month if week = 5 so step back a week if necessary
if (DatePart(month,@Period_start) > @month_start) set @Period_start = DATEADD(week,-1,@Period_start)
Set @Period_start = DATEADD(minute,@hours_start,@Period_start)  ---TODO check if offset applied OK for 1 hour either side of daylight saving start and end

set @Period_end = ''1 jan 2000'' -- start with a known datetime
set @year_end = @year_end - 2000
Set @Period_end = DATEADD(year,@year_end,@Period_end) -- then adjust it to match the definition
Set @Period_end = DATEADD(month,@month_end-1,@Period_end)
Set @Period_end = DATEADD(week,@week_end-1,@Period_end)
if (@day_end >=  DatePart(weekday,@Period_end) ) set @day_offset = @day_end -  DatePart(weekday,@Period_end) else  set @day_offset = @day_end -  DatePart(weekday,@Period_end) + 7
Set @Period_end = DATEADD(day,@day_offset,@Period_end)
-- We may have jumped to the next month if week = 5 so step back a week if necessary
if (DatePart(month,@Period_end) > @month_end) set @Period_end = DATEADD(week,-1,@Period_end)
Set @Period_end = DATEADD(minute,@hours_end,@Period_end)  ---TODO check if offset applied OK for 1 hour either side of daylight saving start and end
Set @Period_end = DATEADD(minute,-@offset_mins,@Period_end) -- end time is quoted with daylight savings included


IF (@UserLocalTime >= @Period_start)
AND (@UserLocalTime < @Period_end) set @UserLocalTime = DATEADD(minute,@offset_mins,@UserLocalTime)
END
RETURN @UserLocalTime
END
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfUser_GetAdministratorsEmailAddress]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create function [udfUser_GetAdministratorsEmailAddress]
(
@UserID	int
)
Returns varchar(100)
AS
BEGIN
DECLARE @UnitID int
SELECT @UnitID = UnitID FROM tblUser WHERE UserID = @UserID

DECLARE @Email VARCHAR(100)
SELECT @Email = coalesce(
-- try to get the closest unit admin then search further afield
(Select top 1	u.Email
from tblUnitAdministrator ua
inner join tblUser u on ua.userID = u.UserID
where ua.unitID=@unitID
and u.usertypeID=3 --Unit administrator(3)
and u.unitID=@unitID
and u.Email is not null),


(Select top 1	u.Email
from tblUnitAdministrator ua
inner join tblUser u on ua.userID = u.UserID
where ua.unitID=@unitID
and u.usertypeID=3 --Unit administrator(3)
and u.Email is not null),

(Select top 1	u.Email
from tblUser u inner join tblUnit un on un.OrganisationID = u.OrganisationID
where un.unitID=@unitID
and UserTypeID = 2
and Email is not null),


(Select top 1	u.Email
from tblUser u inner join tblUnit un on un.OrganisationID = u.OrganisationID
where un.unitID=@unitID
and UserTypeID = 1
and Email is not null),

--all else failed so get the salt admin
(Select top 1	u.Email
from tblUser u
where UserTypeID = 1
and Email is not null))



return @Email
END
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfUser_GetAdministratorsOnBehalfOfEmailAddress]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE function [udfUser_GetAdministratorsOnBehalfOfEmailAddress]
(
@UserID	int
)
Returns varchar(100)
AS
BEGIN


DECLARE @Email VARCHAR(100)
SELECT @Email = dbo.udfGetEmailOnBehalfOf(0) -- udfGetEmailOnBehalfOf ignores the OrgID so don''t bother sending a correct OrgID


return @Email
END
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udfUTCtoDaylightSavingTime]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [udfUTCtoDaylightSavingTime]
(
@UTC DateTime,
@OrgID int
)
RETURNS DateTime
AS
BEGIN

IF (@UTC is null) RETURN null
DECLARE @OrgLocalTime datetime
DECLARE @UTC_Offset int
DECLARE @Timezone datetime
DECLARE @offset_mins int, @hours_start int, @day_start int, @week_start int, @month_start int, @hours_end int, @day_end int, @week_end int, @month_end int, @year_end int , @year_start int
SELECT @UTC_Offset = TZ.OffsetUTC , @Timezone = TZ.TimezoneID
FROM tblTimeZone TZ
INNER JOIN tblOrganisation Org ON TZ.TimeZoneID = Org.TimeZoneID
WHERE Org.OrganisationID = @OrgID
IF (@UTC_Offset IS NULL)
BEGIN
Set @OrgLocalTime = ''1 Jan 1900'' -- all results are displayed by Reporting Services so create an "error" that will be apparent in Reporting Services
END
ELSE
BEGIN
Set @OrgLocalTime = DATEADD(minute,@UTC_Offset,@UTC )
SELECT  @offset_mins = offset_mins, --get definition of the (at most) 1 definition that may cover the datetime
@hours_start = hours_start, --overlapping definitions removed by GUI so only 1 result returned
@day_start = day_start,
@week_start = week_start,
@month_start = month_start,
@hours_end = hours_end,
@day_end = day_end,
@week_end = week_end,
@month_end = month_end
FROM tblTimeZoneDaylightSavingRules
WHERE  TimezoneID = @Timezone
AND @OrgLocalTime >= first_start_date
AND @OrgLocalTime <= last_end_date

-- start with a period (@Period_start datetime, @period_end datetime) that just has the correct year digits
DECLARE @Period_start datetime, @period_end datetime
Set @year_start = year(@OrgLocalTime)
set @year_end = year(@OrgLocalTime)

if (month(@OrgLocalTime) <= @month_end) and (@month_start > @month_end) set @year_start = @year_start - 1   -- rule spans december 31 so adjust

IF(@month_start > @month_end) and (month(@OrgLocalTime) >= @month_start) set @year_end = @year_start + 1  -- rule spans december 31 so adjust


--Set @year_start = year(@OrgLocalTime) --now calculate the exact start and end dates and times for the year under consideration
--IF(@month_start > @month_end) set @year_end = @year_start+1 else set @year_end = @year_start
--DECLARE @Period_start datetime, @period_end datetime

set @Period_start = ''1 jan 2000'' -- start with a known datetime
set @year_start = @year_start - 2000
Set @Period_start = DATEADD(year,@year_start,@Period_start) -- then set the year correctly
-- Then move to the correct month
Set @Period_start = DATEADD(month,@month_start-1,@Period_start)
-- Then move to the correct week (let week 5 slide to the next month for now)
Set @Period_start = DATEADD(week,@week_start-1,@Period_start)
-- Now move FORWARD to the correct day (say) the 5th sunday of february
Declare @day_offset int
if (@day_start >=  DatePart(weekday,@Period_start) ) set @day_offset = @day_start -  DatePart(weekday,@Period_start) else  set @day_offset = @day_start -  DatePart(weekday,@Period_start) + 7
Set @Period_start = DATEADD(day,@day_offset,@Period_start)
-- We may have jumped to the next month if week = 5 so step back a week if necessary
if (DatePart(month,@Period_start) > @month_start) set @Period_start = DATEADD(week,-1,@Period_start)
Set @Period_start = DATEADD(minute,@hours_start,@Period_start)  ---TODO check if offset applied OK for 1 hour either side of daylight saving start and end

set @Period_end = ''1 jan 2000'' -- start with a known datetime
set @year_end = @year_end - 2000
Set @Period_end = DATEADD(year,@year_end,@Period_end) -- then adjust it to match the definition
Set @Period_end = DATEADD(month,@month_end-1,@Period_end)
Set @Period_end = DATEADD(week,@week_end-1,@Period_end)
if (@day_end >=  DatePart(weekday,@Period_end) ) set @day_offset = @day_end -  DatePart(weekday,@Period_end) else  set @day_offset = @day_end -  DatePart(weekday,@Period_end) + 7
Set @Period_end = DATEADD(day,@day_offset,@Period_end)
-- We may have jumped to the next month if week = 5 so step back a week if necessary
if (DatePart(month,@Period_end) > @month_end) set @Period_end = DATEADD(week,-1,@Period_end)
Set @Period_end = DATEADD(minute,@hours_end,@Period_end)  ---TODO check if offset applied OK for 1 hour either side of daylight saving start and end
Set @Period_end = DATEADD(minute,-@offset_mins,@Period_end) -- end time is quoted with daylight savings included


IF (@OrgLocalTime >= @Period_start)
AND (@OrgLocalTime < @Period_end) set @OrgLocalTime = DATEADD(minute,@offset_mins,@OrgLocalTime)
END
RETURN @OrgLocalTime
END
' 
END
GO


SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udf_GetAdminEmailsForORG]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE  FUNCTION [udf_GetAdminEmailsForORG](@Org INT)
--RETURNS @Result TABLE(UserID INT, UnitID INT, Hierarchy nVARCHAR(500), HierarchyName nVARCHAR(2000))
RETURNS TABLE
AS
RETURN

SELECT
unt.UnitID, uadm.UserID, hier.Hierarchy, hier.HierarchyName
FROM
tblUnitAdministrator uadm
INNER JOIN tblUnit unt ON uadm.UnitID = unt.UnitID AND unt.OrganisationID = @ORG
INNER JOIN tblUnitHierarchy hier ON hier.UnitID = unt.UnitID

--For units with no Unit Admin inform the Organisation Administrator instead
UNION
SELECT
unt.UnitID, ORGadm.UserID, hier.Hierarchy, hier.HierarchyName
FROM
tblUser ORGadm
INNER JOIN tblUnit unt ON ORGadm.OrganisationID = unt.OrganisationID AND ORGadm.OrganisationID = @ORG AND ORGadm.UserTypeID = 2
INNER JOIN tblUnitHierarchy hier ON hier.UnitID = unt.UnitID
WHERE NOT EXISTS
(
SELECT * FROM tblUnitAdministrator uadm WHERE uadm.UnitID = unt.UnitID
)
' 
END
GO


SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udf_GetUnitHierarchiesForORG]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE  FUNCTION [udf_GetUnitHierarchiesForORG](@Org INT)
RETURNS @Result TABLE(UnitID INT, Hierarchy nVARCHAR(500), HierarchyName nVARCHAR(2000))
AS
BEGIN
INSERT INTO @Result
SELECT
A.UnitID, A.Hierarchy, A.HierarchyName
FROM
tblUnitHierarchy A, tblUnit B
WHERE
A.UnitID = B.UnitID AND B.OrganisationID = @ORG

RETURN
END
' 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[udf_GridExportHeaders]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create  FUNCTION [udf_GridExportHeaders](@LangCode varchar(10) = ''en-AU'',
@LangInterfaceName varchar(200) = ''/Reporting/PeriodicReport.aspx'')
--RETURNS @Result TABLE( C1 nVARCHAR(500),C2 nVARCHAR(500), C3 nVARCHAR(500), C4 nVARCHAR(500),C5 nVARCHAR(500),C6 nVARCHAR(500),C7 nVARCHAR(500),C8 nVARCHAR(500),C9 nVARCHAR(500),C10 nVARCHAR(500),C11 nVARCHAR(500))
RETURNS TABLE
AS
RETURN

SELECT 1 AS C1
' 
END
GO



