--  ########################         new language stuff    ########################  --


-- Thursday, 9 January 2014 - 10:18:29 AM
if not exists (select * from tblLangResource where LangResourceName = N'delete') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'delete', '', '', 1, null, null, getdate(), null, null, newid()) 


-- Thursday, 9 January 2014 - 10:18:29 AM
GO


-- Thursday, 9 January 2014 - 10:18:29 AM
if not exists (select * from tblLangResource where LangResourceName = N'disable') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'disable', '', '', 1, null, null, getdate(), null, null, newid()) 


-- Thursday, 9 January 2014 - 10:18:29 AM
GO


-- Thursday, 9 January 2014 - 10:18:29 AM
if not exists (select * from tblLangResource where LangResourceName = N'disabled') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'disabled', '', '', 1, null, null, getdate(), null, null, newid()) 


-- Thursday, 9 January 2014 - 10:18:29 AM
GO


-- Thursday, 9 January 2014 - 10:18:29 AM
if not exists (select * from tblLangResource where LangResourceName = N'enable') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'enable', '', '', 1, null, null, getdate(), null, null, newid()) 


-- Thursday, 9 January 2014 - 10:18:29 AM
GO


-- Thursday, 9 January 2014 - 10:18:29 AM
if not exists (select * from tblLangResource where LangResourceName = N'enabled') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'enabled', '', '', 1, null, null, getdate(), null, null, newid()) 


-- Thursday, 9 January 2014 - 10:18:29 AM
GO


-- Thursday, 9 January 2014 - 10:18:29 AM
if not exists (select * from tblLangResource where LangResourceName = N'hdrCourseName') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'hdrCourseName', '', '', 1, null, null, getdate(), null, null, newid()) 


-- Thursday, 9 January 2014 - 10:18:29 AM
GO


-- Thursday, 9 January 2014 - 10:18:29 AM
if not exists (select * from tblLangResource where LangResourceName = N'hdrInitEnrolment') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'hdrInitEnrolment', '', '', 1, null, null, getdate(), null, null, newid()) 


-- Thursday, 9 January 2014 - 10:18:29 AM
GO


-- Thursday, 9 January 2014 - 10:18:29 AM
if not exists (select * from tblLangResource where LangResourceName = N'hdrPostExpiryNotification') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'hdrPostExpiryNotification', '', '', 1, null, null, getdate(), null, null, newid()) 


-- Thursday, 9 January 2014 - 10:18:29 AM
GO


-- Thursday, 9 January 2014 - 10:18:29 AM
if not exists (select * from tblLangResource where LangResourceName = N'hdrPreExpiryNotification') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'hdrPreExpiryNotification', '', '', 1, null, null, getdate(), null, null, newid()) 


-- Thursday, 9 January 2014 - 10:18:29 AM
GO


-- Thursday, 9 January 2014 - 10:18:29 AM
if not exists (select * from tblLangResource where LangResourceName = N'ltrPreExpCalc') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'ltrPreExpCalc', '', '', 1, null, null, getdate(), null, null, newid()) 


-- Thursday, 9 January 2014 - 10:18:29 AM
GO


-- Thursday, 9 January 2014 - 10:18:29 AM
if not exists (select * from tblLangResource where LangResourceName = N'ltrShowHide') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'ltrShowHide', '', '', 1, null, null, getdate(), null, null, newid()) 


-- Thursday, 9 January 2014 - 10:18:29 AM
GO


-- Thursday, 9 January 2014 - 10:49:04 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Organisation/OrganisationMail.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Organisation/OrganisationMail.aspx', 'aspx', 1, 1, null, getdate(), '10 Feb 2008 12:05:23', null, newid()) 


-- Thursday, 9 January 2014 - 10:49:04 AM
GO


-- Thursday, 9 January 2014 - 10:18:30 AM
If not exists (select * from tblLangValue where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrgMailSetup.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'ltrQuizExpiry')) begin insert into tblLangValue (LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)  select 2, (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrgMailSetup.aspx'),  (select LangResourceID from tblLangResource where LangResourceName = 'ltrQuizExpiry'), N'Enable', 1, 1, getdate(), newid()end else begin update tblLangValue set LangEntryValue = N'Enable' where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrgMailSetup.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'ltrQuizExpiry') end 


-- Thursday, 9 January 2014 - 10:18:30 AM
GO


-- Thursday, 9 January 2014 - 10:18:30 AM
If not exists (select * from tblLangValue where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrgMailSetup.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'ltrConfigureCourse')) begin insert into tblLangValue (LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)  select 2, (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrgMailSetup.aspx'),  (select LangResourceID from tblLangResource where LangResourceName = 'ltrConfigureCourse'), N'Apply to (select Courses)', 1, 1, getdate(), newid()end else begin update tblLangValue set LangEntryValue = N'Apply to (select Courses)' where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrgMailSetup.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'ltrConfigureCourse') end 


-- Thursday, 9 January 2014 - 10:18:30 AM
GO


-- Thursday, 9 January 2014 - 10:18:30 AM
If not exists (select * from tblLangValue where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'hdrCourseName')) begin insert into tblLangValue (LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)  select 2, (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx'),  (select LangResourceID from tblLangResource where LangResourceName = 'hdrCourseName'), N'Course Name', 1, 1, getdate(), newid()end else begin update tblLangValue set LangEntryValue = N'Course Name' where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'hdrCourseName') end 


-- Thursday, 9 January 2014 - 10:18:30 AM
GO


-- Thursday, 9 January 2014 - 10:18:30 AM
If not exists (select * from tblLangValue where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'hdrInitEnrolment')) begin insert into tblLangValue (LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)  select 2, (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx'),  (select LangResourceID from tblLangResource where LangResourceName = 'hdrInitEnrolment'), N'Initial Enrolment Period', 1, 1, getdate(), newid()end else begin update tblLangValue set LangEntryValue = N'Initial Enrolment Period' where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'hdrInitEnrolment') end 


-- Thursday, 9 January 2014 - 10:18:30 AM
GO


-- Thursday, 9 January 2014 - 10:18:30 AM
If not exists (select * from tblLangValue where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'hdrPreExpiryNotification')) begin insert into tblLangValue (LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)  select 2, (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx'),  (select LangResourceID from tblLangResource where LangResourceName = 'hdrPreExpiryNotification'), N'Pre-Expiry Notification', 1, 1, getdate(), newid()end else begin update tblLangValue set LangEntryValue = N'Pre-Expiry Notification' where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'hdrPreExpiryNotification') end 


-- Thursday, 9 January 2014 - 10:18:30 AM
GO


-- Thursday, 9 January 2014 - 10:18:30 AM
If not exists (select * from tblLangValue where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'hdrPostExpiryNotification')) begin insert into tblLangValue (LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)  select 2, (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx'),  (select LangResourceID from tblLangResource where LangResourceName = 'hdrPostExpiryNotification'), N'Post-Expiry Notification', 1, 1, getdate(), newid()end else begin update tblLangValue set LangEntryValue = N'Post-Expiry Notification' where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'hdrPostExpiryNotification') end 


-- Thursday, 9 January 2014 - 10:18:30 AM
GO


-- Thursday, 9 January 2014 - 10:18:30 AM
If not exists (select * from tblLangValue where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'hdrAction')) begin insert into tblLangValue (LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)  select 2, (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx'),  (select LangResourceID from tblLangResource where LangResourceName = 'hdrAction'), N'Action', 1, 1, getdate(), newid()end else begin update tblLangValue set LangEntryValue = N'Action' where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'hdrAction') end 


-- Thursday, 9 January 2014 - 10:18:30 AM
GO


-- Thursday, 9 January 2014 - 10:18:30 AM
If not exists (select * from tblLangValue where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'enabled')) begin insert into tblLangValue (LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)  select 2, (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx'),  (select LangResourceID from tblLangResource where LangResourceName = 'enabled'), N'Enabled', 1, 1, getdate(), newid()end else begin update tblLangValue set LangEntryValue = N'Enabled' where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'enabled') end 


-- Thursday, 9 January 2014 - 10:18:30 AM
GO


-- Thursday, 9 January 2014 - 10:18:30 AM
If not exists (select * from tblLangValue where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'disabled')) begin insert into tblLangValue (LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)  select 2, (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx'),  (select LangResourceID from tblLangResource where LangResourceName = 'disabled'), N'Disabled', 1, 1, getdate(), newid()end else begin update tblLangValue set LangEntryValue = N'Disabled' where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'disabled') end 


-- Thursday, 9 January 2014 - 10:18:30 AM
GO


-- Thursday, 9 January 2014 - 10:18:30 AM
If not exists (select * from tblLangValue where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'enable')) begin insert into tblLangValue (LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)  select 2, (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx'),  (select LangResourceID from tblLangResource where LangResourceName = 'enable'), N'Enable', 1, 1, getdate(), newid()end else begin update tblLangValue set LangEntryValue = N'Enable' where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'enable') end 


-- Thursday, 9 January 2014 - 10:18:30 AM
GO


-- Thursday, 9 January 2014 - 10:18:30 AM
If not exists (select * from tblLangValue where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'disable')) begin insert into tblLangValue (LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)  select 2, (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx'),  (select LangResourceID from tblLangResource where LangResourceName = 'disable'), N'Disable', 1, 1, getdate(), newid()end else begin update tblLangValue set LangEntryValue = N'Disable' where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'disable') end 


-- Thursday, 9 January 2014 - 10:18:30 AM
GO


-- Thursday, 9 January 2014 - 10:18:30 AM
If not exists (select * from tblLangValue where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'delete')) begin insert into tblLangValue (LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)  select 2, (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx'),  (select LangResourceID from tblLangResource where LangResourceName = 'delete'), N'Delete', 1, 1, getdate(), newid()end else begin update tblLangValue set LangEntryValue = N'Delete' where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'delete') end 


-- Thursday, 9 January 2014 - 10:18:30 AM
GO


-- Thursday, 9 January 2014 - 10:18:30 AM
If not exists (select * from tblLangValue where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'lblPageTitle')) begin insert into tblLangValue (LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)  select 2, (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx'),  (select LangResourceID from tblLangResource where LangResourceName = 'lblPageTitle'), N'Organisation Mail Setup', 1, 1, getdate(), newid()end else begin update tblLangValue set LangEntryValue = N'Organisation Mail Setup' where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'lblPageTitle') end 


-- Thursday, 9 January 2014 - 10:18:30 AM
GO


-- Thursday, 9 January 2014 - 10:18:30 AM
If not exists (select * from tblLangValue where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrgMailSetup.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'ltrShowHide')) begin insert into tblLangValue (LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)  select 2, (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrgMailSetup.aspx'),  (select LangResourceID from tblLangResource where LangResourceName = 'ltrShowHide'), N'Show/Hide Example', 1, 1, getdate(), newid()end else begin update tblLangValue set LangEntryValue = N'Show/Hide Example' where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrgMailSetup.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'ltrShowHide') end 


-- Thursday, 9 January 2014 - 10:18:30 AM
GO


-- Thursday, 9 January 2014 - 10:18:30 AM
If not exists (select * from tblLangValue where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrgMailSetup.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'ltrPreExpCalc')) begin insert into tblLangValue (LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)  select 2, (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrgMailSetup.aspx'),  (select LangResourceID from tblLangResource where LangResourceName = 'ltrPreExpCalc'), N'The due date is calculated from date of enrolment plus the number of days in the Initial Enrolment period. eg. 01/01/2013 + 30 days = 31/01/2013', 1, 1, getdate(), newid()end else begin update tblLangValue set LangEntryValue = N'The due date is calculated from date of enrolment plus the number of days in the Initial Enrolment period. eg. 01/01/2013 + 30 days = 31/01/2013' where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrgMailSetup.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'ltrPreExpCalc') end 


-- Thursday, 9 January 2014 - 10:18:30 AM
GO


-- Thursday, 9 January 2014 - 10:18:30 AM
If not exists (select * from tblLangValue where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrgMailSetup.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'lblMessage.Saved')) begin insert into tblLangValue (LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)  select 2, (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrgMailSetup.aspx'),  (select LangResourceID from tblLangResource where LangResourceName = 'lblMessage.Saved'), N'The Organisation Mail Setup has been saved sucessfully', 1, 1, getdate(), newid()end else begin update tblLangValue set LangEntryValue = N'The Organisation Mail Setup has been saved sucessfully' where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrgMailSetup.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'lblMessage.Saved') end 


-- Thursday, 9 January 2014 - 10:18:30 AM
GO


-- Thursday, 9 January 2014 - 10:18:30 AM
If not exists (select * from tblLangValue where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'ltrEmailServices')) begin insert into tblLangValue (LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)  select 2, (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx'),  (select LangResourceID from tblLangResource where LangResourceName = 'ltrEmailServices'), N'Automated emailing', 1, 1, getdate(), newid()end else begin update tblLangValue set LangEntryValue = N'Automated emailing' where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'ltrEmailServices') end 


-- Thursday, 9 January 2014 - 10:18:30 AM
GO


-- Thursday, 9 January 2014 - 10:18:30 AM
If not exists (select * from tblLangValue where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'ltrEmailServicesDesc')) begin insert into tblLangValue (LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)  select 2, (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx'),  (select LangResourceID from tblLangResource where LangResourceName = 'ltrEmailServicesDesc'), N'Enable/disable notification emailing if you do not wish for any emails to be automatically sent
(this does not affect any scheduled Reporting emails).', 1, 1, getdate(), newid()end else begin update tblLangValue set LangEntryValue = N'Enable/disable notification emailing if you do not wish for any emails to be automatically sent
(this does not affect any scheduled Reporting emails).' where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'ltrEmailServicesDesc') end 


-- Thursday, 9 January 2014 - 10:18:30 AM
GO


-- Thursday, 9 January 2014 - 10:18:30 AM
If not exists (select * from tblLangValue where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'btnStopEmail_Stop')) begin insert into tblLangValue (LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)  select 2, (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx'),  (select LangResourceID from tblLangResource where LangResourceName = 'btnStopEmail_Stop'), N'Stop Emails', 1, 1, getdate(), newid()end else begin update tblLangValue set LangEntryValue = N'Stop Emails' where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'btnStopEmail_Stop') end 


-- Thursday, 9 January 2014 - 10:18:30 AM
GO


-- Thursday, 9 January 2014 - 10:18:30 AM
If not exists (select * from tblLangValue where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'btnStopEmail_Start')) begin insert into tblLangValue (LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)  select 2, (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx'),  (select LangResourceID from tblLangResource where LangResourceName = 'btnStopEmail_Start'), N'Start Emails', 1, 1, getdate(), newid()end else begin update tblLangValue set LangEntryValue = N'Start Emails' where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Administration/Organisation/OrganisationMail.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'btnStopEmail_Start') end 


-- Thursday, 9 January 2014 - 10:18:30 AM
GO





-- ###########################################  DDL for new STUFF ###################################### --


IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tblUserQuizStatus' 
		AND  COLUMN_NAME = 'DateLastReset')                                                
begin
	alter table dbo.tblUserQuizStatus add DateLastReset datetime null
end
GO


IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tblQuiz' 
		AND  COLUMN_NAME = 'Scorm1_2')
BEGIN
    ALTER TABLE dbo.tblQuiz ADD
	    Scorm1_2 bit NOT NULL CONSTRAINT DF_tblQuiz_Scorm1_2 DEFAULT 0
END
GO

IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tblQuiz' 
		AND  COLUMN_NAME = 'LectoraBookmark')
BEGIN
    ALTER TABLE dbo.tblQuiz ADD
	    LectoraBookmark varchar(100) NOT NULL CONSTRAINT DF_tblQuiz_LectoraBookmark DEFAULT 'A001_quiz.html'
END
GO


IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tblreminderescalation' 
		AND  COLUMN_NAME = 'PreExpInitEnrolment')
BEGIN
alter table tblreminderescalation
	add PreExpInitEnrolment bit not null default 0
END
GO

IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tblreminderescalation' 
		AND  COLUMN_NAME = 'PreExpResitPeriod')
BEGIN
alter table tblreminderescalation
	add PreExpResitPeriod bit not null default 0
END
GO


IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tblreminderescalation' 
		AND  COLUMN_NAME = 'PostExpReminder')
BEGIN
alter table tblreminderescalation
	add PostExpReminder bit not null default 0
END
GO


IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tblreminderescalation' 
		AND  COLUMN_NAME = 'PostExpInitEnrolment')
BEGIN
alter table tblreminderescalation
	add PostExpInitEnrolment bit not null default 0
END
GO


IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tblreminderescalation' 
		AND  COLUMN_NAME = 'PostExpResitPeriod')
BEGIN
alter table tblreminderescalation
	add PostExpResitPeriod bit not null default 0
END
GO

IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tblreminderescalation' 
		AND  COLUMN_NAME = 'DateEnabled')
BEGIN
alter table tblreminderescalation
	add DateEnabled datetime default null
END
GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblQuizExpiryAtRisk_Notified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblQuizExpiryAtRisk] DROP CONSTRAINT [DF_tblQuizExpiryAtRisk_Notified]
END

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblQuizExpiryAtRisk]') AND type in (N'U'))
DROP TABLE [dbo].[tblQuizExpiryAtRisk]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblQuizExpiryAtRisk](
	[UserID] [int] NOT NULL,
	[ModuleID] [int] NOT NULL,
	[OrganisationID] [int] NOT NULL,
	[ExpiryDate] [Datetime] NULL,
	[PreExpiryNotified] [bit] NOT NULL default 0,
	[ExpiryNotifications][int] not Null default 0,
	[DateNotified] [datetime] null
 CONSTRAINT [PK_tblQuizExpiryAtRisk] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[ModuleID] ASC,
	[OrganisationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


--  ######################################### code for new stuff #################################  --

-- not used any more so get rid of it....
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcAutomatedEmails_ManagersToNotify]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcAutomatedEmails_ManagersToNotify]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcSCORMimport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcSCORMimport]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcSCORMtrainQandA]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcSCORMtrainQandA]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcSCORMgetValue]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcSCORMgetValue]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcGetReminderEscalations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcGetReminderEscalations]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcSCORMgetSession]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcSCORMgetSession]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcAutomatedEmails_OrganisationsToNotify]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcAutomatedEmails_OrganisationsToNotify]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcCourse_GetListByOrganisation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcCourse_GetListByOrganisation]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcEmail_Search]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcEmail_Search]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcEmail_SearchByUserID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcEmail_SearchByUserID]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_SaveCourseAccess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcOrganisation_SaveCourseAccess]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcUser_Import]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcUser_Import]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcQuizSession_BeforeStartQuiz]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcQuizSession_BeforeStartQuiz]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcQuizSession_GetEndQuizInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcQuizSession_GetEndQuizInfo]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcQuizSession_GetEndQuizInfo2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcQuizSession_GetEndQuizInfo2]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcAutomatedEmails_ManagersToNotifyIndividually]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcAutomatedEmails_ManagersToNotifyIndividually]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcAutomatedEmails_ManagersToNotifyList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcAutomatedEmails_ManagersToNotifyList]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcAutomatedEmails_UsersToNotify]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcAutomatedEmails_UsersToNotify]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_GetNextOnceOnlyReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcReport_GetNextOnceOnlyReport]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_GetNextReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcReport_GetNextReport]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcReport_GetNextUrgentReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcReport_GetNextUrgentReport]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcAutomatedEmails_New StartersToNotify]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcAutomatedEmails_New StartersToNotify]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcCourse_AdminMashup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcCourse_AdminMashup]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcQuizSession_UpdateEndQuizInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcQuizSession_UpdateEndQuizInfo]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcUser_Update]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcUser_Update]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_UpdateFeatureAccess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcOrganisation_UpdateFeatureAccess]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcEscalationConfigForCourse_Update]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcEscalationConfigForCourse_Update]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcEmail_GetNext]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcEmail_GetNext]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcUpdateReminderEscalation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcUpdateReminderEscalation]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcSCORMpublishedcontent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcSCORMpublishedcontent]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcSCORMsetValue]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcSCORMsetValue]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcOrganisation_GetURL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcOrganisation_GetURL]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcUserCourseStatus_Calculate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcUserCourseStatus_Calculate]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcUserLessonStatus_Update_Quick]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcUserLessonStatus_Update_Quick]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcUserQuizStatus_Update_Quick]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcUserQuizStatus_Update_Quick]
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prcPolicy_UserSearch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[prcPolicy_UserSearch]
GO




IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcSCORMimport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcSCORMimport]
@intModuleID integer,
@strToolLocation varchar(100),
@strQFSLocation varchar(100),
@DatePublished datetime,
@intUserID integer,
@SCORMsource varchar(100)
AS
BEGIN
--Set @intLessonID 	= dbo.udfGetLessonIDByToolbookIDAndModuleID (@strToolbookID,@intModuleID)


Declare @LWorkSiteID nvarchar(50)
Declare @QFWorkSiteID nvarchar(50)
Declare @intLessonID integer
Declare @intquizID integer

Select @LWorkSiteID = LWorkSiteID, @QFWorkSiteID = QFWorkSiteID From tblLesson Where LessonID = @intLessonID

---- Deactivate the existing lesson if it exists
Begin
Update
tblLesson
Set
Active = 0
Where
ModuleID = @intModuleID
End


-- Create the new lesson
Insert Into tblLesson
(
ModuleID,
ToolbookID,
ToolbookLocation,
QFSlocation,
DatePublished,
LoadedBy,
DateLoaded,
Active,
LWorkSiteID,
QFWorkSiteID,
Scorm1_2
)
-- With the values from the old lesson
VALUES
(
@intModuleID,
''SCOnew'',
@strToolLocation,
@strQFSLocation,
@DatePublished,
@intUserID,		-- Loaded By
GETDATE(),		-- Date Loaded
1,				-- Active
@LWorkSiteID,
@QFWorkSiteID,
1
)
-- Get the new lesson id
SELECT 	@intLessonID =  LessonID FROM tblLesson where Active = 1 AND ModuleID = @intModuleID

UPDATE tblLesson set ToolbookID = ''SCO'' + CAST(LessonID as varchar(9)) WHERE LessonID = @intLessonID

-- Insert the new lesson pages
Insert Into tblLessonPage
(
LessonID,
ToolbookPageID,
Title
)

Select
@intLessonID,
''SCORM 1.2 lesson'',
''IFRAME 1.2''

--delete bookmarks to old content
DELETE FROM tblScormDME where lessonID = @intModuleID

Declare @QuizLaunchPoint nvarchar(100)
SELECT @QuizLaunchPoint =   COALESCE(QuizLaunchPoint,'' '') FROM tblSCORMcontent WHERE LessonLaunchPoint = @SCORMsource 
IF @QuizLaunchPoint <> '' ''
BEGIN

    Declare @strToolLocationReverse varchar(100)
    Declare  @strToolDirectory varchar(100)
    SELECT @strToolLocationReverse = reverse (@strToolLocation)
    SELECT @strToolDirectory = substring(@strToolLocation,1, LEN(@strToolLocation)-CHARINDEX ( ''/'' ,@strToolLocationReverse)  ) 
	Update tblQuiz Set Active = 0 Where ModuleID = @intModuleID
	INSERT INTO tblQuiz
           ([ModuleID]
           ,[ToolbookID]
           ,[ToolbookLocation]
           ,[DatePublished]
           ,[LoadedBy]
           ,[DateLoaded]
           ,[Active]
           ,[WorksiteID]
           ,Scorm1_2
           ,LectoraBookmark    )
     VALUES
           (@intModuleID
           ,''SCO''
           ,@strToolLocation 
           -- ,@strToolDirectory +''/''+@QuizLaunchPoint
           ,@DatePublished
           ,1
           ,getUTCdate()
           ,1
           ,null,1
           ,@QuizLaunchPoint  )
         SELECT 	@intquizID =  quizID FROM tblQuiz where Active = 1 AND ModuleID = @intModuleID

UPDATE tblQuiz set ToolbookID = ''SCO'' + CAST(quizID as varchar(9)) WHERE quizID = @intquizID  
END

SELECT @intLessonID
END
' 
END
GO



IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcSCORMtrainQandA]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE Procedure [prcSCORMtrainQandA] 
(
	@StudentID int,
    @intModuleID Int,
    @intAskedQuestion Int,
    @intWeighting Int,
    @strLatency NVarChar(100),
    @strTime NVarChar(100),
    @strText NVarChar(1000), 
    @strCorrectResponse NVarChar(1000), 
    @strStudentResponse NVarChar(1000), 
    @strType NVarChar(100), 
    @strID NVarChar(100), 
    @isCorrect Bit,
    @strQuizSessionID nvarchar(200)
)
as
begin
		
		IF (@strQuizSessionID IS NOT NULL)
		BEGIN
			declare @intQuizID int;

			set @intQuizID = (
					select top 1 QuizID
					from tblQuiz
					where moduleID = @intModuleID
						and Active = 1
					)

			declare @QuizQuestionID int

			select @QuizQuestionID = (
					select top 1 QuizQuestionID
					from tblQuizQuestion
					where QuizID = @intQuizID
						and ToolbookPageID = @strID
						and Question = @strText
					)

			if (@QuizQuestionID is null)
			begin
				delete
				from tblQuizQuestion
				where QuizID = @intQuizID
					and ToolbookPageID = @strID

				insert tblQuizQuestion (
					QuizID
					,ToolbookPageID
					,Question
					)
				values (
					@intQuizID
					,@strID
					,@strText
					)
				select @QuizQuestionID = @@IDENTITY
			end

			declare @QuizAnswerID int
			--
			select @QuizAnswerID = (
					select top 1 QuizAnswerID
					from tblQuizAnswer
					where QuizQuestionID = @QuizQuestionID
						and ToolbookAnswerID = SUBSTRING(@strStudentResponse,0,49)
						and Answer = @strStudentResponse
					)

			if (@QuizAnswerID is null)
			begin
				delete
				from tblQuizAnswer
				where QuizQuestionID = @QuizQuestionID
					and ToolbookAnswerID = SUBSTRING(@strStudentResponse,0,49)

				insert tblQuizAnswer (
					QuizQuestionID
					,ToolbookAnswerID
					,Answer
					,correct
					)
				values (
					@QuizQuestionID
					,SUBSTRING(@strStudentResponse,0,49)
					,@strStudentResponse
					,@isCorrect
					)
				select @QuizAnswerID = @@IDENTITY
			end
			
			declare @QuizCorrectAnswerID int
			select @QuizCorrectAnswerID = (
					select top 1 QuizAnswerID
					from tblQuizAnswer
					where QuizQuestionID = @QuizQuestionID
						and ToolbookAnswerID = SUBSTRING(@strCorrectResponse,0,49)
						and Answer = @strCorrectResponse
					)

			if (@QuizCorrectAnswerID is null)
			begin
				delete
				from tblQuizAnswer
				where QuizQuestionID = @QuizQuestionID
					and ToolbookAnswerID = SUBSTRING(@strCorrectResponse,0,49)

				insert tblQuizAnswer (
					QuizQuestionID
					,ToolbookAnswerID
					,Answer
					,correct
					)
				values (
					@QuizQuestionID
					,SUBSTRING(@strCorrectResponse,0,49)
					,@strCorrectResponse
					,1
					)
				select @QuizCorrectAnswerID = @@IDENTITY
					
			end
			
			IF NOT EXISTS (SELECT * FROM tblQuizQuestionAudit WHERE QuizSessionID = @strQuizSessionID AND QuizQuestionID = @QuizQuestionID)
			BEGIN
				INSERT INTO tblQuizQuestionAudit( QuizSessionID,QuizQuestionID,Duration,DateAccessed)
				VALUES  (@strQuizSessionID, @QuizQuestionID, 46664, getUTCdate())
			END
			if not exists (SELECT * FROM tblQuizAnswerAudit WHERE QuizSessionID = @strQuizSessionID AND QuizQuestionID = @QuizQuestionID AND QuizAnswerID = @QuizAnswerID)
			BEGIN
				INSERT INTO tblQuizAnswerAudit (QuizSessionID,QuizQuestionID,QuizAnswerID)
				values (@strQuizSessionID,@QuizQuestionID,@QuizAnswerID) 
			END
		END

 end

' 
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcSCORMgetValue]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[prcSCORMgetValue] (
             @StudentID int,
             @LessonID int,
             @DME  varchar(50)
           )  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
if @DME=''cmi.core.lesson_location''
begin
		SELECT  Q.lectoraBookmark from tblLesson L 
		inner join tblQuiz Q on L.ModuleID =  Q.ModuleID where L.Active = 1 and Q.Active = 1 and L.lessonID = @lessonID
