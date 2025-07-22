-- ========================
-- 1. Создание таблицы
-- ========================
CREATE TABLE IF NOT EXISTS bi_tools_demo.currency_conversions
(
    id UInt64,
    client_id UInt64,
    from_currency String,
    to_currency String,
    amount_from Float64,
    amount_to Float64,
    timestamp DateTime
)
ENGINE = MergeTree()
ORDER BY (client_id, timestamp);

-- ========================
-- 2. Наполнение тестовыми данными
-- ========================
INSERT INTO bi_tools_demo.currency_conversions (id, client_id, from_currency, to_currency, amount_from, amount_to, timestamp) VALUES
(1, 1001, 'USD', 'EUR', 1000.00, 915.00, toDateTime('2025-01-10 12:00:00')),
(2, 1001, 'EUR', 'USD', 500.00, 538.00, toDateTime('2025-01-20 10:00:00')),
(3, 1002, 'USD', 'GBP', 2000.00, 1570.00, toDateTime('2025-02-15 08:30:00')),
(4, 1002, 'GBP', 'USD', 300.00, 375.00, toDateTime('2025-02-20 14:00:00')),
(5, 1003, 'EUR', 'USD', 1200.00, 1315.00, toDateTime('2025-03-05 16:45:00')),
(6, 1003, 'USD', 'EUR', 500.00, 450.00, toDateTime('2025-03-10 09:15:00')),
(7, 1004, 'USD', 'GBP', 750.00, 590.00, toDateTime('2025-04-01 13:00:00')),
(8, 1004, 'GBP', 'USD', 200.00, 254.00, toDateTime('2025-04-12 11:30:00')),
(9, 1005, 'EUR', 'USD', 800.00, 875.00, toDateTime('2025-05-02 18:45:00')),
(10, 1005, 'USD', 'EUR', 400.00, 365.00, toDateTime('2025-05-03 19:00:00'));
