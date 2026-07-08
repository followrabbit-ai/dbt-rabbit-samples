with
{{ get_max_date_cte(
    source('crypto_bitcoin_cash', 'transactions'),
    'block_timestamp',
    extra_where="block_timestamp_month >= date_sub(current_date(), interval 420 day)"
) }}

select
    `hash`,
    size,
    virtual_size,
    version,
    block_number,
    block_hash,
    block_timestamp,
    input_count,
    output_count,
    input_value,
    output_value,
    is_coinbase,
    fee
from {{ source('crypto_bitcoin_cash', 'transactions') }}
cross join max_dt
where block_timestamp_month >= date_sub(max_dt.max_dt, interval 70 day)
  and date(block_timestamp) between date_sub(max_dt.max_dt, interval 30 day) and max_dt.max_dt
