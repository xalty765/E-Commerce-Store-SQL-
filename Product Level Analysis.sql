-- Product and Sales Analysis

SELECT 
    primary_product_id, COUNT(order_id)
FROM
    orders
WHERE
    order_id BETWEEN 10000 AND 11000
GROUP BY 1
ORDER BY 2 DESC;   

-- 1. Product level sales analysis

SELECT 
    YEAR(created_at) AS yr,
    MONTH(created_at) AS mon,
    COUNT(order_id) AS sales,
    SUM(price_usd) AS revenue,
    SUM(price_usd - cogs_usd) AS margin
FROM
    orders
WHERE
    created_at < '2013-01-04'
GROUP BY 1 , 2
ORDER BY 3 DESC;

-- 2. Impact of new product launch

SELECT YEAR(o.created_at) AS yr,
MONTH(o.created_at) AS mon,
COUNT(DISTINCT o.order_id) AS orders,
Count(DISTINCT ws.website_session_id) AS sessions,
COUNT(DISTINCT o.order_id)/COUNT(DISTINCT ws.website_session_id) AS conv_rate,
SUM(o.price_usd)/Count(DISTINCT ws.website_session_id) AS revenue_per_session,
COUNT(DISTINCT CASE WHEN primary_product_id =1 THEN O.ORDER_ID ELSE NULL END) as product_1_orders,
COUNT(DISTINCT CASE WHEN primary_product_id =2 THEN O.ORDER_ID ELSE NULL END) as product_2_orders
FROM website_sessions ws
LEFT JOIN orders o 
ON ws.website_session_id = o.website_session_id
WHERE ws.created_at < '2013-04-05'
AND ws.created_at > '2012-04-01'
GROUP BY  1,2;

-- 2 . Product level website pathing
SELECT 
    wp.pageview_url,
    COUNT(DISTINCT website_pageview_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders
FROM
    website_pageviews wp
        LEFT JOIN
    orders o ON o.website_session_id = wp.website_session_id
WHERE
    wp.created_at BETWEEN '2013-02-01' AND '2013-03-01'
        AND wp.pageview_url IN ('/the-original-mr-fuzzy' , '/the-forever-love-bear')
GROUP BY 1;

--  IDENTIFYING REPEAT VISITORS

WITH cte AS (
SELECT user_id, count(DISTINCT website_session_id) AS  repeat_sessions 
FROM website_sessions
WHERE created_at < '2014-11-01' 
AND created_at> '2014-01-01'
GROUP BY 1
)
SELECT repeat_sessions,COUNT(user_id)
FROM cte 
GROUP BY  1;


