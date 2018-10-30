SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcSearchUsers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra Jagtap
-- Create date: 27/10/2011
-- Description:	Searches the Users with First name and last name
-- =============================================
CREATE PROCEDURE [prcSearchUsers] 
(
	-- Add the parameters for the stored procedure here
	@OrgID int,
	@Firstname varchar(100), 
	@LastName varchar(100),
	@ScheduleId int
) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

If @Firstname is null
Set @Firstname = ''''

Set @Firstname =rtrim(@firstName)

If @LastName is null
Set @LastName = ''''

Set @LastName =rtrim(@lastName)

	SELECT UserID, 
		CASE u.Active WHEN 1 THEN FirstName WHEN 0 THEN FirstName + ''(I)'' END AS FirstName, 
		LastName, UserName, Email
		FROM tblUser u JOIN tblUserType ut ON u.UserTypeID = ut.UserTypeID
		WHERE FirstName like @Firstname + ''%'' 
		AND LastName like @LastName +''%'' AND OrganisationID=@OrgID
--		AND u.UserTypeID <> 4 
--		AND u.UserID NOT IN (SELECT UserID FROM tblCCList WHERE ScheduleId = @ScheduleId)
END' 
END
GO
