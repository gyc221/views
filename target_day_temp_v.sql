create or replace view target_day_temp_v
as
select 
a.year_mon,
b.day,
c.station_name,
ifnull(d.temp,p.temp) as temp
from temporary_year_month a join temporary_day b join 
(
select '银川' as station_name
-- union 
-- select '城区' as station_name
-- union
-- select '望远' as station_name
-- union
-- select '永宁' as station_name
-- union
-- select '贺兰' as station_name
) c
left join target_day_temp d 
on c.station_name=d.station_name and a.year_mon=d.year_mon and b.day=d.day
left join pm_weatherdaily p on unix_timestamp(DATE_ADD(a.year_mon,INTERVAL (b.day-1) DAY))=p.ts
