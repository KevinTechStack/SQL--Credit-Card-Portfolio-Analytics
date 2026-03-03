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
- Focus merchant partnerships and new offers first on **Groceries, Shopping, and Fuel** (these are the largest spend categories). Use **Electronics** and **Dining** for targeted campaigns to drive additional, incremental spend.
- Treat online as the main growth channel (online spend is much higher). Keep the digital purchase flow smooth for genuine customers so you don’t lose transactions due to friction.
- Plan major campaigns around the **weekend-heavy spend pattern** (Fri–Sun). Use weekdays mainly for lighter-touch reminders and activation, instead of spending the full budget then.

### 2) Segment-led strategy (avoid one-size-fits-all)
| Segment | What the data says | Action |
|--------|---------------------|--------|
| Emerging Affluent | High spend per customer | Prioritize retention and upsell, offer tier benefits and premium bundles, and avoid unnecessary declines or extra steps that hurt experience |
| Mass Market | Largest base and spend engine | Run scalable offers in top categories, build strong merchant partnerships, **maintain a stable digital experience**, and monitor higher-value fraud exposure closely |
| Low Value | Lowest spend segment + highest fraud share | Use simple, low-cost messaging to increase usage, and rely mainly on automated fraud checks to manage cost-to-serve |

### 3) Fraud & risk: separate frequency controls from severity controls
- For **frequency-heavy** fraud areas (where fraud happens often): use automated controls like velocity checks, merchant/category rules, device/IP risk signals, and low-friction step-ups.
- For **severity-heavy** exposure (where the loss per event is higher, such as high-value activity): use stronger monitoring for unusual patterns and apply risk-based authentication on higher-value attempts.
- Operating principle: reduce fraud while avoiding extra steps or unnecessary declines for your highest-spending customers.

### 4) Rewards optimization: fix the biggest cost driver without hurting retention
- Start with cashback since it is the biggest redemption driver. Check whether low-spend customers are earning cashback at a level that is not economically justified.
- Move to a value-based rewards structure:
  - Link benefits to customer value/profit band.
  - Use spend thresholds (“value gates”) to unlock premium benefits.
  - Put caps on extreme reward-to-spend outliers.
- Track the **reward-to-spend ratio** to spot potential loss-making behavior early.
- Protect the **High** and strong **Mid** profit bands, while reducing leakage from low-spend or loss-making customers.

### 5) Profitability management: defend what produces profit
- Concentrate retention and service quality efforts on **Mid (100–1k)** and **High (1k–10k)** profit bands, since they generate most of the profit.
- For the **Loss** cohort (0.3K customers, -$0.02M profit):
  - Identify the main drivers (reward leakage, fraud exposure, servicing costs) and apply targeted fixes or restrictions, instead of broad cuts across the portfolio.

### 6) Monitoring and governance (what to track weekly/monthly)
- Revenue: spend by category, online vs offline mix, weekend uplift.
- Customer: segment movement over time, retention of top spend cohorts, activation of Low Value customers.
- Risk: fraud counts and fraud value by segment/category/channel; false-positive rate after control changes.
- Rewards: redemption mix, reward-to-spend outliers, reward-to-spend ratio trend by segment/profit band.
- Profit: customers and profit by band; movement into and out of the Loss band.

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
