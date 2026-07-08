select
    date(start_time) as ride_date,
    count(*) as rides,
    avg(duration_minutes) as avg_duration_minutes,
    count(distinct bike_id) as unique_bikes
from {{ ref('stg_bikeshare_trips') }}
group by ride_date
order by ride_date
