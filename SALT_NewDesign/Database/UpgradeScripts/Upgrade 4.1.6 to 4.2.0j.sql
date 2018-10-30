


if not exists (select * from tblReportType)
begin



declare @ctr int
select @ctr = count(*) from tblQuizSession
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblQuizSession') 


update tblQuizSession set DateTimeStarted = dbo.ToUTC(DateTimeStarted), DateTimeCompleted = dbo.ToUTC(DateTimeCompleted)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblQuizSession') 




select @ctr = count(*) from tblProfilePeriod
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblProfilePeriod') 


update tblProfilePeriod set DateStart = dbo.ToUTC(DateStart), DateEnd = dbo.ToUTC(DateEnd), 
FutureDateStart = dbo.ToUTC(FutureDateStart),FutureDateEnd = dbo.ToUTC(FutureDateEnd)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblProfilePeriod') 





select @ctr = count(*) from tblLangInterface
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblLangInterface') 


update tblLangInterface set DateCreated = dbo.ToUTC(DateCreated), DateModified = dbo.ToUTC(DateModified),
DateDeleted = dbo.ToUTC(DateDeleted)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblLangInterface') 



end
go
