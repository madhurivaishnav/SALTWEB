SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcAutomatedEmails_MailServerURL]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcAutomatedEmails_MailServerURL]

AS
BEGIN
SELECT Value FROM tblAppConfig WHERE Name = ''MailServer''
END
' 
END
GO
