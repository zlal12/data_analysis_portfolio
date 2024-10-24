--Analysis of E-Commerce Shop's Order Data
--1. Check the Data

--a) 'Order' Table
SELECT *
FROM online_order

--b) 'Item' Table
SELECT *
FROM item

--c) 'Category' Table
SELECT *
FROM category

--d) 'User' Table
SELECT *
FROM user_info

--2. Check the Sales of TOP Products

-- Aggregating Sales by Product and Sorting in order of High Sales
SELECT itemid, item_name, SUM(gmv) AS gmv
FROM online_order AS oo
JOIN item AS i ON oo.itemid = i.id
GROUP BY 1,2
;

-- Sales by Category
SELECT c.cate1, i.item_name, SUM(gmv) as gmv
FROM online_order oo
JOIN item i ON oo.itemid = i.id
JOIN category c ON i.category_id = c.id
GROUP BY 1, 2
ORDER BY 1, 2
;

-- Sales by Gender
SELECT ui.gender, SUM(gmv) AS gmv, COUNT(DISTINCT oo.userid) AS user_cnt
FROM online_order oo
JOIN user_info ui  ON oo.userid = ui.userid 
GROUP BY 1
ORDER BY 2 DESC
;

-- Sales by Age
SELECT ui.age_band, SUM(gmv) AS gmv, COUNT(DISTINCT oo.userid) AS user_cnt
FROM online_order oo
JOIN user_info ui  ON oo.userid = ui.userid 
GROUP BY 1
ORDER BY 2 DESC
;

--3. Sales of Major Products by Category
SELECT c.cate3, c.cate2, c.cate1, i.item_name, 
	SUM(gmv) AS gmv, SUM(unitsold) AS unitsold, 
	SUM(gmv) / SUM(unitsold) AS price
FROM online_order oo
JOIN item i ON oo.itemid = i.id
JOIN category c ON i.category_id = c.id
GROUP BY 1,2,3,4
ORDER BY 1, 5 DESC

-- What's the items bought by male users?
SELECT item_name, cate1, SUM(gmv) AS gmv, SUM(unitsold) AS unitsold
FROM online_order oo
JOIN item i ON oo.itemid = i.id
JOIN category c ON i.category_id = c.id
JOIN user_info ui ON oo.userid = ui.userid 
WHERE ui.gender = 'M'
GROUP BY 1,2
;

--4. Process Columns to the Desired Format--------------------------------------------------------------

--a) Change a Number into a String
SELECT dt, CAST(dt AS varchar) AS yyyymmdd
FROM online_order oo
;

--b) Cut the Part of String 
SELECT dt, LEFT(CAST(dt AS varchar), 4) AS yyyy,
	SUBSTRING(CAST(dt AS varchar),5,2) AS mm,
	RIGHT(CAST(dt AS varchar), 2) AS dd
FROM online_order oo
;

--c) Make a date column in 'yyyy-mm-dd' format
SELECT dt,
	CONCAT(
	LEFT(cast(dt AS varchar), 4), '-',
	SUBSTRING(CAST(dt AS varchar),5,2) , '-',
	RIGHT(cast(dt AS varchar), 2) ) AS yyyymmdd
FROM online_order oo
;

--d) Replace the Null values
SELECT 
	COALESCE(ui.gender, 'NA') AS gender, 
	COALESCE(ui.age_band, 'NA') AS age_band,
	SUM(oo.gmv) AS gmv
FROM online_order oo
LEFT JOIN user_info ui ON oo.userid  = ui.userid
GROUP BY 1,2
ORDER BY 1,2
;

--e) Add the column I want: change the gender column to Korean
SELECT 
	DISTINCT CASE WHEN gender = 'M' THEN '남성'
	WHEN gender = 'F' THEN '여성'  
	END AS gender
FROM user_info ui
;

--f) Make a age band (20s, 30s, 40s) 
SELECT
	CASE WHEN ui.age_band = '20~24' THEN '20s'
	WHEN ui.age_band = '25~29' THEN '20s'
	WHEN ui.age_band = '30~34' THEN '30s'
	WHEN ui.age_band = '35~39' THEN '30s'
	WHEN ui.age_band = '40~44' THEN '40s'
	WHEN ui.age_band = '45~49' THEN '40s'
	ELSE 'NA'
	END AS age_group,
	SUM(gmv) AS gmv
