DATA SANITY CHECKS

-- 1.	CHECK FOR ANY ODD VALUES
SELECT
(SELECT COUNT(*) FROM customers) AS customers,
(SELECT COUNT(*) FROM cards) AS cards,
(SELECT COUNT(*) FROM transactions) AS transactions,
(SELECT COUNT(*) FROM payments) AS payments,
(SELECT COUNT(*) FROM fraud_flags) AS fraud_flags,
(SELECT COUNT(*) FROM reward_redemptions) AS redemptions,
(SELECT COUNT(*) FROM currency_conversion) AS currencies;

-- 2.	CHECK DISTINCT
SELECT COUNT(*) - COUNT(DISTINCT customer_id) FROM customers;
SELECT COUNT(*) - COUNT(DISTINCT card_id) FROM cards;
SELECT COUNT(*) - COUNT(DISTINCT transaction_id) FROM transactions;
SELECT COUNT(*) - COUNT(DISTINCT payment_id) FROM payments;
SELECT COUNT(*) - COUNT(DISTINCT fraud_id) FROM fraud_flags;
SELECT COUNT(*) - COUNT(DISTINCT redemption_id) FROM reward_redemptions;

-- 3.	CHECK FOR NULLS
SELECT COUNT(*)
FROM transactions t
LEFT JOIN currency_conversion cc
ON t.currency = cc.currency_code
WHERE cc.currency_code IS NULL;

-- 4.	%FRAUD
SELECT
COUNT(f.transaction_id) * 100.0 / COUNT(*) AS fraud_rate_percent
FROM transactions t
LEFT JOIN fraud_flags f
ON t.transaction_id = f.transaction_id;

-- 5.	
SELECT
MIN(payment_amount),
AVG(payment_amount),
MAX(payment_amount)
FROM payments;

SELECT COUNT(*)
FROM payments
WHERE payment_amount = 0;

-- 6.	
SELECT customer_segment, COUNT(*)
FROM customers
GROUP BY customer_segment;

-- 7. NULLS
SELECT
COUNT(*) FILTER (WHERE transaction_id IS NULL) AS missing_customer,
COUNT(*) FILTER (WHERE card_id IS NULL) AS missing_card,
COUNT(*) FILTER (WHERE amount IS NULL) AS missing_amount,
COUNT(*) FILTER (WHERE currency IS NULL) AS missing_currency,
COUNT(*) FILTER (WHERE merchant_category IS NULL) AS missing_category,
COUNT(*) FILTER (WHERE transaction_date IS NULL) AS missing_date
FROM transactions;

-- 8. 
SELECT
COUNT(*) FILTER (WHERE payment_id IS NULL),
COUNT(*) FILTER (WHERE payment_amount IS NULL),
COUNT(*) FILTER (WHERE payment_date IS NULL),
COUNT(*) FILTER (WHERE card_id IS NULL)
FROM payments;

-- 9.
SELECT
COUNT(*) FILTER (WHERE redemption_id IS NULL),
COUNT(*) FILTER (WHERE redemption_value IS NULL),
COUNT(*) FILTER (WHERE redemption_type IS NULL),
COUNT(*) FILTER (WHERE redemption_date IS NULL)
FROM reward_redemptions;

-- 10. MISSING OR NEGATIVE VALUES
SELECT COUNT(*) FROM transactions WHERE amount <= 0;
SELECT COUNT(*) FROM payments WHERE payment_amount <= 0;
SELECT COUNT(*) FROM reward_redemptions WHERE redemption_value <= 0;
SELECT COUNT(*) FROM customers WHERE customer_id <= 0;

-- 11. DUPLICATE RECORDS
SELECT COUNT(*) - COUNT(DISTINCT transaction_id) AS duplicates
FROM transactions;
