if exists (select * from sysobjects where id = object_id(N'[vwDaily_Average]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [vwDaily_Average]
GO

if exists (select * from sysobjects where id = object_id(N'[vwDaily_Max]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [vwDaily_Max]
GO

if exists (select * from sysobjects where id = object_id(N'[vwHourly_MostRecent]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [vwHourly_MostRecent]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW vwDaily_Average
AS
	SELECT     
			tblLogDaily.OrganisationID, 
			MAX(tblOrganisation.OrganisationName) AS 'OrganisationName', 
			AVG(tblLogDaily.TimePeriod1) AS [Before 7am], 
			AVG(tblLogDaily.TimePeriod2) AS [7am to 9am], 
			AVG(tblLogDaily.TimePeriod3) AS [9am to 11am], 
			AVG(tblLogDaily.TimePeriod4) AS [11am to 1pm], 
			AVG(tblLogDaily.TimePeriod5) AS [1pm to 3pm], 
			AVG(tblLogDaily.TimePeriod6) AS [3pm to 5pm], 
			AVG(tblLogDaily.TimePeriod7) AS [5pm to 7pm], 
			AVG(tblLogDaily.TimePeriod8) AS [After 7pm]
	FROM         
			tblLogDaily 
			
	INNER JOIN
			tblOrganisation 

	ON tblOrganisation.OrganisationID = tblLogDaily.OrganisationID
	        
	GROUP BY tblLogDaily.OrganisationID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW vwDaily_Max
AS
	SELECT     
		tblLogDaily.OrganisationID, 
		MAX(tblOrganisation.OrganisationName) AS 'OrganisationName', 
		MAX(tblLogDaily.TimePeriod1) AS [Before 7am], 
		MAX(tblLogDaily.TimePeriod2) AS [7am to 9am], 
		MAX(tblLogDaily.TimePeriod3) AS [9am to 11am], 
		MAX(tblLogDaily.TimePeriod4) AS [11am to 1pm], 
		MAX(tblLogDaily.TimePeriod5) AS [1pm to 3pm], 
		MAX(tblLogDaily.TimePeriod6) AS [3pm to 5pm], 
		MAX(tblLogDaily.TimePeriod7) AS [5pm to 7pm], 
		MAX(tblLogDaily.TimePeriod8) AS [After 7pm]
	FROM         
		tblLogDaily 
	INNER JOIN
		tblOrganisation 
	ON 
		tblOrganisation.OrganisationID = tblLogDaily.OrganisationID
	GROUP BY 
		tblLogDaily.OrganisationID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW vwHourly_MostRecent
AS
	SELECT     
		tblLogHourly.OrganisationID, 
		tblOrganisation.OrganisationName, 
		tblLogHourly.TimePeriod1 AS [Last Minute], 
		tblLogHourly.TimePeriod2 AS [Last Hour], 
		tblLogHourly.TimePeriod3 AS [Last Day], 
		tblLogHourly.TimePeriod4 AS [Last Week], 
		tblLogHourly.TimePeriod5 AS [Last Month], 
		tblLogHourly.TimePeriod6 AS [Last Year],
		tblLogHourly.DateCreated
	FROM         
		tblLogHourly 
	INNER JOIN
		tblOrganisation 
	ON 
		tblOrganisation.OrganisationID = tblLogHourly.OrganisationID
	WHERE     
		(
			tblLogHourly.DateCreated = (SELECT MAX(datecreated) FROM tblLogHourly)
		)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

