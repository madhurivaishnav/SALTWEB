/****** Object:  StoredProcedure [dbo].[prcSCORMdeleteDME]    Script Date: 12/19/2012 15:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcSCORMdeleteDME]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create proc [prcSCORMdeleteDME](@StudentID int,@LessonID int)
as begin

	delete from tblScormDME where UserID =@StudentID and LessonID = @LessonID

End
' 
END
GO
