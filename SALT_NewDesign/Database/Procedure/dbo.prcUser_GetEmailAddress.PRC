SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_GetEmailAddress]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:
Gets a list of email addresses when passed a csv list of userid''s

Parameters:
@userIDs (mandatory)

Returns:
1, James@home.com
23, Bob@home.com.au
97, Harry@home.com

order by userID, Email

Called By:
Report.cs

Calls:
udfCsvToInt

Remarks:



Author:Peter Kneale
Date Created: 27 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1



--------------------

**/


CREATE Proc [prcUser_GetEmailAddress]
(
@userIDs varchar(8000)		-- CSV list of user IDs that email addresses of are needed
)

As

Select
FirstName,
LastName,
UserID,
Email
From
tblUser
Where
userID in
(
Select
*
From
udfCsvToInt (@userIDs) 	-- Convert csv list of user id''s into rows
)
and active = 1
' 
END
GO
