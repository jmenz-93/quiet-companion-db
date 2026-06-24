{{ config(
    materialized='incremental',
    incremental_strategy='append',
    on_schema_change='sync_all_columns'
) }}

WITH positions AS (
    SELECT
        account_number,
        ssn,
        ticker,
        CURRENT_DATE AS effective_date,
        SUM(CASE
            WHEN action IN ('Buy', 'Rebalance Buy', 'Dividend Reinvestment', 'Transfer In')
                THEN quantity
            WHEN action IN ('Sell', 'Rebalance Sell', 'Transfer Out')
                THEN quantity * -1
            ELSE 0
        END) AS shares_owned,
        SUM(CASE
            WHEN action IN ('Buy', 'Rebalance Buy', 'Dividend Reinvestment', 'Transfer In')
                THEN net_amount
            ELSE 0
        END) AS cost_basis,
        SUM(CASE WHEN action = 'Dividend (Cash)' THEN net_amount ELSE 0 END) AS dividend_income,
        SUM(CASE WHEN action = 'Interest' THEN net_amount ELSE 0 END) AS interest_income,
        SUM(CASE WHEN action = 'Capital Gain Distribution' THEN net_amount ELSE 0 END) AS capital_gain_distributions,
        SUM(CASE WHEN action IN ('Sell', 'Rebalance Sell') THEN net_amount ELSE 0 END) AS realized_proceeds
    FROM {{ ref('cls_trades') }}
    GROUP BY account_number, ssn, ticker
)

SELECT
    effective_date,
    account_number,
    ssn,
    ticker,
    shares_owned,
    cost_basis,
    dividend_income,
    interest_income,
    capital_gain_distributions,
    realized_proceeds,
    CASE
        WHEN shares_owned > 0
            THEN ROUND(cost_basis / shares_owned, 4)
        ELSE 0
    END AS average_cost_per_share,
    (dividend_income + interest_income + capital_gain_distributions) AS total_income
FROM positions
WHERE
    shares_owned > 0
    {% if is_incremental() %}
        AND effective_date > (SELECT MAX(h2.effective_date) FROM {{ this }} AS h2)
    {% endif %}
