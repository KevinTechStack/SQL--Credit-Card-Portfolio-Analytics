-- 1. CREATED SUMMARY TABLE 

CREATE TABLE customer_spend_summary AS
SELECT
    c.customer_id,
    c.customer_segment,
    SUM(t.amount_usd) AS total_spend_usd,
    COUNT(t.transaction_id) AS total_transactions,
    AVG(t.amount_usd) AS avg_ticket_size
FROM customers c
JOIN cards cd ON c.customer_id = cd.customer_id
JOIN transactions t ON cd.card_id = t.card_id
GROUP BY c.customer_id, c.customer_segment;

-- 2. Customer segment analysis

CREATE TABLE segment_spend_summary AS
SELECT
  customer_segment,
  COUNT(DISTINCT customer_id) AS customers,
  SUM(total_spend_usd) AS segment_total_spend,
  SUM(total_transactions) AS segment_total_transactions,
  AVG(total_spend_usd) AS avg_total_spend_per_customer,
  AVG(avg_ticket_size) AS avg_spend_per_transaction,
  SUM(total_spend_usd) / NULLIF(SUM(total_transactions),0) AS segment_avg_spend_per_txn
FROM customer_spend_summary
GROUP BY customer_segment
ORDER BY segment_total_spend DESC;

-- 3. MONTHLY SPEND SUMMARY TABLE 

CREATE TABLE monthly_spend_summary AS
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    SUM(amount_usd) AS total_spend,
    COUNT(transaction_id) AS txn_count,
    COUNT(DISTINCT card_id) AS active_cards
FROM transactions
GROUP BY month
ORDER BY month;

-- 4. SPENDING BEHAVIOUR

-- 4.1. Identifying Category wise – Count of transactions and Total amount spent

CREATE TABLE category_spend_summary AS
SELECT 
	merchant_category,
	COUNT(*) AS trxn_count,
	SUM(amount_usd) AS total_spend_usd,
	ROUND(
	SUM(amount_usd) * 100.0 / SUM(SUM(amount_usd)) OVER (),
	2
	) AS percent_share
FROM transacTions
GROUP BY merchant_category
ORDER BY total_spend_usd DESC;

-- 4.2.CHANNEL SPEND SUMMARY - Identifying Channel-wise – Count of transactions and Total amount spent

CREATE TABLE channel_spend_summary AS
SELECT
    merchant_type,
	COUNT(*) AS trxn_count,
    SUM(amount_usd) AS total_spend_usd,
    ROUND(
        SUM(amount_usd) * 100.0 / SUM(SUM(amount_usd)) OVER (), 2) AS percent_share
FROM transactions
GROUP BY merchant_type
ORDER BY total_spend_usd DESC;

-- 4.3. Weekend vs Weekday

CREATE TABLE weekend_spend_summary AS
SELECT
    CASE 
        WHEN EXTRACT(DOW FROM transaction_date) IN (0,6)
        THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
	COUNT (*) AS trxn_count,
    SUM(amount_usd) AS total_spend_usd,
    ROUND(
        SUM(amount_usd) * 100.0 / SUM(SUM(amount_usd)) OVER (),
        2
    ) AS percent_share
FROM transactions
GROUP BY day_type
ORDER BY total_spend_usd DESC;

-- 5. FRAUD ANALYSIS

CREATE TABLE fraud_summary AS
SELECT
    COUNT(f.fraud_id) AS fraud_txn,
    SUM(t.amount_usd) AS fraud_amount,
    COUNT(t.transaction_id) AS total_txn,
    (COUNT(f.fraud_id) * 100.0 / COUNT(t.transaction_id)) AS fraud_rate_percent
FROM transactions t
LEFT JOIN fraud_flags f
ON t.transaction_id = f.transaction_id;

-- 5.1. FRAUD BY SEGMENT

