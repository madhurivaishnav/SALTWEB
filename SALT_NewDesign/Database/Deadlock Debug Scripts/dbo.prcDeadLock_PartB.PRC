SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prcDeadLock_PartB]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prcDeadLock_PartB]
GO





CREATE     PROCEDURE [dbo].[prcDeadLock_PartB]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @err int; 
    -- Insert statements for procedure here
	Begin Transaction tranB
	--set deadlock_priority low

	Print 'Process B is Updating Table B...'
	--Test Locking with PartA
	Update tblDeadLockPartB Set Text = 'Updated by Process B'
--Test locking with prcQuizSession_EndQuiz:
--	update tblQuizSession Set QuizPassMark=82
	Print 'Process B Updated Table B.'
	
	Print 'Process B is waiting...'
	WAITFOR DELAY '00:00:10';
	Print 'Process B waited.'
		
	Print 'Process B is Updating Table A...'
	Update tblDeadLockPartA Set Text = 'Updated by Process A'

	Print 'Process B Updated Table A.'
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

