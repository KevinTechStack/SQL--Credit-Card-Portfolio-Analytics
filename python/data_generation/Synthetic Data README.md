# Synthetic Data (README)
## Data Dictionary + Generation Summary

---

## Purpose
This dataset is synthetically generated (Python) to simulate a multi-country credit card portfolio for analytics and visualization. It contains no real PII and is safe for public portfolio use.

---

## Synthetic Data Generation (Python)

**Why synthetic?** Privacy compliance (no real PII), safe to publish, reproducible, and controllable realism.  
**What was built**: 7 interconnected tables with realistic patterns.  
**Scale**: 10,000 unique customers across 7 countries, with 51,598 cards issued.  
**Merchant categories**: Shopping, Groceries, Dining, Electronics, Fuel, Travel.  
**Channels**: Online, Offline.  
**Realism**: weekend spend bias, seasonal patterns, fraud injection (portfolio-level fraud rate aligns to outputs).

**Realism features**
- Geographic spend patterns (INR dominant in India, AED in UAE, etc.)
- Seasonal spending (festival months, travel peaks)
- Dormant card-months (realistic inactivity)
- Income-correlated credit limits

Reference: [Synthetic Data Generation (Python)](../01_Executive_Summary.md#step-1-synthetic-data-generation-python)

---

## Entities & Grain

| Table | Grain | Description |
|------|------|-------------|
| customers | 1 row per customer | Demographics, geography, segment label |
| cards | 1 row per card | Card product, credit limits, fees, reward program |
| transactions | 1 row per transaction | Spend events across time/category/channel/currency |
| fraud_flags | 0–1 row per transaction | Fraud event marker + type |
| reward_redemptions | 1 row per redemption event | Reward redemption type and USD cost |
| payments | 1 row per payment event | Repayment behavior + delinquency |
| currency_conversion | 1 row per currency | FX mapping to normalize amounts to USD |

---

## Key relationships
- customers (1) → cards (M)
- cards (1) → transactions (M)
- transactions (1) → fraud_flags (0/1)
- cards (1) → reward_redemptions (M)
- cards (1) → payments (M)

---

## Notes on synthetic realism
The generator includes:

- Geographic spend patterns (INR dominant in India, AED in UAE, etc.)
- Seasonal spending (festival months, travel peaks)
- Dormant card-months (realistic inactivity)
- Income-correlated credit limits
- Fraud injection aligned to portfolio fraud rate (0.257%)
