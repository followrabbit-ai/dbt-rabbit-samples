select
    date(block_timestamp) as tx_date,
    count(*) as tx_count,
    sum(input_value) as total_input_value,
    sum(output_value) as total_output_value,
    avg(output_count) as avg_output_count,
    countif(is_coinbase) as coinbase_tx_count
from {{ ref('stg_bch_transactions') }}
group by tx_date
order by tx_date
