drop table jcn_platform_contrib;
drop table jcn_daily_summary;
truncate jcn_s2i;
truncate jcn_s2i_bad;
insert into jcn_s2i select * from jcn_s2i_org;
insert into jcn_s2i_bad select project_id,id,date,team_id,sum(work_units) from jcn_s2i where work_units > 2700000000000 group by project_id,id,date,team_id;
delete from jcn_s2i where work_units > 2700000000000;
select count(*),sum(work_units)-140678728949949, sum(work_units),140678728949949::bigint,(sum(work_units))/140678728949949 from jcn_s2i;

begin;
select platform_contrib.* into jcn_platform_contrib from platform_contrib,(select project_id,date,sum(work_units) as work_units from jcn_s2i_bad group by project_id,date) e where e.project_id=platform_contrib.project_id and platform_contrib.date=e.date and cpu=2 and ((platform_contrib.date>'2001-10-16' and ver=8016) or (platform_contrib.date <='2001-10-16' and ver=8010)) and os=6;
update platform_contrib set work_units=platform_contrib.work_units - e.work_units from (select project_id,date,sum(work_units) as work_units from jcn_s2i_bad group by project_id,date) e where e.project_id=platform_contrib.project_id and platform_contrib.date=e.date and cpu=2 and ((platform_contrib.date>'2001-10-16' and ver=8016) or (platform_contrib.date <='2001-10-16' and ver=8010)) and os=6;

select daily_summary.* into jcn_daily_summary from daily_summary,(select project_id,date,sum(work_units) as work_units from jcn_s2i_bad group by project_id,date) e where e.project_id=daily_summary.project_id and daily_summary.date=e.date;
update daily_summary set work_units = daily_summary.work_units - e.work_units from (select project_id,date,sum(work_units) as work_units from jcn_s2i_bad group by project_id,date) e where e.project_id=daily_summary.project_id and daily_summary.date=e.date;

delete from email_contrib where (project_id, date, id) in (select project_id, date, id from jcn_s2i_bad);
--select (select sum(work_units) from email_contrib where project_id=25) as ec, (select sum(work_units) from platform_contrib where project_id =25) as pc, (select sum(work_units) from daily_summary where project_id=25) as ds;
commit;
