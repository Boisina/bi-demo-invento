-- База данных
CREATE DATABASE IF NOT EXISTS bi_tools_demo;
USE bi_tools_demo;

-- Таблицы
CREATE TABLE IF NOT EXISTS clients
(
    client_id UInt32,
    full_name String,
    birth_date Date,
    country String
) ENGINE = MergeTree
ORDER BY client_id;

CREATE TABLE IF NOT EXISTS accounts
(
    account_id UInt32,
    client_id UInt32,
    account_type String,
    opened_date Date
) ENGINE = MergeTree
ORDER BY account_id;

CREATE TABLE IF NOT EXISTS bank_transactions
(
    transaction_id UInt32,
    account_id UInt32,
    transaction_type String,
    amount Float64,
    currency String,
    timestamp DateTime,
    merchant_category String
) ENGINE = MergeTree
ORDER BY transaction_id;

----------------------------------------
-- Чистим предыдущие данные
----------------------------------------
TRUNCATE TABLE clients;
TRUNCATE TABLE accounts;
TRUNCATE TABLE bank_transactions;

----------------------------------------
-- Генерация клиентов: 2500
----------------------------------------
INSERT INTO clients
SELECT
    number + 1 AS client_id,
    concat('Client_', toString(number + 1)) AS full_name,
    today() - INTERVAL (18 + intDiv(number, 50) % 40) * 365 DAY AS birth_date,
    arrayElement(['USA', 'UK', 'Germany', 'France', 'India', 'Brazil', 'Japan', 'Australia'], (number % 8) + 1) AS country
FROM numbers(2500);

----------------------------------------
-- Генерация счетов: примерно 2-5 на клиента
----------------------------------------
INSERT INTO accounts
SELECT
    number + 10001 AS account_id,
    1 + (number % 2500) AS client_id,
    arrayElement(['savings', 'checking', 'business'], (number % 3) + 1) AS account_type,
    toDate('2022-01-01') + INTERVAL (number % 730) DAY AS opened_date
FROM numbers(8000);

----------------------------------------
-- Генерация транзакций: ~180 000 штук
----------------------------------------
INSERT INTO bank_transactions
SELECT
    number + 500001 AS transaction_id,
    10001 + (number % 8000) AS account_id,
    arrayElement(['deposit', 'withdrawal', 'transfer', 'payment'], (number % 4) + 1) AS transaction_type,
    round(50 + (rand64() % 1000000) / 100.0, 2) AS amount,
    arrayElement(['USD', 'EUR', 'GBP', 'JPY', 'AUD'], (number % 5) + 1) AS currency,
    -- Timestamp в интервале 01.01.2025 - 01.07.2025
    toDateTime('2025-01-01 00:00:00') + INTERVAL (rand64() % (180 * 24 * 60 * 60)) SECOND AS timestamp,
    arrayElement(['groceries', 'utilities', 'salary', 'cash', 'travel', 'online', 'health', 'education'], (number % 8) + 1) AS merchant_category
FROM numbers(70000);
