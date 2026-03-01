# Executive Summary
## Credit Card Portfolio Intelligence System (Mass Market)

---

## Project Overview

**Objective**: Build a comprehensive SQL-based analytics platform to monitor and optimize a mass market credit card portfolio for XYZ Bank, an international issuer headquartered in UAE serving customers across 7 countries.

**Problem Statement**: Banks need real-time insights into customer spend behavior, fraud patterns, rewards effectiveness, and profitability to make data-driven decisions on product offers, credit limits, fraud controls, and retention strategies to improve revenue and reduce losses.

**Solution**: End-to-end analytics system from synthetic data generation - Python → normalized database (PostgreSQL) → business intelligence (SQL + Power BI).

---

## Portfolio Snapshot (from this project)

| Metric | Value |
|--------|-------|
| **Customers (unique)** | **10,000** |
| **Cards issued** | **51,598** |
| **Total Spend (USD)** | **$508.31M** |
| **Avg Monthly Spend (USD)** | **$21.18M** |
| **Time Window** | Jan 2024 → Dec 2025 |
| **Fraud Rate (overall)** | **0.257%** |
| **Geographies** | India, UAE, UK, Europe, Turkey, Qatar |

> Note: Customers can hold **multiple cards** (avg ~5.16 cards/customer), which is intentionally modeled to resemble real-world portfolio behavior.

---

## Methodology

### Step 1: Synthetic Data Generation (Python)
- **Why synthetic?** Privacy compliance (no real PII), safe to publish, reproducible, and controllable realism.
- **What was built**: 7 interconnected tables with realistic patterns.
- **10,000 unique customers** across 7 countries, with **51,598 cards** issued.
- **Merchant categories**: Shopping, Groceries, Dining, Electronics, Fuel, Travel.
- **Channels**: Online, POS, ATM.
- **Realism**: weekend spend bias, seasonal patterns, fraud injection (portfolio-level fraud rate aligns to outputs).
- **Realism features**:
  - Geographic spend patterns (INR dominant in India, AED in UAE, etc.)
  - Seasonal spending (festival months, travel peaks)
  - Dormant card-months (realistic inactivity)
  - Income-correlated credit limits

### Step 2: Database Design (PostgreSQL)
- Normalized schema with 7 tables, referential integrity.
- Currency standardization (all amounts converted to USD for analysis).
- Proper indexing on foreign keys for query performance.

### Step 3: Data Quality Validation (SQL)
- 20+ sanity checks covering:
  - Row counts, duplicate detection
  - Missing values
  - Referential integrity checks (orphan transactions/cards/fraud flags)
  - Currency coverage (100% transactions mapped)
  - Fraud rate validation

### Step 4: Analytics Layer (SQL)
Built 10+ summary tables using advanced SQL:
- **Customer behavior**: spend summaries, segmentation, Pareto analysis
- **Operational metrics**: monthly trends, category/channel mix, weekend vs weekday
- **Risk metrics**: fraud by segment/channel/category (frequency vs value)
- **Economics**: rewards effectiveness, profitability modeling
- Techniques: CTEs, window functions, percentiles, CTAS

### Step 5: Business Intelligence (Power BI)
- 5-page interactive dashboard:
  1. Portfolio Overview (KPIs, trends, profitability bands)
  2. Spend & Channel Analysis (category, channel, weekend vs weekday)
  3. Fraud & Risk (exposure by segment/category; fraud value vs count)
  4. Rewards & Profitability (reward cost, scatter plots, profitability distribution)
  5. Segments & Customer Spend (segment sizing, Pareto curve, utilization trend)

---

## Key Discoveries

### 1. **Customer Segmentation & Pareto**
- **Emerging Affluent (20% of customers)**: contributes **~30% of total spend**, highly valuable → Retain & upsell
- **Mass Market**: largest spend engine and stable base → Retention + value protection
- **Low Value**: low engagement and highest fraud frequency share → Activation + automated controls

### 2. Pareto Principle Validated
- Cumulative spend curve shows top customers drive majority value.
- **20% of customers contribute to 57% of the total spend**.
- Monthly spend-to-limit trending up (risk signal for some cohorts).
- **Implication**: retention programs must prioritize top spend percentiles and Emerging Affluent.

### 3. Spend Patterns
- Category share (percent of spend):
  - Groceries: 24.71%
  - Shopping: 20.32%
  - Fuel: 15.41%
  - Electronics: 14.91%
  - Dining: 14.90%
  - Travel: 9.74%
- **Online dominates** (digital-first portfolio).
- Weekend spend share is materially higher (weekend-heavy behavior).
- **Implication**: focus merchant partnerships on everyday categories and run major campaigns Friday–Sunday.

### 4. Fraud Concentration
- Portfolio fraud rate is **0.257%** but concentrated by segment and dimension.
- Low Value contributes the highest share of fraud cases by count (frequency-driven risk).
- Fraud value exposure is highest in Mass Market (value-driven risk).
- **Implication**: segment-based strategy—automate controls for Low Value, deploy advanced monitoring for high-value Mass Market transactions.

### 5. **Rewards & Profitability**
- Cashback is the most expensive and highest-volume redemption type.
- Scatter analysis reveals many customers generate minimal profit.
- Reward cost rises sharply for low-spend customers (inefficient).
- Profit is concentrated in top profitability bands.
- **Implication**: cap high-cost redemptions and redesign rewards to be value-based and margin-safe.

---

## 💡 Business Impact

| Finding | Implication | Recommendation |
|---------|-------------|----------------|
| Mass Market is the largest spend engine | Revenue concentration risk if engagement drops | Prioritize retention campaigns and credit limit optimization |
| Emerging Affluent drives disproportionate value | Highest ROI segment | Upsell, premium tiers, personalized benefits |
| Weekend-heavy behavior | Lifestyle-driven portfolio | Schedule promotional campaigns and offers for weekends |
| Low Value segment drives highest fraud frequency | High operational cost relative to value | Implement automated risk rules and low-cost fraud controls |
| Cashback is a major reward cost driver | Potential margin erosion | Move to tiered or targeted rewards based on customer value |
| Groceries and Shopping dominate spend | Everyday categories drive engagement | Strengthen merchant partnerships and category-specific offers |
| Profitability skewed to top bands | Revenue highly skewed toward a small customer base | Launch VIP tiers, proactive retention, personalized benefits |

**Estimated Annual Impact**: 4–6% improvement in portfolio profitability through targeted rewards optimization, fraud reduction, and high-value customer retention initiatives.

---

**[Next: Business Context →](02_Business_Context.md)**
