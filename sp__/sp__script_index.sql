\set procedure=sp__script_indexes
use stats
go

print "Creating procedure $procedure"
go
if object_id("$procedure") is not NULL
begin
	drop procedure $procedure
end
go
create procedure $procedure
(
	@objname varchar(60)
)
as
begin
	set nocount on

	declare @msg varchar(250)
	declare @objid int
	declare @indid int,
		@indname varchar(30),
		@indstatus smallint,
		@maxrows smallint

	select @objid = object_id(@objname)
	if @objid is null
	begin
		raiserror 99999 "Object '%1!' does not exist!", @objname
		return
	end

	if @objname like "%.%.%" and
		substring(@objname, 1, charindex(".", @objname) - 1) != db_name()
	begin
		/* 17460, "Object must be in the current database." */
		exec sp_getmessage 17460, @msg out
		print @msg
		return  (1)
	end

	declare index_cursor cursor
	for
	SELECT indid, name, status, maxrowsperpage
		FROM sysindexes
		WHERE id = @objid
			and indid > 0
			and indid < 255
		ORDER BY indid

	open index_cursor
	fetch index_cursor
		into @indid, @indname, @indstatus, @maxrows

	while (@@sqlstatus = 0)
	begin
		declare @i int, @out varchar(255)
		declare @colname varchar(30), @with varchar(255)

		select @out = 'create '

		-- Unique?
		if @indstatus & 2 = 2
		begin
			select @out = @out + 'unique '
		end

		-- Clustered index?
		if @indid = 1
		begin
			select @out = @out + 'clustered '
		end

		select @out = @out + 'index on ' + object_name(@objid) + ' ('
		print @out

		select @i = 1
		while @i <= 16
		begin
			select @colname = index_col(@objname, @indid, @i)
			if @colname is null
			begin
				goto lastcol
			end

			if @i > 1
			begin
				select @colname = ", "
			end
			else
			begin
				select @colname = ""
			end
			
			select @colname = @colname + index_col(@objname, @indid, @i)
			print @colname

			select @i = @i + 1
		end

		lastcol:
		if @maxrows != 0
		begin
			select @with = @with + ' max_rows_per_page = '
					+ rtrim(convert(varchar(5), @maxrows))
		end

		if @indstatus & 1 = 1
		begin
			select @with = @with + ' ignore_dup_key'
		end

		if @indstatus & 4 = 4
		begin
			select @with = @with + ' ignore_dup_row'
		end

		if @indstatus & 64 = 64
		begin
			select @with = @with + ' allow_dup_row'
		end

		if @indstatus & 512 = 512
		begin
			select @with = @with + ' sorted_data'
		end

		if @with = 'with'
		begin
			select @with = ''
		end


		select @out = ')' + @with + " on " + s.name
		from syssegments s, sysindexes i
			where s.segment = i.segment
				and i.id = object_id(@objname)
				and i.indid = @indid

		print @out
		print "go"
		print ""

		fetch index_cursor
			into @indid, @indname, @indstatus, @maxrows

	end
	close index_cursor
	deallocate cursor index_cursor
end
go

grant execute on $procedure to wheel
go

grant execute on $procedure to backup
go
