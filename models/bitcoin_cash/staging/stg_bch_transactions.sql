with
{{ get_max_date_cte(
    source('crypto_bitcoin_cash', 'transactions'),
    'block_timestamp',
    extra_where="block_timestamp_month >= date_sub(current_date(), interval 420 day)"
) }}

select
    txs.`hash`,
    txs.size,
    txs.virtual_size,
    txs.version,
    txs.block_number,
    txs.block_hash,
    txs.block_timestamp,
    txs.input_count,
    txs.output_count,
    txs.input_value,
    txs.output_value,
    txs.is_coinbase,
    txs.fee
from {{ source('crypto_bitcoin_cash', 'transactions') }} as txs
cross join max_dt
where
    txs.block_timestamp_month >= date_sub(max_dt.max_dt, interval 70 day)
    and date(txs.block_timestamp) between date_sub(max_dt.max_dt, interval 30 day) and max_dt.max_dt
