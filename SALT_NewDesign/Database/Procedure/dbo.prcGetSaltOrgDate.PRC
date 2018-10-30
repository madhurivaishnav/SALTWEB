SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcGetSaltOrgDate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [prcGetSaltOrgDate]
(
@OrgID int

)

AS

begin


SELECT  convert( varchar(17), dbo.udfUTCtoDaylightSavingTime(GETUTCDATE(),@OrgID),113) as PrintDate

end








' 
END
GO
