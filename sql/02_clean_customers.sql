SET search_path TO superstore, public;

-- This SQL script cleans and transforms the customers data from the staging table to the final customers table.
-- It ensures data integrity and prepares the data for analysis.
-- Drop the final customers table if it exists
DROP TABLE IF EXISTS customers;
CREATE TABLE customers AS
SELECT
    customer_id,
    customer_name,
    segment,
    country,
    city,
    state,
    postal_code,
    region
FROM
    stg_customers
WHERE
    customer_id IS NOT NULL

---CHECKING IF THERE ARE NULL VALUES IN THE FINAL TABLE
SELECT COUNT(*) FROM customers WHERE customer_id IS NULL
OR customer_name IS NULL OR country IS NULL
OR city IS NULL OR state IS NULL;

--CHECK FOR DUPLICATES
SELECT customer_id, COUNT(*)
FROM customers
GROUP BY customer_id, customer_name, segment, country, city, state, postal_code, region
HAVING COUNT(*) > 1;

--removing duplicates if any
--remove duplicates based on the minimum ctid for each customer_id

DELETE FROM customers
WHERE ctid NOT IN (
    SELECT MIN(ctid)
    FROM customers
    GROUP BY customer_id, customer_name, segment, country, city, state, postal_code, region
);

-- Verify that duplicates have been removed
SELECT 
    COUNT(*) AS duplicate_count
FROM 
    customers
GROUP BY customer_id, customer_name, segment, country, city, state, postal_code, region
