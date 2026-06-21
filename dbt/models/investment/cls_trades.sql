{{config(
    materialized='incremental',
    incremental_strategy = 'merge',
    unique_key=['trade_id', 'effective_date'],
    on_schema_change='sync_all_columns'
)}}

SELECT
    trades.effective_date,
    trades.trade_id,
    trades.account_number,
    trades.ssn,
    trades.advisor_code,
    trades.trade_date,
    trades.settlement_date,
    trades.ticker,
    trades.action,
    trades.quantity,
    trades.price,
    trades.commission,
    trades.net_amount,
    trades.cash_flow_direction,
    trades.currency,
    trades.order_type,
    trades.raw_created_timestamp,
    trades.typ_created_timestamp
FROM {{ref('typ_trades')}} AS trades
WHERE
    trades.trade_id IS NOT NULL
    {% if is_incremental() %}
        AND trades.typ_created_timestamp > (SELECT max(t2.typ_created_timestamp) FROM {{ this }} AS t2)
    {% endif %}
