-- 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období?

SELECT
  s.industry,
  s.year,
  s.avg_salary,
  p_milk.avg_price AS milk_price,
  p_bread.avg_price AS bread_price,
  (s.avg_salary / p_milk.avg_price) AS liters_of_milk,
  (s.avg_salary / p_bread.avg_price) AS kilograms_of_bread
FROM t_alina_maksimcikova_project_SQL_primary_final s
LEFT JOIN (
  SELECT year, AVG(avg_price) AS avg_price
  FROM temp_czechia_prices
  WHERE name = 'Mléko polotučné pasterované'
  GROUP BY year
) p_milk ON s.year = p_milk.year
LEFT JOIN (
  SELECT year, AVG(avg_price) AS avg_price
  FROM temp_czechia_prices
  WHERE name = 'Chléb konzumní kmínový'
  GROUP BY year
) p_bread ON s.year = p_bread.year
WHERE s.year IN (2006, 2018)
ORDER BY s.year;
