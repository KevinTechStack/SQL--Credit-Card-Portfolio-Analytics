import pandas as pd
import numpy as np
import os
import time

# =============================
# TIMER + LOGGER
# =============================
start_time = time.time()

def log(msg):
    elapsed = round(time.time() - start_time, 2)
    print(f"[{elapsed}s] {msg}")

log("Realism adjustment script started")

# =========================
# PATH
# =========================
PATH = r"C:\\Users\\HP\\OneDrive\\Documents\\DATA ANALYST PORTFOLIO PROJECT\\Data_Python Generated"

log("Loading files...")

customers = pd.read_csv(os.path.join(PATH, "customers.csv"))
cards = pd.read_csv(os.path.join(PATH, "cards.csv"))
transactions = pd.read_csv(os.path.join(PATH, "transactions.csv"))
payments = pd.read_csv(os.path.join(PATH, "payments.csv"))
fraud = pd.read_csv(os.path.join(PATH, "fraud_flags.csv"))
redemptions = pd.read_csv(os.path.join(PATH, "reward_redemptions.csv"))

log(f"Customers: {len(customers)}")
log(f"Cards: {len(cards)}")
log(f"Transactions: {len(transactions)}")

transactions["transaction_date"] = pd.to_datetime(transactions["transaction_date"], errors="coerce")
payments["payment_date"] = pd.to_datetime(payments["payment_date"], errors="coerce")

np.random.seed(42)

# =====================================================
# 1. MULTIPLE CARDS PER CUSTOMER
# =====================================================
log("Step 1: Creating additional cards (20%)")

extra_cards = cards.sample(frac=0.20).copy()
extra_cards["card_id"] = range(cards["card_id"].max() + 1,
                               cards["card_id"].max() + 1 + len(extra_cards))
cards = pd.concat([cards, extra_cards], ignore_index=True)

log(f"Cards after expansion: {len(cards)}")

# =====================================================
# 2 & 10. REAL DORMANCY
# =====================================================
log("Step 2: Creating realistic dormant card-months (~8%)")

transactions["txn_month"] = transactions["transaction_date"].dt.to_period("M")

card_months = transactions[["card_id", "txn_month"]].drop_duplicates()
dormant_pairs = card_months.sample(frac=0.08, random_state=42)

before_txn = len(transactions)

transactions = transactions.merge(
    dormant_pairs,
    on=["card_id", "txn_month"],
    how="left",
    indicator=True
)

transactions = transactions[transactions["_merge"] == "left_only"]
transactions.drop(columns=["_merge"], inplace=True)

log(f"Transactions removed (dormancy): {before_txn - len(transactions)}")
log(f"Transactions remaining: {len(transactions)}")

# =====================================================
# 3–7. ALL ORIGINAL LOGIC
# =====================================================
log("Step 3: Applying seasonality, growth trend, and spikes")

transactions["month_num"] = transactions["transaction_date"].dt.month
transactions["year"] = transactions["transaction_date"].dt.year

transactions.loc[transactions["month_num"].isin([11, 12]), "amount"] *= 1.35
transactions.loc[transactions["month_num"].isin([2, 6]), "amount"] *= 0.75

transactions["months_since_start"] = (
    (transactions["year"] - transactions["year"].min()) * 12
    + transactions["month_num"]
)
transactions["amount"] *= (1 + transactions["months_since_start"] * 0.01)

spike_mask = np.random.rand(len(transactions)) < 0.02
transactions.loc[spike_mask, "amount"] *= np.random.uniform(2, 4)

log("Step 4: Weekend and online adjustments")

transactions["weekday"] = transactions["transaction_date"].dt.weekday
transactions.loc[transactions["weekday"] >= 5, "amount"] *= 1.2
transactions.loc[transactions["merchant_type"] == "Online", "amount"] *= 1.25

log("Step 5: Category distribution")

category_weights = {
    "Groceries": 0.25,
    "Fuel": 0.15,
    "Shopping": 0.20,
    "Dining": 0.15,
    "Travel": 0.10,
    "Electronics": 0.15
}

transactions["merchant_category"] = np.random.choice(
    list(category_weights.keys()),
    size=len(transactions),
    p=list(category_weights.values())
)

# =====================================================
# FRAUD 
# =====================================================
log("Step 6: Fraud calibration")

transactions["is_online"] = transactions["merchant_type"] == "Online"

base_prob = 0.002
prob = np.full(len(transactions), base_prob)

prob += np.where(
    (transactions["is_online"]) & (transactions["is_international"]),
    0.005, 0
)

cards_seg = cards.merge(
    customers[["customer_id", "customer_segment"]],
    on="customer_id", how="left"
)


for col in ["customer_segment", "customer_segment_x", "customer_segment_y"]:
    if col in transactions.columns:
        transactions.drop(columns=[col], inplace=True)


