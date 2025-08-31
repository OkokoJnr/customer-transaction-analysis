SET search_path TO superstore, public;

-- This SQL script cleans and transforms the customers data from the staging table to the final customers table.
-- It ensures data integrity and prepares the data for analysis.

--checking for duplicates before creating main tables
SELECT customer_id, COUNT(*)
FROM superstore.stg_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

--removing duplicates if any
--remove duplicates based on the minimum ctid for each customer_id
DELETE FROM superstore.stg_customers
WHERE ctid NOT IN (
    SELECT MIN(ctid)
    FROM superstore.stg_customers
    GROUP BY customer_id
);

---CHECKING IF THERE ARE NULL VALUES IN THE FINAL TABLE
SELECT COUNT(*) FROM superstore.stg_customers WHERE customer_id IS NULL
OR customer_name IS NULL OR country IS NULL
OR city IS NULL OR state IS NULL;

-- Drop the final customers table if it exists
DROP TABLE IF EXISTS superstore.customers;
CREATE TABLE superstore.customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(150) NOT NULL,
    segment VARCHAR(100) NOT NULL,
    country VARCHAR,
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(50),
    region VARCHAR(50)
)

--- Insert cleaned data into the final customers table
INSERT INTO superstore.customers (customer_id, customer_name, segment, country, city, state, postal_code, region)
SELECT DISTINCT customer_id, customer_name, segment, country, city, state, postal_code, region
FROM superstore.stg_customers


SELECT COUNT(*) FROM superstore.customers
-- Verify that duplicates have been removed
SELECT 
    COUNT(*) AS duplicate_count
FROM 
    customers
GROUP BY customer_id, customer_name, segment, country, city, state, postal_code, region
