SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prcProfile_CheckProfileName]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[pprcProfile_CheckProfileName]
GO

/*
Summary:
 Stored procedure to check if a Profile with the same name
 as that being created already exists

Parameters:
 @ProfileName nvarchar(255)
 @OrganisationID int


Called By:
 Profile.cs

Author: Aaron Cripps
Date Created: July 2008

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	

*/
create procedure prcProfile_CheckProfileName
(
@ProfileName nvarchar(255),
@OrganisationID int
)
as

select ProfileName
from tblProfile
where OrganisationID = @OrganisationID
and ProfileName = @ProfileName


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO