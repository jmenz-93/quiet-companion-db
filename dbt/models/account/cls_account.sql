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
    p.product_name,
    p.tax_status,
    t.account_status,
    t.date_opened,
    t.date_closed,
    t.last_review_date,
    t.custodian,
    t.advisor_code,
    t.investment_objective,
    t.risk_profile,
    t.time_horizon,
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
LEFT JOIN {{ref("cls_products")}} AS p
    ON t.product_id = p.product_id
WHERE
    p.product_id IS NOT NULL
    {% if is_incremental() %}
        AND t.typ_created_timestamp > (SELECT max(t2.typ_created_timestamp) FROM {{ this }} AS t2)
    {% endif %}
