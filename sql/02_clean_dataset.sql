SET search_path TO superstore, public;

-- This SQL script cleans and transforms the orders data from the staging table to the final orders table.
-- It ensures data integrity and prepares the data for analysis.

--checking for duplicates before creating main tables. from details about the dataset, row_id is unique
SELECT  COUNT(*)
FROM superstore.stg_orders
GROUP BY row_id
HAVING COUNT(*) > 1;

--removing duplicates if any. Duplicate here is define as rows with same row id or rows where all columns are thesame.

--cast and trim data types and create a clean staging table
DROP TABLE IF EXISTS superstore.stg_orders_casted;
CREATE TABLE superstore.stg_orders_casted AS 
SELECT
    NULLIF(TRIM(row_id), '')::INT AS row_id,
    NULLIF(TRIM(order_id), '') AS order_id,
    TO_DATE(NULLIF(TRIM(order_date), ''), 'MM/DD/YYYY') AS order_date,
    TO_DATE(NULLIF(TRIM(ship_date), ''), 'MM/DD/YYYY') AS ship_date,
    NULLIF(TRIM(ship_mode), '') AS ship_mode,
    NULLIF(TRIM(customer_id), '') AS customer_id,
    NULLIF(TRIM(customer_name), '') AS customer_name,
    NULLIF(TRIM(segment), '') AS segment,
    NULLIF(TRIM(country), '') AS country,

    NULLIF(TRIM(city), '') AS city,
    NULLIF(TRIM(state), '') AS state,
    NULLIF(TRIM(postal_code), '') AS postal_code,
    NULLIF(TRIM(region), '') AS region,
    NULLIF(TRIM(product_id), '') AS product_id,
    NULLIF(TRIM(category), '') AS category,
    NULLIF(TRIM(sub_category), '') AS sub_category,
    NULLIF(TRIM(product_name), '') AS product_name,
    NULLIF(TRIM(sales), '')::NUMERIC(12,2) AS sales,
    NULLIF(TRIM(quantity), '')::INT AS quantity,
    NULLIF(TRIM(discount), '')::NUMERIC(5,2) AS discount,
    NULLIF(TRIM(profit), '')::NUMERIC(12,2) AS profit
FROM superstore.stg_orders;

--DEDUPLICATE 
DROP TABLE IF EXISTS superstore.stg_orders_clean;
CREATE TABLE superstore.stg_orders_clean AS
WITH ranked_orders AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY order_id, order_date, ship_date, ship_mode, customer_id, customer_name, segment,
                         country, city, state, postal_code, region, product_id, category, sub_category,
                         product_name, sales, quantity, discount, profit
            ORDER BY row_id
        ) AS rn
    FROM superstore.stg_orders_casted
)
SELECT *
FROM ranked_orders
WHERE rn = 1;

DROP TABLE IF EXISTS superstore.stg_orders_clean_final;
CREATE TABLE superstore.stg_orders_clean_final AS (
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
FROM superstore.stg_orders_clean
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
FROM superstore.stg_orders_clean_final
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
SELECT COUNT(*) FROM superstore.stg_orders_clean_final;

-- Create the final orders table
DROP TABLE IF EXISTS superstore.orders;
CREATE TABLE superstore.orders(
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
    row_id, 
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


--Build dimensions with surrogate keys, and populates the fact table.

-- Safety drops

DROP TABLE IF EXISTS superstore.fact_sales CASCADE;
DROP TABLE IF EXISTS superstore.dim_products CASCADE;
DROP TABLE IF EXISTS superstore.dim_customers CASCADE;
DROP TABLE IF EXISTS superstore.dim_orders CASCADE;
DROP TABLE IF EXISTS superstore.stg_superstore CASCADE;


--Dimension tables (surrogate PKs)

-- Orders
CREATE TABLE superstore.dim_orders (
    order_key   BIGSERIAL PRIMARY KEY,
    order_id    TEXT UNIQUE NOT NULL,
    order_date  DATE,
    ship_date   DATE,
    ship_mode   TEXT
);
INSERT INTO superstore.dim_orders (order_id, order_date, ship_date, ship_mode)
SELECT DISTINCT
    s.order_id,
    s.order_date,
    s.ship_date,
    s.ship_mode
FROM superstore.stg_orders_clean s;

CREATE INDEX ON superstore.dim_orders (order_id);

--Dimension Customers
CREATE TABLE superstore.dim_customers (
    customer_key   BIGSERIAL PRIMARY KEY,
    customer_id    TEXT UNIQUE NOT NULL,
    customer_name  TEXT,
    segment        TEXT,
    country        TEXT,
    city           TEXT,
    state          TEXT,
    postal_code    TEXT,
    region         TEXT
);

INSERT INTO superstore.dim_customers (customer_id, customer_name, segment, country, city, state, postal_code, region)
SELECT DISTINCT ON (s.customer_id)
    customer_id, s.customer_name, s.segment, s.country, s.city, s.state, s.postal_code, s.region
FROM superstore.stg_orders_clean s;
--create indexes to optimize query performance
CREATE INDEX ON superstore.dim_customers (customer_id);
CREATE INDEX ON superstore.dim_customers (region);
CREATE INDEX ON superstore.dim_customers (state);

-- Products
CREATE TABLE superstore.dim_products (
    product_key   BIGSERIAL PRIMARY KEY,
    product_id    TEXT UNIQUE NOT NULL,
    category      TEXT,
    sub_category  TEXT,
    product_name  TEXT
);

INSERT INTO superstore.dim_products (product_id, category, sub_category, product_name)
SELECT DISTINCT ON (s.product_id)
    s.product_id, s.category, s.sub_category, s.product_name
FROM superstore.stg_orders_clean s;

CREATE INDEX ON dim_products (product_id);
CREATE INDEX ON dim_products (category);
CREATE INDEX ON dim_products (sub_category);

-- Fact table
DROP TABLE IF EXISTS superstore.fact_sales;
CREATE TABLE superstore.fact_sales (
    sales_key      BIGSERIAL PRIMARY KEY,
    order_key      BIGINT REFERENCES superstore.dim_orders(order_key),
    customer_key   BIGINT REFERENCES superstore.dim_customers(customer_key),
    product_key    BIGINT REFERENCES superstore.dim_products(product_key),
    sales          NUMERIC(12,2),
    quantity       INT,
    discount       NUMERIC(5,2),
    profit         NUMERIC(12,2),
    profit_margin  NUMERIC(12,4)
);
INSERT INTO superstore.fact_sales (order_key, customer_key, product_key, sales, quantity, discount, profit, profit_margin)
SELECT
    o.order_key,
    c.customer_key,
    p.product_key,
    s.sales,
    s.quantity,
    s.discount,
    s.profit,
    CASE WHEN s.sales > 0 THEN s.profit / s.sales ELSE 0 END AS profit_margin
FROM superstore.orders s
JOIN superstore.dim_orders o ON s.order_id = o.order_id
JOIN superstore.dim_customers c ON s.customer_id = c.customer_id
JOIN superstore.dim_products p ON s.product_id = p.product_id;
-- Verify the number of records in the fact table
SELECT COUNT(*) AS fact_sales_count FROM superstore.fact_sales;
