print 'Creating p_pretire'
go
drop procedure p_pretire
go
create procedure p_pretire
	@id		int,
	@pass		char(8),
	@destid		int
as
begin
	/*
	**	Call using "exec p_pretire $id, '$pass', $destid"
	**	Return data is ReturnValue, RetiresFound, SourceEmail, DestEmail
	*/
	declare @i int,
		@rv int,
		@retires int,
		@srcemail varchar(64),
		@destemail varchar(64),
		@destteam int,
		@realpass char(8)

	set nocount on
	
	select @rv = 0	

	select @i = count(*)
		from STATS_Participant
		where retire_to in (@destid, @id)

	if @i > 10
	begin
		select @rv = 1, @retires = @i
		goto exit_proc
	end

	select @realpass = password,
		@srcemail = email
		from STATS_Participant
		where id = @id

	if @@rowcount = 0
	begin
		select @rv = 2, @retires = @i
		goto exit_proc
	end

	if @realpass <> @pass
	begin
		select @rv = 4, @retires = @i
		goto exit_proc
	end

	select @destemail = email,
		@destteam = team
		from STATS_Participant
		where id = @destid

	if @@rowcount = 0
	begin
		select @rv = 3, @retires = @i
		goto exit_proc
	end

	update STATS_Participant
		set retire_to = @destid,
			team = @destteam,
			retire_date = convert(varchar, getdate(), 112)
		where id = @id

	update STATS_Participant
		set retire_to = @destid,
			team = @destteam
		where retire_to = @id

	select @retires = count(*)
		from STATS_Participant
		where retire_to = @id
			and id <> @id

exit_proc:
	select @rv 'ReturnValue', @retires 'RetiresFound', @srcemail 'SourceEmail', @destemail 'DestEmail'
end
go
grant exec on p_pretire to luser
go

print 'Creating p_pretire_nolimit'
go
drop procedure p_pretire_nolimit
go
create procedure p_pretire_nolimit
	@id		int,
	@destid		int,
	@for_real	bit	= 0
as
begin
	/*
	**	Call using "exec p_pretire $id, $destid"
	**	Return data is ReturnValue, RetiresFound, SourceEmail, DestEmail
	*/

	declare @i int,
		@msg varchar(255),
		@srcemail varchar(64),
		@destemail varchar(64),
		@destteam int

	set nocount on

	select @srcemail = email
		from STATS_Participant
		where id = @id

	select @destemail = email,
		@destteam = team
		from STATS_Participant
		where id = @destid

	if @for_real = 1
	begin
		update STATS_Participant
			set retire_to = @destid,
				team = @destteam,
				retire_date = convert(varchar, getdate(), 112)
			where id = @id	
	
		update STATS_Participant
			set retire_to = @destid,
				team = @destteam
			where retire_to = @id		

		select @i = count(*)
			from STATS_Participant
			where retire_to = @id
				and id <> @id

		select @msg = @destemail + ' now has ' + convert(varchar, @i) + ' addresses retired into it.'
	end
	else
	begin
		select @i = count(*)
			from STATS_Participant
			where @id = retire_to

		select @msg = convert(varchar, @i) + ' (source) records retired into ' + @srcemail
		print @msg
	
		select @i = count(*)
			from STATS_Participant
			where @destid = retire_to
		select @msg = convert(varchar, @i) + ' (dest) records retired into ' + @destemail
		print @msg

		print ' '
		print 'To perform this retire, use this command.'
		select @msg = 'exec p_pretire_nolimit ' + convert(varchar, @id) + ', ' + convert(varchar, @destid) + ', 1'
		print @msg
	end
end
go
print 'Finished.'
