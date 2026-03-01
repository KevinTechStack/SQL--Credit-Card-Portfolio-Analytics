/* ============================================================
   CREDIT CARD PORTFOLIO ANALYTICS — SQL ANALYSIS LAYER
   Project: XYZ Bank | 10K customers | 51,598 cards
   Purpose: Build summary tables for Power BI + insights reporting
   ============================================================ */

BEGIN;

-- ============================================================
-- 1) CUSTOMER-LEVEL SUMMARY
-- ============================================================

DROP TABLE IF EXISTS customer_spend_summary;

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


-- ============================================================
-- 2) SEGMENT-LEVEL SUMMARY
-- ============================================================

DROP TABLE IF EXISTS segment_spend_summary;

CREATE TABLE segment_spend_summary AS
SELECT
  customer_segment,
  COUNT(DISTINCT customer_id) AS customers,
  SUM(total_spend_usd) AS segment_total_spend,
  SUM(total_transactions) AS segment_total_transactions,
  AVG(total_spend_usd) AS avg_total_spend_per_customer,
  AVG(avg_ticket_size) AS avg_spend_per_transaction,
  SUM(total_spend_usd) / NULLIF(SUM(total_transactions), 0) AS segment_avg_spend_per_txn
FROM customer_spend_summary
GROUP BY customer_segment
ORDER BY segment_total_spend DESC;


-- ============================================================
-- 3) MONTHLY SPEND SUMMARY
-- ============================================================

DROP TABLE IF EXISTS monthly_spend_summary;

CREATE TABLE monthly_spend_summary AS
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    SUM(amount_usd) AS total_spend,
    COUNT(transaction_id) AS txn_count,
    COUNT(DISTINCT card_id) AS active_cards
FROM transactions
GROUP BY month
ORDER BY month;


-- ============================================================
-- 4) SPENDING BEHAVIOR (CATEGORY / CHANNEL / DAY-TYPE)
-- ============================================================

DROP TABLE IF EXISTS category_spend_summary;

CREATE TABLE category_spend_summary AS
SELECT 
    merchant_category,
    COUNT(*) AS trxn_count,
    SUM(amount_usd) AS total_spend_usd,
    ROUND(
        SUM(amount_usd) * 100.0 / SUM(SUM(amount_usd)) OVER (),
        2
    ) AS percent_share
FROM transactions
GROUP BY merchant_category
ORDER BY total_spend_usd DESC;


DROP TABLE IF EXISTS channel_spend_summary;

CREATE TABLE channel_spend_summary AS
SELECT
    merchant_type,
    COUNT(*) AS trxn_count,
    SUM(amount_usd) AS total_spend_usd,
    ROUND(
        SUM(amount_usd) * 100.0 / SUM(SUM(amount_usd)) OVER (),
        2
    ) AS percent_share
FROM transactions
GROUP BY merchant_type
ORDER BY total_spend_usd DESC;


DROP TABLE IF EXISTS weekend_spend_summary;

CREATE TABLE weekend_spend_summary AS
SELECT
    CASE 
        WHEN EXTRACT(DOW FROM transaction_date) IN (0, 6) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(*) AS trxn_count,
    SUM(amount_usd) AS total_spend_usd,
    ROUND(
        SUM(amount_usd) * 100.0 / SUM(SUM(amount_usd)) OVER (),
        2
    ) AS percent_share
FROM transactions
GROUP BY day_type
ORDER BY total_spend_usd DESC;


-- ============================================================
-- 5) FRAUD ANALYSIS
-- ============================================================

DROP TABLE IF EXISTS fraud_summary;

CREATE TABLE fraud_summary AS
SELECT
    COUNT(f.fraud_id) AS fraud_txn,
    SUM(CASE WHEN f.fraud_id IS NOT NULL THEN t.amount_usd ELSE 0 END) AS fraud_amount,
    COUNT(t.transaction_id) AS total_txn,
    ROUND(COUNT(f.fraud_id) * 100.0 / NULLIF(COUNT(t.transaction_id), 0), 3) AS fraud_rate_percent
FROM transactions t
LEFT JOIN fraud_flags f
  ON t.transaction_id = f.transaction_id;


