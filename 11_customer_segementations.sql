-- BUSINESS QUESTION 2.   Customer Segmentation & Retention  
--      Who are the top 10 customers by total spending?
--      Are there customers who have stopped purchasing (churn)?

--set the search path to the superstore schema
SET search_path TO superstore, public;

WITH customer_summary AS (
    SELECT 
        customer_id,
        customer_name,
        COUNT(order_id) AS total_order,
        SUM(sales) AS total_spending,
        MAX(order_date) AS last_purchase_date
    FROM superstore.orders
    GROUP BY customer_id, customer_name
),
segmented_customers AS (
    SELECT 
        customer_id,
        customer_name,
        total_order,
        total_spending,
        last_purchase_date,
        CASE 
            WHEN last_purchase_date >= CURRENT_DATE - INTERVAL '3 months' THEN 'Active'
            WHEN last_purchase_date >= CURRENT_DATE - INTERVAL '6 months' THEN 'At Risk'
            ELSE 'Churned'
        END AS churn_status
    FROM customer_summary
),
top_customers AS (
    SELECT    
        customer_id,
        customer_name,
        total_order,
        total_spending,
        last_purchase_date,'Top 10 Spender' AS segment
    FROM segmented_customers
    ORDER BY total_spending DESC, total_order DESC
    LIMIT 10
),
bottom_customers AS (
    SELECT
        customer_id,
        customer_name,
        total_order,
        total_spending,
        last_purchase_date, 'Bottom 10 Spender' AS segment
    FROM segmented_customers
    ORDER BY total_spending ASC, total_order DESC
    LIMIT 10
)
SELECT *
FROM top_customers
UNION ALL
SELECT *
FROM bottom_customers
UNION ALL
SELECT *
FROM segmented_customers
WHERE churn_status IN ('At Risk', 'Churned')
ORDER BY total_spending DESC;
