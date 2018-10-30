SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcEmail_Search]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
The procedure will search email sent within the selected date range to a email and contain text in subject or body

Returns:


Called By:
Calls:

Remarks:


Author: Jack Liu
Date Created: 25 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
select * from tblEmail


prcEmail_Search''20040102'',''20040228'','''','''',''''

**/

CREATE  PROCEDURE [dbo].[prcEmail_Search]
(

@dateFrom  datetime,
@dateTo  datetime,
@toEmail nvarchar(50),
@subject nvarchar(50),
@body nvarchar(50),
@organisationID int
)
as
set nocount on

set @dateFrom = dbo.udfDaylightSavingTimeToUTC(@dateFrom, @organisationID)
set @dateTo = dbo.udfDaylightSavingTimeToUTC(DATEADD(day,1,@dateTo), @organisationID)

if @toEmail=''''
set @toEmail=null

if @subject=''''
set @subject=null

if @body=''''
set @body=null


select
emailid,
ToEmail,
subject,
body,
dbo.udfUTCtoDaylightSavingTime(DateCreated, @organisationID) as DateCreated
from tblEmail
where DateCreated between @dateFrom and  @dateTo
and (@toEmail is null  or toEmail =@toEmail)
and (@subject is null  or subject like ''%''+ @subject +''%'')
and (@body is null  or body   like ''%''+ @body +''%'')
and OrganisationID = IsNull(@organisationID,OrganisationID)
order by datecreated desc
' 
END
GO


