


if not exists (select * from tblReportType)
begin


declare @ctr int
select @ctr = count(*) from tblCourseLicensingUser
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblCourseLicensingUser') 


update tblCourseLicensingUser set LicenseDate = dbo.ToUTC(LicenseDate)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblCourseLicensingUser') 








select @ctr = count(*) from tblLink
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblLink') 


update tblLink set DateCreated = dbo.ToUTC(DateCreated), DateUpdated = dbo.ToUTC(DateUpdated)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblLink') 






select @ctr = count(*) from tblModule
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblModule') 


update tblModule set DateCreated = dbo.ToUTC(DateCreated), DateUpdated = dbo.ToUTC(DateUpdated)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblModule') 





end
go