end
else
begin
	if not exists(	SELECT [value] FROM  tblScormDME WHERE UserID = @StudentID and LessonID = @LessonID and DME = @DME)
	begin 
		select ''''
	end
	else
	begin 
		SELECT [value] FROM  tblScormDME
		WHERE UserID = @StudentID
		and LessonID = @LessonID
		and DME = @DME
	end
end
END
' 
END
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcGetReminderEscalations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcGetReminderEscalations]
(
@orgID int,
@langcode varchar(10)
)

AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
SET NOCOUNT ON


declare @enabled varchar(10)
declare @disabled varchar(10)

declare @enable varchar(10)
declare @disable varchar(10)

declare @edit varchar(10)
declare @delete varchar(10)


SELECT     @enabled = tblLangValue.LangEntryValue
FROM         tblLang INNER JOIN
tblLangValue ON tblLang.LangID = tblLangValue.LangID INNER JOIN
tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID INNER JOIN
tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID
WHERE     (tblLang.LangCode = @langcode) AND (tblLangInterface.LangInterfaceName = ''/Administration/Organisation/OrganisationMail.aspx'') AND
(tblLangResource.LangResourceName = ''enabled'') AND (tblLangValue.Active = 1)


SELECT     @disabled = tblLangValue.LangEntryValue
FROM         tblLang INNER JOIN
tblLangValue ON tblLang.LangID = tblLangValue.LangID INNER JOIN
tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID INNER JOIN
tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID
WHERE     (tblLang.LangCode = @langcode) AND (tblLangInterface.LangInterfaceName = ''/Administration/Organisation/OrganisationMail.aspx'') AND
(tblLangResource.LangResourceName = ''disabled'') AND (tblLangValue.Active = 1)



SELECT     @enable = tblLangValue.LangEntryValue
FROM         tblLang INNER JOIN
tblLangValue ON tblLang.LangID = tblLangValue.LangID INNER JOIN
tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID INNER JOIN
tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID
WHERE     (tblLang.LangCode = @langcode) AND (tblLangInterface.LangInterfaceName = ''/Administration/Organisation/OrganisationMail.aspx'') AND
(tblLangResource.LangResourceName = ''enable'') AND (tblLangValue.Active = 1)


SELECT     @disable = tblLangValue.LangEntryValue
FROM         tblLang INNER JOIN
tblLangValue ON tblLang.LangID = tblLangValue.LangID INNER JOIN
tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID INNER JOIN
tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID
WHERE     (tblLang.LangCode = @langcode) AND (tblLangInterface.LangInterfaceName = ''/Administration/Organisation/OrganisationMail.aspx'') AND
(tblLangResource.LangResourceName = ''disable'') AND (tblLangValue.Active = 1)



SELECT     @edit = tblLangValue.LangEntryValue
FROM         tblLang INNER JOIN
tblLangValue ON tblLang.LangID = tblLangValue.LangID INNER JOIN
tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID INNER JOIN
tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID
WHERE     (tblLang.LangCode = @langcode) AND (tblLangInterface.LangInterfaceName = ''/Administration/Organisation/OrganisationMail.aspx'') AND
(tblLangResource.LangResourceName = ''edit'') AND (tblLangValue.Active = 1)


SELECT     @delete = tblLangValue.LangEntryValue
FROM         tblLang INNER JOIN
tblLangValue ON tblLang.LangID = tblLangValue.LangID INNER JOIN
tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID INNER JOIN
tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID
WHERE     (tblLang.LangCode = @langcode) AND (tblLangInterface.LangInterfaceName = ''/Administration/Organisation/OrganisationMail.aspx'') AND
(tblLangResource.LangResourceName = ''delete'') AND (tblLangValue.Active = 1)



select
re.RemEscId,
re.CourseId,
c.Name as CourseName,
case when re.RemindUsers= 1 then @enabled else @disabled end as RemindUsers,
case when re.QuizExpiryWarn =1 then @enabled else @disabled end as QuizExpiryWarn,
case when re.PostExpReminder = 1 then @enabled else @disabled end as PostExpReminder,
case when dateEnabled is null then @enable else @disable end as dateEnabled,
@edit as coledit,
@delete as colDel
from
tblReminderEscalation re
join tblCourse c on c.CourseID = re.CourseId and c.Active = 1
inner Join tblOrganisationCourseAccess oca	on oca.GrantedCourseID = c.CourseID
and oca.organisationID = @orgID
where
OrgId = @orgID

END
' 
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcSCORMgetSession]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [prcSCORMgetSession] (
             @StudentID int,
             @LessonID int,
            @isLesson bit  
           )  
AS
BEGIN
	SET NOCOUNT ON;
DECLARE @RC int
DECLARE @OrganisationID int
DECLARE @NumQuestions int
DECLARE @quizpassmark int
DECLARE @Name nvarchar(255)
SET @Name = N''Number_Of_Quiz_Questions''
SELECT @OrganisationID = OrganisationID FROM tblUser WHERE UserID = @StudentID
SELECT @quizpassmark = DefaultQuizPassMark FROM tblOrganisation WHERE OrganisationID = @organisationID 
--EXECUTE @NumQuestions = prcOrganisationConfig_GetOne  @organisationID = @OrganisationID, @name = @Name



If Exists (Select OrganisationID From tblOrganisationConfig Where OrganisationID = @organisationID And [Name]	= @Name)
Begin
	Select @NumQuestions = value from tblOrganisationConfig Where OrganisationID	= @OrganisationID And [Name]		= @Name 
End
Else
Begin
	Select @NumQuestions = Value From tblOrganisationConfig Where OrganisationID	is null And  [Name]		= @Name 
End


	-- delete then insert these as we dont want duplicates
	delete from tblScormDME 
	where UserID  =@StudentID and LessonID =@LessonID
	and DME in (''cmi.core.student_id'',''cmi.core.student_name'',''cmi.core.version'',''cmi.core.numrandom'',''cmi.core.quizpassmark'',''salt.lessonorquiz'',''salt.training.QuizURL2'')
	and DME NOT LIKE ''cmi.interactions%''
		

	INSERT INTO  tblScormDME (UserID,LessonID,DME,[value]) VALUES(@StudentID,@LessonID,''cmi.core.student_id'' ,''Salt™''+CAST(@StudentID AS varchar(20)))
	INSERT INTO  tblScormDME (UserID,LessonID,DME,[value]) VALUES(@StudentID,@LessonID,''cmi.core.student_name'' ,(SELECT FirstName FROM tblUser WHERE UserID = @StudentID))
	INSERT INTO  tblScormDME (UserID,LessonID,DME,[value]) VALUES(@StudentID,@LessonID,''cmi.core.version'' ,''3.4'')
	INSERT INTO  tblScormDME (UserID,LessonID,DME,[value]) VALUES(@StudentID,@LessonID,''cmi.core.numrandom'' ,@NumQuestions ) 
	INSERT INTO  tblScormDME (UserID,LessonID,DME,[value]) VALUES(@StudentID,@LessonID,''cmi.core.quizpassmark'' ,@quizpassmark)

   if @isLesson = 1
   begin   
		-- quiz bookmark
		
		DECLARE @VarRunningPageCount nvarchar(255)		
		DECLARE @LessonLocation nvarchar(255)
		DECLARE @VarPageInChapter nvarchar(255)
		DECLARE @VarPagesInChapter nvarchar(255)
		DECLARE @CurrentPage nvarchar(255)
        DECLARE @LectoraBookmark nvarchar(100) 

        SELECT @LectoraBookmark = ''''
		SELECT @VarRunningPageCount = ''''
		SELECT @LessonLocation = ''''
		SELECT @VarPageInChapter = ''''
		SELECT @VarPagesInChapter = ''''
		SELECT @CurrentPage = ''''
		SELECT @LectoraBookmark = ''''        
        
        SELECT @VarRunningPageCount = value 
		     FROM  tblScormDME
			   WHERE UserID = @StudentID
				and LessonID = @LessonID
				and DME = ''salt.variables.VarRunningPageCount''
		
        if @VarRunningPageCount like ''Quiz%'' or @VarRunningPageCount like ''Page 1 %''
        BEGIN
            SELECT @VarRunningPageCount = ''''
        END
        ELSE
        BEGIN
			SELECT @LessonLocation = value 
				 FROM  tblScormDME
				 WHERE UserID = @StudentID
					and LessonID = @LessonID
					and DME = ''cmi.core.lesson_location''
			SELECT @VarPageInChapter = value 
				 FROM  tblScormDME
				 WHERE UserID = @StudentID
					and LessonID = @LessonID
					and DME = ''salt.variables.VarPageInChapter''
			SELECT @VarPagesInChapter = value 
				 FROM  tblScormDME
				 WHERE UserID = @StudentID
					and LessonID = @LessonID
					and DME = ''salt.variables.VarPagesInChapter''

			SELECT @CurrentPage = value 
				 FROM  tblScormDME
				 WHERE UserID = @StudentID
					and LessonID = @LessonID
					and DME = ''salt.currentpage''
					
            SELECT @LectoraBookmark = Q.lectoraBookmark 
                FROM tblLesson L 
				inner join tblQuiz Q on L.ModuleID =  Q.ModuleID 
				WHERE L.Active = 1 and Q.Active = 1 and L.moduleID = @lessonID   
		END		
		SELECT DME,value FROM  tblScormDME
			   WHERE UserID = @StudentID
				and LessonID = @LessonID
				and DME not in (''salt.variables.VarRunningPageCount''
								, ''cmi.core.lesson_location''
								,''salt.variables.VarPageInChapter''
								,''salt.variables.VarPagesInChapter''
								,''salt.currentpage'')
				
		UNION SELECT ''salt.lessonorquiz'' as DME, ''lesson'' as [value]		
		UNION SELECT ''salt.training.QuizURL2'' as DME, @LectoraBookmark as [value]
		UNION SELECT ''salt.variables.VarRunningPageCount'' as DME, @VarRunningPageCount as [value]
		UNION SELECT ''cmi.core.lesson_location'' as DME, @LessonLocation as [value]
		UNION SELECT ''salt.variables.VarPageInChapter'' as DME, @VarPageInChapter as [value]
		UNION SELECT ''salt.variables.VarPagesInChapter'' as DME, @VarPagesInChapter as [value]
		UNION SELECT ''salt.currentpage'' as DME, @CurrentPage as [value]
		
	end
	else
	begin
		
		-- delete the existing quiz dmes
		delete from tblScormDME 
		where UserID  =@StudentID and LessonID =@LessonID
		and DME in (''cmi.suspend_data'',''cmi.core.lesson_location'')
						
		
	    Declare @QuizBookmark varchar(1000)
		SELECT @QuizBookmark =   Q.lectoraBookmark from tblLesson L 
				inner join tblQuiz Q on L.ModuleID =  Q.ModuleID where L.Active = 1 and Q.Active = 1 and L.moduleID = @lessonID  		
		SELECT DME,value FROM  tblScormDME
				 WHERE UserID = @StudentID
					and LessonID = @LessonID				
		UNION SELECT ''cmi.core.lesson_location'' AS DME, @QuizBookmark as [value]
		UNION SELECT ''salt.lessonorquiz'' as DME, ''quiz'' as [value]	
	end

END

' 
END
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcAutomatedEmails_ManagersToNotifyIndividually]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [prcAutomatedEmails_ManagersToNotifyIndividually]
(
@OrganisationID int
)


AS

BEGIN


--                    S E L E C T    T H E    R E S U L T S

--declare @OrganisationID int
--set @OrganisationID = 68

	;with UsersToNotify (userid,DelinquentCourse,username,uFirstname,uLastname) as 
	(
		SELECT distinct UsersToNotify.userid , UsersToNotify.DelinquentCourse,username,uFirstname,uLastname FROM
		(
			-- delinquent users
			SELECT DISTINCT CD.UserCourseStatusID as UserCourseStatusID, CS.userID , u.username, C.Name     as DelinquentCourse, u.FirstName as uFirstname, u.LastName as uLastname
			FROM tblUserCourseStatus CS
			INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
			INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
			INNER JOIN tblUser U On U.UserID = CS.UserID
			INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
			INNER JOIN tblUserCourseDetails UCD ON (UCD.UserID = u.UserID AND UCD.CourseID = C.CourseID)
			INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID)  AND (RemEsc.IndividualNotification=1) AND (RemEsc.NotifyMgr = 1) AND (RemEsc.DaysToCompleteCourse>0)
			INNER JOIN 
			(
			Select 
			DISTINCT
			tU.UserID
			--, tU.UnitID
			--, tU.OrganisationID
			--, tM.ModuleID
			,tC.CourseID

			From
			dbo.tblUser tU
			--< get the courses a user has access to >--
			Inner Join dbo.tblOrganisationCourseAccess tOCA
			On  tOCA.OrganisationID = tU.OrganisationID
			--< get the course details >--
			Inner join dbo.tblCourse tC
			On tC.CourseID = tOCA.GrantedCourseID
			--< get the Active modules in a course >--
			inner join dbo.tblModule tM
			On tM.CourseID = tC.CourseID
			and tM.Active = 1
			--< get the details on which modules a user is configured to access >--
			Left Outer join dbo.tblUserModuleAccess tUsrMA
			On  tUsrMA.UserID = tU.UserID
			And tUsrMA.ModuleID = tM.ModuleID
			--< get the details on which modules a user''s Unit is excluded from  >--
			Left Outer Join dbo.tblUnitModuleAccess tUnitMA
			On  tUnitMA.UnitID = tU.UnitID
			And tUnitMA.DeniedModuleID = tM.ModuleID
			Where
			tU.OrganisationID = @OrganisationID AND
			tU.Active = 1
			--< Active users only >--
			and tu.UnitID is not null
			--< Get the modules that the user''s Unit is not denied >--
			and (tUnitMA.DeniedModuleID  is null
			--<  and the user does not have special access to  it>--
			And tUsrMA.ModuleID is null)
			--< or Get modules that the user has been specially  granted
			or tUsrMA.Granted=1
			) um on um.UserID = U.UserID and um.CourseID = C.CourseID
			where (coursestatusid = 1) 
			AND (o.OrganisationID = @OrganisationID) 
			AND (GETUTCDATE() > DATEADD(d,RemEsc.DaysToCompleteCourse+1, CS.DateCreated)) -- Is Overdue
			AND (CS.DateCreated >= (SELECT MAX(DateCreated) FROM tblUserCourseStatus Expired where expired.CourseStatusID in (0,2) and Expired.CourseID = CS.CourseID and Expired.UserID =CS.UserID ) )
			AND (U.active = 1) 
			AND (UCD.LastDelNoteToMgr = 0)
			AND (GETUTCDATE() < DATEADD(m,6,DATEADD(d,RemEsc.DaysToCompleteCourse, CS.DateCreated))) -- Business Rule = If Course is more than 6 months overdue stop notifying managers

		)  UsersToNotify
	)

	, UsersToNotifyList(numb, userid,DelinquentCourse,username,uFirstname,uLastname) as
	(
		select 1,null,CAST('''' AS NVARCHAR(max)),CAST('''' AS NVARCHAR(max)),CAST('''' AS NVARCHAR(max)),CAST('''' AS NVARCHAR(max))
		UNION ALL

		--SELECT cte.numb + 1,pl.userid,CAST(cte.DelinquentCourse + (case when cte.DelinquentCourse = '''' or pl.DelinquentCourse = '''' then '''' else ''<BR>'' end ) + pl.DelinquentCourse AS NVARCHAR(max))
		SELECT cte.numb + 1,pl.userid,CAST(    cte.DelinquentCourse +  ''<BR>&nbsp;&nbsp;'' + pl.DelinquentCourse AS NVARCHAR(max)),CAST(pl.username AS NVARCHAR(max)),CAST(pl.uFirstname AS NVARCHAR(max)),CAST(pl.uLastname AS NVARCHAR(max))

		from 
		(  SELECT
		RowNum = Row_Number() OVER (partition BY userid order by userid)
		,userid,DelinquentCourse,username,uFirstname,uLastname

		FROM UsersToNotify
		) AS pl
		join UsersToNotifyList cte on pl.RowNum = cte.numb and (cte.userid is null or pl.userid = cte.userid)
	)




	, ManagersToNotifyList(numb, ManagerEmail, DelinquentCourse, FirstName, LastName,username,ManagerName,uFirstname,uLastname,deluserid, mgruserid) as
	(
	select numb,  CAST(UsersManagers.Email AS NVARCHAR(max)),DelinquentCourse,FirstName,LastName,UL.username,UsersManagers.UserName,uFirstname,uLastname, UL.userid, UsersManagers.mgruserid
	FROM UsersToNotifyList UL
	inner join (select max(numb) AS maxnumb,Userid  from UsersToNotifyList  group by userid) max on max.maxnumb = UL.numb and max.userid = UL.userid
	INNER JOIN
		(
			SELECT tblUnitAdmins.username, U.UserID, tblUnitAdmins.Email ,tblUnitAdmins.FirstName, tblUnitAdmins.LastName, tblUnitAdmins.UserID as mgruserid
			FROM  tblUser U  
						INNER JOIN  tblUnitAdministrator ON U.UnitID = tblUnitAdministrator.UnitID
						INNER JOIN   dbo.tblUser AS tblUnitAdmins ON dbo.tblUnitAdministrator.UserID = tblUnitAdmins.UserID AND tblUnitAdmins.UserTypeID = 3
						WHERE  U.NotifyUnitAdmin = 1
			UNION ALL 
			SELECT tblOrgAdmins.username, U.UserID, tblOrgAdmins.Email ,tblOrgAdmins.FirstName, tblOrgAdmins.LastName,tblOrgAdmins.UserID as mgruserid
			FROM  tblUser U  
						INNER JOIN  dbo.tblUser AS tblOrgAdmins ON U.OrganisationID = tblOrgAdmins.OrganisationID
						WHERE  U.NotifyOrgAdmin = 1 AND tblOrgAdmins.UserTypeID = 2
			UNION ALL
			SELECT ''DelinquencyManager'' as username, tblUserDelinquencyManager.UserID, tblUserDelinquencyManager.DelinquencyManagerEmail,'' '' AS FirstName, '' '' AS LastName,-1 as mgruserid
			FROM  dbo.tblUser AS tblUserDelinquencyManager WHERE  NotifyMgr = 1 and tblUserDelinquencyManager.Email IS NOT NULL AND (tblUserDelinquencyManager.Email != '''')
		) UsersManagers ON UsersManagers.UserID = UL.UserID

	)


	--select * from ManagersToNotify
	--select * from ManagersToNotifyList




	SELECT l.ManagerEmail,
	-- Recipient Email Address
	l.ManagerEmail as RecipientEmail,

	-- Sender Email Address
	l.ManagerEmail as SenderEmail,

	-- Subject
	(select   REPLACE(
	(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Overdue_Summary_Subject'')

	,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Overdue_Summary_Subject''))),''%APP_NAME%'',(SELECT Value FROM tblAppConfig where Name = ''AppName''))) as Subject,



	-- Header
	(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Overdue_Summary_Header'')

	,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Overdue_Summary_Header_Individual'')))
	
	
	
	

	--delinquent
	+ ''<BR>'' +''<B>''+ uFirstname +'' ''+uLastname+''</B>''+''&nbsp;&nbsp;''   + DelinquentCourse+ ''<BR>''

	--Email Sig
	+     
	(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Overdue_Summary_Sig'')
				,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Overdue_Summary_Sig'')))+ ''<BR>''  
	 as Body
	, -- Sender"On Behalf Of" Email Address
	(SELECT dbo.udfGetEmailOnBehalfOf (@OrganisationID))  as OnBehalfOfEmail,

	*

	FROM
	ManagersToNotifyList l

	join (select max(s.numb) numb ,ManagerEmail,ManagerName,UserName from ManagersToNotifyList s group by ManagerEmail,ManagerName,UserName)m on m.ManagerEmail = l.ManagerEmail and m.numb = l.numb and m.UserName = l.UserName and m.ManagerName = l.ManagerName
	ORDER BY l.numb DESC


--set flag to indicate delinquency note has been sent
UPDATE tblUserCourseDetails SET LastDelNoteToMgr  = 1
from tblUserCourseDetails
join (
SELECT U.userID , C.CourseID
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblUserCourseDetails UCD ON (UCD.UserID = u.UserID AND UCD.CourseID = C.CourseID)
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID)  AND (RemEsc.IndividualNotification=1) AND (RemEsc.NotifyMgr = 1)
where (coursestatusid = 1) 
AND (o.OrganisationID = @OrganisationID) 
AND (GETUTCDATE() > DATEADD(d,RemEsc.DaysToCompleteCourse+1, CS.DateCreated)) -- Is Overdue
AND (U.active = 1) 
AND (UCD.LastDelNoteToMgr = 0)
AND (GETUTCDATE() < DATEADD(m,6,DATEADD(d,RemEsc.DaysToCompleteCourse, CS.DateCreated))) -- Business Rule = If Course is more than 6 months overdue stop notifying managers
) a on a.userid = tblUserCourseDetails.UserID and a.CourseID = tblUserCourseDetails.CourseID


-- ReminderEscalations are logically grouped by the number of days that the reminders are sent
-- update the "Date last notified" field on the Reminder Escalation for all records that were notified this time.
UPDATE tblReminderEscalation SET LastNotified  = dbo.udfGetSaltOrgMidnight(OrgId)
from tblReminderEscalation
join (
SELECT o.OrganisationID , C.CourseID
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblUserCourseDetails UCD ON (UCD.UserID = u.UserID AND UCD.CourseID = C.CourseID)
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID)  AND (RemEsc.IndividualNotification=1) AND (RemEsc.NotifyMgr = 1)
where (coursestatusid = 1) 
AND (o.OrganisationID = @OrganisationID) 
AND (GETUTCDATE() > DATEADD(d,RemEsc.DaysToCompleteCourse+1, CS.DateCreated)) -- Is Overdue
AND (U.active = 1) 
AND (UCD.LastDelNoteToMgr = 0)
AND (GETUTCDATE() < DATEADD(m,6,DATEADD(d,RemEsc.DaysToCompleteCourse, CS.DateCreated))) -- Business Rule = If Course is more than 6 months overdue stop notifying managers
) a on a.OrganisationID = tblReminderEscalation.OrgId and a.CourseID = tblReminderEscalation.CourseID

END
' 
END
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcAutomatedEmails_ManagersToNotifyList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [prcAutomatedEmails_ManagersToNotifyList]
(
@OrganisationID int
)

AS

BEGIN
--                    S E L E C T    T H E    R E S U L T S

--declare @OrganisationID int
--set @OrganisationID = 68

create table #UsersToNotify
(userid int not null
,DelinquentCourse nvarchar(max) null)

insert into #UsersToNotify
SELECT distinct UsersToNotify.userid , UsersToNotify.DelinquentCourse FROM
(

-- delinquent users
SELECT DISTINCT CD.UserCourseStatusID as UserCourseStatusID, CS.userID , u.username, C.Name     as DelinquentCourse
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblUserCourseDetails UCD ON (UCD.UserID = u.UserID AND UCD.CourseID = C.CourseID)
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID)  AND (RemEsc.IndividualNotification=0)  AND (RemEsc.NotifyMgr = 1) AND (RemEsc.DaysToCompleteCourse>0)
INNER JOIN (select OrgID,NotifyMgrDays, max(lastnotified) as lastnotified  from tblReminderEscalation where tblReminderEscalation.NotifyMgr = 1   group by OrgID,NotifyMgrDays  ) LastNotified 
ON LastNotified.OrgID = o.OrganisationID  and LastNotified.NotifyMgrDays = RemEsc.NotifyMgrDays
INNER JOIN 
(
Select 
DISTINCT
tU.UserID
--, tU.UnitID
--, tU.OrganisationID
--, tM.ModuleID
,tC.CourseID

From
dbo.tblUser tU
--< get the courses a user has access to >--
Inner Join dbo.tblOrganisationCourseAccess tOCA
On  tOCA.OrganisationID = tU.OrganisationID
--< get the course details >--
Inner join dbo.tblCourse tC
On tC.CourseID = tOCA.GrantedCourseID
--< get the Active modules in a course >--
inner join dbo.tblModule tM
On tM.CourseID = tC.CourseID
and tM.Active = 1
--< get the details on which modules a user is configured to access >--
Left Outer join dbo.tblUserModuleAccess tUsrMA
On  tUsrMA.UserID = tU.UserID
And tUsrMA.ModuleID = tM.ModuleID
--< get the details on which modules a user''s Unit is excluded from  >--
Left Outer Join dbo.tblUnitModuleAccess tUnitMA
On  tUnitMA.UnitID = tU.UnitID
And tUnitMA.DeniedModuleID = tM.ModuleID
Where
tU.OrganisationID = @OrganisationID AND
tU.Active = 1
--< Active users only >--
and tu.UnitID is not null
--< Get the modules that the user''s Unit is not denied >--
and (tUnitMA.DeniedModuleID  is null
--<  and the user does not have special access to  it>--
And tUsrMA.ModuleID is null)
--< or Get modules that the user has been specially  granted
or tUsrMA.Granted=1
) um on um.UserID = U.UserID and um.CourseID = C.CourseID
where (coursestatusid = 1) 
AND (o.OrganisationID = @OrganisationID) 
AND (GETUTCDATE() > DATEADD(d,RemEsc.DaysToCompleteCourse+1, CS.DateCreated)) -- Is Overdue
AND (CS.DateCreated >= (SELECT MAX(DateCreated) FROM tblUserCourseStatus Expired where expired.CourseStatusID in (0,2) and Expired.CourseID = CS.CourseID and Expired.UserID =CS.UserID ) )
AND ((UCD.LastDelNoteToMgr = 0) OR (RemEsc.IsCumulative=1)) and  (U.active = 1)  -- and manager not notified OR CUMULATIVE notifications
AND (GETUTCDATE() > DATEADD(d,RemEsc.NotifyMgrDays,LastNotified.LastNotified )) -- Notify manager every N days
AND (GETUTCDATE() < DATEADD(m,6,DATEADD(d,RemEsc.DaysToCompleteCourse, CS.DateCreated))) -- Business Rule = If Course is more than 6 months overdue stop notifying managers

)  UsersToNotify

create index inx_1 on #UsersToNotify(userid)

create table #UsersToNotifyList
(userid int not null
,DelinquentCourse nvarchar(max) null)

create index inx_2 on #UsersToNotifyList(userid)


declare @userid int
,@DelinquentCourse nvarchar(max)
while exists (select 1 from #UsersToNotify)
begin
	set rowcount 1
	
	select @userid = userid
	,@DelinquentCourse = DelinquentCourse
	from #UsersToNotify
	
	if exists (select * from #UsersToNotifyList where userid = @userid)
	begin
		update #UsersToNotifyList set
		DelinquentCourse = rtrim(#UsersToNotifyList.DelinquentCourse + +  ''<BR>&nbsp;&nbsp;'' + @DelinquentCourse )
		from #UsersToNotifyList
		where #UsersToNotifyList.userid = @userid
	end
	else
	begin
		insert #UsersToNotifyList(userid,DelinquentCourse)
		values (@userid,@DelinquentCourse)

	end

	delete #UsersToNotify where
	@userid = userid
	and @DelinquentCourse = DelinquentCourse
	set rowcount 0
end


create table #ManagersToNotify
(ManagerName nvarchar(200) null
,ManagerEmail nvarchar(200) null
,DelinquentCourse nvarchar(max) null
,FirstName nvarchar(200) null
,LastName nvarchar(200) null
,username nvarchar(200) null
,deluserid int
,mgruserid int)

create index inx_3 on #ManagersToNotify(ManagerName)

INSERT into #ManagersToNotify( ManagerName, ManagerEmail ,DelinquentCourse,FirstName,LastName,username, deluserid,mgruserid) 

select  UsersManagers.username as managername,  UsersManagers.Email ,''<BR><B>''+U.Firstname+'' ''+U.Lastname+''</B><BR>&nbsp;&nbsp;''+DelinquentCourse,UsersManagers.FirstName as FirstName,UsersManagers.LastName, U.username,u.UserID,mgruserid
FROM #UsersToNotifyList UL
inner join tblUser U on U.userid=UL.userid


INNER JOIN
	(
		SELECT tblUnitAdmins.username, U.UserID, tblUnitAdmins.Email ,tblUnitAdmins.FirstName, tblUnitAdmins.LastName,tblUnitAdmins.UserID as mgruserid
		FROM  tblUser U  
					INNER JOIN  tblUnitAdministrator ON U.UnitID = tblUnitAdministrator.UnitID
					INNER JOIN   dbo.tblUser AS tblUnitAdmins ON dbo.tblUnitAdministrator.UserID = tblUnitAdmins.UserID AND tblUnitAdmins.UserTypeID = 3
					WHERE  U.NotifyUnitAdmin = 1
		UNION ALL 
		SELECT tblOrgAdmins.username, U.UserID, tblOrgAdmins.Email ,tblOrgAdmins.FirstName, tblOrgAdmins.LastName,tblOrgAdmins.UserID as mgruserid
		FROM  tblUser U  
					INNER JOIN  dbo.tblUser AS tblOrgAdmins ON U.OrganisationID = tblOrgAdmins.OrganisationID
					WHERE  U.NotifyOrgAdmin = 1 AND tblOrgAdmins.UserTypeID = 2
		UNION ALL
		SELECT ''DelinquencyManager'' as username, tblUserDelinquencyManager.UserID, tblUserDelinquencyManager.DelinquencyManagerEmail,'' '' AS FirstName, '' '' AS LastName, -1 as mgruserid
		FROM  dbo.tblUser AS tblUserDelinquencyManager WHERE  NotifyMgr = 1 and tblUserDelinquencyManager.Email IS NOT NULL AND (tblUserDelinquencyManager.Email != '''')
	) UsersManagers ON UsersManagers.UserID = UL.UserID



create table #ManagersToNotifyList
(ManagerName nvarchar(200) null
,ManagerEmail nvarchar(200) null
,DelinquentCourse nvarchar(max) null
,FirstName nvarchar(200) null
,LastName nvarchar(200) null
,username nvarchar(200) null
,deluserid int
,mgruserid int)

create index inx_4 on #ManagersToNotifyList(ManagerName)




declare 
@ManagerName nvarchar(200)
,@ManagerEmail nvarchar(200)
,@FirstName nvarchar(200)
,@LastName nvarchar(200)
,@username nvarchar(200)
,@deluserid int
,@mgruserid int

while exists (select 1 from #ManagersToNotify)
begin
	set rowcount 1
	select @ManagerName = ManagerName
	,@DelinquentCourse = DelinquentCourse
	,@ManagerEmail = ManagerEmail
	,@username = username
	,@FirstName = FirstName
	,@LastName = LastName
	,@deluserid = deluserid
	,@mgruserid = mgruserid
	from #ManagersToNotify

	if exists (select * from #ManagersToNotifyList where ManagerName = @ManagerName)
	begin
		update #ManagersToNotifyList set
		DelinquentCourse = rtrim(#ManagersToNotifyList.DelinquentCourse + +  ''<BR>&nbsp;&nbsp;'' + @DelinquentCourse )
		from #ManagersToNotifyList
		where #ManagersToNotifyList.ManagerName = @ManagerName
	end
	else
	begin
		insert #ManagersToNotifyList(ManagerName,DelinquentCourse,ManagerEmail ,username ,FirstName ,LastName,deluserid, mgruserid )
		values (@ManagerName,@DelinquentCourse,@ManagerEmail,@username ,@FirstName ,@LastName,@deluserid,@mgruserid )
	end

	delete #ManagersToNotify where
	@ManagerName = ManagerName
	and @DelinquentCourse = DelinquentCourse
	and @ManagerEmail = ManagerEmail
	and @username = username
	and @FirstName = FirstName
	and @LastName = LastName
	and @deluserid =deluserid
	and @mgruserid=mgruserid
	set rowcount 0
end




SELECT l.ManagerEmail,
-- Recipient Email Address
l.ManagerEmail as RecipientEmail,

-- Sender Email Address
l.ManagerEmail as SenderEmail,

-- Subject
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Overdue_Summary_Subject'')
	,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Overdue_Summary_Subject''))) as Subject,



-- Header
(
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Overdue_Summary_Header'')
								,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Overdue_Summary_Header'')))
)


--delinquent
+ ''<BR>'' + DelinquentCourse + ''<BR>''

--Email Sig
+     
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Overdue_Summary_Sig'')
			,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Overdue_Summary_Sig'')))+ ''<BR>''   as Body
, -- Sender"On Behalf Of" Email Address
(SELECT dbo.udfGetEmailOnBehalfOf (@OrganisationID))  as OnBehalfOfEmail,


*

FROM
#ManagersToNotifyList l




--set flag to indicate delinquency note has been sent
UPDATE tblUserCourseDetails SET LastDelNoteToMgr  = 1
from tblUserCourseDetails
join (
SELECT U.userID , C.CourseID
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblUserCourseDetails UCD ON (UCD.UserID = u.UserID AND UCD.CourseID = C.CourseID)
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID)  AND (RemEsc.IndividualNotification=0) AND (RemEsc.NotifyMgr = 1)
INNER JOIN (select OrgID,CourseId,NotifyMgrDays, max(lastnotified) as lastnotified  from tblReminderEscalation where tblReminderEscalation.NotifyMgr = 1   group by OrgID,CourseId,NotifyMgrDays  ) LastNotified 
ON LastNotified.OrgID = o.OrganisationID and LastNotified.CourseId =  C.CourseID and LastNotified.NotifyMgrDays = RemEsc.NotifyMgrDays
where (coursestatusid = 1) AND (o.OrganisationID = @OrganisationID) AND (GETUTCDATE() > DATEADD(d,RemEsc.NotifyMgrDays+1, CS.DateCreated))
AND ((UCD.LastDelNoteToMgr = 0) OR (RemEsc.IsCumulative=1)) and  (U.active = 1)
AND (GETUTCDATE() > DATEADD(d,RemEsc.NotifyMgrDays,LastNotified.LastNotified ))
) a on a.userid = tblUserCourseDetails.UserID and a.CourseID = tblUserCourseDetails.CourseID


-- ReminderEscalations are logically grouped by the number of days that the reminders are sent
-- update the "Date last notified" field on the Reminder Escalation for all records that were notified this time.
UPDATE tblReminderEscalation SET LastNotified  = dbo.udfGetSaltOrgMidnight(OrgId)
from tblReminderEscalation
join (
SELECT o.OrganisationID , C.CourseID
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblUserCourseDetails UCD ON (UCD.UserID = u.UserID AND UCD.CourseID = C.CourseID)
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID)  AND (RemEsc.IndividualNotification=0) AND (RemEsc.NotifyMgr = 1)
INNER JOIN (select OrgID,CourseId,NotifyMgrDays, max(lastnotified) as lastnotified  from tblReminderEscalation where tblReminderEscalation.NotifyMgr = 1   group by OrgID,CourseId,NotifyMgrDays  ) LastNotified 
ON LastNotified.OrgID = o.OrganisationID and LastNotified.CourseId =  C.CourseID and LastNotified.NotifyMgrDays = RemEsc.NotifyMgrDays
where (coursestatusid = 1) AND (o.OrganisationID = @OrganisationID) AND (GETUTCDATE() > DATEADD(d,RemEsc.NotifyMgrDays+1, CS.DateCreated))
AND ((UCD.LastDelNoteToMgr = 0) OR (RemEsc.IsCumulative=1)) and  (U.active = 1)
AND (GETUTCDATE() > DATEADD(d,RemEsc.NotifyMgrDays,LastNotified.LastNotified ))
) a on a.OrganisationID = tblReminderEscalation.OrgId and a.CourseID = tblReminderEscalation.CourseID


