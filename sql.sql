-- Create a new database for retail sales analysis
CREATE DATABASE retail_analysis;

-- Select the retail_analysis database for use
USE retail_analysis;


-- Create customers table to store customer details
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,   -- Unique customer ID
    customer_name VARCHAR(100),            -- Customer full name
    segment VARCHAR(50),                   -- Customer segment (Consumer, Corporate, etc.)
    country VARCHAR(50),                   -- Customer country
    city VARCHAR(50),                      -- Customer city
    state VARCHAR(50),                     -- Customer state
    postal_code VARCHAR(20),               -- Postal code
    region VARCHAR(50)                     -- Sales region
);


-- Create products table to store product information
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,    -- Unique product ID
    category VARCHAR(50),                  -- Product category
    sub_category VARCHAR(50),              -- Product sub-category
    product_name TEXT                      -- Product name
);


-- Create orders table to store sales transactions
CREATE TABLE orders (
    row_id INT,                            -- Row identifier
    order_id VARCHAR(50),                  -- Unique order ID
    order_date VARCHAR(50),                -- Date when order was placed
    ship_date VARCHAR(50),                 -- Date when order was shipped
    ship_mode VARCHAR(50),                 -- Shipping method
    customer_id VARCHAR(50),               -- Customer ID reference
    product_id VARCHAR(50),                -- Product ID reference
    sales DECIMAL(10,2),                   -- Sales amount
    quantity INT,                          -- Quantity ordered
    discount DECIMAL(5,2),                 -- Discount applied
    profit DECIMAL(10,2),                  -- Profit earned

    -- Foreign key linking customer_id with customers table
    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id),

    -- Foreign key linking product_id with products table
    FOREIGN KEY (product_id)
    REFERENCES products(product_id)
);


-- Count total number of records in orders table
SELECT COUNT(*) FROM orders;


-- Display order details along with customer and product names
SELECT 
    o.order_id,
    c.customer_name,
    p.product_name,
    o.sales
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
JOIN products p
ON o.product_id = p.product_id
LIMIT 10;


-- Calculate total sales amount 
SELECT 
ROUND(SUM(sales),2) 
AS total_sales
FROM orders;

-- Total Sales Amount for Financial Year 2017
SELECT 
    YEAR(order_date) AS financial_year,
    ROUND(SUM(sales),2) AS total_sales
FROM orders
WHERE YEAR(order_date) = 2017
GROUP BY YEAR(order_date);

-- Calculate total profit amount
SELECT 
ROUND(SUM(profit),2) 
AS total_profit
FROM orders;

-- Total Profit Amount for Financial Year 2017
SELECT 
    YEAR(order_date) AS financial_year,
    ROUND(SUM(profit),2) AS total_profit
FROM orders
WHERE YEAR(order_date) = 2017
GROUP BY YEAR(order_date);

-- Count total orders
SELECT 
COUNT(DISTINCT order_id) 
AS total_orders
FROM orders;

-- Count Total Orders for Financial Year 2017
SELECT 
    YEAR(order_date) AS financial_year,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
WHERE YEAR(order_date) = 2017
GROUP BY YEAR(order_date);

-- Count total unique customers
SELECT 
COUNT(DISTINCT customer_id) 
AS total_customers
FROM customers;

-- Count Total Unique Customers for Financial Year 2017
SELECT 
    YEAR(order_date) AS financial_year,
    COUNT(DISTINCT customer_id) AS total_customers
FROM orders
WHERE YEAR(order_date) = 2017
GROUP BY YEAR(order_date);

-- Find top 10 customers based on total sales
SELECT 
    c.customer_name,
    ROUND(SUM(o.sales),2) AS total_sales
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_sales DESC
LIMIT 10;


-- Find top 10 products based on sales
SELECT 
    p.product_name,
    ROUND(SUM(o.sales),2) AS total_sales
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC
LIMIT 10;


-- Calculate total sales by region
SELECT 
    c.region,
    ROUND(SUM(o.sales),2) AS regional_sales
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.region
ORDER BY regional_sales DESC;


-- Calculate total profit by product category
SELECT 
    p.category,
    ROUND(SUM(o.profit),2) AS total_profit
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY total_profit DESC;

