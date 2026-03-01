-- =====================================
-- CREDIT CARD PORTFOLIO ANALYTICS DATABASE
-- =====================================

-- 1) Currency conversions

CREATE TABLE currency_conversion (
    currency_code      VARCHAR(10) PRIMARY KEY,
    conversion_to_usd  NUMERIC(10,4) NOT NULL
);

-- 2) Customers 

CREATE TABLE customers (
    customer_id       INT PRIMARY KEY,
    age               INT CHECK (age >= 18),
    income_band       VARCHAR(50),
    occupation        VARCHAR(100),
    city              VARCHAR(100),
    country           VARCHAR(100),
    customer_segment  VARCHAR(50),
    join_date         DATE,
    credit_score      INT CHECK (credit_score BETWEEN 300 AND 900)
);

-- 3) Cards

CREATE TABLE cards (
    card_id             INT PRIMARY KEY,
    customer_id         INT NOT NULL REFERENCES customers(customer_id),
    card_type           VARCHAR(50),
    credit_limit        NUMERIC(12,2),
    card_issue_date     DATE,
    annual_fee          NUMERIC(10,2),
    reward_program_type VARCHAR(50)
);

-- 4) Transactions
 
CREATE TABLE transactions (
    transaction_id    BIGINT PRIMARY KEY,
    card_id           INT NOT NULL REFERENCES cards(card_id),
    transaction_date  TIMESTAMP NULL,
    merchant_category VARCHAR(100),
    merchant_type     VARCHAR(50),
    currency          VARCHAR(10) REFERENCES currency_conversion(currency_code),
    amount            NUMERIC(12,2) NULL,
    transaction_type  VARCHAR(50),
    merchant_city     VARCHAR(100),
    merchant_country  VARCHAR(100),
    location          VARCHAR(100),
    is_international  BOOLEAN
);
-- 5) Payments

CREATE TABLE payments (
    payment_id          BIGINT PRIMARY KEY,
    card_id             INT NOT NULL REFERENCES cards(card_id),
    payment_date        DATE,
    payment_amount      NUMERIC(12,2),
    payment_method      VARCHAR(50),
    delinquency_status  VARCHAR(20)
);

-- 6) Reward redemptions

CREATE TABLE reward_redemptions (
    redemption_id     BIGINT PRIMARY KEY,
    card_id           INT NOT NULL REFERENCES cards(card_id),
    redemption_date   DATE,
    redemption_type   VARCHAR(100),
    points_used       INT,
    redemption_value  NUMERIC(10,2)
);

-- 7) Fraud flags

CREATE TABLE fraud_flags (
    fraud_id         BIGINT PRIMARY KEY,
    transaction_id   BIGINT NOT NULL REFERENCES transactions(transaction_id),
    fraud_flag       BOOLEAN,
    fraud_type       VARCHAR(100)
);
