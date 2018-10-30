SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prc_ADMIN_LessonPageAuditPagesVisited]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create proc [prc_ADMIN_LessonPageAuditPagesVisited]

@OrgID int

as

select
left(tblOrganisation.OrganisationName, 25) as [Org Name]
, left(tblUser.Firstname + '' '' + tblUser.LastName, 25) as [username]
, left(tblCourse.Name + ''/'' + tblModule.Name, 65) as [Course / Module]
, left(tblLessonPage.ToolbookPageID + ''/'' + tblLessonPage.Title, 50) [Page id / name]
, dbo.udfUTCtoDaylightSavingTime(tblLessonPageAudit.DateAccessed, @OrgID)
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
tblLessonSession.dATEtIMECompleted > ''2004-11-23''
and tblOrganisation.OrganisationID <> 8
order by tblOrganisation.OrganisationName, tblUser.LastName, tblLessonSession.LessonSessionID desc

' 
END
GO
