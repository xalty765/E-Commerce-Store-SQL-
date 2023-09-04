-- Analyzing Business patterns and seasonality

-- 1. Understanding Seasonality by pulling data from the previous year 
-- Looking at session and order volume of data at monthly and weekly level 

SELECT 
    YEAR(ws.created_at),
    MONTH(ws.created_at),
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders
FROM
    website_sessions ws
        LEFT JOIN
    orders o ON o.website_session_id = ws.website_session_id
WHERE
    ws.created_at < '2013-01-02'
GROUP BY 1 , 2
ORDER BY 3 DESC;

SELECT 
    WEEK(ws.created_at),
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders
FROM
    website_sessions ws
        LEFT JOIN
    orders o ON o.website_session_id = ws.website_session_id
WHERE
    ws.created_at < '2013-01-02'
GROUP BY 1 
ORDER BY 3 DESC;

-- 2. Finding the average session by hour of  day and day week to proceed further with the business idea of adding customer support staff

WITH CTE AS (
SELECT DATE(created_at),
weekday(created_at) as wkd,
HOUR(created_at) as hr,
COUNT(DISTINCT website_session_id) as website_sessions
from website_sessions
where created_at between '2012-09-15'
and created_at < '2012-11-15'
group by 1,2,3)

SELECT hr,
ROUND(AVG(CASE WHEN wkd = 0 THEN  website_sessions ELSE NULL END),1) AS 'Monday',
ROUND(AVG(CASE WHEN wkd = 1 THEN  website_sessions ELSE NULL END),1) AS 'Tuesday', 
ROUND(AVG(CASE WHEN wkd= 2 THEN  website_sessions ELSE NULL END),1) AS 'Wednesday', 
ROUND(AVG(CASE WHEN wkd= 3 THEN  website_sessions ELSE NULL END),1) AS 'Thursday',
ROUND(AVG(CASE WHEN wkd = 4 THEN  website_sessions ELSE NULL END),1) AS 'Friday' ,
ROUND(AVG(CASE WHEN wkd= 5 THEN  website_sessions ELSE NULL END),1 )AS 'Saturday', 
ROUND(AVG(CASE WHEN wkd = 6 THEN  website_sessions ELSE NULL END),1) AS 'Sunday'
FROM CTE 
group by 1
order by 1


