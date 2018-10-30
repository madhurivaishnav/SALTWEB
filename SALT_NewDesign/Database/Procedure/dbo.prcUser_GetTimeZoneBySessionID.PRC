SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_GetTimeZoneBySessionID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE Procedure [prcUser_GetTimeZoneBySessionID]
(
@SessionID varchar(50) 		-- Session ID of the user we are looking for.
)

As

Set NoCount On

-- Declarations
Declare @userID Integer

-- Validation
If (@SessionID Is Null)
Begin
Raiserror(''The Parameter @SessionID was null.  @SessionID does not accept Null values.'', 16, 1)
Return
End

-- Logic
Set @userID= dbo.udfGetUserIDBySessionID(@SessionID)


Select
coalesce(USR.TimeZoneID,ORG.TimeZoneID) as TimeZone
From
tblOrganisation ORG
inner join tblUser USR on ORG.OrganisationID = USR.OrganisationID
inner join tblLessonSession LS on LS.UserID = USR.UserID
WHERE LessonSessionID = ltrim(rtrim(@sessionID))



Select
@UserID as ''UserID''


' 
END
GO