DROP TABLE IF EXISTS fraud_by_segment;

CREATE TABLE fraud_by_segment AS
SELECT
    c.customer_segment,
    COUNT(t.transaction_id) AS total_txns,
    COUNT(f.fraud_id) AS fraud_txns,
    ROUND(
        COUNT(f.fraud_id) * 100.0 / NULLIF(COUNT(t.transaction_id), 0),
        3
    ) AS fraud_rate_percent
FROM transactions t
JOIN cards cd ON t.card_id = cd.card_id
JOIN customers c ON cd.customer_id = c.customer_id
LEFT JOIN fraud_flags f ON t.transaction_id = f.transaction_id
GROUP BY c.customer_segment
ORDER BY fraud_rate_percent DESC;


-- ============================================================
-- 6) PARETO ANALYSIS (CUSTOMER SPEND CONCENTRATION)
-- ============================================================

DROP TABLE IF EXISTS pareto_spend_analysis;

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
    ROUND(cumulative_spend / NULLIF(total_portfolio_spend, 0), 4) AS cumulative_spend_percent,
    ROUND(spend_rank * 100.0 / NULLIF(total_customers, 0), 2) AS customer_percentile
FROM calc
ORDER BY spend_rank;


-- 6.1 PARETO SUMMARY QUERY (Top 20% customers -> % of revenue)
-- This is intentionally a SELECT (not a table) so it can be used for validation output.

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
        SUM(customer_spend) OVER (ORDER BY customer_spend DESC) AS cumulative_revenue,
        COUNT(*) OVER () AS total_customers,
        ROW_NUMBER() OVER (ORDER BY customer_spend DESC) AS customer_rank
    FROM customer_revenue
),
pareto_flag AS (
    SELECT
        *,
        customer_rank * 1.0 / NULLIF(total_customers, 0) AS customer_percent,
        cumulative_revenue * 1.0 / NULLIF(total_business, 0) AS revenue_percent
    FROM ranked
)
SELECT
    ROUND(customer_percent * 100, 2) AS customer_percent,
    ROUND(revenue_percent * 100, 2) AS revenue_percent
FROM pareto_flag
WHERE customer_percent <= 0.20
ORDER BY customer_percent DESC
LIMIT 1;


-- ============================================================
-- 7) UTILIZATION / SPEND-TO-LIMIT (CUSTOMER-MONTH)
-- ============================================================

ALTER TABLE cards ADD COLUMN IF NOT EXISTS credit_limit_usd NUMERIC;

UPDATE cards c
SET credit_limit_usd = c.credit_limit * conv.conversion_to_usd
FROM customers cust
JOIN (
    SELECT 'UAE' as country, 'AED' as cur UNION ALL
    SELECT 'India', 'INR' UNION ALL
    SELECT 'Qatar', 'QAR' UNION ALL
    SELECT 'UK', 'GBP' UNION ALL
    SELECT 'Germany', 'EUR' UNION ALL
    SELECT 'France', 'EUR'
) country_map ON cust.country = country_map.country
JOIN currency_conversion conv ON country_map.cur = conv.currency_code
WHERE c.customer_id = cust.customer_id;


DROP TABLE IF EXISTS customer_monthly_spend_to_limit;

CREATE TABLE customer_monthly_spend_to_limit AS
SELECT
    c.customer_id,
    DATE_TRUNC('month', t.transaction_date) AS month,
    SUM(t.amount_usd) AS monthly_spend_usd,
    cl.total_credit_limit_usd,
    ROUND(
        SUM(t.amount_usd) / NULLIF(cl.total_credit_limit_usd, 0),
        4
    ) AS monthly_spend_to_limit
FROM transactions t
JOIN cards ca ON ca.card_id = t.card_id
JOIN customers c ON c.customer_id = ca.customer_id
JOIN (
    SELECT customer_id, SUM(credit_limit_usd) AS total_credit_limit_usd
    FROM cards
    GROUP BY customer_id
) cl ON cl.customer_id = c.customer_id
GROUP BY c.customer_id, month, cl.total_credit_limit_usd
ORDER BY c.customer_id, month;


