SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prcProfile_SetUserAccessByUnit]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prcProfile_SetUserAccessByUnit]
GO

/*Summary:
	Set's a users that have access to a profile

Parameters:
	@organisationID Integer	
	@ProfileID integer
	@UnitID integer
	
Returns:
	Nothing
		
Called By: 
	Profile.cs.

Calls:
	Nothing

Remarks:

Author: Aaron Cripps	
Date Created: July 2008

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	

**/

Create procedure prcProfile_SetUserAccessByUnit
(
	@ProfileID int,
	@UnitID int
)
as
set nocount on

declare @ProfilePeriodID int
set @ProfilePeriodID =
(select ProfilePeriodID
from tblProfilePeriod
where ProfileID = @ProfileID and profileperiodactive=1)

update tblUserProfilePeriodAccess
set Granted = 1
where ProfilePeriodID = @ProfilePeriodID
and UserID in 
(select UserID from tblUser where UnitID = @UnitID and active=1)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO