--Skript pro vytvoření primární tabulky na zodpovídání výzkumných dotazů: t_ondrej_spalek_project_SQL_primary_final

CREATE TABLE t_ondrej_spalek_project_SQL_primary_final  AS
WITH avg_payroll AS (
SELECT
	cpib."name"  AS industry_name,
	cp.industry_branch_code,
	cp.payroll_year, 
    ROUND (AVG(cp.value) :: NUMERIC ,2) AS average_value 
FROM czechia_payroll cp 
LEFT JOIN czechia_payroll_industry_branch cpib
ON cpib.code = cp.industry_branch_code 
WHERE value_type_code = '5958'
AND calculation_code = '200'
GROUP BY 
	cpib."name",
	cp.industry_branch_code,
	cp.payroll_year
),
food_price AS (
	SELECT 
   	 	cpc.name,
    	cp.category_code, 
    	DATE_PART('year', cp.date_from) AS rok,
    	ROUND(AVG(cp.value)::NUMERIC, 2) AS average_value_item
	FROM czechia_price cp
	LEFT JOIN czechia_price_category cpc 
    	ON cp.category_code = cpc.code 
	--WHERE cp.region_code IS NOT NULL
	GROUP BY 	
		cpc.name, 
		cp.category_code, 
		DATE_PART('year', cp.date_from)
)
SELECT *
FROM avg_payroll
LEFT JOIN food_price 
ON food_price.rok = avg_payroll.payroll_year;

--Skript pro vytvoření sekundární tabulky na zodpovídání výzkumných dotazů: t_ondrej_spalek_project_SQL_secondary_final

CREATE TABLE t_ondrej_spalek_project_SQL_secondary_final AS
SELECT 
    country,
    year,
    gdp,
    population,
    (gdp - LAG(gdp) OVER (ORDER BY "year")) / LAG(gdp) OVER (ORDER BY "year") * 100 AS gdp_percentage_change
FROM 
    economies e
WHERE 
    country = 'Czech Republic'
    AND gdp IS NOT NULL
    AND YEAR BETWEEN 2006 AND 2018
ORDER BY 
    "year";



--1) Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
SELECT 
    payroll_year, 
    industry_name, 
    ROUND(AVG(average_value)::NUMERIC, 2) AS average_salary
FROM t_ondrej_spalek_project_SQL_primary_final
WHERE 
	industry_name IS NOT NULL 
GROUP BY 
	payroll_year, 
	industry_name
ORDER BY 
	payroll_year, 
	industry_name;


--2) Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
SELECT 
    rok,
    name,
    ROUND(SUM(average_value) / COUNT(payroll_year), 2) AS average_salary_year,
    average_value_item,
   	ROUND (((ROUND(SUM(average_value) / COUNT(payroll_year), 0))/ average_value_item),2) AS number_of_items 
FROM t_ondrej_spalek_project_SQL_primary_final
WHERE 
    rok = 2006
    AND name IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované')
GROUP BY 
    rok,
    name,
    average_value_item
UNION ALL
SELECT 
    rok,
    name,
    ROUND(SUM(average_value) / COUNT(payroll_year), 2) AS average_salary_year,
    average_value_item,
   ROUND (((ROUND(SUM(average_value) / COUNT(payroll_year), 0))/ average_value_item),2) AS number_of_items 
FROM t_ondrej_spalek_project_SQL_primary_final
WHERE 
    rok = 2018
    AND name IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované')
GROUP BY 
    rok,
    name,
    average_value_item;
   

--3) Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
SELECT
	rok,
	name AS item_name,
   	ROUND (AVG(average_value_item),2) AS this_year_value,
    ROUND (LAG(AVG(average_value_item)) OVER (PARTITION BY category_code ORDER BY rok),2) AS previous_year_value,
    ROUND ((AVG(average_value_item) - LAG(AVG(average_value_item)) OVER (PARTITION BY category_code ORDER BY rok)) / LAG(AVG(average_value_item)) OVER (PARTITION BY category_code ORDER BY rok) * 100,2) AS percentage_change
FROM t_ondrej_spalek_project_SQL_primary_final
WHERE name IS NOT NULL 
GROUP BY 
    rok, 
    category_code, 
    name
ORDER BY 
   	name,
   	rok ASC, 
   	percentage_change;

-- 4) Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?  
   
SELECT 
    payroll_year,
    average_value,
    ROUND (((average_value - LAG(average_value) OVER (ORDER BY payroll_year)) / LAG(average_value) OVER (ORDER BY payroll_year)) * 100,2) AS difference_average_value,
    SUM(average_value_item) AS total_value,
    ROUND (((SUM(average_value_item) - LAG(SUM(average_value_item)) OVER (ORDER BY payroll_year)) / LAG(SUM(average_value_item)) OVER (ORDER BY payroll_year)) * 100,2) AS difference_basket_value,
    ROUND (((((SUM(average_value_item) - LAG(SUM(average_value_item)) OVER (ORDER BY payroll_year)) / LAG(SUM(average_value_item)) OVER (ORDER BY payroll_year)) * 100)/ (((average_value - LAG(average_value) OVER (ORDER BY payroll_year)) / LAG(average_value) OVER (ORDER BY payroll_year)) * 100)*100),2) AS year_percentage_change 
FROM 
    t_ondrej_spalek_project_SQL_primary_final
WHERE 
    industry_name IS NULL
    AND payroll_year BETWEEN '2006' AND '2018'
GROUP BY 
    payroll_year,
    average_value
ORDER BY 
    payroll_year ASC;

