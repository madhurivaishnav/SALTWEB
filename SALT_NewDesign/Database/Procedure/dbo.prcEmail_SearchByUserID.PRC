SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcEmail_SearchByUserID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N' 

CREATE  PROCEDURE [prcEmail_SearchByUserID]
(
@userID int,
@organisationID int
)
as
set nocount on

select
emailid,
ToEmail,
subject,
body,
dbo.udfUTCtoDaylightSavingTime(DateCreated, @organisationID) as DateCreated
from tblEmail
where 
userID = @userID
order by datecreated desc
'
END

GO