


if not exists (select * from tblReportType)
begin


declare @ctr int
select @ctr = count(*) from tblEmail
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblEmail') 


update tblEmail set DateCreated = dbo.ToUTC(DateCreated)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblEmail') 



select @ctr = count(*) from tblErrorLog
insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Starting update of '+ convert(varchar(100),@ctr) +' records on table tblErrorLog') 


update tblErrorLog set DateCreated = dbo.ToUTC(DateCreated), DateUpdated = dbo.ToUTC(DateUpdated)


insert into tbllogInstall42 (logdatetime, logmessage) values (GETDATE(), 'Complete update of '+ convert(varchar(100),@ctr) +' records on table tblErrorLog') 






end
go


delete from tblReportType
INSERT [dbo].[tblReportType] ([Type], [Name], [Description], [ServerVersion]) VALUES (N'X', N'XML', N'XML file with report data', N'2008')
INSERT [dbo].[tblReportType] ([Type], [Name], [Description], [ServerVersion]) VALUES (N'C', N'CSV', N'CSV (comma delimited)', N'2008')
INSERT [dbo].[tblReportType] ([Type], [Name], [Description], [ServerVersion]) VALUES (N'P', N'PDF', N'Acrobat (PDF) file', N'2008')
INSERT [dbo].[tblReportType] ([Type], [Name], [Description], [ServerVersion]) VALUES (N'H', N'HTML4.0', N'HTML4.0', N'2008')
INSERT [dbo].[tblReportType] ([Type], [Name], [Description], [ServerVersion]) VALUES (N'M', N'MHTML', N'MHTML (web archive)', N'2008')
INSERT [dbo].[tblReportType] ([Type], [Name], [Description], [ServerVersion]) VALUES (N'E', N'EXCEL', N'Excel', N'2008')
INSERT [dbo].[tblReportType] ([Type], [Name], [Description], [ServerVersion]) VALUES (N'D', N'WORD', N'Word', N'2008')




