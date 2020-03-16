create or replace view temporary_heat_station
as 
select 
a.ID as station_id,
a.nam as station_name,
(case a.typ when 3 then 0 when 4 then 1 when 6 then 2 else -1 end) as station_type,
a.typ as origin_type,
(case a.pid when 1 then NULL else a.pid end) as parent_id,
(case when ((a.typ=4 and a.isDirect=1) or a.typ=6) then 1 else 0 end) as is_heat_station,
c.nam as parent_station,
(select k.USER_NAME from 
(select a.orgid,b.USER_NAME from  pm_userorginfo a left join user_config_table_final b on a.userId=b.USER_ID where (a.pmRole&1)=1) k
where k.orgid=a.ID limit 1) as director
from basis_org a left join basis_org c on a.pid=c.id
where a.typ in(3,4,6)
