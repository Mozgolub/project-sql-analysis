-- Vytvoření sekundární tabulky pro EU data

CREATE TABLE t_alina_maksimcikova_project_SQL_secondary_final AS
SELECT
  e.country,
  e.year,
  e.gdp,
  e.population AS economy_population,
  e.gini,
  e.taxes,
  c.continent
FROM economies e
JOIN countries c ON e.country = c.country
WHERE c.continent = 'Europe'
  AND e.year BETWEEN 2006 AND 2018;

-- bylo potřeba vymezit roky, protože

SELECT DISTINCT year FROM temp_czechia_prices ORDER BY year; -- provnávat ceny můžeme jen 2006 až 2018
SELECT DISTINCT payroll_year FROM temp_czechia_salaries ORDER BY payroll_year; -- mzdy můžeme porovnávat 2000 až 2021
