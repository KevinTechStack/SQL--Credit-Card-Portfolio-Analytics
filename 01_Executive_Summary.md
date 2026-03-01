## Project Overview

**Objective**: Build a comprehensive SQL-based analytics platform to monitor and optimize a mass market credit card portfolio for XYZ Bank, an international issuer located in UAE serving customers across 7 countries.

**Problem Statement**: Banks need real-time insights into customer spend behavior, fraud patterns, rewards effectiveness, and profitability to make data-driven decisions on product offers, credit limits, fraud controls, and retention strategies to make decisions to improve revenue and reduce losses.

**Solution**: End-to-end analytics system from synthetic data generation - Python → normalized database (PostgreSQL) → business intelligence (SQL + Power BI).

---	

## Methodology 

### Step 1: Synthetic Data Generation (Python)
- **Why synthetic?** Privacy compliance (no real PII), realistic patterns
- **What we built**: 7 interconnected tables with realistic patterns
- **50K customers** across 7 different countries
- **Merchant categories**: Shopping, Groceries, Dining, Electronics, Fuel, Travel
- **Channels**: Online (68% spend), POS, ATM
- **Realism**: Weekend spend 2x weekday, seasonal patterns, fraud injection (0.42%)
- **Realism features**:
  - Geographic spend patterns (INR dominant in India, AED in UAE, etc.)
  - Seasonal spending (festival months, travel peaks)
  - Dormant card-months (realistic inactivity)
  - Income-correlated credit limits

### Step 2: Database Design (PostgreSQL)
- Normalized schema (3NF) with 7 tables, referential integrity
- Currency standardization (all amounts converted to USD for analysis)
- Proper indexing on foreign keys for query performance

### Step 3: Data Quality Validation (SQL)
- 20+ sanity checks covering:
  - Row counts, duplicate detection
  - Missing values
  - Referential integrity to check orphan transactions)
  - Currency coverage (100% transactions mapped)
  - Fraud rate validation

### Step 4: Analytics Layer (SQL)
Built 10+ summary tables using advanced SQL:
- **Customer behavior**: spend summaries, segmentation, Pareto analysis
- **Operational metrics**: monthly trends, category/channel mix, weekend vs weekday
- **Risk metrics**: fraud by segment/channel/category
- **Economics**: rewards effectiveness, profitability modeling
- Techniques: CTEs, window functions, percentiles, CTAS

### Step 5: Business Intelligence (Power BI)
- 5-page interactive dashboard:
  1. Portfolio Overview (KPIs, trends, profitability bands)
  2. Customer Segments (behavior, Pareto curve, utilization)
  3. Spend Patterns (category, channel, day-type analysis)
  4. Fraud & Risk (exposure by dimension)
  5. Rewards & Profitability (cost analysis, scatter plots, action framework)

---

## Key Discoveries

### 1. **Customer Segmentation & Pareto**
- **Emerging Affluent (20% of customers)**: 33% of spend, highly profitable → Retain & upsell
- **Mass Market (55%)**: Moderate spend(55% of total spend), positive profit → Stable base
- **Low Value (25%)**: Low engagement → They contribute only 13% of the total spend - Activation campaigns needed

### 2. Pareto Principle Validated
- Cumulative spend curve shows top customers drive majority value 
- 20% of the customers contribute to 56% of the total spend
-  **Monthly spend-to-limit trending up** (risk signal for some segments)
- **Implication**: Retention programs must prioritize Emerging Affluent segment

### 3. Spend Patterns
- Top Categories:
 - Shopping: 25% of spend
 - Groceries: 20%
 - Dining: 18%
 - Electronics: 15%
 - Fuel: 12%
- **Essential Categories** drive majority of the transactions
-**Online dominates**: 87% of spend vs 13% offline
- **Weekend = 68% of spend** (2x weekday)
- **Implication**: Lifestyle-driven portfolio; target weekend merchant categories

### 4. Fraud Concentration
- Low Value segment has a fraud rate of 0.502%, which is more than double the rate of the "Mass Market" (0.215%) and "Emerging Affluent" (0.230%) segments
- Fraud value highest in Mass Market
- **Fraud rate healthy** at 0.42% but concentrated in certain segments
- **Implication**: Risk-based authentication for Travel/Electronics/Online, Deploy advanced monitoring for high-value Mass Market transactions


### 5. **Rewards & Profitability**
- Cashback is the most expensive reward type
- Scatter analysis reveals many customers generate minimal profit
- Reward cost rises sharply for low-spend customers (inefficient)
- Profit is highly concentrated: Very High segment generates ~$163M
- **Implication**: Cap high-cost redemptions, redesign for profitability

---

## 💡 Business Impact

| Finding | Implication | Recommendation |
|---------|-------------|----------------|
| Mass Market contributes the largest share of total spend | Revenue concentration risk if engagement drops | Prioritize retention campaigns and credit limit optimization |
| Mass Market drives volume | Retention priority | Merchant partnerships |
| Weekend 68% of spend | Lifestyle focus | Schedule promotional campaigns and offers for weekends |
| Low Value segment accounts for the highest fraud frequency | High operational cost relative to revenue | Implement automated risk rules and low-cost fraud controls |
| Cashback is the highest reward cost driver | Potential margin erosion | Move to tiered or targeted rewards based on customer value |
| Groceries and Shopping dominate category spend | Everyday categories drive customer engagement | Strengthen merchant partnerships and category-specific offers |
| Profitability skewed to top bands | Revenue highly skewed toward a small customer base | Launch VIP tiers, personalized benefits, and proactive retention |

**Estimated Annual Impact**: 4–6% improvement in portfolio profitability through targeted rewards optimization, fraud reduction, and high-value customer retention initiatives

---

**[Next: Business Context →](02_Business_Context.md)**
