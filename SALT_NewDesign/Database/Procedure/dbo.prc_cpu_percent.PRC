SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prc_cpu_percent]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prc_cpu_percent]


AS
BEGIN

DECLARE @CPU_percent int

DECLARE @CPU_BUSY int, @IDLE int
SELECT @CPU_BUSY = @@CPU_BUSY, @IDLE = @@IDLE WAITFOR DELAY ''000:00:01''
SET @CPU_percent = (@@CPU_BUSY - @CPU_BUSY)/((@@IDLE - @IDLE + @@CPU_BUSY - @CPU_BUSY) *1.00) *100

SELECT @CPU_percent
RETURN @CPU_percent

END
' 
END
GO
