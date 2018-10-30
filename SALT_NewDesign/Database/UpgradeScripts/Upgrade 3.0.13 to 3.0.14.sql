

-- [prcBookMark_DeleteBookMarkByUserIDLessonID]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prcBookMark_DeleteBookMarkByUserIDLessonID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prcBookMark_DeleteBookMarkByUserIDLessonID]
GO


-- [prcBookMark_GetBookMark]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prcBookMark_GetBookMark]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prcBookMark_GetBookMark]
GO

