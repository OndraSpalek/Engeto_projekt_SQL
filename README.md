# Engeto_projekt_SQL
Materiálu k projektu SQL v rámci Engeto datové analytiky.

Průvodní list k projektu SQL zabývajícím se zodpovězení otázek životní úrovně obyvatel. 

1. Zadání projektu:	1
2. Vytvořené tabulky	2
3. Výzkumné otázky:	3
4. Vytvořené SQL dotazy	5

1. Zadání projektu:
Cílem projektu je vytvořit podklady pro zodpovězení výzkumných otázek týkajících se dostupnosti základních potravin široké veřejnosti. Materiály budou předány tiskovému oddělení pro prezentování široké veřejnosti.
Pro vytvoření základních datových podkladů máme k dispozici tyto tabulky: 
czechia_payroll – Informace o mzdách v různých odvětvích za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
czechia_payroll_calculation – Číselník kalkulací v tabulce mezd.
czechia_payroll_industry_branch – Číselník odvětví v tabulce mezd.
czechia_payroll_unit – Číselník jednotek hodnot v tabulce mezd.
czechia_payroll_value_type – Číselník typů hodnot v tabulce mezd.
czechia_price – Informace o cenách vybraných potravin za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
czechia_price_category – Číselník kategorií potravin, které se vyskytují v našem přehledu.
czechia_region – Číselník krajů České republiky dle normy CZ-NUTS 2.
czechia district – Číselník okresů České republiky dle normy LAU.
countries - Všemožné informace o zemích na světě, například hlavní město, měna, národní jídlo nebo průměrná výška populace.
economies - GDP, GINI, daňová zátěž, atd. pro daný stát a rok.
Z těchto tabulek vytvoříme 2 cílové tabulky:
t_ondrej spalek_project_SQL_primary_final: tabulka bude primárně obsahovat data mezd a cen potravin za Českou republiku sjednocených na srovnatelné období - roky
t_ondrej spalek_project_SQL_secondary_final: tabulka bude obsahovat data o evropských státech.
Tyto dvě základní tabulky nám budou následně sloužit pro zodpovězení výzkumných otázek: 
Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší procentuální meziroční nárůst)?
Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?



2. Vytvořené tabulky
Seznam a popis tabulek, které byly vytvořeny pro řešení zadání.
t_ondrej_spalek_project_SQL_primary_final: Obsahuje podklady pro zodpovězení otázek týkajících se mezd a potravin. Data se kterými lze pracovat jsou v rozmezí 200 - 2021. Nejsou však dostupná kompletně pro všechny roky. Proto jsem při odpovídání na otázky pracoval u jednotlivých otázek s rozdílnými časovými obdobími.
V této tabulce naleznete následující sloupce:
industry_name: popis odvětví
industry_branch_code: kód odvětví
payroll_year: rok
average_value: průměrná hodnota mzdy pro dané odvětví a daný rok
name: název potraviny sledované ve spotřebitelském koši
category_code: kód potraviny
rok: rok
average_value_item: průměrná cena potraviny v daném roce. 
Je-li hodnota industry_name, industry_branch_code NULL, tak to znamená, že se jedná o průměrnou mzdu za daný rok pro Českou republiku.

t_ondrej_spalek_project_SQL_secondary_final: Obsahuje podklady pro zodpovězení otázek týkající se porovnání evropských států.
country:  název státu
year: rok
gdp: hodnota HDP
population: počet obyvatel v daném roce
gdp_percentage_change: změna HDP v porovnání aktuální rok oproti předchozímu, např. 2006 proti 2005 atd.