if OBJECT_ID(''tempdb..#UsersToNotifyList'') is not null
begin
	drop table #UsersToNotifyList
end

if  OBJECT_ID(''tempdb..#UsersToNotify'')is not null
begin
	drop table #UsersToNotify
END


if OBJECT_ID(''tempdb..#ManagersToNotify'') is not null
begin
	drop table #ManagersToNotify
end


if OBJECT_ID(''tempdb..#ManagersToNotifyList'') is not null
begin
	drop table #ManagersToNotifyList
end


END


' 
END
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcAutomatedEmails_New StartersToNotify]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [prcAutomatedEmails_New StartersToNotify]
(
@OrganisationID int
)


AS
Set Xact_Abort On
BEGIN


declare @stopEmails bit
set @stopEmails = 0
select @stopEmails = StopEmails from tblOrganisation where OrganisationID = @OrganisationID

-- New Starter
SELECT userid,email,(SELECT dbo.udfUser_GetAdministratorsEmailAddress (U.UserID)) as SenderEmail, (SELECT Value + '' login details '' FROM tblAppConfig where Name = ''AppName'') as subject, 
coalesce
(
(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_NewStarter'')
,
(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_NewStarter'')
) as body
, -- Sender"On Behalf Of" Email Address
(SELECT dbo.udfUser_GetAdministratorsOnBehalfOfEmailAddress (U.UserID))  as OnBehalfOfEmail

from tblUser U where  U.OrganisationID = @OrganisationID and U.active = 1 and U.NewStarter = 1
  and @stopEmails = 0 

update tblUser set NewStarter = 0  where  OrganisationID = @OrganisationID and active = 1 and NewStarter = 1


END
' 
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcAutomatedEmails_OrganisationsToNotify]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE   Procedure [prcAutomatedEmails_OrganisationsToNotify]
AS
Set Nocount On



declare @OrgID	    int

SELECT @OrgID = cast(coalesce((SELECT top 1 OrganisationID
from tblOrganisation
WHERE DelinquenciesLastNotified < CourseStatusLastUpdated and dateadd(hh,0,CourseStatusLastUpdated )< dbo.udfUTCtoDaylightSavingTime(getutcdate(),OrganisationID)) ,-1) as varchar(50))

update tblOrganisation set DelinquenciesLastNotified = dbo.udfUTCtoDaylightSavingTime(getutcdate(),OrganisationID) where @OrgID = OrganisationID


select @OrgID
return @OrgID


' 
END
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcAutomatedEmails_UsersToNotify]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[prcAutomatedEmails_UsersToNotify]
(
@OrganisationID int
)


AS

BEGIN

declare @OrgMidnight datetime
set @OrgMidnight =  DATEADD(d,-1,dbo.udfGetSaltOrgMidnight(@OrganisationID))

declare @StopEmails bit
set @StopEmails = 0
select @StopEmails = StopEmails from tblOrganisation where OrganisationID = @OrganisationID 


--                    H O U S E K E E P I N G
--tblUserCourseDetails contains information on notifications about courses that have ''at risk'' quizes
--add any new courses
INSERT INTO tblUserCourseDetails (UserID,CourseID,UserCourseStatusID,NumberOfDelinquencyNotifications, NewStarterFlag, AtRiskQuizList, NotifiedModuleList, LastDelinquencyNotification)

select U.UserID,CourseID,UserCourseStatusID,0,null,'''','''',null
FROM  tblUser U inner join tblUserCourseStatus tUCS ON U.UserID = tUCS.UserID and U.OrganisationID = @organisationID  INNER JOIN
(SELECT MAX(UserCourseStatusID) AS MaxUserCourseStatusID
FROM   dbo.tblUserCourseStatus
GROUP BY UserID, CourseID) AS currentStatus ON tUCS.UserCourseStatusID = currentStatus.MaxUserCourseStatusID

where  CourseStatusID in (1,2) and UserCourseStatusID NOT IN (SELECT UserCourseStatusID FROM tblUserCourseDetails)




--remove data on courses that are now unassigned
DELETE FROM tblUserCourseDetails WHERE UserCourseStatusID IN
(SELECT UserCourseStatusID
FROM  tblUser U inner join tblUserCourseStatus tUCS ON U.UserID = tUCS.UserID and U.OrganisationID = @organisationID  INNER JOIN
(SELECT MAX(UserCourseStatusID) AS MaxUserCourseStatusID
FROM   dbo.tblUserCourseStatus
GROUP BY UserID, CourseID) AS currentStatus ON tUCS.UserCourseStatusID = currentStatus.MaxUserCourseStatusID

where  CourseStatusID = 0
)


--                    S E L E C T    T H E    R E S U L T S

--declare @OrganisationID int
--set @OrganisationID = 68

create table #UsersToNotify
(userid int not null
,NewContent nvarchar(max) null
,PassedCourses nvarchar(max) null
,PassedModules nvarchar(max) null
,AtRiskOfdelinquency nvarchar(max) null
,Delinquent nvarchar(max) null)



insert into #UsersToNotify
SELECT distinct UsersToNotify.userid , UsersToNotify.NewContent , PassedCourses, PassedModules ,AtRiskOfdelinquency, delinquent FROM
(
	-- users with courses expired, due to new content
	SELECT '''' as UserCourseStatusID, tblExpiredNewContent.UserID , tblCourse.Name + '' - ''+ tblModule.Name as NewContent , '''' as PassedCourses ,'''' as PassedModules ,  '''' as AtRiskOfdelinquency,'''' as Delinquent
	FROM  tblExpiredNewContent INNER JOIN
	tblModule ON tblModule.ModuleID = tblExpiredNewContent.ModuleID
	INNER JOIN tblCourse ON tblCourse.CourseID = tblModule.CourseID 
	WHERE tblExpiredNewContent.organisationID = @OrganisationID
    and @StopEmails = 0
    
	-- users with passed courses
	UNION all SELECT '''' as UserCourseStatusID, CS.userid , '''' as NewContent,''   ''+ C.Name as PassedCourses,'''' as PassedModules,  '''' as AtRiskOfdelinquency, '''' as Delinquent
	FROM tblUserCourseStatus CS
	inner join tblUser U ON U.UserID = CS.UserID
	INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
	where U.OrganisationID = @OrganisationID and CS.CourseStatusID=2 and DATEDIFF(d,CS.DateCreated,@OrgMidnight) < 1
	and @StopEmails = 0

	-- users with passed modules
	UNION all SELECT '''' as UserCourseStatusID, QuizStatus.userid ,	'''' as NewContent, '''' as PassedCourses,	''   ''+c.name  + '' - '' + m.name as PassedModules, '''' as AtRiskOfdelinquency, '''' as delinquent
	from
	tblUserQuizStatus QuizStatus
	join tblUser  u on u.UserID = QuizStatus.UserID and u.OrganisationID = @OrganisationID
	inner join tblModule m on m.ModuleID = QuizStatus.ModuleID
	join tblCourse c on c.CourseID = m.CourseID
	inner join
	(
	select
	max(UserQuizStatusID) UserQuizStatusID, uqs.UserID, uqs.ModuleID --UserQuizStatusID is identity
	from
	tblUserQuizStatus uqs
	join tblUser  u on u.UserID = uqs.UserID
	WHERE DATEDIFF(d,uqs.DateCreated,@OrgMidnight) < 1
	and u.OrganisationID = @OrganisationID
	group by
	uqs.UserID,moduleID
	) currentStatus
	on QuizStatus.UserQuizStatusID = currentStatus.UserQuizStatusID
	where m.active = 1
	and QuizStatusID =2
    and @StopEmails = 0
    
	-- users with courses at risk (pre expiry)
	union all SELECT DISTINCT '''' as UserCourseStatusID, AR.userID,  '''' as NewContent , '''' as PassedCourses,'''' as PassedModules, ''   ''+ C.Name +'' ( ''+M.name +'') ''+ convert(varchar (11),ar.ExpiryDate ,113) as AtRiskOfdelinquency,'''' as delinquent
	from tblQuizExpiryAtRisk AR
	INNER JOIN tblUser U On U.UserID = AR.UserID
	inner join tblModule M on m.ModuleID = AR.ModuleID and m.Active = 1 and AR.OrganisationID = @OrganisationID
	INNER JOIN tblCourse C ON C.CourseID = M.CourseID
	where U.Active = 1 AND ar.PreExpiryNotified = 0
	and ar.ExpiryDate >= dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrganisationID)
    and @StopEmails = 0
    
	-- users with expired courses
	union all SELECT DISTINCT '''' as UserCourseStatusID, AR.userID,  '''' as NewContent , '''' as PassedCourses,'''' as PassedModules, '''' as AtRiskOfdelinquency ,''   ''+ C.Name +'' ( ''+M.name +'') ''+ convert(varchar (11),ar.ExpiryDate ,113)  as delinquent
	from tblQuizExpiryAtRisk AR
	INNER JOIN tblUser U On U.UserID = AR.UserID
	inner join tblModule M on m.ModuleID = AR.ModuleID and m.Active = 1 and AR.OrganisationID = @OrganisationID
	INNER JOIN tblCourse C ON C.CourseID = M.CourseID
	INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = @OrganisationID) AND (RemEsc.CourseId = C.CourseID) and RemEsc.PostExpReminder =1
	where U.Active = 1 AND ar.PreExpiryNotified != 0 
		and (ar.ExpiryNotifications =0 and ExpiryDate<=GETUTCDATE())
		and ar.ExpiryDate >= dateadd(year,-1,GETUTCDATE())
		or (ar.ExpiryNotifications>0 and ar.ExpiryNotifications<=(RemEsc.NumOfRemNotfy-1) and DATEADD (DAY,remesc.RepeatRem,ar.datenotified)<GETUTCDATE() )
    and @StopEmails = 0
    
) UsersToNotify

create index in_1 on #UsersToNotify(userid)


create table #UsersToNotifyList
(userid int not null
,NewContent nvarchar(max) null
,PassedCourses nvarchar(max) null
,PassedModules nvarchar(max) null
,AtRiskOfdelinquency nvarchar(max) null
,delinquent nvarchar(max) null)

create index in_2 on #UsersToNotifyList(userid)

declare @userid int
,@NewContent nvarchar(max)
,@PassedCourses nvarchar(max)
,@PassedModules nvarchar(max)
,@AtRiskOfdelinquency nvarchar(max)
,@delinquent nvarchar(max)

while exists (select 1 from #UsersToNotify)
begin
	set rowcount 1
	
	select @userid = userid
	,@NewContent = NewContent
	, @PassedCourses = PassedCourses
	,@PassedModules = PassedModules
	,@AtRiskOfdelinquency = AtRiskOfdelinquency
	,@delinquent =Delinquent

	from #UsersToNotify
	if exists (select * from #UsersToNotifyList where userid = @userid)
	begin

		update #UsersToNotifyList set
		NewContent = rtrim(CAST(#UsersToNotifyList.NewContent + (case when #UsersToNotifyList.NewContent = '''' or @NewContent = '''' then '''' else ''<BR>'' end ) + (case when @NewContent ='''' then '''' else ''&nbsp;&nbsp;'' end) +@NewContent AS NVARCHAR(max)))
		, PassedCourses = rtrim(CAST(#UsersToNotifyList.PassedCourses + (case when #UsersToNotifyList.PassedCourses = '''' or @PassedCourses = '''' then '''' else ''<BR>'' end)+ (case when @PassedCourses ='''' then '''' else ''&nbsp;&nbsp;'' end) + @PassedCourses AS NVARCHAR(max)))
		,PassedModules = rtrim(CAST(#UsersToNotifyList.PassedModules + (case when #UsersToNotifyList.PassedModules = '''' or @PassedModules = '''' then '''' else ''<BR>'' end)+ (case when @PassedModules ='''' then '''' else ''&nbsp;&nbsp;'' end) + @PassedModules AS NVARCHAR(max)))
		,AtRiskOfdelinquency = rtrim(CAST(#UsersToNotifyList.AtRiskOfdelinquency + (case when #UsersToNotifyList.AtRiskOfdelinquency = '''' or @AtRiskOfdelinquency = '''' then '''' else ''<BR>'' end)+ (case when @AtRiskOfdelinquency ='''' then '''' else ''&nbsp;&nbsp;'' end) + @AtRiskOfdelinquency AS NVARCHAR(max)))
		,delinquent = rtrim(CAST(#UsersToNotifyList.delinquent + (case when #UsersToNotifyList.delinquent = '''' or @delinquent = '''' then '''' else ''<BR>'' end)+ (case when @delinquent ='''' then '''' else ''&nbsp;&nbsp;'' end) + @delinquent AS NVARCHAR(max)))
		from #UsersToNotifyList
		where #UsersToNotifyList.userid = @userid
		
	end
	else
	begin

		insert #UsersToNotifyList(userid,NewContent,PassedCourses,PassedModules,AtRiskOfdelinquency,delinquent)
		values (@userid,@NewContent,@PassedCourses,@PassedModules,@AtRiskOfdelinquency,@delinquent)

	end
	
	delete #UsersToNotify where
	@userid = userid
	and @NewContent = NewContent
	and  @PassedCourses = PassedCourses
	and  @PassedModules = PassedModules
	and  @AtRiskOfdelinquency = AtRiskOfdelinquency
	and @delinquent = Delinquent
	set rowcount 0
end

-- 
-- select the final result the result set for return to the app  (also, builds the whole body just once for each user!)

SELECT l.UserID,
-- Recipient Email Address
(SELECT Email FROM tblUser WHERE UserID = l.UserID) as RecipientEmail,

-- Sender Email Address
(SELECT dbo.udfUser_GetAdministratorsEmailAddress (l.UserID)) as SenderEmail,

-- Subject
(select REPLACE(
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_Subject'')
,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_Subject''))),''%APP_NAME%'',(SELECT Value FROM tblAppConfig where Name = ''AppName''))) as Subject,


--1. Body --Header
(select coalesce((SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_Header'')
,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_Header''))),''header error''))

--2. Body --Passed Courses
+coalesce( (select case when PassedCourses = '''' then '''' else replace (
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_PassedCourses'')
,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_PassedCourses''))),''%AUTO_LIST%'',PassedCourses)end),'''')

--3. Body --Passed Modules
+coalesce( (select case when PassedModules = '''' then '''' else '' <br /> '' + replace (
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_PassedModules'')
,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_PassedModules''))),''%AUTO_LIST%'',PassedModules)end),'''')

--4. Body --Expired Content
+ coalesce( (select case when NewContent = '''' then '''' else '' <br /> '' + replace(
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_ExpiredContent'')
,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_ExpiredContent''))),''%AUTO_LIST%'',NewContent)end),'''')

--5. Body --Delinquent
+ coalesce((select case when delinquent = '''' then '''' else '' <br /> '' + replace(
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_AtRiskOfBeingOverdue'')
,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_AtRiskOfBeingOverdue''))),''%AUTO_LIST%'',delinquent)end),'''')

--6. Body --AtRiskOfdelinquency
+coalesce( (select case when AtRiskOfdelinquency = '''' then '''' else '' <br /> '' + replace(
 ( SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_AtRiskOfExpiry'')
,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_AtRiskOfExpiry''))),''%AUTO_LIST%'',AtRiskOfdelinquency) end),'''')

--7. Body --Email Sig
+     (select REPLACE(
(SELECT coalesce( (SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_Sig'')
,(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_Sig'')))+ ''<BR>''  ,''%APP_NAME%'',(SELECT Value FROM tblAppConfig where Name = ''AppName''))) as Body
, -- Sender"On Behalf Of" Email Address
(SELECT dbo.udfUser_GetAdministratorsOnBehalfOfEmailAddress (l.UserID))  as OnBehalfOfEmail,


*

FROM
#UsersToNotifyList l
where NewContent !='''' or PassedCourses !='''' or PassedModules != '''' or AtRiskOfdelinquency != ''''  or delinquent != ''''





--                    H O U S E K E E P I N G  (tidy up for tomorrow)

-- Update record of "at risk of Delinquency" notifications
-- Update tblUserCourseDetails.LastDelinquencyNotification
UPDATE tblUserCourseDetails  SET LastDelinquencyNotification = GETUTCDATE(), NumberOfDelinquencyNotifications = NumberOfDelinquencyNotifications + 1
WHERE  UserCourseStatusID in (-- users with courses at risk of delinquency (1ST WARNING)

SELECT DISTINCT UserCourseStatusID
FROM (SELECT MAX(CD.UserCourseStatusID) as UserCourseStatusID, CS.userID ,  RemEsc.DaysToCompleteCourse, MIN(CS.DateCreated) as DateCreated,C.Name,CS.CourseID
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on O.OrganisationID = u.OrganisationID 
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID) AND (RemindUsers=1)
where U.Active = 1 and @StopEmails = 0
AND ((o.DefaultQuizCompletionDate is not null AND CS.DateCreated >  dateadd(year,-1,o.DefaultQuizCompletionDate))
OR     (o.DefaultQuizCompletionDate is  null AND CS.DateCreated >= (select ISNULL((SELECT MAX(DateCreated) FROM tblUserCourseStatus Expired where expired.CourseStatusID in (0,2) and Expired.CourseID = CS.CourseID and Expired.UserID =CS.UserID) ,''1 jan 1990'')) ))
AND CD.LastDelinquencyNotification IS NULL
AND coursestatusid=1
AND o.OrganisationID = @OrganisationID
AND (GETUTCDATE() > DATEADD(d,RemEsc.DaysToCompleteCourse-RemEsc.NumOfRemNotfy*RemEsc.RepeatRem, CS.DateCreated))
AND (RemEsc.NumOfRemNotfy > cd.NumberOfDelinquencyNotifications)
AND (GETUTCDATE() < DATEADD(d,RemEsc.DaysToCompleteCourse+6, CS.DateCreated))
GROUP BY  CS.CourseID, CS.userID ,  RemEsc.DaysToCompleteCourse, C.Name) ThisCycle
)




UPDATE tblUserCourseDetails  SET LastDelinquencyNotification = GETUTCDATE(), NumberOfDelinquencyNotifications = NumberOfDelinquencyNotifications + 1
WHERE  UserCourseStatusID in (-- users with courses at risk of delinquency (SUBSEQUENT WARNINGS)
SELECT DISTINCT UserCourseStatusID
FROM (SELECT MAX(CD.UserCourseStatusID) as UserCourseStatusID, CS.userID ,  RemEsc.DaysToCompleteCourse, MIN(CS.DateCreated) as DateCreated,C.Name,CS.CourseID
FROM tblUserCourseStatus CS
INNER JOIN tblUserCourseDetails CD ON CD.UserID = CS.UserID AND CD.CourseID = CS.CourseID
INNER JOIN tblCourse C ON C.CourseID = CS.CourseID
INNER JOIN tblUser U On U.UserID = CS.UserID
INNER JOIN tblOrganisation O on o.OrganisationID = u.OrganisationID
INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = o.OrganisationID) AND (RemEsc.CourseId = C.CourseID) AND (RemindUsers=1)
where U.Active = 1 AND coursestatusid=1 AND o.OrganisationID = @OrganisationID and @StopEmails = 0
AND CD.LastDelinquencyNotification IS NOT NULL
AND ((o.DefaultQuizCompletionDate is not null AND CS.DateCreated >  dateadd(year,-1,o.DefaultQuizCompletionDate))
OR     (o.DefaultQuizCompletionDate is  null AND CS.DateCreated >= (select ISNULL((SELECT MAX(DateCreated) FROM tblUserCourseStatus Expired where expired.CourseStatusID in (0,2) and Expired.CourseID = CS.CourseID and Expired.UserID =CS.UserID) ,''1 jan 1990'')) ))
AND coursestatusid=1
AND o.OrganisationID = @OrganisationID
AND (GETUTCDATE() > DATEADD(d,RemEsc.DaysToCompleteCourse-RemEsc.NumOfRemNotfy*RemEsc.RepeatRem, CS.DateCreated))
AND (RemEsc.NumOfRemNotfy > cd.NumberOfDelinquencyNotifications)
AND (GETUTCDATE() > DATEADD(d,RemEsc.RepeatRem, CD.LastDelinquencyNotification))
AND (GETUTCDATE() < DATEADD(d,RemEsc.DaysToCompleteCourse+6, CS.DateCreated))

GROUP BY  CS.CourseID, CS.userID ,  RemEsc.DaysToCompleteCourse, C.Name) ThisQuizCycle
)


DELETE FROM tblExpiredNewContent WHERE organisationID = @OrganisationID  and @StopEmails = 0


-- Update record for post expiry notified -- use same criteria as selection above.
update tblQuizExpiryAtRisk SET --PreExpiryNotified = case when preexpirynotified = 0 then 1 else PreExpiryNotified end,
	ExpiryNotifications  = case when @StopEmails=1 then remesc.NumOfRemNotfy else ExpiryNotifications +1  end,
	datenotified = case when @StopEmails= 1 then null else  GETUTCDATE() end
from tblQuizExpiryAtRisk AR
	INNER JOIN tblUser U On U.UserID = AR.UserID
	inner join tblModule M on m.ModuleID = AR.ModuleID and m.Active = 1 and AR.OrganisationID = @OrganisationID
	INNER JOIN tblCourse C ON C.CourseID = M.CourseID
	INNER JOIN tblReminderEscalation RemEsc ON (RemEsc.OrgId = @OrganisationID) AND (RemEsc.CourseId = C.CourseID) and RemEsc.PostExpReminder =1
	where U.Active = 1 AND ar.PreExpiryNotified != 0 
		and (ar.ExpiryNotifications =0 and ExpiryDate<=GETUTCDATE())
		and ar.ExpiryDate >= dateadd(year,-1,GETUTCDATE())
		or (ar.ExpiryNotifications>0 and ar.ExpiryNotifications<=(RemEsc.NumOfRemNotfy-1) and DATEADD (DAY,remesc.RepeatRem,ar.datenotified)<GETUTCDATE() )    


--update record for pre expiry notified -- straightforward where not prexpiry notified
update tblQuizExpiryAtRisk set 
	PreExpiryNotified = 1,
	DateNotified = case when @StopEmails= 1 then null else GETUTCDATE() end
from tblQuizExpiryAtRisk ar
join tblUser u on u.UserID= ar.UserID
where PreExpiryNotified = 0 and u.OrganisationID = @OrganisationID



if OBJECT_ID(''tempdb..#UsersToNotifyList'') is not null
begin
drop table #UsersToNotifyList
end

if  OBJECT_ID(''tempdb..#UsersToNotify'')is not null
begin
drop table #UsersToNotify
END
end
' 
END
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcCourse_GetListByOrganisation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'




/*
Summary: Gets a list of all Courses
Parameters: None
Returns:

Called By: BusinessServices.Course.GetCourseListAccessableToOrg
Calls: None

Remarks: None

Author: Stephen Kenendy-Clark
Date Created: 06th of Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/


CREATE     Procedure [prcCourse_GetListByOrganisation]
(
@organisationID  int -- The organisation ID
,@excludeInactive int
)

As

-------------------------------------------------------------
-- Return Select
-------------------------------------------------------------
Select
c.[CourseID]
, c.[Name]
, c.[Notes]
, c.[Active]
, c.[CreatedBy]
, dbo.udfUTCtoDaylightSavingTime(c.[DateCreated], @organisationID)
, c.[UpdatedBy]
, dbo.udfUTCtoDaylightSavingTime(c.[DateUpdated], @organisationID)
From
[tblCourse] c
inner Join tblOrganisationCourseAccess oca
on oca.GrantedCourseID = c.CourseID and (@excludeInactive = 0 or (@excludeInactive = 1 and Active = 1))
and oca.organisationID = @organisationID
order by c.Name





' 
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcEmail_Search]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
The procedure will search email sent within the selected date range to a email and contain text in subject or body

Returns:


Called By:
Calls:

Remarks:


Author: Jack Liu
Date Created: 25 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
select * from tblEmail


prcEmail_Search''20040102'',''20040228'','''','''',''''

**/

CREATE  PROCEDURE [dbo].[prcEmail_Search]
(

@dateFrom  datetime,
@dateTo  datetime,
@toEmail nvarchar(50),
@subject nvarchar(50),
@body nvarchar(50),
@organisationID int
)
as
set nocount on

set @dateFrom = dbo.udfDaylightSavingTimeToUTC(@dateFrom, @organisationID)
set @dateTo = dbo.udfDaylightSavingTimeToUTC(DATEADD(day,1,@dateTo), @organisationID)

if @toEmail=''''
set @toEmail=null

if @subject=''''
set @subject=null

if @body=''''
set @body=null


select
emailid,
ToEmail,
subject,
body,
dbo.udfUTCtoDaylightSavingTime(DateCreated, @organisationID) as DateCreated
from tblEmail
where DateCreated between @dateFrom and  @dateTo
and (@toEmail is null  or toEmail =@toEmail)
and (@subject is null  or subject like ''%''+ @subject +''%'')
and (@body is null  or body   like ''%''+ @body +''%'')
and OrganisationID = IsNull(@organisationID,OrganisationID)
order by datecreated desc
' 
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcEmail_SearchByUserID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N' 

CREATE  PROCEDURE [prcEmail_SearchByUserID]
(
@userID int,
@organisationID int
)
as
set nocount on

select
emailid,
ToEmail,
subject,
body,
dbo.udfUTCtoDaylightSavingTime(DateCreated, @organisationID) as DateCreated
from tblEmail
where 
userID = @userID
order by datecreated desc
'
END

GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisation_SaveCourseAccess]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:
Saves the course access settings for an organisation.

Called By:
Organisation.cs

Calls:
None

Remarks:
None

Author: Peter Vranich
Date Created: 19th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

Test:
Exec prcOrganisation_SaveCourseAccess 1, ''1, 3''
*/

CREATE Procedure [prcOrganisation_SaveCourseAccess]
(
@organisationID Integer,
@grantedCourseIDs VarChar(1000)
)

As

Set NoCount On
Set Xact_Abort On

Begin Transaction

-- Remove the existing settings
Delete From tblOrganisationCourseAccess
Where
OrganisationID = @organisationID

-- Insert the new settings
Insert Into tblOrganisationCourseAccess
(
OrganisationID,
GrantedCourseID
)
Select
@organisationID,
gc.IntValue
From dbo.udfCsvToInt(@grantedCourseIDs) As gc

Commit Transaction

' 
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_Import]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
Summary: Insert/Update the details of tblUser table
Parameters:
@userXML text The XML document containing the User data.
@ID Integer ID of either the Organisation or Unit
@hierachy VarChar(12) hierachy where the call to upload useres was made from. can only be Organisation or Unit.
@userID Integer = null -- ID of user inporting the xmlData
Returns:


Called By:
User.cs
Calls:

Author: Li Zhang
Date Created: July 2008

Modification History
-----------------------------------------------------------
v#	Author		Date		Description

*/

CREATE    Procedure [dbo].[prcUser_Import]
(
@userName nvarchar(200),
@password nvarchar(100),
@firstName nvarchar(200),
@lastName nvarchar(200),
@email nvarchar(255),
@unitID int,
@classificationName nvarchar(100),
@classificationOption nvarchar(100),
@externalID	nvarchar(100),
@archival	int,
@isUpdate bit,
@uniqueField int,
@userID int,
@orgID int,
@NotifyUnitAdmin nvarchar(3),
@NotifyOrgAdmin nvarchar(3),
@ManagerNotification nvarchar(3),
@ManagerToNotify nvarchar(255)
)

As
begin

Set NoCount on

Set Xact_Abort On
Begin Transaction


--Declarations
Declare @uniqueField_Email int
Declare @uniuqeField_Username int

set @uniqueField_Email = 1
set @uniuqeField_Username = 2

declare @t int

--update
IF (@isUpdate = 1)
BEGIN

IF (@uniqueField = @uniqueField_Email)
BEGIN

--select ''debug update unique field email''
update tblUser
set UserName = case when @username =''''  then username else ISNULL(@userName,u.UserName)end,
FirstName = case when @firstname = '''' then FirstName else ISNULL(@firstName, u.FirstName)end,
LastName = case when @lastName =''''  then  lastname else ISNULL(@lastName, u.LastName)end,
Password = case when @password ='''' then Password else ISNULL(@password, u.password)end,
ExternalID = case when @externalid ='''' then externalid when @externalid =''^'' then null else ISNULL(@externalID, u.externalID)end,
UnitID = ISNULL(@unitID, u.UnitID),
Active = Case @archival when 1 then 0 -- archive user = true
when 0 then 1 -- archive user = false
else u.Active end,--remain unchanged
DateArchived = Case @archival when 1 then getutcdate()
when 0 then null
else u.DateArchived end,
NotifyUnitAdmin = case when @NotifyUnitAdmin is null then NotifyUnitAdmin when @NotifyUnitAdmin=''Yes'' then 1 when @NotifyUnitAdmin=''No'' then 0  else NotifyUnitAdmin end,
NotifyOrgAdmin = case when @NotifyOrgAdmin is null then notifyorgadmin  when @NotifyOrgAdmin = ''Yes'' then 1 when @NotifyOrgAdmin = ''No''then 0 else NotifyOrgAdmin end,
NotifyMgr = case when @ManagerNotification is null then NotifyMgr when @ManagerNotification = ''Yes'' then 1 when @ManagerNotification = ''No'' then 0 else NotifyMgr end,
DelinquencyManagerEmail = case when @ManagerToNotify='''' then DelinquencyManagerEmail when @ManagerToNotify = ''^'' then null else @ManagerToNotify end,
DateUpdated = getutcdate(),
UpdatedBy = @userID
FROM tblUser u
WHERE
u.Email = @email
and
u.OrganisationID = @orgID

-- get the userid from the email since it is the unique field
select @t = UserID from tblUser where Email = @email


--select ''debug update complete unique field email''
END

else IF (@uniqueField = @uniuqeField_Username)
BEGIN
--select ''debug update unique field username'' + @userName

update tblUser
set FirstName = case when @firstname = '''' then FirstName else ISNULL(@firstName, u.FirstName)end,
LastName = case when @lastName =''''  then  lastname else ISNULL(@lastName, u.LastName)end,
Password = case when @password ='''' then Password else ISNULL(@password, u.password)end,
ExternalID = case when @externalid ='''' then externalid when @externalid =''^'' then null else ISNULL(@externalID, u.externalID)end,
Email = case when @email ='''' then email else ISNULL(@Email, u.Email)end,
UnitID = ISNULL(@unitID, u.UnitID),
Active = Case @archival when 1 then 0
when 0 then 1
else u.Active end,
DateArchived = Case @archival when 1 then getutcdate()
when 0 then null
else u.DateArchived end,
DateUpdated = getutcdate(),
UpdatedBy = @userID,
NotifyUnitAdmin = case when @NotifyUnitAdmin is null then NotifyUnitAdmin when @NotifyUnitAdmin=''Yes'' then 1 when @NotifyUnitAdmin=''No'' then 0  else NotifyUnitAdmin end,
NotifyOrgAdmin = case when @NotifyOrgAdmin is null then notifyorgadmin  when @NotifyOrgAdmin = ''Yes'' then 1 when @NotifyOrgAdmin = ''No''then 0 else NotifyOrgAdmin end,
NotifyMgr = case when @ManagerNotification is null then NotifyMgr when @ManagerNotification = ''Yes'' then 1 when @ManagerNotification = ''No'' then 0 else NotifyMgr end,
DelinquencyManagerEmail = case when @ManagerToNotify='''' then DelinquencyManagerEmail when @ManagerToNotify = ''^'' then null else @ManagerToNotify end
FROM tblUser u
WHERE
u.Username = @username
and
u.OrganisationID = @orgID

-- get the user id from the user name since it is the key field
select @t = UserID from tblUser where Username = @username

--select ''debug update complete unique field username'' + @userName
END

--select @classificationName as a , @classificationOption as b

if (@classificationName!='''' and @classificationOption !='''')
begin
-- Delete existing userclassifications
--====================================

--select @uniqueField , @uniuqeField_Username

IF (@uniqueField = @uniuqeField_Username)
BEGIN

Delete
From
tblUserClassification
from tblUserClassification uc
join tblUser u on u.UserID = uc.UserID
Where
u.UserName = @userName

--select ''debug deleted classifications username''

-- only insert if its not delete ie is not ''^''
if (@classificationName != ''^'' and @classificationOption != ''^'')
begin
--select ''debug inserting classifications username''
-- insert the updated ones into the database
--===================================================
insert into tblUserClassification
(
UserID,
ClassificationID
)
select UserID, cl.ClassificationID
from
tblClassificationType ct
join tblClassification cl on cl.ClassificationTypeID = ct.ClassificationTypeID and ct.OrganisationID=@orgID
join tblUser on UserName = @userName
where
Value= @classificationOption
and ct.OrganisationID = @orgid
--select ''debug completed inserting classifications username''
end
END

IF (@uniqueField = @uniqueField_Email)
BEGIN
Delete
From
tblUserClassification
from tblUserClassification uc
join tblUser u on u.UserID = uc.UserID
Where
u.Email = @email

--select ''debug deleted classifications email ''

-- only insert if its not delete ie is not ''^''
if (@classificationName != ''^'' and @classificationOption != ''^'')
begin
--select ''debug inserting classifications email''
-- insert the updated ones into the database
--===================================================
insert into tblUserClassification
(
UserID,
ClassificationID
)
select userid, cl.ClassificationID
from
tblClassificationType ct
join tblClassification cl on cl.ClassificationTypeID = ct.ClassificationTypeID and ct.OrganisationID=@orgID
join tblUser on Email = @email
where
Value= @classificationOption
and ct.OrganisationID = @orgid
--select ''debug completed inserting classifications email''
end
END

END


--if @archival = 1 begin
--select ''insert into tblBulkInactiveUsers''
--insert into tblBulkInactiveUsers (UserID)values(@t)
--end
END

-- insert
IF @isUpdate = 0
BEGIN
insert into tblUser
(
Username,
Password,
Firstname,
Lastname,
Email,
ExternalID,
OrganisationID,
UnitID,
CreatedBy,
Active,
DateArchived,
NewStarter,
NotifyUnitAdmin,
NotifyOrgAdmin,
NotifyMgr,
DelinquencyManagerEmail

) values
(
@username,
@password,
@firstname,
@lastname,
@email,
@externalID,
@orgID,
@unitID,
@userID,
case @archival when 1 then 0 else 1 end,
case @archival when 1 then getutcdate() else null end,
1,
case when @NotifyUnitAdmin=''Yes'' then 1 else 0 end ,
case when @NotifyOrgAdmin = ''Yes'' then 1 else 0 end,
case when @ManagerNotification = ''Yes'' then 1 else 0 end,
case when @ManagerToNotify='''' then null else @ManagerToNotify end
)
select @t = UserID from tblUser where Username = @username and Email = @email

--Insert the classification data into the tblUserCalssification table.
Insert Into tblUserClassification
(
UserID,
ClassificationID
)
select
@t,
cls.ClassificationID
From
tblClassificationType As c, tblClassification As cls
where c.Name = @classificationName
And (c.OrganisationID = @orgID)
and cls.ClassificationTypeID = c.ClassificationTypeID
AND cls.Value = @classificationOption
And (cls.Active = 1)


--insert course licencing for the imported user
INSERT INTO tblCourseLicensingUser(CourseLicensingID, UserID)
SELECT 		DISTINCT
tblCourseLicensing.CourseLicensingID,
vwUserModuleAccess.UserID

FROM
tblCourseLicensing
INNER JOIN vwUserModuleAccess ON tblCourseLicensing.CourseID = vwUserModuleAccess.CourseID
AND tblCourseLicensing.OrganisationID = vwUserModuleAccess.OrganisationID
INNER JOIN tblUser ON vwUserModuleAccess.UserID = tblUser.UserID
LEFT OUTER JOIN	tblCourseLicensingUser ON tblUser.UserID = tblCourseLicensingUser.UserID
AND tblCourseLicensing.CourseLicensingID = tblCourseLicensingUser.CourseLicensingID
WHERE
tblCourseLicensing.DateStart <= GETUTCDATE()
AND tblCourseLicensing.DateEnd >= GETUTCDATE()
AND tblCourseLicensingUser.CourseLicensingID IS NULL
AND tblUser.userid = @t


-- Get ProfilePeriodIDs for Organisation
create table #ProfilePeriod
(
ProfilePeriodID int
)

insert into #ProfilePeriod
select ProfilePeriodID
from tblProfilePeriod  pp
join tblprofile p
on pp.profileid = p.profileid
where p.organisationid = @orgID


-- insert user into profileperiodaccess against all profileperiodids
-- for the organisation
insert into tblUserProfilePeriodAccess
select ProfilePeriodID, @t, 0 from #ProfilePeriod

drop table #ProfilePeriod

-- Get Policies for Organisation
create table #Policy
(
PolicyID int
)

insert into #Policy
select PolicyID
from tblPolicy
where OrganisationID = @orgID
and deleted = 0

-- insert user  policy access for all policies associated with organisation
insert into tbluserpolicyaccess (PolicyID, UserID,Granted)
select PolicyID, @t, 0 from #Policy

-- insert user policy acceptance for all policies for this org
insert into tblUserPolicyAccepted (PolicyID, UserID, Accepted)
select PolicyID, @t, 0 from #Policy

drop table #Policy

select @archival as archive

END

commit

END
' 
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcQuizSession_BeforeStartQuiz]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*Summary:
Given a UserID and QuizID starts a Quiz and returns a QuizSessionID
Returns:
QuizSessionID guid

