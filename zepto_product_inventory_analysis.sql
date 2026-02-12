drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
DiscountPercent NUMERIC(5,2),
AvailableQuantity INTEGER,
DiscountedSellingPrice NUMERIC(8,2),
WeightInGrams INTEGER,
OutofStock BOOLEAN,
Quantity INTEGER
);

--- Data Exploration -----

SELECT * from zepto;

---- count of all rows
SELECT COUNT(*) FROM zepto;

----sample data
SELECT * FROM zepto LIMIT 10;

----null values
SELECT * FROM zepto
WHERE name IS NULL OR
category IS NULL OR
mrp IS NULL OR
discountpercent IS NULL OR
discountedsellingprice IS NULL OR
weightingrams IS NULL OR
outofstock IS NULL OR
quantity IS NULL;

---different product categories available
SELECT DISTINCT CATEGORY from zepto
ORDER BY category;

---products in stock vs out of stock
SELECT OutofStock, COUNT(sku_id) from zepto
GROUP BY OutofStock;

---product  names present multiple times
SELECT NAME,COUNT(sku_id) AS "Number of SKUs"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id)>1
ORDER BY COUNT(sku_id) DESC;

---Data Cleaning
---Products with price=0
SELECT * FROM zepto
WHERE mrp=0
OR discountedSellingprice=0;

DELETE FROM zepto
WHERE mrp=0;

---convert cents to rupees
UPDATE zepto
SET mrp=mrp/100.0,
discountedSellingprice=discountedSellingprice/100.0;

SELECT mrp,discountedSellingprice FROM zepto

--- Business Problems to Answer

--Q1. Find the top 10 best value products based on the discount percentage?
SELECT DISTINCT name,discountpercent
FROM zepto
ORDER BY  discountpercent DESC
LIMIT 10;

--Q2. What are the products with High MRP but Out of Stock
SELECT DISTINCT name,mrp
from zepto
WHERE outofstock=true
AND mrp>300
ORDER BY mrp DESC;

--Q3. Calculate Estimated Revenue for each category
SELECT category,SUM(discountedSellingprice*availablequantity) AS total_revenue
from zepto
GROUP BY category
ORDER BY total_revenue;

--Q4. Find all products where MRP is greater than 500 and discount is less than 10%
SELECT DISTINCT name,mrp,discountpercent
FROM zepto
WHERE mrp>500.00 
AND discountpercent<10.00
ORDER BY mrp DESC, discountpercent DESC;

--Q5. Identify the top 5 categories offering the highest average discount percentage
SELECT category,ROUND(AVG(discountpercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount
LIMIT 5;

--Q6. Find the price per gram for products above 100g and sort by best value
SELECT DISTINCT name, weightingrams, discountedSellingprice,
ROUND(discountedSellingprice/weightingrams,2) AS price_per_gram
FROM zepto
WHERE weightingrams>=100
ORDER BY price_per_gram;

--Q7. Group the products into categories like Low, Medium, Bulk
SELECT DISTINCT name, weightingrams,
CASE WHEN weightingrams< 1000 THEN 'Low'
		WHEN weightingrams< 5000 THEN 'Medium'
		ELSE 'Bulk'
		END AS weight_category
FROM zepto;

--Q8. What is the Total Inventory Weight Per Category
SELECT category, SUM(availablequantity*weightingrams) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;
	