transactions = transactions.merge(
    cards_seg[["card_id", "customer_segment"]],
    on="card_id", how="left"
)

prob += np.where(transactions["customer_segment"] == "Low Value", 0.003, 0)

transactions["fraud_flag_new"] = (
    np.random.rand(len(transactions)) < prob
).astype(int)

fraud = transactions.loc[
    transactions["fraud_flag_new"] == 1,
    ["transaction_id"]
].copy()

fraud["fraud_id"] = range(1, len(fraud) + 1)
fraud["fraud_flag"] = 1
fraud["fraud_type"] = np.where(
    transactions.loc[transactions["fraud_flag_new"] == 1, "merchant_type"] == "Online",
    "Card Not Present",
    "Skimming"
)

log(f"Fraud records: {len(fraud)}")

# =====================================================
# 8. DELINQUENCY
# =====================================================
log("Step 7: Delinquency status")

threshold = payments["payment_amount"].median() * 0.3
payments["delinquency_status"] = np.where(
    payments["payment_amount"] < threshold,
    "30DPD",
    "Current"
)

# =====================================================
# 9. MISSINGNESS
# =====================================================
log("Step 8: Injecting missing values (~0.5%)")

for col in ["amount", "transaction_date"]:
    mask = np.random.rand(len(transactions)) < 0.005
    transactions.loc[mask, col] = np.nan

# =====================================================
# 13. REDEMPTIONS
# =====================================================
log("Step 9: Redemption behavior")

redeem_weights = {
    "Cashback": 0.55,
    "Gift Cards": 0.30,
    "Flights": 0.15
}

redemptions["redemption_type"] = np.random.choice(
    list(redeem_weights.keys()),
    size=len(redemptions),
    p=list(redeem_weights.values())
)

redemptions.loc[redemptions["redemption_type"] == "Flights", "redemption_value"] *= 1.8
redemptions.loc[redemptions["redemption_type"] == "Cashback", "redemption_value"] *= 0.8

# =====================================================
# CLEANUP
# =====================================================
log("Cleaning temporary columns")

transactions.drop(columns=[
    "txn_month",
    "month_num", "year", "months_since_start",
    "weekday", "is_online", "customer_segment", "fraud_flag_new"
], inplace=True, errors="ignore")

# =====================================================
# FIX INTEGER COLUMNS
# =====================================================
log("Fixing integer columns for PostgreSQL")

print("Missing transaction_id:", transactions["transaction_id"].isna().sum())
print("Missing card_id:", transactions["card_id"].isna().sum())

transactions = transactions.dropna(subset=["transaction_id", "card_id"])
cards = cards.dropna(subset=["card_id", "customer_id"])
payments = payments.dropna(subset=["card_id"])
redemptions = redemptions.dropna(subset=["card_id"])
fraud = fraud.dropna(subset=["transaction_id"])

transactions["transaction_id"] = transactions["transaction_id"].astype(int)
transactions["card_id"] = transactions["card_id"].astype(int)

cards["card_id"] = cards["card_id"].astype(int)
cards["customer_id"] = cards["customer_id"].astype(int)

payments["card_id"] = payments["card_id"].astype(int)
redemptions["card_id"] = redemptions["card_id"].astype(int)
fraud["transaction_id"] = fraud["transaction_id"].astype(int)

log(f"Transactions after ID cleanup: {len(transactions)}")

# =====================================================
# Force exacting CSV schema for Postgres COPY
# (prevents 'extra data after last expected column')
# =====================================================
log("Forcing Postgres COPY schema for transactions + FK-safe fraud export")

TXN_COLS = [
    "transaction_id", "card_id", "transaction_date", "merchant_category",
    "merchant_type", "currency", "amount", "transaction_type",
    "merchant_city", "merchant_country", "location", "is_international"
]

# Keep ONLY these columns and in this order
transactions = transactions[TXN_COLS].copy()

# FK-safe fraud (only transaction_ids that exist in final transactions)
valid_txn_ids = set(transactions["transaction_id"])
fraud = fraud[fraud["transaction_id"].isin(valid_txn_ids)].copy()
fraud = fraud.reset_index(drop=True)
fraud["fraud_id"] = range(1, len(fraud) + 1)
fraud = fraud[["fraud_id", "transaction_id", "fraud_flag", "fraud_type"]]

log("Saving files")

cards.to_csv(os.path.join(PATH, "cards.csv"), index=False)
transactions.to_csv(os.path.join(PATH, "transactions.csv"), index=False)
payments.to_csv(os.path.join(PATH, "payments.csv"), index=False)
fraud.to_csv(os.path.join(PATH, "fraud_flags.csv"), index=False)
redemptions.to_csv(os.path.join(PATH, "reward_redemptions.csv"), index=False)

log("All fixes applied successfully")
log("Script completed")