Called By:
ToolbookListener.cs

Calls:

Remarks:
starts a Quiz and returns the details of the Quiz Session so that it can be opened by salt

Author:
Peter Kneale
Date Created: 2 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date		Description
#1	GB		2/3/04		Added join to Module table in return select
#2 Removed unnecessary transactions

prcQuizSession_BeforeStartQuiz @UserID=11, @QuizID=1

**/

CREATE  Procedure [prcQuizSession_BeforeStartQuiz]
(
@userID int,		-- Users ID
@moduleID int		-- the Quiz ID
)

As

Set NoCount On
Set Xact_Abort On

------------------------------------------
-- Declarations
------------------------------------------
Declare @strQuizSessionID varchar(50)	-- GUID identifying the new session
Declare @intQuizID int			-- Quiz ID the user is starting

------------------------------------------
-- Start New Session
------------------------------------------
Set @strQuizSessionID = newid()

------------------------------------------
-- Start New Session
------------------------------------------
Set @intQuizID =
(
Select Top
1 QuizID
From
tblQuiz
Where
moduleID = @moduleID
And
Active=1
)
If (@intQuizID is NULL or datalength(@intQuizID) = 0)
Begin
Raiserror (''Procedure prcQuizSession_BeforeStartQuiz could not determine the @intQuizID'', 16, 1)
Return
End

------------------------------------------
-- Insert
------------------------------------------
Insert Into
tblQuizSession
(
QuizSessionID,
UserID,
QuizID
)
Values
(
@strQuizSessionID,
@userID,
@intQuizID
)

------------------------------------------
-- select Session Details: SessionID, ModuleName, CourseName and Location
------------------------------------------
Select Top 1
tblModule.[Name] 		As ''ModuleName'',
tblCourse.[Name] 		As ''CourseName'',
@strQuizSessionID 		As ''SessionID'',
tblQuiz.ToolbookLocation 	As ''Location''
,Scorm1_2
From
tblModule
Inner Join tblQuiz
on tblQuiz.ModuleID 	= tblModule.ModuleID
Inner Join tblCourse
on tblCourse.CourseID	 = tblModule.CourseID

Where
tblModule.ModuleID = @moduleID
And
tblQuiz.Active = 1

Return
' 
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcQuizSession_GetEndQuizInfo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
read all information needed to end a quiz

Returns:
data table

Called By:
ToolBook.cs: GetEndQuizInfo

Remarks:

QuizStatusID Status
------------ --------------------------------------------------
0            Unassigned
1            Not Started
2            Passed
3            Failed
4            Expired (Time Elapsed)
5            Expired (New Content)

Author: Li Zhang
Date Created: 13-10-2006
Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	mikev		1/5/2007		Added LessonCompletionDate
**/

CREATE PROCEDURE [prcQuizSession_GetEndQuizInfo]
(
@quizSessionID varchar(50) -- unique that identifies this toolbook quiz session
, @duration int -- time used to complete the quiz
, @score int -- user quiz score
)
AS
SET nocount on
BEGIN
DECLARE @intUserID	int	-- user id
,		@intQuizID	int -- quiz id
,		@intPassMark	int	-- quiz pass mark
,		@intUnitID	int	-- user''s unit id
,		@intModuleID	int -- quiz module id
,		@intCourseID	int -- module course id
,		@intOldCourseStatus	int -- course status before update
,		@intNewQuizStatus int -- the quiz status
, 		@intNewCourseStatus	int	-- course status after update
,		@intQuizFrequency int
,		@dtmQuizCompletionDate datetime
DECLARE	@tblUserEndQuizInfo table	-- return table with all details needed to end a quiz
(
UserID	int
, QuizID int
, PassMark int
, UnitID int
, ModuleID int
, QuizFrequency int
, QuizCompletionDate datetime
, NewQuizStatus int
, OldCourseStatus int
, NewCourseStatus int
, CourseID int

)

--< read required data >--

SET @intUserID = dbo.udfGetUserIDBySessionID(@quizSessionID)
SET @intQuizID = dbo.udfGetQuizIDBySessionID(@quizSessionID)
SELECT @intUnitID = (SELECT TOP 1 UnitID FROM tblUser WHERE UserID = @intUserID)
SELECT @intModuleID = (SELECT TOP 1 ModuleID FROM tblQuiz WHERE QuizID = @intQuizID)
SET @intPassMark = dbo.udfQuiz_GetPassMark(@intUnitID, @intModuleID)
IF @score < @intPassMark
BEGIN
--< Quiz status: failed >--
SET @intNewQuizStatus = 3
END
IF @score > @intPassMark OR @score = @intPassMark
BEGIN
--< Quiz status: passed >--
SET @intNewQuizStatus = 2
END

SELECT @intCourseID = (SELECT TOP 1 CourseID FROM tblModule WHERE ModuleID = @intModuleID)
EXEC @intOldCourseStatus = prcUserCourseStatus_GetStatus @intCourseID, @intUserID
EXEC @intNewCourseStatus = prcUserCourseStatus_Calc @intCourseID, @intUserID,  @intNewQuizStatus,@intModuleID

--< get pre-defined quiz frequency from tblUnitRule >--
--< if the value is null then use the default quiz frequency in tblOrganisation >--

-- mikev(1): added QuizCompletionDate
SET @intQuizFrequency = (
SELECT  TOP 1   ISNULL(ur.QuizFrequency, o.DefaultQuizFrequency)
FROM   	tblUnitRule AS ur INNER JOIN tblUser AS u
ON ur.UnitID = u.UnitID
INNER JOIN tblOrganisation AS o ON u.OrganisationID = o.OrganisationID
WHERE	u.UserID = @intUserID
)

SET @dtmQuizCompletionDate = (
SELECT  TOP 1	ISNULL(ur.QuizCompletionDate, o.DefaultQuizCompletionDate)
FROM   	tblUnitRule AS ur INNER JOIN tblUser AS u
ON ur.UnitID = u.UnitID
INNER JOIN tblOrganisation AS o ON u.OrganisationID = o.OrganisationID
WHERE	u.UserID = @intUserID
)

INSERT INTO @tblUserEndQuizInfo ( UserID, QuizID, PassMark, UnitID, ModuleID, QuizFrequency, QuizCompletionDate, NewQuizStatus, OldCourseStatus, NewCourseStatus, CourseID)
VALUES (@intUserID, @intQuizID, @intPassMark, @intUnitID, @intModuleID, @intQuizFrequency,@dtmQuizCompletionDate,@intNewQuizStatus, @intOldCourseStatus, @intNewCourseStatus, @intCourseID)

SELECT * FROM @tblUserEndQuizInfo
END

' 
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcQuizSession_GetEndQuizInfo2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N' 

/*Summary:
read all information needed to end a quiz

Returns:
data table

Called By:
ToolBook.cs: GetEndQuizInfo

Remarks:

QuizStatusID Status
------------ --------------------------------------------------
0            Unassigned
1            Not Started
2            Passed
3            Failed
4            Expired (Time Elapsed)
5            Expired (New Content)

Author: John H
Date Created: 13-10-2011
Modification History
-----------------------------------------------------------
v#	Author		Date			Description
**/

CREATE PROCEDURE [prcQuizSession_GetEndQuizInfo2]
(
@intUserID int -- student must only sit one quiz at a time for a module
,@intModuleID int
, @duration int -- time used to complete the quiz
, @score int -- user quiz score
)
AS
SET nocount on
BEGIN
DECLARE 
		@intQuizID	int -- quiz id
,		@intPassMark	int	-- quiz pass mark
,		@intUnitID	int	-- user''s unit id
,		@intCourseID	int -- module course id
,		@intOldCourseStatus	int -- course status before update
,		@intNewQuizStatus int -- the quiz status
, 		@intNewCourseStatus	int	-- course status after update
,		@intQuizFrequency int
,		@dtmQuizCompletionDate datetime
DECLARE	@tblUserEndQuizInfo table	-- return table with all details needed to end a quiz
(
UserID	int
, QuizID int
, PassMark int
, UnitID int
, ModuleID int
, QuizFrequency int
, QuizCompletionDate datetime
, NewQuizStatus int
, OldCourseStatus int
, NewCourseStatus int
, CourseID int
, SessionID varchar(50)
, sendcert bit

)

--< read required data >--
DECLARE @quizSessionID varchar(50)
SELECT @quizSessionID =  (SELECT top 1 quizSessionID
  FROM tblQuiz Q
inner join tblQuizSession QS on  Q.QuizID = QS.QuizID 
WHERE Q.Active = 1 AND QS.DateTimeStarted IS NOT NULL
AND QS.DateTimeCompleted IS NULL
AND Q.ModuleID = @intModuleID
AND QS.UserID = @intUserID
order by DateTimeStarted desc)


select  @intQuizID = quizid from 
tblQuiz where ModuleID =@intModuleID





if @quizSessionID is null   begin
	set @quizSessionID = newid()
	
	Insert Into
	tblQuizSession
	(
	QuizSessionID,
	UserID,
	QuizID,
	DateTimeStarted
	)
	Values
	(
	@quizSessionID,
	@intUserID,
	@intQuizID,
	GETUTCDATE()
)

	
end 

							

SELECT @intUnitID = (SELECT TOP 1 UnitID FROM tblUser WHERE UserID = @intUserID)
--SELECT @intModuleID = (SELECT TOP 1 ModuleID FROM tblQuiz WHERE QuizID = @intQuizID)
SET @intPassMark = dbo.udfQuiz_GetPassMark(@intUnitID, @intModuleID)
IF @score < @intPassMark
BEGIN
--< Quiz status: failed >--
SET @intNewQuizStatus = 3
END
IF @score > @intPassMark OR @score = @intPassMark
BEGIN
--< Quiz status: passed >--
SET @intNewQuizStatus = 2
END

SELECT @intCourseID = (SELECT TOP 1 CourseID FROM tblModule WHERE ModuleID = @intModuleID)
EXEC @intOldCourseStatus = prcUserCourseStatus_GetStatus @intCourseID, @intUserID
EXEC @intNewCourseStatus = prcUserCourseStatus_Calc @intCourseID, @intUserID,  @intNewQuizStatus,@intModuleID

--< get pre-defined quiz frequency from tblUnitRule >--
--< if the value is null then use the default quiz frequency in tblOrganisation >--

-- mikev(1): added QuizCompletionDate
SET @intQuizFrequency = (
SELECT  TOP 1   ISNULL(ur.QuizFrequency, o.DefaultQuizFrequency)
FROM   	tblUnitRule AS ur INNER JOIN tblUser AS u
ON ur.UnitID = u.UnitID
INNER JOIN tblOrganisation AS o ON u.OrganisationID = o.OrganisationID
WHERE	u.UserID = @intUserID
)

SET @dtmQuizCompletionDate = (
SELECT  TOP 1	ISNULL(ur.QuizCompletionDate, o.DefaultQuizCompletionDate)
FROM   	tblUnitRule AS ur INNER JOIN tblUser AS u
ON ur.UnitID = u.UnitID
INNER JOIN tblOrganisation AS o ON u.OrganisationID = o.OrganisationID
WHERE	u.UserID = @intUserID
)

INSERT INTO @tblUserEndQuizInfo ( UserID, QuizID, PassMark, UnitID, ModuleID, QuizFrequency, QuizCompletionDate, NewQuizStatus, OldCourseStatus, NewCourseStatus, CourseID, SessionID)
VALUES (@intUserID, @intQuizID, @intPassMark, @intUnitID, @intModuleID, @intQuizFrequency,@dtmQuizCompletionDate,@intNewQuizStatus, @intOldCourseStatus, @intNewCourseStatus, @intCourseID,@quizSessionID)

SELECT * FROM @tblUserEndQuizInfo
END'
end
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_GetNextOnceOnlyReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [prcReport_GetNextOnceOnlyReport]

AS
BEGIN
	-- NextRun is saved in the ORGs timezone so that when an ORG goes into daylight saving the Report is run at the correct time.
	-- ALL other times are saved in the ORGs timezone to reduce load on the GUI when the ORGs timezone is changed
	-- NextRun is never null
	SET NOCOUNT ON
	DECLARE @ScheduleID int,
	@RunDate datetime, 
	@ReportStartDate datetime, 
	@ReportFrequencyPeriod char(1), 
	@ReportFrequency int, 
	@OrgID int	,
	@ReportFromDate datetime,
	@ReportPeriodType int,
	@NumberDelivered int,
	@ReportID int,
	@DateFrom DateTime
	SELECT @ScheduleID = ScheduleID
	FROM tblReportSchedule
	INNER JOIN tblReportInterface ON tblReportSchedule.ReportID = tblReportInterface.ReportID
	INNER JOIN tblUser ON tblReportSchedule.UserID = tblUser.UserID  AND tblUser.Active = 1
	INNER JOIN tblOrganisation ON tblOrganisation.OrganisationID = tblReportSchedule.ParamOrganisationID
	WHERE  CourseStatusLastUpdated > dbo.udfGetSaltOrgMidnight(tblUser.OrganisationID)
	AND (NextRun <= dbo.udfUTCtoDaylightSavingTime(GETUTCDATE(),tblReportSchedule.ParamOrganisationID))
	AND (TerminatedNormally = 0)
	AND (IsPeriodic = ''O'')


	DECLARE @OnBehalfOf nvarchar(255)
	DECLARE @ReplyTo nvarchar(255)
	DECLARE @FromDate DateTime = CAST(''1 Jan 2002'' as datetime)

	IF (@ScheduleID IS NOT NULL)
	BEGIN
		DECLARE @NextRun datetime
		SELECT @NextRun = NextRun,
		@ReportStartDate = ReportStartDate,
		@ReportFrequencyPeriod = ReportFrequencyPeriod,
		@ReportFrequency = ReportFrequency,
		@OrgID = ParamOrganisationID,
		@ReportFromDate = ReportFromDate,
		@NumberDelivered = NumberDelivered,
		@ReportPeriodType = coalesce(ReportPeriodType ,3),
		@ReportID = ReportID,
		@DateFrom = ParamDateFrom
		FROM tblReportSchedule WHERE ScheduleID = @ScheduleID

		SET @RunDate = @NextRun


		SET @NextRun = dbo.udfReportSchedule_IncrementNextRunDate -- get the new NexrRun value
		(
			@RunDate , 
			@ReportStartDate , 
			@ReportFrequencyPeriod , 
			@ReportFrequency , 
			@OrgID 	
		)


		
		-- update the Report Schedule
		UPDATE tblReportSchedule -- Move NextRun,Lastrun forward by one period
		SET NumberDelivered = NumberDelivered + 1,
		TerminatedNormally = 1,
		NextRun = cast(''1 jan 2050'' as datetime),
		LastRun = @RunDate,
		LastUpdatedBy=0,
		Lastupdated=getUTCdate()
		
		WHERE ScheduleID = @ScheduleID

		-- get the Report period (we know the ''to'' date - just need to calculate the ''from'' date)
		IF ((@ReportPeriodType <> 2) AND (@ReportPeriodType <> 3))
		BEGIN
			SET @FromDate = CAST(''1 Jan 2002'' as datetime)
		END
		
		IF (@ReportPeriodType = 3) 
		BEGIN
			SET @FromDate = @ReportFromDate 
		END
		
		IF (@ReportPeriodType = 2) 
		BEGIN
			SET @FromDate =
		CASE 
			WHEN (@ReportFrequencyPeriod=''Y'') THEN DATEADD(YEAR,-@ReportFrequency,@RunDate)
			WHEN (@ReportFrequencyPeriod=''M'') THEN DATEADD(MONTH,-@ReportFrequency,@RunDate)
			WHEN (@ReportFrequencyPeriod=''W'') THEN DATEADD(WEEK,-@ReportFrequency,@RunDate)
			WHEN (@ReportFrequencyPeriod=''D'') THEN DATEADD(DAY,-@ReportFrequency,@RunDate)
			WHEN (@ReportFrequencyPeriod=''H'') THEN DATEADD(HOUR,-@ReportFrequency,@RunDate)
		END	

		END
		
		IF (@ReportID=10) OR (@ReportID=22) OR (@ReportID=23) OR (@ReportID=24)
		BEGIN
			SET @FromDate = @DateFrom
		END
				
		SELECT @OnBehalfOf = dbo.udfGetEmailOnBehalfOf (0)	
	END -- IF ScheduleID is not null


	-- return the results
	SET NOCOUNT OFF
	SELECT TOP (1) [ScheduleID]
	,RS.UserID
	,RS.ReportID
	,[LastRun]
	,[ReportStartDate]
	,[ReportFrequency]
	,[ReportFrequencyPeriod]
	,[DocumentType]
	,[ParamOrganisationID]
	,[ParamCompleted]
	,[ParamStatus]
	,[ParamFailCount]
	,[ParamCourseIDs]
	,[ParamHistoricCourseIDs]
	,[ParamAllUnits]
	,[ParamTimeExpired]
	,[ParamTimeExpiredPeriod]
	,[ParamQuizStatus]
	,[ParamGroupBy]
	,[ParamGroupingOption]
	,[ParamFirstName]
	,[ParamLastName]
	,[ParamUserName]
	,[ParamEmail]
	,[ParamIncludeInactive]
	,[ParamSubject]
	,[ParamBody]
	,[ParamProfileID]
	,[ParamProfilePeriodID]
	,[ParamPolicyIDs]
    ,[ParamAcceptance]
	,[ParamOnlyUsersWithShortfall]
	,[ParamEffectiveDate]
	,[ParamSortBy]
	,[ParamClassificationID]
	,ParamLangInterfaceName
	, case
	when tblReportinterface.ReportID = 26 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.2''))
	when tblReportinterface.ReportID = 27 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.2''))
	when tblReportinterface.ReportID = 3 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.1''))
	when tblReportinterface.ReportID = 6 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.1''))
		when (tblReportinterface.ReportID = 22) or (tblReportinterface.ReportID = 23) or (tblReportinterface.ReportID = 24) or (tblReportinterface.ReportID = 10) 
		then 
		(
			select coalesce(LangEntryValue, (select coalesce(tblLangValue.LangEntryValue,''Missing Localisation'') FROM tblLangValue where tblLang.LangID = tblLangValue.LangID   AND (tblLangValue.Active = 1) and tblLangValue.LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''Report.Summary'') and tblLangValue.LangResourceID = tblLangResource.LangResourceID))
		)

	else coalesce(tblLangValue.LangEntryValue,''Missing Localisation'')
	end as ReportName
	,tblReportInterface.RDLname
	,tblUser.FirstName
	,tblUser.LastName
	,tblUser.Email
	,ParamUnitIDs
	,paramOrganisationID
	,RS.ParamLangCode
	,ParamLangCode
	,ParamLicensingPeriod
	,RS.ReportEndDate
	,RS.ReportTitle
	,RS.NumberOfReports
	,RS.ReportFromDate
,(dbo.udfGetCCList(RS.ScheduleID)) as CCList
	,RS.ReportPeriodType
	,dbo.udfGetEmailOnBehalfOf (ParamOrganisationID) as OnBehalfOf
	,RS.NextRun
	,RS.ReportFromDate
	,@FromDate as FromDate
	,dbo.udfGetEmailReplyTo (ParamOrganisationID,tblUser.FirstName + '' '' + tblUser.LastName + '' <'' + tblUser.Email + ''>'') as ReplyTo
	,CASE when exists (SELECT Value FROM  tblAppConfig WHERE (Name = ''SEND_AUTO_EMAILS'') AND (UPPER(Value) = ''YES'')) then 0 ELSE 1 END as StopEmails
	,CAST(convert( varchar(11), dbo.udfUTCtoDaylightSavingTime(DATEADD(d,1,GETUTCDATE()),@OrgID),113) AS DateTime) as Tomorrow
	,CASE when tblUser.usertypeid=4 then dbo.udfUser_GetAdministratorsEmailAddress (tblUser.UserID) else tblUser.Email end as SenderEmail
	,IsPeriodic
	FROM
	tblReportinterface
	inner join tblReportSchedule RS  on tblReportinterface.ReportID = RS.ReportID	
	INNER JOIN tblUser ON RS.UserID = tblUser.UserID
	LEFT OUTER JOIN tblLang ON tblLang.LangCode = RS.ParamLangCode
	LEFT OUTER JOIN tblLangInterface ON  paramlanginterfacename = tblLangInterface.langinterfacename
	LEFT OUTER JOIN tblLangResource ON  tblLangResource.langresourcename = ''rptreporttitle''
	LEFT OUTER JOIN tblLangValue ON tblLang.LangID = tblLangValue.LangID   AND (tblLangValue.Active = 1) and tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID and tblLangValue.LangResourceID = tblLangResource.LangResourceID

	WHERE ScheduleID = @ScheduleID


END
' 
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_GetNextReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [prcReport_GetNextReport]

AS
BEGIN
	-- NextRun is saved in the ORGs timezone so that when an ORG goes into daylight saving the Report is run at the correct time.
	-- ALL other times are saved in the ORGs timezone to reduce load on the GUI when the ORGs timezone is changed
	
	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET TerminatedNormally = 1
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		WHERE (TerminatedNormally = 0)
		AND (IsPeriodic = ''M'')
		AND ReportEndDate IS NULL -- flag to indicate that NumberOfReports is being used
		AND NumberOfReports IS NOT NULL
		AND NumberDelivered >= NumberOfReports 
	)
	
	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET TerminatedNormally = 0
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		WHERE (TerminatedNormally = 1)
		AND (IsPeriodic = ''M'')
		AND ReportEndDate IS NULL -- flag to indicate that NumberOfReports is being used
		AND NumberOfReports IS NOT NULL
		AND NumberDelivered < NumberOfReports 
	)
	


	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET 
	LastRun = ''1 Jan 1997'',
	NextRun = dbo.udfReportSchedule_CalcNextRunDate 
	(
		ReportStartDate, 
		ReportStartDate , 
		ReportFrequencyPeriod , 
		ReportFrequency , 
		ParamOrganisationID 	
	)
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		INNER JOIN tblUser ON tblReportSchedule.UserID = tblUser.UserID
		WHERE (TerminatedNormally = 0)
		AND (IsPeriodic != ''N'')
		AND (tblUser.Active = 1)
		AND LASTRUN IS NULL
		AND NEXTRUN IS NULL
	)

	
	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET LastRun = ''1 Jan 2001''
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		INNER JOIN tblUser ON tblReportSchedule.UserID = tblUser.UserID
		WHERE (TerminatedNormally = 0)
		AND (IsPeriodic != ''N'')
		AND (tblUser.Active = 1)
		AND LASTRUN IS NULL
	)
	
		
	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET NextRun = dbo.udfReportSchedule_CalcNextRunDate 
	(
		LastRun , 
		ReportStartDate , 
		ReportFrequencyPeriod , 
		ReportFrequency , 
		ParamOrganisationID 	
	)
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		INNER JOIN tblUser ON tblReportSchedule.UserID = tblUser.UserID
		--WHERE (TerminatedNormally = 0)
		AND (IsPeriodic != ''N'')
		AND (tblUser.Active = 1)
		AND NEXTRUN IS NULL
	)
	
	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET TerminatedNormally = 1
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		WHERE (TerminatedNormally = 0)
		AND (IsPeriodic = ''M'')
		AND ReportEndDate IS NOT NULL
		AND NextRun > ReportEndDate
		AND NumberOfReports IS NULL
	)
	
	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET TerminatedNormally = 0
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		WHERE (TerminatedNormally = 1)
		AND (IsPeriodic = ''M'')
		AND ReportEndDate IS NOT NULL
		AND NextRun <= ReportEndDate
		AND NumberOfReports IS NULL
	)	
		
	UPDATE tblReportSchedule -- fix schedules that have been modified by GUI
	SET TerminatedNormally = 0
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		WHERE (TerminatedNormally = 1)
		AND (IsPeriodic = ''M'')
		AND ReportEndDate IS NULL 
		AND NumberOfReports IS  NULL
	)
	
	
	-- NextRun is never null
	SET NOCOUNT ON
	DECLARE @ScheduleID int,
	@RunDate datetime, 
	@ReportStartDate datetime, 
	@ReportFrequencyPeriod char(1), 
	@ReportFrequency int, 
	@OrgID int	,
	@ReportFromDate datetime,
	@NumberDelivered int,
	@NumberOfReports int,
	@ReportEndDate datetime,
	@ReportPeriodType int,
	@ReportID int

	SELECT @ScheduleID =  ScheduleID
	FROM tblReportSchedule
	INNER JOIN tblReportInterface ON tblReportSchedule.ReportID = tblReportInterface.ReportID
	INNER JOIN tblUser ON tblReportSchedule.UserID = tblUser.UserID AND tblUser.Active = 1
	INNER JOIN tblOrganisation ON tblOrganisation.OrganisationID = tblReportSchedule.ParamOrganisationID
	WHERE  CourseStatusLastUpdated > dbo.udfGetSaltOrgMidnight(tblUser.OrganisationID)
	AND (NextRun <= dbo.udfUTCtoDaylightSavingTime(GETUTCDATE(),tblReportSchedule.ParamOrganisationID))
	AND (TerminatedNormally = 0)
	AND (IsPeriodic = ''M'')


	DECLARE @OnBehalfOf nvarchar(255)
	DECLARE @ReplyTo nvarchar(255)
	DECLARE @FromDate DateTime = CAST(''1 Jan 1997'' as datetime)
	DECLARE @DateFrom DateTime

	IF (@ScheduleID IS NOT NULL)
	BEGIN
		DECLARE @NextRun datetime
		SELECT @NextRun = NextRun,
		@ReportStartDate = ReportStartDate,
		@ReportFrequencyPeriod = ReportFrequencyPeriod,
		@ReportFrequency = ReportFrequency,
		@OrgID = ParamOrganisationID,
		@ReportFromDate = ReportFromDate,
		@NumberDelivered = NumberDelivered, 
		@NumberOfReports = NumberOfReports, 
		@ReportEndDate = ReportEndDate ,
		@ReportPeriodType = coalesce(ReportPeriodType ,3),
		@ReportID = ReportID,
		@DateFrom = ParamDateFrom
		FROM tblReportSchedule WHERE ScheduleID = @ScheduleID

		SET @RunDate = dbo.udfReportSchedule_CalcNextRunDate -- may have missed a couple of reports if the server was down so just verify that NEXTRUN makes sense
		(
			@NextRun,  
			@ReportStartDate , 
			@ReportFrequencyPeriod,  
			@ReportFrequency, 
			@OrgID
		)

		SET @NextRun = dbo.udfReportSchedule_IncrementNextRunDate -- get the new NexrRun value
		(
			@RunDate , 
			@ReportStartDate , 
			@ReportFrequencyPeriod , 
			@ReportFrequency , 
			@OrgID 	
		)
		-- now look for termination conditions
		DECLARE @TerminatedNormally bit = 0

		IF  @ReportEndDate IS NOT NULL AND (@ReportEndDate < @NextRun) BEGIN SET @TerminatedNormally = 1  END
		IF @NumberOfReports IS NOT NULL AND (@NumberOfReports < (@NumberDelivered + 1)) BEGIN SET @TerminatedNormally = 1  END
		
		-- update the Report Schedule
		UPDATE tblReportSchedule -- Move NextRun,Lastrun forward by one period
		SET NumberDelivered = NumberDelivered + 1,
		TerminatedNormally = @TerminatedNormally,
		LastRun = @RunDate,
		NextRun = @NextRun,
		LastUpdatedBy=0,
		Lastupdated=getUTCdate()
		WHERE ScheduleID = @ScheduleID

		-- get the Report period (we know the ''to'' date - just need to calculate the ''from'' date)

		IF ((@ReportPeriodType <> 2) AND (@ReportPeriodType <> 3))
		BEGIN
			SET @FromDate = CAST(''1 Jan 1997'' as datetime)
		END
		
		IF (@ReportPeriodType = 3) 
		BEGIN
			SELECT @FromDate = @RunDate 
		END
		
		IF (@ReportPeriodType = 2) 
		BEGIN
			SET @FromDate =
			CASE 
				WHEN (@ReportFrequencyPeriod=''Y'') THEN DATEADD(YEAR,-@ReportFrequency,@RunDate)
				WHEN (@ReportFrequencyPeriod=''M'') THEN DATEADD(MONTH,-@ReportFrequency,@RunDate)
				WHEN (@ReportFrequencyPeriod=''W'') THEN DATEADD(WEEK,-@ReportFrequency,@RunDate)
				WHEN (@ReportFrequencyPeriod=''D'') THEN DATEADD(DAY,-@ReportFrequency,@RunDate)
				WHEN (@ReportFrequencyPeriod=''H'') THEN DATEADD(HOUR,-@ReportFrequency,@RunDate)
			END	
	    END
		IF (@ReportID=10) OR (@ReportID=22) OR (@ReportID=23) OR (@ReportID=24)
		BEGIN
			SET @FromDate = @DateFrom
		END
		
	SELECT @OnBehalfOf = dbo.udfGetEmailOnBehalfOf (@OrgID)	
	END -- IF ScheduleID is not null


	-- return the results
	SET NOCOUNT OFF
	SELECT TOP (1) [ScheduleID]
	,RS.UserID
	,RS.ReportID
	,[LastRun]
	,[ReportStartDate]
	,[ReportFrequency]
	,[ReportFrequencyPeriod]
	,[DocumentType]
	,[ParamOrganisationID]
	,[ParamCompleted]
	,[ParamStatus]
	,[ParamFailCount]
	,[ParamCourseIDs]
	,[ParamHistoricCourseIDs]
	,[ParamAllUnits]
	,[ParamTimeExpired]
	,[ParamTimeExpiredPeriod]
	,[ParamQuizStatus]
	,[ParamGroupBy]
	,[ParamGroupingOption]
	,[ParamFirstName]
	,[ParamLastName]
	,[ParamUserName]
	,[ParamEmail]
	,[ParamIncludeInactive]
	,[ParamSubject]
	,[ParamBody]
	,[ParamProfileID]
	,[ParamProfilePeriodID]
	,[ParamPolicyIDs]
    ,[ParamAcceptance]
	,[ParamOnlyUsersWithShortfall]
	,[ParamEffectiveDate]
	,[ParamSortBy]
	,[ParamClassificationID]
	,ParamLangInterfaceName
	, case
	when tblReportinterface.ReportID = 26 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.2''))
	when tblReportinterface.ReportID = 27 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.2''))
	when tblReportinterface.ReportID = 3 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.1''))
	when tblReportinterface.ReportID = 6 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.1''))
	when (tblReportinterface.ReportID = 22) or (tblReportinterface.ReportID = 23) or (tblReportinterface.ReportID = 24) or (tblReportinterface.ReportID = 10) 
	then 
		(
			select coalesce(LangEntryValue, (select coalesce(tblLangValue.LangEntryValue,''Missing Localisation'') FROM tblLangValue where tblLang.LangID = tblLangValue.LangID   AND (tblLangValue.Active = 1) and tblLangValue.LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''Report.Summary'') and tblLangValue.LangResourceID = tblLangResource.LangResourceID))
		)

	else coalesce(tblLangValue.LangEntryValue,''Missing Localisation'')
	end as ReportName
	,tblReportInterface.RDLname
	,tblUser.FirstName
	,tblUser.LastName
	,tblUser.Email
	,ParamUnitIDs
	,paramOrganisationID
	,RS.ParamLangCode
	,ParamLangCode
	,ParamLicensingPeriod
	,RS.ReportEndDate
	,RS.ReportTitle
	,RS.NumberOfReports
	,RS.ReportFromDate
