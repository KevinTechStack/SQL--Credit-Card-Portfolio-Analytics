import pandas as pd
import numpy as np
import random
from datetime import datetime, timedelta
import os
import time

# =============================
# TIMER + LOGGER
# =============================

start_time = time.time()

def log(msg):
    elapsed = round(time.time() - start_time, 2)
    print(f"[{elapsed}s] {msg}")

log("Script started")

# =============================
# CONFIG
# =============================

OUTPUT_PATH = r"C:\Users\HP\OneDrive\Documents\DATA ANALYST PORTFOLIO PROJECT\Data_Python Generated"
os.makedirs(OUTPUT_PATH, exist_ok=True)

NUM_CUSTOMERS = 10000
START_DATE = datetime(2024, 1, 1)
END_DATE = datetime(2025, 12, 31)

np.random.seed(42)
random.seed(42)

log("Configuration loaded and output path verified")

# =============================
# GEOGRAPHY
# =============================

cities = {
    "UAE": ["Dubai", "Abu Dhabi"],
    "Qatar": ["Doha"],
    "UK": ["London"],
    "Germany": ["Berlin"],
    "France": ["Paris"],
    "India": ["Mumbai"]
}

country_currency = {
    "UAE": "AED",
    "Qatar": "QAR",
    "UK": "GBP",
    "Germany": "EUR",
    "France": "EUR",
    "India": "INR"
}

currency_conversion = {
    "USD": 1.0,
    "AED": 0.27,
    "QAR": 0.27,
    "GBP": 1.25,
    "EUR": 1.10,
    "INR": 0.012
}

currency_df = pd.DataFrame([
    {"currency_code": k, "conversion_to_usd": v}
    for k, v in currency_conversion.items()
])

log("Currency conversion table created")

# =============================
# CUSTOMER LOGIC
# =============================

segments = ["Low Value", "Mass Market", "Emerging Affluent"]
segment_weights = [0.25, 0.55, 0.20]

income_bands = {
    "Low Value": ["Low"],
    "Mass Market": ["Medium"],
    "Emerging Affluent": ["High"]
}

credit_score_ranges = {
    "Low Value": (550, 650),
    "Mass Market": (650, 750),
    "Emerging Affluent": (720, 850)
}

occupations = ["Salaried", "Self-employed", "Business", "Student"]

customers = []

for cid in range(1, NUM_CUSTOMERS + 1):
    segment = np.random.choice(segments, p=segment_weights)
    country = random.choice(list(cities.keys()))
    city = random.choice(cities[country])

    age = np.random.randint(21, 65)
    credit_low, credit_high = credit_score_ranges[segment]

    customers.append({
        "customer_id": cid,
        "age": age,
        "income_band": random.choice(income_bands[segment]),
        "occupation": random.choice(occupations),
        "city": city,
        "country": country,
        "customer_segment": segment,
        "join_date": START_DATE - timedelta(days=random.randint(0, 1500)),
        "credit_score": np.random.randint(credit_low, credit_high)
    })

customers_df = pd.DataFrame(customers)

# Controlled missing values (<1%)
customers_df.loc[customers_df.sample(frac=0.005).index, "occupation"] = None

log(f"Customers generated: {len(customers_df)}")

# =============================
# CARDS TABLE
# =============================

card_types = {
    "Low Value": ["Basic"],
    "Mass Market": ["Basic", "Gold"],
    "Emerging Affluent": ["Gold", "Platinum"]
}

credit_limits = {
    "Basic": (1000, 3000),
    "Gold": (3000, 8000),
    "Platinum": (8000, 20000)
}

annual_fees = {
    "Basic": 0,
    "Gold": 100,
    "Platinum": 300
}

reward_programs = ["Cashback", "Travel", "Points"]

cards = []
card_id = 1

for _, cust in customers_df.iterrows():
    card_type = random.choice(card_types[cust["customer_segment"]])
    low, high = credit_limits[card_type]

    cards.append({
        "card_id": card_id,
        "customer_id": cust["customer_id"],
        "card_type": card_type,
        "credit_limit": np.random.randint(low, high),
        "card_issue_date": cust["join_date"] + timedelta(days=random.randint(0, 60)),
        "annual_fee": annual_fees[card_type],
        "reward_program_type": random.choice(reward_programs)
    })
    card_id += 1

cards_df = pd.DataFrame(cards)

log(f"Cards generated: {len(cards_df)}")

# =============================
# TRANSACTIONS + PAYMENTS + FRAUD + REWARDS
# =============================

date_range = pd.date_range(START_DATE, END_DATE, freq="MS")
merchant_categories = ["Groceries", "Travel", "Dining", "Electronics", "Fuel", "Shopping"]

transactions = []
payments = []
frauds = []
redemptions = []

txn_id = 1
payment_id = 1
fraud_id = 1
redeem_id = 1

total_cards = len(cards_df)
log("Starting transaction generation...")

