


if not exists (select * from tblReportType)
begin




declare @ctr int
select @ctr = count(*) from tblEmailQueue
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblEmailQueue') 


update tblEmailQueue set QueuedTime = dbo.ToUTC(QueuedTime), SendStarted = dbo.ToUTC(SendStarted)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblEmailQueue') 





select @ctr = count(*) from tblReportSchedule
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblReportSchedule') 


update tblReportSchedule set LastRun = dbo.ToUTC(LastRun), ReportStartDate = dbo.ToUTC(ReportStartDate),
ParamEffectiveDate = dbo.ToUTC(ParamEffectiveDate)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblReportSchedule') 





select @ctr = count(*) from tblUserCourseStatus
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblUserCourseStatus') 


update tblUserCourseStatus set DateCreated = dbo.ToUTC(DateCreated)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblUserCourseStatus') 







end
go
