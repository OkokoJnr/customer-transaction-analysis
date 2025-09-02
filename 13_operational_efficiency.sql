-- 4.   Operational Efficiency  
--      How do shipping modes affect delivery times and profitability?
--      Do discounts increase sales or simply reduce profit?
--set the search path to the superstore schema
SET search_path TO superstore, public;
-- This SQL script analyzes operational efficiency in terms of shipping modes and discount strategies.

--Profitability, average delivery time (in days) and order count across shipping mode and region
SELECT  
    ship_mode,
    COUNT(*) AS total_orders,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,   
    AVG(ship_date - order_date) AS avg_delivery_time_days
FROM superstore.orders
    GROUP BY ship_mode
    ORDER BY total_profit DESC;