CREATE TABLE fraud_by_segment AS
SELECT
    c.customer_segment,
    COUNT(t.transaction_id) AS total_txns,
    COUNT(f.fraud_id) AS fraud_txns,
    ROUND(
        COUNT(f.fraud_id) * 100.0 / COUNT(t.transaction_id),
        3
    ) AS fraud_rate_percent
FROM transactions t
JOIN cards cd ON t.card_id = cd.card_id
JOIN customers c ON cd.customer_id = c.customer_id
LEFT JOIN fraud_flags f ON t.transaction_id = f.transaction_id
GROUP BY c.customer_segment
ORDER BY fraud_rate_percent DESC;

-- 6. PARETO ANALYSIS

CREATE TABLE pareto_spend_analysis AS
WITH ranked AS (
    SELECT
        customer_id,
        total_spend_usd,
        SUM(total_spend_usd) OVER () AS total_portfolio_spend,
        ROW_NUMBER() OVER (ORDER BY total_spend_usd DESC) AS spend_rank,
        COUNT(*) OVER () AS total_customers
    FROM customer_spend_summary
),

calc AS (
    SELECT
        *,
        SUM(total_spend_usd) OVER (
            ORDER BY total_spend_usd DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_spend
    FROM ranked
)

SELECT
    customer_id,
    total_spend_usd,
    spend_rank,
    ROUND(cumulative_spend / total_portfolio_spend, 4) AS cumulative_spend_percent,
    ROUND(spend_rank * 100.0 / total_customers, 2) AS customer_percentile
FROM calc
ORDER BY spend_rank;

-- 6.1. SUMMARY TABLE

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        SUM(t.amount_usd) AS customer_spend
    FROM transactions t
    JOIN cards cd ON t.card_id = cd.card_id
    JOIN customers c ON cd.customer_id = c.customer_id
    GROUP BY c.customer_id
),

ranked AS (
    SELECT
        customer_spend,
        SUM(customer_spend) OVER () AS total_business,
        SUM(customer_spend) OVER (
            ORDER BY customer_spend DESC
        ) AS cumulative_revenue,
        COUNT(*) OVER () AS total_customers,
        ROW_NUMBER() OVER (
            ORDER BY customer_spend DESC
        ) AS customer_rank
    FROM customer_revenue
),

pareto_flag AS (
    SELECT *,
        customer_rank * 1.0 / total_customers AS customer_percent,
        cumulative_revenue * 1.0 / total_business AS revenue_percent
    FROM ranked
)

SELECT
    ROUND(customer_percent * 100, 2) AS customer_percent,
    ROUND(revenue_percent * 100, 2) AS revenue_percent
FROM pareto_flag
WHERE customer_percent <= 0.20
ORDER BY customer_percent DESC
LIMIT 1;

-- 7. CARD UTILIZATION RATIO

-- 7.1. Converting credit limit to usd from base currency
ALTER TABLE cards
ADD COLUMN IF NOT EXISTS credit_limit_usd NUMERIC;
UPDATE cards c
SET credit_limit_usd = c.credit_limit * cc.conversion_to_usd
FROM currency_conversion cc
WHERE cc.currency_code = 'AED'

-- 7.2. CREATE TABLE customer_monthly_spend_to_limit AS

SELECT
  c.customer_id,
  date_trunc('month', t.transaction_date) AS month,
  SUM(t.amount_usd) AS monthly_spend_usd,
  cl.total_credit_limit_usd,
  ROUND(
    SUM(t.amount_usd) / NULLIF(cl.total_credit_limit_usd, 0),
    4
  ) AS monthly_spend_to_limit
FROM transactions t
JOIN cards ca
  ON ca.card_id = t.card_id
JOIN customers c
  ON c.customer_id = ca.customer_id
JOIN (
  SELECT customer_id, SUM(credit_limit_usd) AS total_credit_limit_usd
  FROM cards
  GROUP BY customer_id
) cl
  ON cl.customer_id = c.customer_id
GROUP BY
  c.customer_id,
  date_trunc('month', t.transaction_date),
  cl.total_credit_limit_usd
