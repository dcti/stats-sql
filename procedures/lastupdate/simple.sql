/*
** p_lastupdate2
** Replacement for p_lastupdate, without all the overhead of multiple procs
** and unnecessary parameters.
** Procedure specifically ignores the differences between when email, team
** and project are last updated, as showing this to the users only serves to
** cause confusion.
*/

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

	/* 
	** When RC5_64 is merged into the main tables, this collapses to just
	** the select statement from the else
	*/
	
	/*
	** We may want to use Projects.LAST_STATS_DATE instead, if we can decide
	** that will always, only represent the last full stats run to complete.
	** If that field represents the upload date, then we should have a new
	** field for this purpose.
	*/
	
	if @project_id = 5
	begin
		select @lastdate = max(date)
			from RC5_64_platform
	end
	else
	begin
		select @lastdate = max(DATE)
			from Platform_Contrib
			where PROJECT_ID = @project_id
	end
	
	/*
	** This is probably a bit of overkill in this scenario, but makes
	** sense in the general case
	*/

	select @lastdate as lastupdate
end
go
grant execute on p_lastupdate2 to public
go


