SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_GetOne]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
Summary: Gets the details of one User
Parameters: @userID integer
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

CREATE Procedure [prcUser_GetOne]
(
	@userID Integer = null -- User ID
)

As
begin 

	Set NoCount On

	If @userID Is Null
	Begin
		Raiserror(''The Parameter @userID was null.  @userID does not accept Null values.'', 16, 1)
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
		dbo.udfUTCtoDaylightSavingTime(DateCreated, OrganisationID) as DateCreated,
		UpdatedBy,
		dbo.udfUTCtoDaylightSavingTime(DateUpdated, OrganisationID) as DateUpdated,
		dbo.udfUTCtoDaylightSavingTime(LastLogin, OrganisationID) as LastLogin,
		TimeZoneID,
		DelinquencyManagerEmail,
		NotifyMgr,
		NotifyUnitAdmin,
NotifyOrgAdmin,
EbookNotification
	From
		tblUser
	Where
		UserID = @userID
END



' 
END
GO
