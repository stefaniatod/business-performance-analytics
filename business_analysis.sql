-- =========================================================
-- BUSINESS PERFORMANCE ANALYTICS
-- SQL Business Analysis
-- Database: SQLite
-- =========================================================


-- =========================================================
-- 1. DATA EXPLORATION
-- How many orders are in the dataset?
-- =========================================================

SELECT COUNT(Order_ID) AS Total_Orders
FROM orders;


-- =========================================================
-- 2. ORDER STATUS ANALYSIS
-- How are orders distributed by status?
-- =========================================================

SELECT
    Status,
    COUNT(Order_ID) AS Order_Count
FROM orders
GROUP BY Status
ORDER BY Order_Count DESC;


-- =========================================================
-- 3. DATA QUALITY - MISSING CUSTOMERS
-- How many orders cannot be linked to a customer?
-- =========================================================

SELECT
    o.Order_ID,
    o.Customer_ID,
    o.Status
FROM orders o
LEFT JOIN customers c
    ON o.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL;


-- =========================================================
-- 4. REVENUE ANALYSIS
-- Calculate revenue at order-item level.
-- =========================================================

SELECT
    Order_ID,
    Product_ID,
    Quantity,
    Unit_Price,
    Quantity * Unit_Price AS Revenue
FROM order_items
LIMIT 10;


-- =========================================================
-- 5. TOTAL REVENUE
-- Raw revenue before data-quality filtering.
-- =========================================================

SELECT
    SUM(Quantity * Unit_Price) AS Total_Revenue
FROM order_items;


-- =========================================================
-- 6. VALID REVENUE
-- Exclude negative quantities and missing prices.
-- =========================================================

SELECT
    SUM(Quantity * Unit_Price) AS Valid_Revenue
FROM order_items
WHERE Quantity > 0
  AND Unit_Price IS NOT NULL;


-- =========================================================
-- 7. REVENUE BY PRODUCT CATEGORY
-- Which categories generate the most revenue?
-- =========================================================

SELECT
    p.Category,
    SUM(oi.Quantity * oi.Unit_Price) AS Revenue
FROM order_items oi
JOIN products p
    ON oi.Product_ID = p.Product_ID
WHERE oi.Quantity > 0
  AND oi.Unit_Price IS NOT NULL
GROUP BY p.Category
ORDER BY Revenue DESC;


-- =========================================================
-- 8. PROFIT BY PRODUCT CATEGORY
-- Which categories generate the most profit?
-- =========================================================

SELECT
    p.Category,
    SUM(oi.Quantity * (oi.Unit_Price - p.Cost)) AS Profit
FROM order_items oi
JOIN products p
    ON oi.Product_ID = p.Product_ID
WHERE oi.Quantity > 0
  AND oi.Unit_Price IS NOT NULL
GROUP BY p.Category
ORDER BY Profit DESC;


-- =========================================================
-- 9. PROFIT MARGIN BY CATEGORY
-- Revenue vs. profit and profitability percentage.
-- =========================================================

WITH category_profit AS (
    SELECT
        p.Category,
        SUM(oi.Quantity * oi.Unit_Price) AS Revenue,
        SUM(oi.Quantity * (oi.Unit_Price - p.Cost)) AS Profit
    FROM order_items oi
    JOIN products p
        ON oi.Product_ID = p.Product_ID
    WHERE oi.Quantity > 0
      AND oi.Unit_Price IS NOT NULL
      AND p.Cost IS NOT NULL
    GROUP BY p.Category
)

SELECT
    Category,
    Revenue,
    Profit,
    Profit / Revenue * 100 AS Profit_Margin
FROM category_profit
ORDER BY Profit_Margin DESC;


-- =========================================================
-- 10. TOP PRODUCTS BY PROFIT
-- Which products generate the highest profit?
-- =========================================================

SELECT
    p.Product_Name,
    p.Category,
    SUM(oi.Quantity * (oi.Unit_Price - p.Cost)) AS Profit
FROM order_items oi
JOIN products p
    ON oi.Product_ID = p.Product_ID
WHERE oi.Quantity > 0
  AND oi.Unit_Price IS NOT NULL
  AND p.Cost IS NOT NULL
GROUP BY
    p.Product_ID,
    p.Product_Name,
    p.Category
ORDER BY Profit DESC
LIMIT 10;


