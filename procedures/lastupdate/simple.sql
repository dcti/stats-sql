/*
** p_lastupdate_ details
** Creates the 8 necessary procedures individually.  All files are defined here.
*/

drop procedure p_lastupdate_e
go
create procedure p_lastupdate_e
	@project_id tinyint = NULL	
as
begin
	if @project_id is NULL or @project_id not in (select PROJECT_ID from Projects)
	begin
		raiserror 99999 "Invalid project specified"
	end

	select max(LAST_DATE) as lastupdate
		from Email_Rank
		where PROJECT_ID = @project_id
end
go
grant execute on p_lastupdate_e to public
go


drop procedure p_lastupdate_t
go
create procedure p_lastupdate_t
	@project_id tinyint = NULL	
as
begin
	if @project_id is NULL or @project_id not in (select PROJECT_ID from Projects)
	begin
		raiserror 99999 "Invalid project specified"
	end

	select max(LAST_DATE) as lastupdate
		from Team_Rank
		where PROJECT_ID = @project_id
end
go
grant execute on p_lastupdate_t to public
go

drop procedure p_lastupdate_m
go
create procedure p_lastupdate_m
	@project_id tinyint = NULL	
as
begin
	declare @mindate datetime
	
	if @project_id is NULL or @project_id not in (select PROJECT_ID from Projects)
	begin
		raiserror 99999 "Invalid project specified"
	end

	select @mindate = dateadd(day, -30, getdate())

	select max(DATE) as lastupdate
		from Email_Contrib
		where PROJECT_ID = @project_id
			and DATE >= @mindate
end
go
grant execute on p_lastupdate_m to public
go

drop procedure p_lastupdate_p
go
create procedure p_lastupdate_p
	@project_id tinyint = NULL	
as
begin
	if @project_id is NULL or @project_id not in (select PROJECT_ID from Projects)
	begin
		raiserror 99999 "Invalid project specified"
	end

	select max(DATE) as lastupdate
		from Platform_Contrib
		where PROJECT_ID = @project_id
end
go
grant execute on p_lastupdate_p to public
go



drop procedure p_lastupdate_rc5_e
go
create procedure p_lastupdate_rc5_e
	@project_id tinyint = NULL	
as
begin
	if @project_id <> 5
	begin
		raiserror 99999 "Invalid project specified"
	end

	select max(last) as lastupdate
		from statproc.rc5_64_CACHE_em_rank
end
go
grant execute on p_lastupdate_rc5_e to public
go


drop procedure p_lastupdate_rc5_t
go
create procedure p_lastupdate_rc5_t
	@project_id tinyint = NULL	
as
begin
	if @project_id <> 5
	begin
		raiserror 99999 "Invalid project specified"
	end

	select max(last) as lastupdate
		from statproc.rc5_64_CACHE_tm_rank
end
go
grant execute on p_lastupdate_rc5_t to public
go

drop procedure p_lastupdate_rc5_m
go
create procedure p_lastupdate_rc5_m
	@project_id tinyint = NULL	
as
begin
	if @project_id <> 5
	begin
		raiserror 99999 "Invalid project specified"
	end

	select max(date) as lastupdate
		from rc5_64_platform
end
go
grant execute on p_lastupdate_rc5_m to public
go

drop procedure p_lastupdate_rc5_p
go
create procedure p_lastupdate_rc5_p
	@project_id tinyint = NULL	
as
begin
	if @project_id <> 5
	begin
		raiserror 99999 "Invalid project specified"
	end

	select max(date) as lastupdate
		from rc5_64_platform
end
go
grant execute on p_lastupdate_rc5_p to public
go
