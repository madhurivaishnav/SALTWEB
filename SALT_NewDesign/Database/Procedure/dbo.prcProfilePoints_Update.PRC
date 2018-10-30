SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcProfilePoints_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Updates ProfilePoints

Parameters:
@ProfilePointsID int,
@ProfilePointsType nvarchar(1),
@TypeID int,
@ProfilePeriodID int,
@Points numeric(10,1),
@Active bit,
@DateAssigned datetime

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

create procedure [prcProfilePoints_Update]
(
@ProfilePointsID int,
@ProfilePointsType nvarchar(1),
@TypeID int,
@ProfilePeriodID int,
@Points numeric(10,1),
@Active bit,
@DateAssigned datetime,
@OrgID int
--@ApplyToQuiz bit,
--@ApplyToLesson bit
)

as

set @DateAssigned = dbo.udfDaylightSavingTimeToUTC(@DateAssigned, @OrgID)

-- update tblProfilePoints values
update tblProfilePoints
set
ProfilePointsType = @ProfilePointsType,
TypeID = @TypeID,
ProfilePeriodID = @ProfilePeriodID,
Points = @Points,
Active = @Active --,
--DateAssigned = @DateAssigned --,
--ApplyToQuiz = @ApplyToQuiz,
--ApplyToLesson = @ApplyToLesson
where ProfilePointsID = @ProfilePointsID

' 
END
GO
