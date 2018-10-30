SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcEmail_Purge]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [prcEmail_Purge] as

begin

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

	SELECT  
		case when ((CHARINDEX (''>'',AddressTo) > 0) and (CHARINDEX (''<'',AddressTo) > 0)) then SUBSTRING(AddressTo,CHARINDEX (''<'',AddressTo)+1,CHARINDEX (''>'',AddressTo)-CHARINDEX (''<'',AddressTo)-1) else AddressTo end
		,case when ((CHARINDEX (''>'',AddressTo) > 0) and (CHARINDEX (''<'',AddressTo) > 0)) then SUBSTRING(AddressTo,1,CHARINDEX (''<'',AddressTo)-1) else AddressTo end
		,case when ((CHARINDEX (''>'',AddressFrom) > 0) and (CHARINDEX (''<'',AddressFrom) > 0)) then SUBSTRING(AddressFrom,CHARINDEX (''<'',AddressFrom)+1,CHARINDEX (''>'',AddressFrom)-CHARINDEX (''<'',AddressFrom)-1) else AddressFrom end
		,case when ((CHARINDEX (''>'',AddressFrom) > 0) and (CHARINDEX (''<'',AddressFrom) > 0)) then SUBSTRING(AddressFrom,1,CHARINDEX (''<'',AddressFrom)-1) else AddressFrom end
		,''''
		,AddressBccs
		,Subject
		,Body
		,QueuedTime
		,tblEmailQueue.organisationID
	FROM 
		tblEmailQueue 
		
	DELETE FROM tblEmailQueue 
	
	
end

' 
END
GO
