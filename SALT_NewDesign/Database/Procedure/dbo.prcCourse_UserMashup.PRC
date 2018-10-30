SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcCourse_UserMashup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:		Compiles a %COURSE_NAMES% block and returns it with a bunch of user info for sending email to that user
Parameters:		Comma separated list of userID:courseID
Returns:		table (lastname nvarchar(50), firstname nvarchar(50), userid int, email nvarchar(100), course_names varchar(8000))

Called By:		BusinessServices.Course.GetUserMashup in Course.cs
Calls:			None

Remarks:		None

Author:			Mark Donald
Date Created:	13 Nov 2009

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE PROCEDURE [prcCourse_UserMashup]
@input_csv varchar(8000),
@user_ids varchar(8000)
AS
BEGIN
SET NOCOUNT ON;

DECLARE @mashup TABLE (userid int, courseid int)
DECLARE @selected_users TABLE (userid int)
DECLARE @result TABLE (firstname nvarchar(50), lastname nvarchar(50), userid int, email nvarchar(100), course_names varchar(8000))
DECLARE
@pos int,
@colon_pos int,
@temp varchar(50),
@userid int,
@course_names varchar(8000)

-- rip the user selection
INSERT INTO @selected_users
SELECT
*
FROM
dbo.udfCsvToInt(@user_ids)

-- clean up the input so it resembles ''userid:courseid,userid:courseid,''
SELECT @input_csv = replace(rtrim(ltrim(replace(replace(replace(@input_csv,'' '',''''),'',,'','',''),'','','' ''))),'' '','','') + '',''

-- rip the csv into a table
WHILE patindex(''%,%'', @input_csv) <> 0
BEGIN
SELECT @pos = patindex(''%,%'', @input_csv)
SELECT @temp = left(@input_csv, @pos - 1)
SELECT @colon_pos = patindex(''%:%'', @input_csv)
INSERT @mashup VALUES (
cast(substring(@temp, 1, @colon_pos - 1) AS int),
cast(substring(@temp, @colon_pos + 1, len(@temp)) AS int)
)
SELECT @input_csv = substring(@input_csv, @pos + 1, len(@input_csv))
END

-- Note to self: if the reporting server environment is ever upgraded
-- to SQL Server 2005+ we can improve performace by dicing the cursor
-- and @result table in favour of a UDA function... (UDAs are not
-- available in SS2000)
SELECT @course_names = ''<BR>&nbsp;''
DECLARE concatenator CURSOR READ_ONLY FOR
SELECT
userid
FROM
@selected_users
OPEN concatenator
FETCH NEXT FROM concatenator INTO @userid
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT
@course_names = @course_names + [name] + ''<BR>&nbsp;''
FROM
tblcourse c, @mashup m
WHERE
c.courseid = m.courseid
AND userid = @userid
INSERT INTO
@result
SELECT
lastname, firstname, userid, email, @course_names
FROM
tbluser
WHERE
userid = @userid
SELECT @course_names = ''<BR>&nbsp;''
FETCH NEXT FROM concatenator INTO @userid
END
CLOSE concatenator
DEALLOCATE concatenator

SELECT * FROM @result
END
' 
END
GO
