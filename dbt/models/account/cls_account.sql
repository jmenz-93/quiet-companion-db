{{config(
    materialized='incremental',
    incremental_strategy = 'merge',
    unique_key=['account_number', 'effective_date'],
    on_schema_change='sync_all_columns'
)}}

SELECT
    t.effective_date,
    t.account_number,
    t.ssn,
    t.product_id,
    t.account_status,
    t.date_opened,
    t.date_closed,
    t.last_review_date,
    t.custodian,
    t.advisor_code,
    t.investment_objective,
    t.risk_profile,
    t.time_horizon,
    t.tax_status,
    t.rebalance_frequency,
    t.annual_contribution,
    t.management_fee,
    t.margin_enabled,
    t.options_approved,
    t.beneficiary_designated,
    t.esg_preference,
    t.raw_created_timestamp,
    t.typ_created_timestamp
FROM {{ref('typ_account')}} AS t
{% if is_incremental() %}
    WHERE t.typ_created_timestamp > (SELECT max(t2.typ_created_timestamp) FROM {{ this }} AS t2)
{% endif %}
