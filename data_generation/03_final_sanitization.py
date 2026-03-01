import pandas as pd
import os

# =========================
# CONFIGURATION
# =========================
PATH = r"C:\Users\HP\OneDrive\Documents\DATA ANALYST PORTFOLIO PROJECT\Data_Python Generated"

def audit_log(section, result):
    print(f"--- {section.upper()} ---")
    print(result)
    print("\n")

# Load Sanitized Files
transactions = pd.read_csv(os.path.join(PATH, "transactions.csv"))
cards = pd.read_csv(os.path.join(PATH, "cards.csv"))
customers = pd.read_csv(os.path.join(PATH, "customers.csv"))

# Convert dates for trend analysis
transactions['transaction_date'] = pd.to_datetime(transactions['transaction_date'])

# =====================================================
# 1. THE "BILLION DOLLAR" CHECK
# =====================================================
total_spend = transactions['amount'].sum()
avg_txn = transactions['amount'].mean()

audit_log("Portfolio Financials", 
          f"Total Portfolio Spend: ${total_spend:,.2f}\n"
          f"Average Transaction Value (ATV): ${avg_txn:.2f}")

# =====================================================
# 2. SEGMENT REALISM CHECK
# =====================================================
# Merge to check spend by segment
df_audit = transactions.merge(cards[['card_id', 'customer_id']], on='card_id')
df_audit = df_audit.merge(customers[['customer_id', 'customer_segment']], on='customer_id')

segment_summary = df_audit.groupby('customer_segment').agg(
    Total_Spend=('amount', 'sum'),
    Txn_Count=('transaction_id', 'count'),
    Avg_Spend_Per_Txn=('amount', 'mean')
).round(2)

audit_log("Segment Performance", segment_summary)

# =====================================================
# 3. SPIKE & SEASONALITY CHECK (Nov vs Dec 2025)
# =====================================================
transactions['year_month'] = transactions['transaction_date'].dt.to_period('M')
monthly_trend = transactions.groupby('year_month')['amount'].sum()

# Compare last two months to ensure the spike is no longer a 'wall'
nov_25 = monthly_trend.loc['2025-11']
dec_25 = monthly_trend.loc['2025-12']
spike_ratio = dec_25 / nov_25

audit_log("Trend Analysis", 
          f"Nov 2025 Spend: ${nov_25:,.2f}\n"
          f"Dec 2025 Spend: ${dec_25:,.2f}\n"
          f"Spike Intensity (Dec/Nov): {spike_ratio:.2f}x")

# =====================================================
# 4. DATA INTEGRITY CHECK
# =====================================================
duplicate_txns = transactions['transaction_id'].duplicated().sum()
null_amounts = transactions['amount'].isna().sum()

audit_log("Integrity & Hygiene", 
          f"Duplicate Transaction IDs: {duplicate_txns}\n"
          f"Missing/Null Amounts: {null_amounts}")
