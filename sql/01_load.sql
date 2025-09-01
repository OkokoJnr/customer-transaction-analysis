--- seet search path
SET search_path TO superstore, public;

---copy data into staging tables
copy superstore.stg_orders FROM 'C:\Program Files\PostgreSQL\17/Sample - Superstore.csv' WITH (FORMAT csv, HEADER true);

SELECT COUNT(*) from superstore.stg_orders;