FROM online_order oo
LEFT JOIN user_info ui ON oo.userid  = ui.userid
GROUP BY 1
ORDER BY 1 
;


--g) Comparing the Sales of TOP3 Categories with Other Products
SELECT
	CASE WHEN cate1 IN ('스커트', '티셔츠', '원피스') THEN 'TOP 3'
	ELSE '기타' END AS item_type, 
	SUM(gmv) AS gmv
FROM online_order oo
JOIN item i ON oo.itemid = i.id
JOIN category c ON i.category_id = c.id
GROUP BY 1
ORDER BY 2 DESC
;

--h) Compare the sales of items with specific keywords and without it
SELECT 
	item_name,
	CASE WHEN item_name LIKE '%cute%' THEN 'cute concept'
	WHEN item_name LIKE '%chic%' THEN 'chic concept'
	WHEN item_name LIKE '%feminine%' THEN 'femine concept'
	WHEN item_name LIKE '%simple%' THEN 'simple concept'
	ELSE 'unclassified'
	END AS item_concept
FROM item
;

SELECT 
	CASE WHEN item_name LIKE '%cute%' THEN 'cute concept'
	WHEN item_name LIKE '%chic%' THEN 'chic concept'
	WHEN item_name LIKE '%feminine%' THEN 'femine concept'
	WHEN item_name LIKE '%simple%' THEN 'simple concept'
	ELSE 'unclassified'
	END AS item_concept, 
	SUM(gmv) AS gmv
FROM online_order oo
JOIN item i ON oo.itemid = i.id
GROUP BY 1
ORDER BY 2 DESC
;


--5. Date-related functions--------------------------------------------------------------

--a) Basic syntax to check today's date
SELECT now()

SELECT current_date

SELECT current_timestamp

--b) Convert from Date Format to String Format
SELECT to_char(now(),'yyyymmdd')

SELECT to_char(now(), 'yyyy / mm / dd')

--c) Calculation with date
SELECT now() + interval '1 day'

SELECT now() - interval '1 month'

--d Check Year, Month and Week from Date
SELECT date_part('year', now())

SELECT date_part('day', now())

--d) Check the Sales for the Last Year
SELECT *
FROM gmv_trend gt
WHERE CAST(yyyy AS varchar) || CAST(mm AS varchar)
>= CAST(date_part('year', now() - interval '1 year') AS varchar) || CAST(date_part('month', now() - interval '1 year') AS varchar)
ORDER BY 2,3
;


--6. Calculate discount rate, product margin and total margin

SELECT 
	c.cate1,
	ROUND(SUM(CAST(discount AS numeric)) / SUM(gmv), 2) * 100 AS discount_rate,
	SUM(gmv) - SUM(discount) AS paid_amount,
	ROUND(SUM(CAST(product_profit AS numeric)) / SUM(gmv), 2) * 100 AS product_margin,
	CAST(ROUND(SUM(CAST(total_profit AS numeric)) / SUM(gmv) * 100) AS varchar) || '%' AS total_margin
FROM online_order oo
JOIN item i ON oo.itemid = i.id
JOIN category c ON i.category_id  = c.id
GROUP BY 1
ORDER BY 3 DESC
;


--7. Analysis from the customer's point of view 

-- Product with High Number of Purchase per Person

SELECT 
	i.item_name, 
	SUM(unitsold) AS unitsold, 
	COUNT(DISTINCT userid) AS user_count, 
	ROUND(SUM(CAST(unitsold AS numeric)) / COUNT(DISTINCT userid), 2) AS avg_unitsold_per_customer, 
	ROUND(SUM(CAST(gmv AS numeric)) / COUNT(DISTINCT userid)) AS avg_gmv_per_customer
FROM online_order oo
JOIN item i ON oo.itemid = i.id
GROUP BY 1
ORDER BY 4 desc
;

-- Gender & Age group with High Purchase Price per Person

SELECT 
	gender, 
	age_band,
	SUM(gmv) AS gmv,
	COUNT(DISTINCT oo.userid) AS user_count,
	SUM(gmv) / COUNT(DISTINCT oo.userid) AS avg_gmv_per_customer
FROM online_order oo
JOIN user_info ui ON oo.userid  = ui.userid
GROUP BY 1,2
ORDER BY 5 DESC
;