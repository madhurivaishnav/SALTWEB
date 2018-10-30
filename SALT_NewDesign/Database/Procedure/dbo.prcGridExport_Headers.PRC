SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcGridExport_Headers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcGridExport_Headers]
	@LangInterfaceName NVarChar(4000),
	@CurrentCultureName NVarChar(20)

AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @OrgID int
	Declare @UserID int
	DECLARE @Sort NVarChar(4000)

	DECLARE @SQL NVarChar(4000)
	DECLARE @LangID NVarChar(40)
		SELECT @LangID=LangID FROM tblLang where tblLang.LangCode=  @CurrentCultureName 
		IF @LangID IS NULL 
		BEGIN
			SET @LangID=2
		END

SELECT
(SELECT LangEntryValue
FROM tblLangValue
where LangID=@LangID and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=@LangInterfaceName)
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''C1'') ) as C1,(SELECT LangEntryValue
FROM tblLangValue
where LangID=@LangID and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=@LangInterfaceName)
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''C2'') ) as C2,(SELECT LangEntryValue
FROM tblLangValue
where LangID=@LangID and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=@LangInterfaceName)
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''C3'') ) as C3,(SELECT LangEntryValue
FROM tblLangValue
where LangID=@LangID and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=@LangInterfaceName)
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''C4'') ) as C4,(SELECT LangEntryValue
FROM tblLangValue
where LangID=@LangID and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=@LangInterfaceName)
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''C5'') ) as C5,(SELECT LangEntryValue
FROM tblLangValue
where LangID=@LangID and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=@LangInterfaceName)
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''C6'') ) as C6,(SELECT LangEntryValue
FROM tblLangValue
where LangID=@LangID and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=@LangInterfaceName)
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''C7'') ) as C7,(SELECT LangEntryValue
FROM tblLangValue
where LangID=@LangID and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=@LangInterfaceName)
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''C8'') ) as C8,(SELECT LangEntryValue
FROM tblLangValue
where LangID=@LangID and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=@LangInterfaceName)
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''C9'') ) as C9,(SELECT LangEntryValue
FROM tblLangValue
where LangID=@LangID and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=@LangInterfaceName)
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''C10'') ) as C10,(SELECT LangEntryValue
FROM tblLangValue
where LangID=@LangID and LangInterfaceID=
(SELECT LangInterfaceID
FROM tblLangInterface
where LangInterfaceName=@LangInterfaceName)
and LangResourceID=
(SELECT LangResourceID
FROM tblLangResource
where LangResourceName=''C11'') ) as C11

END
' 
END
GO
