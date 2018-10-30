SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prcUser_GetDetailsByEmail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prcUser_GetDetailsByEmail]
GO

/*
Summary: Gets the details of one User by their email address
Parameters: @emailAddress varchar(100)
Returns: UserID, FirstName, LastName, UserName, Password, Email, ExternalID, OrganisationID, UnitID, UserTypeID, Active, CreatedBy, DateCreated, UpdatedBy, DateUpdated

Called By: User.cs
Calls: None

Remarks: Raises an error if the parameter is null

Author: Gavin Buddis
Date Created: 10th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	
*/

CREATE Procedure prcUser_GetDetailsByEmail
(
	@emailAddress varchar(100) = null -- Email Address
)

As
Set NoCount On

If @emailAddress Is Null
Begin
	Raiserror('The Parameter @emailAddress was null.  @emailAddress does not accept Null values.', 16, 1)
	Return
End

Select
	UserID,
	FirstName,
	LastName,
	UserName,
	Password,
	Email,
	ExternalID,
	OrganisationID,
	UnitID,
	UserTypeID,
	Active,
	CreatedBy,
	DateCreated,
	UpdatedBy,
	DateUpdated
From
	tblUser
Where
	Email = @emailAddress
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

 