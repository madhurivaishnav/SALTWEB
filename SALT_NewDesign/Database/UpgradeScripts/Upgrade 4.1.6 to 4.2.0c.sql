


if not exists (select * from tblReportType)
begin


declare @ctr int
select @ctr = count(*) from tblModuleStatusUpdateHistory
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblModuleStatusUpdateHistory') 


update tblModuleStatusUpdateHistory set StartTime = dbo.ToUTC(StartTime), FinishTime = dbo.ToUTC(FinishTime)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblModuleStatusUpdateHistory') 





select @ctr = count(*) from tblUserCourseDetails
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblUserCourseDetails') 


update tblUserCourseDetails set LastDelinquencyNotification = dbo.ToUTC(LastDelinquencyNotification)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblUserCourseDetails') 







select @ctr = count(*) from tblCourseLicensing
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblCourseLicensing') 


update tblCourseLicensing set DateStart = dbo.ToUTC(DateStart), DateEnd = dbo.ToUTC(DateEnd), 
DateLicenseWarnEmailSent = dbo.ToUTC(DateLicenseWarnEmailSent), DateWarn = dbo.ToUTC(DateWarn),
DateExpiryWarnEmailSent = dbo.ToUTC(DateExpiryWarnEmailSent)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblCourseLicensing') 




end
go
