-- 5. Má výška HDP vliv na změny ve mzdách a cenách potravin?

WITH hdp_changes AS (
  -- Výpočet změn HDP
  SELECT
    e.year,
    e.gdp,
    LAG(e.gdp) OVER (ORDER BY e.year) AS prev_gdp,
    CASE
      WHEN LAG(e.gdp) OVER (ORDER BY e.year) IS NOT NULL AND LAG(e.gdp) OVER (ORDER BY e.year) != 0
      THEN ((e.gdp - LAG(e.gdp) OVER (ORDER BY e.year)) / LAG(e.gdp) OVER (ORDER BY e.year)) * 100
      ELSE NULL
    END AS gdp_change_pct
  FROM t_alina_maksimcikova_project_SQL_secondary_final e
  WHERE e.country = 'Czech Republic'
  AND e.year BETWEEN 2006 AND 2018
),
price_changes AS (
  -- Výpočet změn cen mléka a chleba
  SELECT
    p.year,
    MAX(CASE WHEN p.name = 'Mléko polotučné pasterované' THEN p.price_change_pct END) AS milk_price_change_pct,
    MAX(CASE WHEN p.name = 'Chléb konzumní kmínový' THEN p.price_change_pct END) AS bread_price_change_pct
  FROM (
    SELECT
      p.year,
      p.name,
      p.avg_price,
      LAG(p.avg_price) OVER (PARTITION BY p.name ORDER BY p.year) AS prev_price,
      CASE
        WHEN LAG(p.avg_price) OVER (PARTITION BY p.name ORDER BY p.year) IS NOT NULL AND LAG(p.avg_price) OVER (PARTITION BY p.name ORDER BY p.year) != 0
        THEN ((p.avg_price - LAG(p.avg_price) OVER (PARTITION BY p.name ORDER BY p.year)) / LAG(p.avg_price) OVER (PARTITION BY p.name ORDER BY p.year)) * 100
        ELSE NULL
      END AS price_change_pct
    FROM temp_czechia_prices p
    WHERE p.year BETWEEN 2006 AND 2018
    AND p.name IN ('Mléko polotučné pasterované', 'Chléb konzumní kmínový')
  ) p
  GROUP BY p.year
),
salary_changes AS (
  -- Výpočet změn mezd
  SELECT
    s.payroll_year AS year,
    s.avg_salary,
    LAG(s.avg_salary) OVER (ORDER BY s.payroll_year) AS prev_salary,
    CASE
      WHEN LAG(s.avg_salary) OVER (ORDER BY s.payroll_year) IS NOT NULL AND LAG(s.avg_salary) OVER (ORDER BY s.payroll_year) != 0
      THEN ((s.avg_salary - LAG(s.avg_salary) OVER (ORDER BY s.payroll_year)) / LAG(s.avg_salary) OVER (ORDER BY s.payroll_year)) * 100
      ELSE NULL
    END AS salary_change_pct
  FROM temp_czechia_salaries s
  WHERE s.payroll_year BETWEEN 2006 AND 2018
)
-- Spojení všech dat do jednoho výsledku
SELECT
  h.year,
  h.gdp,
  h.gdp_change_pct,
  p.milk_price_change_pct,
  p.bread_price_change_pct,
  s.salary_change_pct
FROM hdp_changes h
LEFT JOIN price_changes p ON h.year = p.year
LEFT JOIN salary_changes s ON h.year = s.year
GROUP BY h.year, h.gdp, h.gdp_change_pct, p.milk_price_change_pct, p.bread_price_change_pct, s.salary_change_pct
ORDER BY h.year;
