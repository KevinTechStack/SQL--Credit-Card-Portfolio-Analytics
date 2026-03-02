# Data Model

## Synthetic Data → Relational Schema → Analytics Layer

---

## 0) Synthetic Data Creation (Python)

This project uses **synthetic data generated using Python** to simulate a multi-country credit card portfolio while remaining safe to publish (no real PII).

### What the Python script produces
The script generates a portfolio with:
- **10,000 unique customers** with realistic demographics and geography across **7 countries**
- **multi-card** ownership per customer)
- Transaction behavior aligned to portfolio patterns (category mix, channel mix, weekend bias)
- Fraud injection aligned to portfolio fraud rate and segment-level concentration
- Reward redemption behavior (Cashback / Gift Cards / Flights) with differing cost profiles
- Multi-currency spend normalized to USD via conversion mapping

### Realism features included
- Geographic spend patterns (INR dominant in India, AED in UAE, etc.)
- Seasonal spending (festival months, travel peaks)
- Dormant card-months (realistic inactivity)
- Income-correlated credit limits

**Python file**: `python/data_generation.py`

---

## ER Diagram + Analytics Design

---

## ER Diagram


![ER Diagram](images/Credit_Card_Portfolio_ERD.png)

---

## Tables (7 total)

### 1) `customers` (dimension)
- **Grain**: 1 row per customer (10,000 unique customers)
- **Includes**: demographics, geography, income band, credit score, segment label
- **Used for**: segment strategy, country analysis, lifecycle cohorting

### 2) `cards` (account-level dimension)
- **Grain**: 1 row per card (51,598 cards total)
- **Relationship**: customers (1) → cards (many)
- **Includes**: credit limits, annual fees, reward program type
- **Used for**: spend-to-limit/utilization calculations and product economics

### 3) `transactions` (fact table)
- **Grain**: 1 row per transaction
- **Includes**: date, amount_usd, merchant category, merchant type (Online/POS/ATM), currency, location flags
- **Used for**: all spend analytics (category, channel, weekend share), monthly trends, Pareto

### 4) `fraud_flags` (event table)
- **Grain**: 0–1 row per transaction (flagged fraud)
- **Used for**: fraud rate by segment/category, fraud value vs frequency

### 5) `reward_redemptions` (fact table)
- **Grain**: 1 row per redemption event
- **Includes**: redemption type (Cashback/Gift Cards/Flights), redemption_value_usd
- **Used for**: reward cost drivers + rewards vs spend effectiveness

### 6) `payments` (fact table)
- **Grain**: 1 row per payment event
- **Includes**: payment_amount, delinquency status
- **Used for**: repayment behavior and risk indicators

### 7) `currency_conversion` (reference)
- **Grain**: 1 row per currency
- **Used for**: normalizing multi-currency spend into USD

---
## Implementation Files
- Schema: `sql/01_schema.sql`
- Quality checks: `sql/02_sanity_checks.sql`
- Analysis: `sql/03_analysis_queries.sql`

---

**[Next: Business Insights Report →](04_Business_Insights_Report.md)**
## Key Relationships (cardinality)