for i, (_, card) in enumerate(cards_df.iterrows(), 1):

    if i % 500 == 0:
        log(f"Processed {i}/{total_cards} cards")

    cust = customers_df.loc[customers_df.customer_id == card["customer_id"]].iloc[0]

    balance = 0
    missed_streak = 0

    for month in date_range:

        # Segment-based transaction volume
        if cust["customer_segment"] == "Low Value":
            txn_count = np.random.randint(8, 15)
        elif cust["customer_segment"] == "Mass Market":
            txn_count = np.random.randint(15, 30)
        else:
            txn_count = np.random.randint(25, 45)

        monthly_spend = 0

        for _ in range(txn_count):

            # Age bias: younger more online
            if cust["age"] < 35:
                merchant_type = np.random.choice(["Online", "Offline"], p=[0.65, 0.35])
            else:
                merchant_type = np.random.choice(["Online", "Offline"], p=[0.40, 0.60])

            # International bias
            intl_prob = 0.05
            if cust["customer_segment"] == "Emerging Affluent":
                intl_prob = 0.15

            is_intl = np.random.rand() < intl_prob

            if is_intl:
                merchant_country = random.choice(list(cities.keys()))
                merchant_city = random.choice(cities[merchant_country])
            else:
                merchant_country = cust["country"]
                merchant_city = cust["city"]

            currency = country_currency[merchant_country]

            # Cash advance bias
            if cust["customer_segment"] == "Low Value":
                txn_type = np.random.choice(["Purchase", "Cash Advance"], p=[0.85, 0.15])
            else:
                txn_type = np.random.choice(["Purchase", "Cash Advance"], p=[0.95, 0.05])

            # Amount logic
            if txn_type == "Cash Advance":
                amount = np.random.uniform(100, 500)
            else:
                amount = np.random.uniform(10, 300)

            # Outlier (<1%)
            if np.random.rand() < 0.005:
                amount *= random.randint(5, 10)

            monthly_spend += amount

            fraud_prob = 0.002
            if is_intl and merchant_type == "Online":
                fraud_prob += 0.005
            if cust["customer_segment"] == "Low Value":
                fraud_prob += 0.003

            fraud_flag = np.random.rand() < fraud_prob

            transactions.append({
                "transaction_id": txn_id,
                "card_id": card["card_id"],
                "transaction_date": month + timedelta(days=random.randint(0, 27)),
                "merchant_category": random.choice(merchant_categories),
                "merchant_type": merchant_type,
                "currency": currency,
                "amount": round(amount, 2),
                "transaction_type": txn_type,
                "merchant_city": merchant_city,
                "merchant_country": merchant_country,
                "location": merchant_city,
                "is_international": is_intl
            })

            if fraud_flag:
                frauds.append({
                    "fraud_id": fraud_id,
                    "transaction_id": txn_id,
                    "fraud_flag": 1,
                    "fraud_type": "Card Not Present" if merchant_type == "Online" else "Skimming"
                })
                fraud_id += 1

            txn_id += 1

        # ===== Revolving balance logic =====
        balance += monthly_spend
        utilization = balance / card["credit_limit"]

        # Payment behavior linked to risk
        if utilization > 0.8 and np.random.rand() < 0.25:
            payment_amount = balance * np.random.uniform(0.05, 0.2)
            missed_streak += 1
        else:
            payment_amount = balance * np.random.uniform(0.3, 0.8)
            missed_streak = 0

        balance = max(balance - payment_amount, 0)

        payments.append({
            "payment_id": payment_id,
            "card_id": card["card_id"],
            "payment_date": month + timedelta(days=25),
            "payment_amount": round(payment_amount, 2),
            "payment_method": random.choice(["Auto Debit", "Manual", "Bank Transfer"])
        })

        payment_id += 1

        # Reward redemption (~10% monthly chance)
        if random.random() < 0.1:
            points = np.random.randint(500, 5000)
            redemptions.append({
                "redemption_id": redeem_id,
                "card_id": card["card_id"],
                "redemption_date": month + timedelta(days=20),
                "redemption_type": random.choice(["Flights", "Cashback", "Gift Cards"]),
                "points_used": points,
                "redemption_value": round(points * 0.01, 2)
            })
            redeem_id += 1

# =============================
# DATAFRAMES
# =============================

transactions_df = pd.DataFrame(transactions)
payments_df = pd.DataFrame(payments)
fraud_df = pd.DataFrame(frauds)
redemptions_df = pd.DataFrame(redemptions)

log(f"Transactions generated: {len(transactions_df)}")
log(f"Payments generated: {len(payments_df)}")
log(f"Fraud records generated: {len(fraud_df)}")
log(f"Reward redemptions generated: {len(redemptions_df)}")

# =============================
# SAVE FILES
# =============================

log("Saving files...")

customers_df.to_csv(os.path.join(OUTPUT_PATH, "customers.csv"), index=False)
cards_df.to_csv(os.path.join(OUTPUT_PATH, "cards.csv"), index=False)
transactions_df.to_csv(os.path.join(OUTPUT_PATH, "transactions.csv"), index=False)
payments_df.to_csv(os.path.join(OUTPUT_PATH, "payments.csv"), index=False)
fraud_df.to_csv(os.path.join(OUTPUT_PATH, "fraud_flags.csv"), index=False)
redemptions_df.to_csv(os.path.join(OUTPUT_PATH, "reward_redemptions.csv"), index=False)
currency_df.to_csv(os.path.join(OUTPUT_PATH, "currency_conversions.csv"), index=False)

log("All 7 tables saved successfully")
log(f"Location: {OUTPUT_PATH}")
log("Script completed")
