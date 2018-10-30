IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[vwDaily_Average]'))
DROP VIEW [vwDaily_Average]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[vwDaily_Average]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [vwDaily_Average]
AS
	SELECT     
			tblLogDaily.OrganisationID, 
			MAX(tblOrganisation.OrganisationName) AS ''OrganisationName'', 
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

'
GO


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[vwDaily_Max]'))
DROP VIEW [vwDaily_Max]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[vwDaily_Max]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [vwDaily_Max]
AS
	SELECT     
		tblLogDaily.OrganisationID, 
		MAX(tblOrganisation.OrganisationName) AS ''OrganisationName'', 
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

'
GO


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[vwHourly_MostRecent]'))
DROP VIEW [vwHourly_MostRecent]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[vwHourly_MostRecent]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [vwHourly_MostRecent]
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

'
GO


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[vwUnitModuleRule]'))
DROP VIEW [vwUnitModuleRule]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[vwUnitModuleRule]'))
EXEC dbo.sp_executesql @statement = N'
/*Summary:
	Gets unit module compliance rules

Returns:
	table
		
Called By: 

Calls:

Remarks:
	

	
Author:
Jack Liu
Date Created: 23 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	mikev		1/5/2007		Added Completion dates to view. There is a business rule which says that you cannot have both frequency and date fields for lesson and quiz. There is a ISNULL in the view which uses the organisation''s default frequency. Note, that when frequency is not used, it will have a value of null; so I don''t see a problem with using the default value in this case.
--------------------
*/
CREATE view [vwUnitModuleRule]
as
Select 	u.UnitID,
	m.CourseID,
	m.ModuleID,
	m.Name,
	case 
		when ur.unitID is null then cast(1 as bit)
		else cast(0 as bit)
	end as UsingDefault,
	case 
		when (ur.LessonFrequency is null and ur.LessonCompletionDate is null and o.DefaultLessonCompletionDate is null) then 
			o.DefaultLessonFrequency
		else 
			ur.LessonFrequency
		end 
	as LessonFrequency, 
	case 
		when (ur.QuizFrequency is null and ur.QuizCompletionDate is null and o.DefaultQuizCompletionDate is null) then 
			o.DefaultQuizFrequency
		else 
			ur.QuizFrequency
		end 
	as QuizFrequency, 
	isNull(ur.QuizPassMark, o.DefaultQuizPassMark) as QuizPassMark,
	case 
		when (ur.LessonFrequency is null and ur.LessonCompletionDate is null and not(o.DefaultLessonCompletionDate is null)) then 
			o.DefaultLessonCompletionDate
		else
			ur.LessonCompletionDate
		end 
	as LessonCompletionDate,
	case 
		when (ur.QuizFrequency is null and ur.QuizCompletionDate is null and not(o.DefaultQuizCompletionDate is null)) then 
			o.DefaultQuizCompletionDate
		else
			ur.QuizCompletionDate
		end 
	as QuizCompletionDate
From tblOrganisationCourseAccess c
	inner join tblModule m
		on m.CourseID = c.GrantedCourseID
	inner join tblOrganisation o  -- Get default compliance rules
		on o.OrganisationID = c.OrganisationID
	inner join tblUnit u
		on u.OrganisationID = c.OrganisationID
	left join tblUnitRule ur --Get the unit specific rules
		on ur.ModuleID = m.ModuleID 
			and ur.UnitID=u.unitID




'
GO


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[vwUserCourseStatus]'))
DROP VIEW [vwUserCourseStatus]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[vwUserCourseStatus]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [vwUserCourseStatus]
AS
SELECT     tUCS.UserCourseStatusID, tUCS.UserID, tUCS.CourseID, tUCS.CourseStatusID, tUCS.ModulesAssigned, tUCS.DateCreated,
(SELECT     MAX(DateCreated) AS Expr1
FROM          dbo.tblUserCourseStatus
WHERE      (tUCS.CourseStatusID = 1) AND (UserID = tUCS.UserID) AND (CourseID = tUCS.CourseID) AND (CourseStatusID = 2) AND
(UserCourseStatusID < tUCS.UserCourseStatusID)) AS LastCompleted
FROM         dbo.tblUserCourseStatus AS tUCS INNER JOIN
dbo.tblCourse AS tC ON tC.CourseID = tUCS.CourseID AND tC.Active = 1 INNER JOIN
(SELECT     MAX(UserCourseStatusID) AS UserCourseStatusID
FROM          dbo.tblUserCourseStatus AS tblUserCourseStatus_1
GROUP BY UserID, CourseID) AS currentStatus ON tUCS.UserCourseStatusID = currentStatus.UserCourseStatusID



