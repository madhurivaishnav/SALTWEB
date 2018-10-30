


if not exists (select * from tblReportType)
begin

declare @ctr int
select @ctr = count(*) from tblOrganisation
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblOrganisation') 


update tblOrganisation set DefaultLessonCompletionDate = dbo.ToUTC(DefaultLessonCompletionDate), 
DefaultQuizCompletionDate = dbo.ToUTC(DefaultQuizCompletionDate), 
DateCreated = dbo.ToUTC(DateCreated), DateUpdated = dbo.ToUTC(DateUpdated),
CourseStatusLastUpdated = dbo.ToUTC(CourseStatusLastUpdated),
DelinquenciesLastNotified = dbo.ToUTC(DelinquenciesLastNotified)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblOrganisation') 






select @ctr = count(*) from tblLessonSession
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblLessonSession') 


update tblLessonSession set DateTimeStarted = dbo.ToUTC(DateTimeStarted), DateTimeCompleted = dbo.ToUTC(DateTimeCompleted)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblLessonSession') 






select @ctr = count(*) from tblQuiz
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblQuiz') 


update tblQuiz set DatePublished = dbo.ToUTC(DatePublished), DateLoaded = dbo.ToUTC(DateLoaded)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblQuiz') 




end
go
