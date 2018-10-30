SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_UsernameSearch]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*Summary:
The procedure will search within the selected Parent Units for those Users whose name contains the entered first and last names.
(If no Parent Units have been selected, the system will search across the whole organisation.)

Returns:
Unit Name
Full pathway

Called By:
Calls:

Remarks:
The searching units will include all children and grandchildren
Only return users that logged on user has permission to see


Author: Gavin Buddis
Date Created: 2 Mar 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	Li Zhang	4/4/2006		Added search on username function
#2	VDL			26 Sep 2008		Add Search on email field / add boolean logic for include inactive users


**/

CREATE  Procedure  [prcUser_UsernameSearch]
(
@organisationID  Int,
@parentUnitIDs  Varchar(500),
@firstName	nVarchar(100),
@lastName	nVarchar(100),
@userName   nVarchar(200),
@userEmail	nvarchar(300),
@userID		int = 0,
@adminUserID		Int,
@includeInactiveUsers bit
)
As
Set Nocount On

Declare @intUserTypeID Int

Select @intUserTypeID = UserTypeID
From tblUser
Where userID = @adminUserID

--Check Data
If @parentUnitIDs is null
set @parentUnitIDs =''''

If @firstName is null
Set @firstName = ''''

Set @firstName =rtrim(@firstName)

If @lastName is null
Set @lastName = ''''

Set @lastName =rtrim(@lastName)

If @userName is null
Set @userName = ''''

Set @userName = rtrim(@userName)

if @userEmail is null
Set @userEmail =''''

Select
us.UserID,
us.UserName,
us.FirstName,
case
When us.Active = 0 then us.LastName + ''(I)''
Else us.LastName
end as LastName,
case
When us.LastLogin Is Null then ''Never''
Else cast(dbo.udfUTCtoDaylightSavingTime(us.LastLogin,@OrganisationID) as varchar)
end as LastLogin,
dbo.udfGetUnitPathway(us.UnitID) as Pathway,
us.Active

From tbluser us
join tblunit un on us.unitid = un.unitid

Where (us.OrganisationID = @organisationID)
and
(
us.Active= case when @includeInactiveUsers=0 then 1 else us.active end
)
--1. Within the selected Parent Units (can select multiple units)
--The unit hierarchy contains the parent Unit ID
and (
un.UnitID in
(
Select IntValue from dbo.udfCsvToInt(@parentUnitIDs)
)
or (@parentUnitIDs='''')
)
--2. User firstname contains the entered text
and (
(us.firstname like ''%''+ @firstName + ''%'')
or (us.firstname ='''')
)
--3. User lastname contains the entered text
and (
(us.lastname like ''%''+ @lastName + ''%'')
or (us.lastname ='''')
)
--4. User username contains the entered text
and (
(us.UserName like ''%'' + @userName + ''%'')
or (us.UserName ='''')
)
--4.5 User Email Address is the entered text
and (
(us.email like ''%'' + @userEmail + ''%'')
or (@useremail ='''')
)
--5. Permission
--Salt Administrator(1), Organisation Administrator(2) has permission to access all units
--Unit Administrator(3) only has permission to those that he is administrator
and (
(@intUserTypeID<3)
or (un.UnitID in (select UnitID from tblUnitAdministrator where UserID=@adminUserID))
)
-- 6. User ID
and (
(@userid != 0 and us.userid = @userid ) or (@userid = 0 and us.userid > 0)
)


Order By Name' 
END
GO
