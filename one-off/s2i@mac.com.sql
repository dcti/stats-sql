truncate jcn_s2i;
insert into jcn_s2i select * from jcn_s2i_org;
delete from jcn_s2i where work_units > 2700000000000;
select count(*),sum(work_units)-140678728949949, sum(work_units),140678728949949::bigint,(sum(work_units))/140678728949949 from jcn_s2i;
