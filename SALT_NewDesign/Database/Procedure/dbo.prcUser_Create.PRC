SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_Create]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
Inserts a new user.

Parameters:
@organisationID		(Mandatory)
@unitID 			(Mandatory)
@firstName 			(Mandatory)
@lastName			(Mandatory)
@userName			(Mandatory)
@email				(Mandatory)
@active			(Mandatory)
@userTypeID			(Mandatory)
@actionUserID			(Mandatory)
@password			(Mandatory)

Returns:
@intErrorNumber As ''ErrorNumber'',
@strErrorMessage As ''ErrorMessage''

Called By:
User.cs.

Calls:
Nothing

Assumptions:
The majority of business logic related to password
lengths, confirmation passwords, valid emails etc.
are implemented through the UI.
Assumption is that the parameters when passed in
contain valid data.

Remarks:
Exception:
0. Succeed
1. RecordNotFound
2. FK constraint
3. PKViolationException
4. UniqueViolationException
5. MissingParameterException
7. IntegrityConstraintException
10. BusinessServiceException (General)


Author: Peter Vranich
Date Created: 20th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	Jack Liu	15/09/2005		User name is only unique per organisation

**/
CREATE  Procedure [prcUser_Create]
(
@organisationID Integer = Null,
@unitID Integer = Null,
@firstName nvarchar(50) = Null,
@lastName nvarchar(50) = Null,
@userName nvarchar(100) = Null,
@email nvarchar(100) = null,
@active bit = null,
@userTypeID Integer = Null,
@actionUserID Integer = Null,
@password nvarchar(50) = Null,
@externalID nvarchar(50) = Null,
@TimeZoneID Integer = Null,
@DelinquencyManagerEmail nvarchar(100) = Null,
@NotifyMgr bit = 0,
@NotifyUnitAdmin bit = 0, 
@NotifyOrgAdmin bit = 0, 
@EbookNotification bit = 0
)

As

Set NoCount On
Set Xact_Abort On

Begin Transaction

-- Declarations
Declare @strErrorMessage Varchar(200) -- Holds the error message
Declare @intErrorNumber Integer -- Holds the error number
Declare @UserID integer -- Holds the UserID once created

-- Initialise variables
Set @strErrorMessage = ''''
Set @intErrorNumber = 0

-- PARAMETER VALIDATION
--==============================================================

-- If user type is not SALT Administrator, check that a OrgID and UnitID has been supplied
If(@userTypeID <>1)
Begin
If(@organisationID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @organisationID in stored procedure prcUser_Create''
Goto Finalise
End

--Validate Parameter @unitID
If(@unitID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @unitID in stored procedure prcUser_Create''
Goto Finalise
End
End

--Validate Parameter @firstName
If(@firstName Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @firstName in stored procedure prcUser_Create''
Goto Finalise
End

--Validate Parameter @lastName
If(@lastName Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @lastName in stored procedure prcUser_Create''
Goto Finalise
End

--Validate Parameter @userName
If(@userName Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @userName in stored procedure prcUser_Create''
Goto Finalise
End

--Validate Parameter @email
If(@email Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @email in stored procedure prcUser_Create''
Goto Finalise
End

--Validate Parameter @active
If(@active Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @active in stored procedure prcUser_Create''
Goto Finalise
End

--Validate Parameter @userTypeID
If(@userTypeID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @userTypeID in stored procedure prcUser_Create''
Goto Finalise
End

--Validate Parameter @createdByUserID
If(@actionUserID Is Null)
Begin
Set @intErrorNumber = 5
Set @strErrorMessage = ''Missing or Null parameter @updatedByUserID in stored procedure prcUser_Create''
Goto Finalise
End

-- If a unit was specified make sure it exists
--=========================================================
If (@unitID Is Not Null)
Begin
If Not Exists(Select * From tblUnit Where UnitID = @unitID)
Begin
Set @intErrorNumber = 1
Set @strErrorMessage = ''The specified unit could be found or may not be active.''
Goto Finalise
End
End

If(@userTypeID <>1)
begin
-- User name is unique per organisation
If Exists(Select * From tblUser Where Username = @userName and (organisationID=@organisationID or organisationID is null))
Begin
Set @intErrorNumber = 4
Set @strErrorMessage = @userName
Goto Finalise
End
end
else
begin
If Exists(Select * From tblUser Where Username = @userName)
Begin
Set @intErrorNumber = 4
Set @strErrorMessage = @userName
Goto Finalise
End
end


If Exists(Select * From tblUser Where Email = @email)
Begin
Set @intErrorNumber = 41
Set @strErrorMessage = ''The email address '' + @email + '' already exists.  <BR>Please choose another email address.''
Goto Finalise
End

Insert Into tblUser
(
OrganisationID,
FirstName,
LastName,
UserName,
Password,
Email,
UnitID,
UserTypeID,
Active,
CreatedBy,
DateCreated,
ExternalID,
NewStarter,
TimeZoneID,
DelinquencyManagerEmail,
NotifyMgr,
NotifyUnitAdmin,
NotifyOrgAdmin,
EbookNotification
)
Values
(
@organisationID,
@firstName,
@lastName,
@userName,
@password,
@email,
@unitID,
@userTypeID,
@active,
@actionUserID,
GETUTCDATE(),
@externalID, -- http://bugs.salt.devbdw.com/edit_bug.aspx?id=274
1,
@TimeZoneID,
@DelinquencyManagerEmail,
@NotifyMgr,
@NotifyUnitAdmin, 
@NotifyOrgAdmin, 
@EbookNotification
)

update tblUser set DateArchived = getutcdate() where Active = 0 and DateArchived IS NULL AND UserID = @@Identity
update tblUser set DateArchived = null where Active = 1 and NOT(DateArchived IS NULL) AND UserID = @@Identity

-- Set the error message to successfull
Set @strErrorMessage = @@Identity
Set @UserID = @@Identity


-- Get ProfilePeriodID''s for Organisation
create table #ProfilePeriod
(
ProfilePeriodID int
)

insert into #ProfilePeriod
select ProfilePeriodID
from tblProfilePeriod  pp
join tblprofile p
on pp.profileid = p.profileid
where p.organisationid = @OrganisationID


-- insert user into profileperiodaccess against all profileperiodid''s
-- for the organisation
insert into tblUserProfilePeriodAccess
select
pp.ProfilePeriodID,
@UserID,
uppa.granted
from #ProfilePeriod pp
join tblUnitProfilePeriodAccess uppa
on uppa.ProfilePeriodID = pp.ProfilePeriodID
where uppa.UnitID = @UnitID

drop table #ProfilePeriod

-- Get Policies for Organisation
create table #Policy
(
PolicyID int,
Granted bit
)

insert into #Policy
select p.PolicyID,
case when (select distinct granted from tblUnitPolicyAccess where unitID = @unitID and policyid = p.policyid) is null then 0
else (select distinct granted from tblUnitPolicyAccess where unitID = @unitID and policyid = p.policyid) end
from tblPolicy p where
OrganisationID = @OrganisationID
and deleted = 0


-- insert user into policy for all policy''s associated with organisation
insert into tblUserPolicyAccepted (PolicyID, UserID, Accepted)
select PolicyID, @UserID, 0 from #Policy

-- insert user into policyaccess for all policies
insert into tblUserPolicyAccess (PolicyID, UserID, Granted)
select PolicyID, @UserID, Granted  from #Policy

drop table #Policy

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


' 
END
GO
