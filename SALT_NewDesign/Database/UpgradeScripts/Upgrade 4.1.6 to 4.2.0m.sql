


if not exists (select * from tblReportType)
begin

declare @ctr int
select @ctr = count(*) from tblLangValue
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblLangValue') 


update tblLangValue set DateCreated = dbo.ToUTC(DateCreated), DateModified = dbo.ToUTC(DateModified),
DateDeleted = dbo.ToUTC(DateDeleted)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblLangValue') 



select @ctr = count(*) from tblUserLessonStatus
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblUserLessonStatus') 


update tblUserLessonStatus set LessonCompletionDate = dbo.ToUTC(LessonCompletionDate), DateCreated = dbo.ToUTC(DateCreated)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblUserLessonStatus') 





end
go
