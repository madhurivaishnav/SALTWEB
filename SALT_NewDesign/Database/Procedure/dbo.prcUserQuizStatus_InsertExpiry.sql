SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUserQuizStatus_InsertExpiry]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [prcUserQuizStatus_InsertExpiry]
(
	@UserID int
	, @ModuleID int
	,@OrganisationID int
)
AS
	SET nocount ON
	insert tblExpiredNewContent (ModuleID,OrganisationID,UserID)
	values (@ModuleID ,@OrganisationID,@UserID)

' 
END
GO 