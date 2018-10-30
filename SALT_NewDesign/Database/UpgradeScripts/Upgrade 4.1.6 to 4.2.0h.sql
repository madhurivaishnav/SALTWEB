


if not exists (select * from tblReportType)
begin


declare @ctr int
select @ctr = count(*) from tblUser
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblUser') 


update tblUser set DateArchived = dbo.ToUTC(DateArchived), DateCreated = dbo.ToUTC(DateCreated), 
DateUpdated = dbo.ToUTC(DateUpdated), LastLogin = dbo.ToUTC(LastLogin)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblUser') 





end
go