' 
GO




IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[vwUserLessonStatus]'))
DROP VIEW [vwUserLessonStatus]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[vwUserLessonStatus]'))
EXEC dbo.sp_executesql @statement = N'
CREATE  VIEW [vwUserLessonStatus]
AS
select 	LessonStatus.UserLessonStatusID,
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
group by 	UserID,moduleID) currentStatus
on LessonStatus.UserLessonStatusID = currentStatus.UserLessonStatusID
where LessonStatus.Excluded = 0 or LessonStatus.Excluded is null


' 
GO




IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[vwUserModuleAccess]'))
DROP VIEW [vwUserModuleAccess]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[vwUserModuleAccess]'))
EXEC dbo.sp_executesql @statement = N'
/*Summary:
	Gets the current granted modules for each user
Returns:
	table
		
Called By: 

Calls:

Remarks:
	This view gets a list of all active modules that each user can access today.

	
Author:
Stephen Kennedy-Clark
Date Created: 6 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	Jack Liu	18/03/2003		Module can be specially granted or denied to a user,
						It overwrites the unit module access profile. 
						e.g. a module is denied acccess to a unit, but still can be granted access to a user in this unit

--------------------

select * from vwUserModuleAccess

*/


CREATE     VIEW [vwUserModuleAccess]
AS
Select
	tU.UserID
	, tU.FirstName 
	, tU.LastName
	, tU.UnitID
	, tU.OrganisationID
	, tM.ModuleID
	, tM.CourseID
	, tC.Name ''CourseName''
	, tM.Name
	, tM.Sequence
	, tM.Description
From
	dbo.tblUser tU
	--< get the courses a user has access to >--
	Inner Join dbo.tblOrganisationCourseAccess tOCA
		On  tOCA.OrganisationID = tU.OrganisationID
	--< get the course details >--
	Inner join dbo.tblCourse tC
		On tC.CourseID = tOCA.GrantedCourseID
	--< get the Active modules in a course >--
	inner join dbo.tblModule tM
		On tM.CourseID = tC.CourseID 
			and tM.Active = 1
	--< get the details on which moduels a user is configured to access >--
	Left Outer join dbo.tblUserModuleAccess tUsrMA
		On  tUsrMA.UserID = tU.UserID
			And tUsrMA.ModuleID = tM.ModuleID
	--< get the details on which moduels a user''s Unit is excluded from  >--
	Left Outer Join dbo.tblUnitModuleAccess tUnitMA
		On  tUnitMA.UnitID = tU.UnitID
			And tUnitMA.DeniedModuleID = tM.ModuleID
Where	
    tU.Active = 1
    --< Active users only >--
    and tu.UnitID is not null
	--< Get the modules that the user''s Unit is not denied >--
	and (tUnitMA.DeniedModuleID  is null
	--<  and the user does not have special access to  it>--
		And tUsrMA.ModuleID is null)
	--< or Get modules that the user has been specially  granted 
	or tUsrMA.Granted=1


















'
GO


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[vwUserQuizStatus]'))
DROP VIEW [vwUserQuizStatus]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[vwUserQuizStatus]'))
EXEC dbo.sp_executesql @statement = N'
/*Summary:
gets the latest quiz results for each user
Returns:
table

Called By:
prcModule_GetDetailsForHomePage
prcIndividualReport
Calls:

Remarks:
--// The quiz status details we need are in the table tblUserQuizStatus
--// However this table contains historic as well as current data
--// The view below gets only the latest results for each user <-> module
--// This is evectivly a Remove Duplicates problem
--// Where the duplicate is defined as having the same UserID and ModuleID
--// but a different Primary Key. Only the row with the latest PK is returned

Author:
Jack Liu
Date Created: 17 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


--------------------
prcModule_GetDetailsForHomePage @userID = 11, @courseID=1
*/

CREATE   VIEW [vwUserQuizStatus]
AS
select
QuizStatus.UserQuizStatusID
, QuizStatus.UserID
, QuizStatus.ModuleID
, m.CourseID
, QuizStatus.QuizStatusID
, QuizStatus.QuizFrequency
, QuizStatus.QuizPassMark
, QuizStatus.QuizSessionID
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
group by
UserID,moduleID
) currentStatus
on QuizStatus.UserQuizStatusID = currentStatus.UserQuizStatusID
where m.active = 1



'
GO



