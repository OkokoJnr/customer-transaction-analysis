-- This SQL script creates the necessary schema for the Superstore database.
CREATE SCHEMA IF NOT EXISTS superstore;

--SET search_path TO superstore;
SET search_path TO superstore, public;

-- Create the staging table
DROP TABLE IF EXISTS superstore.stg_orders CASCADE;

CREATE TABLE superstore.stg_orders (
    row_id TEXT,              -- Unique ID for each row
    order_id TEXT,            -- Unique order ID for each customer
    order_date TEXT,          -- Order date
    ship_date TEXT,           -- Shipping date
    ship_mode TEXT,           -- Shipping mode
    customer_id TEXT,         -- Unique customer ID
    customer_name TEXT,       -- Name of the customer
    segment TEXT,             -- Customer segment
    country TEXT,             -- Country of residence
    city TEXT,                -- City of residence
    state TEXT,               -- State of residence
    postal_code TEXT,         -- Postal code
    region TEXT,              -- Region of the customer
    product_id TEXT,          -- Unique product ID
    category TEXT,            -- Product category
    sub_category TEXT,        -- Product sub-category
    product_name TEXT,        -- Product name
    sales TEXT,               -- Sales of the product
    quantity TEXT,            -- Quantity of the product
    discount TEXT,            -- Discount applied
    profit TEXT               -- Profit or loss
);