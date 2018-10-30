SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPolicy_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*Summary:
Updates a Policy.

Parameters:
@PolicyID int,
@OrganisationID int,
@PolicyName nvarchar(255),
@Active bit,
@Deleted bit,
@PolicyFileName nvarchar(255),
@PolicyFileSize bigint,
@UploadDate datetime


Returns:
Nothing

Called By:
Policy.cs.

Calls:
Nothing

Remarks:
None

Author: Aaron Cripps
Date Created: June 2008

Modification History
-----------------------------------------------------------
v#	Author		Date			Description

**/

CREATE procedure [prcPolicy_Update]
(
@PolicyID int,
@OrganisationID int,
@PolicyName nvarchar(255),
@Active bit,
@Deleted bit,
@PolicyFileName nvarchar(255),
@PolicyFileSize bigint,
@UploadDate datetime,
@ConfirmationMessage nvarchar(500)
)
as

declare @SQL nvarchar(1000)
declare @SQLL nvarchar(1000)
declare @SQLR nvarchar(1000)
declare @Index int

set @PolicyName = replace(@PolicyName, '''''''', '''''''''''')
set @ConfirmationMessage = replace(@ConfirmationMessage, '''''''', '''''''''''')

set @SQL = ''update tblPolicy''
set @SQL = @SQL + '' set''
if @OrganisationID is not null
begin
set @SQL = @SQL + '' OrganisationID = '' + cast(@OrganisationID as nvarchar) + '',''
end
if @PolicyName is not null
begin
set @SQL = @SQL + '' PolicyName = '''''' + @PolicyName + '''''',''
end
if @Active is not null
begin
set @SQL = @SQL + '' Active = '' + cast(@Active as char(1)) + '', ''
end
if @Deleted is not null
begin
set @SQL = @SQL + '' Deleted = '' + cast(@Deleted as char(1)) + '', ''
end
if @PolicyFileName is not null
begin
set @SQL = @SQL + '' PolicyFileName = '''''' + @PolicyFileName + '''''',''
end
if @PolicyFileSize is not null
begin
set @SQL = @SQL + '' PolicyFileSize = '' + cast(@PolicyFileSize as nvarchar) + '',''
end
if @UploadDate is not null
begin
set @SQL = @SQL + '' UploadDate = getUTCDate() ,''
end
if @ConfirmationMessage is not null
begin
set @SQL = @SQL + '' ConfirmationMessage = '''''' + @ConfirmationMessage + '''''',''
end
set @SQL = @SQL + '' where PolicyID ='' + cast(@PolicyID as nvarchar)

-- this removes last '','' character from @SQL
set @SQL = reverse(@SQL)
set @index = charindex('','', @SQL)
if @index > 0
begin
set @SQLL = left(@SQL, @index-1)
set @SQLR = right(@SQL, len(@SQL) - (@index))
set @SQL = @SQLL + @SQLR
end
set @SQL = reverse(@SQL)

exec (@SQL)
' 
END
GO
