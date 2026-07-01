{{config(materialized='view')}}


SELECT
    c.ssn as client_ssn,
    c.first_name as client_first_name,
    c.last_name as client_last_name,
    c.date_of_birth as client_date_of_birth,
    c.marital_status as client_marital_status,
    c.annual_income_bracket as client_annual_income_bracket,
    c.estimated_net_worth_bracket as client_estimated_net_worth_bracket, 
    c.email_address as client_email_address,
    c.occupation as client_occupation,
    cca.city as client_city, 
    cca.state as client_state,
    cca.zip_code as client_zip_code,
    a.account_number, 
    a.account_status, 
    a.risk_profile, 
    a.investment_objective,
    a.product_name, 
    a.product_category,
    adv.advisor_name, 
    adv.specialization as advisor_specialization
FROM {{ref('cls_client')}} c
INNER JOIN {{ref('cls_client_address')}} cca on c.ssn = cca.ssn
INNER JOIN {{ref('cls_account')}} a ON c.ssn = a.ssn
INNER JOIN {{ref('cls_advisor')}} adv ON a.advisor_code = adv.advisor_code