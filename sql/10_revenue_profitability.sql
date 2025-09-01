--1.   Revenue & Profitability  
    --  What are the overall sales and profit trends?
    --  Which categories and sub-categories are most/least profitable?

--Overall Sales and Profit Trends
-- Monthly Sales and Profit
SELECT TO_CHAR(order_date, 'month'),
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM superstore.orders
GROUP BY 1
ORDER BY 2 DESC;

