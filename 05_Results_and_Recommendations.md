# Results & Recommendations
## Executive Actions Based on Portfolio Insights

---

## Results (What the analysis establishes)

### 1) Portfolio scale and performance baseline
- Customer base: **10,000** customers with **51,598** cards issued.
- Total Spend: **$508.31M** across **Jan 2024 → Dec 2025**, with **$21.18M** average monthly spend.

### 2) Revenue drivers are clear and actionable
- Spend is concentrated in essential categories:
  - **Groceries: $126M (24.71%)**
  - **Shopping: $103M (20.32%)**
  - **Fuel: $78M (15.41%)**
  - **Electronics: $76M (14.91%)**
  - **Dining: $76M (14.90%)**
  - **Travel: $50M (9.74%)**
- Channel economics show a digital-first portfolio by value:
  - **Online spend: $455.64M** vs **Offline spend: $52.67M**
  - Transactions are comparatively balanced: **Offline 1.26M** vs **Online 1.17M**
- Weekend behavior is highly skewed:
  - **Weekend spend share: 71.55%** vs **Weekday: 28.45%**

### 3) Segment contribution is uneven (and should drive strategy)
- Customer mix:
  - **Mass Market: 5K (54.3%)**
  - **Low Value: 3K (25.58%)**
  - **Emerging Affluent: 2K (20.12%)**
- Spend contribution:
  - **Mass Market: $282.87M**
  - **Emerging Affluent: $157M**
  - **Low Value: $68.44M**
- Spend concentration is meaningful (Pareto curve): **Top 20% customers contribute 57% of total spend**.

### 4) Fraud has different “frequency vs value” pockets
- Fraud share by segment (percent of fraud transactions):
  - **Low Value: 50.20%**
  - **Emerging Affluent: 23.00%**
  - **Mass Market: 21.50%**
- Fraud transaction counts by segment:
  - **Mass Market: 2.9K**
  - **Emerging Affluent: 1.8K**
  - **Low Value: 1.6K**
- Fraud value exposure is highest in Mass Market:
  - **Mass Market: $1.35M**
  - **Emerging Affluent: $0.77M**
  - **Low Value: $0.31M**
- Fraud counts by category are highest in everyday categories:
  - **Groceries: 1543**, **Shopping: 1213**, **Dining: 957**, **Fuel: 957**, **Electronics: 947**, **Travel: 646**

### 5) Rewards and profitability are measurable levers
- Rewards redemption volume is led by cashback:
  - **Cashback: 217K**, **Gift Cards: 144K**, **Flights: 129K**
- Profitability distribution:
  - Customers by band: **Mid 6.0K**, **Low 2.2K**, **High 1.5K**, **Loss 0.3K**
  - Profit by band: **Mid $2.55M**, **High $2.43M**, **Low $0.09M**, **Loss -$0.02M**
- Customer-level reward cost vs spend pattern indicates many customers cluster at lower spend levels while still incurring reward costs, which can become uneconomical without value-based tiering.

---

## Recommendations (What to do next)

### 1) Revenue growth: focus on the biggest levers
- Prioritize merchant partnerships and offer design around **Groceries, Shopping, Fuel** first (largest spend pools), and use **Electronics/Dining** for targeted incremental uplift.
- Treat online as the primary revenue channel (online value dominates); ensure digital purchase journeys remain friction-light for good customers.
- Run campaign around the observed **weekend-heavy spend** pattern (Fri–Sun), with weekday activity used for reminders/activation rather than main budget allocation.

### 2) Segment-led strategy (avoid one-size-fits-all)
- **Mass Market** (largest spend pool): run scalable value offers in top categories, ensure stable digital experience, and apply stronger monitoring for high-value fraud exposure.
- **Emerging Affluent** (high spend per customer): focus on retention + upgrades (tier benefits, premium bundles) and protect experience from unnecessary declines/friction.
- **Low Value** (highest fraud share): Use simple, low-cost messages to engage these customers and get them to use the card more, and rely mainly on automated fraud checks because fraud happens more often in this group and manual effort is costly.
- 
### 3) Fraud & risk: separate frequency controls from severity controls
- For **frequency-heavy** fraud pockets (high counts, especially everyday categories):
  - Use automated controls (velocity checks, merchant/category rules, device/IP signals, low-friction step-ups).
- For **severity-heavy** exposure (higher fraud value in Mass Market):
  - Apply risk-based authentication on high-value attempts and stronger monitoring for anomalous patterns.
- Adjust the fraud checks so you reduce fraud without creating extra steps or unnecessary declines for your highest-spending customers.

### 4) Rewards optimization: fix the biggest cost driver without hurting retention
- Start with cashback since it is the largest redemption volume driver; review whether cashback is being over-earned in low-spend customers.
- Introduce a value-based rewards structure:
  - Tie benefits by customer value/profit band.
  - Add spend thresholds for premium benefits.
  - Cap extreme reward-to-spend outliers.
- Protect the **High** and strong **Mid** profit bands while addressing leakage in low-spend or loss-making customers.

### 5) Profitability management: defend what produces profit
- Focus retention and service quality on **Mid (100–1k)** and **High (1k–10k)** profit bands because they contribute the majority of profit.
- For the **Loss** cohort (0.3K customers, -$0.02M profit):
  - Identify drivers (reward leakage, fraud exposure, servicing cost) and apply targeted restrictions or redesign rather than broad cuts.

### 6) Monitoring and governance (what to track weekly/monthly)
- Revenue: category-level spend, online vs offline spend mix, weekend uplift.
- Customer: segment migration, retention of top spend cohorts, activation of Low Value.
- Risk: fraud counts and value by segment/category/channel; false positive rate if you implement stricter controls.
- Rewards: redemption mix and reward-to-spend outliers.
- Profit: customer count and profit by band; movement into/out of Loss band.

---

## Implementation roadmap (practical sequencing)

1. **Quick wins**
   - Weekend-led campaigns in Groceries/Shopping/Fuel.
   - Cashback review: identify and cap obvious reward-to-spend outliers.

2. **Risk + rewards design**
   - Deploy frequency vs severity fraud rule sets.
   - Roll out rewards based on profit bands.

3. **Scale and refine**
   - Build segment-specific journeys (Mass Market scale offers, Emerging Affluent retention, Low Value activation + controls).
   - Track KPI movement and iterate thresholds/rules.

---

**Next: Next Steps →**
