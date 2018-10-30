


if not exists (select * from tblReportType)
begin

declare @ctr int
select @ctr = count(*) from tblUnitRule
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records  on table tblUnitRule') 

update tblUnitRule set LessonCompletionDate = dbo.ToUTC(LessonCompletionDate), QuizCompletionDate = dbo.ToUTC(QuizCompletionDate), 
DateCreated= dbo.ToUTC(DateCreated), DateUpdated = dbo.ToUTC(DateUpdated)

insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records  on table tblUnitRule') 



select @ctr = count(*) from tblUserPolicyAccepted
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records  on table tblUserPolicyAccepted') 

update tblUserPolicyAccepted set DateAccepted = dbo.ToUTC(DateAccepted)

insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records  on table tblUserPolicyAccepted') 



select @ctr = count(*) from tblCourse
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records  on table tblCourse') 

update tblCourse set DateCreated = dbo.ToUTC(DateCreated), DateUpdated = dbo.ToUTC(DateUpdated)

insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records  on table tblCourse') 



end
go