-- Calculate Yearly Sales Performance
SELECT 
    YEAR(order_date) AS year,
    ROUND(SUM(sales),2) AS total_sales
FROM orders
GROUP BY YEAR(order_date)
ORDER BY year;

-- Calculate Monthly Sales Performance for 2017
SELECT 
    MONTH(order_date) AS month,
    ROUND(SUM(sales),2) AS monthly_sales
FROM orders
WHERE YEAR(order_date) = 2017
GROUP BY MONTH(order_date)
ORDER BY month;


-- Find Top 10 Products with Highest Losses along with Category
SELECT 
    p.category,
    p.product_name,
    ROUND(SUM(o.profit),2) AS total_loss
FROM orders o
JOIN products p
ON o.product_id = p.product_id
WHERE o.profit < 0
GROUP BY p.category, p.product_name
ORDER BY total_loss ASC
LIMIT 10;


-- Calculate average order value
SELECT 
    ROUND(SUM(sales)/COUNT(DISTINCT order_id),2) 
    AS avg_order_value
FROM orders;



-- Categorize products into High, Medium, and Low sales groups
SELECT 
    p.product_name,
    p.category,
    ROUND(SUM(o.sales),2) AS total_sales,

    CASE
        WHEN SUM(o.sales) > 5000 THEN 'High Sales'
        WHEN SUM(o.sales) > 2000 THEN 'Medium Sales'
        ELSE 'Low Sales'
    END AS sales_category

FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.product_name, p.category
ORDER BY total_sales DESC;


-- Create a view to store customer-wise sales summary
CREATE VIEW 
customer_sales AS
SELECT 
    c.customer_name,
    ROUND(SUM(o.sales),2) AS total_sales
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_name;


-- Display data from customer_sales view
SELECT 
* 
FROM customer_sales
LIMIT 10;


-- Calculate average profit earned per order
SELECT 
    ROUND(AVG(profit),2) AS avg_profit
FROM orders;

-- State-wise Sales Analysis
-- Calculate total sales and profit for each state
SELECT 
    c.state,
    ROUND(SUM(o.sales),2) AS total_sales,
    ROUND(SUM(o.profit),2) AS total_profit,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.state
ORDER BY total_sales DESC;


-- State-wise Top Performing States
-- Display top 10 states based on sales
SELECT 
    c.state,
    ROUND(SUM(o.sales),2) AS total_sales
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.state
ORDER BY total_sales DESC
LIMIT 10;



-- Calculate total quantity sold for each sub-category under every category
SELECT 
    p.category,                   
    p.sub_category,              
    SUM(o.quantity) AS total_quantity  
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.category, p.sub_category
ORDER BY total_quantity DESC;


-- Sub-category Movement Analysis
-- Categorize sub-categories as Fast Moving, Slow Moving, and Not Moving
-- based on total quantity sold
SELECT 
    p.category,
    p.sub_category,
    SUM(o.quantity) AS total_quantity,
    
    CASE
        WHEN SUM(o.quantity) > 100 THEN 'Fast Moving'
        WHEN SUM(o.quantity) BETWEEN 30 AND 100 THEN 'Slow Moving'
        ELSE 'Not Moving'
    END AS movement_status

FROM orders o
JOIN products p
ON o.product_id = p.product_id

GROUP BY p.category, p.sub_category
ORDER BY p.category, total_quantity DESC;

-- Fast Moving Sub-categories
SELECT 
    p.category,
    p.sub_category,
    SUM(o.quantity) AS total_quantity
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.category, p.sub_category
HAVING SUM(o.quantity) > 3000
ORDER BY total_quantity DESC;

-- Slow Moving Sub-categories
SELECT 
    p.category,
    p.sub_category,
    SUM(o.quantity) AS total_quantity
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.category, p.sub_category
HAVING SUM(o.quantity) BETWEEN 1000 AND 3000
ORDER BY total_quantity DESC;

-- Not Moving Sub-categories
SELECT 
    p.category,
    p.sub_category,
    SUM(o.quantity) AS total_quantity
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.category, p.sub_category
HAVING SUM(o.quantity) < 1000
ORDER BY total_quantity ASC;


