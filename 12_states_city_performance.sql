-- 3. States and Cities Performance  
--      Which states, or cities generate the highest revenue?
--      Are there markets where losses consistently occur?

--      Which states/cities have the highest sales volume?
--      How do sales and profitability trends vary across different states/cities over time?
--set the search path to the superstore schema
SET search_path TO superstore, public;
-- This SQL script analyzes the performance of different states and cities in terms of sales and profitability.

--      Which states/cities are most/least profitable?
--most profitable states/cities
SELECT
    state,
    city,
    SUM(profit) AS total_profit
FROM superstore.orders
GROUP BY state, city
ORDER BY total_profit DESC
LIMIT 10;

--least profitable states/cities
SELECT
    state,
    city,
    SUM(profit) AS total_profit
FROM superstore.orders
GROUP BY state, city
ORDER BY total_profit ASC
LIMIT 10;

--states with highest sales volume
SELECT
    state,
    city,
    SUM(sales) AS total_sales
FROM superstore.orders
GROUP BY state, city
ORDER BY total_sales DESC
LIMIT 10;

--states with least sales volume
SELECT
    state,
    city,
    SUM(sales) AS total_sales
FROM superstore.orders
GROUP BY state, city
ORDER BY total_sales ASC
LIMIT 10;

--sales and profitability trends over time across states/cities
SELECT
     TO_CHAR(order_date, 'Month') AS order_month,
     state,
     SUM(sales) AS total_sales,
     SUM(profit) AS total_profit
FROM superstore.orders
GROUP BY 1,2
ORDER BY total_profit DESC, order_month;

