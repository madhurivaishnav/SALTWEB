SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUnit_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*Summary:
Updates a unit details.
Returns:
Nothing.

Called By:
Unit Class.

Calls:
Nothing
Remarks:
Validation:
1. Integrity Violation
The Unit''s details have been updated by another user (since the data are retrieved)

2. Deactivate a Unit
.There are no users in this unit
.There are no active sub-units in this units

3. Activate a Unit
.Parent unit must be active

Exception:
0. Succeed
1. RecordNotFound
4. UniqueViolationException
5. MissingParameterException
6. PermissionDeniedException
7. IntegrityViolationException
10. BusinessServiceException (General)


Author: Jack Liu
Date Created: 10 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

**/
CREATE PROCEDURE [prcUnit_Update]
(
@unitID	int,
@name 	nvarchar(100),
@active	bit,
@updatedByUserID int,
@originalDateUpdated DateTime,
@OrgID int
)
AS

set nocount on

set xact_abort on
Begin Tran

--Validation
Declare @intErrorNumber Integer -- Holds the error number
Declare @strErrorMessage Varchar(200) -- Holds the error message

declare @blnExistingStatus bit
declare @strHierarchy nvarchar(500)
declare @intParentUnitID int
declare @dteDateUpdated datetime


select @blnExistingStatus = active,
@strHierarchy=  Hierarchy +'',%'',
@intParentUnitID = ParentUnitID,
@dteDateUpdated = dbo.udfUTCtoDaylightSavingTime(DateUpdated, @OrgID)
from tblUnit
where UnitID = @unitID

set @intErrorNumber=0
set @strErrorMessage=''''

--1. Integrity Violation
--The Unit''s details have been updated by another user (since the data are retrieved)

if (@dteDateUpdated>@originalDateUpdated)
Begin
Set @intErrorNumber = 7
Set @strErrorMessage = ''The unit''''s details have been updated by another user, you will need to refresh the unit''''s details and re-enter your changes.  <a href="[Url]">Click here</a> to refresh.''
Goto Finalise
End

--2. Deactivate unit
--.There are no users in this unit
--.There are no active sub-units in this units
if (@blnExistingStatus=1 and @active=0)
Begin
if exists(select UserID from tblUser where UnitID=@unitID)
BEGIN
Set @intErrorNumber = 10
set @strErrorMessage = ''You can not deactivate a unit which contains users.  Please move the users to another unit.''
Goto Finalise
end

if exists(select UnitID from tblUnit where hierarchy like @strHierarchy  and active=1)
BEGIN
Set @intErrorNumber = 101
set @strErrorMessage = ''You can not deactivate a unit which contains active sub-units.''
Goto Finalise
end
end

--3. Activate a Unit
--.Parent unit must be active
else if (@blnExistingStatus=0 and @active=1)
Begin
if exists(select UnitID from tblUnit where unitID=@intParentUnitID  and active=0)
BEGIN
Set @intErrorNumber = 102
set @strErrorMessage = ''You cannot activate a unit whose parent unit is inactive.''
Goto Finalise
end
end


if (@intErrorNumber=0)
begin
UPDATE 	tblUnit
SET 	Name		= 	@name,
Active		= 	@active,
UpdatedBy	= 	@updatedByUserID,
DateUpdated	= 	GETUTCDATE()
WHERE 	UnitID = @unitID
end


Finalise:
If(@intErrorNumber > 0)
Begin
Select
@intErrorNumber As ''ErrorNumber'',
@strErrorMessage As ''ErrorMessage''
Rollback Transaction
End
Else
Begin
Select
0 As ''ErrorNumber'',
''Successfully Updated'' As ''ErrorMessage''
Commit Transaction
End


' 
END
GO