ORDER BY
  c.customer_id,
  month;

-- 8. REWARDS EFFECTIVENESS

-- 8.1. Reward cost per card

CREATE TABLE rewards_cost_per_card AS
SELECT
    card_id,
    COUNT(*) AS redemption_count,
    SUM(redemption_value_usd) AS total_reward_cost_usd,
    AVG(redemption_value_usd) AS avg_redemption_value_usd
FROM reward_redemptions
GROUP BY card_id;


-- 8.2. REWARDS vs SPEND

CREATE TABLE rewards_effectiveness AS
SELECT
cs.customer_id,
cs.total_spend_usd,
COALESCE(SUM(r.total_reward_cost_usd), 0) AS total_reward_cost_usd,
ROUND(
COALESCE(SUM(r.total_reward_cost_usd), 0) 
/ NULLIF(cs.total_spend_usd, 0),
4
) AS reward_to_spend_ratio
FROM customer_spend_summary cs
LEFT JOIN cards c
ON cs.customer_id = c.customer_id
LEFT JOIN rewards_cost_per_card r
ON c.card_id = r.card_id
GROUP BY cs.customer_id, cs.total_spend_usd
ORDER BY reward_to_spend_ratio DESC

CREATE TABLE rewards_summary AS
SELECT
    redemption_type,
    SUM(redemption_value_usd) AS total_cost,
    COUNT(*) AS redemption_count
FROM reward_redemptions
GROUP BY redemption_type;

-- 9. PROFITABILITY

CREATE TABLE customer_profitability AS
WITH params AS (
  SELECT 0.006::numeric AS other_cost_rate  -- 0.6% of spend; try 0.004 to 0.008 [web:692]
)
SELECT
  customer_id,
  total_spend_usd,
  interchange_revenue_usd,
  annual_fee_usd,
  reward_cost_usd,

  ROUND(total_spend_usd * p.other_cost_rate, 2) AS other_cost_usd,

  ROUND(
    interchange_revenue_usd
    + COALESCE(annual_fee_usd, 0)
    - COALESCE(reward_cost_usd, 0)
    - (total_spend_usd * p.other_cost_rate),
    2
  ) AS profit_realistic_usd
FROM customer_profitability_v2 
CROSS JOIN params p;

CREATE TABLE profitability_summary AS
SELECT
  CASE
    WHEN profit_realistic_usd < 0 THEN 'Loss'
    WHEN profit_realistic_usd < 100 THEN 'Low (0-100)'
    WHEN profit_realistic_usd < 1000 THEN 'Mid (100-1k)'
    WHEN profit_realistic_usd < 10000 THEN 'High (1k-10k)'
    ELSE 'Very High (10k+)'
  END AS profit_band,
  COUNT(*) AS customers,
  SUM(profit_realistic_usd) AS total_profit_usd
FROM customer_profitability
GROUP BY 1
ORDER BY 1;

-- 10. CUSTOMER SEGMENTATION

CREATE TABLE customer_segments AS
WITH thresholds AS (
  SELECT
    percentile_cont(0.80) WITHIN GROUP (ORDER BY total_spend_usd) AS p80,
    percentile_cont(0.50) WITHIN GROUP (ORDER BY total_spend_usd) AS p50
  FROM customer_spend_summary
)
SELECT
  s.customer_id,
  s.total_spend_usd,
  p.profit_realistic_usd,

  CASE
    WHEN COALESCE(p.profit_realistic_usd, 0) < 0
      THEN 'Loss Customer'

    WHEN s.total_spend_usd >= t.p80
         AND COALESCE(p.profit_realistic_usd, 0) > 0
      THEN 'High Value'

    WHEN s.total_spend_usd < t.p50
      THEN 'Low Activity'

    ELSE 'Mass Market'
  END AS customer_segment

FROM customer_spend_summary s
LEFT JOIN customer_profitability p
  ON p.customer_id = s.customer_id
CROSS JOIN thresholds t;