,(dbo.udfGetCCList(RS.ScheduleID)) as CCList
	,RS.ReportPeriodType
	,dbo.udfGetEmailOnBehalfOf (ParamOrganisationID) as OnBehalfOf
	,RS.NextRun
	,@FromDate as FromDate
	,dbo.udfGetEmailReplyTo (ParamOrganisationID,tblUser.FirstName + '' '' + tblUser.LastName + '' <'' + tblUser.Email + ''>'') as ReplyTo
	,CASE when exists (SELECT Value FROM  tblAppConfig WHERE (Name = ''SEND_AUTO_EMAILS'') AND (UPPER(Value) = ''YES'')) then 0 ELSE 1 END as StopEmails
	,CAST(convert( varchar(11), dbo.udfUTCtoDaylightSavingTime(DATEADD(d,1,GETUTCDATE()),@OrgID),113) AS DateTime) as Tomorrow
,CASE when tblUser.usertypeid=4 then dbo.udfUser_GetAdministratorsEmailAddress (tblUser.UserID) else tblUser.Email end as SenderEmail
    ,IsPeriodic
	FROM
	tblReportinterface
	inner join tblReportSchedule RS  on tblReportinterface.ReportID = RS.ReportID
	INNER JOIN tblUser ON RS.UserID = tblUser.UserID
	LEFT OUTER JOIN tblLang ON tblLang.LangCode = RS.ParamLangCode
	LEFT OUTER JOIN tblLangInterface ON  paramlanginterfacename = tblLangInterface.langinterfacename
	LEFT OUTER JOIN tblLangResource ON  tblLangResource.langresourcename = ''rptreporttitle''
	LEFT OUTER JOIN tblLangValue ON tblLang.LangID = tblLangValue.LangID   AND (tblLangValue.Active = 1) and tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID and tblLangValue.LangResourceID = tblLangResource.LangResourceID

	WHERE ScheduleID = @ScheduleID


END
' 
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_GetNextUrgentReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [prcReport_GetNextUrgentReport]

AS
BEGIN
-- Only returns NOW schedules - Send these first to give a greater sense of response by the application
-- NEXTRUN is always saved in UTC to reduce conversion times
-- NextRun is never null
SET NOCOUNT ON

	DECLARE @ScheduleID int,
	@RunDate datetime, 
	@ReportStartDate datetime, 
	@ReportFrequencyPeriod char(1), 
	@ReportFrequency int, 
	@OrgID int	,
	@ReportFromDate datetime,
	@NumberDelivered int,
	@NumberOfReports int,
	@ReportEndDate datetime,
	@ReportPeriodType int,
	@ReportID int,
	@DateFrom DateTime
	
	UPDATE tblReportSchedule -- remove schedules for inactive users
	SET NumberDelivered = 0,
	TerminatedNormally = 1,
	LastRun = getUTCdate(),
	NextRun = null
	WHERE ScheduleID in 
	(
		SELECT ScheduleID 
		FROM tblReportSchedule
		INNER JOIN tblUser ON tblReportSchedule.UserID = tblUser.UserID
		WHERE (TerminatedNormally = 0)
		AND (IsPeriodic = ''N'')
		AND (tblUser.Active = 0)
	)

SELECT @ScheduleID = ScheduleID
FROM tblReportSchedule
INNER JOIN tblReportInterface ON tblReportSchedule.ReportID = tblReportInterface.ReportID
INNER JOIN tblUser ON tblReportSchedule.UserID = tblUser.UserID
INNER JOIN tblOrganisation ON tblOrganisation.OrganisationID = tblReportSchedule.ParamOrganisationID
WHERE  CourseStatusLastUpdated > dbo.udfGetSaltOrgMidnight(tblUser.OrganisationID)
AND (TerminatedNormally = 0)
AND (IsPeriodic = ''N'')
AND (tblUser.Active = 1)

DECLARE @OnBehalfOf nvarchar(255)
DECLARE @ReplyTo nvarchar(255)
DECLARE @FromDate DateTime = CAST(''1 Jan 2002'' as datetime)

	IF (@ScheduleID IS NOT NULL)
	BEGIN
		DECLARE @NextRun datetime
		SELECT @NextRun = NextRun,
		@ReportStartDate = ReportStartDate,
		@ReportFrequencyPeriod = ReportFrequencyPeriod,
		@ReportFrequency = ReportFrequency,
		@OrgID = ParamOrganisationID,
		@ReportFromDate = ReportFromDate,
		@NumberDelivered = NumberDelivered, 
		@NumberOfReports = NumberOfReports, 
		@ReportEndDate = ReportEndDate ,
		@ReportPeriodType = coalesce(ReportPeriodType ,3),
		@ReportID = ReportID,
		@DateFrom = ParamDateFrom
		FROM tblReportSchedule WHERE ScheduleID = @ScheduleID
	
	-- update the Report Schedule
	UPDATE tblReportSchedule 
	SET NumberDelivered = NumberDelivered + 1,
	TerminatedNormally = 1,
	LastRun = getUTCdate(),
	NextRun = cast(''1 jan 2050'' as datetime),
	LastUpdatedBy=0,
	Lastupdated=getUTCdate()
	WHERE ScheduleID = @ScheduleID



	-- we know the ''to'' date - just need to read the ''from'' date
    SET @FromDate = @ReportStartDate



END -- IF ScheduleID is not null


-- return the results
SET NOCOUNT OFF
SELECT TOP (1) [ScheduleID]
,RS.UserID
,RS.ReportID
,[LastRun]
,[ReportStartDate]
,[ReportFrequency]
,[ReportFrequencyPeriod]
,[DocumentType]
,[ParamOrganisationID]
,[ParamCompleted]
,[ParamStatus]
,[ParamFailCount]
,[ParamCourseIDs]
,[ParamHistoricCourseIDs]
,[ParamAllUnits]
,[ParamTimeExpired]
,[ParamTimeExpiredPeriod]
,[ParamQuizStatus]
,[ParamGroupBy]
,[ParamGroupingOption]
,[ParamFirstName]
,[ParamLastName]
,[ParamUserName]
,[ParamEmail]
,[ParamIncludeInactive]
,[ParamSubject]
,[ParamBody]
,[ParamProfileID]
,[ParamProfilePeriodID]
,[ParamPolicyIDs]
,[ParamAcceptance]
,[ParamOnlyUsersWithShortfall]
,[ParamEffectiveDate]
,[ParamSortBy]
,[ParamClassificationID]
,ParamLangInterfaceName
, case
when tblReportinterface.ReportID = 26 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.2''))
when tblReportinterface.ReportID = 27 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.2''))
when tblReportinterface.ReportID = 3 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.1''))
when tblReportinterface.ReportID = 6 then (select coalesce(LangEntryValue,''Missing Localisation'') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = RS.ParamLangCode) and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''/Reporting/Admin/AdministrationReport.aspx'') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = ''lblPageTitle.1''))
when (tblReportinterface.ReportID = 22) or (tblReportinterface.ReportID = 23) or (tblReportinterface.ReportID = 24) or (tblReportinterface.ReportID = 10) 
then 
	(
		select coalesce(LangEntryValue, (select coalesce(tblLangValue.LangEntryValue,''Missing Localisation'') FROM tblLangValue where tblLang.LangID = tblLangValue.LangID   AND (tblLangValue.Active = 1) and tblLangValue.LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = ''Report.Summary'') and tblLangValue.LangResourceID = tblLangResource.LangResourceID))
	)

else coalesce(tblLangValue.LangEntryValue,''Missing Localisation'')
end as ReportName
,tblReportInterface.RDLname
,tblUser.FirstName
,tblUser.LastName
,tblUser.Email
,ParamUnitIDs
,paramOrganisationID
,RS.ParamLangCode
,ParamLangCode
,ParamLicensingPeriod
,RS.ReportEndDate
,RS.ReportTitle
,RS.NumberOfReports
,RS.ReportFromDate
,(dbo.udfGetCCList(RS.ScheduleID)) as CCList
,RS.ReportPeriodType
,dbo.udfGetEmailOnBehalfOf (ParamOrganisationID) as OnBehalfOf
,RS.NextRun
,RS.ReportFromDate
,@FromDate as FromDate
,dbo.udfGetEmailReplyTo (ParamOrganisationID,tblUser.FirstName + '' '' + tblUser.LastName + '' <'' + tblUser.Email + ''>'') as ReplyTo
,CASE when exists (SELECT Value FROM  tblAppConfig WHERE (Name = ''SEND_AUTO_EMAILS'') AND (UPPER(Value) = ''YES'')) then 0 ELSE 1 END as StopEmails
,CAST(convert( varchar(11), dbo.udfUTCtoDaylightSavingTime(DATEADD(d,1,GETUTCDATE()),@OrgID),113) AS DateTime) as Tomorrow
,CASE when tblUser.usertypeid=4 then dbo.udfUser_GetAdministratorsEmailAddress (tblUser.UserID) else tblUser.Email end as SenderEmail
,IsPeriodic
FROM
tblReportinterface
inner join tblReportSchedule RS  on tblReportinterface.ReportID = RS.ReportID
INNER JOIN tblUser ON RS.UserID = tblUser.UserID
LEFT OUTER JOIN tblLang ON tblLang.LangCode = RS.ParamLangCode
LEFT OUTER JOIN tblLangInterface ON  paramlanginterfacename = tblLangInterface.langinterfacename
LEFT OUTER JOIN tblLangResource ON  tblLangResource.langresourcename = ''rptreporttitle''
LEFT OUTER JOIN tblLangValue ON tblLang.LangID = tblLangValue.LangID   AND (tblLangValue.Active = 1) and tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID and tblLangValue.LangResourceID = tblLangResource.LangResourceID

WHERE ScheduleID = @ScheduleID


	-- remove spent "NOW" Schedule to reduce size of table
	DELETE FROM tblReportSchedule 
	WHERE ScheduleID = @ScheduleID
	
END
' 
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcCourse_AdminMashup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:		Compiles a bunch of info based on the selected units/courses then filters it based on administrator selection
Parameters:		Comma separated list of userID:courseID, comma separated list of adminID (unit administrators)
Returns:		table (lastname firstname userid email course_names)

Called By:		BusinessServices.Course.GetAdminMashup in Course.cs
Calls:			None

Remarks:		None

Author:			Mark Donald
Date Created:	20 Jan 2010

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE PROCEDURE [prcCourse_AdminMashup]
@organisationID int,
@unitIDs 			varchar(MAX),
@courseIDs 			varchar(8000),
@input_csv varchar(8000),
@adminids varchar(8000),
@classificationID 	int,
@courseModuleStatus	int,
@quizDateFrom 		datetime,
@quizDateTo 		datetime,
@includeInactive	int
AS
BEGIN
SET NOCOUNT ON;


set @quizDateFrom = dbo.udfDaylightSavingTimeToUTC(@quizDateFrom, @organisationID)
set @quizDateTo = dbo.udfDaylightSavingTimeToUTC(@quizDateTo, @organisationID)

declare @tblUserUnit table
(
UserID int,
UnitID int
)


declare @tblUnit table
(
unitID int
)

declare @tblUnitAdministrator table
(
unitID int,
AdminUserID int,
firstname nvarchar(200),
lastname nvarchar(200)
)
Set Nocount On
Declare
@CONST_INCOMPLETE     	int,
@CONST_COMPLETE     	int,
@CONST_FAILD            int,
@CONST_NOTSTARTED 	    int,
@CONST_UNKNOWN 	        int,
@CONST_EXPIRED_TIMELAPSED int,
@CONST_EXPIRED_NEWCONTENT int

set @CONST_INCOMPLETE	= 0
set @CONST_COMPLETE	    = 1
set @CONST_FAILD		= 2
set @CONST_NOTSTARTED	= 3
set @CONST_EXPIRED_TIMELAPSED	= 4
set @CONST_EXPIRED_NEWCONTENT  = 5

DECLARE @Units TABLE (UnitID INT)
DECLARE @Courses TABLE (CourseID INT)
DECLARE @CoursesWithAccess TABLE (CourseID INT PRIMARY KEY, [name] nvarchar(100))
DECLARE @UserModuleWithAccess TABLE (UserID INT, ModuleID INT, UnitID INT, PRIMARY KEY(UserID, ModuleID, UnitID))
DECLARE @AllModules TABLE (ModuleID INT PRIMARY KEY(ModuleID))
DECLARE @Users TABLE (UserID INT, UnitID INT PRIMARY KEY(UserID, UnitID))
DECLARE @UsersNQuizStatus TABLE (
UserID	INT, ModuleID INT, LatestQuizID INT, QuizStatusID INT, QuizScore INT,
PRIMARY KEY(UserID, ModuleID, LatestQuizID, QuizStatusID)
)
DECLARE @UsersQuizStatusNOTSTARTED TABLE (
UserID	INT, ModuleID INT, LatestQuizID INT, QuizStatusID INT, QuizScore INT,
PRIMARY KEY(UserID, ModuleID, LatestQuizID, QuizStatusID)
)
DECLARE @mashup TABLE (userid int, courseid int)
DECLARE @selectedadmin TABLE (adminid int)
DECLARE
@pos int,
@colon_pos int,
@temp varchar(50)

INSERT INTO
@Courses
SELECT
*
FROM
dbo.udfCsvToInt(@courseIDs)

INSERT INTO
@Units
SELECT
*
FROM
dbo.udfCsvToInt(@unitIDs)

INSERT INTO
@selectedadmin
SELECT
*
FROM
dbo.udfCsvToInt(@adminids)

--Get Rid of courses which do not have access to specified org
INSERT INTO
@CoursesWithAccess
SELECT
A.CourseID, [name]
FROM
@Courses A, tblOrganisationCourseAccess B, tblCourse C
WHERE
A.CourseID = B.GrantedCourseID
AND B.OrganisationID = @organisationID
AND A.CourseID = C.CourseID
AND C.Active = 1

--Get All the users for all specfied units
INSERT INTO
@Users
SELECT
DISTINCT A.UserID, A.UnitiD
FROM
tblUser A
join  @Units B on A.UnitID = B.UnitID
join  tblUnit C on B.UnitID = C.UnitID  AND C.Active = 1
WHERE
@includeinactive =1 or A.Active = 1 -- show all or only active users



if @courseModuleStatus = @CONST_COMPLETE or @courseModuleStatus = @CONST_INCOMPLETE
begin -- completed / -- InComplete
--------------------
-- Completed --
--------------------
-- A user is completed if they became complete and remained completed in the period of interest
-- the query only needs to check to see status at the max date in this period as a line item
-- as tblUserCourseStatus is only writen to when an event occours that would
-- change the status.
-- When "Course/Module Status" is set to "Complete"
-- This will find users that:
-- - Belong to any of the Units in @unitIDs
-- - AND are currently assigned Modules from the selected Course
-- - AND have the Custom Classification option (if provided)
-- - AND have (at the end of the time-period in question) got a status of Complete in tblUserCourseStatus
-- - AND the event that made them complete happened some time in the time-period in question
--------------------
-- InComplete
--------------------
-- A user is in-completed if for any reason they are not complete but do have access to the course
-- This will find users that:
-- - Belong to any of the Units in @unitIDs
-- - AND are currently assigned Modules from the selected Course
-- - AND have the Custom Classification option (if provided)
-- - AND have (at the end of the time-period in question) got a status of Incomplete in tblUserCourseStatus
-- - AND the event that made them complete happened some time in the time-period in question

INSERT INTO @tblUserUnit(UserID, UnitID)
SELECT
DISTINCT A.UserID, A.UnitID
FROM
(SELECT
A.UserID, D.UnitID
FROM
(SELECT
A.UserID, A.CourseID, MAX(A.UserCourseStatusID) AS ''LatestCourseStatus''
FROM
tblUserCourseStatus A, @CoursesWithAccess B
WHERE
A.DateCreated < DATEADD(DD, 1, @quizDateTo)
and A.CourseID = B.CourseID
GROUP BY
A.UserID, A.CourseID
) A, @Users B, tblUserCourseStatus C, tblUser D
WHERE
A.UserID = B.UserID
AND B.UserID = C.UserID
AND A.LatestCourseStatus = C.UserCourseStatusID
AND (C.DateCreated BETWEEN @quizDateFrom AND @quizDateTo)
AND C.CourseStatusID = case @courseModuleStatus
when @CONST_COMPLETE then 2   -- Complete
when @CONST_INCOMPLETE then 1 -- InComplete
end
AND A.UserID = D.UserID
) A
LEFT JOIN tblUserClassification ON tblUserClassification.UserID = A.UserID
AND tblUserClassification.classificationID = isnull( @classificationID, tblUserClassification.classificationID )
WHERE
--If classification is Any (0), This will find users of any Custom Classification
(@classificationID =0 OR tblUserClassification.classificationID = @classificationID)
AND A.UserID IN (select UserID from tblUser where OrganisationID = @organisationID and Active = 1)
ORDER BY
A.UserID, A.UnitID
END -- completed / -- InComplete


if @courseModuleStatus = @CONST_FAILD or @courseModuleStatus = @CONST_EXPIRED_TIMELAPSED or @courseModuleStatus = @CONST_EXPIRED_NEWCONTENT
begin -- Failed
--------------------
-- Failed  --
--------------------
-- When "Course/Module Status" is set to "Failed"
-- This will find users that:
--  - Belong to any of the Units in @unitIDs
--  - AND are currently assigned Modules from the selected Course
--  - AND have the Custom Classification option
--  - AND took a quiz, for a Module within the selected Course, within the date range and failed it
--  - AND who currently have a status other than "Passed" for that same quiz
--------------------

INSERT INTO
@UserModuleWithAccess
SELECT
DISTINCT A.UserID, A.ModuleID, A.UnitID
FROM
(SELECT
A.UserID, A.ModuleID, A.UnitID
FROM
vwUserModuleAccess A
where
courseid in (SELECT courseid from @Courses)
)A, @Users B
Where
A.UserID = B.UserID

--Find the latest status of all quiz for all the modules
INSERT INTO
@UsersNQuizStatus
SELECT
DISTINCT A.UserID, A.ModuleID, A.LatestQuizID, B.QuizStatusID, B.QuizScore
FROM
(SELECT
A.UserID, A.ModuleID, MAX(B.UserQuizStatusID) AS ''LatestQuizID''
FROM
@UserModuleWithAccess A, tblUserQuizStatus B
WHERE
A.UserID = B.UserID
AND A.ModuleID = B.ModuleID
GROUP BY
A.UserID, A.ModuleID
) A, tblUserQuizStatus B
WHERE
A.UserID = B.UserID
AND A.ModuleID = B.ModuleID
AND A.LatestQuizID = B.UserQuizStatusID

INSERT INTO
@UsersQuizStatusNOTSTARTED
SELECT
*
FROM
@UsersNQuizStatus
WHERE
QuizStatusID = case @courseModuleStatus
when @CONST_FAILD then 3   -- Failed
when @CONST_EXPIRED_TIMELAPSED then 4 -- Expired time lapsed
when @CONST_EXPIRED_NEWCONTENT then 5 -- Expired new content
end

--Get Data in report format
INSERT INTO @tblUserUnit(UserID, UnitID)
SELECT
DISTINCT A.UserID, UnitID
FROM
(select
distinct userid, moduleid
from
@UsersQuizStatusNOTSTARTED
) A, tblUser B, tblModule D
WHERE
A.UserID = B.UserID
AND A.ModuleID = D.ModuleID
AND D.Active = 1
ORDER BY
A.UserID, UnitID
end --/ Failed


-- Not started --

if @courseModuleStatus = @CONST_NOTSTARTED
begin -- Not started - Any
--------------------
-- Not started  --
--------------------
-- When "Course/Module Status" is set to "Not Started"
-- This will find users that:
--  - Belong to any of the Units in @unitIDs
--  - AND are currently assigned Modules from the selected Course
--  - AND have the Custom Classification option
--  - AND who have not started ANY of the quizes they have access to in this course
--------------------

INSERT INTO
@UserModuleWithAccess
SELECT
DISTINCT A.UserID, A.ModuleID, A.UnitID
FROM
(SELECT
A.UserID, A.ModuleID, A.UnitID
FROM
vwUserModuleAccess A
where
courseid in (SELECT courseid from @Courses)
) A, @Users B
Where
A.UserID = B.UserID

--Find the latest status of all quiz for all the modules
INSERT INTO
@UsersNQuizStatus
SELECT
DISTINCT A.UserID, A.ModuleID, A.LatestQuizID, B.QuizStatusID, B.QuizScore
FROM
(SELECT
A.UserID, A.ModuleID, MAX(B.UserQuizStatusID) AS ''LatestQuizID''
FROM
@UserModuleWithAccess A, tblUserQuizStatus B
WHERE
A.UserID = B.UserID
AND A.ModuleID = B.ModuleID
GROUP BY
A.UserID, A.ModuleID
) A, tblUserQuizStatus B
WHERE
A.UserID = B.UserID
AND A.ModuleID = B.ModuleID
AND A.LatestQuizID = B.UserQuizStatusID
AND (B.DateCreated BETWEEN @quizDateFrom AND @quizDateTo)

--select * from @UsersNQuizStatus

--Get User with Quiz NOT STARTED
INSERT INTO
@UsersQuizStatusNOTSTARTED
SELECT
*
FROM
@UsersNQuizStatus
WHERE
QuizStatusID NOT IN (2,3)
AND UserID NOT IN (SELECT UserID FROM @UsersNQuizStatus WHERE QuizStatusID IN (2,3))

--select * from @UsersQuizStatusNOTSTARTED
--select distinct userid,moduleid from @UsersQuizStatusNOTSTARTED

--Get Data in report format
INSERT INTO @tblUserUnit(UserID, UnitID)
SELECT
A.UserID, UnitID
FROM
(SELECT
DISTINCT A.UserID, B.UnitID
FROM
(SELECT
DISTINCT userid, moduleid
FROM
@UsersQuizStatusNOTSTARTED
) A, tblUser B, tblModule D
WHERE
A.UserID = B.UserID
AND A.ModuleID = D.ModuleID
AND D.Active = 1
) A
LEFT JOIN tblUserClassification ON tblUserClassification.UserID = A.UserID
AND tblUserClassification.classificationID = isnull( @classificationID, tblUserClassification.classificationID )
WHERE
--If classification is Any (0), This will find users of any Custom Classification
@classificationID =0 OR tblUserClassification.classificationID = @classificationID
ORDER BY
A.UserID, UnitID

end --/ Not started - Any


insert into @tblUnit(UnitID)
select distinct UnitID
from @tblUserUnit

---If "Administrators" was selected as the Recipient Type, then the email will be sent to the administrators of the users Units.
insert into @tblUnitAdministrator (UnitID, AdminUserID,firstname, lastname)
select u.UnitID, ua.UserID, us.firstname, us.lastname
from @tblUnit u
inner join tblUnitAdministrator ua
on ua.UnitID = u.UnitID
inner join tblUser us
on us.UserID = ua.UserID and us.UserTypeID = 3 --Unit Administrator

--If a user belongs to a Unit that does not have its own administrator, the email will go to the Organisation Administrators.
insert into @tblUnitAdministrator (UnitID, AdminUserID,firstname, lastname)
select u.UnitID, us.UserID, us.firstname, us.lastname
from tblUser us
cross join @tblUnit u
where us.OrganisationID = @organisationID
and us.UserTypeID = 2 -- Organisation Administrator
and u.UnitID not in (select UnitID from @tblUnitAdministrator)
and us.Active = 1


