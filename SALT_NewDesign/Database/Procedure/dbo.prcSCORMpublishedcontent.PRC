/****** Object:  StoredProcedure [dbo].[prcSCORMpublishedcontent]    Script Date: 12/19/2012 15:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcSCORMpublishedcontent]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE  [prcSCORMpublishedcontent]

AS
BEGIN
SELECT LessonLaunchPoint + ''?QFS='' + QFS as  launchpoint,''"''+CourseName + ''" - '' + ModuleName + '' ''+ CAST(contentID AS varchar(9)) AS title FROM tblSCORMcontent order by contentID DESC
END
' 
END
GO
