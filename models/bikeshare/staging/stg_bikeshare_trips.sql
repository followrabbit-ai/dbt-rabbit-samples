with
{{ get_max_date_cte(source('austin_bikeshare', 'bikeshare_trips'), 'start_time') }}

select
    trips.trip_id,
    trips.subscriber_type,
    trips.bike_id,
    trips.start_time,
    trips.duration_minutes,
    trips.start_station_id,
    trips.start_station_name,
    trips.end_station_id,
    trips.end_station_name
from {{ source('austin_bikeshare', 'bikeshare_trips') }} as trips
cross join max_dt
where date(trips.start_time) between date_sub(max_dt.max_dt, interval 30 day) and max_dt.max_dt