-- clean up the input so it resembles ''userid:courseid,userid:courseid,''
SELECT @input_csv = replace(rtrim(ltrim(replace(replace(replace(@input_csv,'' '',''''),'',,'','',''),'','','' ''))),'' '','','') + '',''

-- rip input_csv
WHILE patindex(''%,%'', @input_csv) <> 0
BEGIN
SELECT @pos = patindex(''%,%'', @input_csv)
SELECT @temp = left(@input_csv, @pos - 1)
SELECT @colon_pos = patindex(''%:%'', @input_csv)
INSERT @mashup VALUES (
cast(substring(@temp, 1, @colon_pos - 1) AS int),
cast(substring(@temp, @colon_pos + 1, len(@temp)) AS int)
)
SELECT @input_csv = substring(@input_csv, @pos + 1, len(@input_csv))
END

-- join @mashup, @tblunitadministrator & @selectedadmin tables & sort results by adminid and courseid
SELECT
adminid, a.email, a.firstname, a.lastname, m.courseid, [name] coursename, u.firstname, u.lastname, n.firstname, n.lastname, u.UserID
FROM
@mashup m,
@tblunitadministrator n,
@selectedadmin s,
tbluser a,
tblcourse c,
tbluser u
WHERE
u.userid = m.userid
AND n.unitid = u.unitid
AND a.userid = adminid
AND adminid = adminuserid
AND c.courseid = m.courseid
ORDER BY
adminid, m.courseid

END
' 
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcQuizSession_UpdateEndQuizInfo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Update record in tblQuizSession
Insert record into tblUserQuizStatus
Insert record into tblUserCourseStatus

Returns:
data table

Called By:
ToolBook.cs: UpdateEndQuizInfo

Author: Li Zhang
Date Created: 13-10-2006
Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	mikev		1/5/2007		Added QuizCompletionDate
**/

CREATE PROCEDURE [dbo].[prcQuizSession_UpdateEndQuizInfo]
(
@QuizSessionID	varchar(50) -- unique GUID that identifies this toolbook quiz session
, @Duration	int -- the duration in seconds of the quiz as mesured by toolbook
, @Score 	int -- the score as mesured by toolbook
, @UserID	int	-- user id
, @QuizID	int -- quiz id
, @PassMark	int	-- quiz pass mark
, @UnitID	int	-- user''s unit id
, @ModuleID	int -- quiz module id
, @CourseID	int -- module course id
, @OldCourseStatus	int -- course status before update
, @NewQuizStatus int -- the quiz status
, @NewCourseStatus	int	-- course status after update
, @QuizFrequency	int -- quiz frequency
, @QuizCompletionDate	datetime -- quiz completiondate
)
AS
SET nocount on
SET xact_abort on
BEGIN TRANSACTION

declare @createrec as bit
set @createrec = 0


declare @OrgID int
select @OrgID = organisationID from tblUnit where tblUnit.UnitID=@UnitID

set @QuizCompletionDate = dbo.udfDaylightSavingTimeToUTC(@QuizCompletionDate, @OrgID)

DECLARE @dateCreated datetime
SET @dateCreated = GETUTCDATE()

IF EXISTS
(
SELECT QuizSessionID
FROM tblQuizSession
WHERE QuizSessionID = @QuizSessionID
AND	DateTimeStarted IS NOT NULL
AND DateTimeCompleted IS NULL
)
BEGIN
	-- < update tblQuizSession >--
	UPDATE tblQuizSession
	SET DateTimeCompleted = @dateCreated
	, Duration = DATEDIFF(second,DateTimeStarted,@dateCreated)
	, QuizScore = @Score
	, QuizPassMark = @PassMark
	WHERE
	QuizSessionID = @QuizSessionID

	--< insert into tblUserQuizStatus >--
	INSERT INTO
	tblUserQuizStatus
	(
	UserID,
	ModuleID,
	QuizStatusID,
	QuizFrequency,
	QuizPassMark,
	QuizCompletionDate,
	QuizScore,
	QuizSessionID,
	DateCreated
	)
	VALUES
	(
	@UserID,
	@ModuleID,
	@NewQuizStatus,
	@QuizFrequency,
	@PassMark,
	@QuizCompletionDate,
	@Score,
	@QuizSessionID,
	@dateCreated
	)

	--< insert into tblUserCourseStatus >--

	-- if the user redo the quiz when they are still having a completed user course status
	-- check if the last 2 course status is a completed status
	-- if it is then we update the date of the last course status id to avoid new rows being inserted
	-- if not we just add a new row
	IF (@OldCourseStatus=2 and @OldCourseStatus = @NewCourseStatus)
	BEGIN
		
		declare @csdate datetime
		
		
		select top 1 @csdate = DateCreated 
		from tblUserCourseStatus 
		where UserID = @UserID 	and CourseID =@CourseID
		order by DateCreated desc

		declare @modss  table (moduleid int, dt datetime )

		insert into   @modss
		select m.moduleid, max(uqs.DateCreated) as dt
		 from tblUserQuizStatus uqs
		 -- join tblUserModuleAccess uma on uma.UserID = uqs.UserID and uma.ModuleID = uqs.ModuleID and uma.Granted = 1
		 join vwUserModuleAccess uma on uma.UserID = uqs.UserID and uma.ModuleID = uqs.ModuleID
		join tblModule m on m.ModuleID = uqs.ModuleID
		where m.CourseID =@CourseID and uqs.UserID = @UserID and QuizStatusID =2
		group by m.ModuleID

		select @createrec = case when MIN(dt)>@csdate then 1 else 0 end
		from @modss

		if(@createrec =1)
		begin
			EXEC prcUserCourseStatus_Insert @UserID, @ModuleID, @NewCourseStatus
		end

	END
	ELSE IF (@OldCourseStatus = -1) or (@OldCourseStatus <> @NewCourseStatus)	
	BEGIN
	
		if(@NewCourseStatus=2) begin
			set @createrec =1
		end
		
		EXEC prcUserCourseStatus_Insert @UserID, @ModuleID, @NewCourseStatus
	END
	ELSE BEGIN
		IF NOT EXISTS (SELECT UserID FROM vwUserModuleAccess where UserID = @UserID AND CourseID = @CourseID) AND
		EXISTS (SELECT UserCourseStatusID FROM tblUserCourseStatus WHERE UserID = @UserID AND CourseID = @CourseID AND CourseStatusID <> 0)
		BEGIN
			EXEC prcUserCourseStatus_Insert @UserID, @ModuleID,  0
		END
	END

END


COMMIT TRANSACTION

select @createrec as sendcert 
' 
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [prcUser_Update] 
(
	@userID Integer = Null,
	@unitID Integer = Null,
	@firstName nvarchar(50) = Null,
	@lastName nvarchar(50) = Null,
	@userName nvarchar(100) = Null,
	@email nvarchar(100) = null,
	@active bit = null,
	@userTypeID Integer = Null,
	@updatedByUserID Integer = Null,
	@dateUpdated datetime = Null,
	@password nvarchar(50) = Null,
	@oldPassword nvarchar(50) = Null,
	@externalID nvarchar(50) = Null,
	@TimeZoneID Integer = Null,
	@DelinquencyManagerEmail nvarchar(100) = Null,
	@NotifyUnitAdmin bit = null,
	@NotifyOrgAdmin bit = null,
@NotifyMgr bit = null,
@EbookNotification bit = 0
)

As BEGIN

	Set NoCount On
	Set Xact_Abort On

	Begin Transaction

	-- Declarations
	Declare @strErrorMessage Varchar(200) -- Holds the error message
	Declare @OrgTimeZone Integer -- Holds the ORG timezone
	Declare @intErrorNumber Integer -- Holds the error number
	Declare @UpdatedByUserTypeID Integer -- Holds the UserTypeID for the Updating user.
	Declare @blnChangePassword bit			-- Boolean value to indentify update of the password
	Declare @strCurrentPassword nvarchar(50) -- Holds the current password in the DB for this user
	Declare @strCurrentUserName nvarchar(100) -- Holds the current username in the DB for this user
	Declare @strCurrentEmail nvarchar(100) -- Holds the current email in the DB for this user
	Declare @organisationID Integer -- Used to set the OrgID to null when updating a SALT Administrator
	Declare @dteCurrentDateUpdated datetime -- Holds the current dateupdated in the DB for this user

	-- Initialise variables
	Set @strErrorMessage = ''''
	Set @intErrorNumber = 0
	Set @blnChangePassword = 0

	-- PARAMETER VALIDATION
	--==============================================================

	-- Verify @UnitID and OrgID
	Select
		@organisationID = OrganisationID
	From
		tblUser
	Where
		UserID = @userID

	--==================================================
	-- If 0 passed in (for a SALT Admin), insert nulls for
	-- Unit and Org IDs
	if (@UnitID = 0)
	begin
		Set @UnitID = null
		Set @OrganisationID = null
	end

	Select
		@OrgTimeZone = TimeZoneID
	From
		tblOrganisation
	Where
		OrganisationID = @OrganisationID

	if (@OrgTimeZone = @TimeZoneID)
	begin
		Set @TimeZoneID = null
	end

	--Missing or Null parameter {0} in stored procedure prcUser_Update
	--Validate Parameter @userID
	If(@userID Is Null)
	Begin
		Set @intErrorNumber = 5
		Set @strErrorMessage = ''Missing or Null parameter @userID in stored procedure prcUser_Update''
		Goto Finalise
	End

	-- If user type is not SALT Administrator, validate parameter @UnitID
	If(@userTypeID <> 1)
	Begin
		If(@unitID Is Null)
		Begin
			Set @intErrorNumber = 5
			Set @strErrorMessage = ''Missing or Null parameter @unitID in stored procedure prcUser_Update''
			Goto Finalise
		End
	End

	--Validate Parameter @firstName
	If(@firstName Is Null)
	Begin
		Set @intErrorNumber = 5
		Set @strErrorMessage = ''Missing or Null parameter @firstName in stored procedure prcUser_Update''
		Goto Finalise
	End

	--Validate Parameter @lastName
	If(@lastName Is Null)
	Begin
		Set @intErrorNumber = 5
		Set @strErrorMessage = ''Missing or Null parameter @lastName in stored procedure prcUser_Update''
		Goto Finalise

	End

	--Validate Parameter @userName
	If(@userName Is Null)
	Begin
		Set @intErrorNumber = 5
		Set @strErrorMessage = ''Missing or Null parameter @userName in stored procedure prcUser_Update''
		Goto Finalise
	End

	--Validate Parameter @email
	If(@email Is Null)
	Begin
		Set @intErrorNumber = 5
		Set @strErrorMessage = ''Missing or Null parameter @email in stored procedure prcUser_Update''
		Goto Finalise
	End

	--Validate Parameter @active
	If(@active Is Null)
	Begin
		Set @intErrorNumber = 5
		Set @strErrorMessage = ''Missing or Null parameter @active in stored procedure prcUser_Update''
		Goto Finalise
	End

	--Validate Parameter @userTypeID
	If(@userTypeID Is Null)
	Begin
		Set @intErrorNumber = 5
		Set @strErrorMessage = ''Missing or Null parameter @userTypeID in stored procedure prcUser_Update''
		Goto Finalise
	End

	--Validate Parameter @updatedByUserID
	If(@updatedByUserID Is Null)
	Begin
		Set @intErrorNumber = 5
		Set @strErrorMessage = ''Missing or Null parameter @updatedByUserID in stored procedure prcUser_Update''
		Goto Finalise
	End

	--Validate Parameter @dateUpdated
	If(@dateUpdated Is Null)
	Begin
		Set @intErrorNumber = 5
		Set @strErrorMessage = ''Missing or Null parameter @dateUpdated in stored procedure prcUser_Update''
		Goto Finalise
	End

	-- Validate User Exists
	--=========================================================
	If Not Exists(Select * From tblUser Where UserID = @userID)
	Begin
		Set @intErrorNumber = 1
		Set @strErrorMessage = ''This record no longer exists please refresh your screen.  If the problem persists please contact your administrator.''
		Goto Finalise
	End

	-- If a unit was specified make sure it exists
	--=========================================================
	If (@unitID Is Not Null)
	Begin
		If Not Exists(Select * From tblUnit Where UnitID = @unitID)
		Begin
			Set @intErrorNumber = 11
			Set @strErrorMessage = ''The specified unit could be found or may not be active.''
			Goto Finalise
		End
	End

	-- Integrity Constraint
	--=========================================================
	Select
		@dteCurrentDateUpdated = DateUpdated
	from
		tblUser
	Where
		UserID = @userID


	/*If (DateDiff(s, @dteCurrentDateUpdated, @dateUpdated) <> 0)
	Begin
	Set @intErrorNumber = 7
	Set @strErrorMessage = ''This record has already been updated by another user, please refresh your screen. If the problem persists please contact your administrator.''
	Goto Finalise
	End */


	-- Validate Passwords
	--=======================

	-- get Updating User, UserTypeID
	Select
		@UpdatedByUserTypeID = UserTypeID
	from
		tblUser
	Where
		UserID = @updatedByUserID

	if(@UpdatedByUserTypeID = 4)
	Begin

		-- SALT User
		If (@password Is Not Null or @oldPassword Is Not Null)
		Begin
			If(@password Is Null)
			Begin
				Set @intErrorNumber = 5
				Set @strErrorMessage = ''Missing or Null parameter @password in stored procedure prcUser_Update''
				Goto Finalise
			End

			If(@oldPassword Is Null)
			Begin
				Set @intErrorNumber = 5
				Set @strErrorMessage = ''Missing or Null parameter @oldPassword in stored procedure prcUser_Update''
				Goto Finalise
			End

			-- Get the current password in the DB
			Select
				@strCurrentPassword = Password
			From
				tblUser
			Where
				UserID = @userID

			-- Ensure old password match current password otherwise error
			if(@oldPassword <> @strCurrentPassword)
			Begin
				Set @intErrorNumber = 4
				Set @strErrorMessage = ''Your old password was entered incorrectly so the user details have not been saved. ''
				Set @strErrorMessage = @strErrorMessage + ''Please try again and if the problem persists please contact your administrator.''
				Goto Finalise
			End

			Set @blnChangePassword = 1
		End
	End
	else
	Begin
		-- Administrator
		-- if there is a value in @oldPassword then admin is attempting to update their own password
		if(@oldPassword Is Not Null)
			Begin
			-- Get the current password in the DB
			Select
				@strCurrentPassword = Password
			From
				tblUser
			Where
				UserID = @userID

			-- Ensure old password match current password otherwise error
			if(@oldPassword <> @strCurrentPassword)
			Begin
				Set @intErrorNumber = 4
				Set @strErrorMessage = ''Your old password was entered incorrectly so the user details have not been saved. ''
				Set @strErrorMessage = @strErrorMessage + ''Please try again and if the problem persists please contact your administrator.''
				Goto Finalise
			End

			Set @blnChangePassword = 1
		End

		If(@password Is Not Null)
		Begin
			Set @blnChangePassword = 1
		End
	End

	-- Validate Permisions
	--========================================
	if(@UpdatedByUserTypeID = 4)
	Begin
	-- Salt User can only update themselves
	if(@UpdatedByUserID <> @UserID)
	Begin
	Set @intErrorNumber = 41
	Set @strErrorMessage = ''You do not have the permissions required to update this user.''
	Goto Finalise
	End
	End


	-- Validate Unique UserName
	--========================================
	Select
	@strCurrentUserName = UserName
	From
	tblUser
	Where
	UserID = @userID

	-- Check for uniqueness if the username is changing
	if(@strCurrentUserName <> @userName)
	Begin
	If(@userTypeID <> 1)
	begin
	if Exists(Select * from tblUser where UserName = @userName and (organisationID=@organisationID or organisationID is null))
	Begin
	Set @intErrorNumber = 42
	Set @strErrorMessage = @userName
	Goto Finalise
	End
	end
	else
	begin
	if Exists(Select * from tblUser where UserName = @userName)
	Begin
	Set @intErrorNumber = 42
	Set @strErrorMessage = @userName
	Goto Finalise
	End
	end
	End


	-- Validate Unique UserName
	--========================================
	Select
	@strCurrentEmail = Email
	From
	tblUser
	Where
	UserID = @userID

	-- Check for uniqueness if the email address is changing
	if(@strCurrentEmail <> @email)
	If Exists(Select * From tblUser Where Email = @email)
	Begin
	Set @intErrorNumber = 43
	Set @strErrorMessage = @email
	Goto Finalise
	End


	-- only update if the user is moved to a new unit (so new unit is diff from the current unit)
	if (select unitid from tblUser where userid=@userid) <> @unitid
	begin


	-- update the profile access of the user
	-- give the user access to profiles for the selected unit
	update tbluserprofileperiodaccess set granted = 1
	where	userid = @userid
	and profileperiodid in (
	select profileperiodid from tblunitprofileperiodaccess where
	unitid = @unitID and granted = 1)

	-- give the user access to the policies for the selected unit.
	/*update tbluserpolicyaccess set granted = 1
	where	userid = @userid
	and policyid in (
	select policyid from tblunitpolicyaccess where
	unitid = @unitID and granted = 1)*/

	update upa1
	set upa1.granted = upa2.granted
	from tbluserpolicyaccess upa1
	inner join tblunitpolicyaccess upa2
	on upa1.policyid=upa2.policyid
	inner join tblPolicy p
	on upa1.policyid=p.policyid
	where
	upa1.userid=@userid and upa2.unitid=@unitid
	and p.deleted=0

	end



	-- Execute Update
	--===============================================================
	-- Update the record in tblUser
	if(@blnChangePassword = 1)
	Begin
		-- Update with password change
		Update 
			tblUser
		Set
			FirstName = @firstName,
			LastName = @lastName,
			UserName = @userName,
			Password = @password,
			Email = @email,
			OrganisationID = @organisationID,
			UnitID = @unitID,
			UserTypeID = @userTypeID,
			Active = @active,
			UpdatedBy = @updatedByUserID,
			DateUpdated = getutcDate(),
			ExternalID = @externalID,
			TimeZoneID = @TimeZoneID,
			DelinquencyManagerEmail = @DelinquencyManagerEmail,
			NotifyMgr = @NotifyMgr,
			NotifyOrgAdmin = @NotifyOrgAdmin,
NotifyUnitAdmin =@NotifyUnitAdmin,
EbookNotification = @EbookNotification
		Where
			UserID = @userID
	End
	Else
	Begin
		Update 
			tblUser
		Set
			FirstName = @firstName,
			LastName = @lastName,
			UserName = @userName,
			Email = @email,
			UnitID = @unitID,
			UserTypeID = @userTypeID,
			Active = @active,
			UpdatedBy = @updatedByUserID,
			DateUpdated = getutcDate(),
			ExternalID = @externalID,
			TimeZoneID = @TimeZoneID,
			DelinquencyManagerEmail = @DelinquencyManagerEmail,
			NotifyMgr = @NotifyMgr,
			NotifyOrgAdmin = @NotifyOrgAdmin,
NotifyUnitAdmin =@NotifyUnitAdmin,
EbookNotification = @EbookNotification
		Where
			UserID = @userID
	End


	update tblUser set DateArchived = getutcdate() where Active = 0 and DateArchived IS NULL AND UserID = @userID
	update tblUser set DateArchived = null where Active = 1 and NOT(DateArchived IS NULL) AND UserID = @userID


	-- update the user current status
	/*declare courseIDCursor cursor
	for
	select
	grantedcourseid
	from
	tblOrganisationCourseAccess oca
	where
	organisationid = (select organisationid from tblUser where userid=@userid)


	-- update course status for users
	declare @intOldCourseStatus int
	declare @intNewCourseStatus int
	declare @courseID int
	declare @moduleID int


	open courseIDCursor

	fetch next from courseIDCursor into @courseid
	while (@@FETCH_STATUS <> -1)
	begin
	if (@@FETCH_STATUS <> -2)
	begin
	exec @intOldCourseStatus = prcUserCourseStatus_GetStatus @courseID, @userID
	exec @intNewCourseStatus = prcUserCourseStatus_Calculate @courseID, @userID

	--select * from tbluser where userid=@userid

	--select * from tblUsercoursestatus where userid=@userid and courseid=@courseid

	print ''CourseID: '' + convert(varchar(10), @courseid)
	print ''Old Course Status : '' + convert(varchar(10), @intOldCourseStatus)
	print ''New Course Status : '' + convert(varchar(10), @intNewCourseStatus)

	if (@intOldCourseStatus <> -1) and (@intOldCourseStatus <> @intNewCourseStatus)
	begin
	print ''Insert''

	set @moduleID = (select top 1 m.moduleId from tblModule m where CourseID = @courseID and  and m.active = 1)  --prcUserCourseStatus_Insert will not update if module is inactive
	--print ''ModuleID: '' + convert(varchar(10), @moduleid)  + ''\n''
	exec prcUserCourseStatus_Insert @userID, @ModuleID, @intNewCourseStatus
	end
	end

	fetch next from courseIDCursor into @courseid
	end

	close courseIDCursor deallocate courseIDCursor*/



	-- Set the error message to successfull
	Set @strErrorMessage = ''Successfully Updated''

	-- Finalise the procedure
	Goto Finalise


	Finalise:
	If(@intErrorNumber > 0)
	Begin
	Rollback Transaction
	Select
	@intErrorNumber As ''ErrorNumber'',
	@strErrorMessage As ''ErrorMessage''
	End
	Else
	Begin
	Commit Transaction
	Select
	@intErrorNumber As ''ErrorNumber'',
	@strErrorMessage As ''ErrorMessage''
	End
END

' 
END
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisation_UpdateFeatureAccess]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'  

CREATE Procedure [prcOrganisation_UpdateFeatureAccess]
(
@OrganisationID int,
@featurename nvarchar(100),
@granted tinyint
)

As


if(@granted = 1)
begin

delete from tblOrganisationFeatureAccess
where
organisationid=@organisationid and featurename=@featurename

insert into tblOrganisationFeatureAccess
(organisationid, featurename, granted)
values
(@organisationid, @featurename, @granted)

end
else if(@granted = 0)
begin

delete from tblOrganisationFeatureAccess
where
organisationid=@organisationid and featurename=@featurename

end
'
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcEscalationConfigForCourse_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcEscalationConfigForCourse_Update]
(
	@remEscID int = -1,
	@orgID int ,
	@courseIDs varchar(max)  = '''',
	@updateOption int =-1,
	@DaysToCompleteCourse int,
	@RemindUsers bit=0,
	@NumOfRemNotfy int =-1,
	@RepeatRem int =-1,
	@NotifyMgr bit =0,
	@IndividualNotification bit =0,
	@IsCumulative bit =0,
	@NotifyMgrDays int=-1,
	@QuizExpiryWarn bit =0,
	@DaysQuizExpiry int =-1,
	@preexpiryInitEnrolment bit =0,
	@postExpReminder bit = 0,
	@postExpInitEnrolment bit = 0,
	@postExpResitPeriod bit = 0,
	@preExpResitPeriod bit = 0
)
AS
BEGIN

		--update existing ones
		update
		tblReminderEscalation
		set
		DaysToCompleteCourse = @DaysToCompleteCourse,
		RemindUsers = @RemindUsers,
		NumOfRemNotfy = @NumOfRemNotfy,
		RepeatRem = @RepeatRem,
		NotifyMgr = @NotifyMgr,
		IsCumulative = @IsCumulative,
		QuizExpiryWarn = @QuizExpiryWarn,
		DaysQuizExpiry = @DaysQuizExpiry,		
		NotifyMgrDays = @NotifyMgrDays,
		IndividualNotification = @IndividualNotification,
		PreExpInitEnrolment = @preexpiryInitEnrolment,
		PostExpReminder =@postExpReminder,
		PostExpInitEnrolment = @postExpInitEnrolment,
		PostExpResitPeriod = @postExpResitPeriod,
		PreExpResitPeriod = @preExpResitPeriod
		
		where
		OrgId =@orgID
		and CourseId IN (SELECT * FROM dbo.udfCsvToInt(@courseIDs))
	
		insert into tblReminderEscalation (
		OrgId,
		CourseId,
		DaysToCompleteCourse,
		RemindUsers,
		NumOfRemNotfy,
		RepeatRem,
		NotifyMgr,
		IsCumulative,
		QuizExpiryWarn,
		DaysQuizExpiry,
		NotifyMgrDays,
		IndividualNotification,
		PreExpInitEnrolment,
		PostExpReminder,
		PostExpInitEnrolment,
		PostExpResitPeriod,
		PreExpResitPeriod,
		DateEnabled
		)
		select 
		@orgID,
		c.CourseID,
		@DaysToCompleteCourse,
		@RemindUsers,
		@NumOfRemNotfy,
		@RepeatRem,
		@NotifyMgr,
		@IsCumulative,
		@QuizExpiryWarn,
		@DaysQuizExpiry,
		@NotifyMgrDays,
		@IndividualNotification,
		@preexpiryInitEnrolment,
		@postExpReminder,
		@postExpInitEnrolment,
		@postExpResitPeriod,
		@preExpResitPeriod,
		GETUTCDATE()
		from tblCourse c
		left join tblReminderEscalation re on re.CourseId = c.CourseID and re.OrgId = @orgID
		where re.CourseId is null and c.CourseID IN (SELECT * FROM dbo.udfCsvToInt(@courseIDs))
		
END' 
END
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcEmail_GetNext]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[prcEmail_GetNext]
AS
BEGIN

select
tblEmailQueue.EmailQueueID
into
#tblEmailsToPurge
FROM tblEmailQueue
inner join tblOrganisation on tblOrganisation.OrganisationID = tblEmailQueue.organisationID
join tblAppConfig on name  = ''SEND_AUTO_EMAILS''
where upper(Value) = ''NO''
or ( tblOrganisation.StopEmails = 1 
     and ( tblEmailQueue.[Subject] like ''%Student Summary%'' 
	       or tblEmailQueue.[Subject] like ''%Course Completion%'' 
           or tblEmailQueue.[Subject] like ''%Overdue Summary%'' 
         )
	)

INSERT INTO tblEmailPurged
([ToEmail]
,[ToName]
,[FromEmail]
,[FromName]
,[CC]
,[BCC]
,[Subject]
,[Body]
,[DateCreated]
,[OrganisationID])

SELECT  case when ((CHARINDEX (''>'',AddressTo) > 0) and (CHARINDEX (''<'',AddressTo) > 0)) then SUBSTRING(AddressTo,CHARINDEX (''<'',AddressTo)+1,CHARINDEX (''>'',AddressTo)-CHARINDEX (''<'',AddressTo)-1) else AddressTo end

,case when ((CHARINDEX (''>'',AddressTo) > 0) and (CHARINDEX (''<'',AddressTo) > 0)) then SUBSTRING(AddressTo,1,CHARINDEX (''<'',AddressTo)-1) else AddressTo end
,case when ((CHARINDEX (''>'',AddressFrom) > 0) and (CHARINDEX (''<'',AddressFrom) > 0)) then SUBSTRING(AddressFrom,CHARINDEX (''<'',AddressFrom)+1,CHARINDEX (''>'',AddressFrom)-CHARINDEX (''<'',AddressFrom)-1) else AddressFrom end
,case when ((CHARINDEX (''>'',AddressFrom) > 0) and (CHARINDEX (''<'',AddressFrom) > 0)) then SUBSTRING(AddressFrom,1,CHARINDEX (''<'',AddressFrom)-1) else AddressFrom end
,''''
,AddressBccs
,Subject
,Body
,QueuedTime
,tblEmailQueue.organisationID
FROM tblEmailQueue 
inner join #tblEmailsToPurge ON tblEmailQueue.EmailQueueID = #tblEmailsToPurge.EmailQueueID

-- do the purge
DELETE FROM tblEmailQueue WHERE EmailQueueID in (SELECT EmailQueueID FROM #tblEmailsToPurge)

DECLARE  @EmailQueueID INT
SELECT @EmailQueueID = MIN (EmailQueueID)
FROM tblEmailQueue
inner join tblOrganisation on tblOrganisation.OrganisationID = tblEmailQueue.organisationID
--join tblAppConfig on name  = ''SEND_AUTO_EMAILS''
--WHERE (tblOrganisation.StopEmails = 0 AND upper(Value) <> ''NO'')  --< already been purged and deleted above!?
--AND 
where ((SendStarted is NULL) OR (DATEADD(DAY,1,SendStarted) < GETUTCDATE()))


-- A single instance will be calling this procedure so there is no need to do multi-user code here
SELECT TOP (1) EmailQueueID,OrganisationID,AddressTo,AddressBCCs,[Subject],body,AddressSender,AddressFrom,IsHTML,CASE WHEN DATEDIFF(d,QueuedTime,GETUTCDATE()) > 1 THEN 1 ELSE 0 END AS Retry
FROM tblEmailQueue  WHERE @EmailQueueID =  EmailQueueID
UPDATE tblEmailQueue SET SendStarted = GETUTCDATE()  WHERE @EmailQueueID =  EmailQueueID

END
' 
END
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUpdateReminderEscalation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

create procedure  [prcUpdateReminderEscalation](@remescid int, @act int)
as
begin

if @act = 0  begin
update tblReminderEscalation set DateEnabled = case when DateEnabled IS null then GETUTCDATE() else null end where RemEscId = @remescid
end
else if @act = 1 begin
delete from tblReminderEscalation where RemEscId = @remescid
end


end

' 
END
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcSCORMpublishedcontent]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE  [prcSCORMpublishedcontent]

AS
BEGIN
SELECT LessonLaunchPoint + ''?QFS='' + QFS as  launchpoint,''"''+CourseName + ''" - '' + ModuleName + '' ''+ CAST(contentID AS varchar(9)) AS title FROM tblSCORMcontent order by contentID DESC
END
' 
END
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcSCORMsetValue]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcSCORMsetValue] (
             @StudentID int,
             @LessonID int,
             @DME  varchar(50),
             @value  varchar(4000)
           )  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    DELETE FROM tblScormDME where UserID = @StudentID and LessonID = @LessonID and DME = @DME
    DECLARE @quizAnswer varchar(100)
    SET @quizAnswer = @DME 

    IF LEN(@quizAnswer) >= 14  set @quizAnswer =	SUBSTRING(@quizAnswer,1,15)

    if (@quizAnswer <> ''cmi.interaction'')
    BEGIN  
	INSERT INTO tblScormDME
           (UserID
           ,LessonID
           ,DME
           ,[value])
     VALUES (
           @StudentID,
           @LessonID, 
           @DME, 
           @value)
      END     
END

' 
END
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisation_GetURL]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [prcOrganisation_GetURL] @organisationID int

as 
begin
	
	declare @orgurl varchar(500)
	
	SELECT @orgurl =CASE WHEN ''true'' = [Value] THEN ''HTTPS://'' ELSE ''http://'' END FROM tblAppConfig where Name = ''SSL'' 
	SELECT organisationname, ORGURL =@orgurl + COALESCE(DOMAINNAME,''localhost'')  + ''/Restricted/Login.aspx'' FROM tblOrganisation ORG WHERE ORG.OrganisationID =  @OrganisationID
	
	

END
' 
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUserCourseStatus_Calculate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*Summary:
Returns the current course status for a user - course

Returns:
int CourseStatusID

Called By:
trgUserQuizStatus
Calls:
trigger

Remarks:

QuizStatusID Status
------------ --------------------------------------------------
0            Unassigned
1            Not Started
2            Passed
3            Failed
4            Expired (Time Elapsed)
5            Expired (New Content)


CourseStatusID Status
-------------- --------------------------------------------------
0              Unassigned
1              InComplete
2              Complete

Author: Stepehn Clark
Date Created: 24 March 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1 S K-Clark	7 March 2005	Access to a course but no modules in it is now considered for compliance as no access to the course
3.0.24 Li Zhang		09-02-2007		Avoid use the row count result of vwUserQuizStatus and vwUserModule in calculating the user course status
 Chris Plewright	20-11-2013		Check for expiry, and return incomplete.

exec @intCurrentCourseStatus = prcUserCourseStatus_GetStatus @CourseID = @intCourseID, @UserID = @int@UserID
exec @intNewCourseStatus = prcUserCourseStatus_Calculate @CourseID = @intCourseID, @UserID = @intUserID

DECLARE @return_status int
EXEC @return_status = prcUserCourseStatus_Calculate @CourseID = 19, @userID = 1108
SELECT ''Return Status'' = @return_status


**/



CREATE       Procedure [dbo].[prcUserCourseStatus_Calculate]
(
@CourseID int	-- The course ID
, @UserID int 	-- The user ID
)
AS
------------------------------------
Set Nocount On

--< if all the users results for this quiz are passed then the course was completed >--
Declare @intStatus int, -- Return Value
@intRowCount int

declare @tblUserQuizStatus table
(
ModuleID    int
, QuizStatusID int
, QuizFrequency int
, QuizPassMark int
, QuizScore   int
, DateCreated  datetime
, DateLastReset datetime
)

insert into
@tblUserQuizStatus
(
ModuleID
, QuizStatusID
, QuizFrequency
, QuizPassMark
, QuizScore
, DateCreated
, DateLastReset
)
select
vUQS.ModuleID
, vUQS.QuizStatusID
, vUQS.QuizFrequency
, vUQS.QuizPassMark
, vUQS.QuizScore
, vUQS.DateCreated
, vUQS.DateLastReset
from
(
	select
	QuizStatus.UserQuizStatusID
	, QuizStatus.UserID
	, QuizStatus.ModuleID
	, m.CourseID
	, QuizStatus.QuizStatusID
	, QuizStatus.QuizFrequency
	, QuizStatus.QuizPassMark
	, QuizStatus.QuizSessionID
	, QuizStatus.QuizScore
	, QuizStatus.DateCreated
	, QuizStatus.DateLastReset
	from
	tblUserQuizStatus QuizStatus
	inner join tblModule m on m.ModuleID = QuizStatus.ModuleID AND m.CourseID = @CourseID
	inner join
		(
		select
		max(UserQuizStatusID) UserQuizStatusID --UserQuizStatusID is identity
		from
		tblUserQuizStatus
		WHERE
		tblUserQuizStatus.UserID = @userID
		group by
		UserID,moduleID
		) currentStatus
	on QuizStatus.UserQuizStatusID = currentStatus.UserQuizStatusID
	where m.active = 1
) vUQS
inner join
(
	Select
	tU.UserID
	, tU.FirstName
	, tU.LastName
	, tU.UnitID
	, tU.OrganisationID
	, tM.ModuleID
	, tM.CourseID
	, tC.Name ''CourseName''
	, tM.Name
	, tM.Sequence
	, tM.Description
	From
	dbo.tblUser tU
	--< get the courses a user has access to >--
	Inner Join dbo.tblOrganisationCourseAccess tOCA
	On  tOCA.OrganisationID = tU.OrganisationID
	--< get the course details >--
	Inner join dbo.tblCourse tC
	On tC.CourseID = tOCA.GrantedCourseID
	--< get the Active modules in a course >--
	inner join dbo.tblModule tM
	On tM.CourseID = tC.CourseID
	and tM.Active = 1
	--< get the details on which moduels a user is configured to access >--
	Left Outer join dbo.tblUserModuleAccess tUsrMA
	On  tUsrMA.UserID = tU.UserID
	And tUsrMA.ModuleID = tM.ModuleID
	--< get the details on which moduels a user''s Unit is excluded from  >--
	Left Outer Join dbo.tblUnitModuleAccess tUnitMA
	On  tUnitMA.UnitID = tU.UnitID
	And tUnitMA.DeniedModuleID = tM.ModuleID
	Where
	tC.CourseID = @CourseID AND tU.UserID = @UserID
	--AND tU.Active = 1
	--< Active users only >--
	and tu.UnitID is not null
	--< Get the modules that the user''s Unit is not denied >--
	and (tUnitMA.DeniedModuleID  is null
	--<  and the user does not have special access to  it>--
	And tUsrMA.ModuleID is null)
	--< or Get modules that the user has been specially  granted
	or tUsrMA.Granted=1
) vUMA
on
vUQS.ModuleID = vUMA.ModuleID
and vUQS.CourseID = @CourseID
and vUQS.UserID = @userID
and vUMA.CourseID = @CourseID
and vUMA.UserID = @userID



-- get the rowcount
set @intRowCount = @@RowCount

-- if nothing was returned then there is something wrong (scheduled task has not been run ??)

if @intRowCount = 0
Begin --1
/***** this logic has been changed
Previoulsy:
If a person had access to a course but not to any modules
in the course then they still have access to the the course as far as compliance is concerned
Now:
If a person does not have access to any modules in a course then from the point of view of
compliance reporting they do not have access to the course
*/
return 0 -- unassigned ?
End --/1

-- if there are any results for anything other than passed then the course is incomplete
if exists (select ModuleID from @tblUserQuizStatus where QuizStatusID <> 2)
Begin --4
return  1 --Incomplete
End --/4

-- if there are ANY passes, but NONE of them were created AFTER the expiry or quiz reset dates, then return as Incomplete.
-- this is needed because the user may have passed the course initially, but was later unassigned from the module, 
--  and so didnt get marked as unassigned during the time when the course was expired or quiz reset.  
--  then the user may have been re-assigned to the module, but is still left with a previous completed 
--  status from a course that would have expired if they were active at that time of expiry or quiz reset.
if exists (select ModuleID from @tblUserQuizStatus where QuizStatusID = 2)
begin
	---there were passes, BUT - check if NONE of them were after the quiz reset date then return incomplete...
	if not exists ( select ModuleID from @tblUserQuizStatus where QuizStatusID = 2 and DateCreated > DateLastReset and DateLastReset is not null)
	Begin 
	  return  1 --Incomplete
	End
	
	-- check expiry...
	declare @intQuizFrequency int
	SELECT @intQuizFrequency = (
		SELECT  TOP 1   ISNULL(ur.QuizFrequency, o.DefaultQuizFrequency)
		FROM   	tblUnitRule AS ur 
		RIGHT JOIN tblUser AS u ON ur.UnitID = u.UnitID
		INNER JOIN tblOrganisation AS o ON u.OrganisationID = o.OrganisationID
		WHERE	u.UserID = @UserID
		)

	declare @dtmQuizCompletionDate datetime 
	set @dtmQuizCompletionDate = null
	SET @dtmQuizCompletionDate = (
		SELECT  TOP 1	ISNULL(ur.QuizCompletionDate, o.DefaultQuizCompletionDate)
		FROM   	tblUnitRule AS ur 
		RIGHT JOIN tblUser AS u ON ur.UnitID = u.UnitID
		INNER JOIN tblOrganisation AS o ON u.OrganisationID = o.OrganisationID
		WHERE	u.UserID = @UserID
		)

	if (@dtmQuizCompletionDate is null and @intQuizFrequency is not null)
	begin
	  select @dtmQuizCompletionDate  = ISNULL(@dtmQuizCompletionDate , dateadd(mm,0-@intQuizFrequency,GETDATE()))
	end
   
	if @dtmQuizCompletionDate is not null AND not exists ( select ModuleID from @tblUserQuizStatus where QuizStatusID = 2 and DateCreated > @dtmQuizCompletionDate )
	Begin 
	  return  1 --Incomplete
	End 
end

---

select * into #tblTemp from
(
Select
tU.UserID
, tU.FirstName
, tU.LastName
, tU.UnitID
, tU.OrganisationID
, tM.ModuleID
, tM.CourseID
, tC.Name ''CourseName''
, tM.Name
, tM.Sequence
, tM.Description
From
dbo.tblUser tU
--< get the courses a user has access to >--
Inner Join dbo.tblOrganisationCourseAccess tOCA
On  tOCA.OrganisationID = tU.OrganisationID
--< get the course details >--
Inner join dbo.tblCourse tC
On tC.CourseID = tOCA.GrantedCourseID
--< get the Active modules in a course >--
inner join dbo.tblModule tM
On tM.CourseID = tC.CourseID
and tM.Active = 1
--< get the details on which moduels a user is configured to access >--
Left Outer join dbo.tblUserModuleAccess tUsrMA
On  tUsrMA.UserID = tU.UserID
And tUsrMA.ModuleID = tM.ModuleID
--< get the details on which moduels a user''s Unit is excluded from  >--
Left Outer Join dbo.tblUnitModuleAccess tUnitMA
On  tUnitMA.UnitID = tU.UnitID
And tUnitMA.DeniedModuleID = tM.ModuleID
Where
tC.CourseID = @CourseID AND tU.UserID = @UserID
-- AND tU.Active = 1
--< Active users only >--
and tu.UnitID is not null
--< Get the modules that the user''s Unit is not denied >--
and (tUnitMA.DeniedModuleID  is null
--<  and the user does not have special access to  it>--
And tUsrMA.ModuleID is null)
--< or Get modules that the user has been specially  granted
or tUsrMA.Granted=1
) as vwUserModuleAccess where userID = @UserID and courseID=@CourseID
SET @intRowCount = @@RowCount
--  all the quizes are passed then the course is complete
if  (select count(ModuleID) from @tblUserQuizStatus where QuizStatusID = 2) = @intRowCount
Begin --5
return 2 --Complete
End --/5
drop table #tblTemp

-- Code should never fall through to here, but just in case
return 1 -- Incomplete


' 
END
GO



IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUserLessonStatus_Update_Quick]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = 
N'/* Summary:
Update lesson status for each user
This schedule task only updates three status:
Unassigned Modules (0)
New Assigned Modules (Not Started(1))
Expired Modules (Time Elapsed)(4)

Returns:

Called By:

Calls:
Nothing

Remarks:
This is a schedule job running every night to check there are any changes in the user lesson status based on current compliance rules.
If they are the same as the current status, ignore it, otherwise a new status will be created.

If a module is assigned to a user, and there is no activity for this module, the status will be  ''Not started''.
If a module is unassigned from a user, the status will be ''unassinged"(There are records in status table, but the module is not assigned to this user now)
If a module is set to inactive, the status will be ''unassinged''

------------ Decision Processes -------------

1. Get CurrentAssignedModules and PreviousAssignedModules
1.1  CurrentAssignedModules
Get all modules that are currently assigned to each users
and compliance rules

1.2  PreviousAssignedModules
Get a list of modules that is in the lesson status table that the last statuses are not Unassigned (0)

2. Add New lesson status
2.1. Unassigned Modules (0) (PreviousAssignedModules - CurrentAssignedModules)

2.2. New Assigned Modules (Not Started(1)) (CurrentAssignedModules- PreviousAssignedModules)

2.3. Expired Modules (Time Elapsed)(4): Expired a lesson if the cycle started date is past the lesson frequency
a)Get the last cycle started date which current lesson status is In Progress (2), or Completed(3)
b)If the cycle started date is past the current lesson date/frequency, the new status is Expired (Time Expired)(4)



------------ Data need to be recorded -------------

LessonFrequency
0  Unassigned:  		-
1  Not Started: 		Y
4  Expired (Time Elapsed): 	Y


Author: Jack Liu
Date Created: 21 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	mikev		1/5/2007		Added LessonCompletionDate

