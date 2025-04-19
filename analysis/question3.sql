-- 3. Která kategorie potravin zdražuje nejpomaleji (nejnižší percentuální meziroční nárůst)?

WITH price_changes AS (
  SELECT
    name,
    year,
    avg_price,
    LAG(avg_price) OVER (PARTITION BY name ORDER BY year) AS prev_avg_price,
    ((avg_price - LAG(avg_price) OVER (PARTITION BY name ORDER BY year)) / 
     LAG(avg_price) OVER (PARTITION BY name ORDER BY year)) * 100 AS price_change_pct
  FROM temp_czechia_prices
  WHERE year BETWEEN 2006 AND 2018
)
SELECT
  name,
  AVG(price_change_pct) AS avg_annual_change,
  MIN(price_change_pct) AS min_change,
  COUNT(CASE WHEN price_change_pct < 0 THEN 1 END) AS years_with_decrease
FROM price_changes
WHERE price_change_pct IS NOT NULL
GROUP BY name
ORDER BY avg_annual_change ASC;
