


if not exists (select * from tblReportType)
begin



declare @ctr int
select @ctr = count(*) from tblLessonPageAudit
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblLessonPageAudit') 


update tblLessonPageAudit set DateAccessed = dbo.ToUTC(DateAccessed)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblLessonPageAudit') 








select @ctr = count(*) from tblUserCPDPoints
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblUserCPDPoints') 


update tblUserCPDPoints set DateAssigned = dbo.ToUTC(DateAssigned)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblUserCPDPoints') 





select @ctr = count(*) from tblBookmark
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblBookmark') 


update tblBookmark set DateCreated = dbo.ToUTC(DateCreated)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblBookmark') 





end
go