--5) Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, 
--projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem? 

--5A) Změna HDP oproti předchozím roku v % v porovnání jak se změnili ceny potravin a rostly mzdy oproti předchozímu roku, tzn. 
 --když v daném roku rostlo HDP o x% oproti předchozímu roku zda to mělo vliv na růst mezd, cen potravin v % oproti předchozímu roku.

WITH basket_value AS (
    SELECT 
        rok,
        SUM(total_value),
        (SUM(total_value) - LAG(SUM(total_value)) OVER (ORDER BY rok)) / LAG(SUM(total_value)) OVER (ORDER BY rok) * 100 AS consumer_basket_percentage_change
    FROM (
        SELECT
            rok,
            AVG(average_value_item) AS total_value,
            category_code,
            name,
            LAG(SUM(average_value_item)) OVER (PARTITION BY category_code ORDER BY rok) AS previous_year_value,
            (SUM(average_value_item) - LAG(SUM(average_value_item)) OVER (PARTITION BY category_code ORDER BY rok)) / LAG(SUM(average_value_item)) OVER (PARTITION BY category_code ORDER BY rok) * 100 AS percentage_change
        FROM t_ondrej_spalek_project_SQL_primary_final
        GROUP BY 
            rok, 
            category_code, 
            name
        ORDER BY 
            name,
            rok, 
            percentage_change
    ) subquery
    GROUP BY
        rok
    ORDER BY
        rok
),
mzda_value AS (
SELECT 
    payroll_year,
    ROUND(SUM(average_value) / COUNT(payroll_year), 2) AS avg_salary,
    (ROUND(SUM(average_value) / COUNT(payroll_year), 2) - LAG(ROUND(SUM(average_value) / COUNT(payroll_year), 2)) OVER (ORDER BY payroll_year)) / LAG(ROUND(SUM(average_value) / COUNT(payroll_year), 2)) OVER (ORDER BY payroll_year) * 100 AS salary_percentage_change
FROM 
    t_ondrej_spalek_project_SQL_primary_final
WHERE 
    payroll_year BETWEEN '2006' AND '2018'
GROUP BY  
    payroll_year
ORDER BY 
    payroll_year
   )
SELECT
    rok,
    gdp_percentage_change,
    salary_percentage_change,
    bv.consumer_basket_percentage_change
FROM basket_value bv
LEFT JOIN mzda_value mv ON  bv.rok = mv.payroll_year
LEFT JOIN t_ondrej_spalek_project_SQL_secondary_final ppp ON bv.rok = ppp."year";

--5B) Porovnání růstu HDP ve srovnání cen růstu mezd, potravin o rok později, 
--tzn. pokud rostlo HDP v roce 2007 o x% oproti roku 2006, jaký to mělo vliv na růst mezd a cen potravin v roce 2008 oproti  roku 2007.


 WITH basket_value AS (
    SELECT 
        rok,
        SUM(total_value),
        (SUM(total_value) - LAG(SUM(total_value)) OVER (ORDER BY rok)) / LAG(SUM(total_value)) OVER (ORDER BY rok) * 100 AS consumer_basket_percentage_change
    FROM (
        SELECT
            rok,
            AVG(average_value_item) AS total_value,
            category_code,
            name,
            LAG(SUM(average_value_item)) OVER (PARTITION BY category_code ORDER BY rok) AS previous_year_value,
            (SUM(average_value_item) - LAG(SUM(average_value_item)) OVER (PARTITION BY category_code ORDER BY rok)) / LAG(SUM(average_value_item)) OVER (PARTITION BY category_code ORDER BY rok) * 100 AS percentage_change
        FROM t_ondrej_spalek_project_SQL_primary_final
        GROUP BY 
            rok, 
            category_code, 
            name
        ORDER BY 
            name,
            rok, 
            percentage_change
    ) subquery
    GROUP BY
        rok
    ORDER BY
        rok
),
mzda_value AS (
SELECT 
    payroll_year,
    ROUND(SUM(average_value) / COUNT(payroll_year), 2) AS avg_salary,
    (ROUND(SUM(average_value) / COUNT(payroll_year), 2) - LAG(ROUND(SUM(average_value) / COUNT(payroll_year), 2)) OVER (ORDER BY payroll_year)) / LAG(ROUND(SUM(average_value) / COUNT(payroll_year), 2)) OVER (ORDER BY payroll_year) * 100 AS salary_percentage_change
FROM 
    t_ondrej_spalek_project_SQL_primary_final
WHERE 
    payroll_year BETWEEN '2006' AND '2018'
GROUP BY  
    payroll_year
ORDER BY 
    payroll_year
),
gdp_value AS (
    SELECT 
        "year",
        gdp,
        (gdp - LAG(gdp) OVER (ORDER BY "year")) / LAG(gdp) OVER (ORDER BY "year") * 100 AS gdp_percentage_change
    FROM 
        t_ondrej_spalek_project_SQL_secondary_final ppp
    WHERE 
        country = 'Czech Republic'
        AND gdp IS NOT NULL
        AND "year" BETWEEN 2006 AND 2018
)
SELECT
    gdp_value."year" AS gdp_year,
    gdp_value.gdp_percentage_change,
    mv.salary_percentage_change,
    bv.consumer_basket_percentage_change
FROM 
    gdp_value
LEFT JOIN basket_value bv 
ON gdp_value."year" = bv.rok + 1
LEFT JOIN mzda_value mv 
ON gdp_value."year" = mv.payroll_year + 1
ORDER BY 
    gdp_value."year";
    

   
