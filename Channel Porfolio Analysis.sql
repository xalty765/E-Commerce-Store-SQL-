-- Analyzing Chanel portfolio

SELECT 
    utm_content,
    COUNT(DISTINCT ws.website_session_id),
    COUNT(DISTINCT O.order_id)
FROM
    website_sessions ws
        LEFT JOIN
    orders O ON O.website_session_id = ws.website_session_id
GROUP BY utm_content;


-- Analyzing Chanel Portfolios
SELECT 
    WEEK(created_at),
    COUNT(DISTINCT CASE
            WHEN utm_source = 'gsearch' THEN website_session_id
            ELSE NULL
        END) AS gsearch_sessions,
    COUNT(DISTINCT CASE
            WHEN utm_source = 'bsearch' THEN website_session_id
            ELSE NULL
        END) AS bsearch_sessions
FROM
    website_sessions
WHERE
    CREATED_AT > '2012-08-22'
        AND created_at < '2012-11-29'
        AND utm_campaign = 'nonbrand'
GROUP BY 1;

-- 2. Comparing Chanel Characteristics

SELECT 
    utm_source,
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE
            WHEN device_type = 'mobile' THEN website_session_id
            ELSE NULL
        END) AS mobile_sessions,
    COUNT(DISTINCT CASE
            WHEN device_type = 'mobile' THEN website_session_id
            ELSE NULL
        END) / COUNT(DISTINCT website_session_id) AS pct_mobile
FROM
    website_sessions
WHERE
    created_at > '2012-08-22'
        AND created_at < '2012-11-30'
        AND utm_campaign = 'nonbrand'
GROUP BY utm_source;

-- Cross Channel Bid Optimization

SELECT 
    ws.device_type,
    ws.utm_source,
    COUNT(DISTINCT WS.WEBSITE_SESSION_ID) AS sessions,
    COUNT(DISTINCT O.ORDER_ID) AS orders,
    COUNT(DISTINCT O.ORDER_ID) / COUNT(DISTINCT WS.WEBSITE_SESSION_ID) AS conversion_rate
FROM
    website_sessions ws
        LEFT JOIN
    orders o ON ws.website_session_id = o.website_session_id
WHERE
    utm_campaign = 'nonbrand'
        AND ws.created_at > '2012-08-22'
        AND ws.created_at < '2012-09-18'
GROUP BY 1 , 2;

-- Analyzing Chanel Portfolio Trends

SELECT 
    WEEK(created_at),
    COUNT(DISTINCT CASE WHEN utm_source='gsearch' AND device_type = 'desktop' THEN website_session_id ELSE NULL END),
	COUNT(DISTINCT CASE WHEN utm_source='bsearch' AND device_type = 'desktop' THEN website_session_id ELSE NULL END),
    COUNT(DISTINCT CASE WHEN utm_source='gsearch' AND device_type = 'mobile' THEN website_session_id ELSE NULL END),
	COUNT(DISTINCT CASE WHEN utm_source='bsearch' AND device_type = 'mobile' THEN website_session_id ELSE NULL END)
FROM
    website_sessions 
WHERE utm_campaign = 'nonbrand'
AND created_at > '2012-11-04'
AND created_at < '2012-12-22'
GROUP BY 1;
