SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcGetSet_MailFlag]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create  Procedure [prcGetSet_MailFlag]
(
@OrganisationID int,
@getSet int,
@UserID int
)

As
begin 
	if (@getSet =1)
	begin
		update tblOrganisation set StopEmails = case when StopEmails = 0 then 1 else 0 end, 
			DateUpdated = GETDATE(), UpdatedBy = @UserID 
		where OrganisationID = @OrganisationID
	end
	
	select stopemails from tblOrganisation where organisationID = @OrganisationID
end
' 
END
GO
