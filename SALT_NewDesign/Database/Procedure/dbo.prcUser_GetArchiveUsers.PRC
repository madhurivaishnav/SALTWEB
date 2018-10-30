SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_GetArchiveUsers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Li Zhang
-- Create date: June 2008
-- Description:
-- =============================================
CREATE PROCEDURE [prcUser_GetArchiveUsers]
@fromDate datetime,
@inclNewUsers int,
@orgID int,
@userID int
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

set @fromDate = dbo.udfDaylightSavingTimeToUTC(@fromDate, @orgID)

declare @SelectedUnitIDs table
(unid int)

declare @usertype int
DECLARE @tblTemp table(
LastLogin nvarchar(200),
FirstName nvarchar(200),
LastName nvarchar(200),
Username nvarchar(200),
ExternalID nvarchar(50),
Email nvarchar(100),
UserID int)


-- Get user type
Select @UserType = UserTypeID from tblUser Where UserID = @UserID

-- salt and org admins
IF (@UserType in(1,2))
Begin
insert into @SelectedUnitIDs
select unitID
from
tblUnit Where OrganisationID = @orgID

end

-- unit admin
IF (@UserType = 3)
Begin
insert into @SelectedUnitIDs
select 	u.unitID
from 	tblUnit as u
inner join tblUnitAdministrator as ua
on (u.unitID=ua.unitID)
and (ua.userID = @userID)
where 	(u.organisationID=@orgID)
end


-- get users haven''t login after @fromDate
insert into @tblTemp
select
dbo.udfUTCtoDaylightSavingTime(LastLogin, @orgID), FirstName, LastName, Username, ExternalID,Email, UserID
from
tblUser
join @SelectedUnitIDs on unid = unitid
where
LastLogin < @fromDate
and OrganisationID =  @orgID
and Active = ''true''




if @inclNewUsers = 1
begin
insert into @tblTemp
select
''Never'', FirstName, LastName, Username, ExternalID, Email, UserID
from
tblUser
join @SelectedUnitIDs on unid = unitid
where
LastLogin is null and DateUpdated < @fromDate
and OrganisationID =  @orgID and Active = ''true''
end


select * from @tblTemp

END



SET QUOTED_IDENTIFIER ON
' 
END
GO
