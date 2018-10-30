SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcEmail_QueueMessage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [prcEmail_QueueMessage]
-- Add the parameters for the stored procedure here
@organisationID int,
@AddressTo nvarchar(255),
@Subject nvarchar(255),
@Body nvarchar(max),
@AddressSender nvarchar(255),
@AddressFrom nvarchar(255),
@IsHTML bit,
@AddressBccs nvarchar(max)
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

DECLARE @TEMP datetime
DECLARE @QueuedTime datetime
SET @TEMP = DATEADD(YEAR,1,GETUTCDATE())
SET @QueuedTime = GETUTCDATE()
INSERT INTO tblEmailQueue
([organisationID]
,[AddressTo]
,[Subject]
,[Body]
,[QueuedTime]
,[SendStarted]
,[AddressSender]
,[AddressFrom]
,[IsHTML]
,[AddressBccs])
VALUES
(@organisationID,
@AddressTo,
@Subject,
@Body,
@QueuedTime,
@TEMP,
@AddressSender,
@AddressFrom,
@IsHTML,
@AddressBccs)


SELECT EmailQueueID from tblEmailQueue
WHERE
[organisationID] = @organisationID
AND	[AddressTo] = @AddressTo
AND [Subject]  = @Subject
AND [Body] = @Body
AND [QueuedTime] = @QueuedTime
AND [SendStarted] = @TEMP
AND [AddressSender] = @AddressSender
AND [AddressFrom] = @AddressFrom
AND [IsHTML] = @IsHTML
AND [AddressBccs] = @AddressBccs
END
' 
END
GO
