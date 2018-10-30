if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prc_ADMIN_LessonPageAuditPagesVisited]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prc_ADMIN_LessonPageAuditPagesVisited]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

create proc prc_ADMIN_LessonPageAuditPagesVisited

as

select
	left(tblOrganisation.OrganisationName, 25) as [Org Name]
	, left(tblUser.Firstname + ' ' + tblUser.LastName, 25) as [username]
	, left(tblCourse.Name + '/' + tblModule.Name, 65) as [Course / Module]
	, left(tblLessonPage.ToolbookPageID + '/' + tblLessonPage.Title, 50) [Page id / name]
	, tblLessonPageAudit.DateAccessed
From
	tblLessonPageAudit
	inner join .tblLessonSession on tblLessonPageAudit.LessonSessionID = tblLessonSession.LessonSessionID
	inner join tblUser on tblLessonSession.UserID = tblUser.userID
	inner join tblOrganisation on tblOrganisation.OrganisationID = tblUser.OrganisationID
	inner join tblLessonPage on tblLessonPage.LessonPageID = tblLessonPageAudit.LessonPageID
	inner join tblLesson on tblLesson.LessonID = .tblLessonPage.LessonID
	inner join tblModule on tblModule.moduleid = tblLesson.moduleID
	inner join tblCourse on tblModule.courseid = tblCourse.courseid
where
	tblLessonSession.dATEtIMECompleted > '2004-11-23'
	and tblOrganisation.OrganisationID <> 8
order by tblOrganisation.OrganisationName, tblUser.LastName, tblLessonSession.LessonSessionID desc


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

 