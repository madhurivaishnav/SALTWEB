SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUSER_ArchiveUsers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/******************************************************************************
**		File:
**		Name: Stored_Procedure_Name
**		Desc: Uses user defined function to return full unit path
**
**		This template can be customized:
**
**		Return values:
**
**		Called by:
**
**		Parameters:
**		Input							Output
**     ----------							-----------
**
**		Auth: Li Zhang
**		Date: July 2008
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		--------		--------				-------------------------------------------
**
*******************************************************************************/
CREATE PROCEDURE [prcUSER_ArchiveUsers]
(@userIDs varchar(1000),
@updatedBy int)
AS

UPDATE tblUser set Active = ''False'', DateArchived = getutcdate(), updatedBy = @updatedBy,
DateUpdated = getutcdate() WHERE UserID in ( SELECT * FROM dbo.udfCsvToInt(@userIDs))
' 
END
GO
