SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_GetUnitIDByUserID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcUser_GetUnitIDByUserID]
@UserID int
AS

SELECT
UnitID
FROM
tblUser
WHERE
UserID = @UserID
' 
END
GO
