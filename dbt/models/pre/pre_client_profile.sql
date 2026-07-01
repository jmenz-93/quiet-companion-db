WITH latest_client AS (
    SELECT DISTINCT ON (ssn) *
    FROM {{ ref('cls_client') }}
    ORDER BY ssn ASC, effective_date DESC
),

latest_address AS (
    SELECT DISTINCT ON (ssn) *
    FROM {{ ref('cls_client_address') }}
    ORDER BY ssn ASC, effective_date DESC
),

latest_account AS (
    SELECT DISTINCT ON (account_number) *
    FROM {{ ref('cls_account') }}
    ORDER BY account_number ASC, effective_date DESC
)

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
FROM latest_client AS c
LEFT JOIN latest_address AS cca ON c.ssn = cca.ssn
INNER JOIN latest_account AS a ON c.ssn = a.ssn
INNER JOIN {{ ref('cls_products') }} AS p ON a.product_id = p.product_id
LEFT JOIN {{ ref('cls_advisor') }} AS adv ON a.advisor_code = adv.advisor_code
