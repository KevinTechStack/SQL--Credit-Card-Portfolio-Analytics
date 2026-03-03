# Data Model

## Synthetic Data → Relational Schema → Analytics Layer → Visualization Layer

---

## 1) Synthetic Data Creation (Python)

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

**Python file**: [`python/data_generation.py`](python/data_generation.py)

---
## 2) Relational Schema
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

## 3) Analytics Layer (SQL outputs)

SQL creates summary tables used directly in Power BI:
- Customer spend summary (customer-level spend, transactions, ticket size)
- Segment spend summary (customers, spend contribution, avg spend)
- Category / channel / weekend summaries (mix + percent shares)
- Fraud summaries (portfolio fraud rate, fraud by segment)
- Pareto analysis (top 20% customers → 57% spend)
- Rewards effectiveness (reward-to-spend ratio)
- Profitability model + bands

SQL location: [`sql`](sql.sql)

---
## Visualization Layer (Power BI)

This project uses Power BI as the visualization layer on top of the SQL analytics outputs.

### How Power BI is powered
- Summary tables are **created in SQL** (CTAS) inside PostgreSQL (for example: segment, category, channel, weekend, fraud, profitability, and Pareto outputs).
- These SQL output tables are then **imported into Power BI** to build the 5-page dashboard and ensure the visuals are driven by validated summary tables (not raw transactions).

### Power BI artifact
- Dashboard file: [`PowerBI/CC_PORTFOLIO_ANALYSIS_new.pbix`](PowerBI/CC_PORTFOLIO_ANALYSIS_new.pbix)

### Screenshot references
Screenshots used across documentation are stored in `images/`:
- [`Portfolio_Overview_page_1.png`](images/Portfolio_Overview_page_1.png)
- [`Spend_and_Channels_page_2.png`](images/Spend_and_Channels_page_2.png)
- [`Rewards_and_Profitability_page_3.png`](images/Rewards_and_Profitability_page_3.png)
- [`Fraud_and_Risk_page_4.png`](images/Fraud_and_Risk_page_4.png)
- [`Segments_and_Customers_page_5.png`](images/Segments_and_Customers_page_5.png)
  
## Implementation Files
- **Schema**: [`sql/01_schema.sql`](sql/01_schema.sql)
- **Quality checks**: [`sql/02_sanity_checks.sql`](sql/02_sanity_checks.sql)
- **Analysis**: [`sql/03_analysis_queries.sql`](sql/03_analysis_queries.sql)
- Power BI: [`PowerBI/CC_PORTFOLIO_ANALYSIS_new.pbix`](PowerBI/CC_PORTFOLIO_ANALYSIS_new.pbix)
---

**[Next: Business Insights Report →](04_Business_Insights_Report.md)**

