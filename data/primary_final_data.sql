-- Vytvoření dočasné tabulky pro mzdy
-- Mzdy v jednotlivých odvětvích dle odvětví a roku

CREATE TEMP TABLE temp_czechia_salaries AS
SELECT
    cp.payroll_year,
    ib.name AS industry,
    AVG(cp.value) AS avg_salary
FROM czechia_payroll cp 
JOIN czechia_payroll_industry_branch ib
    ON cp.industry_branch_code = ib.code
WHERE cp.value_type_code = '5958'
GROUP BY 
    cp.payroll_year,
    ib.name;

-- Vytvoření dočasné tabulky pro ceny potravin
-- Ceny potravin dle kategorie a roku

CREATE TEMP TABLE temp_czechia_prices AS
SELECT
    EXTRACT(YEAR FROM p.date_from) AS year,
    cpc.name,
    avg(p.value) AS avg_price
FROM czechia_price p
JOIN czechia_price_category cpc 
    ON p.category_code = cpc.code
GROUP BY 
    p.date_from,
    cpc.name;

-- zjistim spravny nazev kategorie produktu, se kterymi pak budu pracovat
-- Mléko polotučné pasterované, Chléb konzumní kmínový


-- Vytvoření finální primární tabulky
CREATE TABLE t_alina_maksimcikova_project_SQL_primary_final AS 
SELECT
  s.payroll_year AS YEAR,
  s.industry,
  s.avg_salary,
  p_milk.avg_price AS milk_price,
  p_bread.avg_price AS bread_price
FROM temp_czechia_salaries s
LEFT JOIN (
  SELECT year, name, AVG(avg_price) AS avg_price
  FROM temp_czechia_prices
  GROUP BY year, name
) p_milk ON s.payroll_year = p_milk.year 
  AND p_milk.name = 'Mléko polotučné pasterované'
LEFT JOIN (
  SELECT year, name, AVG(avg_price) AS avg_price
  FROM temp_czechia_prices
  GROUP BY year, name
) p_bread ON s.payroll_year = p_bread.year 
  AND p_bread.name = 'Chléb konzumní kmínový'
WHERE s.payroll_year BETWEEN 2006 AND 2018;
