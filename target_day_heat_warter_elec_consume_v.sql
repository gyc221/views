create or replace view target_day_heat_warter_elec_consume_v
as
select 
a.station_id,
a.station_name,
a.parent_station as p_name,
a.pp_name,
a.station_type,
a.parent_id,
a.has_child,
a.year_mon,
a.day,
a.dt,
ifnull(b.heat_consume,func_final_getStationArea(a.station_id,a.dt)*47.6*((18-ifnull(dd.temp,d.temp))/31.1)) as heat_consume,
ifnull(b.warter_consume,e.warter_consume/30.0) as warter_consume,
ifnull(b.elec_consume,e.elec_consume/30.0) as elec_consume
from 
(
select 
t.*,
ym.year_mon,
d.day,
DATE_ADD(ym.year_mon,INTERVAL (d.day-1) DAY) as dt 
from temporary_year_month ym join temporary_day d join 
(
select *,
(select count(*) from temporary_heat_station where parent_id= a1.station_id) as has_child 
from temporary_heat_station a1
) t 
on t.station_type in(1,2)
) a
left join target_day b on a.station_id=b.station_id and a.year_mon=b.year_mon and a.day=b.day
left join pm_weatherdaily d on unix_timestamp(a.dt)=d.ts
left join target_day_temp dd on dd.year_mon=a.year_mon and dd.day=a.day and dd.station_name='银川'
left join target_month_end_station e on a.station_id=e.station_id and a.year_mon=e.year_mon
