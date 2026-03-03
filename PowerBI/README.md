# Power BI Notes
## credit_card_portfolio.pbix

---

## How to open
1. Download **PowerBI/CC_PORTFOLIO_ANALYSIS_new.pbix** from [`PowerBI/CC_PORTFOLIO_ANALYSIS_new.pbix`](../PowerBI/)
2. Open in **Power BI Desktop**
3. Use the page tabs to navigate across the 5 dashboard pages

> Note: `.pbix` is a binary file. GitHub won’t preview it—open the file and click **Download** (or **Raw**) to get the PBIX

---

## KPI definitions (must match SQL)
- **Total Customers**: distinct customers in `customers`
- **Cards issued**: count of `card_id` in `cards`
- **Total Spend (USD)**: sum of `transactions.amount_usd`
- **Avg Monthly Spend (USD)**: average of monthly spend across the time window
- **Fraud Rate (%)**: fraud transactions / total transactions * 100

---

## Model notes
- Portfolio is multi-country and multi-currency; all amounts are normalized to **USD** using conversion mapping.
- Customers can hold multiple cards (expected and intentionally modeled).

---

## Refresh / reproducibility
To reproduce the dataset:
- Generate synthetic data using [python/data_generation/](../python/data_generation/)
- Load into PostgreSQL
- Execute:
  - [`sql/01_schema.sql`](../sql/01_schema.sql)
  - [`sql/02_sanity_checks.sql`](../sql/02_sanity_checks.sql)
  - [`sql/03_analysis_queries.sql`](../sql/03_analysis_queries.sql)
- Refresh Power BI model and validate KPI alignment (Total Spend, Fraud Rate, Pareto %)

