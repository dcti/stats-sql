\set procedure=sp__script_table
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
	declare @outputline varchar(255), @work varchar(255)
	declare @colname sysname(30),
		@coltype smallint,
		@collen tinyint,
		@colprec tinyint,
		@colscale tinyint,
		@colstatus tinyint
	declare @typename sysname(30)

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

	SELECT @outputline = 'create table ' + object_name(@objid)
	print @outputline
	print '('

	declare field_cursor cursor
	for
	select name, usertype, length, prec, scale, status
		from syscolumns
		where id = @objid
		order by colid

	open field_cursor
	fetch field_cursor
		into @colname, @coltype, @collen, @colprec, @colscale, @colstatus

	while (@@sqlstatus = 0)
	begin
		select @outputline = char(9) + @colname + replicate(char(9), (31 - datalength(@colname)) / 8)

		select @work = name
			from systypes
			where usertype = @coltype

		if @coltype in (1, 2, 3, 4)
		begin
			select @work = @work + '(' + convert(varchar, @collen) + ')'
		end

		if @coltype in (10, 24)
		begin
			select @work = @work + '(' + convert(varchar, @colprec) + ','
					+ convert(varchar, @colscale) + ')'
		end

		select @outputline = @outputline + @work + replicate(char(9), (23 - datalength(@work)) / 8)

		if (@colstatus & 0x08) = 0x08
		begin
			select @outputline = @outputline + 'NULL'
		end
		else
		begin
			if (@colstatus & 0x80) = 0x80
			begin
				select @outputline = @outputline + 'identity'
			end
			else
			begin
				select @outputline = @outputline + 'not NULL'
			end
		end

		fetch field_cursor
			into @colname, @coltype, @collen, @colprec, @colscale, @colstatus
		if (@@sqlstatus = 0)
		begin
			select @outputline = @outputline + ','
		end

		print @outputline
	end
	close field_cursor
	deallocate cursor field_cursor

	print ')'
end
go

grant execute on $procedure to wheel
go

grant execute on $procedure to backup
go
