if object_id('p_lastupdate2') is not NULL
begin
	drop procedure p_lastupdate2
end
go
create procedure p_lastupdate2
(
	@project_id tinyint = NULL
)
as
begin
	declare @lastdate datetime
	
	/* Error checking */
	if @project_id is NULL or @project_id not in (select PROJECT_ID from Projects)
	begin
		raiserror 99999 "Invalid project specified"
	end

	if @project_id = 5
	begin
		select @lastdate = max(date)
			from RC5_64_platform
	end
	else
	begin
		select @lastdate = max(DATE)
			from Email_Contrib
			where PROJECT_ID = @project_id
	end
	
	select @lastdate as lastupdate
end
go
grant execute on p_lastupdate2 to public
go


