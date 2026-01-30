# Zepto Inventory & Pricing Intelligence – SQL Analytics Project

![image](https://github.com/kovidanand/SQL-Zepto_Analysis_P6/blob/main/Logo_of_Zepto.png)

### Overview

This project analyzes Zepto’s product inventory and pricing data using SQL to support merchandising, supply chain, and revenue strategy teams.

The analysis focuses on identifying discount efficiency, stock-out risk, category-level revenue potential, pricing gaps, and inventory weight distribution.
The goal is to turn raw SKU-level data into decision-ready business insights for fast-commerce operations.

## Business Problem

Quick-commerce platforms like Zepto operate on thin margins and high-velocity inventory cycles.
Leadership teams must continuously answer:

- Which products give the best value to customers?

- Where are high-price products going out of stock?

- Which categories generate the most revenue?

- Are premium items being discounted correctly?

- Which categories are over- or under-stocked by weight?

- How should products be grouped for logistics planning?

Without structured SQL analysis, these questions are handled manually or through dashboards that lack auditability.

## Solution

This project solves those problems by:

- Cleaning pricing data and correcting currency units

- Validating missing or incorrect records

- Segmenting products by weight for logistics use

- Ranking discounts and category revenue

- Identifying risky stock-out patterns

- Measuring inventory concentration

All logic is implemented directly in SQL so it can be productionized in reporting pipelines.

## Dataset Scope

The dataset contains SKU-level attributes including:

product name, category, MRP, discount percentage, available quantity, discounted selling price, weight in grams, stock-out status, and quantity.

## Analytical Coverage, Decisions Enabled, and Business Impact
**Data Quality Validation and Cleaning**

The project first checks for null values and invalid pricing, removes zero-priced items, and converts prices from paise to rupees.

Business Impact
Improves financial accuracy and prevents revenue calculations from being distorted by corrupted records.

**Decisions Enabled**                                                
- Trust category-level revenue metrics
- Avoid pricing errors on the customer app                                                         
- Reduce reconciliation issues in finance reports                                            

### 1. Top Discounted Products
```sql
SELECT 
    name,
    mrp,
    discountpercent
FROM zepto 
ORDER BY 3 DESC
LIMIT 10;
```

**Business Impact**
Identifies SKUs driving customer attraction through heavy discounts.

**Decisions Enabled**
• Promote these items in campaigns
• Review margin sustainability
• Negotiate supplier terms

### 2. High-MRP Products That Are Out of Stock
```sql
SELECT 
     mrp,
     outOfStock
FROM zepto
WHERE 
    outOfStock = 'true'
	AND mrp > 300
ORDER BY 1 DESC;
```

**Business Impact**

Flags revenue-critical premium products that customers cannot currently purchase.

**Decisions Enabled**
- Trigger urgent replenishment
- Adjust safety stock levels
- Escalate supplier delays

### 3. Category-Level Revenue Estimation
```sql
SELECT 
    category,
	SUM(discountedSellingPrice * availableQuantity) AS Total_revenue
FROM zepto
GROUP BY 1
ORDER BY 2 DESC;
```

**Business Impact**

Shows which product categories contribute most to gross sales.

**Decisions Enabled**
- Prioritize high-value categories
- Allocate warehouse space
- Expand winning segments

### 4. Premium Products With Low Discounts
```sql
SELECT 
    DISTINCT name,
	mrp,
	discountpercent
FROM zepto
WHERE mrp > 500
      AND discountpercent < 10
ORDER BY 2, 3 DESC;
```

**Business Impact**

Reveals expensive products that may not be competitively priced.

**Decisions Enabled**
- Review pricing strategy
- Introduce tactical discounts
- Improve premium product conversion

###  5. Categories Offering the Highest Average Discounts
```sql
SELECT 
     category,
	 ROUND(AVG(discountpercent),2) AS avg_discountpercent
FROM zepto
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 5;
```

**Business Impact**

Highlights segments where margin pressure may be highest.

**Decisions Enabled**
- Revisit promotional strategy
- Adjust supplier negotiations
- Protect profitability

### 6. Price-Per-Gram Value Analysis
```sql
SELECT 
    DISTINCT name,
	weightInGms,
    discountedSellingPrice,
    ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY 4 DESC;
```

**Business Impact**

Compares products fairly across pack sizes to detect poor-value SKUs.

**Decisions Enabled**
- Rationalize assortment
- Introduce private labels
- Reprice inefficient SKUs

### 7.Weight-Based Product Segmentation
```sql
SELECT 
   DISTINCT name, 
   weightInGms,
   CASE 
        WHEN weightInGms < 1000 THEN 'Low'
	    WHEN weightInGms < 5000 THEN 'Medium'
	    ELSE 'Bulk'
   END AS weight_category
FROM zepto;
```

**Business Impact**

Creates operational groupings useful for picking, storage, and delivery routing.

**Decisions Enabled**
- Design warehouse slotting
- Optimize rider load limits
- Improve dispatch efficiency

### 8. Total Inventory Weight by Category
```sql
SELECT 
    category,
    SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;
```

**Business Impact**

Shows which categories consume the most physical storage.

**Decisions Enabled**
- Warehouse layout planning
- Inventory caps for heavy categories
- Logistics cost control

## Business Value Delivered

- Improves stock availability for high-value products
- Supports pricing and promotion strategy
- Highlights margin-risk categories
- Optimizes warehouse utilization
- Strengthens revenue forecasting
- Reduces operational blind spots



