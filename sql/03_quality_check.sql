--set the search path to the superstore schema
SET search_path TO superstore, public;
-- This SQL script performs data quality checks on the cleaned orders data.
-- It checks, row count, for duplicates, null values, and ensures data integrity before finalizing the dataset.

--row count check
SELECT 
    (SELECT COUNT(*) FROM superstore.stg_orders) AS stage_rows,
    (SELECT COUNT(*) FROM superstore.orders) AS fact_rows 


-- NULL COUNT IN CRITICAL COLUMNS
SELECT
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN order_id IS NULL THEN 1 END) AS null_order_id,
    COUNT(CASE WHEN customer_id IS NULL THEN 1 END) AS null_customer_id,
    COUNT(CASE WHEN product_id IS NULL THEN 1 END) AS null_product_id,
    COUNT(CASE WHEN sales IS NULL THEN 1 END) AS null_sales,
    COUNT(CASE WHEN quantity IS NULL THEN 1 END) AS null_quantity
FROM superstore.orders;

--NEGATIVE PROFIT CHECK AND DISCOUNT OUTLIERS

SELECT 
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN profit < 0 THEN '1' END) AS negative_profit,
    COUNT(CASE WHEN discount < 0 OR discount > 1 THEN 1 END) AS outlier_discount
FROM superstore.orders;

SELECT * FROM superstore.orders WHERE profit < 0