3. Výzkumné otázky:
Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
Vývoje mezd jsem sledoval mezi lety 2000 až 2021. Obecně mzdy rostou porovnáme-li rok 2000 proti roku 2021.  Při sledování mezd po jednotlivých letech jsem došel k závěru, že roční průměrná výše může kolísat a není zde trend, že ve všech odvětvích musí mzdy každý rok růst. V odvětví zemědělství, lesnictví a rybářství byl pokles mezd mezi lety 2002 a 2003.  V odvětví  těžby a dobývání je pokles u mezd mezi lety 2000 a 2001. Potom také mezi lety 2006 a 2007.  Ve zpracovatelském průmyslu byl pokles mezd mezi lety 2005 a 2006 a potom 2008 a 2009. Takto mohu pokračovat dále napříč dalšími odvětvími.  Pro lepší přehled přikládám graf, který ukazuje vývoj mezd za celé období ve všech sledovaných oblastech.
Vývoj mezd vyjádřený grafem:


Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
Pro zodpovězení této otázky jsem využil data z let 2006 a 2018. Jedná se o první a poslední rok, kdy byla dostupná data o  cenách a mzdách.
V roce 2006 bylo možné zakoupit  1 307, 65 ks chleba konzumního kmínového a 1 460,29 l mléka polotučného pasterovaného.  V roce 2018 bylo možné koupit 1 363,09 chleba konzumního kmínového a 1 667, 02 l mléka polotučného pasterovaného.
Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší procentuální meziroční nárůst)?
Pro zodpovězení této otázky jsem se podíval, jak se měnila cena dané potraviny při porovnání aktuálního roku oproti roku minulému, tzn: rok 2009 proti 2008, 2010 proti 2009 atd.  Výsledkem byla tabulka s vývojem cen v čase ze které můžeme vybrat potravinu s nejmenší meziročním růstem.
Pro demonstraci výsledku přidávám zobrazení změny ceny pro Banány žluté a Cukr krystalový.

Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
Ano, existuje. Ve sledovaném období 2006 až 2018 máme roky 2009, 2011, 2012, 2014 a 2016, kdy byl růst spotřebitelského koše vyšší než 10% oproti růstu mezd.
Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
Odpovědi na tuto otázku jsem rozdělil na dvě části.  
a) Pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném roce? 
Jako výpočet jsme použili porovnání aktuálního roku oproti roku předchozímu, tzn, pokud výsledek ukazuje, že HDP, mzdy, potraviny vzrostly v roce 2006 o X%, tak to znamená oproti roku 2005.
Odpověď není jednoznačná.  Najdeme roky, kdy růst HDP a mezd znamená i růst potravin, ale i naopak. V roce  2007, kdy HDP vzrostlo o 5,57% a mzdy vzrostly o 6,89% a ceny potravin o 6,76%. Stejně tak rok 2017, kdy HDP vzrostlo o 5,17%, mzdy o 6,19% a ceny potravin vzrostly o 9,62%. Proti tomu máme rok 2009, kdy HDP kleslo o 4,65% a mzdy vzrostly o 3,08% a ceny potravin klesly o 6,41%.  V roce 2013 HDP kleslo o 0,045%, mzdy o 1,48% a cena potravin vzrostla o 5,097%
b) Pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách v následujícím roce?
Pro odpověď na tuto otázku vychází v porovnání meziročního růstu následovně. Bereme-li rok 2008, tak zde porovnáváme změnu HDP roku 2008 proti roku 2007 a to porovnáváme ve změnách cen potravin, mzdy roku 2009 oproti roku 2008. Chceme tedy zjistit, zda trend HDP roku 2008 se propsal do vývoje mezd a cen potravin v roce 2009.
Odpověď na tuto otázku také není jednoznačná.  Máme rok 2008, kdy růst HDP znamenal růst mezd  o 6,89% a růst potravin o 6,68% v roce 2009.  Ovšem v roce 2009 byl pokles HDP o 4,65% avšak mzdy v roce 2010 vzrostly o 7,7% a spotřebitelský koš o 7,19%. Nebo rok 2014, kdy byl růst HDP 2,26% a mzdy v následujícím roce 2015 klesly o 1,48% a ceny potravin o 5,95%.


4. Vytvořené SQL dotazy pro základní tabulky
SQL skript pro vytvoření tabulky: t_ondrej_spalek_project_SQL_primary_final:
CREATE TABLE t_ondrej_spalek_project_SQL_primary_final  AS
WITH avg_payroll AS (
SELECT
	cpib."name"  AS industry_name,
	cp.industry_branch_code ,
	cp.payroll_year,
   ROUND (AVG(cp.value) :: NUMERIC ,2) AS average_value
FROM czechia_payroll cp
LEFT JOIN czechia_payroll_industry_branch cpib
ON cpib.code = cp.industry_branch_code
WHERE value_type_code = '5958'
AND calculation_code = '200'
GROUP BY
	cpib."name" ,
	cp.industry_branch_code ,
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

SQL skript pro vytvoření tabulky: t_ondrej_spalek_project_SQL_secondary_final:
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

5. Vytvořené SQL dotazy pro zodpovězení výzkumných otázek
Popis jednotlivých SQL dotazů, které byly vytvořeny pro zodpovězení položených otázek.
1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
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
2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
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
 
3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší procentuální meziroční nárůst)?
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
  	rok ASC ,
  	percentage_change;

4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
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
5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

5A)
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

5B)
 
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
  




