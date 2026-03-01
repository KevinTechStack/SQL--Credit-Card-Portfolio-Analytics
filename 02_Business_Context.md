# Business Context
## XYZ Bank Credit Card Division – Mass Market Portfolio

---

## 🏦 Company & Portfolio Overview

**XYZ Bank** is an international retail bank issuing **Mass Market credit cards** across **7 countries**.  
This project builds a **Portfolio Intelligence System** to enable data-driven decisions across **revenue growth, risk management, customer retention, and product optimization**

### Portfolio snapshot (from this project)
| Metric | Value |
|--------|-------|
| **Customers** | 50,000 |
| **Total Spend** | $44.85M USD |
| **Transactions** | 2M+ |
| **Fraud Rate** | 0.42% |
| **Geographies** | India, UAE, UK, Europe, Turkey, Qatar |

### Customer segments (observed in analysis)
| Segment | % Customers | % Spend | Key takeaway |
|---------|-------------|---------|--------------|
| **Mass Market** | 55% | 55% | Largest volume; stable base; revenue concentration risk |
| **Emerging Affluent** | 20% | 33% | High value per customer; best ROI for retention and upsell |
| **Low Value** | 25% | 13% | Low engagement; highest fraud frequency; activation + risk controls needed |

---

## 🎯 Strategic Objectives

### Primary goal
Build a **Portfolio Intelligence System** to improve revenue and reduce losses by understanding **spend behavior, fraud risk, reward economics, and profitability concentration**.

---

## 1) Revenue Growth

**Business reality**:
- **Mass Market** drives portfolio spend (volume engine).
- **Emerging Affluent** delivers the highest value per customer (highest ROI for upsell).

**Key questions**
- Which categories and channels drive the most spend?
- What is the weekend vs weekday behavior?
- What is the digital adoption level and how does it affect strategy?

**Target outcomes (examples)**
- Increase Low Value activation (raise engagement and spend contribution).
- Increase Emerging Affluent penetration through upgrades and cross-sell.

---

## 2) Fraud & Risk Management

**Business reality**:
- Fraud frequency is concentrated in **Low Value** (highest fraud rate).
- Fraud value exposure is highest in **Mass Market** (highest fraud value).

**Key questions**
- Fraud rate by segment/channel/category?
- Concentration in Travel/Electronics/Online?
- Is utilization (spend-to-limit) trending upward and indicating stress?

**Target outcome (example)**
- Reduce fraud rate from **0.42% → 0.28%** (~33% improvement).

---

## 3) Rewards Optimization

**Business reality**:
- Cashback is the **largest reward cost driver**.
- Reward cost rises sharply for low-spend customers (inefficient economics).

**Key questions**
- Reward cost by redemption type?
- Which customers have reward-to-spend > 4%?
- How does profitability vary by segment?

**Target outcome (example)**
- Reduce reward cost from **2.1% → 1.5%** of spend.

---

## 4) Customer Lifecycle Management

**Business reality**:
- Pareto behavior exists: top customers contribute a majority of spend.
- Retention focus should prioritize **Emerging Affluent** and top spend percentiles.

**Key questions**
- Validate Pareto distribution (20% → 56% of spend)?
- What differentiates high-value customers?
- Where do Low Value customers drop off (activation barriers)?

**Target outcome (example)**
- Improve top 20% retention from **92% → 97%**.

---

## 🌍 Multi-Country Complexity

### Currency and standardization
Transactions occur across multiple currencies (INR, AED, EUR, GBP, TRY, QAR, USD).  
For cross-country comparability, all monetary values are normalized to **USD** for analytics.

### Regulatory environment (high-level)
- India: RBI
- UAE: DFSA
- UK: FCA
- Europe: GDPR

### Why synthetic data (explicit)
This project uses **synthetic data generated via Python** to avoid privacy/compliance issues and to ensure the dataset is shareable, reproducible, and safe for public portfolio use.

---

## ✅ Success Criteria

| Objective | KPI | Target |
|-----------|-----|--------|
| Revenue | Low Value spend share | 13% → 25% |
| Risk | Fraud rate | 0.42% → 0.28% |
| Rewards | Reward cost (% of spend) | 2.1% → 1.5% |
| Retention | Top 20% retention | 92% → 97% |

---

**[Next: Data Model →](03_Data_Model.md)**
