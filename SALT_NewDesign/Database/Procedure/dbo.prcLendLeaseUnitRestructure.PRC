SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcLendLeaseUnitRestructure]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [prcLendLeaseUnitRestructure]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    declare @organisationid int


	set @organisationid = 29

	select
	un.UnitID, un.Name
	into #tblParentUnit
	from
	tblUnit un
	where
	un.OrganisationID=@organisationid
	and ParentUnitID is null
	and un.Active=1


	declare unitCursor cursor
	for 
	select
	pu.UnitID, pu.Name, un2.UnitID, un2.name, un.UnitID, un.name
	from #tblParentUnit pu,
	tblUnit un inner join tblUnit un2
	on un.ParentUnitID=un2.unitid
	where
	un.hierarchy like (convert(varchar(10), pu.unitid) + ''%'') 
	and un.unitid not in
	(
		select distinct parentunitid from tblUnit where organisationid=@organisationid and parentunitid is not null and active=1
	)
	and un.organisationid=@organisationid
	and un.active = 1
	and un.name like ''[A-Z][A-Z][A-Z][0-9][0-9][0-9]''
	--and pu.unitid = 767 -- BLL
	and pu.unitid in
	(1319, 1325, 1357, 1494, 1569)
	
	open unitCursor

	declare @main_unitid int
	declare @main_unitname varchar(200)
	declare @parent_unitid int
	declare @parent_unitname varchar(200)
	declare @child_unitid int
	declare @child_unitname varchar(200)
	declare @default_date datetime


	set @default_date = GETDATE()

	fetch next from unitCursor into 
	@main_unitid,
	@main_unitname,
	@parent_unitid,
	@parent_unitname,
	@child_unitid,
	@child_unitname

	while @@FETCH_STATUS <> -1
	begin
		if @@FETCH_STATUS <> -2
		begin

		declare @new_unitname varchar(200)
		set @new_unitname= @parent_unitname + '' '' + @child_unitname

		print ''Renaming '' + @child_unitname + '' to '' + @new_unitname	
		exec prcUnit_Update @unitid=@child_unitid, @name=@new_unitname, @active = 1, @updatedByUserID=1, @originalDateUpdated = @default_date

		print ''Moving '' + @new_unitname + '' as child unit of '' + @main_unitname
		exec prcUnit_Move @fromUnitID = @child_unitid, @toUnitID = @main_unitid, @adminuserid=1

		print ''Set '' + @parent_unitname + '' to inactive''
		exec prcUnit_Update @unitid=@parent_unitid, @name=@parent_unitname, @active = 0, @updatedByUserID=1, @originalDateUpdated = @default_date

		end
		
		fetch next from unitCursor into 
		@main_unitid,
		@main_unitname,
		@parent_unitid,
		@parent_unitname,
		@child_unitid,
		@child_unitname
	end

	close unitcursor
	deallocate unitcursor

	drop table #tblParentUnit
END
' 
END
GO
