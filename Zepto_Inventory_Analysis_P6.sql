                                                     -- ZEPTO Project --  

DROP TABLE IF EXISTS zepto;

-- Creating Table

CREATE TABLE zepto
       (sku_id SERIAL PRIMARY KEY,
	    Category VARCHAR(90),	
	    name VARCHAR(100),
		mrp	 INT,
		discountPercent INT,	
		availableQuantity INT,
		discountedSellingPrice	INT,
		weightInGms	INT,
		outOfStock	BOOLEAN,
		quantity INT 
);


_________________________________________
-- Data Exploration
_________________________________________


SELECT * FROM zepto;

-- Count of rows

SELECT COUNT(*) FROM zepto;

-- NUll Values

SELECT * FROM zepto 
WHERE 
name IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL 
OR
availableQuantity IS NULL
OR
weightInGms IS NULL 
OR 
outOfStock IS NULL
OR
quantity IS NULL

-- Different Product Category

SELECT 
    DISTINCT category
FROM zepto
ORDER BY 1;


-- Products Out of Stock VS In Stock

SELECT 
    outOfStock,
	COUNT(sku_id)
FROM zepto
GROUP BY 1;

-- Product Names Present Multiple Times

SELECT 
    name,
	COUNT(sku_id) AS No_of_SKU
FROM ZEPTO
GROUP BY 1
HAVING COUNT(sku_id) > 1
ORDER BY 2 DESC;

_____________________________________
-- Data Cleaning 
_____________________________________

--Product with Price 0 

SELECT * 
FROM zepto 
WHERE 
   mrp =  0 
   OR 
   discountedSellingPrice = 0;

DELETE FROM zepto
WHERE
   mrp = 0;


-- Conversin of mrp - Paise to Rupees

UPDATE zepto 
SET 
  mrp = mrp/100.0,
  discountedSellingPrice = discountedSellingPrice/100.0;



______________________
-- DATA ANALYSIS 
______________________


-- Q1. Find the top 10 best-value products based on the discount percentage.

SELECT 
    name,
	mrp,
	discountpercent
FROM zepto 
ORDER BY 3 DESC
LIMIT 10;


--Q2.What are the Products with High MRP but Out of Stock

SELECT 
     mrp,
	 outOfStock
FROM zepto
WHERE 
    outOfStock = 'true'
	AND 
	mrp > 300
ORDER BY 1 DESC 


--Q3.Calculate Estimated Revenue for each category

SELECT 
    category,
	SUM(discountedSellingPrice * availableQuantity) AS Total_revenue
FROM zepto
GROUP BY 1
ORDER BY 2 DESC;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.

SELECT 
    DISTINCT name,
	mrp,
	discountpercent
FROM zepto
WHERE mrp > 500
      AND
	  discountpercent < 10
ORDER BY 2, 3 DESC;


-- Q5. Identify the top 5 categories offering the highest average discount percentage.

SELECT 
     category,
	 ROUND(AVG(discountpercent),2) AS avg_discountpercent
FROM zepto
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 5;



-- Q6. Find the price per gram for products above 100g and sort by best value.

SELECT 
    DISTINCT name,
	weightInGms,
    discountedSellingPrice,
    ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE 
    weightInGms >= 100
ORDER BY 4 DESC;


--Q7.Group the products into categories like Low, Medium, Bulk.

SELECT 
   DISTINCT name, 
   weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;


--Q8.What is the Total Inventory Weight Per Category

SELECT 
    category,
    SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;  



                                                       -- END --









