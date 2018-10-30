SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcEmail_LogSentEmail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [prcEmail_LogSentEmail]
@toEmail	nvarchar(1000),
@toName	nvarchar(128),
@fromEmail	nvarchar(128),
@fromName	nvarchar(128),
@CC		nvarchar(1000) = '''',
@BCC 		nvarchar(1000) = '''',
@subject	nvarchar (256),
@body		ntext,
@organisationID	int,
@userID int = 0
As


-- attempt to check if the user exist and find the userid
-- else we just insert 0
-- this is because the service log the email as well and i am unable to find where it can retrieve
-- the userid in a short time
-- hence the workaround
if(@userID=0)
begin

set @userid=coalesce((select top 1 userid from tblUser where organisationid=@organisationid and email=@toemail), 0)

end

Insert Into
tblEmail
(
ToEmail,
ToName,
FromEmail,
FromName,
CC,
BCC,
Subject,
Body,
DateCreated,
OrganisationID,
userID
)

Values
(
@toEmail,
@toName,
@fromEmail,
@fromName,
@CC,
@BCC,
@subject,
@body,
GetUTCDate(),
@organisationID,
@userid
)
' 
END
GO
