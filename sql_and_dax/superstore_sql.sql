-- 1. Create table
CREATE TABLE superstore (
    Row_ID INT,
    Order_ID TEXT,
    Order_Date DATE,
    Ship_Date DATE,
    Ship_Mode TEXT,
    Customer_ID TEXT,
    Customer_Name TEXT,
    Segment TEXT,
    Country TEXT,
    City TEXT,
    State TEXT,
    Postal_Code TEXT,
    Region TEXT,
    Product_ID TEXT,
    Category TEXT,
    Sub_Category TEXT,
    Product_Name TEXT,
    Sales NUMERIC,
    Quantity INT,
    Discount NUMERIC,
    Profit NUMERIC
);

-- 2. Import your dataset here (use \COPY in psql or import tool in pgAdmin)

-- 3. Data Cleaning
-- Remove duplicates
DELETE FROM superstore
WHERE ctid NOT IN (
    SELECT MIN(ctid)
    FROM superstore
    GROUP BY Order_ID, Product_ID
);

-- 4. Add calculated columns
ALTER TABLE superstore ADD COLUMN Profit_Margin NUMERIC;
ALTER TABLE superstore ADD COLUMN Loss_Flag INT;

UPDATE superstore
SET Profit_Margin = ROUND((Profit / Sales) * 100, 2),
    Loss_Flag = CASE WHEN Profit < 0 THEN 1 ELSE 0 END;

-- 5. Top loss-making products
SELECT "Product_Name", SUM(Profit) AS total_loss
FROM superstore
WHERE Profit < 0
GROUP BY "Product_Name"
ORDER BY total_loss ASC
LIMIT 10;

-- 6. Loss by category & region
SELECT Category, Region, SUM(Profit) AS total_profit
FROM superstore
GROUP BY Category, Region
ORDER BY total_profit ASC;

-- 7. Discount vs Profit trend
SELECT Discount, ROUND(AVG(Profit), 2) AS avg_profit
FROM superstore
GROUP BY Discount
ORDER BY Discount DESC;
-- profit and loss by category
SELECT 
    category,
    SUM(CASE WHEN profit < 0 THEN profit ELSE 0 END) AS total_loss,
    SUM(CASE WHEN profit > 0 THEN profit ELSE 0 END) AS total_profit,
    SUM(profit) AS net_profit
FROM superstore_clean
GROUP BY category
ORDER BY net_profit DESC;
-- profit and loss by region
SELECT 
    region,
    SUM(CASE WHEN profit < 0 THEN profit ELSE 0 END) AS total_loss,
    SUM(CASE WHEN profit > 0 THEN profit ELSE 0 END) AS total_profit,
    SUM(profit) AS net_profit
FROM superstore_clean
GROUP BY region
ORDER BY net_profit DESC;
