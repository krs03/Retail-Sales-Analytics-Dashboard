CREATE DATABASE retail_analysis;
USE retail_analysis;

CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    region VARCHAR(50)
);

CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name TEXT
);


CREATE TABLE orders (
    row_id INT,
    order_id VARCHAR(50),
    order_date VARCHAR(50),
    ship_date VARCHAR(50),
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    product_id VARCHAR(50),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(10,2),

    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id),

    FOREIGN KEY (product_id)
    REFERENCES products(product_id)
);
SELECT COUNT(*) FROM orders;


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


SELECT ROUND(SUM(sales),2) AS total_sales
FROM orders;

SELECT ROUND(SUM(profit),2) AS total_profit
FROM orders;

SELECT COUNT(DISTINCT order_id) AS total_orders
FROM orders;

SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM customers;

SELECT 
    c.customer_name,
    ROUND(SUM(o.sales),2) AS total_sales
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_sales DESC
LIMIT 10;

SELECT 
    p.product_name,
    ROUND(SUM(o.sales),2) AS total_sales
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC
LIMIT 10;

SELECT 
    c.region,
    ROUND(SUM(o.sales),2) AS regional_sales
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.region
ORDER BY regional_sales DESC;

SELECT 
    p.category,
    ROUND(SUM(o.profit),2) AS total_profit
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY total_profit DESC;

SELECT 
    MONTH(order_date) AS month,
    ROUND(SUM(sales),2) AS monthly_sales
FROM orders
GROUP BY MONTH(order_date)
ORDER BY month;

SELECT 
    p.product_name,
    ROUND(SUM(o.profit),2) AS total_loss
FROM orders o
JOIN products p
ON o.product_id = p.product_id
WHERE o.profit < 0
GROUP BY p.product_name
ORDER BY total_loss ASC
LIMIT 10;

SELECT 
    ROUND(SUM(sales)/COUNT(DISTINCT order_id),2) 
    AS avg_order_value
FROM orders;

SELECT 
    order_id,
    sales,
    CASE
        WHEN sales > 500 THEN 'High Sales'
        WHEN sales > 200 THEN 'Medium Sales'
        ELSE 'Low Sales'
    END AS sales_category
FROM orders;

CREATE VIEW customer_sales AS
SELECT 
    c.customer_name,
    ROUND(SUM(o.sales),2) AS total_sales
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_name;

SELECT * FROM customer_sales
LIMIT 10;

SELECT 
    ROUND(AVG(profit),2) AS avg_profit
FROM orders;