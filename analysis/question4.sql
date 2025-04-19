-- 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

WITH price_changes AS (
  SELECT
    name,
    year,
    avg_price,
    LAG(avg_price) OVER (PARTITION BY name ORDER BY year) AS prev_avg_price,
    ((avg_price - LAG(avg_price) OVER (PARTITION BY name ORDER BY year)) / LAG(avg_price) OVER (PARTITION BY name ORDER BY year)) * 100 AS price_change_pct
  FROM temp_czechia_prices
  WHERE year BETWEEN 2006 AND 2018
),
salary_changes AS (
  SELECT
    payroll_year,
    avg_salary,
    LAG(avg_salary) OVER (ORDER BY payroll_year) AS prev_avg_salary,
    ((avg_salary - LAG(avg_salary) OVER (ORDER BY payroll_year)) / LAG(avg_salary) OVER (ORDER BY payroll_year)) * 100 AS salary_change_pct
  FROM temp_czechia_salaries
  WHERE payroll_year BETWEEN 2006 AND 2018
)
SELECT
  p.year,
  p.name,
  p.price_change_pct AS food_price_change_pct,
  s.salary_change_pct AS salary_change_pct
FROM price_changes p
JOIN salary_changes s ON p.year = s.payroll_year
WHERE p.price_change_pct > 10
ORDER BY p.year;
