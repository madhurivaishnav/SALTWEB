SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
