


if not exists (select * from tblReportType)
begin

declare @ctr int
select @ctr = count(*) from tblLangResource
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblLangResource') 


update tblLangResource set DateCreated = dbo.ToUTC(DateCreated), DateModified = dbo.ToUTC(DateModified),
DateDeleted = dbo.ToUTC(DateDeleted)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblLangResource') 






end
go
