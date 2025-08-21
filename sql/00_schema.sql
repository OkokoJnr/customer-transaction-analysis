-- This SQL script creates the necessary schema for the Superstore database.
CREATE SCHEMA IF NOT EXISTS superstore;

--SET search_path TO superstore;
SET search_path TO superstore, public;

-- staging the customers table
DROP TABLE IF EXISTS stg_customers;
CREATE TABLE stg_customers (
  customer_id   TEXT,
  customer_name TEXT,
  segment       TEXT,
  country       TEXT,
  city          TEXT,
  state         TEXT,
  postal_code   TEXT,
  region        TEXT
);

-- Staging table for orders (raw)
DROP TABLE IF EXISTS stg_orders;
CREATE TABLE stg_orders (
  order_id   TEXT,
  order_date TEXT,
  ship_date  TEXT,
  ship_mode  TEXT
);


-- Staging table for products transactions (raw)
DROP TABLE IF EXISTS stg_products;
CREATE TABLE stg_products (
  customer_id   TEXT,
  product_id    TEXT,
  category      TEXT,
  sub_category  TEXT,
  product_name  TEXT,
  sales         TEXT,
  quantity      TEXT,
  discount      TEXT,
  profit        TEXT,
  order_id      TEXT
);
