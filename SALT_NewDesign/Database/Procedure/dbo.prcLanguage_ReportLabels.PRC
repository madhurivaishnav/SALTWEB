SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcLanguage_ReportLabels]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE Procedure [prcLanguage_ReportLabels]
@LangCode varchar(10) = ''en-AU'',
@LangInterfaceName varchar(200) = ''Report.Summary''
As

DECLARE NameValueLOOP CURSOR
FOR
SELECT     tblLangResource.LangResourceName, tblLangValue.LangEntryValue
FROM         tblLang INNER JOIN
tblLangValue ON tblLang.LangID = tblLangValue.LangID INNER JOIN
tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID INNER JOIN
tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID
WHERE     (tblLang.LangCode = @LangCode) AND (tblLangInterface.LangInterfaceName = @LangInterfaceName or tblLangInterface.LangInterfaceName = ''Report.GLOBAL'')
AND (tblLangValue.Active = 1)

Open NameValueLOOP

declare @cursor_Name nvarchar(200)
declare @cursor_Value nvarchar(4000)

FETCH NEXT FROM NameValueLOOP INTO @cursor_Name, @cursor_Value

declare @fieldList as nvarchar(4000)
set @fieldList = ''''

WHILE @@FETCH_STATUS = 0
BEGIN

if @fieldList <> ''''
BEGIN
set @fieldList = @fieldList + '', ''
END

set @fieldList = @fieldList + ''N'''''' + @cursor_Value + '''''' as '' + @cursor_Name
FETCH NEXT FROM NameValueLOOP INTO @cursor_Name, @cursor_Value
END
CLOSE NameValueLOOP
DEALLOCATE NameValueLOOP

declare @createTable as nvarchar(4000)
set @createTable = ''SELECT '' + @fieldList

EXEC(@createTable)


SET QUOTED_IDENTIFIER OFF
' 
END
GO
