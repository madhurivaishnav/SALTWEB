SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcEmail_RemoveMessage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [prcEmail_RemoveMessage]

@EmailQueueID int

AS
BEGIN

DELETE FROM tblEmailQueue WHERE EmailQueueID = @EmailQueueID
DELETE FROM tblEmailQueueLinkedResource WHERE EmailQueueID = @EmailQueueID
END
' 
END
GO
