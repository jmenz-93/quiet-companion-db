WITH latest_client AS (
    SELECT DISTINCT ON (ssn) *
    FROM {{ ref('cls_client') }}
    ORDER BY ssn, effective_date DESC
),
latest_address AS (
    SELECT DISTINCT ON (ssn) *
    FROM {{ ref('cls_client_address') }}
    ORDER BY ssn, effective_date DESC
)

SELECT
    c.ssn,
    c.first_name,
    c.last_name,
    c.date_of_birth,
    c.marital_status,
    c.annual_income_bracket,
    c.estimated_net_worth_bracket,
    c.occupation,
    a.city,
    a.state,
    acc.account_number,
    acc.account_status,
    acc.risk_profile,
    acc.investment_objective,
    acc.product_id,
    p.product_name,
    p.category,
    adv.advisor_name,
    adv.specialization
FROM latest_client c
LEFT JOIN latest_address a ON c.ssn = a.ssn
JOIN {{ ref('cls_account') }} acc ON c.ssn = acc.ssn
JOIN {{ ref('cls_products') }} p ON acc.product_id = p.product_id
LEFT JOIN {{ ref('cls_advisor') }} adv ON acc.advisor_code = adv.advisor_code