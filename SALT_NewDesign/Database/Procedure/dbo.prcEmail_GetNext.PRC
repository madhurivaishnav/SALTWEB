SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcEmail_GetNext]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[prcEmail_GetNext]
AS
BEGIN

select
tblEmailQueue.EmailQueueID
into
#tblEmailsToPurge
FROM tblEmailQueue
inner join tblOrganisation on tblOrganisation.OrganisationID = tblEmailQueue.organisationID
join tblAppConfig on name  = ''SEND_AUTO_EMAILS''
where upper(Value) = ''NO''
or ( tblOrganisation.StopEmails = 1 
     and ( tblEmailQueue.[Subject] like ''%Student Summary%'' 
	       or tblEmailQueue.[Subject] like ''%Course Completion%'' 
           or tblEmailQueue.[Subject] like ''%Overdue Summary%'' 
         )
	)

INSERT INTO tblEmailPurged
([ToEmail]
,[ToName]
,[FromEmail]
,[FromName]
,[CC]
,[BCC]
,[Subject]
,[Body]
,[DateCreated]
,[OrganisationID])

SELECT  case when ((CHARINDEX (''>'',AddressTo) > 0) and (CHARINDEX (''<'',AddressTo) > 0)) then SUBSTRING(AddressTo,CHARINDEX (''<'',AddressTo)+1,CHARINDEX (''>'',AddressTo)-CHARINDEX (''<'',AddressTo)-1) else AddressTo end

,case when ((CHARINDEX (''>'',AddressTo) > 0) and (CHARINDEX (''<'',AddressTo) > 0)) then SUBSTRING(AddressTo,1,CHARINDEX (''<'',AddressTo)-1) else AddressTo end
,case when ((CHARINDEX (''>'',AddressFrom) > 0) and (CHARINDEX (''<'',AddressFrom) > 0)) then SUBSTRING(AddressFrom,CHARINDEX (''<'',AddressFrom)+1,CHARINDEX (''>'',AddressFrom)-CHARINDEX (''<'',AddressFrom)-1) else AddressFrom end
,case when ((CHARINDEX (''>'',AddressFrom) > 0) and (CHARINDEX (''<'',AddressFrom) > 0)) then SUBSTRING(AddressFrom,1,CHARINDEX (''<'',AddressFrom)-1) else AddressFrom end
,''''
,AddressBccs
,Subject
,Body
,QueuedTime
,tblEmailQueue.organisationID
FROM tblEmailQueue 
inner join #tblEmailsToPurge ON tblEmailQueue.EmailQueueID = #tblEmailsToPurge.EmailQueueID

-- do the purge
DELETE FROM tblEmailQueue WHERE EmailQueueID in (SELECT EmailQueueID FROM #tblEmailsToPurge)

DECLARE  @EmailQueueID INT
SELECT @EmailQueueID = MIN (EmailQueueID)
FROM tblEmailQueue
inner join tblOrganisation on tblOrganisation.OrganisationID = tblEmailQueue.organisationID
--join tblAppConfig on name  = ''SEND_AUTO_EMAILS''
--WHERE (tblOrganisation.StopEmails = 0 AND upper(Value) <> ''NO'')  --< already been purged and deleted above!?
--AND 
where ((SendStarted is NULL) OR (DATEADD(DAY,1,SendStarted) < GETUTCDATE()))


-- A single instance will be calling this procedure so there is no need to do multi-user code here
SELECT TOP (1) EmailQueueID,OrganisationID,AddressTo,AddressBCCs,[Subject],body,AddressSender,AddressFrom,IsHTML,CASE WHEN DATEDIFF(d,QueuedTime,GETUTCDATE()) > 1 THEN 1 ELSE 0 END AS Retry
FROM tblEmailQueue  WHERE @EmailQueueID =  EmailQueueID
UPDATE tblEmailQueue SET SendStarted = GETUTCDATE()  WHERE @EmailQueueID =  EmailQueueID

END
' 
END
GO


