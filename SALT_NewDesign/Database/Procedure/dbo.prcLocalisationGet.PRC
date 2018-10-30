SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcLocalisationGet]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcLocalisationGet]
	@LangInterfaceName NVarChar(4000),
	@LangResourceName NVarChar(4000),
	@CurrentCultureName NVarChar(4000)
AS
BEGIN
	DECLARE @LangID VarChar(4)
		SELECT @LangID = LangID FROM tblLang where tblLang.LangCode =   @CurrentCultureName
		IF @LangID IS NULL 
		BEGIN
			SELECT @LangID = LangID FROM tblLang where tblLang.LangCode = ''en_AU''
		END
	DECLARE @LangEntryValue NVarChar(4000)
SELECT @LangEntryValue = LangEntryValue
FROM tblLangValue
where LangID = @LangID and LangInterfaceID = 
	(SELECT LangInterfaceID
	FROM tblLangInterface
	where LangInterfaceName = @LangInterfaceName  )
and LangResourceID = 
	(SELECT LangResourceID
	FROM tblLangResource
	where LangResourceName = @LangResourceName)
	
	IF @LangEntryValue is NULL
	BEGIN
		SET @LangEntryValue = '' ''
		IF  @LangResourceName = ''lblPageTitle''
			BEGIN
				SELECT @LangEntryValue =  [Value]
				FROM tblAppConfig
				WHERE ''AppName''  = Name
			END
	END
	SELECT @LangEntryValue
END
' 
END
GO
