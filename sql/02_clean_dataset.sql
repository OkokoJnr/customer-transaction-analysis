SET search_path TO superstore, public;

-- This SQL script cleans and transforms the orders data from the staging table to the final orders table.
-- It ensures data integrity and prepares the data for analysis.

--checking for duplicates before creating main tables. from details about the dataset, row_id is unique
SELECT  COUNT(*)
FROM superstore.stg_orders
GROUP BY row_id
HAVING COUNT(*) > 1;

--removing duplicates if any. Duplicate here is define as rows with same row id or rows where all columns are thesame.

--remove duplicates based on the minimum ctid for each customer_id
DROP TABLE superstore.stg_orders_clean;
CREATE TABLE superstore.stg_orders_clean (
    row_id INT,
    order_id TEXT,
    order_date    DATE, 
    ship_date     DATE,
    ship_mode     TEXT,
    customer_id   TEXT,
    customer_name TEXT, 
    segment       TEXT,
    country       TEXT,
    city          TEXT,
    state         TEXT,
    postal_code   TEXT,
    region        TEXT,
    product_id    TEXT,
    category      TEXT,
    sub_category  TEXT,
    product_name  TEXT,
    sales         NUMERIC(12,2),
    quantity      INT,
    discount      NUMERIC(5,2),
    profit        NUMERIC(12,2)
);

INSERT INTO superstore.stg_orders_clean
SELECT
    row_id::INT,
    order_id,
    order_date::DATE,
    ship_date::DATE,
    ship_mode,
    customer_id,
    customer_name,
    segment,
    country,
    city,
    state,
    postal_code,
    region,
    product_id,
    category,
    sub_category,
    product_name,
    sales::NUMERIC(12,2),
    quantity::INT,
    discount::NUMERIC(5,2),
    profit::NUMERIC(12,2)
FROM superstore.stg_orders;


DELETE FROM superstore.stg_orders_clean
WHERE ctid NOT IN (
    SELECT MIN(ctid)
    FROM superstore.stg_orders_clean
    GROUP BY order_id, order_date, ship_date,  ship_mode, customer_id, customer_name, segment, country, city,state, postal_code, region, product_id, category, sub_category, product_name, sales,quantity, discount,profit ---group by the column that defines duplicates -- in this case all columns except row_id
);
--recheck for duplicates
SELECT  
    order_id, 
    order_date, 
    ship_date,  
    ship_mode, 
    customer_id, 
    customer_name, 
    segment, country, 
    city,
    state, 
    postal_code, 
    region, 
    product_id, 
    category, 
    sub_category, 
    product_name, 
    sales,quantity, 
    discount,profit 
FROM superstore.stg_orders_clean
GROUP BY 
    order_id, 
    order_date, 
    ship_date,  
    ship_mode, 
    customer_id, 
    customer_name, 
    segment, 
    country, 
    city,
    state, 
    postal_code, 
    region, 
    product_id, 
    category, 
    sub_category, 
    product_name, 
    sales,
    quantity, 
    discount,
    profit 
HAVING COUNT(*) > 1

-- Create the final orders table
DROP TABLE IF EXISTS superstore.orders
CREATE TABLE IF NOT EXISTS superstore.orders(
    row_id INT PRIMARY KEY,
    order_id VARCHAR(50) NOT NULL,
    order_date date,
    ship_date date,
    ship_mode TEXT NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    customer_name VARCHAR(50) NOT NULL,
    segment VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR,
    postal_code VARCHAR(50) NOT NULL,
    region VARCHAR(50) NULL,
    product_id VARCHAR(100) NOT NULL,
    category VARCHAR (50) NOT NULL,
    sub_category VARCHAR (100) NOT NULL,
    product_name TEXT NOT NULL,
    sales numeric NOT NULL,
    quantity INT NOT NULL,
    discount numeric, 
    profit NUMERIC, 
    profit_margin numeric(12,4) GENERATED ALWAYS AS (CASE WHEN sales > 0 THEN profit / sales ELSE 0 END) STORED
)

SELECT * FROM superstore.orders LIMIT 10;

INSERT INTO superstore.orders(
    row_id, 
    order_id, 
    order_date, 
    ship_date, 
    ship_mode, 
    customer_id, 
    customer_name, 
    segment, 
    country, 
    city, 
    state, 
    postal_code, 
    region, 
    product_id, 
    category, 
    sub_category, 
    product_name, 
    sales, 
    quantity, 
    discount, 
    profit
)

SELECT 
    CAST(row_id AS INT), 
    order_id,
    order_date::date,
    ship_date::date,
    ship_mode,
    customer_id,
    customer_name,
    segment,
    country,
    city,
    state,
    postal_code,
    region,
    product_id,
    category,
    sub_category,
    product_name,
    CAST(sales AS NUMERIC),
    CAST(quantity AS INT),
    CAST(discount AS NUMERIC),
    CAST(profit AS NUMERIC)
FROM superstore.stg_orders_clean
