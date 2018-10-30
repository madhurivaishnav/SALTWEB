SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPolicy_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
Add a new Policy.

Parameters:
@PolicyID output int,
@OrganisationID int,
@PolicyName nvarchar(255),
@Active bit,
@Deleted bit,
@PolicyFileName nvarchar(255),
@PolicyFileSize bigint,
@UploadDate datetime


Returns:
Nothing

Called By:
Policy.cs.

Calls:
Nothing

Remarks:
None

Author: Aaron Cripps
Date Created: June 2008

Modification History
-----------------------------------------------------------
v#	Author		Date			Description

**/

CREATE procedure [prcPolicy_Add]
(
@PolicyID int output,
@OrganisationID int,
@PolicyName nvarchar(255),
@Active bit,
@Deleted bit,
@PolicyFileName nvarchar(255),
@PolicyFileSize bigint,
@ConfirmationMessage nvarchar(500)
)
as

insert into tblPolicy
(
OrganisationID,
PolicyName,
Active,
Deleted,
PolicyFileName,
PolicyFileSize,
UploadDate,
ConfirmationMessage
)
values
(
@OrganisationID,
@PolicyName,
@Active,
@Deleted,
@PolicyFileName,
@PolicyFileSize,
getUTCDate(),
@ConfirmationMessage
)

set @PolicyID = @@Identity

-- get a list of all users for the organisation
create table #UserTemp
(
UserID int
)

insert into #UserTemp (UserID)
Select
UserID
From
tblUser
Where
OrganisationID = @organisationID

insert into tblUserPolicyAccepted (PolicyID, UserID, Accepted)
select @PolicyID, UserID, 0 from #UserTemp

drop table #UserTemp

/*
do this bit for policies that are created after the profiles have been created
*/
insert into tblprofilepoints ( profilepointstype, typeid, profileperiodid, points, active, dateassigned)
select ''P'',@PolicyID,profileperiodid,0,1,getutcdate() from tblprofileperiod

select @PolicyID
' 
END
GO
