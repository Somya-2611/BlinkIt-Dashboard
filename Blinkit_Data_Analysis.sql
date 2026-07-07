CREATE TABLE blinkit_grocery_data (
	item_fat_content TEXT,
    item_identifier TEXT,
	item_type TEXT,
	outlet_establishment_year INT,
	outlet_identifier TEXT,
	outlet_location_type TEXT,
	outlet_size TEXT,
	outlet_type TEXT,
    item_visibility NUMERIC,
    item_weight NUMERIC,
    sales NUMERIC,
	rating NUMERIC
);
Select * from blinkit_grocery_data;

Select count(*) from blinkit_grocery_data;


-- DATA CLEANING:
-- Cleaning the Item Fat Content field ensures data consistency and accuracy in analysis. The presence of multiple
--variations of the same category (e.g., LF, low fat vs. Low Fat) can cause issues in reporting, aggregations, and
-- filtering. Standardizing these values to improve data quality, making it easier to generate insights and maintain
-- uniformity in dataset.

UPDATE blinkit_grocery_data
SET item_fat_content = 
CASE WHEN item_fat_content IN ('low fat' , 'LF') THEN 'Low Fat'
	 WHEN item_fat_content = 'reg' THEN 'Regular'
	 ELSE item_fat_content 
END;

SELECT DISTINCT item_fat_content from blinkit_grocery_data;

-- Α. KPI's

-- 1. TOTAL SALES:
SELECT CAST(SUM(sales)/1000000 AS DECIMAL(10,2)) AS "Total_Sales(in Millions)"
FROM blinkit_grocery_data;

-- 2. AVERAGE SALES
SELECT CAST(AVG(sales) AS DECIMAL(10,2)) AS "Average_sales"
FROM blinkit_grocery_data;

-- 3. NO OF ITEMS
SELECT COUNT(*) AS "Total No of Orders"
FROM blinkit_grocery_data;

-- 4. AVERAGE RATING 
SELECT CAST(AVG(rating) AS DECIMAL(10,2)) AS "Average Rating"
FROM blinkit_grocery_data;


-- B. TOTAL SALES BY FAT CONTENT 

SELECT item_fat_content, SUM(sales) as "Total Sales"
FROM blinkit_grocery_data
GROUP BY  item_fat_content;


-- C. TOTAL SALES BY ITEM TYPE

SELECT item_type , SUM(sales) as "Total Sales"
FROM blinkit_grocery_data
GROUP BY  item_type
ORDER BY "Total Sales" desc;


-- D. FAT CONTENT BY OUTLET FOR TOTAL SALES

SELECT outlet_location_type,
    SUM(CASE
            WHEN item_fat_content = 'Low Fat' THEN sales
            ELSE 0
        END) AS Low_Fat,
    SUM(CASE
            WHEN item_fat_content = 'Regular' THEN sales
            ELSE 0
        END) AS Regular
FROM blinkit_grocery_data
GROUP BY outlet_location_type
ORDER BY outlet_location_type;




































