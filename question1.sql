-- 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

SELECT
  industry,
  year,
  avg_salary,
  ((avg_salary - LAG(avg_salary) OVER (PARTITION BY industry ORDER BY year)) / 
   LAG(avg_salary) OVER (PARTITION BY industry ORDER BY year)) * 100 AS salary_change_pct
FROM t_alina_maksimcikova_project_SQL_primary_final
WHERE year BETWEEN 2006 AND 2018
ORDER BY industry, year;
