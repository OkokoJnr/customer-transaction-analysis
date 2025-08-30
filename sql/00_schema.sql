-- This SQL script creates the necessary schema for the Superstore database.
CREATE SCHEMA IF NOT EXISTS superstore;

--SET search_path TO superstore;
SET search_path TO superstore, public;

-- staging the customers table
DROP TABLE IF EXISTS public.stg_customers;
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
DROP TABLE IF EXISTS superstore.stg_orders;
CREATE TABLE superstore.stg_orders (
  order_id   TEXT,
  order_date TEXT,
  ship_date  TEXT,
  ship_mode  TEXT,
  customer_id TEXT,
  product_id TEXT
);

-- Staging table for products transactions (raw)
DROP TABLE IF EXISTS superstore.stg_products;
CREATE TABLE superstore.stg_products (
  product_id    TEXT,
  category      TEXT,
  sub_category  TEXT,
  product_name  TEXT,
  sales         TEXT,
  quantity      TEXT,
  discount      TEXT,
  profit        TEXT
);
