SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcJobGetAgentStatus]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE Procedure [prcJobGetAgentStatus]
@Status Varchar(50) OUTPUT
AS

/******************************************************************************
**		File:
**		Name: prcJobGetAgentStatus
**		Desc:
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
**		Auth:
**		Date:
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		--------		--------				-------------------------------------------
**
*******************************************************************************/


EXEC @Status= master..xp_servicecontrol ''QUERYSTATE'', ''SQLServerAgent''
RETURN



' 
END
GO
