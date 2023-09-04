
/* ANALYZING TOP TRAFFIC SOURCES 
*/

-- 1. FINDING TOP TRAFFIC SOURCES

SELECT 
    utm_source,
    utm_campaign,
    http_referer,
    COUNT(DISTINCT website_session_id) AS no_of_sessions,
    http_referer
FROM
    website_sessions
WHERE
    created_at < '2012-04-12'
GROUP BY 1 , 2 , 3
ORDER BY 4 DESC;


-- GSEARCH NONBRAND HAD THE HIGHEST TRAFFIC OUT OF ALL(OPPOURTUNITY TO OPTIMIZE BIDDING ON THIS CAMPAIGN)

-- TRAFFIC SOURCE CONVERSION

-- 1. FINDING TOP TRAFFIC SOURCES

SELECT 
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT O.order_id) AS orders
FROM
    website_sessions ws
        LEFT JOIN
    orders O ON O.website_session_id = ws.website_session_id
WHERE
    ws.created_at < '2012-04-14';

-- 2. CONVERSION RATE CALCULATION

SELECT 
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT O.order_id) AS orders,
    COUNT(DISTINCT O.order_id) / COUNT(DISTINCT ws.website_session_id) * 100 AS session_ordr_cvr
FROM
    website_sessions ws
        LEFT JOIN
    orders O ON O.website_session_id = ws.website_session_id
WHERE
    ws.created_at < '2012-04-14'
        AND ws.utm_source = 'gsearch'
        AND ws.utm_campaign = 'nonbrand';
        
        
/*
DESPITE THE TRAFFIC ON THE GSEARCH NON BRAND THE CONVERSION RATE WAS LOWER THAN 4 % SO WE CAN LOWER THE MONEY WE SPEND ON THIS
*/

        
/*
BID OPTIMIZATION AND TREND ANALYSIS
*/

SELECT 
    YEAR(created_at),
    WEEK(created_at),
    MIN(DATE(created_at)) AS week_start,
    COUNT(DISTINCT website_session_id) AS sessions
FROM
    website_sessions
GROUP BY 1 , 2
LIMIT 1000;


SELECT 
    primary_product_id,
    COUNT(CASE WHEN items_purchased = 1 THEN order_id ELSE NULL END) AS Single_item_order,
    COUNT(CASE WHEN items_purchased = 2 THEN order_id ELSE NULL END) AS multi_item_order,
    COUNT(DISTINCT order_id) AS total_orders
FROM
    orders    
GROUP BY 1;

-- TRAFFIC SOURCE TREND ANALYSIS

SELECT 
    MIN(DATE(created_at)) AS week_started_at,
    COUNT(DISTINCT website_session_id)
FROM
    website_sessions
WHERE
    created_at < '2012-05-12'
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
GROUP BY WEEK(created_at);

--  FINDING THE CONVERSION RATE FROM SESSION TO ORDERS FOR EACH DEVICE TYPE AND OPTIMIZING THE BIDDING TO GENERATE MORE TRAFFIC

SELECT 
    device_type,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT O.order_id) AS orders,
    COUNT(DISTINCT O.order_id) / COUNT(DISTINCT ws.website_session_id) * 100 AS session_to_ordr_cvr
FROM
    website_sessions ws
        LEFT JOIN
    orders O ON ws.website_session_id = O.website_session_id
WHERE
    ws.created_at < '2012-05-11'
        AND ws.utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
GROUP BY device_type;


-- WEEKLY TRENDS TO ANALYZE THE CUSTOMER VOLUME FOR EACH DEVICE TYPE 

SELECT 
    WEEK(created_at) as week_no,
    COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN website_session_id ELSE NULL END) AS desktop_sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) AS mobile_sessions
FROM
    website_sessions ws
WHERE
    created_at < '2012-06-09'
    AND created_at > '2012-04-15'
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
GROUP BY 1;


-- 1. Finding pages with the most sessions
SELECT 
    PAGEVIEW_URL, COUNT(DISTINCT WEBSITE_SESSION_ID)
FROM
    WEBSITE_PAGEVIEWS
GROUP BY 1
ORDER BY 2 DESC;

-- Finding top entry pages

CREATE TEMPORARY TABLE FIRST_LANDER3
SELECT 
    WEBSITE_SESSION_ID, MIN(WEBSITE_PAGEVIEW_ID) AS MIN_PV_ID
FROM
    WEBSITE_PAGEVIEWS
WHERE WEBSITE_PAGEVIEW_ID < 5000
GROUP BY 1;

SELECT 
    WP.PAGEVIEW_URL, COUNT(DISTINCT FL.WEBSITE_SESSION_ID)
FROM
    WEBSITE_PAGEVIEWS WP
        LEFT JOIN
    FIRST_LANDER2 FL ON FL.MIN_PV_ID = WP.WEBSITE_PAGEVIEW_ID
GROUP BY 1
ORDER BY 2 DESC


