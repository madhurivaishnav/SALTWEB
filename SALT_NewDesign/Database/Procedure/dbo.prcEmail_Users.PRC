SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcEmail_Users]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Returns: result set (active users in the csv list of units)

Author: Mark Donald
Date Created: 04 Aug 2009

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

exec dbo.prcEmail_Users 109, ''4463''
**/

CREATE PROC [prcEmail_Users]
(
@organisationID		int,
@unitIDs 			varchar(MAX)
)
AS
SET NOCOUNT ON

BEGIN
SELECT DISTINCT
u.userid, firstname, lastname, email
FROM
tblUser u, tblunit t
WHERE
u.unitid = t.unitid
AND u.organisationid = @organisationID
AND t.unitid IN (SELECT * FROM dbo.udfCsvToInt(@unitIDs))
AND u.Active = 1
AND t.Active = 1
END

' 
END
GO
