SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUnit_MoveToTopLevel]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
Move a unit to top level.
Returns:
Nothing.

Called By:
Unit Class.

Calls:
Nothing
Remarks:


Exception:
0: Succeed
1.RecordNotFound
2.FK constraint
3.PKViolationException
4.UniqueViolationException
10.BusinessServiceException (General)


Author: Jack Liu
Date Created: 11 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

**/
CREATE PROCEDURE [prcUnit_MoveToTopLevel]
(
@fromUnitID	int,
@adminUserID 	int
)

AS

set nocount on

set xact_abort on
Begin Tran
declare @strErrorMessage varchar(500)
declare @intErrorNumber int

declare @intUserTypeID int

declare @intFromOrganisationID int
declare @strFromHierarchy nvarchar(500)
declare @intFromParentUnitID int

select @intUserTypeID = UserTypeID
from tblUser
where userID = @adminUserID

select @intFromOrganisationID = OrganisationID,
@strFromHierarchy = Hierarchy,
@intFromParentUnitID = parentUnitID
from tblUnit
where unitID=@fromUnitID


set @strErrorMessage=''''

-------------- 1. Permission Checking ----------------
--Only Salt Administrator (1), Organisation Administrator (2) can move a unit to top level
If (@intUserTypeID>2)
begin
set @strErrorMessage = ''You do not have permission to move a unit to the top level.''
set @intErrorNumber = 1
end

-----------------2. Validation -----------------------------
if (@strErrorMessage='''')
begin
--	2.1. "From" unit is in top level
if (@intFromParentUnitID is null)
begin
set @strErrorMessage = ''The ''''From'''' unit already exists at the top level.''
set @intErrorNumber = 11
end
end

if (@strErrorMessage='''')
begin
--1. Update hierarchy and rebuild the unit tree
Update tblUnit
set parentUnitID=null,
UpdatedBy = @adminUserID,
DateUpdated = getutcdate()
where unitID=@fromUnitID

--rebuild the unit tree
exec prcOrganisation_CheckUnitTree @intFromOrganisationID

--2. Keep the exsiting administrators
select 0 as Error, '''' as ErrorMessage
end
else
begin
select @intErrorNumber as Error,  @strErrorMessage as ErrorMessage
end

commit TRAN
' 
END
GO
