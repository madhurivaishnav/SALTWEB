SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcEmail_GetAttachments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [prcEmail_GetAttachments]
@EmailQueueID INT
AS
BEGIN
SELECT ContentID,ByteStream FROM tblEmailQueueLinkedResource WHERE EmailQueueID = @EmailQueueID


END
' 
END
GO
