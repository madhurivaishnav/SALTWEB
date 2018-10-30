


if not exists (select * from tblReportType)
begin


declare @ctr int
select @ctr = count(*) from tblQuizQuestionAudit
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblQuizQuestionAudit') 


update tblQuizQuestionAudit set DateAccessed = dbo.ToUTC(DateAccessed)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblQuizQuestionAudit') 







select @ctr = count(*) from tblUserQuizStatus
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblUserQuizStatus') 


update tblUserQuizStatus set QuizCompletionDate = dbo.ToUTC(QuizCompletionDate), DateCreated = dbo.ToUTC(DateCreated)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblUserQuizStatus') 






select @ctr = count(*) from tblUnitAdministrator
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblUnitAdministrator') 


update tblUnitAdministrator set DateCreated = dbo.ToUTC(DateCreated)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblUnitAdministrator') 






end
go
