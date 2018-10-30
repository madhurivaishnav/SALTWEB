


if not exists (select * from tblReportType)
begin

declare @ctr int
select @ctr = count(*) from tblUserCurrentLessonStatus
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records  on table on table tblUserCurrentLessonStatus') 

update tblUserCurrentLessonStatus set DateCreated = dbo.ToUTC(DateCreated), LessonCompletionDate = dbo.ToUTC(LessonCompletionDate)

insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records  on table on table tblUserCurrentLessonStatus')



select @ctr = count(*) from tblPolicy
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records  on table on table tblPolicy') 

update tblPolicy set UploadDate = dbo.ToUTC(UploadDate)

insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblPolicy')



select @ctr = count(*) from tblProfilePoints
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblProfilePoints') 

update tblProfilePoints set DateAssigned = dbo.ToUTC(DateAssigned)

insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblProfilePoints')



end
go
