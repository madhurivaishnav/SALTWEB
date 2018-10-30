SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcLogUsage_Hourly]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [prcLogUsage_Hourly] AS

Insert Into
tblLogHourly ([OrganisationID]
,[TimePeriod1]
,[TimePeriod2]
,[TimePeriod3]
,[TimePeriod4]
,[TimePeriod5]
,[TimePeriod6]
,[DateCreated] )


SELECT  MAX(tblOrganisation.OrganisationID),
COUNT(Minute.UserMinute) AS ''Last Minute'',
COUNT(Hour.UserHour) AS ''Last Hour'',
COUNT(Days.UserDay) AS ''Last Day'',
COUNT(Weeks.userWeek) AS ''Last Week'',
COUNT(Months.UserMonth) AS ''Last Month'',
COUNT(Years.UserYear) AS ''Last Year'',
GetUTCDate()
FROM         tblUser INNER JOIN
tblOrganisation ON tblUser.OrganisationID = tblOrganisation.OrganisationID LEFT OUTER JOIN
(SELECT     UserID AS UserYear
FROM          tblUser
WHERE      DATEDIFF(Year, LastLogin, getutcdate()) <= 1) AS Years ON UserID = UserYear LEFT OUTER JOIN
(SELECT     UserID AS UserMonth
FROM          tblUser
WHERE      DATEDIFF(Month, LastLogin, getutcdate()) <= 1) AS Months ON UserID = UserMonth LEFT OUTER JOIN
(SELECT     UserID AS UserWeek
FROM          tblUser
WHERE      DATEDIFF(Week, LastLogin, getutcdate()) <= 1) AS Weeks ON UserID = UserWeek LEFT OUTER JOIN
(SELECT     UserID AS UserDay
FROM          tblUser
WHERE      DATEDIFF(Day, LastLogin, getutcdate()) <= 1) AS Days ON UserID = UserDay LEFT OUTER JOIN
(SELECT     UserID AS UserHour
FROM          tblUser
WHERE      DATEDIFF(Hour, LastLogin, getutcdate()) <= 1) AS Hour ON UserID = UserHour LEFT OUTER JOIN
(SELECT     UserID AS UserMinute
FROM          tblUser
WHERE      DATEDIFF(Minute, LastLogin, getutcdate()) <= 1) AS Minute ON UserID = UserMinute
GROUP BY tblUser.OrganisationID
' 
END
GO
