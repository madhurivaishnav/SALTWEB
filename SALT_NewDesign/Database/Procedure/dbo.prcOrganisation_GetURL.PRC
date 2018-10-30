SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisation_GetURL]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [prcOrganisation_GetURL] @organisationID int

as 
begin
	
	declare @orgurl varchar(500)
	
	SELECT @orgurl =CASE WHEN ''true'' = [Value] THEN ''HTTPS://'' ELSE ''http://'' END FROM tblAppConfig where Name = ''SSL'' 
	SELECT organisationname, ORGURL =@orgurl + COALESCE(DOMAINNAME,''localhost'')  + ''/Restricted/Login.aspx'' FROM tblOrganisation ORG WHERE ORG.OrganisationID =  @OrganisationID
	
	

END
' 
END
GO
