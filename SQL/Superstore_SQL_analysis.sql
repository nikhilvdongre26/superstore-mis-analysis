Create database superstore_mis;
Use superstore_mis;

drop table sales_test;

CREATE TABLE sales (
    row_id INT,
    order_id VARCHAR(30),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),

    customer_id VARCHAR(30),
    customer_name VARCHAR(150),
    segment VARCHAR(50),

    country VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    region VARCHAR(50),

    product_id VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),

    sales DECIMAL(12,2),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(12,2),

    order_year INT,
    order_month VARCHAR(10),
    quarter VARCHAR(5),
    shipping_days INT,
    profit_margin DECIMAL(10,4)
);

LOAD DATA LOCAL INFILE 'C:/Users/HP/Downloads/SuperStore_Cleaned.csv'
INTO TABLE sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

select * from sales;

-- Total Sales
SELECT ROUND(SUM(sales),2) as total_sales
from sales;

-- Total Profit
SELECT ROUND(SUM(profit),2) as total_profit
from sales;

-- Profit Margin %
SELECT ROUND(SUM(profit)/SUM(sales)*100,2) as profit_margin_pct
from sales;

-- Total Orders
SELECT COUNT(DISTINCT order_id) as total_orders
from sales;

-- Region Performance
SELECT 
      region,
      ROUND(SUM(sales),2) as sales,
      ROUND(SUM(profit),2) as profit
FROM sales
GROUP BY region
ORDER BY sales DESC;

-- Category Performance
SELECT 
      category,
      ROUND(SUM(sales),2) as sales,
      ROUND(SUM(profit),2) as profit
FROM sales
GROUP BY category
ORDER BY sales DESC;

-- Top 10 Sub-Categories
SELECT 
      sub_category,
      ROUND(SUM(sales),2) as sales,
      ROUND(SUM(profit),2) as profit
FROM sales
GROUP BY sub_category
ORDER BY sales DESC
Limit 10;

-- Loss-Making Sub-Categories
SELECT
      sub_category,
      ROUND(SUM(profit),2) as profit
FROM sales
GROUP BY sub_category
HAVING SUM(profit) < 0
ORDER BY profit;

-- Advanced Analysis

-- Top 10 Customers by Sales
SELECT 
      customer_name,
       ROUND(SUM(sales),2) AS total_sales,
       ROUND(SUM(profit),2) AS total_profit
FROM sales
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 10;

-- Top 10 Products
SELECT 
      product_name,
      ROUND(SUM(sales),2) as revenue
FROM sales
GROUP BY product_name
ORDER BY revenue DESC
LIMIT 10;

-- Sales by Year
SELECT
    order_year,
    ROUND(SUM(sales),2) AS sales,
    ROUND(SUM(profit),2) AS profit
FROM sales
GROUP BY order_year
ORDER BY order_year;

-- Average Shipping Time
SELECT 
      ROUND(Avg(shipping_days),2) as avg_shipping_days
FROM sales;

-- Region Profit Margin
SELECT
    region,
    ROUND(SUM(sales),2) AS sales,
    ROUND(SUM(profit),2) AS profit,
    ROUND((SUM(profit)/SUM(sales))*100,2) AS profit_margin_pct
FROM sales
GROUP BY region
ORDER BY profit_margin_pct DESC;