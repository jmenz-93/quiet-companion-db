{{ config(
    materialized='incremental',
    unique_key=['advisor_code', 'raw_created_timestamp']
) }}
SELECT
    CAST(raw_advisor.effective_date AS DATE) AS effective_date,
    raw_advisor.advisor_code,
    raw_advisor.advisor_name,
    raw_advisor.title,
    raw_advisor.credentials,
    raw_advisor.phone_number,
    raw_advisor.specialization,
    raw_advisor.advisor_status,
    raw_advisor.raw_created_timestamp,
    CURRENT_TIMESTAMP AS typ_created_timestamp
FROM {{ source('quiet_companion', 'raw_advisor') }} AS raw_advisor
{% if is_incremental() %}
    WHERE raw_advisor.raw_created_timestamp >= (SELECT MAX(a.raw_created_timestamp) FROM {{ this }} AS a)
{% endif %}
