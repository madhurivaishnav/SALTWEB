


if not exists (select * from tblReportType)
begin


declare @ctr int
select @ctr = count(*) from tblLangValueArchive
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblLangValueArchive') 


update tblLangValueArchive set DateCreated = dbo.ToUTC(DateCreated)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblLangValueArchive') 




select @ctr = count(*) from tblLogDaily
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblLogDaily') 


update tblLogDaily set DateCreated = dbo.ToUTC(DateCreated)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblLogDaily') 




select @ctr = count(*) from tblLogHourly
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblLogHourly') 


update tblLogHourly set DateCreated = dbo.ToUTC(DateCreated)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblLogHourly') 



end
go
