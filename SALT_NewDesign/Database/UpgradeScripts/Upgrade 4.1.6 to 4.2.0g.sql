


if not exists (select * from tblReportType)
begin






declare @ctr int

select @ctr = count(*) from tblUnit
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblUnit') 


update tblUnit set DateCreated = dbo.ToUTC(DateCreated), DateUpdated = dbo.ToUTC(DateUpdated)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblUnit') 




select @ctr = count(*) from tblLang
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblLang') 


update tblLang set DateCreated = dbo.ToUTC(DateCreated), DateModified = dbo.ToUTC(DateModified),
DateDeleted = dbo.ToUTC(DateDeleted)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblLang') 





end
go