-- ============================================================
-- 8) REWARDS EFFECTIVENESS
-- ============================================================

DROP TABLE IF EXISTS rewards_cost_per_card;

CREATE TABLE rewards_cost_per_card AS
SELECT
    card_id,
    COUNT(*) AS redemption_count,
    SUM(redemption_value_usd) AS total_reward_cost_usd,
    AVG(redemption_value_usd) AS avg_redemption_value_usd
FROM reward_redemptions
GROUP BY card_id;


DROP TABLE IF EXISTS rewards_effectiveness;

CREATE TABLE rewards_effectiveness AS
SELECT
    cs.customer_id,
    cs.total_spend_usd,
    COALESCE(SUM(r.total_reward_cost_usd), 0) AS total_reward_cost_usd,
    ROUND(
        COALESCE(SUM(r.total_reward_cost_usd), 0) / NULLIF(cs.total_spend_usd, 0),
        4
    ) AS reward_to_spend_ratio
FROM customer_spend_summary cs
LEFT JOIN cards c
  ON cs.customer_id = c.customer_id
LEFT JOIN rewards_cost_per_card r
  ON c.card_id = r.card_id
GROUP BY cs.customer_id, cs.total_spend_usd
ORDER BY reward_to_spend_ratio DESC;


DROP TABLE IF EXISTS rewards_summary;

CREATE TABLE rewards_summary AS
SELECT
    redemption_type,
    SUM(redemption_value_usd) AS total_cost,
    COUNT(*) AS redemption_count
FROM reward_redemptions
GROUP BY redemption_type;


-- ============================================================
-- 9) PROFITABILITY (REALISTIC PROFIT MODEL)
-- ============================================================

DROP TABLE IF EXISTS customer_profitability_v2;

CREATE TABLE customer_profitability_v2 AS
SELECT 
    cs.customer_id,
    cs.total_spend_usd,
    ROUND(cs.total_spend_usd * 0.015, 2) AS interchange_revenue_usd,
    COALESCE(SUM(cd.annual_fee_usd), 0) AS annual_fee_usd,
    COALESCE(MAX(re.total_reward_cost_usd), 0) AS reward_cost_usd
FROM customer_spend_summary cs
LEFT JOIN (
    SELECT
        customer_id,
        SUM(annual_fee * 0.27) AS annual_fee_usd
    FROM cards
    GROUP BY customer_id
) cd ON cs.customer_id = cd.customer_id
LEFT JOIN rewards_effectiveness re ON cs.customer_id = re.customer_id
GROUP BY cs.customer_id, cs.total_spend_usd;


DROP TABLE IF EXISTS customer_profitability;

CREATE TABLE customer_profitability AS
WITH params AS (
  SELECT 0.006::numeric AS other_cost_rate
)
SELECT
  cp.customer_id,
  cp.total_spend_usd,
  cp.interchange_revenue_usd,
  cp.annual_fee_usd,
  cp.reward_cost_usd,
  ROUND(cp.total_spend_usd * p.other_cost_rate, 2) AS other_cost_usd,
  ROUND(
    cp.interchange_revenue_usd
    + cp.annual_fee_usd
    - cp.reward_cost_usd
    - (cp.total_spend_usd * p.other_cost_rate),
    2
  ) AS profit_realistic_usd
FROM customer_profitability_v2 cp
CROSS JOIN params p;


DROP TABLE IF EXISTS profitability_summary;

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


-- ============================================================
-- 10) CUSTOMER SEGMENTATION (SPEND + PROFIT)
-- ============================================================

DROP TABLE IF EXISTS customer_segments;

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
    WHEN COALESCE(p.profit_realistic_usd, 0) < 0 THEN 'Loss Customer'
    WHEN s.total_spend_usd >= t.p80 AND COALESCE(p.profit_realistic_usd, 0) > 0 THEN 'High Value'
    WHEN s.total_spend_usd < t.p50 THEN 'Low Activity'
    ELSE 'Mass Market'
  END AS customer_segment
FROM customer_spend_summary s
LEFT JOIN customer_profitability p
  ON p.customer_id = s.customer_id
CROSS JOIN thresholds t;

COMMIT;
