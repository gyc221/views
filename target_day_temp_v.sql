create or replace view target_day_temp_v
as
select 
a.year_mon,
b.day,
c.station_id,
c.station_name,
d.temp 
from temporary_year_month a join temporary_day b join 
(select station_id,station_name from temporary_heat_station where origin_type=3) c
left join target_day_temp d 
on c.station_id=d.station_id and a.year_mon=d.year_mon and b.day=d.day
