--1.   Revenue & Profitability  
    --  What are the overall sales and profit trends?
    --  Which categories and sub-categories are most/least profitable?

--Overall Sales and Profit Trends
-- Monthly Sales and Profit
WITH m AS (
SELECT date_trunc('month', order_date)::date AS month_start,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM superstore.orders
GROUP BY 1)
SELECT to_char(month_start, 'YYYY-MM') AS month_ym,
       total_sales,
       total_profit
FROM m
ORDER BY month_start;
--Categories that are most/least profitable?
a

--Sub-categories that are most profitable? (top 7)
SELECT
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM superstore.orders
GROUP BY 1 
ORDER BY total_profit DESC
LIMIT 7

--Sub-categories that are least profitable? (bottom 8)
SELECT
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM superstore.orders
GROUP BY 1
ORDER BY total_profit ASC
LIMIT 8

--profitability and sales of categories and subcategories over months
SELECT 
    TO_CHAR(order_date, 'month') AS order_month,
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM superstore.orders
GROUP BY 1,2
ORDER BY order_month, total_profit DESC

SELECT
    TO_CHAR(order_date, 'month') AS order_month,
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM superstore.orders
GROUP BY 1,2
ORDER BY order_month, total_profit DESC

--REGIONAL PERFORMANCE ACROSS CATEGORIES AND SUB_CATEGORIES -profitability and sales of categories and subcategories over regions

-- regions
SELECT
    region,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM superstore.orders 
GROUP BY 1
ORDER BY total_profit DESC;

--total profit of categories across regions
SELECT
    region,
    category,
    SUM(profit) AS total_profit
FROM superstore.orders
GROUP BY 1,2
ORDER BY region, category DESC;

--total profit of sub_categories across regions
SELECT
    region ,
    category,
    sub_category,
    SUM(profit)  AS total_profit,
     ROW_NUMBER () OVER(PARTITION BY region ORDER BY SUM(profit)) AS profit_rank
FROM superstore.orders 
GROUP BY 1,2,3
ORDER BY region ASC, total_profit DESC, category ASC