prcUserLessonStatus_Update

**/
Create Procedure [dbo].[prcUserLessonStatus_Update_Quick]
(
@OrgID int	-- comma separated organisationID
)
AS
Set Nocount On



--##################################################################################################################
/*
2. Add New lesson status

2.1.     N O T      A S S I G N E D      M O D U L E S
(0) (PreviousAssignedModules - CurrentAssignedModules)
Add record of 0 (unassigned) to tblUserLessonStatus for each User-Module that has been started but now has no Course access or is specifically excluded at unit/user level
*/
--##################################################################################################################
insert into tblUserLessonStatus
(
UserID,
ModuleID,
LessonStatusID
)
select pam.UserID,
pam.ModuleID,
0  as QuizStatusID --Unassigned (0)
from

(
SELECT LessonStatus.UserID, LessonStatus.ModuleID
FROM  dbo.tblUserCurrentLessonStatus as LessonStatus
inner join tblUser on tblUser.UserID = LessonStatus.UserID and tblUser.OrganisationID = @OrgID
WHERE  (LessonStatus.Excluded = 0) OR (LessonStatus.Excluded IS NULL)
AND (LessonStatus.UserLessonStatusID <> 0)
and 	LessonStatus.LessonStatusID<>0 --not Unassigned (0)
)  pam


left join (SELECT tU.UserID, tM.ModuleID, CASE WHEN (ur.LessonFrequency IS NULL AND ur.LessonCompletionDate IS NULL AND o.DefaultLessonCompletionDate IS NULL)
THEN o.DefaultLessonFrequency ELSE ur.LessonFrequency END AS LessonFrequency, CASE WHEN (ur.LessonFrequency IS NULL AND
ur.LessonCompletionDate IS NULL AND NOT (o.DefaultLessonCompletionDate IS NULL))
THEN o.DefaultLessonCompletionDate ELSE ur.LessonCompletionDate END AS LessonCompletionDate
FROM  dbo.tblUser AS tU INNER JOIN
tblUnit on tU.UnitID = tblUnit.UnitID and tblUnit.OrganisationID = @OrgID INNER JOIN
dbo.tblOrganisationCourseAccess AS tOCA ON tOCA.OrganisationID = tU.OrganisationID AND tOCA.OrganisationID = @OrgID INNER JOIN
dbo.tblOrganisation AS o ON o.OrganisationID = tOCA.OrganisationID INNER JOIN
dbo.tblModule AS tM ON tM.Active = 1 AND tOCA.GrantedCourseID = tM.CourseID LEFT OUTER JOIN
dbo.tblUserModuleAccess AS tUsrMA ON tUsrMA.UserID = tU.UserID AND tUsrMA.ModuleID = tM.ModuleID LEFT OUTER JOIN
dbo.tblUnitModuleAccess AS tUnitMA ON tUnitMA.UnitID = tU.UnitID AND tUnitMA.DeniedModuleID = tM.ModuleID LEFT OUTER JOIN
dbo.tblUnitRule AS ur ON ur.ModuleID = tM.ModuleID AND ur.UnitID = tU.UnitID
WHERE (tU.Active = 1) AND (tU.UnitID IS NOT NULL) AND (tUnitMA.DeniedModuleID IS NULL) AND (tUsrMA.ModuleID IS NULL) OR
(tUsrMA.Granted = 1)) cam -- Current Assigned Modules

on cam.UserID = pam.UserID
and cam.ModuleID = pam.ModuleID
where cam.moduleID is null
and cam.UserID in (select UserID from tblUser where OrganisationID = @OrgID)



--##################################################################################################################
/*
2.2.      N E W     A S S I G N E D     M O D U L E S
(Not Started(1)) (CurrentAssignedModules- PreviousAssignedModules)
*/
--##################################################################################################################


insert into tblUserLessonStatus
(
UserID,
ModuleID,
LessonStatusID,
LessonFrequency,
LessonCompletionDate
)
select cam.UserID,
cam.ModuleID,
1  as LessonStatusID,--Not Started(1)
cam.LessonFrequency,
cam.LessonCompletionDate
from
(
SELECT tU.UserID, tM.ModuleID, CASE WHEN (ur.LessonFrequency IS NULL AND ur.LessonCompletionDate IS NULL AND o.DefaultLessonCompletionDate IS NULL)
THEN o.DefaultLessonFrequency ELSE ur.LessonFrequency END AS LessonFrequency, CASE WHEN (ur.LessonFrequency IS NULL AND
ur.LessonCompletionDate IS NULL AND NOT (o.DefaultLessonCompletionDate IS NULL))
THEN o.DefaultLessonCompletionDate ELSE ur.LessonCompletionDate END AS LessonCompletionDate
FROM  dbo.tblUser AS tU INNER JOIN
tblUnit on tU.UnitID = tblUnit.UnitID and tblUnit.OrganisationID = @OrgID INNER JOIN
dbo.tblOrganisationCourseAccess AS tOCA ON tOCA.OrganisationID = tU.OrganisationID AND tOCA.OrganisationID = @OrgID INNER JOIN
dbo.tblOrganisation AS o ON o.OrganisationID = tOCA.OrganisationID INNER JOIN
dbo.tblModule AS tM ON tM.Active = 1 AND tOCA.GrantedCourseID = tM.CourseID LEFT OUTER JOIN
dbo.tblUserModuleAccess AS tUsrMA ON tUsrMA.UserID = tU.UserID AND tUsrMA.ModuleID = tM.ModuleID LEFT OUTER JOIN
dbo.tblUnitModuleAccess AS tUnitMA ON tUnitMA.UnitID = tU.UnitID AND tUnitMA.DeniedModuleID = tM.ModuleID LEFT OUTER JOIN
dbo.tblUnitRule AS ur ON ur.ModuleID = tM.ModuleID AND ur.UnitID = tU.UnitID
WHERE (tU.Active = 1) AND (tU.UnitID IS NOT NULL) AND (tUnitMA.DeniedModuleID IS NULL) AND (tUsrMA.ModuleID IS NULL) OR
(tUsrMA.Granted = 1)
) cam
left join
(
SELECT LessonStatus.UserID, LessonStatus.ModuleID
FROM  dbo.tblUserCurrentLessonStatus as LessonStatus
inner join tblUser on tblUser.UserID = LessonStatus.UserID and tblUser.OrganisationID = @OrgID
WHERE  (LessonStatus.Excluded = 0) OR (LessonStatus.Excluded IS NULL)
AND (LessonStatus.UserLessonStatusID <> 0)
and 	LessonStatus.LessonStatusID<>0 --not Unassigned (0)
)  pam
on cam.UserID = pam.UserID
and cam.ModuleID = pam.ModuleID
where pam.moduleID is null



--##################################################################################################################
/*
2.3.       E X P I R E D    M O D U L E S
(Time Elapsed)(4): Expired a lesson if the cycle started date is past the lesson frequency
a)Get the last cycle started date which current lesson status is In Progress (2), or Completed(3)
b)If the cycle started date is past the current lesson frequency, the new status is Expired (Time Expired)(4)
*/
--##################################################################################################################




insert into tblUserLessonStatus
(
UserID,
ModuleID,
LessonStatusID,
LessonFrequency,
LessonCompletionDate
)
select cam.UserID,
cam.ModuleID,
4  as LessonStatusID, --(Time Elapsed)(4)
cam.LessonFrequency, cam.LessonCompletionDate
from (
select 	max(LastStarted.UserLessonStatusID) LastStartedStatusID
from tblUserLessonStatus LastStarted
inner join
(
SELECT LessonStatus.UserLessonStatusID, LessonStatus.UserID, LessonStatus.ModuleID, m.CourseID, LessonStatus.LessonStatusID, LessonStatus.LessonFrequency,
LessonStatus.DateCreated
FROM  dbo.tblUserCurrentLessonStatus as LessonStatus
inner join tblUser on tblUser.UserID = LessonStatus.UserID and tblUser.OrganisationID = @OrgID
inner join tblModule m on m.ModuleID = LessonStatus.ModuleID

WHERE  (LessonStatus.Excluded = 0) OR (LessonStatus.Excluded IS NULL)
) CurrentStatus
on  LastStarted.UserID = CurrentStatus.UserID
and  LastStarted.ModuleID = CurrentStatus.ModuleID
and CurrentStatus.LessonStatusID in (2,3)
where LastStarted.LessonStatusID = 2
and LastStarted.UserID in (select UserID from tblUser where OrganisationID = @OrgID)
group by LastStarted.UserID, LastStarted.moduleID
) lss
inner join tblUserLessonStatus uls
on uls.UserLessonStatusID = lss.LastStartedStatusID
inner join (SELECT tU.UserID, tM.ModuleID, CASE WHEN (ur.LessonFrequency IS NULL AND ur.LessonCompletionDate IS NULL AND o.DefaultLessonCompletionDate IS NULL)
THEN o.DefaultLessonFrequency ELSE ur.LessonFrequency END AS LessonFrequency, CASE WHEN (ur.LessonFrequency IS NULL AND
ur.LessonCompletionDate IS NULL AND NOT (o.DefaultLessonCompletionDate IS NULL))
THEN o.DefaultLessonCompletionDate ELSE ur.LessonCompletionDate END AS LessonCompletionDate
FROM  dbo.tblUser AS tU INNER JOIN
dbo.tblOrganisationCourseAccess AS tOCA ON tOCA.OrganisationID = tU.OrganisationID AND tOCA.OrganisationID = @OrgID INNER JOIN
dbo.tblOrganisation AS o ON o.OrganisationID = tOCA.OrganisationID INNER JOIN
dbo.tblUnit AS u ON u.OrganisationID = tU.OrganisationID and u.UnitID = tU.UnitID INNER JOIN
dbo.tblModule AS tM ON tM.Active = 1 AND tOCA.GrantedCourseID = tM.CourseID LEFT OUTER JOIN
dbo.tblUserModuleAccess AS tUsrMA ON tUsrMA.UserID = tU.UserID AND tUsrMA.ModuleID = tM.ModuleID LEFT OUTER JOIN
dbo.tblUnitModuleAccess AS tUnitMA ON tUnitMA.UnitID = tU.UnitID AND tUnitMA.DeniedModuleID = tM.ModuleID LEFT OUTER JOIN
dbo.tblUnitRule AS ur ON ur.ModuleID = tM.ModuleID AND ur.UnitID = tU.UnitID
WHERE (tU.Active = 1) AND (tU.UnitID IS NOT NULL) AND (tUnitMA.DeniedModuleID IS NULL) AND (tUsrMA.ModuleID IS NULL) OR
(tUsrMA.Granted = 1)) cam
on cam.UserID = uls.UserID
and cam.ModuleID = uls.ModuleID
where
(
cam.LessonCompletionDate is null
and DateDiff(day,getutcdate(), dateadd(month, cam.LessonFrequency, uls.DateCreated)) <= 0
)
or
(
isnull(DateDiff(day, getutcdate(), cam.LessonCompletionDate), 1) <= 0
)
and cam.UserID in (select UserID from tblUser where OrganisationID = @OrgID)
--Expired





--##################################################################################################################
-- Extend completion dates
update tblOrganisation
set DefaultLessonCompletionDate = dateadd(year, 1, [DefaultLessonCompletionDate])
where DefaultLessonCompletionDate < getutcdate() and OrganisationID = @OrgID

--##################################################################################################################
update tblUnitRule
set LessonCompletionDate = dateadd(year, 1, [LessonCompletionDate])
where LessonCompletionDate < getutcdate() and UnitID IN (select UnitID from tblUnit where OrganisationID = @OrgID)
-- /Extend completion dates
--##################################################################################################################




SET QUOTED_IDENTIFIER ON'
 
END
GO



IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUserQuizStatus_Update_Quick]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/* Summary:
Update quiz status for each user

Returns:

Called By:

Calls:
Nothing

Remarks:
This is a schedule job running every night to check there are any changes in the user quiz status based on current compliance rules.
If they are the same as the current status, ignore it, otherwise a new status will be created.

If a module is assigned to a user, and there is no activity for this module, the status will be  ''Not started''.
If a module is unassigned from a user, the status will be ''unassinged"(There are records in status table, but the module is not assigned to this user now)
If a module is set to inactive, the status will be ''unassinged''

All user-module pair need to be re-evaluated, as compliance rules may be changed since the user''s last toolbook activity.

------------ Decision Processes -------------

1. Get Current User Quiz status
-----------------------------------
1.1  Get all modules that are currently assigned to each users (CurrentAssignedModules)
and compliance rules

1.2. Get the last quiz activity for each user and module pair (StartedModules)

1.3. Unassigned Modules (0) (PreviousAssignedModules - CurrentAssignedModules)
a) Get a list of modules that is in the quiz status table that the last statuses are not Unassigned (0)(PreviousAssignedModules)
b) Get rid off all modules that are currently assigned to the users (from step 1)
c)All modules left are Unassigned(0)

1.4. Not Started Modules (1) (CurrentAssignedModules- StartedModules)
All currently assigned modules that don''t have any activity is Not Started (1)

1.5. Started Modules
a)If the last quiz is inactive, the status is Expired (New Content)(5)
b)If the last quiz is past the current quiz date/frequency, the status is Expired (Time Expired)(4)
c)If the last quiz is during the current quiz frequency, get the current pass mark, and check the quiz status
If user Failed the quiz, the status is Failed (3)
If user Passed the quiz, the status is Passed (2)

2. Update User Quiz status
----------------------------
If the last quiz status for each user is not the same as the current status, add the new status



------------ Data need to be recorded -------------

QuizFrequency	QuizPassMark	QuizScore
0  Unassigned:  		-		-		-
1  Not Started: 		Y		Y		-
2  Passed: 	 		Y		Y		Y
3  Failed: 	 		Y		Y		Y
4  Expired (Time Elapsed): 	Y		Y		-
5  Expired (New Content): 	Y		Y		-


Author: Jack Liu
Date Created: 20 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	mikev		1/5/2007		Added logic for new fields LessonCompletionStatus & QuizCompletionStatus
#2	mikev		9/5/2007		Added course completion logic. If a module is marked active or not active; to calculate if the course is complete.
#3	Mark Donald	21/9/2009		Added OrganisationName (control character) to License Warning emails
  Chris Plewright  21/11/2013   fixed for incorrect for No of Post Expiry notifications being sent.
   
prcUserQuizStatus_Update_Quick

**/
CREATE   Procedure [dbo].[prcUserQuizStatus_Update_Quick]
(
@OrgID int	-- comma separated organisationID
)
AS
Set Nocount On
declare @intHistoryID int

insert into tblModuleStatusUpdateHistory(startTime) values(getUTCdate());
set @intHistoryID = @@identity

--1. Get Current User Quiz status
--mikev : added QuizCompletionDate
/* UNITTEST: CurrentAssignedModules */
CREATE TABLE #tblCurrentUserQuizStatus
(
UserID int NOT NULL ,
ModuleID int NOT NULL ,
QuizStatusID int not NULL ,
QuizFrequency int NULL ,
QuizPassMark int NULL ,
QuizCompletionDate DateTime NULL,
QuizScore int NULL,
QuizSessionID uniqueidentifier NULL
)


/*
1.1  Get all modules that are currently assigned to each users (CurrentAssignedModules)
and current compliance rules
*/
-- mikev(1): added completion date

select
um.UserID,
um.ModuleID,
umr.QuizFrequency,
umr.QuizPassMark,
umr.QuizCompletionDate
into
#tblCurrentAssignedModules
from
(
Select
tU.UserID
, tU.UnitID
, tU.OrganisationID
, tM.ModuleID


From
dbo.tblUser tU
--< get the courses a user has access to >--
Inner Join dbo.tblOrganisationCourseAccess tOCA
On  tOCA.OrganisationID = tU.OrganisationID
--< get the course details >--
Inner join dbo.tblCourse tC
On tC.CourseID = tOCA.GrantedCourseID
--< get the Active modules in a course >--
inner join dbo.tblModule tM
On tM.CourseID = tC.CourseID
and tM.Active = 1
--< get the details on which moduels a user is configured to access >--
Left Outer join dbo.tblUserModuleAccess tUsrMA
On  tUsrMA.UserID = tU.UserID
And tUsrMA.ModuleID = tM.ModuleID
--< get the details on which moduels a user''s Unit is excluded from  >--
Left Outer Join dbo.tblUnitModuleAccess tUnitMA
On  tUnitMA.UnitID = tU.UnitID
And tUnitMA.DeniedModuleID = tM.ModuleID
Where
tU.OrganisationID = @OrgID AND
tU.Active = 1
--< Active users only >--
and tu.UnitID is not null
--< Get the modules that the user''s Unit is not denied >--
and (tUnitMA.DeniedModuleID  is null
--<  and the user does not have special access to  it>--
And tUsrMA.ModuleID is null)
--< or Get modules that the user has been specially  granted
or tUsrMA.Granted=1
) um
inner join
(
Select 	u.UnitID,
m.CourseID,
m.ModuleID,
case
when ur.unitID is null then cast(1 as bit)
else cast(0 as bit)
end as UsingDefault,
case
when (ur.LessonFrequency is null and ur.LessonCompletionDate is null and o.DefaultLessonCompletionDate is null) then
o.DefaultLessonFrequency
else
ur.LessonFrequency
end
as LessonFrequency,
case
when (ur.QuizFrequency is null and ur.QuizCompletionDate is null and o.DefaultQuizCompletionDate is null) then
o.DefaultQuizFrequency
else
ur.QuizFrequency
end
as QuizFrequency,
isNull(ur.QuizPassMark, o.DefaultQuizPassMark) as QuizPassMark,
case
when (ur.LessonFrequency is null and ur.LessonCompletionDate is null and not(o.DefaultLessonCompletionDate is null)) then
o.DefaultLessonCompletionDate
else
ur.LessonCompletionDate
end
as LessonCompletionDate,
case
when (ur.QuizFrequency is null and ur.QuizCompletionDate is null and not(o.DefaultQuizCompletionDate is null)) then
o.DefaultQuizCompletionDate
else
ur.QuizCompletionDate
end
as QuizCompletionDate
From tblOrganisationCourseAccess c
inner join tblModule m
on m.CourseID = c.GrantedCourseID
inner join tblOrganisation o  -- Get default compliance rules
on o.OrganisationID = c.OrganisationID
inner join tblUnit u
on u.OrganisationID = c.OrganisationID
left join tblUnitRule ur --Get the unit specific rules
on ur.ModuleID = m.ModuleID
and ur.UnitID=u.unitID
WHERE o.OrganisationID = @OrgID
) umr
on
umr.ModuleID  = um.ModuleID
and umr.UnitID = um.UnitID
and um.UnitID in (select UnitID from tblUnit where OrganisationID = @OrgID)
and um.UserID IN (select UserID from tblUser where OrganisationID = @OrgID)
/* /UNITTEST: CurrentAssignedModules */

-- select * from #tblCurrentAssignedModules
/*
1.2. Get the last quiz activity for each user and module pair (StartedModules)
*/
/* UNITTEST: StartedModules */
select
um.userID,
um.moduleID,
q.active,
qs.QuizScore,
qs.QuizSessionID,
qs.DateTimeCompleted
into
#tblStartedModules
from
#tblCurrentAssignedModules um
inner join
(
select
um.userID, um.moduleID, max(DateTimeCompleted)  as DateTimeCompleted
from
#tblCurrentAssignedModules um
inner join tblQuiz q
on q.ModuleID = um.ModuleID
inner join tblQuizSession qs
on
qs.QuizID=	q.quizID
and qs.userID = um.userID
and qs.DateTimeCompleted is not null
group by um.userID, um.moduleID
)
as LastQuizDate

on
LastQuizDate.userID = um.userID
and LastQuizDate.ModuleID = um.ModuleID

inner join tblQuiz q
on
q.ModuleID = um.ModuleID
inner join tblQuizSession qs
on
qs.QuizID=	q.quizID
and qs.userID = um.userID
and qs.DateTimeCompleted  = LastQuizDate.DateTimeCompleted
/* /UNITTEST: StartedModules */


-- select * from #tblStartedModules

/*
1.3. Unassigned Modules (0) (PreviousAssignedModules - CurrentAssignedModules)
a) Get a list of modules that is in the quiz status table that the last statuses are not Unassigned (0)(PreviousAssignedModules)
b) Get rid off all modules that are currently assigned to the users (from step 1)
c)All modules left are Unassigned(0)
*/

/* UNITTEST: Status_Unassigned */
insert into #tblCurrentUserQuizStatus
(
UserID,
ModuleID,
QuizStatusID
)
select
uqs.UserID,
uqs.ModuleID,
0  as QuizStatusID --Unassigned (0)
from
(
select
QuizStatus.UserQuizStatusID
, QuizStatus.UserID
, QuizStatus.ModuleID
, m.CourseID
, QuizStatus.QuizStatusID
, QuizStatus.QuizFrequency
, QuizStatus.QuizPassMark
, QuizStatus.QuizSessionID
, QuizStatus.QuizScore
, QuizStatus.DateCreated

from
tblUserQuizStatus QuizStatus
inner join tblModule m on m.ModuleID = QuizStatus.ModuleID
inner join
(
select
max(UserQuizStatusID) UserQuizStatusID --UserQuizStatusID is identity
from
tblUserQuizStatus
WHERE
tblUserQuizStatus.UserID in (select UserID from tblUser where OrganisationID = @OrgID)
group by
UserID,moduleID
) currentStatus
on QuizStatus.UserQuizStatusID = currentStatus.UserQuizStatusID
where m.active = 1
) uqs
left join
#tblCurrentAssignedModules cam
on
cam.UserID = uqs.UserID
and cam.ModuleID = uqs.ModuleID
where
uqs.QuizStatusID<>0 --not Unassigned (0)
and cam.moduleID is null
and cam.UserID in (select UserID from tblUser where OrganisationID = @OrgID)
/* /UNITTEST: Status_Unassigned */

/*
1.4. Not Started Modules (1) (CurrentAssignedModules- StartedModules)
All currently assigned modules that don''t have any activity is Not Started (1)
*/
-- mikev(1): added QuizCompletionDate
/* UNITTEST: Status_NotStarted */
insert into
#tblCurrentUserQuizStatus
(
UserID,
ModuleID,
QuizStatusID,
QuizFrequency,
QuizPassMark,
QuizCompletionDate
)
select
cam.UserID,
cam.ModuleID,
1  as QuizStatusID, --Not Started (1)
cam.QuizFrequency,
cam.QuizPassMark,
cam.QuizCompletionDate
from
#tblCurrentAssignedModules cam
left join
#tblStartedModules sm
on
sm.UserID = cam.UserID
and sm.ModuleID = cam.ModuleID
where
sm.moduleID is null
and cam.UserID in (select UserID from tblUser where OrganisationID = @OrgID)
/* /UNITTEST: Status_NotStarted */
/*
EXPIRED NEW CONTENT IS NOW A MANUAL PROCESS
1.5. Started Modules
a)If the last quiz is inactive, the status is Expired (New Content)(5)
b)If the last quiz is past the current quiz frequency, the status is Expired (Time Expired)(4)
c)If the last quiz is during the current quiz frequency, get the current pass mark, and check the quiz status
If user Failed the quiz, the status is Failed (3)
If user Passed the quiz, the status is Passed (2)
*/

--	  	a)If the last quiz is inactive, the status is Expired (New Content)(5)


--		b)If the last quiz is past the current quiz frequency, the status is Expired (Time Expired)(4)
-- mikev(1): added QuizCompletionDate. Added criteria
/* UNITTEST: Status_TimeExpired */
insert into #tblCurrentUserQuizStatus
(
UserID,
ModuleID,
QuizStatusID,
QuizFrequency,
QuizPassMark,
QuizCompletionDate
)
select cam.UserID,
cam.ModuleID,
4  as QuizStatusID, --  Expired (Time Expired)(4)
cam.QuizFrequency,
cam.QuizPassMark,
cam.QuizCompletionDate
from #tblCurrentAssignedModules cam
inner join #tblStartedModules sm
on sm.UserID = cam.UserID
and sm.ModuleID = cam.ModuleID
where
(
(
cam.QuizCompletionDate is null
and DateDiff(day,dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID), dateadd(month, cam.QuizFrequency, dbo.udfUTCtoDaylightSavingTime(sm.DateTimeCompleted,@OrgID))) <= 0
)
or
(
isnull(DateDiff(day, getutcdate(), cam.QuizCompletionDate), 1) <= 0
)
)
and cam.UserID in (select UserID from tblUser where OrganisationID = @OrgID)
/* /UNITTEST: Status_TimeExpired */

--		c)If the last quiz is during the current quiz frequency, get the current pass mark, and check the quiz status
--			If user Failed the quiz, the status is Failed (3)
--			If user Passed the quiz, the status is Passed (2)

-- mikev(1): added QuizCompletionDate and changed logic of criteria to use the date before the frequency
/* UNITTEST: Status_PassFail */
insert into #tblCurrentUserQuizStatus
(
UserID,
ModuleID,
QuizStatusID,
QuizFrequency,
QuizPassMark,
QuizCompletionDate,
QuizScore,
QuizSessionID
)
select cam.UserID,
cam.ModuleID,
case
when sm.QuizScore>=cam.QuizPassMark then 2 -- Passed (2)
else	3  --Failed (3)
end  as QuizStatusID,
cam.QuizFrequency,
cam.QuizPassMark,
cam.QuizCompletionDate,
sm.QuizScore,
sm.QuizSessionID
from #tblCurrentAssignedModules cam
inner join #tblStartedModules sm
on sm.UserID = cam.UserID
and sm.ModuleID = cam.ModuleID
where
not (
cam.QuizCompletionDate is null
and DateDiff(day,dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID), dateadd(month, cam.QuizFrequency, dbo.udfUTCtoDaylightSavingTime(sm.DateTimeCompleted,@OrgID))) <= 0
)
and cam.QuizCompletionDate is null
and cam.UserID in (select UserID from tblUser where OrganisationID = @OrgID)
and (select top 1 QuizStatusID from tblUserQuizStatus where ModuleID = cam.ModuleID and UserID = cam.UserID order by UserQuizStatusID Desc) NOT IN (5)

/* /UNITTEST: Status_PassFail */
/*
2. Update User Quiz status
----------------------------
If the last quiz status for each user is not the same as the current status, add the new status
*/


/* UNITTEST: CourseStatus */
-- mikev(1): added cursor for quizcompletiondate
declare @cursor_UserID 	        int
declare @cursor_ModuleID 	    int
declare @cursor_QuizStatusID 	int
declare @cursor_QuizFrequency 	int
declare @cursor_QuizPassMark	int
declare @cursor_QuizCompletionDate	DateTime
declare @cursor_QuizScore	    int
declare @cursor_QuizSessionID   varchar(50)
declare @cursor_UserQuizStatusID int

-- mikev(1): added quizcompletiondate
declare @LastUser int
declare @LastModuleID int
declare @LastCourse int
declare @LastQuizStatusID int
declare @cursor_CourseID int
set @LastUser = -1
set @LastCourse = -1
set @LastQuizStatusID = -1
set  @LastModuleID = 0
DECLARE CurrentUserQuizStatus CURSOR
FOR


select
cs.UserID,
cs.ModuleID,
cs.QuizStatusID,
cs.QuizFrequency,
cs.QuizPassMark,
cs.QuizCompletionDate,
cs.QuizScore,
cs.QuizSessionID,
s.UserQuizStatusID,
Module.CourseID
from -- Any UserModules with current access but no tblUserQuizStatus record
#tblCurrentUserQuizStatus cs
inner join tblModule Module on module.moduleID = cs.ModuleID
left join
(  -- The UserModule quiz status for the latest quiz attempt
select
QuizStatus.UserQuizStatusID
, QuizStatus.UserID
, QuizStatus.ModuleID
, m.CourseID
, QuizStatus.QuizStatusID
, QuizStatus.QuizFrequency
, QuizStatus.QuizPassMark
, QuizStatus.QuizSessionID
, QuizStatus.QuizScore
, QuizStatus.DateCreated

from
tblUserQuizStatus QuizStatus
inner join tblModule m on m.ModuleID = QuizStatus.ModuleID
inner join
(
select
max(UserQuizStatusID) UserQuizStatusID --UserQuizStatusID is identity
from
tblUserQuizStatus
WHERE
tblUserQuizStatus.UserID in (select UserID from tblUser where OrganisationID = @OrgID)
group by
UserID,moduleID
) currentStatus
on QuizStatus.UserQuizStatusID = currentStatus.UserQuizStatusID
where m.active = 1
) s
on cs.userID = s.UserID
and cs.ModuleID = s.ModuleID
and cs.QuizStatusID = s.QuizStatusID
where
s.UserQuizStatusID is null
order by cs.UserID,
case when (cs.QuizStatusID = 0) then 6 else cs.QuizStatusID end,
Module.CourseID
-- ordered so we can update course status on the last module in the course rather than for every module in the course

Open CurrentUserQuizStatus

FETCH NEXT FROM CurrentUserQuizStatus
Into
@cursor_UserID,@cursor_ModuleID,@cursor_QuizStatusID,@cursor_QuizFrequency,
@cursor_QuizPassMark,@cursor_QuizCompletionDate,@cursor_QuizScore,@cursor_QuizSessionID, @cursor_UserQuizStatusID, @cursor_CourseID
set @LastCourse = @cursor_CourseID
set @LastUser = @cursor_UserID
set @LastQuizStatusID = @cursor_QuizStatusID
set @LastModuleID = @cursor_ModuleID

DECLARE @Err integer
WHILE @@FETCH_STATUS = 0
BEGIN

insert into tblUserQuizStatus
(
UserID,
ModuleID,
QuizStatusID,
QuizFrequency,
QuizPassMark,
QuizCompletionDate,
QuizScore,
QuizSessionID
)
values
(
@cursor_UserID,
@cursor_ModuleID,
@cursor_QuizStatusID,
@cursor_QuizFrequency,
@cursor_QuizPassMark,
@cursor_QuizCompletionDate,
@cursor_QuizScore,
@cursor_QuizSessionID
)
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_Update_Quick'',''insert into tblUserQuizStatus'',''UserID=''+CAST(@cursor_UserID AS varchar(10)),CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_Update_Quick'',1,1,null,getutcdate(),getutcdate()) END

-- don''t update the course status for every module in the course - once per course is enough
-- do update the course status on every change in QuizStatus
if (@LastCourse != @cursor_CourseID) or (@LastUser != @cursor_UserID) or (@LastQuizStatusID != @cursor_QuizStatusID) EXEC prcUserQuizStatus_UpdateCourseStatus @LastUser, @LastModuleID

set @LastCourse = @cursor_CourseID
set @LastUser = @cursor_UserID
set @LastQuizStatusID = @cursor_QuizStatusID
set @LastModuleID = @cursor_ModuleID


FETCH NEXT FROM CurrentUserQuizStatus
Into
@cursor_UserID,@cursor_ModuleID,@cursor_QuizStatusID,@cursor_QuizFrequency,
@cursor_QuizPassMark,@cursor_QuizCompletionDate,@cursor_QuizScore,@cursor_QuizSessionID, @cursor_UserQuizStatusID, @cursor_CourseID


END
-- final course may not be done so update just to be safe
if (@LastUser != -1 ) EXEC prcUserQuizStatus_UpdateCourseStatus @cursor_UserID, @cursor_ModuleID
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_Update_Quick'',''prcUserQuizStatus_UpdateCourseStatus'',''prcUserQuizStatus_UpdateCourseStatus'',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_Update_Quick'',1,1,null,getutcdate(),getutcdate()) END

-- Finished CurrentUserQuizStatus
CLOSE CurrentUserQuizStatus
DEALLOCATE CurrentUserQuizStatus




--              AT RISK OF EXPIRY



delete from tblQuizExpiryAtRisk 
where OrganisationID = @OrgID   -- delete from ExpiryAtRisk those users who somehow are no longer at risk

