SELECT     
	MAX(tblOrganisation.OrganisationName) AS OrganisationName, 
	COUNT(Minute.UserMinute)	AS 'Last Minute', 
	COUNT(Hour.UserHour)		AS 'Last Hour', 
    COUNT(Days.UserDay)			AS 'Last Day',
    COUNT(Weeks.userWeek)		AS 'Last Week', 
    COUNT(Months.UserMonth)		AS 'Last Month', 
    COUNT(Years.UserYear)		AS 'Last Year'
FROM         
	tblUser 

INNER JOIN
                     
	tblOrganisation ON tblUser.OrganisationID = tblOrganisation.OrganisationID 
	
LEFT OUTER JOIN
    (SELECT     UserID AS UserYear
    FROM          tblUser
    WHERE      DATEDIFF(Year, LastLogin, getdate()) <= 1) 
    AS Years ON UserID = UserYear 
    
LEFT OUTER JOIN
    
    (SELECT     UserID AS UserMonth
    FROM          tblUser
    WHERE      DATEDIFF(Month, LastLogin, getdate()) <= 1) 
    AS Months ON UserID = UserMonth 
    
LEFT OUTER JOIN
    
    (SELECT     UserID AS UserWeek
    FROM          tblUser
    WHERE      DATEDIFF(Week, LastLogin, getdate()) <= 1) 
    AS Weeks ON UserID = UserWeek 
    
LEFT OUTER JOIN

    (SELECT     UserID AS UserDay
    FROM          tblUser
    WHERE      DATEDIFF(Day, LastLogin, getdate()) <= 1) 
    AS Days ON UserID = UserDay 
    
LEFT OUTER JOIN
    
    (SELECT     UserID AS UserHour
    FROM          tblUser
    WHERE      DATEDIFF(Hour, LastLogin, getdate()) <= 1) 
    AS Hour ON UserID = UserHour 
    
LEFT OUTER JOIN
    
    (SELECT     UserID AS UserMinute
    FROM          tblUser
    WHERE      DATEDIFF(Minute, LastLogin, getdate()) <= 1) 
    AS Minute ON UserID = UserMinute
    
GROUP BY tblUser.OrganisationID 