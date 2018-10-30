-- **** FIX LANGUAGE HEADER ****
			
	-- FIX SIMPLIFIED LANGUAGE CODE
		UPDATE tblLang set LangCode = 'zh-CHS' WHERE LangCode = 'zh-hans'
		UPDATE tblLangResource set LangResourceName = 'zh-CHS' WHERE LangResourceName = 'zh-hans'
		
	-- FIX TRADITIONAL LANGUAGE CODE
		declare @langID int
		declare @langInterfaceID int
		declare @langResourceID int

		SELECT @langID = LangID from tblLang WHERE LangCode = 'zh-CHT'
		if NOT(@langID IS NULL)
		BEGIN
			SELECT @langInterfaceID = LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = 'LanguageNames'
			SELECT @langResourceID = LangResourceID FROM tblLangResource WHERE LangResourceName = 'zh-CHT'
			
			UPDATE tblLang set LangCode = 'zh-CHT' WHERE LangCode = 'zh-hant'
			UPDATE tblLangResource set LangResourceName = 'zh-CHT' WHERE LangResourceName = 'zh-hant'

			IF NOT EXISTS( SELECT LangEntryValue from tblLangValue WHERE LangID = @langID AND LangInterfaceID = @langInterfaceID AND LangResourceID = @langResourceID )
				BEGIN
					INSERT INTO [dbo].[tblLangValue] ([LangID],[LangInterfaceID],[LangResourceID],[LangEntryValue],[Active],[UserCreated],[UserModified],[DateCreated],[DateModified],[RecordLock])
						VALUES (@langID
								,@langInterfaceID
								,@langResourceID
								,'zh-CHT'
								,1,1,1,getdate(),getdate(),newid())
				END
		END

-- /**** FIX LANGUAGE HEADER ****