and  not exists (
SELECT      
	@orgid,
	QuizStatus.UserID, 
	QuizStatus.ModuleID ,
	case when re.QuizExpiryWarn=0 then -1 else 0 end as preexpiry ,
	0 as postexpiry,
	case when quizstatus.QuizStatusID = 1 then 
				dateadd (d,re.daystocompletecourse,QuizStatus.DateCreated)
		 when QuizStatus.QuizStatusID>1 then 
				(
					case when coalesce(ur.quizcompletiondate,o.DefaultQuizCompletionDate)  is not null then 
						coalesce(ur.quizcompletiondate,o.DefaultQuizCompletionDate)
					else
						DATEADD(M,coalesce(ur.quizfrequency,o.DefaultQuizFrequency),QuizStatus.DateCreated)						
					end
				)
		 end
	as expiry		
FROM         
	tblUserQuizStatus AS QuizStatus 
	INNER JOIN dbo.tblModule AS m ON m.ModuleID = QuizStatus.ModuleID 	
	INNER JOIN(SELECT     MAX(UserQuizStatusID) AS UserQuizStatusID,ModuleID,uqs.UserID
				FROM          dbo.tblUserQuizStatus uqs
				join tblUser u on u.UserID = uqs.UserID and u.OrganisationID = @orgid and u.Active = 1
				GROUP BY ModuleID,uqs.UserID ) AS currentStatus ON QuizStatus.UserQuizStatusID = currentStatus.UserQuizStatusID and currentStatus.ModuleID = m.ModuleID
	join tblUser u on u.UserID =QuizStatus.UserID 
	join tblOrganisation o on o.OrganisationID = u.OrganisationID and o.OrganisationID = @orgid
	join tblReminderEscalation re on m.CourseID = re.CourseId and re.OrgId = o.OrganisationID and re.DateEnabled<GETUTCDATE()
	left join tblUnit unit on unit.UnitID = u.UnitID
	left join tblUnitRule ur on ur.UnitID = u.UnitID and ur.ModuleID = m.ModuleID
WHERE     (m.Active = 1) 
and
(
	-- pre expiry initial enrolment
	(
		quizexpirywarn = 1  and 
		(RemindUsers = 1 and re.PreExpInitEnrolment = 1 and quizstatus.QuizStatusID = 1 and DATEDIFF (D,getutcdate(),(dateadd (d,re.daystocompletecourse,QuizStatus.DateCreated)))<=re.DaysQuizExpiry 
			or
			--enable				--resit period reminder
			(PreExpResitPeriod = 1	and QuizStatus.QuizStatusID>1 and 
				-- pre expiry resit period	
				(dateadd(M,case when coalesce(ur.quizfrequency ,o.DefaultQuizFrequency) = 0 then 99 else coalesce(ur.quizfrequency ,o.DefaultQuizFrequency) end , dateadd(d,-re.DaysQuizExpiry,  QuizStatus.DateCreated))<=GETDATE()) 
				or 
				-- pre expiry resit period date
				(DATEADD(yy,1,quizstatus.DateCreated)<= coalesce(ur.quizcompletiondate,o.DefaultQuizCompletionDate) and DATEADD(D,-re.DaysQuizExpiry,coalesce(ur.quizcompletiondate,o.DefaultQuizCompletionDate))<= getutcdate())
			) 
		)
	)
	or
	(
		re.PostExpReminder = 1 and
		-- post expiry initial reminder
		(
			(
				 RemindUsers = 1 and re.PostExpInitEnrolment = 1 and QuizStatus.QuizStatusID = 1 and (dateadd (d,re.daystocompletecourse,QuizStatus.DateCreated))<=GETUTCDATE()
			)
			or
			-- post expiry resit period
			(
				re.PostExpResitPeriod = 1  and QuizStatus.QuizStatusID >1 and
				(
					-- post expiry resit period
					(dateadd(M,case when coalesce(ur.quizfrequency ,o.DefaultQuizFrequency)= 0 then 99 else coalesce(ur.quizfrequency ,o.DefaultQuizFrequency) end , QuizStatus.DateCreated)<=GETDATE()) 
					or 
					-- post expiry resit date
					(DATEADD(Y,1,quizstatus.DateCreated)<= coalesce(ur.quizcompletiondate,o.DefaultQuizCompletionDate) and (coalesce(ur.quizcompletiondate,o.DefaultQuizCompletionDate)<= getutcdate() or DATEDIFF(MONTH,coalesce(ur.quizcompletiondate,o.DefaultQuizCompletionDate),QuizStatus.DateCreated)>12)) -- need to double check this in testing
				)
			)
		)
	)
)
	
--and not exists
--(SELECT * FROM tblQuizExpiryAtRisk
--where 	tblQuizExpiryAtRisk.UserID = QuizStatus.UserID
--and tblQuizExpiryAtRisk.ModuleID = QuizStatus.ModuleID
--and tblQuizExpiryAtRisk.OrganisationID = @OrgID)
)

SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_Update_Quick'',''delete from tblQuizExpiryAtRisk'',''delete from tblQuizExpiryAtRisk'',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_Update_Quick'',1,1,null,getutcdate(),getutcdate()) END


insert into tblQuizExpiryAtRisk -- add users that are now AtRisk that were not already flagged as AtRisk
(
OrganisationID,
UserID,
ModuleID,
PreExpiryNotified,
ExpiryNotifications,
expirydate
)

SELECT      
	@orgid,
	QuizStatus.UserID, 
	QuizStatus.ModuleID ,
	case when re.QuizExpiryWarn=0 then -1 else 0 end as preexpiry ,
	0 as postexpiry,
	case when quizstatus.QuizStatusID = 1 then 
				dateadd (d,re.daystocompletecourse,QuizStatus.DateCreated)
		 when QuizStatus.QuizStatusID>1 then 
				(
					case when coalesce(ur.quizcompletiondate,o.DefaultQuizCompletionDate)  is not null then 
						coalesce(ur.quizcompletiondate,o.DefaultQuizCompletionDate)
					else
						DATEADD(M,coalesce(ur.quizfrequency,o.DefaultQuizFrequency),QuizStatus.DateCreated)						
					end
				)
		 end
	as expiry		
FROM         
	tblUserQuizStatus AS QuizStatus 
	INNER JOIN dbo.tblModule AS m ON m.ModuleID = QuizStatus.ModuleID 	
	INNER JOIN(SELECT     MAX(UserQuizStatusID) AS UserQuizStatusID,ModuleID,uqs.UserID
				FROM          dbo.tblUserQuizStatus uqs
				join tblUser u on u.UserID = uqs.UserID and u.OrganisationID = @orgid and u.Active = 1
				GROUP BY ModuleID,uqs.UserID ) AS currentStatus ON QuizStatus.UserQuizStatusID = currentStatus.UserQuizStatusID and currentStatus.ModuleID = m.ModuleID
	join tblUser u on u.UserID =QuizStatus.UserID 
	join tblOrganisation o on o.OrganisationID = u.OrganisationID and o.OrganisationID = @orgid
	join tblReminderEscalation re on m.CourseID = re.CourseId and re.OrgId = o.OrganisationID and re.DateEnabled<GETUTCDATE()
	left join tblUnit unit on unit.UnitID = u.UnitID
	left join tblUnitRule ur on ur.UnitID = u.UnitID and ur.ModuleID = m.ModuleID
WHERE     (m.Active = 1) 
--/*
and
(
	-- pre expiry initial enrolment
	(
		quizexpirywarn = 1  and 
		(RemindUsers = 1 and re.PreExpInitEnrolment = 1 and quizstatus.QuizStatusID = 1 and DATEDIFF (D,getutcdate(),(dateadd (d,re.daystocompletecourse,QuizStatus.DateCreated)))<=re.DaysQuizExpiry 
			or
			--enable				--resit period reminder
			(PreExpResitPeriod = 1	and QuizStatus.QuizStatusID>1 and 
				-- pre expiry resit period	
				(dateadd(M,case when coalesce(ur.quizfrequency ,o.DefaultQuizFrequency) = 0 then 99 else coalesce(ur.quizfrequency,o.DefaultQuizFrequency) end , dateadd(d,-re.DaysQuizExpiry,  QuizStatus.DateCreated))<=GETUTCDATE()) 
				or 
				-- pre expiry resit period date
				(DATEADD(yy,1,quizstatus.DateCreated)<= coalesce(ur.quizcompletiondate,o.DefaultQuizCompletionDate) and DATEADD(D,-re.DaysQuizExpiry,coalesce(ur.quizcompletiondate,o.DefaultQuizCompletionDate))<= getutcdate())
			) 
		)
	)
	or
	(
		re.PostExpReminder = 1 and
		-- post expiry initial reminder
		(
			(
				 RemindUsers = 1 and re.PostExpInitEnrolment = 1 and QuizStatus.QuizStatusID = 1 and (dateadd (d,re.daystocompletecourse,QuizStatus.DateCreated))<=GETUTCDATE()
			)
			or
			-- post expiry resit period
			(
				re.PostExpResitPeriod = 1  and QuizStatus.QuizStatusID >1 and
				(
					-- post expiry resit period
					(dateadd(M,case when coalesce(ur.quizfrequency, o.DefaultQuizFrequency) = 0 then 99 else coalesce(ur.quizfrequency,o.DefaultQuizFrequency) end , QuizStatus.DateCreated)<=GETDATE()) 
					or 
					-- post expiry resit date
					(DATEADD(Y,1,quizstatus.DateCreated)<= coalesce(ur.quizcompletiondate,o.DefaultQuizCompletionDate) and coalesce(ur.quizcompletiondate,o.DefaultQuizCompletionDate)<= getutcdate())
				)
			)
		)
	)
)
	
	--*/
and not exists
(SELECT * FROM tblQuizExpiryAtRisk
where 	tblQuizExpiryAtRisk.UserID = QuizStatus.UserID
and tblQuizExpiryAtRisk.ModuleID = QuizStatus.ModuleID
and tblQuizExpiryAtRisk.OrganisationID = @OrgID)


SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_Update_Quick'',''insert into tblQuizExpiryAtRisk'',''insert into tblQuizExpiryAtRisk'',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_Update_Quick'',1,1,null,getutcdate(),getutcdate()) END








drop table  #tblCurrentUserQuizStatus

drop table #tblCurrentAssignedModules

drop table #tblStartedModules
/* /UNITTEST: CourseStatus */


/* UNITTEST: Licensing */
EXEC prcDatabaseMail_SetupProfile -- incase email address etc has changed, re-setup.

-- Check who is missing license for current period, includes period turn over
declare @lic_CourseLicensingID int, @lic_UserID int
DECLARE LicensingLoop CURSOR
FOR
SELECT DISTINCT tblCourseLicensing.CourseLicensingID, vwUserModuleAccess.UserID
FROM tblCourseLicensing
INNER JOIN vwUserModuleAccess ON tblCourseLicensing.CourseID = vwUserModuleAccess.CourseID
AND tblCourseLicensing.OrganisationID = vwUserModuleAccess.OrganisationID
INNER JOIN tblUser ON vwUserModuleAccess.UserID = tblUser.UserID
LEFT OUTER JOIN	tblCourseLicensingUser ON tblCourseLicensing.CourseLicensingID = tblCourseLicensingUser.CourseLicensingID
WHERE tblCourseLicensing.DateStart <= GETUTCDATE()
AND tblCourseLicensing.DateEnd >= GETUTCDATE()
AND tblCourseLicensingUser.CourseLicensingID IS NULL
AND tblUser.Active = 1
AND vwUserModuleAccess.OrganisationID = @OrgID
Open LicensingLoop
FETCH NEXT FROM LicensingLoop
Into
@lic_CourseLicensingID, @lic_UserID
WHILE @@FETCH_STATUS = 0
BEGIN
IF NOT EXISTS(SELECT CourseLicensingID FROM tblCourseLicensingUser WHERE CourseLicensingID = @lic_CourseLicensingID and UserID = @lic_UserID)
BEGIN
INSERT INTO tblCourseLicensingUser(CourseLicensingID, UserID) VALUES (@lic_CourseLicensingID, @lic_UserID)
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_Update_Quick'',''INSERT INTO tblCourseLicensingUser'',''INSERT INTO tblCourseLicensingUser'',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_Update_Quick'',1,1,null,getutcdate(),getutcdate()) END
END
FETCH NEXT FROM LicensingLoop
Into
@lic_CourseLicensingID, @lic_UserID
END

CLOSE LicensingLoop
DEALLOCATE LicensingLoop



-- WARNING EMAILS
-- License Warning
declare @licenseWarnEmail nvarchar(4000)
declare @licenseWarnEmail_Subject nvarchar(4000)
declare @emailLicenseWarnLicRecipients nvarchar(512)
declare @warn_lic_CourseName nvarchar(200),
@warn_lic_CourseLicensingID int,
@warn_lic_LicenseNumber int,
@warn_lic_LicenseWarnNumber int,
@warn_lic_RepNameSalt nvarchar(200),
@warn_lic_RepEmailSalt nvarchar(200),
@warn_lic_RepNameOrg nvarchar(200),
@warn_lic_RepEmailOrg nvarchar(200),
@warn_lic_LangCode nvarchar(10),
@warn_lic_LicensesUsed int,
@warn_lic_LicenseWarnEmail bit,
@warn_lic_OrganisationName nvarchar(50)

DECLARE LicenceNumberLoop CURSOR
FOR
SELECT
c.Name, l.CourseLicensingID, l.LicenseNumber, l.LicenseWarnNumber, l.RepNameSalt, l.RepEmailSalt,
l.RepNameOrg, l.RepEmailOrg, l.LangCode, COUNT(u.CourseLicensingUserID) AS LicensesUsed,
l.LicenseWarnEmail, OrganisationName
FROM
tblCourseLicensing l
INNER JOIN tblCourseLicensingUser u ON l.CourseLicensingID = u.CourseLicensingID
INNER JOIN tblCourse c ON l.CourseID = c.CourseID
LEFT JOIN tblOrganisation o ON l.OrganisationID = o.OrganisationID
WHERE
l.OrganisationID = @OrgID
GROUP BY
OrganisationName, l.CourseLicensingID, l.RepNameSalt, l.RepEmailSalt, l.RepNameOrg, l.RepEmailOrg, c.Name, l.LicenseNumber,
l.LicenseWarnNumber, l.LicenseWarnEmail, l.LangCode
HAVING
COUNT(u.CourseLicensingUserID) >= l.LicenseWarnNumber
AND l.LicenseWarnEmail = 1

Open LicenceNumberLoop
FETCH NEXT FROM LicenceNumberLoop
Into @warn_lic_CourseName,
@warn_lic_CourseLicensingID,
@warn_lic_LicenseNumber,
@warn_lic_LicenseWarnNumber,
@warn_lic_RepNameSalt,
@warn_lic_RepEmailSalt,
@warn_lic_RepNameOrg,
@warn_lic_RepEmailOrg,
@warn_lic_LangCode,
@warn_lic_LicensesUsed,
@warn_lic_LicenseWarnEmail,
@warn_lic_OrganisationName

WHILE @@FETCH_STATUS = 0
BEGIN
-- Get License Warning text in desired language.
SELECT     @licenseWarnEmail = tblLangValue.LangEntryValue
FROM         tblLang INNER JOIN
tblLangValue ON tblLang.LangID = tblLangValue.LangID INNER JOIN
tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID INNER JOIN
tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID
WHERE     (tblLang.LangCode = @warn_lic_LangCode) AND (tblLangInterface.LangInterfaceName = ''/ContentAdministration/Licensing/Default.aspx'') AND
(tblLangResource.LangResourceName = ''Email_LicenseWarn'') AND (tblLangValue.Active = 1)

SELECT     @licenseWarnEmail_Subject = tblLangValue.LangEntryValue
FROM         tblLang INNER JOIN
tblLangValue ON tblLang.LangID = tblLangValue.LangID INNER JOIN
tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID INNER JOIN
tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID
WHERE     (tblLang.LangCode = @warn_lic_LangCode) AND (tblLangInterface.LangInterfaceName = ''/ContentAdministration/Licensing/Default.aspx'') AND
(tblLangResource.LangResourceName = ''Email_LicenseWarn_Subject'') AND (tblLangValue.Active = 1)

-- {0} is receipient name, {1} is the license warning amount, {2} course name, {3} license limit, {4} name of contact person
-- {5} is organisation name
set @licenseWarnEmail = REPLACE(@licenseWarnEmail, ''{0}'', @warn_lic_RepNameOrg)
set @licenseWarnEmail = REPLACE(@licenseWarnEmail, ''{1}'', @warn_lic_LicenseWarnNumber)
set @licenseWarnEmail = REPLACE(@licenseWarnEmail, ''{2}'', @warn_lic_CourseName)
set @licenseWarnEmail = REPLACE(@licenseWarnEmail, ''{3}'', @warn_lic_LicenseNumber)
set @licenseWarnEmail = REPLACE(@licenseWarnEmail, ''{4}'', @warn_lic_RepNameSalt)
set @licenseWarnEmail = REPLACE(@licenseWarnEmail, ''{5}'', @warn_lic_OrganisationName)

set @licenseWarnEmail_Subject = REPLACE(@licenseWarnEmail_Subject, ''{0}'', @warn_lic_CourseName)
set @licenseWarnEmail_Subject = REPLACE(@licenseWarnEmail_Subject, ''{1}'', @warn_lic_OrganisationName)

select @emailLicenseWarnLicRecipients = @warn_lic_RepEmailOrg +'';''+@warn_lic_RepEmailSalt

EXEC msdb.dbo.sp_send_dbmail
@recipients = @emailLicenseWarnLicRecipients,
@body = @licenseWarnEmail,
@subject = @licenseWarnEmail_Subject,
@profile_name = ''Salt_MailAccount''

--Log emails sent
exec prcEMail_LogSentEmail @toEmail = @warn_lic_RepEmailOrg, @toName = null, @fromEmail = ''support@blakedawson.com'', @fromName = ''Blake Dawson'', @subject = @licenseWarnEmail_Subject, @body = @licenseWarnEmail, @organisationID = @OrgID
exec prcEMail_LogSentEmail @toEmail = @warn_lic_RepEmailSalt, @toName = null, @fromEmail = ''support@blakedawson.com'', @fromName = ''Blake Dawson'', @subject = @licenseWarnEmail_Subject, @body = @licenseWarnEmail, @organisationID = @OrgID

print ''queued numLics warning mail to : '' + @emailLicenseWarnLicRecipients

-- Unset flag and record date email sent
UPDATE tblCourseLicensing SET DateLicenseWarnEmailSent = getutcdate(), LicenseWarnEmail = 0 WHERE CourseLicensingID = @warn_lic_CourseLicensingID
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_Update_Quick'',''UPDATE tblCourseLicensing'',''UPDATE tblCourseLicensing'',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_Update_Quick'',1,1,null,getutcdate(),getutcdate()) END

FETCH NEXT FROM LicenceNumberLoop
Into @warn_lic_CourseName,
@warn_lic_CourseLicensingID,
@warn_lic_LicenseNumber,
@warn_lic_LicenseWarnNumber,
@warn_lic_RepNameSalt,
@warn_lic_RepEmailSalt,
@warn_lic_RepNameOrg,
@warn_lic_RepEmailOrg,
@warn_lic_LangCode,
@warn_lic_LicensesUsed,
@warn_lic_LicenseWarnEmail,
@warn_lic_OrganisationName
END

CLOSE LicenceNumberLoop
DEALLOCATE LicenceNumberLoop
-- /License Warning


-- Expiry Warning
declare @expiryWarnEmail nvarchar(4000)
declare @expiryWarnEmail_Subject nvarchar(4000)
declare @emailLicenseWarnExpRecipients nvarchar(512)
DECLARE @warn_exp_CourseLicensingID int,
@warn_exp_CourseName nvarchar(200),
@warn_exp_DateWarn datetime,
@warn_exp_ExpiryWarnEmail bit,
@warn_exp_DateEnd datetime,
@warn_exp_RepNameSalt nvarchar(200),
@warn_exp_RepEmailSalt nvarchar(200),
@warn_exp_RepNameOrg nvarchar(200),
@warn_exp_RepEmailOrg nvarchar(200),
@warn_exp_LangCode nvarchar(10),
@warn_exp_OrganisationName nvarchar(50)

DECLARE LicenceExpiryLoop CURSOR
FOR
SELECT
l.CourseLicensingID, c.Name, l.DateWarn, l.ExpiryWarnEmail, l.DateEnd, l.RepNameSalt,
l.RepEmailSalt, l.RepNameOrg, l.RepEmailOrg, l.LangCode, OrganisationName
FROM
tblCourseLicensing l
INNER JOIN tblCourse c ON l.CourseID = c.CourseID
LEFT JOIN tblOrganisation o ON l.OrganisationID = o.OrganisationID
WHERE
l.DateWarn < GETUTCDATE()
AND l.ExpiryWarnEmail = 1
AND l.OrganisationID = @OrgID

Open LicenceExpiryLoop
FETCH NEXT FROM LicenceExpiryLoop
Into @warn_exp_CourseLicensingID,
@warn_exp_CourseName,
@warn_exp_DateWarn,
@warn_exp_ExpiryWarnEmail,
@warn_exp_DateEnd,
@warn_exp_RepNameSalt,
@warn_exp_RepEmailSalt,
@warn_exp_RepNameOrg,
@warn_exp_RepEmailOrg,
@warn_exp_LangCode,
@warn_exp_OrganisationName

WHILE @@FETCH_STATUS = 0
BEGIN
-- Get Expiry Warning text in desired language.
SELECT     @expiryWarnEmail = tblLangValue.LangEntryValue
FROM         tblLang INNER JOIN
tblLangValue ON tblLang.LangID = tblLangValue.LangID INNER JOIN
tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID INNER JOIN
tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID
WHERE     (tblLang.LangCode = @warn_exp_LangCode) AND (tblLangInterface.LangInterfaceName = ''/ContentAdministration/Licensing/Default.aspx'') AND
(tblLangResource.LangResourceName = ''Email_ExpiryWarn'') AND (tblLangValue.Active = 1)

SELECT     @expiryWarnEmail_Subject = tblLangValue.LangEntryValue
FROM         tblLang INNER JOIN
tblLangValue ON tblLang.LangID = tblLangValue.LangID INNER JOIN
tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID INNER JOIN
tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID
WHERE     (tblLang.LangCode = @warn_exp_LangCode) AND (tblLangInterface.LangInterfaceName = ''/ContentAdministration/Licensing/Default.aspx'') AND
(tblLangResource.LangResourceName = ''Email_ExpiryWarn_Subject'') AND (tblLangValue.Active = 1)

-- {0} Receipient Name, {1} number days till expiry, {2} course name, {3} expiry date, {4} Salt rep name
-- {5} Organisation Name
set @expiryWarnEmail = REPLACE(@expiryWarnEmail, ''{0}'', @warn_exp_RepNameOrg)
set @expiryWarnEmail = REPLACE(@expiryWarnEmail, ''{1}'', DATEDIFF(dd,dbo.udfUTCtoDaylightSavingTime(getUTCdate(),@OrgID),dbo.udfUTCtoDaylightSavingTime(@warn_exp_DateEnd,@OrgID)))
set @expiryWarnEmail = REPLACE(@expiryWarnEmail, ''{2}'', @warn_exp_CourseName)
set @expiryWarnEmail = REPLACE(@expiryWarnEmail, ''{3}'', CONVERT(CHAR(10), dbo.udfUTCtoDaylightSavingTime(@warn_exp_DateEnd,@OrgID), 103))
set @expiryWarnEmail = REPLACE(@expiryWarnEmail, ''{4}'', @warn_exp_RepNameSalt)
set @expiryWarnEmail = REPLACE(@expiryWarnEmail, ''{5}'', @warn_exp_OrganisationName)

set @expiryWarnEmail_Subject = REPLACE(@expiryWarnEmail_Subject, ''{0}'', @warn_exp_CourseName)
set @expiryWarnEmail_Subject = REPLACE(@expiryWarnEmail_Subject, ''{1}'', @warn_exp_OrganisationName)

select @emailLicenseWarnExpRecipients = @warn_exp_RepEmailOrg +'';''+@warn_exp_RepEmailSalt

EXEC msdb.dbo.sp_send_dbmail
@recipients = @emailLicenseWarnExpRecipients,
@body = @expiryWarnEmail,
@subject = @expiryWarnEmail_Subject,
@profile_name = ''Salt_MailAccount''

--Log emails sent
exec prcEMail_LogSentEmail @toEmail = @warn_exp_RepEmailOrg, @toName = null, @fromEmail = ''support@blakedawson.com'', @fromName = ''Blake Dawson'', @subject = @expiryWarnEmail_Subject, @body = @expiryWarnEmail, @organisationID = @OrgID
exec prcEMail_LogSentEmail @toEmail = @warn_exp_RepEmailSalt, @toName = null, @fromEmail = ''support@blakedawson.com'', @fromName = ''Blake Dawson'', @subject = @expiryWarnEmail_Subject, @body = @expiryWarnEmail, @organisationID = @OrgID

print ''queued expiry mail to : '' + @emailLicenseWarnExpRecipients
-- Unset flag and record date email sent
UPDATE tblCourseLicensing SET DateExpiryWarnEmailSent = getutcdate(), ExpiryWarnEmail = 0 WHERE CourseLicensingID = @warn_exp_CourseLicensingID
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_Update_Quick'',''UPDATE tblCourseLicensing'',''UPDATE tblCourseLicensing'',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_Update_Quick'',1,1,null,getutcdate(),getutcdate()) END


FETCH NEXT FROM LicenceExpiryLoop
Into @warn_exp_CourseLicensingID,
@warn_exp_CourseName,
@warn_exp_DateWarn,
@warn_exp_ExpiryWarnEmail,
@warn_exp_DateEnd,
@warn_exp_RepNameSalt,
@warn_exp_RepEmailSalt,
@warn_exp_RepNameOrg,
@warn_exp_RepEmailOrg,
@warn_exp_LangCode,
@warn_exp_OrganisationName
END

CLOSE LicenceExpiryLoop
DEALLOCATE LicenceExpiryLoop
-- /Expiry Warning
/* /UNITTEST: Licensing */


/* UNITTEST: ModuleNightly */
-- START Course status reconcile. If a module has been made active or inactive to run through all user and ensure that their course status is correct.
-- AS PER BUSINESS requirement
-- Get all changed modules
declare @c_CourseID int, @c_ModuleID int
DECLARE UpdatedModuleLOOP CURSOR
FOR
SELECT CourseID, ModuleID FROM tblModule WHERE(DateUpdated > GETUTCDATE() - 2)
Open UpdatedModuleLOOP

FETCH NEXT FROM UpdatedModuleLOOP
Into
@c_CourseID, @c_ModuleID

WHILE @@FETCH_STATUS = 0
BEGIN
-- Get all users related to this module
declare @c_UserID int
DECLARE UserLOOP CURSOR
FOR
SELECT UserID FROM tblUserModuleAccess WHERE ModuleID = @c_ModuleID
Open UserLOOP


FETCH NEXT FROM UserLOOP
Into
@c_UserID

WHILE @@FETCH_STATUS = 0
BEGIN
EXEC prcUserQuizStatus_UpdateCourseStatus @c_UserID, @c_ModuleID
SET @Err = @@ERROR; if @Err <> 0 BEGIN INSERT into tblErrorLog ([Source],[Module],[Function],[Code],[Message],[StackTrace],[ErrorLevel],[ErrorStatus],[Resolution],[DateCreated],[DateUpdated])     VALUES(''prcUserQuizStatus_Update_Quick'',''prcUserQuizStatus_UpdateCourseStatus'',''prcUserQuizStatus_UpdateCourseStatus'',CAST(@Err AS varchar(50)),CAST(@Err AS varchar(50)),''prcUserQuizStatus_Update_Quick'',1,1,null,getutcdate(),getutcdate()) END

FETCH NEXT FROM UserLOOP
Into
@c_UserID
END

CLOSE UserLOOP
DEALLOCATE UserLOOP

FETCH NEXT FROM UpdatedModuleLOOP
Into
@c_CourseID, @c_ModuleID
END

CLOSE UpdatedModuleLOOP
DEALLOCATE UpdatedModuleLOOP
/* /UNITTEST: ModuleNightly */




/* UNITTEST: ExtendComplianceDate */
update tblOrganisation
set DefaultQuizCompletionDate = dateadd(year, 1, [DefaultQuizCompletionDate])
where DefaultQuizCompletionDate < getutcdate() and OrganisationID = @OrgID

update tblUnitRule
set QuizCompletionDate = dateadd(year, 1, [QuizCompletionDate])
where QuizCompletionDate < getutcdate() and UnitID IN (select UnitID from tblUnit where OrganisationID = @OrgID)
/* /UNITTEST: ExtendComplianceDate */


-- END Course status reconcile.


update tblOrganisation set CourseStatusLastUpdated = dbo.udfUTCtoDaylightSavingTime(getutcdate(),@OrgID) where OrganisationID = @OrgID

update tblModuleStatusUpdateHistory
set FinishTime = getutcdate()
where ModuleStatusUpdateHistoryID = @intHistoryID
' 
END
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPolicy_UserSearch]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*Summary:
Returns results of search for users on Assign Users tab of CPDdetail.aspx

Returns:

Called By:

Calls:

Remarks:
The searching units will include all children and grandchildren
Only return users that logged on user has permission to see


Author: Aaron Cripps
Date Created: Feb 2009

Modification History
-----------------------------------------------------------
v#	Author		Date			Description

**/

CREATE  Procedure  [dbo].[prcPolicy_UserSearch]
(
@organisationID  Int,
@PolicyID int,
@parentUnitIDs  Varchar(max),
@firstName	nVarchar(50),
@lastName	nVarchar(50),
@userName	nVarChar(100),
@Email		nVarChar(100),
@ExternalID nVarChar(50),
@adminUserID		Int,
@Type nvarchar(50)
)
As
Set Nocount On

Declare @intUserTypeID Int

Select @intUserTypeID = UserTypeID
From tblUser
Where userID = @adminUserID



--Check Data
If @parentUnitIDs is null
set @parentUnitIDs =''''

If @firstName is null
Set @firstName = ''''

Set @firstName =rtrim(@firstName)

If @lastName is null
Set @lastName = ''''

Set @lastName =rtrim(@lastName)

If @userName is null
Set @userName = ''''

set @userName = rtrim(@userName)

if @Email is null
set @Email = ''''

set @Email = rtrim(@Email)

if @ExternalID is null
set @ExternalID = ''''

set @ExternalID = rtrim(@ExternalID)

if @Type = ''search''
Begin
Select
us.UserID,
us.UserName,
us.FirstName,
case
When us.Active = 0 then us.LastName + ''(I)''
Else us.LastName
end as LastName,
case
When us.LastLogin Is Null then ''Never''
Else cast(us.LastLogin as varchar)
end as LastLogin,
dbo.udfGetUnitPathway(us.UnitID) as Pathway,
us.Active,
upa.Granted

From tblUnit un, tblUser us, tblUserPolicyAccess upa

Where (un.OrganisationID = @organisationID)
and
(
us.Active=1
)
--0. Join Unit and User tables
and (
un.UnitID = us.UnitID
)
-- Join User and UserProfilePeriodAccess tables
and (
us.UserID = upa.UserID
)
and (
upa.PolicyID = @PolicyID
)
--1. Within the selected Parent Units (can select multiple units)
--The unit hierarchy contains the parent Unit ID
and (
un.UnitID in
(
Select IntValue from dbo.udfCsvToInt(@parentUnitIDs)
)
or (@parentUnitIDs='''')
)
--2. User firstname contains the entered text
and (
(firstname like ''%''+ @firstName + ''%'')
or (firstname ='''')
)
--3. User lastname contains the entered text
and (
(lastname like ''%''+ @lastName + ''%'')
or (lastname ='''')
)
-- User username contains the entered text
and (
(username like ''%'' + @userName + ''%'')
or (userName='''')
)
-- User email contains the entered text
and (
(email like ''%'' + @Email + ''%'')
or (email='''') or (email = null)
)
-- User externalid contains the entered text
and (
(externalID like ''%'' + @ExternalID + ''%'')
or (externalID = '''') or (externalid = null)
)
--4. Permission
--Salt Administrator(1), Organisation Administrator(2) has permission to access all units
--Unit Administrator(3) only has permission to those that he is administrator
and (
(@intUserTypeID<3)
or (un.UnitID in (select UnitID from tblUnitAdministrator where UserID=@adminUserID))
)
Order By Name
End
else if @Type = ''view''
Begin
Select
us.UserID,
us.UserName,
us.FirstName,
case
When us.Active = 0 then us.LastName + ''(I)''
Else us.LastName
end as LastName,
case
When us.LastLogin Is Null then ''Never''
Else cast(us.LastLogin as varchar)
end as LastLogin,
dbo.udfGetUnitPathway(us.UnitID) as Pathway,
us.Active,
upa.Granted

From tblUnit un, tblUser us, tblUserPolicyAccess upa

Where (un.OrganisationID = @organisationID)
and
(
us.Active=1
)
--0. Join Unit and User tables
and (
un.UnitID = us.UnitID
)
-- Join User and UserProfilePeriodAccess tables
and (
us.UserID = upa.UserID
)
and (
upa.PolicyID = @PolicyID
)
--1. Within the selected Parent Units (can select multiple units)
--The unit hierarchy contains the parent Unit ID
--and (
--un.UnitID in
--	(
--		Select IntValue from dbo.udfCsvToInt(@parentUnitIDs)
--	)
--	or (@parentUnitIDs='''')
--	)
--2. User firstname contains the entered text
--and (
--	(firstname like ''%''+ @firstName + ''%'')
--	or (firstname ='''')
--    )
--3. User lastname contains the entered text
--and (
--	(lastname like ''%''+ @lastName + ''%'')
--	or (lastname ='''')
--    )
-- User username contains the entered text
--and (
--	(username like ''%'' + @userName + ''%'')
--	or (userName='''')
--	)
-- User email contains the entered text
--and (
--	(email like ''%'' + @Email + ''%'')
--	or (email='''') or (email = null)
--	)
-- User externalid contains the entered text
--and (
--	(externalID like ''%'' + @ExternalID + ''%'' )
--	or (externalID = '''') or (externalid = null)
--	)
--4. Permission
--Salt Administrator(1), Organisation Administrator(2) has permission to access all units
--Unit Administrator(3) only has permission to those that he is administrator
and (
(@intUserTypeID<3)
or (un.UnitID in (select UnitID from tblUnitAdministrator where UserID=@adminUserID))
)
and upa.Granted=1
Order By Name
End
' 
END
GO