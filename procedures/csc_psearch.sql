use stats
go
print 'Creating procedure csc_psearch'
go
if object_id('csc_psearch') is not NULL
begin
	drop procedure csc_psearch
end
go
create procedure csc_psearch
	@searchtext varchar(255),
	@maxrows int = 50,
	@escapewildcards bit = 1
as
begin
	set nocount on
	set rowcount 0

	declare @rows int,
		@pos int,
		@pattern varchar(255),
		@nextchar varchar(5)

	if datalength(@searchtext) < 3
	begin
		return -1
	end

	create table #csc_psearch
	(
		id	int
	)

	select	@rows = 0

	if @escapewildcards = 1 and @searchtext like '%[%_]%'
	begin
		select @pos = 1,
			@pattern = NULL

		while @pos <= datalength(@searchtext)
		begin
			select @nextchar = substring(@searchtext, @pos, 1)

			if @nextchar = '%'
			begin
				select @nextchar = '[%]'
			end
			else if @nextchar = '_'
			begin
				select @nextchar = '[_]'
			end

			if @pos = 1
			begin
				select @pattern = @nextchar
			end
			else
			begin
				select @pattern = @pattern + @nextchar
			end
			select @pos = @pos + 1
		end
	end
	else
	begin
		select @pattern = @searchtext
	end

	select @pattern = @pattern + '%'

	if charindex('@', @pattern) > 1
	begin
		insert #csc_psearch (id)
			select id
			from STATS_Participant
			where email like @pattern

		select @rows = @@rowcount
	end

	if @rows = 0
	begin
		select @pattern = '%' + @pattern

		insert #csc_psearch
			select id
			from STATS_Participant
			where email like @pattern

		select @rows = @@rowcount
	end
	
	set rowcount @maxrows
	set nocount off
	select p.id, p.listmode, p.contact_name, p.email, convert(varchar, r.first, 100) as 'first',
			convert(varchar, r.last, 100) as 'last', r.blocks, r.days_working, r.overall_rate,
			r.rank, r.change
                from STATS_Participant p, statproc.CSC_CACHE_em_RANK r, #csc_psearch cp
                where p.id = r.id
                	and p.id = cp.id
                	and r.id = cp.id
			and p.listmode < 10
		order by r.rank, p.email

	set nocount on
	set rowcount 0

	drop table #csc_psearch

        return
end
go
grant exec on csc_psearch to public
go
