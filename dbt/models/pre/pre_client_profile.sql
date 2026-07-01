{{config(materialized='view')}}


SELECT
    c.ssn AS client_ssn,
    c.first_name AS client_first_name,
    c.last_name AS client_last_name,
    c.date_of_birth AS client_date_of_birth,
    c.marital_status AS client_marital_status,
    c.annual_income_bracket AS client_annual_income_bracket,
    c.estimated_net_worth_bracket AS client_estimated_net_worth_bracket,
    c.email_address AS client_email_address,
    c.occupation AS client_occupation,
    cca.city AS client_city,
    cca.state AS client_state,
    cca.zip_code AS client_zip_code,
    a.account_number,
    a.account_status,
    a.risk_profile,
    a.investment_objective,
    a.product_name,
    a.product_category,
    adv.advisor_name,
    adv.specialization AS advisor_specialization
FROM {{ref('cls_client')}} AS c
INNER JOIN {{ref('cls_client_address')}} AS cca ON c.ssn = cca.ssn
INNER JOIN {{ref('cls_account')}} AS a ON c.ssn = a.ssn
INNER JOIN {{ref('cls_advisor')}} AS adv ON a.advisor_code = adv.advisor_code
