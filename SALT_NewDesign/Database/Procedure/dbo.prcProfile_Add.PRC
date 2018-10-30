SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcProfile_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Adds Profile

Parameters:
@ProfileName

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

create procedure [prcProfile_Add]
(
@ProfileID int output,
@profilePeriodID int Output,
@OrganisationID int,
@ProfileName nvarchar(255),
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
Begin

set @DateStart = dbo.udfDaylightSavingTimeToUTC(@DateStart, @OrganisationID)
set @DateEnd =dbo.udfDaylightSavingTimeToUTC(@DateEnd, @OrganisationID)
set @FutureDateStart = dbo.udfDaylightSavingTimeToUTC(@FutureDateStart, @OrganisationID)
set @FutureDateEnd = dbo.udfDaylightSavingTimeToUTC(@FutureDateEnd, @OrganisationID)

-- insert values into tblProfile
insert into tblProfile
(OrganisationID,
ProfileName)
values
(@OrganisationID,
@ProfileName)

-- get ProfileID
set @ProfileID = @@Identity

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
ProfilePeriodActive)
values
(@ProfileID,
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
1)

-- get the profileperiodid
set @ProfilePeriodID = @@Identity
End
' 
END
GO
