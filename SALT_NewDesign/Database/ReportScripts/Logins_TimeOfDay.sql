SELECT     
	MAX(tblOrganisation.OrganisationName) AS OrganisationName, 
	COUNT(User_A.User_A)		AS '12am - 7am ',
	COUNT(User_B.User_B)		AS ' 7am - 9am ',
	COUNT(User_C.User_C)		AS ' 9am - 11am',
	COUNT(User_D.User_D)		AS '11am - 1pm ',
	COUNT(User_E.User_E)		AS '1pm  - 3pm',
	COUNT(User_F.User_F)		AS ' 3pm - 5pm ',
	COUNT(User_G.User_G)		AS ' 5pm - 7pm',
	COUNT(User_H.User_H)		AS ' 7pm - 12pm '
FROM         
	tblUser 

INNER JOIN
                     
	tblOrganisation ON tblUser.OrganisationID = tblOrganisation.OrganisationID 
	
LEFT OUTER JOIN
    (SELECT     UserID AS User_A
    FROM          tblUser
    WHERE      DATEPART(hh, LastLogin) >= 0 AND DATEPART(hh, LastLogin) <7)
    AS User_A ON UserID = User_A 
    
LEFT OUTER JOIN
    (SELECT     UserID AS User_B
    FROM          tblUser
    WHERE      DATEPART(hh, LastLogin) >= 7 AND DATEPART(hh, LastLogin) <9)
    AS User_B ON UserID = User_B
    

LEFT OUTER JOIN
    (SELECT     UserID AS User_C
    FROM          tblUser
    WHERE      DATEPART(hh, LastLogin) >= 9 AND DATEPART(hh, LastLogin) <11)
    AS User_C ON UserID = User_C


LEFT OUTER JOIN
    (SELECT     UserID AS User_D
    FROM          tblUser
    WHERE      DATEPART(hh, LastLogin) >= 11 AND DATEPART(hh, LastLogin) <13)
    AS User_D ON UserID = User_D

LEFT OUTER JOIN
    (SELECT     UserID AS User_E
    FROM          tblUser
    WHERE      DATEPART(hh, LastLogin) >= 13 AND DATEPART(hh, LastLogin) <15)
    AS User_E ON UserID = User_E

LEFT OUTER JOIN
    (SELECT     UserID AS User_F
    FROM          tblUser
    WHERE      DATEPART(hh, LastLogin) >= 15 AND DATEPART(hh, LastLogin) <17)
    AS User_F ON UserID = User_F

LEFT OUTER JOIN
    (SELECT     UserID AS User_G
    FROM          tblUser
    WHERE      DATEPART(hh, LastLogin) >= 17 AND DATEPART(hh, LastLogin) <19)
    AS User_G ON UserID = User_G


LEFT OUTER JOIN
    (SELECT     UserID AS User_H
    FROM          tblUser
    WHERE      DATEPART(hh, LastLogin) >= 19 AND DATEPART(hh, LastLogin) <24)
    AS User_H ON UserID = User_H

GROUP BY tblUser.OrganisationID  
