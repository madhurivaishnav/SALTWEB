SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcProfile_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Updates a Profile.

Parameters:



Returns:
Nothing

Called By:
Profile.cs.

Calls:
Nothing

Remarks:
None

Author: Aaron Cripps
Date Created: July 2008

Modification History
-----------------------------------------------------------
v#	Author		Date			Description

**/

create procedure [prcProfile_Update]
(
@ProfileID int,
@ProfileName nvarchar(255),
@OrganisationID int,
@DateStart datetime,
@DateEnd datetime,
@Points numeric(10,1),
@EndOfPeriodAction char(1),
@MonthIncrement int,
@FutureDateStart datetime,
@FutureDateEnd datetime,
@FuturePoints numeric(10,1)
)
as

set @DateStart = dbo.udfDaylightSavingTimeToUTC(@DateStart, @OrganisationID)
set @DateEnd = dbo.udfDaylightSavingTimeToUTC(@DateEnd, @OrganisationID)
set @FutureDateStart = dbo.udfDaylightSavingTimeToUTC(@FutureDateStart, @OrganisationID)
set @FutureDateEnd = dbo.udfDaylightSavingTimeToUTC(@FutureDateEnd, @OrganisationID)

-- Update tblProfile
update tblProfile
set ProfileName =  @ProfileName
where ProfileID = @ProfileID
and OrganisationID = @OrganisationID

-- Get profileperiodid for profileid
declare @ProfilePeriodID int
-- Get ProfilePeriodID
set @ProfilePeriodID =
(select ProfilePeriodID
from tblProfilePeriod
where ProfileID = @ProfileID
and profileperiodactive = 1)

if @ProfilePeriodID > 0
begin
-- Update tblProfilePeriod
update tblProfilePeriod
set DateStart = @DateStart,
DateEnd = @DateEnd,
Points = @Points,
EndOfPeriodAction = @EndOfPeriodAction ,
MonthIncrement = @MonthIncrement ,
FutureDateStart = @FutureDateStart,
FutureDateEnd = @FutureDateEnd,
FuturePoints = @FuturePoints
where ProfilePeriodID = @ProfilePeriodID
and ProfileID = @ProfileID
end
else
begin
-- just in case - set any other profileperiods with same profileid
-- as inactive
update tblProfilePeriod
set profileperiodactive = 0
where profileid = @profileid

-- No profileperiod exists (profile with future period deleted)
-- so need to add the profile period
-- insert values into tblProfilePeriod


insert into tblProfilePeriod
(ProfileID,
DateStart,
DateEnd,
Points,
EndOfPeriodAction,
MonthIncrement,
FutureDateStart,
FutureDateEnd,
FuturePoints,
ApplyToQuiz,
ApplyToLesson,
profileperiodactive)
values
(
@ProfileID,
@DateStart,
@DateEnd,
@Points,
@EndOfPeriodAction,
@MonthIncrement,
@FutureDateStart,
@FutureDateEnd,
@FuturePoints,
1,
1,
1
)
end

' 
END
GO
