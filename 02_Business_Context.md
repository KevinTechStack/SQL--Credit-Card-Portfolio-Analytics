# Business Context
## XYZ Bank Credit Card Division – Mass Market Portfolio

---

## 🏦 Company & Portfolio Overview

**XYZ Bank** is an international retail bank issuing **Mass Market credit cards** across **7 countries**.  
This project builds a **Portfolio Intelligence System** to enable data-driven decisions across **revenue growth, risk management, customer retention, and product optimization**.

### Portfolio snapshot (from this project)
| Metric | Value |
|--------|-------|
| **Customers (unique)** | **10,000** |
| **Cards issued** | **51,598** |
| **Total Spend (USD)** | **$508.31M** |
| **Avg Monthly Spend (USD)** | **$21.18M** |
| **Time Window** | Jan 2024 → Dec 2025 |
| **Fraud Rate (overall)** | **0.42%** |
| **Geographies** | India, UAE, UK, Europe, Turkey, Qatar |

> Multi-card ownership is intentional and reflects real portfolio design (product stacking, co-branded cards, premium upgrades).

---

## Customer Segments (observed in analysis)

| Segment | % Customers | Spend (USD) | Business meaning |
|---------|-------------|-------------|------------------|
| **Mass Market** | ~54.3% | ~**$280M** | Largest volume engine; stable base; protect engagement and manage high-value fraud exposure |
| **Emerging Affluent** | ~20.1% | ~**$160M** | Highest value per customer; best ROI for retention and upsell |
| **Low Value** | ~25.6% | ~**$70M** | Low engagement; highest fraud frequency; activation + cost-efficient controls needed |

---

## 🎯 Strategic Objectives

### Primary goal
Build a **Portfolio Intelligence System** to improve revenue and reduce losses by understanding **spend behavior, fraud risk, reward economics, and profitability concentration**.

---

## 1) Revenue Growth

**Business reality**
- **Mass Market** drives the largest spend contribution and portfolio stability.
- **Emerging Affluent** delivers the highest value per customer and is the best upsell target.

**Key questions**
- Which merchant categories drive the majority of spend and transactions?
- What is the channel split (online vs offline), and how does it influence product strategy?
- What is the weekend effect, and how should campaigns be timed?
- How concentrated is spend (Pareto) and who are the key customers?

**Target outcomes (examples)**
- Protect Mass Market retention and grow spend through limit management and merchant partnerships.
- Increase Emerging Affluent penetration via premium tiers and personalized benefits.

---

## 2) Fraud & Risk Management

**Business reality**
- Fraud frequency is concentrated in **Low Value** (≈50% of fraud cases).
- Fraud value exposure is highest in **Mass Market** (~$1.35M).

**Key questions**
- Fraud rate by segment, merchant category, and channel?
- Which categories create the most fraud volume (frequency) vs high fraud value?
- How do we reduce fraud without adding friction for top customers?
- Are utilization/spend-to-limit trends signaling stress?

**Target outcome (example)**
- Reduce fraud rate from **0.42% → 0.28%** (~33% improvement).

---

## 3) Rewards Optimization

**Business reality**
- Cashback is the largest redemption driver (highest volume).
- Reward costs rise sharply among low-spend customers (inefficient economics).
- Profit is concentrated in a subset of customers (Mid/High bands dominate).

**Key questions**
- Reward cost by redemption type?
- Which customers have reward-to-spend ratios that destroy margin?
- What changes improve profitability without harming retention?

**Target outcome (example)**
- Reduce reward cost from **2.1% → 1.5%** of spend.

---

## 4) Customer Lifecycle Management

**Business reality**
- Spend concentration exists (Pareto curve: top percentiles drive most value).
- Weekend-heavy, online-heavy portfolio suggests lifestyle patterns and digital dependence.
- Spend-to-limit increases in later periods (potential early warning signal).

**Key questions**
- Which customers drive the top spend percentiles?
- What behaviors predict high value (category mix, channel, activity frequency)?
- Where do Low Value customers drop off and why?

**Target outcome (example)**
- Improve top customer retention from **92% → 97%**.

---

## 🌍 Multi-Country Complexity

### Currency and standardization
Transactions occur across multiple currencies (INR, AED, EUR, GBP, TRY, QAR, USD).  
For cross-country comparability, all monetary values are standardized to **USD** for analytics.

### Regulatory environment (high-level)
- India: RBI
- UAE: DFSA
- UK: FCA
- Europe: GDPR

### Why synthetic data (explicit)
This project uses **synthetic data generated via Python** to avoid privacy/compliance issues while maintaining realistic portfolio patterns (segments, multi-card ownership, channel mix, fraud injection, and rewards redemption behavior).

---

## ✅ Success Criteria

| Objective | KPI | Target |
|-----------|-----|--------|
| Revenue | Emerging Affluent share uplift | 33% → 40%+ |
| Risk | Fraud rate | 0.42% → 0.28% |
| Rewards | Reward cost (% of spend) | 2.1% → 1.5% |
| Retention | Top customer retention | 92% → 97% |

---

**[Next: Data Model →](03_Data_Model.md)**
