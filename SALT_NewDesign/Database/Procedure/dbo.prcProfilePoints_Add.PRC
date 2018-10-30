SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcProfilePoints_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
Adds Profile

Parameters:
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

CREATE procedure [prcProfilePoints_Add]
(
@ProfilePointsType nvarchar(1),
@TypeID int,
@ProfilePeriodID int,
@Points numeric(10,1),
@Active bit,
@OrgID int
--@ApplyToQuiz bit,
--@ApplyToLesson bit
)

as



-- insert values into tblProfilePoints
insert into tblProfilePoints
(
ProfilePointsType,
TypeID,
ProfilePeriodID,
Points,
Active,
DateAssigned --,
--ApplyToQuiz,
--ApplyToLesson
)
values
(
@ProfilePointsType,
@TypeID,
@ProfilePeriodID,
@Points,
@Active,
GETUTCDATE() --,
--@ApplyToQuiz,
--@ApplyToLesson
)

/****** Object:  Table [dbo].[tbllogInstall42]    Script Date: 07/07/2011 17:05:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[tbllogInstall42]'') AND type in (N''U''))
DROP TABLE [dbo].[tbllogInstall42]
' 
END
GO
