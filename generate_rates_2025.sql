-- Создаём базу
CREATE DATABASE IF NOT EXISTS bi_tools_demo;

-- Создаём таблицу
CREATE TABLE IF NOT EXISTS bi_tools_demo.rates
(
    rate_date Date,
    currency LowCardinality(String),
    rate_to_BYN Float32
)
ENGINE = MergeTree
ORDER BY (rate_date, currency);

-- Вставляем данные
INSERT INTO bi_tools_demo.rates
WITH
    -- Сгенерируем список дат за 2025
    arrayJoin(
        arrayMap(
            x -> toDate('2025-01-01') + x,
            range(
                0,
                dateDiff('day', toDate('2025-01-01'), toDate('2025-12-31')) + 1
            )
        )
    ) AS rate_date
SELECT
    rate_date,
    currency,
    CASE currency
        WHEN 'USD' THEN 3.1 + rand() % 40 / 100.0
        WHEN 'EUR' THEN 3.3 + rand() % 40 / 100.0
        WHEN 'GBP' THEN 3.7 + rand() % 40 / 100.0
    END AS rate_to_BYN
FROM
(
    -- Генерируем валюты
    SELECT 'USD' AS currency
    UNION ALL SELECT 'EUR'
    UNION ALL SELECT 'GBP'
) AS currencies
;
