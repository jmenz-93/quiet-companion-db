{{config(
    materialized='incremental',
    incremental_strategy = 'merge',
    unique_key=['advisor_code', 'effective_date'],
    on_schema_change='sync_all_columns'
)}}

SELECT
    t.effective_date,
    t.advisor_code,
    t.advisor_name,
    t.title,
    t.credentials,
    t.phone_number,
    t.specialization,
    t.advisor_status,
    t.raw_created_timestamp,
    t.typ_created_timestamp
FROM {{ref('typ_advisor')}} AS t
{% if is_incremental() %}
    WHERE t.typ_created_timestamp > (SELECT max(t2.typ_created_timestamp) FROM {{ this }} AS t2)
{% endif %}
