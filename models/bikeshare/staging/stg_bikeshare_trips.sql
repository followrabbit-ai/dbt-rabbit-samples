with
{{ get_max_date_cte(source('austin_bikeshare', 'bikeshare_trips'), 'start_time') }}

select
    trip_id,
    subscriber_type,
    bike_id,
    start_time,
    duration_minutes,
    start_station_id,
    start_station_name,
    end_station_id,
    end_station_name
from {{ source('austin_bikeshare', 'bikeshare_trips') }}
cross join max_dt
where date(start_time) between date_sub(max_dt.max_dt, interval 30 day) and max_dt.max_dt
