{{config(
    materialized='incremental',
    incremental_strategy = 'merge',
    unique_key=['ssn', 'effective_date'],
    on_schema_change='sync_all_columns'
)}}

WITH ranked AS (
    SELECT
        t.effective_date,
        t.ssn,
        t.address_line_1,
        t.address_line_2,
        t.city,
        t.state,
        t.zip_code,
        t.county,
        t.country,
        t.address_type,
        t.residency_status,
        t.years_at_current_address,
        t.raw_created_timestamp,
        t.typ_created_timestamp,
        ROW_NUMBER() OVER (PARTITION BY t.ssn, t.effective_date ORDER BY t.raw_created_timestamp DESC) AS row_num
    FROM {{ref('typ_client_address')}} AS t
    {% if is_incremental() %}
        WHERE t.effective_date >= (SELECT max(t2.effective_date) FROM {{ this }} AS t2)
    {% endif %}
)

SELECT
    effective_date,
    ssn,
    address_line_1,
    address_line_2,
    city,
    state,
    zip_code,
    county,
    country,
    address_type,
    residency_status,
    years_at_current_address,
    raw_created_timestamp,
    typ_created_timestamp
FROM ranked
WHERE row_num = 1