-- =========================================================
-- 11. TOP PRODUCTS BY REVENUE AND PROFIT
-- Compare sales volume with profitability.
-- =========================================================

SELECT
    p.Product_Name,
    p.Category,
    SUM(oi.Quantity * oi.Unit_Price) AS Revenue,
    SUM(oi.Quantity * (oi.Unit_Price - p.Cost)) AS Profit
FROM order_items oi
JOIN products p
    ON oi.Product_ID = p.Product_ID
WHERE oi.Quantity > 0
  AND oi.Unit_Price IS NOT NULL
  AND p.Cost IS NOT NULL
GROUP BY
    p.Product_ID,
    p.Product_Name,
    p.Category
ORDER BY Revenue DESC
LIMIT 10;


-- =========================================================
-- 12. DISCOUNT ANALYSIS
-- Which products have the highest average discount?
-- =========================================================

SELECT
    p.Product_Name,
    p.Category,
    p.List_Price,
    AVG(oi.Unit_Price) AS Avg_Selling_Price,
    AVG(
        (p.List_Price - oi.Unit_Price)
        / p.List_Price * 100
    ) AS Avg_Discount
FROM order_items oi
JOIN products p
    ON oi.Product_ID = p.Product_ID
WHERE oi.Unit_Price IS NOT NULL
GROUP BY
    p.Product_ID,
    p.Product_Name,
    p.Category,
    p.List_Price
ORDER BY Avg_Discount DESC
LIMIT 10;


-- =========================================================
-- 13. CUSTOMER ORDER FREQUENCY
-- Which customers place the most orders?
-- =========================================================

SELECT
    c.Customer_ID,
    c.Country,
    c.Segment,
    COUNT(o.Order_ID) AS Order_Count
FROM customers c
JOIN orders o
    ON c.Customer_ID = o.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Country,
    c.Segment
ORDER BY Order_Count DESC
LIMIT 10;


-- =========================================================
-- 14. CUSTOMER REVENUE
-- Which customers generate the highest revenue?
-- =========================================================

SELECT
    c.Customer_ID,
    c.Country,
    SUM(oi.Quantity * oi.Unit_Price) AS Revenue
FROM customers c
JOIN orders o
    ON o.Customer_ID = c.Customer_ID
JOIN order_items oi
    ON o.Order_ID = oi.Order_ID
WHERE oi.Quantity > 0
  AND oi.Unit_Price IS NOT NULL
GROUP BY
    c.Customer_ID,
    c.Country
ORDER BY Revenue DESC
LIMIT 10;


-- =========================================================
-- 15. CUSTOMER AVERAGE ORDER VALUE
-- Which customers have the highest AOV?
-- =========================================================

SELECT
    c.Customer_ID,
    c.Country,
    COUNT(DISTINCT o.Order_ID) AS Order_Count,
    SUM(oi.Quantity * oi.Unit_Price) AS Revenue,
    SUM(oi.Quantity * oi.Unit_Price)
        / COUNT(DISTINCT o.Order_ID) AS AOV
FROM customers c
JOIN orders o
    ON c.Customer_ID = o.Customer_ID
JOIN order_items oi
    ON o.Order_ID = oi.Order_ID
WHERE oi.Quantity > 0
  AND oi.Unit_Price IS NOT NULL
GROUP BY
    c.Customer_ID,
    c.Country
ORDER BY AOV DESC
LIMIT 10;


-- =========================================================
-- 16. HIGH-VALUE CUSTOMERS
-- Customers with at least 5 orders
-- and more than 50,000 in revenue.
-- =========================================================

SELECT
    c.Customer_ID,
    c.Country,
    COUNT(DISTINCT o.Order_ID) AS Order_Count,
    SUM(oi.Quantity * oi.Unit_Price) AS Revenue
FROM customers c
JOIN orders o
    ON c.Customer_ID = o.Customer_ID
JOIN order_items oi
    ON o.Order_ID = oi.Order_ID
WHERE oi.Quantity > 0
  AND oi.Unit_Price IS NOT NULL
GROUP BY
    c.Customer_ID,
    c.Country
HAVING COUNT(DISTINCT o.Order_ID) >= 5
   AND SUM(oi.Quantity * oi.Unit_Price) > 50000
ORDER BY Revenue DESC;