{{ config(
    materialized='view'
) }}

-- De-identified client feed for the LLM recommendation step. One row per client.
--
-- This view does NOT decide which products fit — it exposes the client's profile
-- only. The LLM does the matching/recommending against the full pre_products
-- catalog (which carries no PII and can be sent to the model as-is).
--
-- ssn is replaced by client_ref (a stable hash of ssn); the ssn <-> client_ref
-- mapping never leaves the warehouse, so nothing sent to the model can identify a
-- client. held_product_ids lets the model favor net-new products; it is not
-- identifying. (age is exact for ranking accuracy — bucket it into a band here if
-- you want extra distance.)

WITH client_current AS (
    SELECT
        c.ssn,
        c.age,
        c.estimated_net_worth_bracket
    FROM {{ ref('cls_client') }} AS c
    WHERE c.is_current
),

account_rollup AS (
    SELECT
        a.ssn,
        ARRAY_AGG(DISTINCT a.risk_profile) AS client_risk_profiles,
        ARRAY_AGG(DISTINCT a.product_id) AS held_product_ids
    FROM {{ ref('cls_account') }} AS a
    WHERE a.is_current
    GROUP BY a.ssn
),

joined AS (
    SELECT
        cc.ssn,
        cc.age,
        cc.estimated_net_worth_bracket,
        ar.client_risk_profiles,
        ar.held_product_ids
    FROM client_current AS cc
    INNER JOIN account_rollup AS ar ON cc.ssn = ar.ssn
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['ssn']) }} AS client_ref,
    age,
    estimated_net_worth_bracket,
    client_risk_profiles,
    held_product_ids
FROM joined
