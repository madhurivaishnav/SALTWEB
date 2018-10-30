if exists (select * from dbo.sysobjects where id = object_id(N'[prcLogUsage_Daily]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [prcLogUsage_Daily]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[prcLogUsage_Hourly]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [prcLogUsage_Hourly]
GO


SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE prcLogUsage_Daily
as
Insert
into
	tblLogDaily

SELECT  MAX(tblOrganisation.[OrganisationID]) , 
		COUNT(User_A.User_A) AS '12am - 7am ', 
		COUNT(User_B.User_B) AS ' 7am - 9am ', 
        COUNT(User_C.User_C) AS ' 9am - 11am', 
		COUNT(User_D.User_D) AS '11am - 1pm ', 
		COUNT(User_E.User_E) AS '1pm  - 3pm', 
		COUNT(User_F.User_F) AS ' 3pm - 5pm ', 
		COUNT(User_G.User_G) AS ' 5pm - 7pm', 
		COUNT(User_H.User_H) AS ' 7pm - 12pm ',
		GetDate()
FROM         tblUser INNER JOIN
                      tblOrganisation ON tblUser.OrganisationID = tblOrganisation.OrganisationID LEFT OUTER JOIN
                          (SELECT     UserID AS User_A
                            FROM          tblUser
                            WHERE      DATEPART(hh, LastLogin) >= 0 AND DATEPART(hh, LastLogin) < 7) AS User_A ON UserID = User_A LEFT OUTER JOIN
                          (SELECT     UserID AS User_B
                            FROM          tblUser
                            WHERE      DATEPART(hh, LastLogin) >= 7 AND DATEPART(hh, LastLogin) < 9) AS User_B ON UserID = User_B LEFT OUTER JOIN
                          (SELECT     UserID AS User_C
                            FROM          tblUser
                            WHERE      DATEPART(hh, LastLogin) >= 9 AND DATEPART(hh, LastLogin) < 11) AS User_C ON UserID = User_C LEFT OUTER JOIN
                          (SELECT     UserID AS User_D
                            FROM          tblUser
                            WHERE      DATEPART(hh, LastLogin) >= 11 AND DATEPART(hh, LastLogin) < 13) AS User_D ON UserID = User_D LEFT OUTER JOIN
                          (SELECT     UserID AS User_E
                            FROM          tblUser
                            WHERE      DATEPART(hh, LastLogin) >= 13 AND DATEPART(hh, LastLogin) < 15) AS User_E ON UserID = User_E LEFT OUTER JOIN
                          (SELECT     UserID AS User_F
                            FROM          tblUser
                            WHERE      DATEPART(hh, LastLogin) >= 15 AND DATEPART(hh, LastLogin) < 17) AS User_F ON UserID = User_F LEFT OUTER JOIN
                          (SELECT     UserID AS User_G
                            FROM          tblUser
                            WHERE      DATEPART(hh, LastLogin) >= 17 AND DATEPART(hh, LastLogin) < 19) AS User_G ON UserID = User_G LEFT OUTER JOIN
                          (SELECT     UserID AS User_H
                            FROM          tblUser
                            WHERE      DATEPART(hh, LastLogin) >= 19 AND DATEPART(hh, LastLogin) < 24) AS User_H ON UserID = User_H
GROUP BY tblUser.OrganisationID
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE prcLogUsage_Hourly AS

Insert Into
	tblLogHourly

SELECT  MAX(tblOrganisation.OrganisationID), 
		COUNT(Minute.UserMinute) AS 'Last Minute', 
		COUNT(Hour.UserHour) AS 'Last Hour', 
        COUNT(Days.UserDay) AS 'Last Day', 
		COUNT(Weeks.userWeek) AS 'Last Week', 
		COUNT(Months.UserMonth) AS 'Last Month', 
		COUNT(Years.UserYear) AS 'Last Year',
		GetDate()
FROM         tblUser INNER JOIN
                      tblOrganisation ON tblUser.OrganisationID = tblOrganisation.OrganisationID LEFT OUTER JOIN
                          (SELECT     UserID AS UserYear
                            FROM          tblUser
                            WHERE      DATEDIFF(Year, LastLogin, getdate()) <= 1) AS Years ON UserID = UserYear LEFT OUTER JOIN
                          (SELECT     UserID AS UserMonth
                            FROM          tblUser
                            WHERE      DATEDIFF(Month, LastLogin, getdate()) <= 1) AS Months ON UserID = UserMonth LEFT OUTER JOIN
                          (SELECT     UserID AS UserWeek
                            FROM          tblUser
                            WHERE      DATEDIFF(Week, LastLogin, getdate()) <= 1) AS Weeks ON UserID = UserWeek LEFT OUTER JOIN
                          (SELECT     UserID AS UserDay
                            FROM          tblUser
                            WHERE      DATEDIFF(Day, LastLogin, getdate()) <= 1) AS Days ON UserID = UserDay LEFT OUTER JOIN
                          (SELECT     UserID AS UserHour
                            FROM          tblUser
                            WHERE      DATEDIFF(Hour, LastLogin, getdate()) <= 1) AS Hour ON UserID = UserHour LEFT OUTER JOIN
                          (SELECT     UserID AS UserMinute
                            FROM          tblUser
                            WHERE      DATEDIFF(Minute, LastLogin, getdate()) <= 1) AS Minute ON UserID = UserMinute
GROUP BY tblUser.OrganisationID
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

 