--- seet search path
SET search_path TO superstore, public;

---copy data into staging tables
copy stg_customers FROM 'C:\Program Files\PostgreSQL\17/superstore-customer.csv' WITH (FORMAT csv, HEADER true);
copy stg_orders    FROM 'C:\Program Files\PostgreSQL\17/superstore-orders.csv'   WITH (FORMAT csv, HEADER true);
copy stg_products  FROM 'C:\Program Files\PostgreSQL\17/superstore-products.csv' WITH (FORMAT csv, HEADER true);


SELECT * FROM stg_products LIMIT 5;

SELECT * FROM stg_customers LIMIT 5

SELECT * FROM stg_orders LIMIT 5