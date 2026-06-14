{{config(
    materialized='incremental',
    incremental_strategy = 'merge',
    unique_key=['ssn', 'effective_date'],
    on_schema_change='sync_all_columns'
)}}

SELECT
    t.effective_date,
    t.ssn,
    t.first_name,
    t.last_name,
    t.date_of_birth,
    t.marital_status,
    t.number_of_dependents,
    t.email_address,
    t.phone_number,
    t.citizenship_status,
    t.employment_status,
    t.occupation,
    t.employer_name,
    t.annual_income_bracket,
    t.estimated_net_worth_bracket,
    t.education_level,
    t.politically_exposed_person,
    t.finra_association,
    t.aml_flag,
    t.preferred_contact_method,
    t.raw_created_timestamp,
    t.typ_created_timestamp
FROM {{ref('typ_client')}} AS t
{% if is_incremental() %}
    WHERE t.typ_created_timestamp > (SELECT max(t2.typ_created_timestamp) FROM {{ this }} AS t2)
{% endif %}
