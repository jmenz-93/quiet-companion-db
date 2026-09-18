-- Recommendation-ready product catalog.
-- Parses the human-readable eligibility fields in cls_products into structured
-- match keys, and carries the descriptive text used to explain a recommendation
-- (to an advisor or an LLM). One row per product.
--
-- Parsing notes (verified against all 16 catalog rows):
--   risk_profiles         : "Conservative, Moderate, ..."   -> exact-token array
--   age_min / age_max     : "25-65", "0-17 (child age)"      -> the two integers
--   is_child_beneficiary  : "(child age)" marks products whose age range refers to
--                           the child beneficiary (529, custodial), not the holder
--   horizon_years_*       : "... (3-20+ years)"              -> the two integers in parens
--   min_investable_assets : "Minimum $250,000 investable..."  -> numeric floor; NULL
--                           for products with no investable-asset gate

SELECT
    p.product_id,
    p.product_code,
    p.product_name,
    p.product_category,
    p.tax_status,
    p.tax_treatment,

    -- structured match keys
    p.purpose,
    p.best_suited_for,
    p.when_to_recommend,
    p.key_benefits,
    p.key_limitations,
    p.contribution_limit_2026,
    p.income_limit_2026,

    -- descriptive fields carried through for explanation / LLM input
    p.typical_time_horizon,
    p.common_age_range,
    p.risk_suitability,
    STRING_TO_ARRAY(p.risk_suitability, ', ') AS risk_profiles,
    (REGEXP_MATCH(p.common_age_range, '(\d+)\s*-\s*(\d+)'))[1]::int AS age_min,
    (REGEXP_MATCH(p.common_age_range, '(\d+)\s*-\s*(\d+)'))[2]::int AS age_max,
    (p.common_age_range ILIKE '%child%') AS is_child_beneficiary,
    (REGEXP_MATCH(p.typical_time_horizon, '\((\d+)\s*-\s*(\d+)'))[1]::int AS horizon_years_min,
    (REGEXP_MATCH(p.typical_time_horizon, '\((\d+)\s*-\s*(\d+)'))[2]::int AS horizon_years_max,
    REPLACE(
        (REGEXP_MATCH(p.income_limit_2026, 'Minimum \$([0-9,]+)'))[1], ',', ''
    )::numeric AS min_investable_assets
FROM {{ ref('cls_products') }} AS p
