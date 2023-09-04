CREATE SCHEMA Ecom;

USE Ecom;

CREATE TABLE order_items(
order_item_id BIGINT NOT NULL AUTO_INCREMENT ,
created_at DATETIME NOT NULL,
order_id BIGINT NOT NULL,
price_usd DECIMAL(10,2) NOT NULL,
cogs_usd DECIMAL(10,2),
website_session_id BIGINT NOT NULL,
PRIMARY KEY(order_item_id)
);

CREATE TABLE order_item_refund(
order_item_refund_id BIGINT NOT NULL AUTO_INCREMENT,
created_at DATETIME NOT NULL,
order_item_id BIGINT NOT NULL,
order_id BIGINT NOT NULL,
refund_amount_usd DECIMAL(10,2) NOT NULL,
PRIMARY KEY(order_item_refund_id),
FOREIGN KEY(order_item_id) REFERENCES order_items(order_item_id)
);

DELETE FROM ORDER_ITEM_REFUND
WHERE ORDER_ITEM_REFUND_ID BETWEEN 6 AND 10;

CREATE TABLE products(
product_id BIGINT NOT NULL,
created_at DATETIME NOT NULL,
product_name VARCHAR(120) NOT NULL,
PRIMARY KEY(product_id)
);

INSERT  INTO products value
(1,'2013-03-19 09:00:00','The Original Mr.Fuzzy'),
(2,'2013-01-06 13:00:00','The Forever Love Bear');

SELECT 
    *
FROM
    order_items;
    
ALTER TABLE order_items
ADD COLUMN product_id BIGINT NOT NULL;

UPDATE order_items
Set product_id =1
where order_item_id > 0;


ALTER TABLE order_items 
ADD FOREIGN KEY (product_id)
REFERENCES products(product_id);

ALTER TABLE order_items
ADD COLUMN is_primary_item INT;


UPDATE order_items
SET is_primary_item =1
WHERE order_item_id >0;

SELECT 
    *
FROM
    products;

INSERT INTO products VALUES
(3,'2013-12-12 09:00:00', 'The Birthday Sugar Panda'),
(4,'2014-2-5 10:00:00', 'The Hudson River mini Bear');

CREATE TRIGGER purchaseUpdateInventory
AFTER INSERT ON customer_purchases
FOR EACH ROW 
Update inventory
set number_in_stock = number_in_stock-1
where inventory_id = new.inventory_id;

CREATE trigger purchaseupdatesummary
before insert 
on customer_purchases
for each row
update purchase_summary 
set purchaes_excluding_last = count(customer_purchase_id)
where customer_id = new.customer_id;


CREATE TABLE orders (
order_id  BIGINT NOT NULL,
created_at DATETIME NOT NULL,
website_session_id BIGINT NOT NULL,
primary_product_id BIGINT NOT NULL ,
items_purchased BIGINT NOT NULL,
price_usd DECIMAL(6,2)NOT NULL,
cogs_usd DECIMAL(6,2) NOT NULL,
PRIMARY KEY(order_id)
);


INSERT INTO  orders
SELECT 
order_id,
MIN(created_at) as created_at,
MIN(website_session_id) AS website_session_id,
SUM(CASE WHEN is_primary_item =1 then product_id else null end)
as primary_product_id,
COUNT(order_item_id) as items_purchased,
SUM(price_usd)  as price_usd,
SUM(cogs_usd) as cogs_usd
FROM order_items
GROUP BY 1
ORDER BY 1;

CREATE 
    TRIGGER  order_item_update
 AFTER INSERT ON order_items FOR EACH ROW 
    REPLACE INTO orders SELECT order_id,
        MIN(created_at) AS created_at,
        MIN(website_session_id) AS website_session_id,
        SUM(CASE
            WHEN is_primary_item = 1 THEN product_id
            ELSE NULL
        END) AS primary_product_id,
        COUNT(order_item_id) AS items_purchased,
        SUM(price_usd) AS price_usd,
        SUM(cogs_usd) AS cogs_usd FROM
        order_items
    WHERE
        ORDER_ID = NEW.ORDER_ID
    GROUP BY 1
    ORDER BY 1;

CREATE VIEW SURVEY AS 
SELECT country,
avg(case when is_manager ='Yes' then 1 else 0 end ) as pct,
avg(case when education_level ='Yes' then 1 else 0 end) as pc,
Count(*)
FROM salary_survey
group by 1
order by 4;


CREATE TABLE website_sessions(
website_session_id BIGINT NOT NULL,
created_at DATETIME NOT NULL,
user_id BIGINT NOT NULL,
is_repeat_session INT,
utm_source VARCHAR (50),
utm_campaign VARCHAR(50),
utm_content VARCHAR (50),
device_type VARCHAR(25) NOT NULL,
http_referer VARCHAR(100) NOT NULL,
PRIMARY KEY(website_session_id)
);

CREATE VIEW website_session_summary AS
    SELECT 
        YEAR(created_at) AS years,
        MONTH(created_at) AS months,
        utm_source,
        utm_campaign,
        COUNT(DISTINCT website_session_id) AS number_of_sessions
    FROM
        website_sessions_id
    GROUP BY 1 , 2 , 3 , 4
    ORDER BY 2;

CREATE TABLE website_pageviews (
    website_pageview_id BIGINT,
    created_at DATETIME,
    website_session_id BIGINT,
    pageview_url VARCHAR(100),
    PRIMARY KEY (website_pageview_id),
    FOREIGN KEY (website_session_id)
        REFERENCES website_sessions (website_session_id)
);


