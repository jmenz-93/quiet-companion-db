CREATE TABLE quiet_companion.accounts (
    account_number VARCHAR(50),
    ssn_primary VARCHAR(20),
    account_type VARCHAR(50),
    account_status VARCHAR(50),
    date_opened DATE,
    last_review_date DATE,
    custodian VARCHAR(100),
    assigned_advisor VARCHAR(100),
    investment_objective VARCHAR(100),
    risk_profile VARCHAR(50),
    time_horizon VARCHAR(50),
    tax_status VARCHAR(50),
    rebalance_frequency VARCHAR(50),
    market_value DECIMAL(18, 2),
    cost_basis DECIMAL(18, 2),
    cash_balance DECIMAL(18, 2),
    annual_contribution DECIMAL(18, 2),
    management_fee DECIMAL(5, 2),
    equity_allocation DECIMAL(5, 2),
    fixed_income_allocation DECIMAL(5, 2),
    alternatives_allocation DECIMAL(5, 2),
    margin_enabled BOOLEAN,
    options_approved BOOLEAN,
    beneficiary_designated BOOLEAN,
    esg_preference BOOLEAN
);

CREATE TABLE quiet_companion.addresses (
    account_number VARCHAR(50),
    ssn VARCHAR(20),
    street_address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(50),
    zip_code VARCHAR(20),
    country VARCHAR(50)
);

CREATE TABLE quiet_companion.clients (
    account_number VARCHAR(50),
    ssn VARCHAR(20),
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    date_of_birth DATE,
    age INT,
    marital_status VARCHAR(50),
    number_of_dependents INT,
    email_address VARCHAR(255),
    phone_number VARCHAR(50),
    citizenship_status VARCHAR(50),
    employment_status VARCHAR(50),
    occupation VARCHAR(100),
    employer_name VARCHAR(100),
    annual_income_bracket VARCHAR(100),
    estimated_net_worth_bracket VARCHAR(100),
    education_level VARCHAR(100),
    client_since DATE,
    politically_exposed_person BOOLEAN,
    finra_association BOOLEAN,
    kyc_verified BOOLEAN,
    aml_flag BOOLEAN,
    preferred_contact_method VARCHAR(50),
    communication_language VARCHAR(50)
);

CREATE TABLE quiet_companion.positions (
    account_number VARCHAR(50),
    ssn VARCHAR(20),
    account_type VARCHAR(50),
    ticker VARCHAR(20),
    security_name VARCHAR(255),
    asset_class VARCHAR(100),
    shares_units DECIMAL(18, 4),
    price DECIMAL(18, 2),
    market_value DECIMAL(18, 2),
    cost_basis DECIMAL(18, 2),
    unrealized_gain_loss_amount DECIMAL(18, 2),
    unrealized_gain_loss_percent DECIMAL(8, 2),
    percent_of_account DECIMAL(5, 2),
    as_of_date DATE
);

CREATE TABLE quiet_companion.trades (
    account_number VARCHAR(50),
    ssn VARCHAR(20),
    account_type VARCHAR(50),
    trade_date DATE,
    settlement_date DATE,
    action VARCHAR(50), --noqa
    ticker VARCHAR(20),
    security_name VARCHAR(255),
    asset_class VARCHAR(100),
    shares_units DECIMAL(18, 4),
    price DECIMAL(18, 2),
    gross_amount DECIMAL(18, 2),
    commission DECIMAL(18, 2),
    net_amount DECIMAL(18, 2),
    currency VARCHAR(10),
    trade_status VARCHAR(50),
    options_details VARCHAR(255),
    order_type VARCHAR(50),
    account_tax_status VARCHAR(50)
);
