SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcJobMaintainUnitHierarchies]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [prcJobMaintainUnitHierarchies] AS

if (select count(*) from sysobjects where [name] = ''tblUnitHierarchy'') = 0
BEGIN

CREATE TABLE [dbo].[tblUnitHierarchy] (
[UnitID] [int] NOT NULL ,
[Hierarchy] [nvarchar] (500) COLLATE Latin1_General_CI_AS NULL ,
[HierarchyName] [nvarchar] (2000) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]


CREATE  INDEX [IX_tblUnitHierarchy] ON [dbo].[tblUnitHierarchy]([Hierarchy]) ON [PRIMARY]
END


if (select count(*) from sysobjects where [name] = ''utg_UpdateUnitHierarchy'') = 0
BEGIN

EXEC(''CREATE TRIGGER utg_UpdateUnitHierarchy ON tblUnit AFTER INSERT, UPDATE AS '' +
--Update Existing hierarchies
''UPDATE '' +
''tblUnitHierarchy '' +
''SET '' +
''Hierarchy = B.Hierarchy, '' +
''HierarchyName = dbo.udfGetUnitPathway(B.UnitID) '' +
''FROM '' +
''tblUnitHierarchy A, tblUnit B '' +
''WHERE '' +
''A.UnitID = B.UnitID AND '' +
''B.UnitID IN (Select A.UnitID FROM tblUnit A, INSERTED B WHERE A.Hierarchy LIKE ''''%'''' + CAST(B.UnitID AS VARCHAR(10)) + ''''%'''') '' +
''INSERT INTO '' +
''tblUnitHierarchy '' +
''SELECT '' +
''A.UnitID, A.Hierarchy, dbo.udfGetUnitPathway(A.UnitID) '' +
''FROM '' +
''INSERTED A '' +
''WHERE '' +
''A.UnitID NOT IN (SELECT B.UnitID FROM tblUnitHierarchy B WHERE B.UnitID = A.UnitID)'')
END



if (select count(*) from sysobjects where [name] = ''utg_DeleteUnitHierarchy'') = 0
BEGIN

EXEC(''CREATE TRIGGER utg_DeleteUnitHierarchy ON tblUnit AFTER DELETE AS '' +
''DELETE FROM tblUnitHierarchy '' +
''WHERE UnitID IN (SELECT UnitID FROM Deleted) '')

END

--Dummy to fill tblUnitHierarchy table
UPDATE tblUnit SET Hierarchy = Hierarchy
' 
END
GO
