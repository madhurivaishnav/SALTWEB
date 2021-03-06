SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prcDeadLock_User]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prcDeadLock_User]
GO






CREATE      PROCEDURE [dbo].[prcDeadLock_User]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @err int; 
    -- Insert statements for procedure here
	Begin Transaction tranB
	--set deadlock_priority low

	Print 'Process B is Updating Table A...'
	-- Test locking with prcUser_Update
	Update tblUser Set UnitID = 1 Where UserID = 1

	Print 'Process B Updated  tblUser'
	
	Print 'Process B is waiting...'
	WAITFOR DELAY '00:00:10';
	Print 'Process B waited.'

	Print 'Process B is Updating Table B...'
	Update tblDeadLockPartB Set Text = 'Updated by Process B'
	Print 'Process B Updated Table B.'
		
	Print 'Process B is committing...'
	declare @intError int
	set @intError = @@Error
	if (@intError =0)
		Begin
			Commit 
			Print 'Process B is Commited.'
		End
	Else
		Begin
			Rollback
			Print 'Process B is Rolled Back.'
		End
	
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

