SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcEmail_QueuedMessageAttachments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [prcEmail_QueuedMessageAttachments]

@EmailQueueID bigint,
@ContentID nvarchar(100),
@Content varbinary(max)
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;


INSERT INTO tblEmailQueueLinkedResource
([EmailQueueID]
,[ContentID]
,[ByteStream])
VALUES
(@EmailQueueID
,@ContentID
,@Content)
END
' 
END
GO
